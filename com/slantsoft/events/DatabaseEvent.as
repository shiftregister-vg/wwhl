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
		public static const GET_TRACKED_EVENTS_DATES_BY_CLIENT:String = "GetTrackedEventsDatesByClientDatabaseEvent";
		public static const GET_CLIENTS:String = "GetClientsDatabaseEvent";
		public static const CLIENTS:String = "ClientsDatabaseEvent";
		public static const UPDATE_CLIENT:String = "UpdateClientDatabaseEvent";
		public static const CREATE_CLIENT:String = "CreateClientDatabaseEvent";
		public static const UPDATE_CLIENT_COMPLETE:String = "UpdateClientCompleteDatabaseEvent";
		public static const CREATE_CLIENT_COMPLETE:String = "CreateClientCompleteDatabaseEvent";
		public static const DELETE_CLIENT:String = "DeleteClientDatabaseEvent";
		public static const DELETE_CLIENT_COMPLETE:String = "DeleteClientCompleteDatabaseEvent";
		public static const DELETE_CLIENT_EVENTS:String = "DeleteClientEventsDatabaseEvent";
		public static const DELETE_CLIENT_EVENTS_COMPLETE:String = "DeleteClientEventsCompleteDatabaseEvent";
		
		public var recordSet:SQLResult;
		public var client:Object;
		public var lastRowID:int;
		
		public function DatabaseEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}