/**
 * User: LeX Gorbunov
 * Date: 28.06.11
 * Time: 15:46
 * E-mail: lexgorbunov@swdrom.com
 */
package ru.lglab {
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;

public class RemoteResourceList {
    private var xmlData:XML;
    private static var imgList:Object=new Object();
    private static var soundList:Object=new Object();
    private var _onCompleteXmlLoad:Function;
    private var xmlLoader:URLLoader=new URLLoader();
    
    public function RemoteResourceList() {
        xmlLoader.addEventListener(Event.COMPLETE,onLoad);
    }
    public function getSoundIdsList():Array{
        var idsList:Array=new Array();
        for (var idSnd:String in soundList)
            idsList.push(idSnd);
        return idsList;
    }
    public function addImage(id,url:String):void{
        imgList[id]=url;
    }
    public function existsImage(id:String):Boolean{
        return (imgList[id]!=null);
    }
    public function getImageUrl(id:String):String{
        return imgList[id];
    }
    public function addSound(id,url:String):void{
        soundList[id]=url;
    }
    public function existsSound(id:String):Boolean{
        return (soundList[id]!=null);
    }
    public function getSoundUrl(id:String):String{
        return soundList[id];
    }
    public function loadXml(umlUrl:String){
        clear();
        xmlLoader.load(new URLRequest(umlUrl));
    }
    private function onLoad(e:Event){
        xmlData=new XML(e.currentTarget.data);
        var remoteImages:XMLList=xmlData.game.images.img;
        for each  (var x:* in remoteImages)
            addImage(x.@id,x.@url);
        var remoteSound:XMLList=xmlData.game.sound.track;
        for each  (var x:* in remoteSound)
            addSound(x.@id,x.@url);
        if(_onCompleteXmlLoad!=null)
            _onCompleteXmlLoad();
    }
    public function clear(){
        for each  (var item in imgList)
            delete imgList[item]
        imgList = new Object();
        for each  (var item in soundList)
            delete soundList[item]
        soundList = new Object();
    }
    public function dispose(){
        for (var item in imgList)
            delete imgList[item]
        imgList = null;
        for (var item in soundList)
            delete soundList[item]
        soundList = null;
    }
    public function set onCompleteXmlLoad(value:Function):void{
        _onCompleteXmlLoad=value;
    }
}
}
