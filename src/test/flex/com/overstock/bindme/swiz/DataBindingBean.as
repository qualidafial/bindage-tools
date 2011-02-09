package com.overstock.bindme.swiz {
import com.overstock.bindme.Bind;

[Bindable]
public class DataBindingBean {

  public var foo:*;

  public var bar:*;

  public function DataBindingBean() {
  }

  [DataBinding]
  public function init():void {
    Bind.fromProperty(this, "foo")
        .toProperty(this, "bar");
  }
}
}
