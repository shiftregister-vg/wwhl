package com.slantsoft.managers
{
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;

	public class TrackingManager extends EventDispatcher
	{
		private var _trackedEvents:ArrayCollection;
		
		[Bindable ('TrackedEventsChanged')]
		public function get trackedEvents():ArrayCollection{
			return _trackedEvents;
		}
	}
}