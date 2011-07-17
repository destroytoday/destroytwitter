package com.destroytoday.destroytwitter.manager
{
	import com.destroytoday.pool.ObjectWaterpark;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Quartic;
	
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;

	public class TweenManager
	{
		//--------------------------------------------------------------------------
		//
		//  Signals
		//
		//--------------------------------------------------------------------------
		
		public const activeTweensChanged:Signal = new Signal(int); // activeTweens
		
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		protected static var _instance:TweenManager;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var targetMap:Dictionary = new Dictionary(true);
		
		protected var _activeTweens:int;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function TweenManager()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get activeTweens():int
		{
			return _activeTweens;
		}
		
		public function set activeTweens(value:int):void
		{
			var oldActiveTweens:int = _activeTweens;
			
			_activeTweens = value;

			if (_activeTweens > oldActiveTweens && _activeTweens == 1 ||
				_activeTweens < oldActiveTweens && _activeTweens == 0)
			{
				activeTweensChanged.dispatch(_activeTweens);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Static Methods
		//
		//--------------------------------------------------------------------------
		
		public static function getInstance():TweenManager
		{
			if (!_instance)
			{
				_instance = new TweenManager();
			}
			
			return _instance;
		}
		
		public static function to(target:Object, values:Object, duration:Number = 0.75, easing:Function = null, onComplete:Function = null):GTween
		{
			var tween:GTween;
			
			if (getInstance().targetMap[target])
			{
				tween = getInstance().targetMap[target];
			}
			else
			{
				++getInstance().activeTweens;

				tween = ObjectWaterpark.getObject(GTween) as GTween;
				
				getInstance().targetMap[target] = tween;
			}
			
			tween.target = target;
			tween.duration = duration;
			tween.ease = easing || Quartic.easeInOut;
			tween.onComplete = onComplete || getInstance().tweenCompleteHandler;
			tween.resetValues(values);
			
			return tween;
		}
		
		public static function disposeTween(tween:GTween):void
		{
			delete getInstance().targetMap[tween.target];
			
			ObjectWaterpark.disposeObject(tween);
			
			--getInstance().activeTweens;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		public function tweenCompleteHandler(tween:GTween):void
		{
			disposeTween(tween);
		}
	}
}