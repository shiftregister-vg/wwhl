package com.slantsoft.events
{
	import flash.events.Event;
	
	public class HistoryEvent extends Event
	{
		public static const OPEN_WINDOW:String = "OpenWindowStatsEvent";
		
		public function HistoryEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}