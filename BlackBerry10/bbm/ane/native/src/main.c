#include "FlashRuntimeExtensions.h"

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <math.h>
#include <string.h>
#include <pthread.h>
#include <bbmsp/bbmsp_events.h>
#include <bbmsp/bbmsp.h>
#include <bbmsp/bbmsp_context.h>
#include <bbmsp/bbmsp_userprofile.h>

#include <bbmsp/bbmsp_messaging.h>

#include <bbmsp/bbmsp_util.h>
#include <bps/bps.h>
#include <bps/event.h>
#include <assert.h>


#include "aneutils.h"






#include "contacts.h"
#include "userprofile.h"
#include "userprofilebox.h"
#include "global.h"


void ContextInitializer(void* extData, const uint8_t* ctxType,FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet);
void extensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet);
void extensionFinalizer(void* extData);
void ContextFinalizer(FREContext ctx);


// UUID of the app. Passed in on calls to register.
const char *uuid = NULL;


static void
complete_thread_event(bps_event_t *event)
{
    bps_event_payload_t *payload = bps_event_get_payload(event);
    thread_payload_t* thread_payload = (thread_payload_t*)payload->data1;
    free(thread_payload);

    bps_event_destroy(event);
}

static bps_event_t *
create_thread_event(const thread_payload_t *thread_payload, int code)
{
    thread_payload_t *copy_payload;
    copy_payload = (thread_payload_t*)malloc(sizeof(*copy_payload));
    memcpy(copy_payload, thread_payload, sizeof(*copy_payload));

    bps_event_payload_t payload;
    payload.data1 = (uintptr_t)copy_payload;

    bps_event_t *event;
    bps_event_create(&event, thread_payload->domain_id, code, &payload, &complete_thread_event);

    return event;
}

static void
connect_thread(thread_payload_t *thread_data)
{
    bps_event_t *event;
    bps_get_event(&event, -1);
    assert(event);
    assert(bps_event_get_code(event) == MASTER_CONNECT);

    thread_payload_t *thread_payload;
    bps_event_payload_t *payload = bps_event_get_payload(event);
    thread_payload = (thread_payload_t*)payload->data1;

    memcpy(thread_data, thread_payload, sizeof(*thread_data));

    // push back as an 'ack'
    bps_channel_push_event(thread_data->channel_id, event);

}


/**
 * Attempts to register the app with bbm.
 */
void register_bbm()
{
	bbmsp_result_t register_result = BBMSP_FAILURE;


	//Only register if the UUID is not null.
	if( uuid != NULL )
	{
		register_result = bbmsp_register(uuid);
		trace( "bbmsp_register() %i", register_result );
	}


	if( register_result == BBMSP_ASYNC)
	{
		trace( "bbm registration started" );
		FREDispatchStatusEventAsync(context, (const uint8_t *)"registration", (const uint8_t *)"access_pending");
	}
	else if( register_result == BBMSP_SUCCESS )
	{
		trace( "bbm registration success" );
		FREDispatchStatusEventAsync(context, (const uint8_t *)"registration", (const uint8_t *)"access_allowed");
	}
	else
	{
		trace( "bbm registration failed");
		FREDispatchStatusEventAsync(context, (const uint8_t *)"registration", (const uint8_t *)"access_unregistered");
	}
}

/**
 * Called when a registration event is received.
 */
void handle_register_event( bbmsp_event_t* bbmsp_event, int event_type )
{
	trace( "Processing a BBMSP registration event" );
	if( event_type == BBMSP_SP_EVENT_ACCESS_CHANGED )
	{
		bbmsp_access_error_codes_t code = bbmsp_event_access_changed_get_access_error_code(bbmsp_event);
		trace( "registration event code %i", code );

		if( code == BBMSP_ACCESS_UNREGISTERED )
		{
			register_bbm();
		}
		else if( code == BBMSP_ACCESS_ALLOWED )
		{
			//We have registered and have access.
			//Dispatch event to ActionScript.
			FREDispatchStatusEventAsync(context, (const uint8_t *)"registration", (const uint8_t *)"access_allowed");
		}
	}
}

