package com.destroytoday.destroytwitter.controller
{
	import com.destroytoday.destroytwitter.model.AlertModel;
	import com.destroytoday.destroytwitter.model.vo.AlertMessageVO;
	import com.destroytoday.destroytwitter.signals.ApplicationSignalBus;
	import com.destroytoday.pool.ObjectWaterpark;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	public class AlertController
	{
		[Inject]
		public var signalBus:ApplicationSignalBus;
		
		[Inject]
		public var model:AlertModel;
		
		protected var timer:Timer = new Timer(1000.0);
		
		public function AlertController()
		{
		}
		
		public function addMessage(source:String, text:String, duration:int = 3000):void
		{
			var message:AlertMessageVO = ObjectWaterpark.getObject(AlertMessageVO) as AlertMessageVO;
			
			if (source) text = source + ": " + text;
			message.text = text;
			message.startTime = getTimer();
			message.duration = duration;

			model.messageList[model.messageList.length] = message;
			
			model.summary += (model.summary ? "<p></p>" : "") + "<p class=\"alertMessage\">" + message.text + "</p>";

			if (!timer.running && duration != -1) {
				timer.addEventListener(TimerEvent.TIMER, timerHandler);
				
				timer.reset();
				timer.start();
			}
			
			signalBus.alertChanged.dispatch(model.summary);
		}
		
		public function close():void
		{
			timer.removeEventListener(TimerEvent.TIMER, timerHandler);
			timer.stop();
			
			for each (var message:AlertMessageVO in model.messageList) {
				ObjectWaterpark.disposeObject(message);
			}
			
			model.summary = "";
			model.messageList.length = 0;
			
			signalBus.alertClosed.dispatch();
		}
		
		protected function timerHandler(event:TimerEvent):void
		{
			var message:AlertMessageVO;
			var changed:Boolean, continueTimer:Boolean;
			
			var m:uint = model.messageList.length;
			var time:int = getTimer();
			model.summary = "";

			for (var i:uint = 0; i < m; ++i) {
				message = model.messageList[i];
				
				if (message.duration != -1 && message.startTime + message.duration < time) {
					model.messageList.splice(model.messageList.indexOf(message), 1);
					
					ObjectWaterpark.disposeObject(message);
					
					--i;
					--m;
					changed = true;
				} else {
					if (message.duration != -1) continueTimer = true;
					
					model.summary += (model.summary ? "<p></p>" : "") + "<p class=\"alertMessage\">" + message.text + "</p>";
				}
			}
			
			if (!model.summary) {
				close();
			} else if (changed) {
				signalBus.alertChanged.dispatch(model.summary);
				
				if (!continueTimer) {
					timer.removeEventListener(TimerEvent.TIMER, timerHandler);
					timer.stop();
				}
			}
		}
	}
}