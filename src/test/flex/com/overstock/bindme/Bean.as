/*
 * The contents of this file are subject to the Mozilla Public License
 * Version 1.1 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 * 
 * The Original Code is "BindMe Data Binding Framework for Flex ActionScript 3."
 * 
 * The Initial Developer of the Original Code is Overstock.com.
 * Portions created by Overstock.com are Copyright (C) 2011.
 * All Rights Reserved.
 * 
 * Contributor(s):
 * - Matthew Hall, Overstock.com <qualidafial@gmail.com> 
 */

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
