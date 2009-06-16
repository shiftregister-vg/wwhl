package com.slantsoft.events
{
	import flash.events.Event;
	
	public class ClientManagerEvent extends Event
	{
		public static const OPEN:String = "OpenClientManagerEvent";
		
		public function ClientManagerEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}