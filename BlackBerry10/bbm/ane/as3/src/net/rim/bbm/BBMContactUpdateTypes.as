package net.rim.bbm
{
	/**
	 * The types of updates that a user or a contact can make to their BBM profile.
	 * <p>
	 * Update types are used to determine which property was updated when a <code>BBMContactEvent</code> event is dispatched.
	 * </p>
	 * @bbtags
     * <version>10.2</version>
     * <foundin>BBM.ane</foundin>
     * @see net.rim.events.BBMContactEvent#updateType
	 */
	public class BBMContactUpdateTypes
	{
		/**
		 *  Indicates that the display name has changed.
		 */
		public static const DISPLAY_NAME:int = 1 << 0;
		
		/**
		 * Indicates that the display picture has changed.
		 */
		public static const DISPLAY_PICTURE:int = 1 << 1;
		/**
		 * Indicates that the personal message has changed.
		 */
		public static const PERSONAL_MESSAGE:int = 1 << 2;
		/**
		 * Indicates that the status has changed.
		 */
		public static const STATUS:int = 1 << 3;
		/**
		 * Indicates that your app was installed/enabled.
		 */
		public static const INSTALL_APP:int = 1 << 4;
		/**
		 * Indicates that your app was uninstalled/disabled.
		 */
		public static const UNINSTALL_APP:int = 1 << 5;
	}
}
