package com.slantsoft.managers
{
	import com.slantsoft.views.StatsWindow;
	
	import flash.events.EventDispatcher;
	import flash.system.Capabilities;

	public class NativeWindowManager extends EventDispatcher
	{
		private var statsWindow:StatsWindow;
		
		public function openStatsWindow():void{
			var targetHeight:int = 400;
			var targetWidth:int = 600;
			
			if (!statsWindow || statsWindow.closed){
				statsWindow = new StatsWindow();
				
				statsWindow.height = targetHeight;
				statsWindow.width = targetWidth;
				statsWindow.minHeight = targetHeight;
				statsWindow.minWidth = targetWidth;
				
				statsWindow.open();
				
				statsWindow.nativeWindow.x = (Capabilities.screenResolutionX - targetWidth) / 2;
				statsWindow.nativeWindow.y = (Capabilities.screenResolutionY - targetHeight) / 2;
			}
			
			statsWindow.activate();
		}
	}
}