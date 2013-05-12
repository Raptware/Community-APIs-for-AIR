#include "contacts.h"
#include <bbmsp/bbmsp_events.h>

/**
 * Simple wrapper for the various bbm contact property getters.
 */
bbmsp_result_t contact_get_property( bbmsp_contact_t* contact, char **value, bbmsp_result_t (*func)(const bbmsp_contact_t*, char*, size_t), size_t max_size )
{
	bbmsp_result_t result = BBMSP_FAILURE;

	*value = malloc( max_size );
	result = func( contact, *value, max_size );

	return( result );
}



/**
 * Creates a ActionScript net.rim.bbm.BBMContact instance from the supplied native contact.
 */
FREObject createActionScriptContact( const bbmsp_contact_t* contact )
{
	FREObject contact_AS = NULL;

	const int cNumAttributes = 7;
	FREObject resultAttributes[cNumAttributes];

	bbmsp_result_t result;

	char ppid[BBMSP_CONTACT_PPID_MAX];
	result = bbmsp_contact_get_ppid( contact, ppid, BBMSP_CONTACT_PPID_MAX );

	if( result == BBMSP_SUCCESS )
	{
		FRENewObjectFromUTF8((uint32_t)(strlen(ppid) + 1), (uint8_t*)ppid, &resultAttributes[0]);
	}
	else
	{
		trace( "createActionScriptContact ppid %i", result );
	}


	char displayName[BBMSP_CONTACT_DISPLAY_NAME_MAX];
	result = bbmsp_contact_get_display_name( contact, displayName, BBMSP_CONTACT_DISPLAY_NAME_MAX );
	if( result == BBMSP_SUCCESS )
	{
		FRENewObjectFromUTF8((uint32_t)(strlen(displayName) + 1), (uint8_t*)displayName, &resultAttributes[1]);
	}
	else
	{
		trace( "createActionScriptContact displayName %i", result );
	}


	char personalMessage[BBMSP_CONTACT_PERSONAL_MSG_MAX];
	result = bbmsp_contact_get_personal_message( contact, personalMessage, BBMSP_CONTACT_PERSONAL_MSG_MAX );
	if( result == BBMSP_SUCCESS )
	{
		FRENewObjectFromUTF8((uint32_t)(strlen(personalMessage) + 1), (uint8_t*)personalMessage, &resultAttributes[2]);
	}
	else
	{
		trace( "createActionScriptContact personalMessage %i", result );
	}

	char statusMessage[BBMSP_CONTACT_STATUS_MSG_MAX];
	result = bbmsp_contact_get_status_message( contact, statusMessage, BBMSP_CONTACT_STATUS_MSG_MAX );
	if( result == BBMSP_SUCCESS )
	{
		FRENewObjectFromUTF8((uint32_t)(strlen(statusMessage) + 1), (uint8_t*)statusMessage, &resultAttributes[3]);
	}
	else
	{
		trace( "createActionScriptContact statusMessage %i", result );
	}

	char appVersion[BBMSP_CONTACT_APP_VERSION_MAX];
	result = bbmsp_contact_get_app_version( contact, appVersion, BBMSP_CONTACT_APP_VERSION_MAX );
	if( result == BBMSP_SUCCESS )
	{
		FRENewObjectFromUTF8((uint32_t)(strlen(appVersion) + 1), (uint8_t*)appVersion, &resultAttributes[4]);
	}
	else
	{
		trace( "createActionScriptContact appVersion %i", result );
	}

	bbmsp_presence_status_t status;
	result = bbmsp_contact_get_status( contact, &status );
	if( result == BBMSP_SUCCESS )
	{
		FRENewObjectFromInt32( (int32_t)status, &resultAttributes[5]);
	}
	else
	{
		trace( "createActionScriptContact status %i", result );
	}


	bbmsp_image_t* m_contact_avatar;
	bbmsp_image_create_empty(&m_contact_avatar);

	result = bbmsp_contact_get_display_picture( contact, m_contact_avatar );
	trace( "%i picture", result );

	if( result == BBMSP_SUCCESS )
	{
		char path[PATH_MAX];
		getAvatarPath( m_contact_avatar, ppid, path );
		FRENewObjectFromUTF8((uint32_t)(strlen(path) + 1), (uint8_t*)path, &resultAttributes[6]);
	}
	else
	{
		resultAttributes[5] = NULL;
	}

	bbmsp_image_destroy( &m_contact_avatar );

	FRENewObject((const uint8_t*) "Array", cNumAttributes, resultAttributes, &contact_AS, NULL);

	return( contact_AS );
}

/**
 * Called by ActionScript after it receives an event when a contact has been updated.
 * This method returns an array of the properties that have been updated for each contact.
 */
