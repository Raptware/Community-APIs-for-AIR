#include "userprofilebox.h"


/**
 * Called from ActionScript to register an icon.
 */
FREObject registerIcon(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{


	FREByteArray byteArray;
	FREAcquireByteArray( argv[ 0 ], &byteArray );

	int32_t type;
	FREGetObjectAsInt32( argv[ 1 ], &type );

	int32_t id;
	FREGetObjectAsInt32( argv[ 2 ], &id );

	trace( "registerIcon id %i type %i", id, type );


	bbmsp_image_t *bbmspImage;
	bbmspImage=0;
	bbmsp_image_create_empty(&bbmspImage);
	bbmsp_result_t rc;
	rc = bbmsp_image_create(&bbmspImage, (bbmsp_image_type_t)type, (const char*)byteArray.bytes, byteArray.length );

	trace( "create image %i", rc );

	if( rc == BBMSP_SUCCESS )
	{
		rc = bbmsp_user_profile_box_register_icon( id, bbmspImage );
		trace( "bbmsp_user_profile_box_register_icon %i", rc );
	}

	FREReleaseByteArray( argv[ 0 ] );
	bbmsp_image_destroy( &bbmspImage );

	FREObject result;
	FRENewObjectFromInt32( (int32_t)rc, &result );

	return( result );
}

/**
 * Creates a net.rim.bbm.BBMProfileBoxItem ActionScript object from the supplied bbmsp_user_profile_box_item_t so it can be returned to ActionScript.
 */
FREObject createActionScriptBoxItem( const bbmsp_user_profile_box_item_t *item )
{
	FREObject asObj = NULL;

	const int cNumAttributes = 4;
	FREObject resultAttributes[cNumAttributes];

	bbmsp_result_t result;

	char id[BBMSP_PROFILE_BOX_ITEM_ID_MAX];
	result = bbmsp_user_profile_box_item_get_item_id( item, id, BBMSP_PROFILE_BOX_ITEM_ID_MAX );
	if( result == BBMSP_SUCCESS )
	{
		FRENewObjectFromUTF8((uint32_t)(strlen(id) + 1), (uint8_t*)id, &resultAttributes[0]);
	}
	else
	{
		trace( "createActionScriptBoxItem id %i", result );
	}

	char text[BBMSP_PROFILE_BOX_ITEM_TEXT_MAX];
	result = bbmsp_user_profile_box_item_get_text( item, text, BBMSP_PROFILE_BOX_ITEM_TEXT_MAX );
	if( result == BBMSP_SUCCESS )
	{
		FRENewObjectFromUTF8((uint32_t)(strlen(text) + 1), (uint8_t*)text, &resultAttributes[1]);
	}
	else
	{
		trace( "createActionScriptBoxItem text %i", result );
	}

	char cookie[BBMSP_PROFILE_BOX_ITEM_COOKIE_MAX];
	result = bbmsp_user_profile_box_item_get_cookie( item, cookie, BBMSP_PROFILE_BOX_ITEM_COOKIE_MAX );
	if( result == BBMSP_SUCCESS )
	{
		FRENewObjectFromUTF8((uint32_t)(strlen(cookie) + 1), (uint8_t*)cookie, &resultAttributes[2]);
	}
	else
	{
		trace( "createActionScriptBoxItem cookie %i", result );
	}

	int32_t iconId = 0;
	result = bbmsp_user_profile_box_item_get_icon_id( item, &iconId );
	if( result == BBMSP_SUCCESS )
	{
		FRENewObjectFromInt32( iconId, &resultAttributes[3] );
	}
	else
	{
		trace( "createActionScriptBoxItem iconId %i", result );
	}

	FRENewObject((const uint8_t*) "Array", cNumAttributes, resultAttributes, &asObj, NULL);

	return( asObj );
}

/**
 * Called from ActionScript to get all of the profile box items.
 */
FREObject getProfileBoxItems(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	trace( "getProfileBoxItems()" );
	FREObject result = NULL;
	FRENewObject((const uint8_t*) "Array", 0, NULL, &result, NULL);

	bbmsp_user_profile_box_item_list_t *list = NULL;
	bbmsp_user_profile_box_item_list_create( &list );

	if( bbmsp_user_profile_box_get_items( list ) == BBMSP_SUCCESS )
	{
		int length = bbmsp_user_profile_box_items_size( list );
		int i = 0;
		trace( "box items size %i", length );
		for( i = 0; i<length; i++ )
		{
			const bbmsp_user_profile_box_item_t *item = bbmsp_user_profile_box_itemlist_get_at( list, i );
			FREObject obj = createActionScriptBoxItem( item );
			FRESetArrayElementAt( result, i, obj );
		}
	}

	return( result );
}

/**
 * Called from ActionScript to add a profile box item.
 */
FREObject addProfileBoxItem(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{

	FREObject result = NULL;

	bbmsp_result_t return_result = BBMSP_FAILURE;

	const char *text = NULL;
	getString( argv[0], &text );

	const char *cookie = NULL;
	getString( argv[ 1 ], &cookie );

	int32_t icon;
	FREGetObjectAsInt32( argv[2], &icon );

	trace( "addProfileBoxItem %s %s %i", text, cookie, icon );

	if( icon > 0 )
	{
		return_result = bbmsp_user_profile_box_add_item( text, icon, cookie );
		trace( "bbmsp_user_profile_box_add_item %i", return_result );
	}
	else
	{
		return_result = bbmsp_user_profile_box_add_item_no_icon( text, cookie );
		trace( "bbmsp_user_profile_box_add_item_no_icon %i", return_result );
	}

	FRENewObjectFromInt32( return_result, &result );
	return( result );
}

/**
 * Called from ActionScript to remove a profile box item.
 */
FREObject removeProfileBoxItem(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	FREObject result = NULL;

	bbmsp_result_t return_result = BBMSP_FAILURE;

	const char *id = NULL;
	getString( argv[0], &id );

	return_result = bbmsp_user_profile_box_remove_item( id );

	FRENewObjectFromInt32( return_result, &result );
	return( result );
}

/**
 * Called from ActionScript to remove all the profile box items.
 */
FREObject removeAllProfileBoxItems(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	FREObject result = NULL;

	bbmsp_result_t return_result = BBMSP_FAILURE;

	return_result = bbmsp_user_profile_box_remove_all_items();

	FRENewObjectFromInt32( return_result, &result );
	return( result );
}

/**
 * Called from ActionScript to get the newly added profile box item.
 */
FREObject getAddedProfileBoxItem(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	FREObject item = createActionScriptBoxItem( itemToAdd );

	pthread_mutex_lock( &amutex );
	itemAdded = true;
	pthread_cond_signal( &acond );
	pthread_mutex_unlock( &amutex );

	return item;
}

/**
 * Called from ActionScript to retrieve the profile box item's icon.
 * When retrieve a BBMSP_SP_EVENT_USER_PROFILE_BOX_ICON_RETRIEVED is received.
 */
FREObject getProfileBoxItemIcon(FREContext ctx, void* functionData, uint32_t argc, FREObject argv[])
{
	int32_t iconId;
	FREGetObjectAsInt32( argv[0], &iconId );
	bbmsp_result_t result;

	result = bbmsp_user_profile_box_retrieve_icon( iconId );

	FREObject return_result = NULL;
	FRENewObjectFromInt32( result, &return_result );

	return( return_result );
}

/**
 * Called when a user profile box event occurs.
 */
void handle_user_profile_box_event( bbmsp_event_t* bbmsp_event, int event_type )
{

	bbmsp_user_profile_box_item_t *item;
	bbmsp_result_t result = BBMSP_FAILURE;

	if( event_type == BBMSP_SP_EVENT_USER_PROFILE_BOX_ICON_ADDED )
	{
		trace( "profile box icon added" );
	}
	else if( event_type == BBMSP_SP_EVENT_USER_PROFILE_BOX_ITEM_ADDED )
	{
		trace( "profile box item added" );

		bbmsp_user_profile_box_item_create( &item );
		result = bbmsp_event_user_profile_box_item_added_get_item( bbmsp_event, item );

		bbmsp_user_profile_box_item_create( &itemToAdd );
		bbmsp_user_profile_box_item_copy( itemToAdd, item );

		pthread_mutex_lock( &amutex );
		itemAdded = false;

		//Dispatches event to ActionScript, which then calls getAddedProfileBoxItem() to get the newly added item.
		FREDispatchStatusEventAsync(context, (const uint8_t *)"profilebox", (const uint8_t *)"added");

		while( !itemAdded )
		{
			pthread_cond_wait( &acond, &amutex );
		}

		bbmsp_user_profile_box_item_destroy( &itemToAdd );

		pthread_mutex_unlock( &amutex );
	}
	else if( event_type == BBMSP_SP_EVENT_USER_PROFILE_BOX_ITEM_REMOVED )
	{
		trace( "profile box item removed" );
		bbmsp_user_profile_box_item_create( &item );
		bbmsp_event_user_profile_box_item_removed_get_item( bbmsp_event, item );
		char id[BBMSP_PROFILE_BOX_ITEM_ID_MAX];
		bbmsp_user_profile_box_item_get_item_id( item, id, BBMSP_PROFILE_BOX_ITEM_ID_MAX );
		FREDispatchStatusEventAsync(context, (const uint8_t *)"profilebox_removed", (const uint8_t *)id);

	}
	else if( event_type == BBMSP_SP_EVENT_USER_PROFILE_BOX_ICON_RETRIEVED )
	{
		trace( "profile box item icon retrieved.");
		bbmsp_image_t *image;
		bbmsp_image_create_empty( &image );

		int32_t iconid;
		result = bbmsp_event_user_profile_box_icon_retrieved_get_icon_id( bbmsp_event, &iconid );
		result = bbmsp_event_user_profile_box_icon_retrieved_get_icon_image( bbmsp_event, &image );

		char path[PATH_MAX];
		getIconPath( image,iconid, path	);


		saveFile( path, image );

		bbmsp_image_destroy( &image );
		//Dispatches event to ActionScript with the path to the icon.
		FREDispatchStatusEventAsync(context, (const uint8_t *)"profilebox_icon", (const uint8_t *)path);

	}
}
