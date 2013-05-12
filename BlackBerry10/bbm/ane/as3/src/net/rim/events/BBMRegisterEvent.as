package net.rim.events
{
	import flash.events.Event;

	/**
	 * <code>BBMRegisterEvent</code> events are dispatched by the <code>BBMManager</code> class when registration events occur.
	 * @bbtags
     * <version>10.2</version>
     * <foundin>BBM.ane</foundin>
     * @see net.rim.bbm.BBMManager BBMManager
	 */
	public class BBMRegisterEvent extends Event
	{
		
		/**
		 * Event type dispatched when the application has successfully registered with the BBM Social Platform.
		 * <p>The BBMRegisterEvent.SUCCESS constant defines the value of the
	     *  <code>type</code> property of the event object for an
	     *  <code>register_success</code> event.</p>
	     *
	     *  <p>The properties of the event object have the following values:</p>
	     *  <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
	     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
	     *     <tr><td><code>currentTarget</code></td><td>The object that is actively processing the Event object with an event listener.</td></tr>
	     *     <tr><td><code>type</code></td><td>BBMRegisterEvent.SUCCESS</td></tr>
	     *  </table>
	     *
	     *  @eventType register_success
		 */
		public static const SUCCESS:String = "register_success";
		
		/**
		 * Event type dispatched when the application is in the process of registering with the BBM Social Platform.
		 * <p>The BBMRegisterEvent.PENDING constant defines the value of the
	     *  <code>type</code> property of the event object for an
	     *  <code>register_pending</code> event.</p>
	     *
	     *  <p>The properties of the event object have the following values:</p>
	     *  <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
	     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
	     *     <tr><td><code>currentTarget</code></td><td>The object that is actively processing the Event object with an event listener.</td></tr>
	     *     <tr><td><code>type</code></td><td>BBMRegisterEvent.PENDING</td></tr>
	     *  </table>
	     *
	     *  @eventType register_pending
		 */
		public static const PENDING:String = "register_pending";
		
		/**
		 * Event type dispatched when the application is not registered with the BBM Social Platform.
		 * <p>The BBMRegisterEvent.UNREGISTERED constant defines the value of the
	     *  <code>type</code> property of the event object for an
	     *  <code>register_unregistered</code> event.</p>
	     *
	     *  <p>The properties of the event object have the following values:</p>
	     *  <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
	     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
	     *     <tr><td><code>currentTarget</code></td><td>The object that is actively processing the Event object with an event listener.</td></tr>
	     *     <tr><td><code>type</code></td><td>BBMRegisterEvent.UNREGISTERED</td></tr>
	     *  </table>
	     *
	     *  @eventType register_unregistered
		 */
		public static const UNREGISTERED:String = "register_unregistered";
		
		/**
		 * Event type dispatched when access to the BBM Social Platform is denied. This is usually the result of the user turning off BBM in the application permissions.
		 * <p>The BBMRegisterEvent.DENIED constant defines the value of the
	     *  <code>type</code> property of the event object for an
	     *  <code>register_denied</code> event.</p>
	     *
	     *  <p>The properties of the event object have the following values:</p>
	     *  <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
	     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
	     *     <tr><td><code>currentTarget</code></td><td>The object that is actively processing the Event object with an event listener.</td></tr>
	     *     <tr><td><code>type</code></td><td>BBMRegisterEvent.DENIED</td></tr>
	     *  </table>
	     *
	     *  @eventType register_denied
		 */
		public static const DENIED:String = "register_denied";
		
		
		/**
		 * Creates a <code>BBMRegisterEvent</code> instance.
		 * @param type The type of event.
		 */
		public function BBMRegisterEvent( type:String )
		{
			super( type, bubbles, cancelable );
		}
		
		
		/** @private **/
		override public function clone():Event
		{
			return new BBMRegisterEvent( type );
		}

		/** @private **/
		override public function toString():String
		{
			return formatToString( "BBMRegisterEvent", "type");
		}
	}
}
