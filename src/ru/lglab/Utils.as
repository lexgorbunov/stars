/**
 * User: LeX Gorbunov
 * Date: 23.06.11
 * Time: 11:04
 * E-mail: lexgorbunov@swdrom.com
 */
package ru.lglab {
import mx.utils.StringUtil;

public class Utils {
    public function Utils() {
    }

    public static function rangeRand(min, max:Number):Number {
        return Math.floor(Math.random() * (max - min)) + min;
    }

    public static function getDateLastVisit(lastVDate:Date):String {
        return StringUtil.substitute(
                'Дата последнего запуска: {0}.{1}.{2} {3}:{4}:{5}',
                lastVDate.getDate(),
                lastVDate.getMonth(),
                lastVDate.getFullYear(),
                lastVDate.getHours(),
                lastVDate.getMinutes(),
                lastVDate.getSeconds()
                );
    }
}
}
