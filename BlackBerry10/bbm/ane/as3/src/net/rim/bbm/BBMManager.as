package net.rim.bbm
{
	import net.rim.bbm.data.BBMContactsProvider;
	import net.rim.bbm.data.BBMProfileBoxItemProvider;
	import net.rim.events.BBMContactEvent;
	import net.rim.events.BBMRegisterEvent;
	import net.rim.events.BBMUserProfileEvent;

	import qnx.ui.data.IDataProvider;

	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;


	 
	/**
	 * Dispatched when the contact list is retrieved from the BBM Social Platform servers.
	 * @eventType net.rim.events.BBMContactEvent
	 */
	[Event(name="contact_list", type="net.rim.events.BBMContactEvent")]
	
	/**
	 * Dispatched when a contact is updated.
	 * @eventType net.rim.events.BBMContactEvent
	 */
	[Event(name="contact_update", type="net.rim.events.BBMContactEvent")]
	
	/**
	 * Dispatched when the application has successfully registered with the BBM Social Platform.
	 * @eventType net.rim.events.BBMRegisterEvent
	 */
	[Event(name="register_success", type="net.rim.events.BBMRegisterEvent")]
	
	/**
	 * Dispatched when the application is in the process of registering with the BBM Social Platform.
	 * @eventType net.rim.events.BBMRegisterEvent
	 */
	[Event(name="register_pending", type="net.rim.events.BBMRegisterEvent")]
	
	/**
	 * Dispatched when the application is not registered with the BBM Social Platform.
	 * @eventType net.rim.events.BBMRegisterEvent
	 */
	[Event(name="register_unregistered", type="net.rim.events.BBMRegisterEvent")]
	
	/**
	 * Dispatched when access to the BBM Social Platform is denied.
	 * <p>This is usually the result of the user turning off BBM in the application permissions.</p>
	 * @eventType net.rim.events.BBMRegisterEvent
	 */
	[Event(name="register_denied", type="net.rim.events.BBMRegisterEvent")]
	
	/**
	 * Dispatched when the user profile is updated.
	 * @eventType net.rim.events.BBMUserProfileEvent
	 */
	[Event(name="userProfileUpdate", type="net.rim.events.BBMUserProfileEvent")]
	
	/**
	 * The <code>BBMManager</code> class is used to interact with the BBM Social Platform.
	 * <p>
	 * For example, you can:
	 * <ul>
	 * <li>Invite BBM contacts to download your app by accessing a user's BBM contact list.</li>
	 * <li>Update a user's BBM personal message, status, and avatar.</li>
	 * <li>Add a customizable application box to a user's BBM profile to broadcast achievements or provide updates.</li>
	 * </ul>
	 * </p>
	 * <p>
	 * Applications wishing to use the <code>BBMManager</code> must ensure that their application includes the following permission in their bar-descriptor.xml file.
	 * <br>
	 * <b>&lt;permission&gt;bbm_connect&lt;/permission&gt;</b>
	 * </p>
	 * <p>
	 * Connecting to the BBM Social Platform starts with registering your app. 
	 * The BBM Social Platform APIs are not generally available for use until the app is registered. 
	 * Successful registration is indicated when <code>BBMRegisterEvent.SUCCESS</code> event is recieved.
	 * </p>
	 * @see #registerApplication()
	 */
	public class BBMManager extends EventDispatcher
	{
		
		private static var __instance:BBMManager;
		
		/**
		 * Returns the singelton instance of <code>BBMManager</code>
		 * @return The singleton instance of the class.
		 */
		public static function get bbmManager():BBMManager
		{
			if( __instance == null )
			{
				__instance = new BBMManager( new SingeltonEnforcer() );
			}
			
			return( __instance );
		}
		
		
		
		private var __context:ExtensionContext;
		private var __contacts:BBMContactsProvider = new BBMContactsProvider();
		private var __boxItems:BBMProfileBoxItemProvider;
		private var __userProfile:BBMUserProfile;
		
		private var __iconDir:File;

		
		/**
		 * Gets the version number of the BBM Social Platform.
		 * <p>
		 * Retrieves the version of the BBM Social Platform library that your application is using. 
		 * You can use the version number to check whether your application is compatible with this version of the BBM Social Platform.
		 * </p>
		 * @return The version number of the BBM Social Platform library in the format.
		 */
		public function get version():int
		{
			var result:int;
			
			/*FDT_IGNORE*/
			if(CONFIG::ANE)
			/*FDT_IGNORE*/ 
			{
				result = __context.call( "getVersion" ) as int;
			}
		
			return( result );
		}
		
		/**
		 * Returns a list of BBM contacts that have the application installed.
		 * <p>
		 * The <code>IDataProvider</code> list is populated with <code>BBMContact</code> objects.
		 * </p>
		 * <p>
		 * It is important that you do not modify this list in any way. The list of contacts is managed strictly by this class. 
		 * Modifiying the list could lead to potential issues.
		 * </p>
		 * @return A <code>IDataProvider</code> instance that can easily be set as a <code>dataProvider</code> for a <code>List</code> instance.
		 * @see BBMContacts
		 */
		public function get contacts():IDataProvider
		{
			return( __contacts );
		}
		
		/**
		 * Returns a list of user profile box items for the current user.
		 * <p>
		 * The <code>IDataProvider</code> list is populated with <code>BBMProfileBoxItem</code> objects.
		 * </p>
		 * <p>
		 * In order to access the users profile box items, the <code>canShowProfileBox()</code> method must return <code>true</code>.
		 * </p>
		 * <p>
		 * It is important that you do not modify this list in any way. The list of profile box items is managed strictly by this class. 
		 * Modifiying the list could lead to potential issues.
		 * </p>
		 * @return A <code>IDataProvider</code> instance that can easily be set as a <code>dataProvider</code> for a <code>List</code> instance.
		 * @see BBMProfileBoxItem
		 */
		public function get profileBoxItems():IDataProvider
		{
			if( __boxItems == null )
			{
				var arr:Array;
				
				/*FDT_IGNORE*/
				if(CONFIG::ANE)
				/*FDT_IGNORE*/ 
				{
					arr = __context.call( "getProfileBoxItems" ) as Array;
				}
				/*FDT_IGNORE*/
				else
				/*FDT_IGNORE*/
				{
					arr = [];
				}

				__boxItems = new BBMProfileBoxItemProvider();
				if( arr )
				{
					for( var i:int = 0; i<arr.length; i++ )
					{
						__boxItems.addItem( createBoxItemFromArray(arr[i]));
					}
				}
			}

			return( __boxItems );
		}
		
		/**
		 * Do not call directly.
		 * <p>
		 * Use the <code>BBMManager.bbmManager</code> property to return the singelton instance of this class.
		 * </p>
		 * @param enforcer The singleton enforcer to help prevent accidental instaniation of this class directly.
		 * @see #bbmManager
		 */
		public function BBMManager( enforcer:SingeltonEnforcer )
		{
			/*FDT_IGNORE*/
			if(CONFIG::ANE)
			/*FDT_IGNORE*/ 
			{
				init();
			}
		}
		
		private function init():void
		{
			__context = ExtensionContext.createExtensionContext( "net.rim.BBM", null );
			__context.addEventListener(StatusEvent.STATUS, statusEvent );
			
			var dir:File = File.applicationStorageDirectory.resolvePath( "bbm" );
			
			if( !dir.exists )
			{
				dir.createDirectory();
			}
			
			var avatar:File = dir.resolvePath("avatar");
			if( !avatar.exists )
			{
				avatar.createDirectory();
			}
			
			
			__iconDir = File.applicationStorageDirectory.resolvePath( "bbm/icons" );
			
			if( !__iconDir.exists )
			{
				__iconDir.createDirectory();
			}
			
			
			var path:String = dir.nativePath + "/";

			__context.call( "setStoragePath", path );
		}
		
		/**
		 * Returns <code>true</code> if a download invitation can be sent.
		 * <p>
		 * This method will always return <code>false</code> before a successful registration.
		 * </p>
		 * @return Returns <code>true</code> if inviations can be sent.
		 */
		public function sendDownloadInvitation():Boolean
		{
			var result:Boolean;
			
			/*FDT_IGNORE*/
			if(CONFIG::ANE)
			/*FDT_IGNORE*/ 
			{
				result = Boolean( __context.call( "sendDownloadInvitation" ) as int );
			}

			return( result );
		}
		
		/**
		 * Determine whether access to the BBM Social Platform is allowed.
		 * <p>
		 * Access is not allowed until a successful registration has taken place.
		 * </p>
		 * @return Returns <code>true</code> is access is allowed.
		 */
		public function isAccessAllowed():Boolean
		{
			var result:Boolean;
			
			/*FDT_IGNORE*/
			if(CONFIG::ANE)
			/*FDT_IGNORE*/ 
			{
				result = Boolean( __context.call( "accessAllowed" ) as int );
			}
			
			return( result );
		}
		
		/**
		 * Determine whether the user has allowed this application and its application activities to appear in their BBM profile.
		 * <p>
		 * You can use this function to determine whether your profile box is
 		 * being displayed on the user's profile. This function will return an accurate
 		 * value only if you have access to the BBM Social Platform (i.e. if
 		 * <code>isAccessAllowed()</code> returns <code>true</code>).
 		 * </p>
 		 * <p>
		 * The user can modify this permission through the global settings application.
		 * </p>
		 * @return Returns <code>true</code> if profile box items can be shown.
		 */
		public function canShowProfileBox():Boolean
		{
			var result:Boolean;
			
			/*FDT_IGNORE*/
			if(CONFIG::ANE)
			/*FDT_IGNORE*/ 
			{
				result = Boolean( __context.call( "canShowProfileBox" ) as int );
			}
			
			return( result );
		}
		
		/**
		 * Determine whether this user has allowed other users of this application to send this user invitations to become a BBM contact.
		 * <p>
		 * This function will return an accurate value only if you have access
 		 * to the BBM Social Platform (i.e. if <code>isAccessAllowed()</code> returns <code>true</code>).
 		 * </p>
 		 * <p>
 		 * The user can modify this permission through the global settings application.
		 * </p>
		 */
		public function canSendBBMInvite():Boolean
		{
			var result:Boolean;
			
			/*FDT_IGNORE*/
			if(CONFIG::ANE)
			/*FDT_IGNORE*/ 
			{
				result = Boolean( __context.call( "canSendBBMInvite" ) as int );
			}
			
			return( result );
		}
		
		/**
		 * Register your app with the BBM Social Platform.
		 * <p>
		 * A UUID is a unique, 128-bit, 36-character identifier that you
		 * generate for your app using a UUID generator. The UUID string must conform to
 		 * the Microsoft 8-4-4-4-12 format (xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx).
		 * </p>
		 * <p>A progress registration dialog may appear in your application after you
 		 * invoke this function. The user will be able to cancel the registration by
 		 * dismissing the dialog. Once the registration is completed, a system toast
 		 * may appear indicating to the user that your application is now connected to BBM.</p>
 		 * <p>If BBM is not setup when registration starts, the user may decide to setup
 		 * BBM. This action will trigger the registration to resume.</p>
 		 * <p>
 		 * <code>BBMRegisterEvent</code> events are dispatched during the registration process.
 		 * </p>
 		 * @param uuid The application's uuid.
 		 * @see net.rim.events.BBMRegisterEvent BBMRegisterEvent
		 */
		public function registerApplication( uuid:String ):void
		{
			/*FDT_IGNORE*/
			if(CONFIG::ANE)
			/*FDT_IGNORE*/ 
			{
				__context.call( "registerApplication", uuid );
			}
		}
		
		/**
		 * Retrieve the user's BBM profile information.
		 * 
		 * @return A instance of <code>BBMUserProfile</code>.
		 * @see BBMUserProfile
		 */
		public function getUserProfile():BBMUserProfile
		{
			if( __userProfile == null )
			{
				/*FDT_IGNORE*/
				if(CONFIG::ANE)
				/*FDT_IGNORE*/ 
				{
					var arr:Array = __context.call( "getUserProfile" ) as Array;
					if( arr )
					{
						trace( arr );
						__userProfile = new BBMUserProfile(arr[0], arr[1], arr[2], arr[3], arr[4], arr[5], arr[6] );
					}
				}
				
			}
			return( __userProfile );
		}
		
		private function statusEvent( event:StatusEvent ):void
		{		
			switch( event.code )
			{
				case "registration":
					handleRegistrationEvent( event.level );
					break;
				case "contact":
					handleContactEvent( event.level );
					break;
				case "profilebox":
					handleProfileBoxEvent( event.level );
					break;
				case "profilebox_icon":
					var path:String = event.level;
					var f:File = new File( path );
					var iconid:int = int( f.name.substr( 0, f.name.lastIndexOf( "." ) ) );
					__boxItems.updateIcon(iconid, path);
					break;
				case "profilebox_removed":
					__boxItems.removeItemWithId( event.level );
					break;
				case "profile.displayname":
					handleUserProfileUpdate( BBMContactUpdateTypes.DISPLAY_NAME, event.level );
					break;
				case "profile.displaypicture":
					handleUserProfileUpdate( BBMContactUpdateTypes.DISPLAY_PICTURE, event.level );
					break;
				case "profile.personalmessage":
					handleUserProfileUpdate( BBMContactUpdateTypes.PERSONAL_MESSAGE, event.level );
					break;
				case "profile.status":
					handleUserProfileUpdate( BBMContactUpdateTypes.STATUS, event.level );
					break;
			}
		}
		
		private function handleProfileBoxEvent( level:String ):void
		{
			if( level == "added" )
			{
				var item:Array = __context.call( "getAddedProfileBoxItem" ) as Array;
				if( __boxItems )
				{
					__boxItems.addItem( createBoxItemFromArray( item ) );
				}
			}
		}
		
		private function createBoxItemFromArray( arr:Array ):BBMProfileBoxItem
		{
			return( new BBMProfileBoxItem( arr[0], arr[1], arr[2], arr[3], arr[4] ) );
		}
		
		private function handleUserProfileUpdate( type:int, value:String ):void
		{
			use namespace bbm_internal;
	
			switch( type )
			{
				case BBMContactUpdateTypes.DISPLAY_NAME:
					__userProfile.$setDisplayName( value );
					break;
				case BBMContactUpdateTypes.DISPLAY_PICTURE:
					__userProfile.$setProfileUrl( value );
					break;
				case BBMContactUpdateTypes.PERSONAL_MESSAGE:
					__userProfile.$setPersonalMessage( value );
					break;
				case BBMContactUpdateTypes.STATUS:
					__userProfile.$setPersonalStatus( value );
					var status:int = __context.call( "getUserProfileStatus" ) as int;
					__userProfile.$setStatus( status );
					break;
					
			}
			
			dispatchEvent( new BBMUserProfileEvent( BBMUserProfileEvent.UPDATE, type ) );
		}
		
		private function handleContactUpdateEvent():void
		{
			var updates:Array = __context.call( "getUpdatedContactProperties" ) as Array;
			if( updates )
			{
				for( var i:int = 0; i<updates.length; i++ )
				{
					var update:Object = updates[ i ];
					var contact:BBMContact = __contacts.updateContactWithId( update.ppid, update.property, update.value, update.status );

					if( contact )
					{
						dispatchEvent( new BBMContactEvent( BBMContactEvent.CONTACT_UPDATE, contact, update.property ) );
					}
				}
			}
		}
		
		
		private function handleRegistrationEvent( level:String ):void
		{
			switch( level )
			{
				case "access_allowed":
					dispatchEvent( new BBMRegisterEvent( BBMRegisterEvent.SUCCESS ) );
					break;
				case "access_pending":
					dispatchEvent( new BBMRegisterEvent( BBMRegisterEvent.PENDING ) );
					break;
				case "access_unregistered":
					dispatchEvent( new BBMRegisterEvent( BBMRegisterEvent.UNREGISTERED ) );
					break;
				case "denied":
					dispatchEvent( new BBMRegisterEvent( BBMRegisterEvent.DENIED ) );
					break;
			}
		}
		
		private function handleContactEvent( level:String ):void
		{
			var arr:Array;
			
			switch( level )
			{
				case "contact_list":
					arr = __context.call( "getContactList" ) as Array;
					if( arr )
					{
						for( var i:int = 0; i<arr.length; i++ )
						{
							__contacts.addItem( createContactFromArray( arr[ i ] ) );
						}
					}
					
					dispatchEvent( new BBMContactEvent( BBMContactEvent.CONTACT_LIST ) );
					
					break;
				case "contact_added":
					arr = __context.call( "getAddedContact" ) as Array;
					if( arr )
					{
						var contact:BBMContact = createContactFromArray( arr );
						if( contact )
						{
							__contacts.addItem( contact );
							dispatchEvent( new BBMContactEvent( BBMContactEvent.CONTACT_UPDATE, contact, BBMContactUpdateTypes.INSTALL_APP ) );
						}
					}
					break;
				case "contact_update":
					handleContactUpdateEvent();
					break;
			}
		}
		
		private function createContactFromArray( arr:Array ):BBMContact
		{
			var contact:BBMContact = new BBMContact(arr[0], arr[1], arr[2], arr[3], arr[4], arr[5], arr[6] );
			return( contact );
		}
		
		/** @private **/
		bbm_internal function setUserProfileMessage( message:String ):int
		{
			var result:int = BBMResult.FAILURE;
			/*FDT_IGNORE*/
			if(CONFIG::ANE)
			/*FDT_IGNORE*/ 
			{
				result = __context.call( "setUserProfileMessage", message ) as int;
			}
			
			return( result );
		}
		
		/** @private **/
		bbm_internal function setUserProfileStatus( message:String, status:int ):int
		{
			var result:int = BBMResult.FAILURE;
			
			/*FDT_IGNORE*/
			if(CONFIG::ANE)
			/*FDT_IGNORE*/ 
			{
				result = __context.call( "setUserProfileStatus", message, status ) as int;
			}
			
			return( result );
		}
		
		/** @private **/
		bbm_internal function setUserProfileImage( path:String ):int
		{
			var result:int = BBMResult.FAILURE;
			
			/*FDT_IGNORE*/
			if(CONFIG::ANE)
			/*FDT_IGNORE*/ 
			{
				var f:File = new File( path );
				var type:int = getImageType( f );
				var ba:ByteArray = readFile( f );
				
				result = __context.call( "setUserProfilePicture", ba, type ) as int;
			}
			
			return( result );
		}
	
		/** @private **/
		bbm_internal function retrieveProfileBoxIcon( id:int ):int
		{
			var result:int = -1;
			/*FDT_IGNORE*/
			if(CONFIG::ANE)
			/*FDT_IGNORE*/ 
			{
				result = __context.call( "getProfileBoxItemIcon", id ) as int;
			}
			return( result );
		}
		
		private function readFile( file:File ):ByteArray
		{
			var stream:FileStream = new FileStream();
			stream.open( file, FileMode.READ );
			var ba:ByteArray = new ByteArray();
			stream.readBytes( ba );
			
			return( ba );
		}
		
		private function getImageType( file:File ):int
		{
			var ext:String = file.extension;
			var type:int = 0;
						
			if( ext == "jpg" || ext == "jpeg" )
			{
				type = 0;
			}
			else if( ext == "gif" )
			{
				type = 2;
			}
			else if( ext == "png" )
			{
				type = 1;
			}
			else if( ext == "bmp" )
			{
				type = 3;
			}
			
			return( type );
		}
		
		/**
		 * Register an image with the BBM Social Platform for use with profile box items.
		 * <p>
		 * Registering an image uploads it to the user's BlackBerry device for use when the app is not running.
 		 * This process takes place asynchronously. Images should be registered using
 		 * the same ID on different devices and in
 		 * different versions of your app because images are distributed on a
 		 * peer-to-peer basis between devices.
		 * </p>
		 * <p>
		 * If <code>canShowProfileBox()</code> returns <code>false</code>, this method will return <code>BBMResult.FAILURE</code>.
		 * </p>
		 * @param path The file path to the image. For example, <code>File.applicationDirectory.resolvePath("assets/apple.png").nativePath</code>
		 * @param id The unique ID of the image. Must be > 0.
		 * @returns Returns one of the values defined in <code>BBMResult</code>.
		 * @see BBMResult
		 */
		public function registerIcon( path:String, id:int ):int
		{
			var result:int = -1;
			/*FDT_IGNORE*/
			if(CONFIG::ANE)
			/*FDT_IGNORE*/ 
			{
				var f:File = new File( path );

				var type:int = getImageType( f );
				var ba:ByteArray = readFile( f );
			
				result = __context.call( "registerIcon", ba, type, id ) as int;
			}
			return( result );
		}
		
		/**
		 * Add an item to a user's profile box.
		 * <p>
		 * A profile box item consists of an image, text, and a customizable string (cookie).
		 * </p>
		 * @param text The item text must not be null or empty. It can have a maximum of 100 characters,
 		 * with no more than 2 new line characters.
 		 * @param cookie The cookie can be null, with a maximum of 128 characters.
 		 * @param iconId Must be that of a registered image, or &lt; 0 if this item has no image.
		 * @returns Returns one of the values defined in <code>BBMResult</code>.
		 * @see BBMResult
		 */
		public function addProfileBoxItem( text:String, cookie:String = null, iconId:int = 0 ):int
		{
			var result:int = -1;
			/*FDT_IGNORE*/
			if(CONFIG::ANE)
			/*FDT_IGNORE*/ 
			{
				result =  __context.call( "addProfileBoxItem", text, cookie, iconId ) as int;
			}
			
			return( result );
		}
		
		/**
		 * Remove a profile box item from the user's BBM profile box.
		 * <p>
		 * This process takes place asynchronously. 
		 * If <code>canShowProfileBox()</code> returns <code>false</code>, this method will return <code>BBMResult.FAILURE</code>.
		 * </p>
		 * <p>
		 * Once the item is removed the <code>profileBoxItems</code> list is automatically updated.
		 * </p>
		 * @param id The id of the item to remove.
		 * @returns Returns one of the values defined in <code>BBMResult</code>.
		 * @see BBMResult
		 */
		public function removeProfileBoxItem( id:String ):int
		{
			var result:int = -1;
			/*FDT_IGNORE*/
			if(CONFIG::ANE)
			/*FDT_IGNORE*/ 
			{
				result = __context.call( "removeProfileBoxItem", id ) as int;
			}
			
			return( result );
		}
		
		/**
		 * Remove all items in the profile box from the user's BlackBerry device.
		 * <p>
		 * This process takes place asynchronously. 
		 * If <code>canShowProfileBox()</code> returns <code>false</code>, this method will return <code>BBMResult.FAILURE</code>.
		 * </p>
		 * <p>
		 * Once the items are removed the <code>profileBoxItems</code> list is automatically updated.
		 * </p>
		 * @returns Returns one of the values defined in <code>BBMResult</code>.
		 * @see BBMResult
		 */
		public function removeAllProfileBoxItems():int
		{
			var result:int = -1;
			/*FDT_IGNORE*/
			if(CONFIG::ANE)
			/*FDT_IGNORE*/ 
			{
				result = __context.call( "removeAllProfileBoxItems" ) as int;
			}
			return( result );
		}

		
	}
}

class SingeltonEnforcer{}