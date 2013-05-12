package net.rim.bbm.data
{
	import net.rim.bbm.BBMProfileBoxItem;
	import net.rim.bbm.bbm_internal;

	import qnx.ui.events.DataProviderEvent;

	/**
	 * @private
	 */
	public class BBMProfileBoxItemProvider extends BBMDataProvider
	{
		public function BBMProfileBoxItemProvider()
		{
			super();
		}
		
		public function getItemWithId( id:String ):BBMProfileBoxItem
		{
			var index:int = indexOfItemId( id );
			var contact:BBMProfileBoxItem;	
			
			if( index != -1 )
			{
				contact = data[ index ] as BBMProfileBoxItem;
			}
			return( contact );
		}
		
		public function indexOfItemId( id:String ):int
		{
			var index:int = -1;
			for( var i:int = 0; i<length; i++ )
			{
				var c:BBMProfileBoxItem = getItemAt(i) as BBMProfileBoxItem;
				if( c && c.id == id )
				{
					return( i );
				}
			}
			
			return( index );
		}
		
		
		
		public function updateIcon( iconid:int, path:String ):void
		{
			for( var i:int = 0; i<length; i++ )
			{
				var item:BBMProfileBoxItem = getItemAt( i ) as BBMProfileBoxItem;
				if( item && item.iconId == iconid )
				{
					use namespace bbm_internal;
					item.setIconUrl( path );
					dispatchChange( DataProviderEvent.UPDATE_ITEM, [item], i, i + 1 );	
				}
			}
		}
		
		public function removeItemWithId( id:String ):void
		{
			var index:int = indexOfItemId( id );
			removeItemAt(index);
		}
	}
}
