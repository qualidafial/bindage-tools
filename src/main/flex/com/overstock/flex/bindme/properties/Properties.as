package com.overstock.flex.bindme.properties {
import com.overstock.flex.bindme.*;

import mx.collections.IList;

/**
 * Helper class providing some common properties.
 */
public class Properties {

  /**
   * Returns a Property instance representing the item at the specified index of an ArrayCollection.
   *
   * @param the item index that the returned property represents.
   */
  public static function itemAt( index:int ):Property {
    var getter:Function = function( obj:IList ):* {
      return obj.getItemAt(index);
    }
    var setter:Function = function( obj:IList,
                                    value:* ):void {
      obj.setItemAt(value, index);
    }
    return Property.make("getItemAt", getter, setter);
  }

}

}