package com.destroytoday.destroytwitter.view.workspace
{
	import com.destroytoday.destroytwitter.view.workspace.base.BaseCanvasGroup;

	public class InfoCanvasGroup extends BaseCanvasGroup
	{
		public var preferencesCanvas:PreferencesCanvas;
		
		public function InfoCanvasGroup()
		{
			preferencesCanvas = addChild(new PreferencesCanvas()) as PreferencesCanvas;
		}
	}
}