/**
 * Thread that handles events coming from BBMSP library.
 */
static void* threadMethod(void* p)
{
	int main_channel = (int)p;

	bps_initialize();

    thread_payload_t thread_payload;
    thread_payload.channel_id = bps_channel_get_active();
    thread_payload.domain_id = bps_register_domain();
    thread_payload.output[0] = '\0';

    bps_event_t *event = create_thread_event(&thread_payload, MASTER_CONNECT);

    bps_channel_push_event(main_channel, event);

    bps_get_event(&event, -1);
    assert(event);
    assert(bps_event_get_code(event) == MASTER_CONNECT);

    if (bbmsp_request_events(0) == BBMSP_FAILURE)
    {
    	trace( "bbmsp_request_events failure" );
    	FREDispatchStatusEventAsync(context, ( uint8_t* )"registration", (const uint8_t*)"denied");
    }
	int success;

	while( true )
	{

		bps_get_event(&event, -1);

		trace( "got event" );

		int domain = bps_event_get_domain(event);
		int code = bps_event_get_code(event);

		if( domain == masterDomain )
		{
			//We have received an event from the main thread.
			if( code == MASTER_REGISTER )
			{

				bbmsp_access_error_codes_t status = bbmsp_get_access_code();
				trace( "status %i", status );
				if( status == BBMSP_ACCESS_UNREGISTERED )
				{
					register_bbm();
				}
			}

		}
		else if( domain == bbmsp_get_domain())
		{
			trace( "bbm event" );
			//We got a bbm event.
			int event_category = 0;
			int event_type = 0;
			bbmsp_event_t* bbmsp_event = NULL;
			bbmsp_event_get_category(event, &event_category);
			bbmsp_event_get_type(event, &event_type);
			bbmsp_event_get(event, &bbmsp_event);

			trace( "Received a BBMSP event: category=%d, type=%d", event_category, event_type);
			// Process registration events only.
			if (event_category == BBMSP_REGISTRATION )
			{
				handle_register_event( bbmsp_event, event_type );
				continue;
			}
			else if( event_category == BBMSP_CONTACT_LIST )
			{
				handle_contact_event( bbmsp_event, event_type );
				continue;
			}
			else if( event_category == BBMSP_USER_PROFILE )
			{
				handle_user_profile_event( bbmsp_event, event_type );
				continue;
			}
			else if( event_category == BBMSP_USER_PROFILE_BOX )
			{
				handle_user_profile_box_event( bbmsp_event, event_type );
				continue;
			}
			trace( "Received an event which is not handled" );
		}
	}
	return NULL;
}

/**
 * Called from ActionScript to register the application with the BBMSP library.
 */
