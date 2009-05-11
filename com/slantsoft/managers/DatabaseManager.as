package com.slantsoft.managers
{
	import com.asfusion.mate.events.Dispatcher;
	import com.slantsoft.events.DatabaseEvent;
	import com.slantsoft.events.TrackingEvent;
	
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.events.EventDispatcher;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;

	public class DatabaseManager extends EventDispatcher
	{
		private var dispatcher:Dispatcher = new Dispatcher();
		private var conn:SQLConnection = new SQLConnection();
		private var dbFile:File = File.applicationStorageDirectory.resolvePath('wwhl.db');
		
		public function initDatabase():void{
			conn.addEventListener(SQLEvent.OPEN, onDBOpen);
			conn.addEventListener(SQLErrorEvent.ERROR, onSQLError);
			
			conn.openAsync(dbFile);
		}
		
		private function onDBOpen(event:SQLEvent):void{
			createTables();
		}
		
		private function createTables():void{
			var createSQL:SQLStatement = new SQLStatement();
			createSQL.sqlConnection = conn;
			
			var sql:String = 
				"CREATE TABLE IF NOT EXISTS trackedEvents (" +
				"	id INTEGER PRIMARY KEY AUTOINCREMENT, " +
				"	startDateTime DATETIME, " +
				"	endDateTime DATETIME, " +
				"	description TEXT, " +
				"	duration TEXT" +
				")";
			
			createSQL.text = sql;
			
			createSQL.addEventListener(SQLEvent.RESULT, createResult);
			createSQL.addEventListener(SQLErrorEvent.ERROR, onSQLError);
			
			createSQL.execute();
		}
		
		private function createResult(event:SQLEvent):void{
			dispatcher.dispatchEvent(new DatabaseEvent(DatabaseEvent.INIT_COMPLETE));
		}
		
		private function onSQLError(event:SQLErrorEvent):void{
			trace('Error message:',event.error.message);
			trace('detail:',event.error.details);
		}
		
		public function getTrackedEvents(startDate:Date):void{
			var selectSQL:SQLStatement = new SQLStatement();
			selectSQL.sqlConnection = conn;
			
			var sql:String = 
				"SELECT " +
				"	id, " +
				"	startDateTime, " +
				"	endDateTime, " +
				"	description, " +
				"	duration " +
				"FROM trackedEvents " +
				"WHERE startDateTime >= @startDate " +
				"ORDER BY startDateTime DESC";
			
			selectSQL.parameters['@startDate'] = startDate;
			
			selectSQL.addEventListener(SQLEvent.RESULT, onSelectTrackedEventsResult);
			selectSQL.addEventListener(SQLErrorEvent.ERROR, onSQLError);
			
			selectSQL.text = sql;
			
			selectSQL.execute();
		}
		
		private function onSelectTrackedEventsResult(event:SQLEvent):void{
			var e:DatabaseEvent = new DatabaseEvent(DatabaseEvent.TRACKED_EVENTS_RESULTS);
			e.recordSet = event.currentTarget.getResult();
			
			dispatcher.dispatchEvent(e);
		}
		
		public function storeNewTrackedEvent(event:TrackingEvent):void{
			var description:String = event.description;
			var start:Date = event.startDate;
			var end:Date = event.endDate;
			var duration:String = event.duration;
			
			var insertSQL:SQLStatement = new SQLStatement();
			insertSQL.sqlConnection = conn;
			
			var sql:String = 
				"INSERT INTO trackedEvents (startDateTime, endDateTime, description, duration) " +
				"VALUES (@startDate, @endDate, @description, @duration)";
			
			insertSQL.parameters['@startDate'] = start;
			insertSQL.parameters['@endDate'] = end;
			insertSQL.parameters['@description'] = description;
			insertSQL.parameters['@duration'] = duration;
			
			insertSQL.addEventListener(SQLEvent.RESULT, onInsert);
			insertSQL.addEventListener(SQLErrorEvent.ERROR, onSQLError);
			
			insertSQL.text = sql;
			
			insertSQL.execute();
		}
		
		private function onInsert(event:SQLEvent):void{
			dispatcher.dispatchEvent(new DatabaseEvent(DatabaseEvent.GET_TRACKED_EVENTS));
		}
		
		public function getHistoryDates():void{
			var selectSQL:SQLStatement = new SQLStatement();
			selectSQL.sqlConnection = conn;
			
			var sql:String = 
				"SELECT DISTINCT STRFTIME('%m-%d-%Y',startDateTime) AS startDateTime FROM trackedEvents ORDER BY startDateTime DESC";
				
			selectSQL.addEventListener(SQLEvent.RESULT, onSelectHistoryDates);
			selectSQL.addEventListener(SQLErrorEvent.ERROR,onSQLError);
			
			selectSQL.text = sql;
			
			selectSQL.execute();
		}
		
		private function onSelectHistoryDates(event:SQLEvent):void{
			var e:DatabaseEvent = new DatabaseEvent(DatabaseEvent.TRACKED_EVENTS_DATES);
			e.recordSet = event.currentTarget.getResult();
			dispatcher.dispatchEvent(e);
		}
		
		public function getHistoryByDate(dateString:String):void{
			var selectSQL:SQLStatement = new SQLStatement();
			selectSQL.sqlConnection = conn;
			
			var sql:String = 
				"SELECT id, startDateTime, endDateTime, description, duration " + 
				"FROM trackedEvents " + 
				"WHERE STRFTIME('%m-%d-%Y',startDateTime) = @dateString " + 
				"ORDER BY startDateTime DESC";
			
			selectSQL.parameters['@dateString'] = dateString;
			
			selectSQL.addEventListener(SQLEvent.RESULT, onSelectHistoryByDate);
			selectSQL.addEventListener(SQLErrorEvent.ERROR,onSQLError);
			
			selectSQL.text = sql;
			
			selectSQL.execute();
		}
		
		private function onSelectHistoryByDate(event:SQLEvent):void{
			var e:DatabaseEvent = new DatabaseEvent(DatabaseEvent.TRACKED_EVENTS_BY_DATE);
			e.recordSet = event.currentTarget.getResult();
			dispatcher.dispatchEvent(e);
		}
	}
}