FREObject getUpdatedContactProperties(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	pthread_mutex_lock(&amutex);
	FREObject result = NULL;
	FRENewObject((const uint8_t*) "Array", 0, NULL, &result, NULL);

	trace( "getUpdatedContactProperties" );

	int i = 0;

	for( i = 0; i<update_size; i++ )
	{
		ContactUpdate contactUpdate = contact_updates[ i ];

		FREObject update;
		FRENewObject((const uint8_t*) "Object", 0, NULL, &update, NULL);

		if( contactUpdate.value != NULL )
		{
			FREObject value;
			FRENewObjectFromUTF8( (uint32_t)(strlen(contactUpdate.value) + 1), (const uint8_t*)contactUpdate.value, &value );
			FRESetObjectProperty( update, (const uint8_t*) "value", value, NULL );
		}

		FREObject ppid;
		FRENewObjectFromUTF8( (uint32_t)(strlen(contactUpdate.ppid) + 1), (const uint8_t*)contactUpdate.ppid, &ppid );
		FRESetObjectProperty( update, (const uint8_t*) "ppid", ppid, NULL );

		FREObject property;
		FRENewObjectFromInt32( (int32_t)contactUpdate.property, &property );
		FRESetObjectProperty( update, (const uint8_t*) "property", property, NULL );

		FREObject status;
		FRENewObjectFromInt32( (int32_t)contactUpdate.status, &status );
		FRESetObjectProperty( update, (const uint8_t*) "status", status, NULL );

		FRESetArrayElementAt( result, i, update );

		free( contactUpdate.value );
		free( contactUpdate.ppid );

	}

	update_size = 0;
	pthread_mutex_unlock(&amutex);
	return result;
}

/**
 * Called from ActionScript to get the current contact list after a BBMSP_SP_EVENT_CONTACT_LIST_FULL event was received.
 *
 */
FREObject getContactList(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	FREObject contacts;

	FREResult asresult;

	asresult = FRENewObject((const uint8_t*) "Array", 0, NULL, &contacts, NULL);
	trace( "FRENewObject - Array %i", asresult );
	int i=0;

	for( i = 0; i<contact_size; i++ )
	{
		FREObject contact = createActionScriptContact( (bbmsp_contact_t* )contact_list[ i ] );
		asresult = FRESetArrayElementAt( contacts, i, contact );
		trace( "FRESetArrayElementAt index %i %i ", i, asresult );
	}

	pthread_mutex_lock( &amutex );
	contactsCreated = true;
	pthread_cond_signal( &acond );
	pthread_mutex_unlock( &amutex );


	return contacts;
}

/**
 * Called from ActionScript when an event is received notifying it of a new contact.
 */
FREObject getAddedContact(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	FREObject contact = createActionScriptContact( (bbmsp_contact_t* )contactToAdd );

	pthread_mutex_lock( &amutex );
	contactAdded = true;
	pthread_cond_signal( &acond );
	pthread_mutex_unlock( &amutex );

	return contact;
}

/**
 * Writes the profile image of a contact to disk so ActionScript can load it when needed.
 */
