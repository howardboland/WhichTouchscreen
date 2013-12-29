package com.which.template.events
{
	import flash.events.Event;
	
	public class TemplateEvent extends Event
	{
		public static var OPEN_URL:String = "OPEN_URL";
		public static var LOADED:String = "LOADED";
		public static var ERROR:String = "ERROR";
		public var url:String;
		
		public function TemplateEvent(type:String="", url:String="", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.url = url;
			super(type, bubbles, cancelable);
		}
	}
}