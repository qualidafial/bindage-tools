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
import org.hamcrest.Matcher;
import org.hamcrest.collection.hasItem;
import org.hamcrest.number.greaterThan;
import org.hamcrest.number.greaterThanOrEqualTo;
import org.hamcrest.number.lessThan;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.sameInstance;
import org.mockito.integrations.given;
import org.mockito.integrations.verify;

[RunWith( "org.mockito.integrations.flexunit4.MockitoClassRunner" )]
public class ToConditionTest {

  function ToConditionTest() {
  }

  [Mock]
  public var matcher:Matcher;

  [Test( expected="ArgumentError" )]
  public function toConditionNoArguments():void {
    toCondition();
  }

  [Test( expected="ArgumentError" )]
  public function toConditionNullArgument():void {
    toCondition(null);
  }

  [Test( expected="ArgumentError" )]
  public function toConditionNotMatcherOrFunction():void {
    toCondition("foo");
  }

  [Test( expected="ArgumentError" )]
  public function toConditionFirstOfTwoArgsNotValid():void {
    toCondition("foo", equalTo("foo"));
  }

  [Test( expected="ArgumentError" )]
  public function toConditionMatcherAndInvalidArgument():void {
    toCondition(equalTo("foo"), "foo");
  }

  [Test( expected="ArgumentError" )]
  public function toConditionFunctionAndInvalidArgument():void {
    function foo():void {
    }

    toCondition(foo, "bar");
  }

  [Test( expected="ArgumentError" )]
  public function toConditionFunctionWithMoreThanOneMatcher():void {
    function foo():void {
    }

    toCondition(foo, greaterThanOrEqualTo(0), lessThan(100));
  }

  [Test]
  public function toConditionMatcher():void {
    given(matcher.matches("a")).willReturn(true);
    given(matcher.matches("b")).willReturn(false);

    var converter:Function = toCondition(matcher);
    assertThat(converter("a"),
               equalTo(true));
    assertThat(converter("b"),
               equalTo(false));

    verify().that(matcher.matches("a"));
    verify().that(matcher.matches("b"));
  }

  [Test]
  public function toConditionFunction():void {
    function lessThanZero( value:Number ):Boolean {
      return value < 0;
    }

    var converter:Function = toCondition(lessThanZero);
    assertThat(converter,
               sameInstance(lessThanZero));
  }

  [Test]
  public function toConditionMatchers():void {
    var converter:Function = toCondition(lessThan(0), greaterThan(0));

    assertThat(converter(-1, 1),
               equalTo(true));
    assertThat(converter(-1, -1),
               equalTo(false));
    assertThat(converter(1, 1),
               equalTo(false));
    assertThat(converter(1, -1),
               equalTo(false));
  }

  [Test( expected="ArgumentError" )]
  public function toConditionMatchersTooFewValues():void {
    var converter:Function = toCondition(lessThan(0), greaterThan(0));
    converter(-1);
  }

  [Test( expected="ArgumentError" )]
  public function toConditionMatchersTooManyValues():void {
    var converter:Function = toCondition(lessThan(0), greaterThan(0));
    converter(-1, 1, "blah");
  }

  [Test]
  public function testToConditionFunctionWithMatcher():void {
    var converter:Function = toCondition(args(), hasItem(equalTo("a")));

    assertThat(converter("a", "b"),
               equalTo(true));
    assertThat(converter("b", "c"),
               equalTo(false));
  }

}

}