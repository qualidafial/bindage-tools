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

package com.overstock.bindme.converters {
import org.flexunit.assertThat;
import org.hamcrest.CustomMatcher;
import org.hamcrest.Matcher;
import org.hamcrest.collection.hasItem;
import org.hamcrest.number.lessThan;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.hasProperty;

public class IfValueTest {

  function IfValueTest() {
  }

  [Test]
  public function testIfValue():void {
    function toUpperCase( value:String ):String {
      return value.toUpperCase();
    }

    function toLowerCase( value:String ):String {
      return value.toLowerCase();
    }

    var converter:Function = ifValue(hasProperty("length", lessThan(5)))
        .thenConvert(toLowerCase)
        .elseConvert(toUpperCase);

    assertThat(converter("AaBb"),
               equalTo("aabb"));
    assertThat(converter("AaBbCc"),
               equalTo("AABBCC"));
  }

  [Test]
  public function testIfValueMultipleValues():void {
    function toSum( ...addends ):Number {
      var result:Number = 0;

      for each (var addend:Number in addends) {
        result += addend;
      }

      return result;
    }

    function toProduct( ...factors ):Number {
      var result:Number = 1;

      for each (var factor:Number in factors) {
        result *= factor;
      }

      return result;
    }

    var isOdd:Matcher = new CustomMatcher("is odd", function( value:Number ):Boolean {
      return value % 2 == 1;
    });

    var converter:Function = ifValue(hasItem(isOdd))
        .thenConvert(toProduct)
        .elseConvert(toSum);

    assertThat(converter([0, 2, 4]), // no odd elements
               equalTo(6)); // sum

    assertThat(converter([2, 3, 4]), // 1 odd element
               equalTo(24)); // product
  }

}

}