package net.rim.bbm
{
	import flash.events.EventDispatcher;

	/**
	 * Represents a profile box item in the BBM Social Platform.
	 * <p>
	 * <code>BBMProfileBoxItem</code> is a class that represents a profile box item accessible through the BBM Social Platform. 
	 * The class provides accessor methods to the main attributes of the ProfileBoxItem including cookie, id, iconId and text.
	 * </p>
	 * @bbtags
     * <version>10.2</version>
     * <foundin>BBM.ane</foundin>
     * @see BBMManager#profileBoxItems
	 */
	public class BBMProfileBoxItem extends EventDispatcher
	{
		
		private var __iconId:int;
		private var __id:String;
		private var __cookie:String;
		private var __text:String;
		private var __iconUrl:String;
		
		/**
		 * Retrieve the url for the icon of the item.
		 * <p>
		 * If <code>null</code>, application developers should call the<code>retrieveIcon()</code>
		 * icon method in order to get the url to the icon. When the icon url is retrieved, this property
		 * is automatically updated with the url. 
		 * </p>
		 */
		public function get iconUrl():String
		{
			return( __iconUrl );
		}
		
		/**
		 * Retrieve the id of the item.
		 */
		public function get id():String
		{
			return( __id );
		}
		
		/**
		 * Retrieve the icon id of the item.
		 */
		public function get iconId():int
		{
			return( __iconId );
		}
		
		/**
		 * Retrieve the text of the item.
		 */
		public function get text():String
		{
			return( __text );
		}
		
		/**
		 * Retrieve the cookie of the item.
		 */
		public function get cookie():String
		{
			return( __cookie );
		}
		
		/**
		 * Creates a <code>BBMProfileBoxItem</code> instance.
		 * <p>
		 * <code>BBMProfileBoxItem</code> instances are created by the <code>BBMManager</code> class and should not be directly instaniated.
		 * </p>
		 * @param id The id of the item.
		 * @param text The text of the item.
		 * @param cookie The cookie of the item.
		 * @param iconId The icon id of the item.
		 * @param iconUrl The url of the icon.
		 */
		public function BBMProfileBoxItem( id:String, text:String, cookie:String, iconId:int, iconUrl:String = null )
		{
			__id = id;
			__text = text;
			__cookie = cookie;
			__iconId = iconId;
			__iconUrl = iconUrl;
		}
		
		/**
		 * Retrieves the icon from the BBM Social Platform.
		 * <p>
		 * Retrieving the icon occurs asynchronously and once completed the <code>iconUrl</code> property is updated.
		 * </p>
		 */
		public function retrieveIcon():void
		{
			use namespace bbm_internal;
			BBMManager.bbmManager.retrieveProfileBoxIcon( __iconId );
		}
		
		/** @private **/
		bbm_internal function setIconUrl( value:String ):void
		{
			__iconUrl = value;
		}
		
	}
}
