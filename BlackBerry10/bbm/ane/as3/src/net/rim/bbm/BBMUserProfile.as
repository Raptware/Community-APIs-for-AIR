package net.rim.bbm
{
	/**
	 * Represents the device User in the BBM Social Platform.
	 * <p>
	 * <code>BBMUserProfile</code> is a class that represents the device user in the BBM Social Platform. 
	 * The class provides getters and setters to attributes of the device User.
	 * </p>
	 * @bbtags
     * <version>10.2</version>
     * <foundin>BBM.ane</foundin>
     * @see BBMManager#getUserProfile()
	 */
	public class BBMUserProfile
	{
		private var __id:String;
		private var __name:String;
		private var __message:String;
		private var __statusMessage:String;
		private var __appVersion:String;
		private var __profileurl:String;
		
		private var __status:int;
		
		/**
		 * Gets or sets the users status.
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
		 * Get the id of the user.
		 */
		public function get id():String
		{
			return( __id );
		}
		
		/**
		 * Get the display name of the user.
		 */
		public function get displayName():String
		{
			return( __name );
		}
		
		/**
		 * Get the personal message of the user.
		 */
		public function get personalMessage():String
		{
			return( __message );
		}
		
		/**
		 * Set the personal message of the user.
		 * <p>
		 * When setting the personal message a dialog displays to allow the
 		 * user to accept or reject the change. A personal message is limited to 160
 		 * characters; anything longer is truncated. If <code>null</code> is passed in, the personal
 		 * message is cleared.
		 * </p>
		 * @param message The message to set.
		 * @return Returns <code>BBMResult.ASYNC</code> if successful in sending the request, otherwise <code>BBMResult.FAILURE</code>.
		 */
		public function setPersonalMessage( message:String ):int
		{
			var result:int = BBMResult.FAILURE;
			if( __message != message )
			{
				//Do not set __status here because the user could press cancel in the dialog.
				//A profile event will update the internal value.
				use namespace bbm_internal;
				result = BBMManager.bbmManager.setUserProfileMessage(message);
			}
			else
			{
				result = BBMResult.SUCCESS;
			}
			
			return( result );
		}
		
		/**
		 * Get or set the personal status of the user.
		 */
		public function get personalStatus():String
		{
			return( __statusMessage );
		}
		
		/**
		 * Sets the status of the user.
		 * @param status The status of the user. Valid values can be found in the <code>BBMContactStatus</code> class.
		 * @param message The personal status of the user.
		 * @return Returns <code>BBMResult.ASYNC</code> if successful in sending the request, otherwise <code>BBMResult.FAILURE</code>.
		 */
		public function setStatus( status:int, message:String ):int
		{
			var result:int = BBMResult.FAILURE;
			if( status != __status || __statusMessage != message )
			{
				use namespace bbm_internal;
				result = BBMManager.bbmManager.setUserProfileStatus( message, status );
			}
			else
			{
				result = BBMResult.SUCCESS;
			}
			
			return( result );
		}
		
		/**
		 * Gets the version of the application installed.
		 */
		public function get appVersion():String
		{
			return( __appVersion );
		}
		
		/**
		 * Gets the url of the profile image for the user.
		 */
		public function get profileUrl():String
		{
			return( __profileurl );
		}
		
		/**
		 * Sets the url of the profile image for the user.
		 * <p>
		 * When setting the profile url, the image is uploaded to the BBM Social Platform servers.
		 * A dialog displays to allow the user to accept or reject the change
 		 * to the user's BBM display picture. The display picture is limited to 32kB of
 		 * data; an attempt to set a display picture that exceeds this limit will fail
 		 * and will not display the dialog.
		 * </p>
		 * @return Returns <code>BBMResult.ASYNC</code> if successful in sending the request, otherwise <code>BBMResult.FAILURE</code>. 
		 */
		public function setProfileUrl( value:String ):int
		{
			var result:int = BBMResult.FAILURE;
			
			if( __profileurl != value )
			{
				//Do not set __profileurl here because the user could press cancel in the dialog.
				//A profile event will update the internal value.
				use namespace bbm_internal;
				result = BBMManager.bbmManager.setUserProfileImage( value );
			}
			else
			{
				result = BBMResult.SUCCESS;
			}
			
			return( result );
		}
		
		/**
		 * Creates a <code>BBMUserProfile</code> instance.
		 * <p>
		 * <code>BBMUserProfile</code> instances are created by the <code>BBMManager</code> class and should not be directly instaniated.
		 * </p>
		 * @param id The id of the user.
		 * @param name The name of the user.
		 * @param message The message of the user.
		 * @param statusMessage The status message of the user.
		 * @param appVersion The app version the user has installed.
		 * @param status The status of the user.
		 * @param profileurl The url for the profile image of the user.
		 */
		public function BBMUserProfile( id:String, name:String, message:String, statusMessage:String, appVersion:String, status:int, profileurl:String = null )
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
		bbm_internal function $setDisplayName( value:String ):void
		{
			__name = value;
		}
		
		/** @private **/
		bbm_internal function $setPersonalMessage( value:String ):void
		{
			__message = value;
		}
		
		/** @private **/
		bbm_internal function $setPersonalStatus( value:String ):void
		{
			__statusMessage = value;
		}
		
		/** @private **/
		bbm_internal function $setStatus( value:int ):void
		{
			__status = value;
		}
		
		/** @private **/
		bbm_internal function $setAppVersion( value:String ):void
		{
			__appVersion = value;
		}
		
		/** @private **/
		bbm_internal function $setProfileUrl( value:String ):void
		{
			__profileurl = value;
		}
	}
}
