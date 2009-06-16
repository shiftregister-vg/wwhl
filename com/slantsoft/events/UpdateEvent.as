package com.slantsoft.events
{
	import flash.events.Event;
	
	public class UpdateEvent extends Event
	{
		public static const CHECK_FOR_UPDATE:String = "CheckForUpdateUpdateEvent";
		public static const GET_REMOTE_APP_DATA:String = "GetRemoteAppDataUpdateEvent";
		public static const OPEN_UPDATE_WINDOW:String = "OpenUpdateWindowUpdateEvent";
		
		public var appData:Object;
		
		public function UpdateEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}