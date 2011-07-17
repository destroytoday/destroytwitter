package com.destroytoday.destroytwitter.view.drawer
{
	import com.destroytoday.destroytwitter.view.workspace.TwitterElement;
	
	import flash.display.Graphics;

	public class DialogueElement extends TwitterElement
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function DialogueElement()
		{
			userIconButton.x = 8.0;
			userIconButton.y = 8.0;
			
			autoSize = false;
			actionsEnabled = true;
			
			width = 326.0;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Invalidation
		//
		//--------------------------------------------------------------------------
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			var graphics:Graphics = this.graphics;
			
			graphics.clear();
			graphics.beginFill(0xFF0099, 0.0);
			graphics.drawRect(0.0, 0.0, width, height);
			graphics.endFill();
		}
	}
}