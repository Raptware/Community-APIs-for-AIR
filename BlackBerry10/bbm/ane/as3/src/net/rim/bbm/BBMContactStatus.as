package net.rim.bbm
{
	/**
	 * Represents the status of the device User or a <code>BBMContact</code>.
	 * @see BBMContact#status
	 * @see BBMUserProfile#status
	 * @bbtags
     * <version>10.2</version>
     * <foundin>BBM.ane</foundin>
	 */
	public class BBMContactStatus
	{
		/**
		 * User status that indicates that the user is available.
		 */
		public static const AVAILABLE:int = 0;
		
		/**
		 * User status that indicates that the user is busy.
		 */
		public static const BUSY:int = 1;
	}
}
