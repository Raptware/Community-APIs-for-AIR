package net.rim.bbm
{
	/**
	 * Represents a contact in the BBM Social Platform.
	 * <p>
	 * <code>BBMContact</code> is a class that represents a contact accessible through the BBM Social Platform. 
	 * The class provides accessor methods to the main attributes of the contact including display name, message and status.
	 * </p>
	 * @bbtags
     * <version>10.2</version>
     * <foundin>BBM.ane</foundin>
     * @see BBMManager#contacts
	 */
	public class BBMContact
	{
		use namespace bbm_internal;
		
		
		private var __id:String;
		private var __name:String;
		private var __message:String;
		private var __statusMessage:String;
		private var __appVersion:String;
		private var __profileurl:String;
		private var __status:int;
		
		/**
		 * Retrieve a contact's status.
		 * <p>
		 * Valid values can be found in the <code>BBMContactStatus</code> class.
		 * </p>
		 * @see BBMContactStatus
		 */
		public function get status():int
		{
			return( __status );
		}
		
		/**
		 * Retrieve a contact's id.
		 * <p>
		 * The user's PPID is the same across multiple instances of BBM (for
 		 * example, on a BlackBerry smartphone and a BlackBerry tablet), when the user
 		 * signs in with the same BlackBerry ID. The ID is encoded as a Base64 string
 		 * using the ASCII character set.
		 * </p>
		 */
		public function get id():String
		{
			return( __id );
		}
		
		/**
		 * Retrieve a contact's display name.
		 */
		public function get displayName():String
		{
			return( __name );
		}
		
		/**
		 * Retrieve a contact's personal message.
		 */
		public function get personalMessage():String
		{
			return( __message );
		}
		
		/**
		 * 
		 * Retrieve a contact's status message.
		 */
		public function get personalStatus():String
		{
			return( __statusMessage );
		}
		
		/**
		 * Retrieve a contact's version of the app that they have installed.
		 */
		public function get appVersion():String
		{
			return( __appVersion );
		}
		
		/**
		 * Retrieve the url for a contact's profile image.
		 */
		public function get profileUrl():String
		{
			return( __profileurl );
		}
		
		/**
		 * Creates a <code>BBMContact</code> instance.
		 * <p>
		 * <code>BBMContact</code> instances are created by the <code>BBMManager</code> class and should not be directly instaniated.
		 * </p>
		 * @param id The id of the contact.
		 * @param name The name of the contact.
		 * @param message The message of the contact.
		 * @param statusMessage The status message of the contact.
		 * @param appVersion The app version the contact has installed.
		 * @param status The status of the contact.
		 * @param profileurl The url for the profile image of the contact.
		 */
		public function BBMContact( id:String, name:String, message:String, statusMessage:String, appVersion:String, status:int, profileurl:String = null )
		{
			__id = id;
			__name = name;
			__message = message;
			__statusMessage = statusMessage;
			__appVersion = appVersion;
			__profileurl = profileurl;
			__status = status;
		}
		
		/** @private **/
		bbm_internal function setDisplayName( value:String ):void
		{
			__name = value;
		}
		
		/** @private **/
		bbm_internal function setPersonalMessage( value:String ):void
		{
			__message = value;
		}
		
		/** @private **/
		bbm_internal function setPersonalStatus( value:String ):void
		{
			__statusMessage = value;
		}
		
		/** @private **/
		bbm_internal function setStatus( value:int ):void
		{
			__status = value;
		}
		
		/** @private **/
		bbm_internal function setAppVersion( value:String ):void
		{
			__appVersion = value;
		}
		
		/** @private **/
		bbm_internal function setProfileUrl( value:String ):void
		{
			__profileurl = value;
		}
		
		/** @private **/
		public function toString() : String 
		{
			return "[BBMContact " + displayName + "]";
		}
		
	}
}
