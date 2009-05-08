package com.slantsoft.events
{
	import flash.events.Event;
	
	public class TrackingEvent extends Event
	{
		public static const START:String = "StartTrackingEvent";
		public static const STOP:String = "StopTrackingEvent";
		
		public var description:String;
		
		public function TrackingEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}