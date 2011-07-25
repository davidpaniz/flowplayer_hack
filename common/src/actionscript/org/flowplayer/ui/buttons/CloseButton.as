/*
 * This file is part of Flowplayer, http://flowplayer.org
 * 
 * By: Anssi Piirainen, <support@flowplayer.org>
 * Copyright (c) 2008-2011 Flowplayer Oy *
 * Released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 */
package org.flowplayer.ui.buttons {
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;

    import org.flowplayer.ui.buttons.AbstractButton;
    import org.flowplayer.ui.buttons.ButtonConfig;
    import org.flowplayer.ui.assets.CloseButton;
    import org.flowplayer.view.AnimationEngine;

    /**
     * @author api
     */
    public class CloseButton extends AbstractButton {
        private var _icon:DisplayObject;

        public function CloseButton(config:ButtonConfig, animationEngine:AnimationEngine) {
            super(config, animationEngine);
        }

        override protected function createFace():DisplayObjectContainer {
            return new org.flowplayer.ui.assets.CloseButton();
        }
    }
}
