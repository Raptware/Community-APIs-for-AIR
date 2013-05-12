package net.rim.bbm.data
{
	import qnx.ui.data.IDataProvider;
	import qnx.ui.events.DataProviderEvent;

	import flash.events.EventDispatcher;

	/**
	* Dispatched when the items are added, removed or updated.
	* @eventType qnx.ui.events.DataProviderEvent.DATA_CHANGE
	*/
	[Event(name="dataChange", type="qnx.ui.events.DataProviderEvent")]
	
	/**
	 * @private
	 */
	public class BBMDataProvider extends EventDispatcher implements IDataProvider
	{
		private var __data:Array;
		
		/**
		* @inheritDoc
		**/
		public function get length():int
		{
			return( __data.length );	
		}
		
		/**
		 * @inheritDoc
		 **/
		public function get data():Array
		{
			return( __data );	
		}
		
		/**
		* Creates a new <code>BBMDataProvider</code> instance.
		**/
		public function BBMDataProvider()
		{
			__data = [];
		}

		/**
		* @inheritDoc
		**/
		public function addItem( item:Object ):void
		{
			addItemAt( item, length );
		}
		
		/**
		* @inheritDoc
		**/
		public function addItemAt( item:Object, index:int ):void
		{
			checkIndex( index, __data.length );
			__data.splice( index, 0, item );
			dispatchChange( DataProviderEvent.ADD_ITEM, [item], index, index );
		}
		
		
		/**
		* @inheritDoc
		**/
		public function addItemsAt( items:Array, index:int ):void
		{
			checkIndex( index, __data.length );
			for( var i:int = 0; i<items.length; i++ )
			{
				__data.splice( index+i, 0, items[ i ] );
			}	
			
			dispatchChange( DataProviderEvent.ADD_ITEM, items, index, index + (items.length - 1));
		}
		
		
		
		
		/**
		* @inheritDoc
		**/
		public function removeItem( item:Object ):void
		{
			var index:int = indexOf( item );
			removeItemAt( index );
		}
		
		/**
		 * @inheritDoc
		 **/
		public function removeItemAt( index:int ):void
		{
			checkIndex( index, __data.length - 1 );
			var arr:Array = [ data[index] ];
			__data.splice( index, 1 );
			dispatchChange( DataProviderEvent.REMOVE_ITEM, arr, index, index);
		}
		
		/**
		 * @inheritDoc
		 **/
		public function removeAll():void
		{
			var len:int = length;
			var arr:Array = data.concat();
			__data = [];
			dispatchChange( DataProviderEvent.REMOVE_ALL, arr, 0, len - 1 );
		}
		
		/**
		 * @inheritDoc
		 **/
		public function replaceItemAt( item:Object, index:int ):void
		{
			checkIndex( index, __data.length - 1 );
			var arr:Array = [data[index]];
			__data.splice( index, 1, item );
			dispatchChange( DataProviderEvent.REPLACE_ITEM, arr,index, index);
		}

		/**
		 * @inheritDoc
		 **/
		public function replaceItem( item:Object, oldObject:Object ):void
		{
			var index:int = indexOf( oldObject );
			replaceItemAt( item, index );
		}
		
		/**
		 * @inheritDoc
		 **/
		public function updateItemAt( item:Object, index:int ):void
		{
			checkIndex( index, __data.length - 1 );
			__data.splice( index, 1, item );
			dispatchChange( DataProviderEvent.UPDATE_ITEM, [item], index, index);
		}
		
		/**
		 * @inheritDoc
		 **/
		public function updateItemsAt( items:Array, index:int ):void
		{
			checkIndex( index, __data.length - 1 );
			checkIndex( index + items.length-1, __data.length - 1 );
			for( var i:int = 0; i<items.length; i++ )
			{
				__data.splice( index+i, 1, items[ i ] );
			}
			dispatchChange( DataProviderEvent.UPDATE_ITEM, items, index, index + (items.length - 1) );
		}
		
		/**
		 * @inheritDoc
		 **/
		public function updateItem( item:Object, oldObject:Object ):void
		{
			var index:int = indexOf( oldObject );
			updateItemAt( item, index );
		}
		
		/**
		 * @inheritDoc
		 **/
		public function getItemAt( index:int ):Object
		{
			checkIndex( index, __data.length - 1 );
			return( __data[ index ] );
		}
		
		/**
		 * @inheritDoc
		 **/
		public function indexOf( item:Object ):int
		{
			return( __data.indexOf( item ) );	
		}
		
		
		/**
		 * @inheritDoc
		 **/
		public function setItems( arr:Array, throwEvent:Boolean = false ):void
		{
			__data = arr;
			if( throwEvent )
			{
				dispatchChange( DataProviderEvent.UPDATE_ALL, arr, 0, length - 1 );
			}
		}
		
		/**
		* Creates a clone of this <code>BBMDataProvider</code>. The new instance contains the same data.
		* 
		* @return The cloned <code>BBMDataProvider</code>.
		**/
		public function clone():IDataProvider
		{
			var arr:IDataProvider = new BBMDataProvider();
			arr.setItems(__data );
			return( arr );	
		}
		
		/** @private **/
		protected function dispatchChange( type:String, items:Array, startIndex:int, endIndex:int, childStartIndex:int = -1, childEndIndex:int = -1 ):void
		{
			var event:DataProviderEvent = new DataProviderEvent( type, items, startIndex, endIndex, childStartIndex, childEndIndex );
			dispatchEvent( event );
		}
		
		/** @private **/
		protected function checkIndex( index:int, maximum:int ):void 
		{
			if( index > maximum || index < 0 ) 
			{
				throw new RangeError( "DataProvider index (" + index + ") is not in acceptable range (0 - " + maximum + " )" );
			}
		}
	}
}
