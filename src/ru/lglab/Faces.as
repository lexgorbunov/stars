/**
 * User: LeX Gorbunov
 * Date: 23.06.11
 * Time: 10:08
 * E-mail: lexgorbunov@swdrom.com
 */
package ru.lglab {
import flash.filters.GlowFilter;
import flash.geom.Point;
import flash.geom.Rectangle;


public class Faces {
    public var original:ImageCacher=new ImageCacher();
    public var suit:Array=[];
    public function Faces(imageSource:String) {
        original.source=imageSource;
        original.onComplete=function(){
            var filter=new GlowFilter();
            original.bitmapData.applyFilter(original.bitmapData,original.bitmapData.rect,new Point(),filter);
        }
    }
    public function produceFaces(faceCount:uint, rect:Rectangle){
        if(suit.length>0)
        {
            // Cleaning suite
            var el:Face;
            while (el = suit.pop())
                el.dispose();
        }

        for(var i=0;i<faceCount;i++){
            var speedx:Number=Utils.rangeRand(-7,7)/3;
            var speedy:Number=Utils.rangeRand(2,7)/2;
            var scalemin:Number=0.3;
            var scalemax:Number=0.8;
            var face:Face=new Face(original.width,original.height,scalemin,scalemax,speedx,speedy,Utils.rangeRand(0.1,1),rect);
            var startScale:Number=Utils.rangeRand(3,8)/10;
            face.setMatrix(
                    Utils.rangeRand(rect.x,rect.width+rect.x),      // x
                    Utils.rangeRand(rect.y,rect.height+rect.y),     // y
                    Utils.rangeRand(0,360),                         // Rotate
                    startScale,                          // scaleX
                    startScale                           // scaleY
            );
            face.setColor(
                Utils.rangeRand(1,9)/10,
                Utils.rangeRand(1,9)/10,
                Utils.rangeRand(1,9)/10
            );
            suit.push(face);
        }
    }
}
}
