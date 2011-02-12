package com.overstock.bindme.properties {

/**
 * Returns a custom property object for the item at the specified index.  May be used with
 * Array and ILists.
 *
 * @param index the item index
 * @return a property object for getting/setting/watching the item at the specified index.
 */
public function itemAt( index:int ):Object {
  if (index < 0) {
    throw new ArgumentError("index must be >= 0");
  }

  function getter( obj:Object ):* {
    return obj.length > index
        ? obj[index]
        : null;
  }

  function setter( obj:Object,
                   value:* ):void {
    if (obj.length > index) {
      obj[index] = value;
    }
  }

  return {
    name: "getItemAt",
    getter: getter,
    setter: setter
  }
}

}
