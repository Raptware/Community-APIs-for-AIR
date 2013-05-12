package net.rim.bbm
{
	/**
	 * Result codes that can be returned by a function.
	 * @bbtags
     * <version>10.2</version>
     * <foundin>BBM.ane</foundin>
	 */
	public class BBMResult
	{
		/**
		* Indicates that a function has completed successfully.
		*/
		public static const SUCCESS:int = 0;
		
		/**
		* Indicates that an operation will be completed asynchronously.
		*/
		public static const ASYNC:int = 1;
		
		/**
		*  Indicates that a function did not complete successfully.
		*/
		public static const FAILURE:int = -1;
	}
}
