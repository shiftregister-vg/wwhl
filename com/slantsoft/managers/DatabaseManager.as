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
			createTrackedEventsTable();
		}
		
		private function createTrackedEventsTable():void{
			var createSQL:SQLStatement = new SQLStatement();
			createSQL.sqlConnection = conn;
			
			var sql:String = 
				"CREATE TABLE IF NOT EXISTS trackedEvents (" +
				"	id INTEGER PRIMARY KEY AUTOINCREMENT, " +
				"	startDateTime DATETIME, " +
				"	endDateTime DATETIME, " +
				"	description TEXT, " +
				"	duration TEXT," +
				"	client_id INTEGER" +
				")";
			
			createSQL.text = sql;
			createSQL.addEventListener(SQLEvent.RESULT, checkClientIDCol);
			createSQL.addEventListener(SQLErrorEvent.ERROR, onSQLError);
			createSQL.execute();
		}
		
		private function checkClientIDCol(event:SQLEvent):void{
			var createSQL:SQLStatement = new SQLStatement();
			createSQL.sqlConnection = conn;
			
			var sql:String = "SELECT client_id FROM trackedEvents LIMIT 1";
			
			createSQL.text = sql;
			createSQL.addEventListener(SQLEvent.RESULT, createClientTable);
			createSQL.addEventListener(SQLErrorEvent.ERROR, addClientIDCol);
			createSQL.execute();
		}
		
		private function addClientIDCol(event:SQLErrorEvent):void {
			var createSQL:SQLStatement = new SQLStatement();
			createSQL.sqlConnection = conn;
			
			var sql:String = "ALTER TABLE trackedEvents ADD COLUMN client_id INTEGER";
			
			createSQL.text = sql;
			createSQL.addEventListener(SQLEvent.RESULT, checkClientIDCol);
			createSQL.addEventListener(SQLErrorEvent.ERROR, onSQLError);
			createSQL.execute();
		}
		
		private function createClientTable(event:SQLEvent=null):void{
			var createSQL:SQLStatement = new SQLStatement();
			createSQL.sqlConnection = conn;
			var sql:String =
				"CREATE TABLE IF NOT EXISTS clients (" +
				"	id INTEGER PRIMARY KEY AUTOINCREMENT, " +
				"	name TEXT, " +
				"	notes TEXT, " +
				"	billtype INTEGER" +
				")";
			
			createSQL.text = sql;
			createSQL.addEventListener(SQLEvent.RESULT, createBillTypesTable);
			createSQL.addEventListener(SQLErrorEvent.ERROR, onSQLError);
			createSQL.execute();
		}
		
		private function createBillTypesTable(event:SQLEvent=null):void{
			var createSQL:SQLStatement = new SQLStatement();
			createSQL.sqlConnection = conn;
			var sql:String =
				"CREATE TABLE IF NOT EXISTS billTypes (" +
				"	id INTEGER PRIMARY KEY AUTOINCREMENT, " +
				"	unit INTEGER, " +
				"	cost INTEGER" +
				")";
			
			createSQL.text = sql;
			createSQL.addEventListener(SQLEvent.RESULT, createWorkUnitsTable);
			createSQL.addEventListener(SQLErrorEvent.ERROR, onSQLError);
			createSQL.execute();
		}
		
		private function createWorkUnitsTable(event:SQLEvent=null):void{
			var createSQL:SQLStatement = new SQLStatement();
			createSQL.sqlConnection = conn;
			var sql:String =
				"CREATE TABLE IF NOT EXISTS workUnits (" +
				"	id INTEGER PRIMARY KEY AUTOINCREMENT, " +
				"	name TEXT" +
				")";
			
			createSQL.text = sql;
			createSQL.addEventListener(SQLEvent.RESULT, createResult);
			createSQL.addEventListener(SQLErrorEvent.ERROR, onSQLError);
			createSQL.execute();
		}
		
		private function createResult(event:SQLEvent=null):void{
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
		
		public function getClients():void{
			var selectSQL:SQLStatement = new SQLStatement();
			selectSQL.sqlConnection = conn;
			
			var sql:String =
				"SELECT " +
				"    c.id, " +
				"    c.name, " +
				"    c.notes, " +
				"    b.cost, " +
				"    w.name AS unit " +
				"FROM clients c " +
				"    LEFT OUTER JOIN billtypes b ON c.billtype = b.id " +
				"    LEFT OUTER JOIN workunits w ON b.unit = w.id " +
				"ORDER BY c.name ASC";
			
			selectSQL.addEventListener(SQLEvent.RESULT, onSelectClientsResult);
			selectSQL.addEventListener(SQLErrorEvent.ERROR, onSQLError);
			
			selectSQL.text = sql;
			
			selectSQL.execute();
		}
		
		private function onSelectClientsResult(event:SQLEvent):void{
			var e:DatabaseEvent = new DatabaseEvent(DatabaseEvent.CLIENTS);
			e.recordSet = event.currentTarget.getResult();
			dispatcher.dispatchEvent(e);
		}
		
		public function storeNewTrackedEvent(event:TrackingEvent):void{
			var description:String = event.description;
			var start:Date = event.startDate;
			var end:Date = event.endDate;
			var duration:String = event.duration;
			var client:int = event.client.id;
			
			var insertSQL:SQLStatement = new SQLStatement();
			insertSQL.sqlConnection = conn;
			
			var sql:String = 
				"INSERT INTO trackedEvents (startDateTime, endDateTime, description, duration, client_id) " +
				"VALUES (@startDate, @endDate, @description, @duration, @client_id)";
			
			insertSQL.parameters['@startDate'] = start;
			insertSQL.parameters['@endDate'] = end;
			insertSQL.parameters['@description'] = description;
			insertSQL.parameters['@duration'] = duration;
			insertSQL.parameters['@client_id'] = client;
			
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
		
		public function createClient(client:Object):void{
			var sqlStatement:SQLStatement = new SQLStatement();
			sqlStatement.sqlConnection = conn;
			
			var sql:String =
				"INSERT INTO clients (name, notes) " +
				"VALUES (@name, @notes)";
			
			sqlStatement.parameters['@name'] = client.name;
			sqlStatement.parameters['@notes'] = client.notes;
			
			sqlStatement.addEventListener(SQLEvent.RESULT,createClientComplete);
			sqlStatement.addEventListener(SQLErrorEvent.ERROR,onSQLError);
			sqlStatement.text = sql;
			sqlStatement.execute();
		}
		
		private function createClientComplete(event:SQLEvent):void{
			var sqlStatement:SQLStatement = new SQLStatement();
			sqlStatement.sqlConnection = conn;
			
			var sql:String = "SELECT last_insert_rowid() AS id";
			
			sqlStatement.addEventListener(SQLEvent.RESULT,function(event:SQLEvent):void{
				var e:DatabaseEvent = new DatabaseEvent(DatabaseEvent.CREATE_CLIENT_COMPLETE);
				dispatchLastID(event.currentTarget.getResult(),e);
			});
			sqlStatement.addEventListener(SQLErrorEvent.ERROR,onSQLError);
			
			sqlStatement.text = sql;
			sqlStatement.execute();
		}
		
		private function dispatchLastID(sqlResult:Object, dbEvent:DatabaseEvent):void{
			dbEvent.lastRowID = sqlResult.data[0].id;
			dispatcher.dispatchEvent(dbEvent);
		}
		
		public function updateClient(client:Object):void{
			var sqlStatement:SQLStatement = new SQLStatement();
			sqlStatement.sqlConnection = conn;
			
			var sql:String =
				"UPDATE clients " +
				"SET	name = @name, " +
				"		notes = @notes " +
				"WHERE id = @id";
			
			sqlStatement.parameters['@name'] = client.name;
			sqlStatement.parameters['@notes'] = client.notes;
			sqlStatement.parameters['@id'] = client.id;
			
			sqlStatement.addEventListener(SQLEvent.RESULT,function(event:SQLEvent):void{
				dispatcher.dispatchEvent(new DatabaseEvent(DatabaseEvent.UPDATE_CLIENT_COMPLETE));
			});
			
			sqlStatement.addEventListener(SQLErrorEvent.ERROR,onSQLError);
			sqlStatement.text = sql;
			sqlStatement.execute();
		}
		
		public function deleteClient(client:Object):void{
			var sqlStatement:SQLStatement = new SQLStatement();
			sqlStatement.sqlConnection = conn;
			
			var sql:String = "DELETE FROM clients WHERE id = @id";
			
			sqlStatement.parameters['@id'] = client.id;
			
			sqlStatement.addEventListener(SQLEvent.RESULT,function(event:SQLEvent):void{
				var e:DatabaseEvent = new DatabaseEvent(DatabaseEvent.DELETE_CLIENT_COMPLETE);
				e.client = client;
				dispatcher.dispatchEvent(e);
			});
			
			sqlStatement.addEventListener(SQLErrorEvent.ERROR,onSQLError);
			
			sqlStatement.text = sql;
			sqlStatement.execute();
		}
		
		public function deleteClientTrackedEvents(client:Object):void{
			var sqlStatement:SQLStatement = new SQLStatement();
			sqlStatement.sqlConnection = conn;
			
			var sql:String = "DELETE FROM trackedevents WHERE client_id = @client_id";
			
			sqlStatement.parameters['@client_id'] = client.id;
			
			sqlStatement.addEventListener(SQLEvent.RESULT,function(event:SQLEvent):void{
				dispatcher.dispatchEvent(new DatabaseEvent(DatabaseEvent.DELETE_CLIENT_EVENTS_COMPLETE));
			});
			
			sqlStatement.addEventListener(SQLErrorEvent.ERROR,onSQLError);
			
			sqlStatement.text = sql;
			sqlStatement.execute();
		}
		
		public function getHistoryDatesByClient(client:Object):void{
			var selectSQL:SQLStatement = new SQLStatement();
			selectSQL.sqlConnection = conn;
			
			var sql:String = 
				"SELECT DISTINCT STRFTIME('%m-%d-%Y',startDateTime) AS startDateTime " + 
				"FROM trackedEvents " + 
				"WHERE client_id = @client_id " +
				"ORDER BY startDateTime DESC";
			
			selectSQL.parameters['@client_id'] = client.id;
			
			selectSQL.addEventListener(SQLEvent.RESULT, onSelectHistoryDates);
			selectSQL.addEventListener(SQLErrorEvent.ERROR,onSQLError);
			
			selectSQL.text = sql;
			
			selectSQL.execute();
		}
		
		public function getHistoryByDateAndClient(dateString:String, client:Object):void{
			var selectSQL:SQLStatement = new SQLStatement();
			selectSQL.sqlConnection = conn;
			
			var sql:String = 
				"SELECT id, startDateTime, endDateTime, description, duration " + 
				"FROM trackedEvents " + 
				"WHERE STRFTIME('%m-%d-%Y',startDateTime) = @dateString " + 
				"	AND client_id = @client_id " +
				"ORDER BY startDateTime DESC";
			
			selectSQL.parameters['@dateString'] = dateString;
			selectSQL.parameters['@client_id'] = client.id;
			
			selectSQL.addEventListener(SQLEvent.RESULT, onSelectHistoryByDate);
			selectSQL.addEventListener(SQLErrorEvent.ERROR,onSQLError);
			
			selectSQL.text = sql;
			
			selectSQL.execute();
		}
	}
}