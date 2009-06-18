package com.slantsoft.managers
{
	import flash.data.SQLResult;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class ClientManager extends EventDispatcher
	{
		private var _clients:Array;
		
		[Bindable ("clientsChanged")]
		public function get clients():Array{
			return _clients;
		}
		
		public function storeClients(result:SQLResult):void{
			_clients = result.data;
			
			dispatchEvent(new Event("clientsChanged"));
		}
	}
}