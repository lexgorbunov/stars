/**
 * User: LeX Gorbunov
 * Date: 24.06.11
 * Time: 16:17
 * E-mail: lexgorbunov@swdrom.com
 */
package ru.lglab {
import flash.display.Bitmap;
import flash.display.Loader;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.net.URLRequest;
import flash.system.LoaderContext;

public class ImageCacher extends Bitmap {
    private static var queue:Array = [];
    private static var cached:Object = new Object();
    private var loader:Loader = new Loader();
    private var waitUrl:String = '';
    private var url:String = '';
    private var _onComplete:Function;
    private var _onError:Function;

    /**
     * To load images
     * @param images Array(imagesId:String=>imageUrl)
     */
    public function ImageCacher(source:String = '') {
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoad);
        loader.contentLoaderInfo.addEventListener(ErrorEvent.ERROR, function(e:ErrorEvent) {
            waitUrl = '';
            if (_onError != null)
                _onError(e);
        });

        if (source != '')
            this.source = source;
    }

    public function set source(urlp:String):void {
        if (cached[urlp] != null) {
            super.bitmapData = cached[urlp];
            url = urlp;
            return;
        }
        queue.push(urlp);
        cached[urlp] = null;
        load();
    }

    public function get source():String {
        return url;
    }

    public function set onComplete(value:Function):void {
        _onComplete = value;
    }

    public function set onError(value:Function):void {
        _onError = value;
    }

    private function load() {
        if (waitUrl != '')
            return;
        waitUrl = queue.pop();
        url = waitUrl;
        loader.load(new URLRequest(waitUrl), new LoaderContext())
    }

    private function onLoad(e:Event) {
        url = waitUrl;
        cached[waitUrl] = e.currentTarget.content.bitmapData;
        bitmapData = e.currentTarget.content.bitmapData;
        if (_onComplete != null)
            _onComplete();
        waitUrl = '';
    }
}
}
