package qnx.samples.bbm.listClasses
{
	import net.rim.bbm.BBMProfileBoxItem;

	import qnx.fuse.ui.display.Image;
	import qnx.fuse.ui.listClasses.CellRenderer;
	import qnx.samples.bbm.images.BBMProfileBoxIcons;
	import qnx.samples.bbm.views.BBMPage;

	/**
	 * @author jdolce
	 */
	public class BBMBoxItemRenderer extends CellRenderer
	{
		
		private var image:Image;
		
		public function BBMBoxItemRenderer()
		{
			super();
		}
		
		override protected function init():void
		{
			super.init();
			
			image = new Image();
			image.cache = BBMPage.profileBoxCache;
			image.fixedAspectRatio = true;
			addChild( image );
		}

		override public function set data( data:Object ):void
		{
			super.data = data;
			if( data )
			{
				var item:BBMProfileBoxItem = data as BBMProfileBoxItem;
				
				setLabel( item.text );
				
				
				
				if( item.iconId > 0 )
				{
	
					var icon:BBMProfileBoxIcons = BBMProfileBoxIcons( BBMPage.icons[item.iconId] );
					if( icon )
					{
						image.setImage( "file://" + icon.path );
					}
					else
					{
						if( item.iconUrl )
						{
							image.setImage( "file://" + item.iconUrl );
						}
						else
						{
							image.setImage(null);
							item.retrieveIcon();
						}
					}
				}
				else
				{
					image.setImage(null);
				}
			}
		}

		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			image.width = image.height = unscaledHeight;
			label.x = image.x + image.width + paddingLeft;
			label.width = unscaledWidth - label.x;
		}
	}
}
