package com.slantsoft.managers
{
	import com.slantsoft.views.StatsWindow;
	
	import flash.events.EventDispatcher;

	public class NativeWindowManager extends EventDispatcher
	{
		private var statsWindow:StatsWindow;
		
		public function openStatsWindow():void{
			if (!statsWindow || statsWindow.closed){
				statsWindow = new StatsWindow();
			}
			statsWindow.open();
			statsWindow.activate();
		}
	}
}