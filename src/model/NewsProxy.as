/*
 PureMVC AS3 Demo - Flex Application Skeleton 
 Copyright (c) 2007 Daniele Ugoletti <daniele.ugoletti@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package model
{
	import com.adobe.serialization.json.JSON;
	import com.which.utils.Console;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
    /**
     * A proxy for read the config file
     */
    public class NewsProxy extends Proxy implements IProxy
    {
		public static const NAME:String = "NewsProxy";									// Proxy name
		public static const SEPARATOR:String = "/";
		
		// Notifications constansts
		public static const LOAD_SUCCESSFUL:String 	= NAME + "loadSuccessful";				// Successful notification
		public static const LOAD_FAILED:String 		= NAME + "loadFailed";					// Failed notification
		
		// Messages
		public static const ERROR_LOAD_FILE:String	= "Could not load the news data!";	// Error message

		private var startupMonitorProxy:StartupMonitorProxy;								// StartupMonitorProxy instance
		protected var index:int = -1;
		public function NewsProxy ( data:Object = null ) 
        {
            super ( NAME, data );
        }
			
		
		/*
		 * Load the xml file, this method is called by StartupMonitorProxy
		 */
		public function load():void
		{
			// create a worker who will go get some data
			// pass it a reference to this proxy so the delegate knows where to return the data
			var urlRequest:URLRequest = new URLRequest('services/news.php');
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, result);
			loader.addEventListener(IOErrorEvent.IO_ERROR, fault);
			loader.load( urlRequest );
			Console.log("NewsProxy loading:" + urlRequest.url, this);
		
		}
		
		/*
		 * This is called when the delegate receives a result from the service
		 * 
         * @param rpcEvent
		 */
		public function result( e : Event ) : void
		{
			// call the helper class for parse the XML data
			index = -1;
			this.data = com.adobe.serialization.json.JSON.decode(e.target.data, true);
			
		
			Console.log("Result: "+data[0]["title"], this);
			//XmlResource.parse(data, rpcEvent.result);
			
			// call the StartupMonitorProxy for notify that the resource is loaded
			//startupMonitorProxy.resourceComplete( NewsProxy.NAME );
			
			// send the successful notification
			sendNotification( NewsProxy.LOAD_SUCCESSFUL );
		}
		
		public function hasData():Boolean
		{
		
			if (data==null)
				return false;
			return data.length>0
		}
		
		public function nextItem():Object
		{
			if (! hasData() )
				return null;
			if (index<this.data.length)
				index++;
			else
				index = 0;
			
			return this.data[index];
				
		}
		public function previousItem():Object
		{
			if (! hasData() )
				return null;
			if (index>0)
				index--;
			else
				index = this.data.length-1;
			
			return this.data[index];
			
		}
		public function isLast():Boolean
		{
			if (! hasData() )
				return true;
			if (index<this.data.length)
				return false;
			return true;
		}
		
		/*
		 * This is called when the delegate receives a fault from the service
		 * 
         * @param rpcEvent
		 */
		public function fault( e : IOErrorEvent ) : void 
		{
			Console.log("Error:" + e.text, this);
			// send the failed notification
			sendNotification( NewsProxy.LOAD_FAILED, NewsProxy.ERROR_LOAD_FILE );
		}
		
		/**
         * Get the config value
		 * 
         * @param key the key to read 
         * @return String the key value stored in internal object
         */
		public function getValue(key:String):String
		{
			return data[key.toLowerCase()];
		}
		
		/**
         * Get the config numeric value 
		 * 
         * @param key the key to read 
         * @return Number the key value stored in internal object
         */
		public function getNumber(key:String):Number
		{
			return Number( data[key.toLowerCase()] );
		}
		
		/**
         * Get the config boolean value 
		 * 
         * @param key the key to read 
         * @return Boolean the key value stored in internal object
         */
		public function getBoolean(key:String):Boolean
		{
			return data[key.toLowerCase()] ? data[key.toLowerCase()].toLowerCase() == "true" : false;
		}
		
		
		/**
         * Set the config value if isn't defined
		 * 
         * @param key the key to set
         * @param value the value
         */
		public function setDefaultValue( key:String, value:Object ):void
		{
			if ( !data[key.toLowerCase()] )
			{
				data[key.toLowerCase()] = value;
			}
		}
	}
}