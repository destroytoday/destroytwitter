package com.destroytoday.destroytwitter.view.drawer
{
    import com.destroytoday.destroytwitter.constants.Asset;
    import com.destroytoday.destroytwitter.model.vo.SQLUserVO;
    import com.destroytoday.destroytwitter.model.vo.UpdateVO;
    import com.destroytoday.destroytwitter.view.components.BitmapButton;
    import com.destroytoday.destroytwitter.view.components.IconButton;
    import com.destroytoday.destroytwitter.view.components.LayoutTextField;
    import com.destroytoday.destroytwitter.view.components.Spinner;
    import com.destroytoday.destroytwitter.view.components.TextButton;
    import com.destroytoday.display.DisplayGroup;
    import com.destroytoday.layouts.HorizontalAlignType;
    import com.destroytoday.layouts.VerticalLayout;
    import com.destroytoday.text.TextFieldPlus;
    import com.destroytoday.twitteraspirin.vo.UserVO;
    import com.destroytoday.util.ApplicationUtil;
    import com.destroytoday.util.NumberUtil;
    import flash.display.CapsStyle;
    import flash.display.Graphics;
    import flash.display.JointStyle;
    import flash.display.LineScaleMode;
    import flash.text.TextFieldAutoSize;
    import org.osflash.signals.Signal;

    public class UpdatePanel extends BaseDrawerPanel
    {

        public var downloadButton:TextButton;

        //--------------------------------------------------------------------------
        //
        //  Instances
        //
        //--------------------------------------------------------------------------

        public var textfield:LayoutTextField;

        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------

        protected var _data:UpdateVO;

        protected var dirtyDataFlag:Boolean;

        //--------------------------------------------------------------------------
        //
        //  Flags
        //
        //--------------------------------------------------------------------------

        protected var dirtySizeFlag:Boolean;

        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        public function UpdatePanel(title:LayoutTextField)
        {
            var layout:VerticalLayout = new VerticalLayout();

            layout.gap = -2.0;

            super(title, layout);

            textfield = addChild(new LayoutTextField()) as LayoutTextField;
            downloadButton = addChild(new TextButton()) as TextButton;

            textfield.x = -2.0
            textfield.autoSize = TextFieldAutoSize.LEFT;
            textfield.heightOffset = 4.0;

            downloadButton.text = "Install";
            downloadButton.align = HorizontalAlignType.RIGHT;
            downloadButton.height = 20.0;
        }

        public function get data():UpdateVO
        {
            return _data;
        }

        public function set data(value:UpdateVO):void
        {
            if (value == _data)
                return;

            _data = value;

            textfield.width = width - textfield.x;

            textfield.htmlText = "<p><span class=\"updateSubtitle\">DestroyTwitter " + _data.versionTo + " is available</span></p>" + "<p>" + _data.summary.replace(/(\[[A-Z]+\])/ig, "<span class=\"dimmed\">$1</span>") + "</p>" + "<p><span class=\"spacer\">&nbsp;</span></p>" + "<p><a href=\"http://support.destroytwitter.com/faqs/releases/" + _data.versionTo.replace(/\./g, '') + "\">See the complete changelog</a></p>";

            textfield.height = Math.round(textfield.height);

            dirtyDataFlag = true;
            updateDisplayList();
        }

        //--------------------------------------------------------------------------
        //
        //  Getters / Setters
        //
        //--------------------------------------------------------------------------

        override public function set visible(value:Boolean):void
        {
            super.visible = value;

            if (visible)
            {
                title.htmlText = "<p><span class=\"title\">Update</span></p>";
            }
        }

        //--------------------------------------------------------------------------
        //
        //  Invalidation
        //
        //--------------------------------------------------------------------------

        override protected function updateDisplayList():void
        {
            super.updateDisplayList();

            if (dirtyDataFlag)
            {
                dirtyDataFlag = false;

                height = Math.round(downloadButton.y + downloadButton.height + 8.0);
            }
        }
    }
}