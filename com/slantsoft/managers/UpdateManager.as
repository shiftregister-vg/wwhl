package com.slantsoft.managers
{
	import com.asfusion.mate.events.Dispatcher;
	import com.slantsoft.events.UpdateEvent;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class UpdateManager extends EventDispatcher
	{
		private var dispatcher:Dispatcher = new Dispatcher();
		private var appXML:XML = NativeApplication.nativeApplication.applicationDescriptor;
		private var ns:Namespace = appXML.namespace();
		private var version:String = appXML.ns::version;
		private var url:String = 'http://slantsoft.com/';
		private var _appData:Object;
		
		public function checkForUpdate():void{
			var e:UpdateEvent = new UpdateEvent(UpdateEvent.GET_REMOTE_APP_DATA);
			this.dispatcher.dispatchEvent(e);
		}
		
		public function storeAppData(value:Object):void{
			_appData = value;
			dispatchEvent(new Event("appDataChanged"));
			compareVersions();
		}
		
		[Bindable ("appDataChanged")]
		public function get appData():Object{
			return _appData;
		}
		
		private function compareVersions():void{
			if (appData.version > version){
				// the current version is older than the remote version, we should preform the update
				var e:UpdateEvent = new UpdateEvent(UpdateEvent.OPEN_UPDATE_WINDOW);
				e.appData = appData;
				this.dispatcher.dispatchEvent(e);
			}
		}
	}
}