package com.slantsoft.events
{
	import flash.events.Event;
	
	public class StatsEvent extends Event
	{
		public static const OPEN_WINDOW:String = "OpenWindowStatsEvent";
		
		public function StatsEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}