package com.slantsoft.managers
{
	import com.slantsoft.events.TrackingEvent;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;

	public class TrackingManager extends EventDispatcher
	{
		private var _trackedEvents:ArrayCollection;
		
		[Bindable ('TrackedEventsChanged')]
		public function get trackedEvents():ArrayCollection{
			return _trackedEvents;
		}
		
		public function storeNewTrackedEvent(event:TrackingEvent):void{
			var description:String = event.description;
			var start:Date = event.startDate;
			var end:Date = event.endDate;
			
			saveTrackedEvent(description, start, end);
		}
		
		private function saveTrackedEvent(description:String, start:Date, end:Date):void{
			
		}
	}
}