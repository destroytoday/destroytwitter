package com.destroytoday.destroytwitter.mediator
{
	import com.destroytoday.destroytwitter.view.components.Spinner;
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;
	
	import mx.utils.ObjectUtil;

	public class SpinnerMediator extends BaseMediator
	{
		//--------------------------------------------------------------------------
		//
		//  Injections
		//
		//--------------------------------------------------------------------------
		
		[Inject]
		public var view:Spinner;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function SpinnerMediator()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------

		override protected function stylesheetChangedHandler(stylesheet:IStyleSheet):void
		{
			styleController.applyStyle(view, stylesheet.getStyle('.Spinner'));
		}
	}
}