package qnx.samples.bbm.views
{
	import net.rim.bbm.BBMUserProfile;
	import qnx.fuse.ui.actionbar.ActionPlacement;
	import net.rim.bbm.BBMContactUpdateTypes;
	import net.rim.bbm.BBMManager;
	import net.rim.events.BBMContactEvent;
	import net.rim.events.BBMRegisterEvent;
	import net.rim.events.BBMUserProfileEvent;

	import qnx.fuse.ui.buttons.LabelButton;
	import qnx.fuse.ui.core.Action;
	import qnx.fuse.ui.core.ActionBase;
	import qnx.fuse.ui.core.Container;
	import qnx.fuse.ui.core.SizeOptions;
	import qnx.fuse.ui.layouts.Align;
	import qnx.fuse.ui.layouts.gridLayout.GridData;
	import qnx.fuse.ui.layouts.gridLayout.GridLayout;
	import qnx.fuse.ui.listClasses.List;
	import qnx.fuse.ui.listClasses.ScrollDirection;
	import qnx.fuse.ui.navigation.Page;
	import qnx.fuse.ui.text.Label;
	import qnx.fuse.ui.utils.ImageCache;
	import qnx.samples.bbm.images.BBMProfileBoxIcons;
	import qnx.samples.bbm.listClasses.BBMCellRenderer;

	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.utils.Dictionary;




	/**
	 * @author jdolce
	 */
	public class BBMPage extends Page
	{
		
		private var register_btn:LabelButton;
		private var bbm:BBMManager;
		private var list:List;
		private var userTitle:UserTitle;
		
		static public var profileImageCache:ImageCache;
		static public var profileBoxCache:ImageCache;
		static public var icons:Dictionary = new Dictionary( true );
		
		[Embed(source="../../../../../assets/AddToContacts.png")]
		private var ICON:Class;
		
		
		private var __profileBoxAction:Action;
		
		public function BBMPage()
		{
			super();
		}

		override protected function onAdded():void
		{
			super.onAdded();
			
			profileImageCache = new ImageCache();
			profileBoxCache = new ImageCache();
			
			var mainContainer:Container = new Container();
			mainContainer.scrollDirection = ScrollDirection.VERTICAL;
			
			var layout:GridLayout = new GridLayout();
			mainContainer.layout = layout;
			
			content = mainContainer;
			var icon:Bitmap = new ICON();

			
			__profileBoxAction = new Action( "Profile Box", icon, null, ActionPlacement.ON_BAR );
			//__profileBoxAction.enabled = false;
			var a:Vector.<ActionBase> = new Vector.<ActionBase>();
			
			a.push( __profileBoxAction );
			actions = a;
			
			bbm = BBMManager.bbmManager;
			
			trace( "VERSION:", bbm.version );
			
			bbm.addEventListener( BBMRegisterEvent.SUCCESS, onRegisterSuccess );
			bbm.addEventListener( BBMRegisterEvent.PENDING, onRegisterPending );
			bbm.addEventListener( BBMRegisterEvent.UNREGISTERED, unRegistered );
			bbm.addEventListener( BBMRegisterEvent.DENIED, onRegisterDenied );
			
			bbm.addEventListener( BBMContactEvent.CONTACT_LIST, onContactList );
			bbm.addEventListener( BBMContactEvent.CONTACT_UPDATE, onContactUpdate );

		}
		
		
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			trace( unscaledWidth, unscaledHeight );
		}


		private function onRegisterDenied( event:BBMRegisterEvent ):void
		{
			var label:Label = new Label();
			label.text = "Access to BBM is denied";
			content.addChild( label );
		}

		private function onProfileUpdate( event:BBMUserProfileEvent ):void
		{
			trace( "PROFILE UPDATE" );
			userTitle.setUserProfile( bbm.getUserProfile() );
		}

		private function onContactUpdate( event:BBMContactEvent ):void
		{
			if( event.updateType == BBMContactUpdateTypes.DISPLAY_PICTURE )
			{
				profileImageCache.reloadImage( event.contact.profileUrl );	
			}
		}
		
		private function createList():void
		{
			if( list == null )
			{
				list = new List();
				list.cellRenderer = BBMCellRenderer;
				
				var data:GridData = new GridData();
				data.hAlign = Align.FILL;
				data.vAlign = Align.FILL;
				data.setOptions( SizeOptions.RESIZE_HORIZONTAL );
				
				list.layoutData = data;
				content.addChild( list );
			}
		}
		

		private function onContactList( event:BBMContactEvent ):void
		{
			createList();
			list.dataProvider = BBMManager.bbmManager.contacts;
		}

		private function unRegistered( event:BBMRegisterEvent ):void
		{
			trace( "Unregistered" );
			register_btn = new LabelButton();
			register_btn.label = "Register";
			register_btn.addEventListener( MouseEvent.CLICK, onRegisterClick );
			content.addChild( register_btn );
		}

		private function onRegisterPending( event:BBMRegisterEvent ):void
		{
			trace( "on register pending" );
		}
		
		private function createUserTitle():void
		{
			if( userTitle == null )
			{
				userTitle = new UserTitle();
				content.addChild( userTitle );
				userTitle.addEventListener( MouseEvent.CLICK, onTitleClicked );
			}
		}

		private function onTitleClicked( event:MouseEvent ):void
		{
			
			var view:BBMProfileView = new BBMProfileView();
			view.setProfile(bbm.getUserProfile());
			pushPage( view );
			
		}
		
		private function onRegisterSuccess( event:BBMRegisterEvent ):void
		{
			trace( "registered" );
			
			if( register_btn )
			{
				if( content.contains( register_btn ) )
				{
					content.removeChild( register_btn );
				}
			}
			
			
			createUserTitle();
			
			var profile:BBMUserProfile = bbm.getUserProfile();
			
			if( profile )
			{
				userTitle.setUserProfile( profile );
			}
			bbm.addEventListener( BBMUserProfileEvent.UPDATE, onProfileUpdate );
			
			registerIcons();
			bbm.getUserProfile();
			
			__profileBoxAction.enabled = true;

		}
		
		
		override public function onActionSelected( action:ActionBase ):void
		{
			if( action == __profileBoxAction )
			{
				var view:ProfileBoxView = new ProfileBoxView();
				pushPage(view);
				return;
			}

			super.onActionSelected( action );
		}

		
		private function registerIcons():void
		{
			icons[101] = new BBMProfileBoxIcons( File.applicationDirectory.resolvePath("assets/apple.png").nativePath, 101 );
			icons[102] = new BBMProfileBoxIcons( File.applicationDirectory.resolvePath("assets/orange.png").nativePath, 102 );
			icons[103] = new BBMProfileBoxIcons( File.applicationDirectory.resolvePath("assets/pear.png").nativePath, 103 );
			
			
			if( bbm.canShowProfileBox() )
			{				
				for each( var icon:BBMProfileBoxIcons in icons )
				{
					var rc:int = bbm.registerIcon( icon.path, icon.id );
					trace( "register icon id", icon.id, rc );
				}
			}
		}

		private function onRegisterClick( event:MouseEvent ):void
		{
			
			bbm.registerApplication( "27a3375d-fd81-451c-b290-aac81e06f114" );
		}

	}
}
import net.rim.bbm.BBMUserProfile;

import qnx.fuse.ui.display.Image;
import qnx.fuse.ui.titlebar.TitleBar;



class UserTitle extends TitleBar
{

	private var image:Image;
	
	
	public function UserTitle()
	{
		
	}

	override protected function init():void
	{
		super.init();
		
		mouseChildren = false;
		
		image = new Image();
		image.fixedAspectRatio = true;
		addChild( image );
	}
	
	public function setUserProfile( profile:BBMUserProfile ):void
	{
		if( profile.profileUrl )
		{
			image.setImage( "file://" + profile.profileUrl );
		}
		
		title = profile.displayName;
		
	}

	override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
	{
		hPadding += unscaledHeight;
		super.updateDisplayList( unscaledWidth, unscaledHeight );
		image.width = image.height = unscaledHeight;
	}


}
