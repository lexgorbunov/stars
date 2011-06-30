/**
 * User: LeX Gorbunov
 * Date: 23.06.11
 * Time: 9:10
 * E-mail: lexgorbunov@swdrom.com
 */
package ru.lglab {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.StageAlign;
import flash.display.StageDisplayState;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.filters.BlurFilter;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.SharedObject;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.utils.getTimer;
import flash.utils.setTimeout;

import mx.controls.Alert;

public class Stars {
    public var app:DisplayObjectContainer;
    var faces:Faces;
    var paper:Bitmap=new Bitmap();
    var background:ImageCacher=new ImageCacher();
    var prop:Object={
        bgColor: 0x000000 as uint
    }
    var width:uint;
    var height:uint;
    var widthDef:uint;
    var heightDef:uint;
    var imageList:RemoteImageList=new RemoteImageList();
    var preloadBoard:Bitmap=new ilib.imgLoading;
    var preloadAnimate:Animate;
    var lastVisitDate:Date;
    var visites:SharedObject=SharedObject.getLocal("visites");
    var lastVisitInfoText:TextField=new TextField();

    public function Stars(stg:DisplayObjectContainer, windowWidth, windowHeight) {
        app=stg;
        widthDef=windowWidth;
        heightDef=windowHeight;
        // Preload animate board
        preloadBoard.x=app.width/2-preloadBoard.width/2;
        preloadBoard.y=app.height/2-preloadBoard.height/2;
        preloadAnimate=new Animate((new ilib.imgAnimateGen).bitmapData,13,3);
        preloadAnimate.x = app.width/2-preloadAnimate.width/2;
        preloadAnimate.y = preloadBoard.y+preloadBoard.height;
        app.addChild(preloadBoard);
        app.addChild(preloadAnimate);
//return;
        imageList.onCompleteXmlLoad=function(){
            background.onComplete=function(){
                setTimeout(init,1000);
                background.onComplete=null;
            };
            if(imageList.exists('wallpaper'))
                background.source=imageList.getImageUrl('wallpaper');
            else
                trace('Невозможно загрузить картинку "wallpaper"');
            if(imageList.exists('star'))
                faces=new Faces(imageList.getImageUrl('star'));
            else
                trace('Невозможно загрузить картинку "star"');
        }
        imageList.loadXml('http://lglab.ru/xmlserver');
    }
    function init(){
        app.removeChild(preloadBoard);
        app.removeChild(preloadAnimate);
        preloadAnimate.dispose();
        // Save shared object
        lastVisitInfoText.defaultTextFormat=new TextFormat(null,15,0xFFFFFF);
        lastVisitInfoText.autoSize=TextFieldAutoSize.LEFT;
        if(visites.data.lastVisitDate!=null)
        {
            lastVisitInfoText.text='Дата последнего запуска: '
                    +(visites.data.lastVisitDate as Date).getDate().toString()+'.'+(visites.data.lastVisitDate as Date).getMonth().toString()+'.'+(visites.data.lastVisitDate as Date).getFullYear().toString()
                    +' '+(visites.data.lastVisitDate as Date).getHours().toString()+':'+(visites.data.lastVisitDate as Date).getMinutes().toString()+':'+(visites.data.lastVisitDate as Date).getSeconds().toString();
        }
        else
            lastVisitInfoText.text='Это первый запуск программы';
        trace(lastVisitInfoText.text);
        visites.data.lastVisitDate=new Date();
        //initialization
        app.stage.scaleMode=StageScaleMode.NO_SCALE;
        app.stage.align=StageAlign.TOP;
        app.stage.quality=StageQuality.MEDIUM;
        app.stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent){
            trace(e.keyCode)
            if(e.keyCode==9){
                app.stage.displayState=StageDisplayState.FULL_SCREEN;
            }
        });
//        imc.bitmapData=(new ilib.wallpaper2).bitmapData;
        background.x=0;
        background.y=0;
        paper.smoothing = true;

        app.addChild(background);
        app.addChild(paper);
        app.addEventListener(Event.RESIZE,onResize);

        run();
        app.addChild(lastVisitInfoText);
    }
    public function run(){
        setGameSize(widthDef,heightDef);
        app.addEventListener(Event.ENTER_FRAME,onEveryFrame)
    }
    public function onResize(e:Event)
    {
        if(app.stage.displayState==StageDisplayState.FULL_SCREEN)
        {
            setGameSize();
            app.stage.align=StageAlign.TOP_LEFT;
        }
        else
        {
            setGameSize(widthDef,heightDef);
            app.stage.align=StageAlign.TOP;
        }
    }
    public function setGameSize(width:uint=0,height:uint=0){
        if(this.width==width && this.height==height)
            return;
        this.width=(width!=0?width:app.width);
        this.height=(height!=0?height:app.height);
        background.width=this.width;
        background.height=this.height;
        lastVisitInfoText.x = this.width-lastVisitInfoText.textWidth;
        lastVisitInfoText.y = this.height-lastVisitInfoText.textHeight;
        faces.produceFaces(500,new Rectangle(0,0,this.width,this.height));
        redrawPaper();
    }
    public function redrawPaper(){
        if(paper.bitmapData!=null)
            paper.bitmapData.dispose();
        paper.bitmapData=new BitmapData(width,height,true,prop.bgColor);
    }
    public function clearPaper(){
        paper.bitmapData.fillRect(new Rectangle(0,0,width,height),prop.bgColor);
    }

    var tm1:int=getTimer();
    var tm2:int;
    var sec:Number=0;
    var fps=0;
    public function onEveryFrame(e:Event){
        clearPaper();
        for each (var face:Face in faces.suit)
        {
            face.updateMatrixOnStep();
            paper.bitmapData.draw(faces.original,face.mat,face.colorTrans,null,null,true);
        }
//        fps++;
//        tm2=getTimer();
//        if(tm2-tm1>=1000)
//        {
////            trace(fps)
//            fps=0;
//            tm1=getTimer();
//        }
    }
}
}
