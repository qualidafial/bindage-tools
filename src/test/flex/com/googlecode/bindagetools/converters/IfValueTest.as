/*
 * Copyright 2011 Overstock.com and others.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.googlecode.bindagetools.converters {
import org.flexunit.assertThat;
import org.hamcrest.CustomMatcher;
import org.hamcrest.Matcher;
import org.hamcrest.collection.hasItem;
import org.hamcrest.number.greaterThan;
import org.hamcrest.number.greaterThanOrEqualTo;
import org.hamcrest.number.lessThan;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.hasProperty;

public class IfValueTest {

  function IfValueTest() {
  }

  [Test( expected="ArgumentError" )]
  public function ifValueNoArguments():void {
    ifValue();
  }

  [Test( expected="ArgumentError" )]
  public function ifValueNullArgument():void {
    ifValue(null);
  }

  [Test( expected="ArgumentError" )]
  public function ifValueNotMatcherOrFunction():void {
    ifValue("foo");
  }

  [Test( expected="ArgumentError" )]
  public function ifValueFirstOfTwoArgsNotValid():void {
    ifValue("foo", equalTo("foo"));
  }

  [Test( expected="ArgumentError" )]
  public function ifValueMatcherAndInvalidArgument():void {
    ifValue(equalTo("foo"), "foo");
  }

  [Test( expected="ArgumentError" )]
  public function ifValueFunctionAndInvalidArgument():void {
    function foo():void {
    }

    ifValue(foo, "bar");
  }

  [Test( expected="ArgumentError" )]
  public function ifValueFunctionWithMoreThanOneMatcher():void {
    function foo():void {
    }

    ifValue(foo, greaterThanOrEqualTo(0), lessThan(100));
  }

  [Test]
  public function ifValueSingleArgument():void {
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
  public function ifValueFunction():void {
    function lengthLessThanFive( value:String ):Boolean {
      return value.length < 5;
    }

    var converter:Function = ifValue(lengthLessThanFive)
        .thenConvert(toConstant("less than five"))
        .elseConvert(toConstant("more than five"));

    assertThat(converter("abc"),
               equalTo("less than five"));
    assertThat(converter("abcde"),
               equalTo("more than five"));
  }

  [Test]
  public function ifValueMultipleMatchers():void {
    var converter:Function = ifValue(lessThan(0), greaterThan(0))
        .thenConvert(toConstant("true"))
        .elseConvert(toConstant("false"));

    assertThat(converter(-1, 1),
               equalTo("true"));
    assertThat(converter(-1, -1),
               equalTo("false"));
    assertThat(converter(1, 1),
               equalTo("false"));
    assertThat(converter(1, -1),
               equalTo("false"));
  }

  [Test( expected="ArgumentError" )]
  public function toConditionMatchersTooFewValues():void {
    var converter:Function = ifValue(lessThan(0), greaterThan(0))
        .thenConvert(toConstant("true"))
        .elseConvert(toConstant("false"));
    converter(-1);
  }

  [Test( expected="ArgumentError" )]
  public function toConditionMatchersTooManyValues():void {
    var converter:Function = ifValue(lessThan(0), greaterThan(0))
        .thenConvert(toConstant("true"))
        .elseConvert(toConstant("false"));
    converter(-1, 1, "blah");
  }

  [Test]
  public function ifValueMultipleArguments():void {
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

    var isOdd:Matcher = new CustomMatcher("is odd",
                                          function( value:Number ):Boolean {
                                            return value % 2 == 1;
                                          });

    var converter:Function = ifValue(args(), hasItem(isOdd))
        .thenConvert(toProduct)
        .elseConvert(toSum);

    assertThat(converter(0, 2, 4), // no odd elements
               equalTo(6)); // sum

    assertThat(converter(2, 3, 4), // 1 odd element
               equalTo(24)); // product
  }

}

}