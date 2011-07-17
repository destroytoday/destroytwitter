package com.destroytoday.destroytwitter.mediator
{
	import com.destroytoday.destroytwitter.view.workspace.InfoCanvasGroup;

	public class InfoCanvasGroupMediator extends BaseCanvasGroupMediator
	{
		[Inject]
		public var view:InfoCanvasGroup;
		
		public function InfoCanvasGroupMediator()
		{
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}
	}
}