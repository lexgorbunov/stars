/**
 * User: LeX Gorbunov
 * Date: 23.06.11
 * Time: 10:41
 * E-mail: lexgorbunov@swdrom.com
 */
package ru.lglab {
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Rectangle;

public class Face {
    public var mat:Matrix;
    public var colorTrans:ColorTransform;
    public var speedx:Number;
    public var speedy:Number;
    public var speedrot:Number;
    public var rotate:Number=0;

    public var scalespeedx:Number=1.01;
    public var scalespeedy:Number=1.01;

    public var scalemin:Number=0.1;
    public var scalemax:Number=0.6;

    public var orignWidth:Number;
    public var orignHeight:Number;
    public var displayRect:Rectangle;
    public var x:Number;
    public var y:Number;
    public var scalex:Number;
    public var scaley:Number;

    public function Face(orignWidth,orignHeight,scalemin,scalemax,speedx,speedy,speedrot:Number,displayRect:Rectangle){
        this.speedx=speedx;
        this.speedy=speedy;
        this.speedrot=speedrot;
        this.orignWidth=orignWidth;
        this.orignHeight=orignHeight;
        this.displayRect=displayRect;
        this.scalemin=scalemin;
        this.scalemax=scalemax;
    }
    public function setMatrix(x:Number=0,y:Number=0,rotate:Number=0,scalex:Number=1,scaley:Number=1){
        mat=new Matrix();
        colorTrans=new ColorTransform(1,1,1,1);
        this.x=x;
        this.y=y;
        this.scalex=scalex;
        this.scaley=scaley;
        this.orignWidth*=scalex;
        this.orignHeight*=scaley;
        this.rotate=rotate;
        mat.createBox(scalex,scaley,0,-orignWidth/2,-orignHeight/2);
        mat.rotate(rotate);
        mat.tx+=x;
        mat.ty+=y;
    }
    public function updateMatrixOnStep(){
        mat.identity();
        //// Scaling ////
        if (scalex >= scalemax || scalex <= scalemin)
            scalespeedx = 1 / scalespeedx;
        if (scaley >= scalemax || scaley <= scalemin)
            scalespeedy = 1 / scalespeedy;
        scalex*=scalespeedx;
        scaley*=scalespeedy;
        this.orignWidth*=scalespeedx;
        this.orignHeight*=scalespeedy;
        mat.scale(scalex,scaley);
        //// Rotate ////
        rotate+=speedrot;
        if(rotate>360) rotate-=360;
        mat.rotate(rotate);

        // Shifting
        /* Звездопад */
        if(x+orignWidth/2>=displayRect.width+displayRect.x)
            speedx=Math.abs(speedx)*(-1);
        else if(x-orignWidth/2<=displayRect.x)
            speedx=Math.abs(speedx);
        if(y+orignHeight/2>=displayRect.height+displayRect.y+10)
            y=-10;//speedy=Math.abs(speedy)*(-1);
        else if(y-orignHeight/2<=displayRect.y)
            speedy=Math.abs(speedy);
//        /*  <Отскоки */
//        if(x+orignWidth/2>=displayRect.width+displayRect.x)
//            speedx=Math.abs(speedx)*(-1);
//        else if(x-orignWidth/2<=displayRect.x)
//            speedx=Math.abs(speedx);
//        if(y+orignHeight/2>=displayRect.height+displayRect.y)
//            speedy=Math.abs(speedy)*(-1);
//        else if(y-orignHeight/2<=displayRect.y)
//            speedy=Math.abs(speedy);

        x+=speedx;
        y+=speedy;
        mat.tx=x
        mat.ty=y
    }
    public function setColor(r,g,b:uint, alpha:uint=1){
        colorTrans=new ColorTransform(r,g,b,alpha);
    }

    /**
     * Destructor
     */
    public function dispose(){
        this.mat=null;
        this.colorTrans=null;
        delete this;
    }
}
}
