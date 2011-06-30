/**
 * User: LeX Gorbunov
 * Date: 23.06.11
 * Time: 11:04
 * E-mail: lexgorbunov@swdrom.com
 */
package ru.lglab {
public class Utils {
    public function Utils() {
    }
    static function rangeRand(min,max:Number):Number{
        return Math.floor(Math.random() * (max-min)) + min;
    }
}
}
