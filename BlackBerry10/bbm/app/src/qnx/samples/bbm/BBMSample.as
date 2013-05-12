package qnx.samples.bbm
{
	import qnx.fuse.ui.Application;
	import qnx.fuse.ui.navigation.NavigationPane;
	import qnx.samples.bbm.views.BBMPage;

	public class BBMSample extends Application
	{
		public function BBMSample()
		{
			
		}

		override protected function onAdded():void
		{
			super.onAdded();
			var pane:NavigationPane = new NavigationPane();
			pane.push( new BBMPage() );
			
			scene = pane;
			
		}

	}
}
