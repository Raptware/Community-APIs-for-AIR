package net.rim.events
{
	import flash.events.Event;

	/**
	 * <code>BBMUserProfileEvent</code> events are dispatched by the <code>BBMManager</code> class when the users profile is updated.
	 * @bbtags
     * <version>10.2</version>
     * <foundin>BBM.ane</foundin>
	 */
	public class BBMUserProfileEvent extends Event
	{
		
		/**
		 * Event type dispatched when the user profile is updated.
		 * <p>The BBMUserProfileEvent.UPDATE constant defines the value of the
	     *  <code>type</code> property of the event object for an
	     *  <code>userProfileUpdate</code> event.</p>
	     *
	     *  <p>The properties of the event object have the following values:</p>
	     *  <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
	     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
	     *     <tr><td><code>currentTarget</code></td><td>The object that is actively processing the Event object with an event listener.</td></tr>
	     *     <tr><td><code>type</code></td><td>BBMUserProfileEvent.UPDATE</td></tr>
	     *     <tr><td><code>updateType</code></td><td>What was updated in the users profile.</td></tr>
	     *  </table>
	     *
	     *  @eventType userProfileUpdate
		 */
		static public const UPDATE:String = "userProfileUpdate";		
		
		private var __updateType:int;
		
		/**
		 * Defines what was updated for the specified user profile.
		 * <p>
		 * Valid values can be found in <code>BBMContactupdateTypes</code>
		 * </p>
		 * @see BBMContactUpdateTypes
		 */
		public function get updateType():int
		{
			return( __updateType );
		}
		
		/**
		 * Creates a <code>BBMUserProfileEvent</code> instance.
		 * @param type The type of event.
		 * @param updateType The type of update.
		 */
		public function BBMUserProfileEvent( type:String, updateType:int = -1 )
		{
			super( type, bubbles, cancelable );
			__updateType = updateType;
		}
		
		/** @private **/
		override public function clone():Event
		{
			return new BBMUserProfileEvent( type, updateType );
		}

		/** @private **/
		override public function toString():String
		{
			return formatToString( "BBMUserProfileEvent", "type", "updateType" );
		}
	}
}
