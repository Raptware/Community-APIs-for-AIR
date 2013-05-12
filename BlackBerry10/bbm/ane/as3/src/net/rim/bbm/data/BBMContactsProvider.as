package net.rim.bbm.data
{
	import net.rim.bbm.BBMContact;
	import net.rim.bbm.BBMContactUpdateTypes;
	import net.rim.bbm.bbm_internal;

	import qnx.ui.events.DataProviderEvent;

	/**
	 * @private
	 */
	public class BBMContactsProvider extends BBMDataProvider
	{
		public function BBMContactsProvider()
		{
			super();
		}
		
		public function getContactWithId( id:String ):BBMContact
		{
			var index:int = indexOfContactId( id );
			var contact:BBMContact;	
			
			if( index != -1 )
			{
				contact = data[ index ] as BBMContact;
			}
			return( contact );
		}
		
		public function indexOfContactId( id:String ):int
		{
			var index:int = -1;
			for( var i:int = 0; i<length; i++ )
			{
				var c:BBMContact = getItemAt(i) as BBMContact;
				if( c && c.id == id )
				{
					return( i );
				}
			}
			
			return( index );
		}
		
		public function updateContactWithId( id:String, prop:int, value:String, status:int ):BBMContact
		{
			var index:int = indexOfContactId( id );
			var contact:BBMContact;	
			
			if( index != -1 )
			{
				contact = data[ index ] as BBMContact;
			}
			
			if( contact )
			{
				if( prop == BBMContactUpdateTypes.UNINSTALL_APP )
				{
					removeItemAt( index );
				}
				else
				{
					use namespace bbm_internal;
					switch( prop )
					{
						case BBMContactUpdateTypes.DISPLAY_NAME:
							contact.setDisplayName( value );
							break;
						case BBMContactUpdateTypes.DISPLAY_PICTURE:
							contact.setProfileUrl( value );
							break;
						case BBMContactUpdateTypes.PERSONAL_MESSAGE:
							contact.setPersonalMessage( value );
							break;
						case BBMContactUpdateTypes.STATUS:
							contact.setPersonalStatus( value );
							contact.setStatus( status );
							break;
					}
					
					dispatchChange( DataProviderEvent.UPDATE_ITEM, [contact], index, index + 1 );
				}
			}
			
			return( contact );
		}
	}
}
