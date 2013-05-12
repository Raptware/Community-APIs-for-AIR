package qnx.samples.bbm.views
{
	import net.rim.bbm.BBMManager;
	import net.rim.bbm.BBMProfileBoxItem;

	import qnx.fuse.ui.actionbar.ActionPlacement;
	import qnx.fuse.ui.core.Action;
	import qnx.fuse.ui.core.ActionBase;
	import qnx.fuse.ui.core.ActionSet;
	import qnx.fuse.ui.core.Container;
	import qnx.fuse.ui.core.DeleteAction;
	import qnx.fuse.ui.core.SizeOptions;
	import qnx.fuse.ui.events.ActionEvent;
	import qnx.fuse.ui.events.ContextMenuEvent;
	import qnx.fuse.ui.layouts.Align;
	import qnx.fuse.ui.layouts.gridLayout.GridData;
	import qnx.fuse.ui.layouts.gridLayout.GridLayout;
	import qnx.fuse.ui.listClasses.List;
	import qnx.fuse.ui.listClasses.ListSelectionMode;
	import qnx.fuse.ui.listClasses.ScrollDirection;
	import qnx.fuse.ui.navigation.NavigationPaneProperties;
	import qnx.fuse.ui.navigation.Page;
	import qnx.fuse.ui.titlebar.TitleBar;
	import qnx.samples.bbm.listClasses.BBMBoxItemRenderer;

	/**
	 * @author jdolce
	 */
	public class ProfileBoxView extends Page
	{
		
		private var list:List;
		private var __addAction:Action;
		private var removeAllAction:Action;
		private var deleteAction:DeleteAction;
		
		
		[Embed(source="../../../../../assets/AddToContacts.png")]
		private var ICON:Class;
		
		public function ProfileBoxView()
		{
			super();
		}

		override protected function init():void
		{
			
			titleBar = new TitleBar();
			titleBar.title = "Profile Box Items";
			
			super.init();

			
			var layout:GridLayout = new GridLayout();
			layout.spacing = 20;
			layout.padding = 20;
			var mainContainer:Container = new Container();
			
			mainContainer.scrollDirection = ScrollDirection.VERTICAL;
			
			mainContainer.layout = layout;
			
			__addAction = new Action( "Add", ICON, null, ActionPlacement.ON_BAR );
			
			
			var a:Vector.<ActionBase> = new Vector.<ActionBase>();
			
			a.push( __addAction );
			actions = a;
			
			
			list = new List();
			list.cellRenderer = BBMBoxItemRenderer;
			list.dataProvider = BBMManager.bbmManager.profileBoxItems;

			var data:GridData = new GridData();
			data.hAlign = Align.FILL;
			data.vAlign = Align.FILL;
			data.setOptions( SizeOptions.RESIZE_HORIZONTAL );
			
			list.selectionMode = ListSelectionMode.SINGLE;
			list.layoutData = data;
			list.addEventListener( ContextMenuEvent.CLOSED, onContextMenuClosed );
			list.addEventListener(ActionEvent.ACTION_SELECTED, onListActionSelect );
			
			deleteAction = new DeleteAction( "Delete" );
			removeAllAction = new Action( "Remove All", ICON );
			var listactions:Vector.<ActionBase> = new Vector.<ActionBase>();
			listactions.push( removeAllAction );
			
			var actionset:ActionSet = new ActionSet();
			actionset.actions = listactions;
			actionset.deleteAction = deleteAction;
			
			list.contextActions = new Vector.<ActionSet>();
			list.contextActions.push(actionset);
			
			mainContainer.addChild( list );
			
			content = mainContainer;
			
			var props:NavigationPaneProperties = new NavigationPaneProperties();
			props.backButton = new Action( "Back" );
			paneProperties = props;
		}
		
		
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			trace( unscaledWidth, unscaledHeight, x, y, alpha, visible, content.width, content.height  );
		}

		private function onContextMenuClosed( event:ContextMenuEvent ):void
		{
			list.selectedIndex = -1;
		}
		private function onListActionSelect( event:ActionEvent ):void
		{
			if( list.selectedItem )
			{
				if( event.action == deleteAction )
				{
					BBMManager.bbmManager.removeProfileBoxItem( BBMProfileBoxItem( list.selectedItem ).id );
				}
				else if( event.action == removeAllAction )
				{
					BBMManager.bbmManager.removeAllProfileBoxItems();
				}
				
				list.selectedIndex = -1;
			}
			
		}

		
		override public function onActionSelected( action:ActionBase ):void
		{
			super.onActionSelected( action );
			
			if( action == __addAction )
			{
				var page:AddProfileView = new AddProfileView();
				pushPage(page);
			}
		}

		
	}
}
