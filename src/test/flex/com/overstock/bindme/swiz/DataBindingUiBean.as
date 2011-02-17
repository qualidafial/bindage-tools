package com.overstock.bindme.swiz {
import com.overstock.bindme.Bind;

import mx.core.UIComponent;

[Bindable]
public class DataBindingUiBean extends UIComponent {

  public var foo:*;

  public var bar:*;

  public function DataBindingUiBean() {
  }

  [DataBinding]
  public function init():void {
    Bind.fromProperty(this, "foo")
        .toProperty(this, "bar");
  }
}
}
