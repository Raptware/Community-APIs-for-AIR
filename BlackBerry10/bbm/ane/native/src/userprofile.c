
#include "userprofile.h"

/**
 * Saves the users profile avatar to disk.
 */
bbmsp_result_t saveUserProfileAvatar( bbmsp_profile_t *profile, char *path )
{
	bbmsp_result_t result;
	char ppid[BBMSP_PROFILE_PPID_MAX];
	result = bbmsp_profile_get_ppid( profile, ppid, BBMSP_PROFILE_PPID_MAX );

	if( result == BBMSP_SUCCESS )
	{

		bbmsp_image_t* m_contact_avatar;
		bbmsp_image_create_empty( &m_contact_avatar );
		result = bbmsp_profile_get_display_picture( profile, m_contact_avatar );

		if( result == BBMSP_SUCCESS )
		{

			getAvatarPath( m_contact_avatar, ppid, path );
			saveFile( path, m_contact_avatar );
		}
		else
		{
			trace( "saveContactAvatar picture %i", result );
		}

		bbmsp_image_destroy( &m_contact_avatar );

	}
	else
	{
		trace( "saveContactAvatar ppid %i", result );
	}

	return( result );
}



/**
 * Creates a ActionScript net.rim.bbm.BBMUserProfile instance from the supplied native contact.
 */
FREObject createActionScriptUserProfile( bbmsp_profile_t *profile )
{
	FREObject contact_AS = NULL;

	const int cNumAttributes = 7;
	FREObject resultAttributes[cNumAttributes];

	bbmsp_result_t result;

	char ppid[BBMSP_PROFILE_PPID_MAX];
	result = bbmsp_profile_get_ppid( profile, ppid, BBMSP_PROFILE_PPID_MAX );

	trace( "PPID %s", ppid );


	if( result == BBMSP_SUCCESS )
	{
		FRENewObjectFromUTF8((uint32_t)(strlen(ppid) + 1), (uint8_t*)ppid, &resultAttributes[0]);
	}
	else
	{
		trace( "createActionScriptUserProfile ppid %i", result );
	}


	char displayName[BBMSP_PROFILE_DISPLAY_NAME_MAX];
	result = bbmsp_profile_get_display_name( profile, displayName, BBMSP_PROFILE_DISPLAY_NAME_MAX );
	if( result == BBMSP_SUCCESS )
	{
		FRENewObjectFromUTF8((uint32_t)(strlen(displayName) + 1), (uint8_t*)displayName, &resultAttributes[1]);
	}
	else
	{
		trace( "createActionScriptUserProfile displayName %i", result );
	}


	char personalMessage[BBMSP_PROFILE_PERSONAL_MSG_MAX];
	result = bbmsp_profile_get_personal_message( profile, personalMessage, BBMSP_PROFILE_PERSONAL_MSG_MAX );
	if( result == BBMSP_SUCCESS )
	{
		FRENewObjectFromUTF8((uint32_t)(strlen(personalMessage) + 1), (uint8_t*)personalMessage, &resultAttributes[2]);
	}
	else
	{
		trace( "createActionScriptUserProfile personalMessage %i", result );
	}

	char statusMessage[BBMSP_PROFILE_STATUS_MSG_MAX];
	result = bbmsp_profile_get_status_message( profile, statusMessage, BBMSP_PROFILE_STATUS_MSG_MAX );
	if( result == BBMSP_SUCCESS )
	{
		FRENewObjectFromUTF8((uint32_t)(strlen(statusMessage) + 1), (uint8_t*)statusMessage, &resultAttributes[3]);
	}
	else
	{
		trace( "createActionScriptUserProfile statusMessage %i", result );
	}

	char appVersion[BBMSP_CONTACT_APP_VERSION_MAX];
	result = bbmsp_profile_get_app_version( profile, appVersion, BBMSP_CONTACT_APP_VERSION_MAX );
	if( result == BBMSP_SUCCESS )
	{
		FRENewObjectFromUTF8((uint32_t)(strlen(appVersion) + 1), (uint8_t*)appVersion, &resultAttributes[4]);
	}
	else
	{
		trace( "createActionScriptUserProfile appVersion %i", result );
	}


	bbmsp_presence_status_t status;
	result = bbmsp_profile_get_status( profile, &status );
	if( result == BBMSP_SUCCESS )
	{
		FRENewObjectFromInt32( (int32_t)status, &resultAttributes[5]);
	}
	else
	{
		trace( "createActionScriptUserProfile status %i", result );
	}

	bbmsp_image_t* m_contact_avatar;
	bbmsp_image_create_empty(&m_contact_avatar);

	result = bbmsp_profile_get_display_picture( profile, m_contact_avatar );
	trace( "%i picture", result );

	if( result == BBMSP_SUCCESS )
	{
		char path[PATH_MAX];
		saveUserProfileAvatar( profile, path );
		FRENewObjectFromUTF8((uint32_t)(strlen(path) + 1), (uint8_t*)path, &resultAttributes[6]);
	}
	else
	{
		resultAttributes[5] = NULL;
	}

	bbmsp_image_destroy( &m_contact_avatar );

	FREResult classresult = FRENewObject((const uint8_t*) "Array", cNumAttributes, resultAttributes, &contact_AS, NULL);

	return( contact_AS );
}


/**
 * Called from ActionScript to get the user's profile.
 */
