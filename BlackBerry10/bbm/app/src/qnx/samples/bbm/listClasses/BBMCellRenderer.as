package qnx.samples.bbm.listClasses
{
	import qnx.fuse.ui.display.Image;
	import qnx.fuse.ui.listClasses.CellRenderer;
	import qnx.samples.bbm.views.BBMPage;

	/**
	 * @author jdolce
	 */
	public class BBMCellRenderer extends CellRenderer
	{
		private var image:Image;
		
		public function BBMCellRenderer()
		{
			super();
		}
		
		
		override protected function init():void
		{
			super.init();
			
			image = new Image();
			image.cache = BBMPage.profileImageCache;
			image.fixedAspectRatio = true;
			addChild( image );
		}

		override public function set data( data:Object ):void
		{
			super.data = data;
			if( data )
			{
				setLabel( data.displayName );
				
				if( data.profileUrl )
				{
					image.setImage( "file://" + data.profileUrl );
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
