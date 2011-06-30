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

public class RemoteImageList {
    private var xmlData:XML;
    private static var imgList:Object=new Object();
    private var _onCompleteXmlLoad:Function;
    private var xmlLoader:URLLoader=new URLLoader();
    
    public function RemoteImageList() {
        xmlLoader.addEventListener(Event.COMPLETE,onLoad);
    }
    public function addImage(id,url:String):void{
        imgList[id]=url;
    }
    public function exists(id:String):Boolean{
        return (imgList[id]!=null);
    }
    public function getImageUrl(id:String):String{
        return imgList[id];
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
        if(_onCompleteXmlLoad!=null)
            _onCompleteXmlLoad();
    }
    // todo Доделать clear()
    public function clear(){
        for each  (var item:* in imgList)
            trace(item)
    }
    public function set onCompleteXmlLoad(value:Function):void{
        _onCompleteXmlLoad=value;
    }
}
}
