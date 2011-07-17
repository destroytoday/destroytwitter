package com.destroytoday.destroytwitter.view.components
{
	import com.destroytoday.display.SpritePlus;
	
	public class MiniScroller extends SpritePlus
	{
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		public var thumb:MiniScrollerThumb;
		
		public var track:MiniScrollerTrack;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function MiniScroller()
		{
			//--------------------------------------
			//  instantiate children
			//--------------------------------------
			
			track = addChild(new MiniScrollerTrack()) as MiniScrollerTrack;
			thumb = addChild(new MiniScrollerThumb()) as MiniScrollerThumb;
			
			//--------------------------------------
			//  set properties
			//--------------------------------------
			
			width = 6.0;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Invalidation
		//
		//--------------------------------------------------------------------------
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();

			thumb.width = width;
			thumb.height = int(height * 0.35);
			track.width = width;
			track.height = height;
		}
	}
}