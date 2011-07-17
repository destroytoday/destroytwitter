package com.destroytoday.destroytwitter.view.workspace
{
	import com.destroytoday.destroytwitter.constants.WorkspaceState;
	import com.destroytoday.destroytwitter.view.workspace.base.BaseStreamCanvas;

	public class MessagesCanvas extends BaseStreamCanvas
	{
		public function MessagesCanvas()
		{
			title.text = "Messages";
			name = WorkspaceState.MESSAGES;
		}
	}
}