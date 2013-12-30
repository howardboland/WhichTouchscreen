/*
 PureMVC AS3 Demo - Flex Application Skeleton 
 Copyright (c) 2007 Daniele Ugoletti <daniele.ugoletti@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package view
{
	import com.which.utils.Console;
	
	import flash.events.Event;
	
	import model.*;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.components.*;

    /**
     * A Mediator for interacting with the SplashScreen component.
     */
    public class VideoMediator extends Mediator implements IMediator
    {
        // Cannonical name of the Mediator
        public static const NAME:String = "VideoMediator";
        
        /**
         * Constructor. 
         */
        public function VideoMediator( viewComponent:VideoView ) 
        {
            // pass the viewComponent to the superclass where 
            // it will be stored in the inherited viewComponent property
            super( NAME, viewComponent );
			
			viewComponent.addEventListener(VideoView.VIDEO_LOOPED, this.videoLoop);
        }

        /**
         * List all notifications this Mediator is interested in.
         * <P>
         * Automatically called by the framework when the mediator
         * is registered with the view.</P>
         * 
         * @return Array the list of Nofitication names
         */
        override public function listNotificationInterests():Array 
        {
            return [ 
					StartupMonitorProxy.LOADING_STEP,
					StartupMonitorProxy.LOADING_COMPLETE,
					ConfigProxy.LOAD_FAILED,
					LocaleProxy.LOAD_FAILED,
					ApplicationFacade.VIEW_VIDEO
					];
        }

        /**
         * Handle all notifications this Mediator is interested in.
         * <P>
         * Called by the framework when a notification is sent that
         * this mediator expressed an interest in when registered
         * (see <code>listNotificationInterests</code>.</P>
         * 
         * @param INotification a notification 
         */
        override public function handleNotification( note:INotification ):void 
        {
            switch ( note.getName() ) 
			{
				case ApplicationFacade.VIEW_VIDEO:
					viewComponent.onInit();
					break;

				case StartupMonitorProxy.LOADING_STEP:
					// update the progress barr
					//this.splashScreen.pb.setProgress( note.getBody() as int, 100);
					break;
					
				case StartupMonitorProxy.LOADING_COMPLETE:
					// all done
					// show the main screen
					//this.sendNotification( ApplicationFacade.VIEW_VIDEO );
					break;
					
				case ConfigProxy.LOAD_FAILED:
				case LocaleProxy.LOAD_FAILED:
					// error reading the config XML fille
					// show the error
					//this.splashScreen.errorText.text = note.getBody() as String;
					//this.splashScreen.errorBox.visible = true;
					break;
            }
        }
		protected function videoLoop( e:Event ):void
		{
			Console.log("Video looped", this);
			this.sendNotification( ApplicationFacade.VIEW_NEWS );
		}

        /**
         * Cast the viewComponent to its actual type.
         * 
         * <P>
         * This is a useful idiom for mediators. The
         * PureMVC Mediator class defines a viewComponent
         * property of type Object. </P>
         * 
         * <P>
         * Here, we cast the generic viewComponent to 
         * its actual type in a protected mode. This 
         * retains encapsulation, while allowing the instance
         * (and subclassed instance) access to a 
         * strongly typed reference with a meaningful
         * name.</P>
         * 
         * @return SplashScreen the viewComponent cast to org.puremvc.as3.demos.flex.appskeleton.view.components.SplashScreen
         */
		 
        protected function get splashScreen():SplashScreen
		{
            return viewComponent as SplashScreen;
        }
		
		/**
         * End effect event
         */
		private function endEffect(event:Event=null):void
		{
			// start to load the resources
			var startupMonitorProxy:StartupMonitorProxy = facade.retrieveProxy( StartupMonitorProxy.NAME ) as StartupMonitorProxy;
			startupMonitorProxy.loadResources();
		}
		
    }
}
