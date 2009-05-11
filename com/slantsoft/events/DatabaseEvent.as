package com.slantsoft.events
{
	import flash.data.SQLResult;
	import flash.events.Event;

	public class DatabaseEvent extends Event
	{
		public static const INIT_COMPLETE:String = "InitCompleteDatabaseEvent";
		public static const GET_TRACKED_EVENTS:String = "GetTrackedEventsDatabaseEvent";
		public static const TRACKED_EVENTS_RESULTS:String = "TrackedEventsResultDatabaseEvent";
		public static const GET_TRACKED_EVENTS_DATES:String = "GetTrackedEventsDatesDatabaseEvent";
		public static const TRACKED_EVENTS_DATES:String = "TrackedEventsDatesDatabaseEvent";
		public static const GET_TRACKED_EVENTS_BY_DATE:String = "GetTrackedEventsByDateDatabaseEvent";
		public static const TRACKED_EVENTS_BY_DATE:String = "TrackedEventsByDateDatabaseEvent";
		
		public var recordSet:SQLResult;
		
		public function DatabaseEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}