bbmsp_result_t saveContactAvatar( bbmsp_contact_t* contact, char *path )
{
	bbmsp_result_t result;
	char *ppid;
	result = contact_get_property( contact, &ppid, bbmsp_contact_get_ppid, BBMSP_CONTACT_PPID_MAX );

	if( result == BBMSP_SUCCESS )
	{

		bbmsp_image_t* m_contact_avatar;
		bbmsp_image_create_empty( &m_contact_avatar );
		result = bbmsp_contact_get_display_picture( contact, m_contact_avatar );

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


void addContactUpdate( bbmsp_contact_t* contact, bbmsp_presence_update_types_t updateType )
{
	bbmsp_result_t result = BBMSP_FAILURE;
	ContactUpdate update;
	update.value = NULL;
	update.property = updateType;
	result = contact_get_property( contact, &update.ppid, bbmsp_contact_get_ppid, BBMSP_CONTACT_PPID_MAX );
	result = bbmsp_contact_get_status( contact, &update.status );

	switch (updateType)
	{
		case BBMSP_DISPLAY_NAME:
			result = contact_get_property( contact, &update.value, bbmsp_contact_get_display_name, BBMSP_CONTACT_DISPLAY_NAME_MAX );
			break;
		case BBMSP_DISPLAY_PICTURE:
			trace( "update display picture" );
			char path[PATH_MAX];
			saveContactAvatar( contact, path );
			trace( "saving file to %s", path );
			update.value = strdup( path );
			break;
		case BBMSP_PERSONAL_MESSAGE:
			result = contact_get_property( contact, &update.value, bbmsp_contact_get_personal_message, BBMSP_CONTACT_PERSONAL_MSG_MAX );
			break;
		case BBMSP_STATUS:
			result = contact_get_property( contact, &update.value, bbmsp_contact_get_status_message, BBMSP_CONTACT_STATUS_MSG_MAX );
			break;
	 }

	pthread_mutex_lock(&amutex);
	contact_updates[ update_size ] = update;
	update_size++;
	//TODO need to do realloc
	pthread_mutex_unlock(&amutex);
}

/**
 * Called when a new contact event is received from the BBMSP library.
 */
void handle_contact_event( bbmsp_event_t* bbmsp_event, int event_type )
{
	trace( "processing contact event" );
	bbmsp_result_t result = BBMSP_FAILURE;

	//Full contact list has been retrieved.
	if( event_type == BBMSP_SP_EVENT_CONTACT_LIST_FULL )
	{
		if( bbmsp_event_contact_list_register_event() == BBMSP_FAILURE )
		{
			trace( "bbmsp_event_contact_list_register_event() failure" );
		}

		//we got the entire contact list
		bbmsp_contact_list_t *list;
		result = bbmsp_event_contact_list_get_full_contact_list( bbmsp_event, &list );
		trace( "bbmsp_event_contact_list_get_full_contact_list %i", result );

		contact_size = bbmsp_contact_list_get_size( list );
		trace( "bbmsp_contact_list_get_size %i", contact_size );

		contact_list = (bbmsp_contact_t**) malloc(sizeof(bbmsp_contact_t*) *contact_size);
		result = bbmsp_contact_list_get_all_contacts( list, contact_list );

		trace( "bbmsp_contact_list_get_all_contacts %i", result );

		pthread_mutex_lock( &amutex );
		contactsCreated = false;

		//Dispatch event to ActionScript, which then calls getContactList() to retrieve the contact list.
		FREDispatchStatusEventAsync(context, (const uint8_t *)"contact", (const uint8_t *)"contact_list");

		while( !contactsCreated )
		{
			pthread_cond_wait( &acond, &amutex );
		}

		pthread_mutex_unlock( &amutex );

		free( contact_list );

	}
	else if( event_type == BBMSP_SP_EVENT_CONTACT_CHANGED )
	{
		//contact was changed

		bbmsp_contact_t* contact = 0;
		bbmsp_contact_create(&contact);
		result = bbmsp_event_contact_changed_get_contact(bbmsp_event, &contact);
		trace( "bbmsp_event_contact_changed_get_contact %i", result );

	    bbmsp_presence_update_types_t updateType;
	    if(bbmsp_event_contact_changed_get_presence_update_type(bbmsp_event, &updateType) == BBMSP_SUCCESS)
	    {
	    	trace( "updateType %i", updateType );

	    	if( updateType & BBMSP_INSTALL_APP  )
	    	{
	    		trace( "adding contact" );
				pthread_mutex_lock( &amutex );
				bbmsp_contact_create( &contactToAdd );
				bbmsp_contact_copy( contactToAdd, contact );
				contactAdded = false;

				//Dispatch event to ActionScript, which then calls getAddedContact() to get the added contact.
				FREDispatchStatusEventAsync(context, (const uint8_t *)"contact", (const uint8_t *)"contact_added");

				while( !contactAdded )
				{
					pthread_cond_wait( &acond, &amutex );
				}

				bbmsp_contact_destroy( &contactToAdd );

				pthread_mutex_unlock( &amutex );
	    	}

	    	if( updateType & BBMSP_DISPLAY_NAME  )
			{
				addContactUpdate( contact, BBMSP_DISPLAY_NAME );
				FREDispatchStatusEventAsync(context, ( uint8_t* )"contact", (const uint8_t*)"contact_update");
			}

			if( updateType & BBMSP_DISPLAY_PICTURE )
			{
				addContactUpdate( contact, BBMSP_DISPLAY_PICTURE );
				FREDispatchStatusEventAsync(context, ( uint8_t* )"contact", (const uint8_t*)"contact_update");
			}

			if( updateType & BBMSP_PERSONAL_MESSAGE )
			{
				addContactUpdate( contact, BBMSP_PERSONAL_MESSAGE );
				FREDispatchStatusEventAsync(context, ( uint8_t* )"contact", (const uint8_t*)"contact_update");
			}

			if( updateType & BBMSP_STATUS )
			{
				addContactUpdate( contact, BBMSP_STATUS );
				FREDispatchStatusEventAsync(context, ( uint8_t* )"contact", (const uint8_t*)"contact_update");
			}

			if( updateType & BBMSP_UNINSTALL_APP )
			{
				addContactUpdate( contact, BBMSP_UNINSTALL_APP );
				FREDispatchStatusEventAsync(context, ( uint8_t* )"contact", (const uint8_t*)"contact_update");
			}
	    }
	}
}
