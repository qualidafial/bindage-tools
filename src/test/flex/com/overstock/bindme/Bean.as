package com.overstock.bindme {
import flash.events.Event;

[Bindable]
public class Bean {

  function Bean() {
  }

  private var _foo:*;
  private var _bar:*;
  private var _baz:*;
  private var _receiveCount:Number = 0;
  private var _receivedValues:Array = null;

  /*
   * Setters in this class intentionally dispatch events regardless of whether the property
   * actually changed values.  Usually the compiler optimizes bindings properties to prevent
   * unnecessary event dispatching, but occasionally in client code and in the Flex core
   * libraries this is not always enforced.  By intentionally omitting this optimization,
   * we can be more confident that testing will catch infinite recursion problems.
   */

  [Bindable( "fooChanged" )]
  public function get foo():* {
    return _foo;
  }

  public function set foo( value:* ):void {
    _foo = value;
    dispatchEvent(new Event("fooChanged"));
  }

  [Bindable( "barChanged" )]
  public function get bar():* {
    return _bar;
  }

  public function set bar( value:* ):void {
    _bar = value;
    dispatchEvent(new Event("barChanged"));
  }

  [Bindable( "bazChanged" )]
  public function get baz():* {
    return _baz;
  }

  public function set baz( value:* ):void {
    _baz = value;
    dispatchEvent(new Event("bazChanged"));
  }

  public function get receiveCount():Number {
    return _receiveCount;
  }

  public function get receivedValues():Array {
    return _receivedValues;
  }

  public function receive( ... values ):void {
    _receiveCount++;
    _receivedValues = values;
  }

}

}
