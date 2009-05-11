package com.slantsoft.managers
{
	import flash.data.SQLResult;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.formatters.DateFormatter;

	public class TrackingManager extends EventDispatcher
	{
		private var _trackedEvents:Array;
		private var _trackedEventsDates:Array;
		private var _trackedEventsByDate:Array;
		private var dateFormatter:DateFormatter = new DateFormatter();
		
		[Bindable ('TrackedEventsChanged')]
		public function get trackedEvents():Array{
			return _trackedEvents;
		}
		
		public function storeTrackedEvents(result:SQLResult):void{
			var tempAC:Array = new Array();
			dateFormatter.formatString = 'L:NN:SS A';
			
			if (result.data && result.data.length > 0){
				for (var i:int = 0; i < result.data.length; i++){
					var startDateTime:Date = result.data[i].startDateTime;
					var endDateTime:Date = result.data[i].endDateTime;
					var description:String = result.data[i].description;
					var duration:String = result.data[i].duration;
					
					var trackedEvent:Object = {
												startDateTime: dateFormatter.format(startDateTime),
												endDateTime: endDateTime,
												description: description,
												duration: duration
											  };
					tempAC[i] = trackedEvent;
				}
			}
			
			_trackedEvents = tempAC;
			
			dispatchEvent(new Event('TrackedEventsChanged'));
		}
		
		[Bindable ('TrackedEventsDatesChanged')]
		public function get trackedEventsDates():Array{
			return _trackedEventsDates;
		}
		
		public function storeTrackedEventsDates(result:SQLResult):void{
			var tempArray:Array = new Array();
			if (result.data && result.data.length > 0){
				for (var i:int = 0; i < result.data.length; i++){
					tempArray[i] = {date: result.data[i].startDateTime};
				}
			}
			_trackedEventsDates = tempArray;
			dispatchEvent(new Event('TrackedEventsDatesChanged'));
		}
		
		[Bindable ('TrackedEventsByDateChanged')]
		public function get trackedEventsByDate():Array{
			return _trackedEventsByDate;
		}
		
		public function storeTrackedEventsByDate(result:SQLResult):void{
			var tempArray:Array = new Array();
			dateFormatter.formatString = 'L:NN:SS A';
			
			if (result.data && result.data.length > 0){
				for (var i:int = 0; i < result.data.length; i++){
					var startDateTime:Date = result.data[i].startDateTime;
					var endDateTime:Date = result.data[i].endDateTime;
					var description:String = result.data[i].description;
					var duration:String = result.data[i].duration;
					
					var trackedEvent:Object = {
												startDateTime: dateFormatter.format(startDateTime),
												endDateTime: endDateTime,
												description: description,
												duration: duration
											  };
											  
					tempArray[i] = trackedEvent;
				}
			}
			
			_trackedEventsByDate = tempArray;
			dispatchEvent(new Event('TrackedEventsByDateChanged'));
		}
	}
}