/**
 * User: LeX Gorbunov
 * Date: 28.06.11
 * Time: 18:01
 * E-mail: lexgorbunov@swdrom.com
 */
package ru.lglab {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Timer;

public class Animate extends Bitmap {
    private var cadrs:Array = new Array();
    private var cadrW:Number;
    private var cadrH:Number;
    private var timer:Timer;
    private var cadrsCount:uint = 0;
    private var pos:uint = 0;
    private var transparent:Boolean = false;

    public function Animate(img:BitmapData, gridXCadrCount:uint, gridYCadrCount:uint, transparent:Boolean = true, fps:uint = 24, autoStart:Boolean = true, repeatCount:uint = 0) {
        cadrW = img.width / gridXCadrCount;
        cadrH = img.height / gridYCadrCount;
        this.transparent = transparent;
        for (var yi:uint = 0; yi < gridYCadrCount; yi++) {
            for (var xi:uint = 0; xi < gridXCadrCount; xi++) {
                var cadrBitmap:BitmapData = new BitmapData(cadrW, cadrH, transparent);
                cadrBitmap.copyPixels(img, new Rectangle(xi * cadrW, yi * cadrH, cadrW, cadrH), new Point(0, 0));
                cadrs.push(cadrBitmap);
                cadrsCount++;
            }
        }
        repeatCount *= cadrsCount;
        timer = new Timer(1000 / fps, repeatCount);
        timer.addEventListener(TimerEvent.TIMER, onTimer);
        if (autoStart)
            timer.start();
    }

    public function start() {
        timer.start();
    }

    public function stop() {
        timer.stop();
    }

    private function onTimer(e:TimerEvent) {
        super.bitmapData = cadrs[pos];
        pos++;
        if (pos >= cadrsCount)
            pos = 0;
    }

    public function dispose() {
        timer.stop();
        timer = null;
        var cadr:BitmapData;
        while (cadr = cadrs.pop()) {
            cadr.dispose();
            cadr = null;
        }
        cadrs = null;
    }

    override public function get width():Number {
        return cadrW;
    }

    override public function get height():Number {
        return cadrH;
    }
}
}
