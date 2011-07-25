/*
 * This file is part of Flowplayer, http://flowplayer.org
 *
 * By: Daniel Rossi <electroteque@gmail.com>, Anssi Piirainen <api@iki.fi> Flowplayer Oy
 * Copyright (c) 2009, 2010 Electroteque Multimedia, Flowplayer Oy
 *
 * Released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 */

package org.flowplayer.net {

    import org.flowplayer.util.Log;
    import org.flowplayer.controller.ClipURLResolver;
    import org.flowplayer.view.Flowplayer;
    import org.osmf.net.DynamicStreamingItem;

    public class StreamSelectionManager implements IStreamSelectionManager {

        protected var log:Log = new Log(this);
        protected var _streamItems:Vector.<BitrateItem>;
        protected var _currentIndex:Number = -1;
        protected var _player:Flowplayer;
        protected var _resolver:ClipURLResolver;
        protected var _previousStreamName:String;
        protected var _currentBitrateItem:BitrateItem;
        protected var _bitrateResource:BitrateResource;

        public function StreamSelectionManager(bitrateResource:BitrateResource, player:Flowplayer, resolver:ClipURLResolver) {
            _bitrateResource = bitrateResource;
            _streamItems = _bitrateResource.addBitratesToClip(player.currentClip);
            _player = player;
            _resolver = resolver;
        }

        public function get bitrates():Vector.<BitrateItem> {
            return _streamItems;
        }

        public function get bitrateResource():BitrateResource {
            return _bitrateResource;
        }

        public function getDefaultStream():BitrateItem {
            log.debug("getDefaultStream()");
            var item:BitrateItem;
            for (var i:Number = 0; i < _streamItems.length; i++) {
                if (_streamItems[i]["isDefault"]) {
                    item = _streamItems[i];
                    _currentIndex = i;
                    break;
                }
            }
            if (! item) {
                //fix for #241 lowest item is the first index not the last once ordered.
                item = _streamItems[0];
                _currentIndex = 0;
                log.debug("getDefaultStream(), did not find a default stream -> using the one with lowest bitrate " + item);
            } else {
                log.debug("getDefaultStream(), found default item " + item);
            }
            return item;
        }

        public function getStreamIndex(bitrate:Number):Number {
            for (var i:Number = _streamItems.length - 1; i >= 0; i--) {
                var item:BitrateItem = _streamItems[i];

                if (item.bitrate == bitrate) {
                    return i;
                    break;
                }
            }
            return -1;
        }

        public function getStream(bitrate:Number):BitrateItem {
            var index:Number = getStreamIndex(bitrate);
            if (index == -1) return getDefaultStream();
            return _streamItems[index] as BitrateItem;
        }

        public function getMappedBitrate(bandwidth:Number = -1):BitrateItem {
            if (bandwidth == -1) return getDefaultStream() as BitrateItem;
            return getStream(bandwidth) as BitrateItem;
        }

        public function getItem(index:uint):BitrateItem {
            return _streamItems[index];
        }

        public function get currentIndex():Number {
            return _currentIndex;
        }

        public function set currentIndex(value:Number):void {
            _currentIndex = value;
        }

        public function get currentBitrateItem():BitrateItem {
            return _currentBitrateItem;
        }

        public function set currentBitrateItem(value:BitrateItem):void {
            _currentBitrateItem = value;
        }

        public function get streamItems():Vector.<BitrateItem> {
            return _streamItems;
        }

        public function fromName(name:String):BitrateItem {
            for (var i:Number = 0; i < _streamItems.length; i++) {
                if (_streamItems[i].streamName.indexOf(name) == 0 ||
                    _streamItems[i].streamName.indexOf("mp4:" + name) == 0) {  
                    return _streamItems[i];
                }
            }
            return null;
        }

        public function changeStreamNames(mappedBitrate:BitrateItem):void {
            var url:String = mappedBitrate.url;

            _previousStreamName = _previousStreamName ? _player.currentClip.url : url;
            currentBitrateItem = mappedBitrate;
            currentIndex = mappedBitrate.index;

            _player.currentClip.setResolvedUrl(_resolver, url);
            _player.currentClip.setCustomProperty("bitrateResolvedUrl", url);
            _player.currentClip.setCustomProperty("mappedBitrate", mappedBitrate);
            log.debug("mappedUrl " + url + ", clip.url now " + _player.currentClip.url);
        }

    }
}