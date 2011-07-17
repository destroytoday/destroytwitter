package com.destroytoday.destroytwitter.view.workspace
{
	import com.destroytoday.destroytwitter.constants.WorkspaceState;
	import com.destroytoday.destroytwitter.view.workspace.base.BaseStreamCanvas;

	public class MentionsCanvas extends BaseStreamCanvas
	{
		public function MentionsCanvas()
		{
			title.text = "Mentions";
			name = WorkspaceState.MENTIONS;
		}
	}
}