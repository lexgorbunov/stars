/**
 * User: LeX Gorbunov
 * Date: 23.06.11
 * Time: 9:10
 * E-mail: lexgorbunov@swdrom.com
 */
package ru.lglab {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObjectContainer;
import flash.display.Loader;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageDisplayState;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundLoaderContext;
import flash.net.SharedObject;
import flash.net.URLRequest;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.utils.setTimeout;

import mx.messaging.Channel;

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
    var resourceList:RemoteResourceList=new RemoteResourceList();
    var preloadBoard:Bitmap=new ilib.imgLoading;
    var preloadAnimate:Animate;
    var lastVisitDate:Date;
    var visites:SharedObject=SharedObject.getLocal("visites");
    var lastVisitInfoText:TextField=new TextField();
    var bgSound:Sound;
    var bgSoundChanel:SoundChannel;
    var musicButtom:ImageCacher=new ImageCacher();
    var musicState:Boolean=false;
    var musicPos:uint=0;
    public function musicPlayPause(e:MouseEvent){
        trace('Click')
        if(!musicState)
        {
            musicButtom.source=resourceList.getImageUrl('pause');
            bgSoundChanel=bgSound.play(musicPos);
            musicState=true;
        }
        else
        {
            musicButtom.source=resourceList.getImageUrl('play');
            musicPos=bgSoundChanel.position;
            bgSoundChanel.stop();
            musicState=false;
        }
    }
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
        resourceList.onCompleteXmlLoad=function(){
            background.onComplete=function(){
                // Loading music
                var sndLoader:Sound=new Sound();
                sndLoader.addEventListener(Event.COMPLETE, function(e:Event){
                    bgSound = e.currentTarget as Sound;
                    bgSoundChanel=bgSound.play();
                    musicState=true;
                    bgSoundChanel.addEventListener(Event.SOUND_COMPLETE, function(e:Event){
                        bgSoundChanel=bgSound.play();
                    });
                    // Create music button
                    musicButtom.onComplete=function(){
                        musicButtom.x = lastVisitInfoText.x-musicButtom.width;
                        musicButtom.y = height-musicButtom.height;
                    }
                    musicButtom.source=resourceList.getImageUrl('pause');
                    musicButtom.addEventListener(MouseEvent.CLICK,musicPlayPause);
                    init();
                });
                sndLoader.load(
                        new URLRequest(resourceList.getSoundUrl(resourceList.getSoundIdsList()[0])),
                        new SoundLoaderContext());
                background.onComplete=null;
            };
            if(resourceList.existsImage('wallpaper'))
                background.source=resourceList.getImageUrl('wallpaper');
            else
                trace('Невозможно загрузить картинку "wallpaper"');
            if(resourceList.existsImage('star'))
                faces=new Faces(resourceList.getImageUrl('star'));
            else
                trace('Невозможно загрузить картинку "star"');
        }
        resourceList.loadXml('http://lglab.ru/xmlserver');
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
        visites.data.lastVisitDate=new Date();
        //initialization
        app.stage.scaleMode=StageScaleMode.NO_SCALE;
        app.stage.align=StageAlign.TOP;
        app.stage.quality=StageQuality.MEDIUM;
        app.stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent){
            if(e.keyCode==9){
                app.stage.displayState=StageDisplayState.FULL_SCREEN;
            }
        });
//        imc.bitmapData=(new ilib.wallpaper2).bitmapData;
        background.x=0;
        background.y=0;
        paper.smoothing = true;

        var paperSprite:Sprite=new Sprite();
//        paperSprite.addChild(background);
//        paperSprite.addChild(paper);
//        paperSprite.mouseEnabled=false;
//        app.addChild(paperSprite);
//        app.addEventListener(Event.RESIZE,onResize);
        app.addChild(background);
        app.addChild(paper);

        run();
        app.addChild(lastVisitInfoText);
        app.addChild(musicButtom);
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
        lastVisitInfoText.x = this.width-lastVisitInfoText.textWidth-8;
        lastVisitInfoText.y = this.height-lastVisitInfoText.textHeight-8;
        musicButtom.x = lastVisitInfoText.x-musicButtom.width;
        musicButtom.y = this.height-musicButtom.height;
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

    public function onEveryFrame(e:Event){
        clearPaper();
        for each (var face:Face in faces.suit)
        {
            face.updateMatrixOnStep();
            paper.bitmapData.draw(faces.original,face.mat,face.colorTrans,null,null,true);
        }
    }
}
}
