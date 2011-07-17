package com.destroytoday.destroytwitter.view.workspace
{
	import com.destroytoday.destroytwitter.constants.WorkspaceState;
	import com.destroytoday.destroytwitter.view.workspace.base.BaseStreamCanvas;

	public class HomeCanvas extends BaseStreamCanvas
	{
		public function HomeCanvas()
		{
			titleText = "Home";
			name = WorkspaceState.HOME;
		}
	}
}