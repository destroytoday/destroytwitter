package
{
    import com.destroytoday.destroytwitter.context.ApplicationContext;
    import com.destroytoday.destroytwitter.view.window.ApplicationWindowChrome;
    import com.destroytoday.destroytwitter.view.window.ApplicationWindowContent;
    import com.gskinner.motion.GTween;
    import com.gskinner.motion.easing.Quartic;
    import com.gskinner.motion.plugins.AutoHidePlugin;
    
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.text.Font;

    [SWF(backgroundColor="#222222")]
    public class BaseDestroyTwitter extends Sprite
    {

        [Embed(source="/assets/fonts.swf", fontName="Interstate-Regular")]
        static protected const INTERSTATE_REGULAR:String;
		
        //public var windowTray:ApplicationWindowTray;

        public var context:ApplicationContext;

        public var windowChrome:ApplicationWindowChrome;

        public var windowContent:ApplicationWindowContent;

        public function BaseDestroyTwitter()
        {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            stage.frameRate = 50.0;
            stage.stageFocusRect = false;
			
            GTween.defaultDispatchEvents = false;
            GTween.defaultEase = Quartic.easeInOut;
            AutoHidePlugin.install();

            context = new ApplicationContext(this);

            windowChrome = addChild(new ApplicationWindowChrome()) as ApplicationWindowChrome;
            //windowTray = addChild(new ApplicationWindowTray()) as ApplicationWindowTray;
        }

        public function addContent():ApplicationWindowContent
        {
            windowContent = addChild(new ApplicationWindowContent()) as ApplicationWindowContent;

            return windowContent;
        }
    }
}