FREObject registerApplication(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{

	//first argument is the uuid of the application.
	const char *id;
	getString( argv[0], &id );

	uuid = strdup( id );

	//Send the event to the tread to do the actual registering.
	bps_event_t *event;
	bps_event_payload_t payload;
	payload.data1 = (uintptr_t)uuid;

	bps_event_create( &event, masterDomain, MASTER_REGISTER, &payload, NULL );
	bps_channel_push_event( threadChannel, event );

	return NULL;
}

/**
 * Called from ActionScript.
 * Sets the storage path where profile images, and profile box item icons are saved.
 */
FREObject setStoragePath(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	const char* path;
	getString( argv[ 0 ], &path );

	avatarPath = strdup( path );

	return NULL;
}

/**
 * Called from ActionScript to see if a BBM Invite can be sent.
 **/
FREObject canSendBBMInvite(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	FREObject result;

	FRENewObjectFromInt32( (int32_t)bbmsp_can_send_bbm_invite(), &result);

	return result;
}

/**
 * Called from ActionScript to see if the profile box can be shown.
 **/
FREObject canShowProfileBox(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	FREObject result;

	FRENewObjectFromInt32( (int32_t)bbmsp_can_show_profile_box(), &result);

	return result;
}

/**
 * Called from ActionScript to see if access is allowed.
 **/
FREObject accessAllowed(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	FREObject result;

	FRENewObjectFromInt32( (int32_t)bbmsp_is_access_allowed(), &result);

	return result;
}

/**
 * Called from ActionScript to send a download invitation.
 **/
FREObject sendDownloadInvitation(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	FREObject result;

	int value = bbmsp_send_download_invitation();


	if( value == BBMSP_SUCCESS )
	{
		FRENewObjectFromInt32( (int32_t)1, &result);
	}
	else
	{
		FRENewObjectFromInt32( (int32_t)0, &result);
	}

	return result;
}

/**
 * Called from ActionScript to get the BBMSP library version.
 **/
FREObject getVersion(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	FREObject result;
	int value = bbmsp_get_version();
	FRENewObjectFromInt32( (int32_t)value, &result);
	return result;
}



void ContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet)
{

	context = ctx;

	static FRENamedFunction s_classMethods[] =
	{
		{(const uint8_t *)"getVersion", NULL, getVersion},
		{(const uint8_t *)"registerApplication", NULL, registerApplication},
		{(const uint8_t *)"getAddedContact", NULL, getAddedContact},
		{(const uint8_t *)"getContactList", NULL, getContactList},
		{(const uint8_t *)"setStoragePath", NULL, setStoragePath},
		{(const uint8_t *)"getUpdatedContactProperties", NULL, getUpdatedContactProperties},
		{(const uint8_t *)"getUserProfile", NULL, getUserProfile},
		{(const uint8_t *)"getUserProfileStatus", NULL, getUserProfileStatus},
		{(const uint8_t *)"setUserProfileStatus", NULL, setUserProfileStatus},
		{(const uint8_t *)"setUserProfileMessage", NULL, setUserProfileMessage},
		{(const uint8_t *)"setUserProfilePicture", NULL, setUserProfilePicture},
		{(const uint8_t *)"canSendBBMInvite", NULL, canSendBBMInvite},
		{(const uint8_t *)"canShowProfileBox", NULL, canShowProfileBox},
		{(const uint8_t *)"accessAllowed", NULL, accessAllowed},
		{(const uint8_t *)"sendDownloadInvitation", NULL, sendDownloadInvitation},


		{(const uint8_t *)"registerIcon", NULL, registerIcon},
		{(const uint8_t *)"getProfileBoxItems", NULL, getProfileBoxItems},
		{(const uint8_t *)"addProfileBoxItem", NULL, addProfileBoxItem},
		{(const uint8_t *)"removeProfileBoxItem", NULL, removeProfileBoxItem},
		{(const uint8_t *)"removeAllProfileBoxItems", NULL, removeAllProfileBoxItems},
		{(const uint8_t *)"getAddedProfileBoxItem", NULL, getAddedProfileBoxItem},
		{(const uint8_t *)"getProfileBoxItemIcon", NULL, getProfileBoxItemIcon},
	};

	const int c_methodCount = sizeof(s_classMethods) / sizeof(FRENamedFunction);

	// Update caller with the required data
	*functionsToSet = s_classMethods;
	*numFunctionsToSet = c_methodCount;
}

// Initialization function of each extension
void extensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
	int success = bps_initialize();

	masterDomain = bps_register_domain();

	*extDataToSet = NULL;
	*ctxInitializerToSet = &ContextInitializer;
	*ctxFinalizerToSet = &ContextFinalizer;
	pthread_mutex_init(&amutex, NULL);
	pthread_cond_init( &acond, NULL );


	pthread_create(NULL, NULL, threadMethod, (void *)bps_channel_get_active());

	thread_payload_t payload;
	connect_thread( &payload );

	threadDomain = payload.domain_id;
	threadChannel = payload.channel_id;
}




// Called when extension is unloaded
void extensionFinalizer(void* extData)
{
	bps_shutdown();
	return;
}

void ContextFinalizer(FREContext ctx) {
	return;
}

