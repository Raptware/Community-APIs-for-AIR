package qnx.samples.bbm.views
{
	import net.rim.bbm.BBMManager;

	import qnx.fuse.ui.buttons.RadioButton;
	import qnx.fuse.ui.core.Action;
	import qnx.fuse.ui.core.ActionBase;
	import qnx.fuse.ui.core.Container;
	import qnx.fuse.ui.events.ActionEvent;
	import qnx.fuse.ui.layouts.gridLayout.GridLayout;
	import qnx.fuse.ui.listClasses.ScrollDirection;
	import qnx.fuse.ui.navigation.Page;
	import qnx.fuse.ui.text.Label;
	import qnx.fuse.ui.text.TextInput;
	import qnx.fuse.ui.titlebar.TitleBar;

	/**
	 * @author jdolce
	 */
	public class AddProfileView extends Page
	{
		
		private var text_txt:TextInput;
		private var cookie_txt:TextInput;
		private var icon1_rb:RadioButton;
		private var icon2_rb:RadioButton;
		private var icon3_rb:RadioButton;

		
		public function AddProfileView()
		{
			super();
		}

		override protected function init():void
		{

			super.init();
			
			titleBar = new TitleBar();
			titleBar.title = "Add Profile Box Item";
			titleBar.addEventListener(ActionEvent.ACTION_SELECTED, onTitleBarActionSelected );

			titleBar.acceptAction = new Action( "Add" );
			titleBar.dismissAction = new Action( "Cancel" );

			var layout:GridLayout = new GridLayout();
			layout.spacing = 20;
			layout.padding = 20;
			
			
			var mainContainer:Container = new Container();
			mainContainer.scrollDirection = ScrollDirection.VERTICAL;
			
			
			mainContainer.layout = layout;
			
			text_txt = new TextInput();
			text_txt.prompt = "Text";
			mainContainer.addChild( text_txt );
			
			cookie_txt = new TextInput();
			cookie_txt.prompt = "Cookie";
			mainContainer.addChild( cookie_txt );
			
			var label:Label = new Label();
			label.text = "Icon";
			mainContainer.addChild( label );
			
			icon1_rb = new RadioButton();
			icon1_rb.label = "Icon Id 101";
			mainContainer.addChild( icon1_rb );
			
			icon2_rb = new RadioButton();
			icon2_rb.label = "Icon Id 102";
			mainContainer.addChild( icon2_rb );
			
			icon3_rb = new RadioButton();
			icon3_rb.label = "Icon Id 103";
			mainContainer.addChild( icon3_rb );
			
			content = mainContainer;
		}
		
		private function getIconId():int
		{
			var id:int;
			
			if( icon1_rb.selected )
			{
				id = 101;
			}
			else if( icon2_rb.selected )
			{
				id = 102;
			}
			else if( icon3_rb.selected )
			{
				id = 103;
			}
			
			return( id );
		}
		
		private function onTitleBarActionSelected( event:ActionEvent ):void
		{
			if( event.action == titleBar.acceptAction )
			{
				BBMManager.bbmManager.addProfileBoxItem( text_txt.text, cookie_txt.text, getIconId() );
			}
			
			popAndDeletePage();
		}

	}
}
