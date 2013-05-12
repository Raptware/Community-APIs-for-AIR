package qnx.samples.bbm.views
{
	import net.rim.bbm.BBMContactStatus;
	import net.rim.bbm.BBMManager;
	import net.rim.bbm.BBMResult;
	import net.rim.bbm.BBMUserProfile;
	import net.rim.events.BBMUserProfileEvent;

	import qnx.fuse.ui.buttons.LabelButton;
	import qnx.fuse.ui.buttons.ToggleSwitch;
	import qnx.fuse.ui.core.Container;
	import qnx.fuse.ui.dialog.ToastBase;
	import qnx.fuse.ui.display.Image;
	import qnx.fuse.ui.layouts.gridLayout.GridLayout;
	import qnx.fuse.ui.listClasses.ScrollDirection;
	import qnx.fuse.ui.navigation.Page;
	import qnx.fuse.ui.text.TextInput;

	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;

	/**
	 * @author jdolce
	 */
	public class BBMProfileView extends Page
	{
		private var message_txt:TextInput;
		private var status_txt:TextInput;
		private var status_ts:ToggleSwitch;
		
		private var __profile:BBMUserProfile;
		
		private var image:Image;
		private var browse_btn:LabelButton;

		
		public function BBMProfileView()
		{
			super();
		}
	
		public function setProfile( profile:BBMUserProfile ):void
		{
			__profile = profile;

			message_txt.text = __profile.personalMessage;
			status_txt.text = __profile.personalStatus;
			trace( "profile status set to", __profile.status );
			status_ts.selected = __profile.status == BBMContactStatus.BUSY;
			
			if( __profile.profileUrl )
			{
				image.setImage( "file://" + __profile.profileUrl );
			}
			
		}
		
		
		override protected function init():void
		{
			super.init();
			
			var layout:GridLayout = new GridLayout();
			layout.spacing = 20;
			layout.padding = 20;
			
			var mainContainer:Container = new Container();
			mainContainer.scrollDirection = ScrollDirection.VERTICAL;
			
			mainContainer.layout = layout;
			
			message_txt = new TextInput();
			mainContainer.addChild( message_txt );
			
			status_ts = new ToggleSwitch();
			status_ts.addEventListener(Event.SELECT, onStatusChanged );
			status_ts.defaultLabel = "Available";
			status_ts.selectedLabel = "Busy";
			mainContainer.addChild( status_ts );
			
			status_txt = new TextInput();
			mainContainer.addChild( status_txt );

			image = new Image();
			image.fixedAspectRatio = true;
			mainContainer.addChild( image );
			
			browse_btn = new LabelButton();
			browse_btn.label = "Browse";
			browse_btn.addEventListener( MouseEvent.CLICK, onBrowse );
			mainContainer.addChild( browse_btn );
			
			content = mainContainer;
		}

		private function onUpdate( event:BBMUserProfileEvent ):void
		{
			setProfile( BBMManager.bbmManager.getUserProfile() );
		}

		private function onBrowse( event:MouseEvent ):void
		{
			var file:File = new File();
			file.addEventListener(Event.SELECT, fileSelected);
			file.browseForOpen( "open file", [new FileFilter( "Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png")] );
		}
		
		private function fileSelected( event:Event ) : void
		{			
			var file:File = File( event.target );
			var path:String = file.nativePath;
			
			trace( "file selected", path );
			
			var result:int = __profile.setProfileUrl( path );
			
			if( result == BBMResult.FAILURE )
			{
				var toast:ToastBase = new ToastBase();
				toast.message = "Picture failed to save.";
				toast.show();
			}
		}

		private function onStatusChanged( event:Event ):void
		{
			trace( "status changed", status_ts.selected );
			if( updateStatus() == BBMResult.FAILURE )
			{
				status_ts.selected = !status_ts.selected;
			}
		}
		
		private function updateStatus():int
		{
			var result:int = __profile.setStatus( status_ts.selected ? BBMContactStatus.BUSY : BBMContactStatus.AVAILABLE, status_txt.text );
			if( result == BBMResult.FAILURE )
			{
				var toast:ToastBase = new ToastBase();
				toast.message = "Status update failed.";
				toast.show();
			}
			
			return( result );
		}
		
		
		override protected function onAdded():void
		{
			super.onAdded();
			stage.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut );
			BBMManager.bbmManager.addEventListener(BBMUserProfileEvent.UPDATE, onUpdate );
		}
		
		
		override protected function onRemoved():void
		{
			super.onRemoved();
			stage.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut );
			BBMManager.bbmManager.removeEventListener(BBMUserProfileEvent.UPDATE, onUpdate );
		}

		private function onFocusOut( event:FocusEvent ):void
		{
			if( message_txt.text != __profile.personalMessage )
			{
				if( __profile.setPersonalMessage( message_txt.text ) == BBMResult.FAILURE )
				{
					var toast:ToastBase = new ToastBase();
					toast.message = "Personal message update failed.";
					toast.show();
					message_txt.text = __profile.personalMessage;
				}
			}
			
			if( status_txt.text != __profile.personalStatus )
			{
				if( updateStatus() == BBMResult.FAILURE )
				{
					status_txt.text = __profile.personalStatus;
				}
			}
		}
		

	}
}
