package net.rim.events
{
	import net.rim.bbm.BBMContact;
	import flash.events.Event;

	/**
	 * <code>BBMContactEvent</code> events are dispatched by the <code>BBMManager</code> class when contacts are updated.
	 * @bbtags
     * <version>10.2</version>
     * <foundin>BBM.ane</foundin>
	 */
	public class BBMContactEvent extends Event
	{
		/**
		 * Event type dispatched when the contact list is retrieved from the BBM Social Platform servers.
		 * <p>The BBMContactEvent.CONTACT_LIST constant defines the value of the
	     *  <code>type</code> property of the event object for an
	     *  <code>contact_list</code> event.</p>
	     *
	     *  <p>The properties of the event object have the following values:</p>
	     *  <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
	     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
	     *     <tr><td><code>contact</code></td><td>The contact property is null for this event type.</td></tr>
	     *     <tr><td><code>currentTarget</code></td><td>The object that is actively processing the Event object with an event listener.</td></tr>
	     *     <tr><td><code>type</code></td><td>BBMContactEvent.CONTACT_LIST</td></tr>
	     *     <tr><td><code>updateType</code></td><td>The updateType property is null for this event type.</td></tr>
	     *  </table>
	     *
	     *  @eventType contact_list
		 */
		public static const CONTACT_LIST:String = "contact_list";
		
		/**
		 * Event type dispatched when a contact is updated.
		 * <p>The BBMContactEvent.CONTACT_UPDATE constant defines the value of the
	     *  <code>type</code> property of the event object for an
	     *  <code>contact_update</code> event.</p>
	     *
	     *  <p>The properties of the event object have the following values:</p>
	     *  <table class="innertable">
	     *     <tr><th>Property</th><th>Value</th></tr>
	     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
	     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
	     *     <tr><td><code>contact</code></td><td>The contact that was updated.</td></tr>
	     *     <tr><td><code>currentTarget</code></td><td>The object that is actively processing the Event object with an event listener.</td></tr>
	     *     <tr><td><code>type</code></td><td>BBMContactEvent.CONTACT_UPDATE</td></tr>
	     *     <tr><td><code>updateType</code></td><td>The property that of the contact that was updated.</td></tr>
	     *  </table>
	     *
	     *  @eventType contact_update
		 */
		public static const CONTACT_UPDATE:String = "contact_update";

		private var __contact:BBMContact;
		private var __updateType:int;
		
		/**
		 * Defines what was updated for the specified contact.
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
		 * The contact that was updated. 
		 */
		public function get contact():BBMContact
		{
			return( __contact );
		}
		
		/**
		 * Creates a <code>BBMContactEvent</code> instance.
		 * @param type The type of event.
		 * @param contact The contact for the event.
		 * @param updateType The updateType of the event.
		 */
		public function BBMContactEvent( type:String, contact:BBMContact = null, updateType:int = -1 )
		{
			__contact = contact;
			__updateType = updateType;
			super( type, bubbles, cancelable );
		}
	
		/** @private **/
		override public function clone():Event
		{
			return new BBMContactEvent( type, contact, updateType );
		}

		/** @private **/
		override public function toString():String
		{
			return formatToString( "BBMContactEvent", "type", "contact", "updateType" );
		}


	}
}