FREObject getUserProfile(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	trace( "getUserProfile()");
	bbmsp_profile_t *profile = 0;
	bbmsp_profile_create( &profile );
	bbmsp_get_user_profile( profile );

	FREObject result = createActionScriptUserProfile( profile );

	bbmsp_profile_destroy( &profile );

	return result;
}

/**
 * Called from ActionScript to get the user's status.
 */
FREObject getUserProfileStatus(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	trace( "getUserProfileStatus()");
	bbmsp_profile_t *profile = 0;
	bbmsp_profile_create( &profile );
	bbmsp_get_user_profile( profile );

	FREObject value = NULL;
	bbmsp_presence_status_t status;
	bbmsp_result_t result = bbmsp_profile_get_status( profile, &status );
	if( result == BBMSP_SUCCESS )
	{
		FRENewObjectFromInt32( (int32_t)status, &value);
	}
	else
	{
		trace( "getUserProfileStatus status %i", result );
	}


	bbmsp_profile_destroy( &profile );

	return value;
}

/**
 * Called from ActionScript to set the user's status.
 */
FREObject setUserProfileStatus(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{

	FREObject result = NULL;

	const char *message;
	getString( argv[0], &message );

	int32_t status;
	FREGetObjectAsInt32( argv[1], &status );


	bbmsp_result_t value = bbmsp_set_user_profile_status( (bbmsp_presence_status_t)status, message);

	trace( "set user profile status %i", value );

	FRENewObjectFromInt32( (int32_t)value, &result );

	return( result );
}

/**
 * Called from ActionScript to set the user's profile message.
 */
FREObject setUserProfileMessage(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	FREObject result = NULL;

	const char *message;
	getString( argv[0], &message );

	bbmsp_result_t value = bbmsp_set_user_profile_personal_message( message );
	trace( "set user profile message %i", value );
	FRENewObjectFromInt32( (int32_t)value, &result );

	return( result );
}

/**
 * Called from ActionScript to set the users profile picture.
 */
FREObject setUserProfilePicture(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{

	FREByteArray byteArray;
	FREAcquireByteArray( argv[ 0 ], &byteArray );

	int32_t type;
	FREGetObjectAsInt32( argv[ 1 ], &type );


	bbmsp_image_t *bbmspImage;
	bbmspImage=0;
	bbmsp_image_create_empty(&bbmspImage);
	bbmsp_result_t rc;
	rc = bbmsp_image_create(&bbmspImage, (bbmsp_image_type_t)type, (const char*)byteArray.bytes, byteArray.length );

	if( rc == BBMSP_SUCCESS )
	{
		rc = bbmsp_set_user_profile_display_picture( bbmspImage );
	}

	FREReleaseByteArray( argv[ 0 ] );

	bbmsp_image_destroy( &bbmspImage );

	FREObject result = NULL;
	FRENewObjectFromInt32( (int32_t)rc, &result );

	return( result );
}

/**
 * Called when a user profile event is received.
 */
void handle_user_profile_event( bbmsp_event_t* bbmsp_event, int event_type )
{
	trace( "processing user profile event" );
	bbmsp_result_t result = BBMSP_FAILURE;
	if( event_type == BBMSP_SP_EVENT_PROFILE_CHANGED )
	{
		bbmsp_profile_t *profile;
		result = bbmsp_profile_create( &profile );
		result = bbmsp_event_profile_changed_get_profile( bbmsp_event, &profile );

		bbmsp_presence_update_types_t updateType;
		if( bbmsp_event_profile_changed_get_presence_update_type( bbmsp_event, &updateType ) == BBMSP_SUCCESS )
		{
			char *value = NULL;

			if( updateType & BBMSP_DISPLAY_NAME )
			{
				value = malloc( BBMSP_PROFILE_DISPLAY_NAME_MAX );
				bbmsp_profile_get_display_name( profile, value, BBMSP_PROFILE_DISPLAY_NAME_MAX );
				if( value != NULL )
				{
					FREDispatchStatusEventAsync(context, (const uint8_t*)"profile.displayname", (const uint8_t*)value);
					free( value );
					value = NULL;
				}
			}

			if( updateType & BBMSP_DISPLAY_PICTURE )
			{
				value = malloc( PATH_MAX );
				saveUserProfileAvatar( profile, value );

				if( value != NULL )
				{
					FREDispatchStatusEventAsync(context, (const uint8_t*)"profile.displaypicture", (const uint8_t*)value);
					free( value );
					value = NULL;
				}
			}

			if( updateType & BBMSP_PERSONAL_MESSAGE )
			{
				value = malloc( BBMSP_PROFILE_PERSONAL_MSG_MAX );
				bbmsp_profile_get_personal_message( profile, value, BBMSP_PROFILE_PERSONAL_MSG_MAX );
				if( value != NULL )
				{
					FREDispatchStatusEventAsync(context, (const uint8_t*)"profile.personalmessage", (const uint8_t*)value);
					free( value );
					value = NULL;
				}
			}


			if( updateType & BBMSP_STATUS )
			{
				value = malloc( BBMSP_PROFILE_STATUS_MSG_MAX );
				bbmsp_profile_get_status_message( profile, value, BBMSP_PROFILE_STATUS_MSG_MAX );
				if( value != NULL )
				{
					FREDispatchStatusEventAsync(context, (const uint8_t*)"profile.status", (const uint8_t*)value);
					free( value );
					value = NULL;
				}
			}
		}
	}
}
