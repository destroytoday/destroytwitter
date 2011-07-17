package com.destroytoday.destroytwitter.mediator
{
	import com.destroytoday.destroytwitter.model.AccountModuleModel;
	import com.destroytoday.destroytwitter.view.workspace.base.BaseCanvas;
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;

	public class BaseCanvasMediator extends BaseMediator
	{
		[Inject]
		public var accountModel:AccountModuleModel;
		
		private function get view():BaseCanvas
		{
			return viewComponent as BaseCanvas;
		}
		
		public function BaseCanvasMediator()
		{
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}

		override protected function stylesheetChangedHandler(stylesheet:IStyleSheet):void
		{
			styleController.applyStyle(view, stylesheet.getStyle('.BaseCanvas'));
			styleController.applyStyle(view.title, stylesheet.getStyle('.CanvasTitle'));
			styleController.applyStyle(view.scroller.thumb, stylesheet.getStyle('.ScrollerThumb'));
			styleController.applyStyle(view.scroller.track, stylesheet.getStyle('.ScrollerTrack'));
		}
	}
}