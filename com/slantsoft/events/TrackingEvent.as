package com.slantsoft.events
{
	import flash.events.Event;
	
	public class TrackingEvent extends Event
	{
		public static const START:String = "StartTrackingEvent";
		public static const STOP:String = "StopTrackingEvent";
		public static const GET_TRACKED_EVENTS_BY_DATE:String = "GetTrackedEventsByDateTrackingEvent";
		public static const GET_TRACKED_EVENTS_BY_CLIENT:String = "GetTrackedEventsByClientTrackingEvent";
		
		public var description:String;
		public var startDate:Date;
		public var endDate:Date;
		public var duration:String;
		public var client:Object;
		
		public var dateString:String;
		
		public function TrackingEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}