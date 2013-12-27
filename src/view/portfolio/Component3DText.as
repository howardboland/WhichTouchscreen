package view.portfolio 
{
    import caurina.transitions.*;
    
    import com.which.utils.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.utils.*;
    
    import org.papervision3d.core.geom.renderables.*;
    import org.papervision3d.materials.*;
    import org.papervision3d.objects.primitives.*;
    
    import view.portfolio.Component3DText;

    public class Component3DText extends Component3D
    {
        private var showDelay:Number;
        private var highresolutionText:SWF;
        private var popupVisible:Boolean;
        private var height:Number;
        private var openInterval:Number;
        private var width:Number;
        private var highresolution:Sprite;
        private var openDelay:Number;
        private var showInterval:Number;
        private var startTime:Number;
        private var url:String;
        private var highresolutionPage:Image;
        private var internalActive:Boolean = false;

        public function Component3DText(childIndex:Array, application:Application, type:String, url:String, id:Number) 
        {
            super(childIndex, application, type, id);
            this.url = url;
        }

        override public function init() : void
        {
            Console.log("init", this);
            inited = true;
            if (type != "text")
            {
                if (type == "board")
                {
                    width = 180;
                    height = 320;
                }
            }
            else
            {
                width = 320;
                height = 180;
            }
            showInterval = 0.6;
            showDelay = index[(index.length - 1)] * 0.1;
            openInterval = 0.35;
            openDelay = childs.length * 0.1 + 0.5;
            highresolutionText = new SWF(url, true);
            if (type != "text")
            {
                if (type == "board")
                {
                    highresolutionPage = new Image("resources/core/page2.jpg", true, false);
                }
            }
            else
            {
                highresolutionPage = new Image("resources/core/page.jpg", true, false);
            }
            highresolution = new Sprite();
            highresolution.addChild(highresolutionPage);
            highresolution.addChild(highresolutionText);
            highresolution.mouseEnabled = false;
            highresolutionPage.addEventListener( MouseEvent.MOUSE_UP, releaseHandler);
            highresolutionPage.addEventListener( MouseEvent.ROLL_OVER, rolloverHandler);
            highresolutionPage.addEventListener( MouseEvent.ROLL_OUT, rolloutHandler);
            highresolutionText.addEventListener( MouseEvent.MOUSE_UP, releaseHandler);
            highresolutionText.addEventListener( MouseEvent.ROLL_OVER, rolloverHandler);
            highresolutionText.addEventListener( MouseEvent.ROLL_OUT, rolloutHandler);
            main.addEventListener( Event.ENTER_FRAME, enterFrameHandler);
            highresolution.addEventListener( MouseEvent.MOUSE_MOVE, mouseMoveHandler);
            return;
        }

        private function hidePopup() : void
        {
            if (isOpen)
            {
                main.setPopupVisible();
            }
            return;
        }

        private function enterFrameHandler(event:Event) : void
        {
            if (getTimer() - startTime > 1000 && popupVisible)
            {
                popupVisible = false;
                hidePopup();
            }
            return;
        }

        private function startPopupTimeout() : void
        {
            startTime = getTimer();
            popupVisible = true;
            return;
        }

        override public function setAnimationDisappear(param1:Number = 0) : Number
        {
			var theExecutionDelay:Number = param1;
            var myDelay:* = showDelay + theExecutionDelay;
            if (type != "text")
            {
                if (type == "board")
                {
                    setMouseListener(false);
                    Tweener.addTween(displayobject, {delay:myDelay, time:showInterval, transition:"easeinoutquad", _bezier:[{x:x, y:(parent.y + y) / 2 - 600, z:parent.z}, {x:(parent.x + x) / 2, y:(parent.y + y) / 2 - 600, z:parent.z}], x:parent.x, y:parent.y, z:parent.z, onComplete:function () : void
            {
                main.scene.removeChild(displayobject);
                return;
            }
            });
                }
            }
            else
            {
                setMouseListener(false);
                Tweener.addTween(displayobject, {delay:myDelay, time:showInterval, transition:"easeinoutquad", onStart:function () : void
            {
                displayobject.material.doubleSided = true;
                return;
            }
            , _bezier:[{x:x, y:y + 400, z:z, rotationX:0, rotationY:0, rotationZ:-45}, {x:parent.x, y:parent.y + 400, z:(parent.z + z) / 2, rotationX:0, rotationY:90, rotationZ:-60}, {x:parent.x, y:parent.y + 400, z:parent.z, rotationX:0, rotationY:180, rotationZ:-90}], x:parent.x, y:parent.y, z:parent.z, rotationX:0, rotationY:180, rotationZ:-90, onComplete:function () : void
            {
                main.scene.removeChild(displayobject);
                return;
            }
            });
            }
            return myDelay + showInterval;
        }

        private function placeImage(event:Event) : void
        {
            highresolution.x = (displayobject.geometry.vertices[1] as Vertex3D).vertex3DInstance.x * Application.scale + main.container3D.x;
            highresolution.y = (displayobject.geometry.vertices[1] as Vertex3D).vertex3DInstance.y * Application.scale + main.container3D.y;
            Console.log("placeimage x" + 330 * Application.scale + " main.container3D.x" + main.container3D.x + "- highresolution.x" + highresolution.x, this);
            var _loc_3:* = 660;
            var _loc_2:* = 340;
            if (width > height)
            {
                highresolution.width = _loc_3 * Application.scale + main.container3D.x - highresolution.x;
                highresolution.height = _loc_2 * Application.scale + main.container3D.y - highresolution.y;
            }
            else
            {
                highresolution.width = _loc_2 * Application.scale + main.container3D.x - highresolution.x;
                highresolution.height = _loc_3 * Application.scale + main.container3D.y - highresolution.y;
            }
            return;
        }

        override public function setAnimationOpen() : Number
        {
            var myDelay:Number;
            if (type != "text")
            {
                if (main.depth != depth)
                {
                    myDelay = main.setChildsDisappearOfDepth(depth);
                }
                main.setClosedOfDepth(depth);
                isOpen = true;
                main.setHighResolution(false);
                Tweener.addTween(this, {time:0.7, delay:myDelay, onComplete:function () : void
            {
                setHighResolution(true);
                return;
            }
            });
                main.setAnimationZoomIn(displayobject, myDelay, 1);
            }
            else
            {
                main.setClosedOfDepth(depth);
                isOpen = true;
                main.setHighResolution(false);
                Tweener.addTween(this, {time:0.7, onComplete:function () : void
            {
                setHighResolution(true);
                return;
            }
            });
                main.setAnimationZoomIn(displayobject, 0, 1);
            }
            return 0.7;
        }

        override public function rolloverHandler(event:MouseEvent) : void
        {
			switch (isOpen) 
			{
				case true:
					main.setPopupVisible(Application.POPUP_2D_ZOOM_OUT);
					startPopupTimeout();
					break;
				case false:
					if (main.isZoomed)
					{
						main.setPopupVisible(Application.POPUP_2D_ZOOM_IN, displayobject);
					}
					else 
					{
						main.setPopupVisible(Application.POPUP_3D_ZOOM_IN, displayobject);
					}
					break;
			}
        }

        override public function isLoaded() : Boolean
        {
            var _loc_1:* = null;
            var _loc_4:* = null;
            var _loc_3:* = 1.1;
            var _loc_2:* = 1;
            if (highresolutionPage && highresolutionText)
            {
                if (highresolutionPage.loaded && highresolutionText.loaded)
                {
                    _loc_1 = new Matrix();
                    if (width > height)
                    {
                        _loc_1.scale(width / 1280, height / 720);
                    }
                    else
                    {
                        _loc_1.scale(width / 720, height / 1280);
                    }
                    highresolutionText.filters = [new BlurFilter(_loc_3, _loc_3, 3)];
                    highresolutionText.alpha = _loc_2;
                    _loc_4 = new BitmapData(width, height);
                    _loc_4.draw(highresolution, _loc_1, null, null, null, true);
                    highresolutionText.filters = null;
                    highresolutionText.alpha = 1;
                    displayobject = new Plane(new BitmapMaterial(_loc_4), width, height);
                    displayobject.material.smooth = true;
                    return true;
                }
                return false;
            }
            return false;
        }

        override public function setAnimationClose() : Number
        {
            if (!internalActive)
            {
                main.setClosedOfDepth(depth);
                setHighResolution(false);
                main.setAnimationZoomOut();
            }
            return 0.7;
        }

        override public function rolloutHandler(event:MouseEvent) : void
        {
            main.setPopupVisible();
            return;
        }

        public function mouseMoveHandler(event:MouseEvent) : void
        {
            if (isOpen)
            {
                main.setPopupVisible(1);
                startPopupTimeout();
            }
            return;
        }

        override public function setAnimationAppear(param1:Number = 0) : Number
        {
			var theExecutionDelay:Number = param1;
            if (index.length == 2)
            {
                var loc3:* = parent;
                var loc4:* = (parent.loadingIndex + 1);
                loc3.loadingIndex = loc4;
            }
            if (type != "text")
            {
                if (type == "board")
                {
                    var myDelay:* = showDelay + theExecutionDelay;
                    main.scene.addChild(displayobject);
                    displayobject.visible = false;
                    Tweener.addTween(displayobject, {delay:myDelay, time:showInterval, transition:"EaseinOutQuad", onStart:function () : void
            {
                displayobject.visible = true;
                displayobject.x = parent.x;
                displayobject.y = parent.y;
                displayobject.z = parent.z;
                return;
            }
            , _bezier:[{x:(parent.x + x) / 2, y:(parent.y + y) / 2 - 600, z:parent.z}, {x:x, y:(parent.y + y) / 2 - 600, z:parent.z}], x:x, y:y, z:z, onComplete:function () : void
            {
                setMouseListener(true);
                return;
            }
            });
                }
            }
            else
            {
                myDelay = showDelay + theExecutionDelay;
                main.scene.addChild(displayobject);
                displayobject.visible = false;
                Tweener.addTween(displayobject, {delay:myDelay, time:showInterval, transition:"EaseInOutQuad", onStart:function () : void
            {
                displayobject.visible = true;
                displayobject.x = parent.x;
                displayobject.y = parent.y;
                displayobject.z = parent.z;
                displayobject.rotationX = 0;
                displayobject.rotationY = 180;
                displayobject.rotationZ = -90;
                displayobject.material.doubleSided = true;
                return;
            }
            , _bezier:[{x:parent.x, y:parent.y + 400, z:parent.z, rotationX:0, rotationY:180, rotationZ:-90}, {x:parent.x, y:parent.y + 400, z:(parent.z + z) / 2, rotationX:0, rotationY:90, rotationZ:-60}, {x:x, y:y + 400, z:z, rotationX:0, rotationY:0, rotationZ:-45}], x:x, y:y, z:z, rotationX:0, rotationY:0, rotationZ:0, onComplete:function () : void
            {
                displayobject.material.doubleSided = false;
                setMouseListener(true);
                return;
            }
            });
            }
            return myDelay + showInterval;
        }

		public function gotoNext() : void
		{
			Console.log("gotoNext", this);
			var component:Component3D = getNextComponent(true);
			if (component != null)
			{
				main.setClosedOfDepth(depth);
				setHighResolution(false);
				Console.log("Pan to component:" + component, this);
				if (component.type == "text" || component.type == "board")
				{
					(component as Component3DText).setAnimationOpen();
				}
				else if (component.type == "image")
				{
					(component as Component3DImage).setAnimationOpen();
				}
			}
		}

		public function gotoPrevious() : void
		{
			Console.log("gotoPrevious", this);
			var component:Component3D = getPreviousComponent(true);
			if (component != null)
			{
				main.setClosedOfDepth(depth);
				setHighResolution(false);
				Console.log("Pan to component:" + component, this);
				if (component.type == "text" || component.type == "board")
				{
					(component as Component3DText).setAnimationOpen();
				}
				else if (component.type == "image")
				{
					(component as Component3DImage).setAnimationOpen();
				}
			}
		}

        public function setHighResolution(enable:Boolean) : void
        {
            if (enable != true)
            {
                if (main.container2D.contains(highresolution))
                {
                    main.container2D.removeChild(highresolution);
                    main.stage.removeEventListener("resize", placeImage);
                    main.setBackgroundOverlay(false);
                    main.setNextPreviousArrows(false);
                }
            }
            else
            {
                main.container2D.addChild(highresolution);
                main.setBackgroundOverlay(true);
                main.setNextPreviousArrows(true);
                main.stage.addEventListener("resize", placeImage);
                placeImage(null);
                activateURLButton();
            }
            return;
        }

		protected function activateURLButton() : void
		{
			var btn:MovieClip;
			var template:MovieClip = highresolutionText.loader.contentLoaderInfo.content as MovieClip;
			Console.log("activateURLButton btn:" + template.getChildByName("btn"), this);
			if (template.getChildByName("btn"))
			{
				btn = template.getChildByName("btn") as MovieClip;
				btn.addEventListener( MouseEvent.ROLL_OVER, rolloverURL);
				btn.addEventListener( MouseEvent.ROLL_OUT, rolloutURL);
				btn.addEventListener( MouseEvent.CLICK, openURL);
			}
		}

        protected function rolloverURL(e:MouseEvent) : void
        {
            internalActive = true;
        }

        protected function rolloutURL(e:MouseEvent) : void
        {
            internalActive = false;
        }

        protected function openURL(e:MouseEvent) : void
        {
            Console.log("OpenURL", this);
            e.stopPropagation();
        }

    }
}
