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

package com.googlecode.bindme {
import com.googlecode.bindme.converters.emptyStringToNull;
import com.googlecode.bindme.converters.toCondition;
import com.googlecode.bindme.properties.itemAt;
import com.googlecode.bindme.util.unwatchAll;

import mx.binding.utils.ChangeWatcher;
import mx.collections.ArrayCollection;
import mx.logging.ILogger;
import mx.logging.ILoggingTarget;
import mx.logging.Log;
import mx.logging.LogEvent;
import mx.logging.LogEventLevel;

import org.flexunit.async.Async;
import org.hamcrest.assertThat;
import org.hamcrest.collection.array;
import org.hamcrest.collection.hasItem;
import org.hamcrest.core.not;
import org.hamcrest.number.greaterThan;
import org.hamcrest.number.lessThan;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.hasProperties;
import org.hamcrest.object.instanceOf;
import org.hamcrest.text.re;

public class BindTest implements ILoggingTarget {

  private var source:Bean;
  private var target:Bean;

  private var logEvents:Array;

  function BindTest() {
  }

  [Before]
  public function setUp():void {
    source = new Bean();
    target = new Bean();
  }

  [Test]
  public function fromProperty():void {
    assertThat(Bind.fromProperty(source, "foo"),
               instanceOf(IPipelineBuilder));
  }

  [Test]
  public function fromPropertyToProperty():void {
    source.foo = "abc";

    Bind.fromProperty(source, "foo")
        .toProperty(target, "bar");

    assertThat(target.bar,
               equalTo("abc"));

    source.foo = "xyz";

    assertThat(target.bar,
               equalTo("xyz"))

    target.bar = "123";

    assertThat(source.foo,
               equalTo("xyz")) // i.e. non-reciprocal
  }

  [Test( expected="ArgumentError" )]
  public function fromPropertyNullSource():void {
    Bind.fromProperty(null, "foo");
  }

  [Test( expected="ArgumentError" )]
  public function fromPropertyNullProperty():void {
    Bind.fromProperty(source, null);
  }

  [Test( expected="ArgumentError" )]
  public function fromPropertyToPropertyNullSource():void {
    Bind.fromProperty(source, "foo")
        .toProperty(null, "bar");
  }

  [Test( expected="ArgumentError" )]
  public function fromPropertyToPropertyNullProperty():void {
    Bind.fromProperty(source, "foo")
        .toProperty(target, null);
  }

  [Test]
  public function fromNestedPropertyToProperty():void {
    source.foo = new Bean();
    source.foo.bar = "abc";

    Bind.fromProperty(source, "foo.bar")
        .toProperty(target, "baz");

    assertThat(target.baz,
               equalTo("abc"));

    source.foo.bar = "xyz";

    assertThat(target.baz,
               equalTo("xyz"));

    var newFoo:Bean = new Bean();
    newFoo.bar = "123";
    source.foo = newFoo;

    assertThat(target.baz,
               equalTo("123"));
  }

  [Test]
  public function fromNestedCustomPropertyToProperty():void {
    source.foo = new ArrayCollection([ new Bean() ]);
    source.foo[0].bar = 1;

    Bind.fromProperty(source, "foo", itemAt(0), "bar")
        .toProperty(target, "baz");

    assertThat(target.baz,
               equalTo(1));

    source.foo[0].bar = 2;

    assertThat(target.baz,
               equalTo(2));

    var newItem:Bean = new Bean();
    newItem.bar = 3;

    source.foo[0] = newItem;
    assertThat(target.baz,
               equalTo(3));

    newItem = new Bean();
    newItem.bar = 4;

    var newFoo:ArrayCollection = new ArrayCollection();
    newFoo.addItem(newItem);

    source.foo = newFoo;
    assertThat(target.baz,
               equalTo(4));
  }

  [Test( expected="ArgumentError" )]
  public function fromCustomPropertyMissingName():void {
    Bind.fromProperty(source, { getter: source.receive });
  }

  [Test( expected="ArgumentError" )]
  public function fromCustomPropertyMissingGetter():void {
    Bind.fromProperty(source, { name: "foo" });
  }

  [Test( expected="ArgumentError" )]
  public function fromCustomPropertyBadName():void {
    Bind.fromProperty(source, { name: 42, getter: source.receive });
  }

  [Test( expected="ArgumentError" )]
  public function fromCustomPropertyBadGetter():void {
    Bind.fromProperty(source, { name: "foo", getter: 42 });
  }

  [Test( expected="ArgumentError" )]
  public function fromPropertyToCustomPropertyMissingName():void {
    Bind.fromProperty(source, "foo")
        .toProperty(target, { setter: target.receive });
  }

  [Test( expected="ArgumentError" )]
  public function fromPropertyToCustomPropertyMissingSetter():void {
    Bind.fromProperty(source, "foo")
        .toProperty(target, { name: "bar" });
  }

  [Test( expected="ArgumentError" )]
  public function fromPropertyToCustomPropertyBadName():void {
    Bind.fromProperty(source, "foo")
        .toProperty(target, { name: 42, setter: target.receive });
  }

  [Test( expected="ArgumentError" )]
  public function fromPropertyToCustomPropertyBadSetter():void {
    Bind.fromProperty(source, "foo")
        .toProperty(target, { name: "bar", setter: 42 });
  }

  [Test]
  public function fromCustomPropertyToProperty():void {
    var list:ArrayCollection = new ArrayCollection([ 1 ]);

    Bind.fromProperty(list, itemAt(0))
        .toProperty(target, "foo");

    assertThat(target.foo,
               equalTo(1));

    list[0] = 2;

    assertThat(target.foo,
               equalTo(2));
  }

  [Test]
  public function fromPropertyToCustomProperty():void {
    source.foo = 1;
    var list:ArrayCollection = new ArrayCollection([ null ]);

    Bind.fromProperty(source, "foo")
        .toProperty(list, itemAt(0));

    assertThat(list[0],
               equalTo(1));

    source.foo = 2;

    assertThat(list[0],
               equalTo(2));
  }

  [Test]
  public function fromPropertyToNestedCustomProperty():void {
    source.foo = 1;
    target.bar = new ArrayCollection([ new Bean() ]);

    Bind.fromProperty(source, "foo")
        .toProperty(target, "bar", itemAt(0), "baz");

    assertThat(target.bar[0].baz,
               equalTo(1));

    source.foo = 2;

    assertThat(target.bar[0].baz,
               equalTo(2));
  }

  [Test]
  public function fromNestedPropertyToPropertyWithInitiallyNullParentProperty():void {
    source.foo = null;
    target.baz = "will be overwritten";

    Bind.fromProperty(source, "foo.bar")
        .toProperty(target, "baz");

    assertThat(target.baz,
               equalTo(null));
  }

  [Test]
  public function fromNestedPropertyToPropertySetParentPropertyToNull():void {
    source.foo = new Bean();
    source.foo.bar = "abc";

    Bind.fromProperty(source, "foo.bar")
        .toProperty(target, "baz");

    source.foo = null;

    assertThat(target.baz,
               equalTo(null));
  }

  [Test]
  public function fromPropertyToNestedProperty():void {
    source.foo = "abc";
    target.bar = new Bean();

    Bind.fromProperty(source, "foo")
        .toProperty(target, "bar.baz");

    assertThat(target.bar.baz,
               equalTo("abc"));

    source.foo = "xyz";

    assertThat(target.bar.baz,
               equalTo("xyz"));
  }

  [Test]
  public function fromPropertyToDeeplyNestedPropertyInitiallyNullParentProperty():void {
    source.foo = "abc";
    target.foo = null;

    Bind.fromProperty(source, "foo")
        .toProperty(target, "foo.bar.baz");

    assertThat(target.foo,
               equalTo(null));

    target.foo = new Bean();
    source.foo = "xyz";

    assertThat(target.foo.bar,
               equalTo(null));

    target.foo.bar = new Bean();
    source.foo = "123";

    assertThat(target.foo.bar.baz,
               equalTo("123"));
  }

  [Test]
  public function fromPropertyToNestedPropertyReplaceParentObject():void {
    source.foo = "abc";

    var originalBar:Bean = new Bean();
    target.bar = originalBar;

    Bind.fromProperty(source, "foo")
        .toProperty(target, "bar.baz");

    assertThat(target.bar.baz,
               equalTo("abc"));

    var newBar:Bean = new Bean();

    target.bar = newBar;

    source.foo = "xyz";

    assertThat(target.bar.baz,
               equalTo("xyz"));
    assertThat(originalBar.baz,
               equalTo("abc"));
    assertThat(newBar.baz,
               equalTo("xyz"));
  }

  [Test]
  public function fromPropertyToNestedInitiallyNullProperty():void {
    source.foo = "abc";
    target.bar = null;

    Bind.fromProperty(source, "foo")
        .toProperty(target, "bar.baz");

    assertThat(target.bar,
               equalTo(null));

    target.bar = new Bean();
    source.foo = "xyz";

    assertThat(target.bar.baz,
               equalTo("xyz"));
  }

  [Test]
  public function fromPropertyToFunction():void {
    source.foo = "abc";

    var receivedValue:*

    function theFunction( value:* ):void {
      receivedValue = value;
    }

    Bind.fromProperty(source, "foo")
        .toFunction(theFunction);

    assertThat(receivedValue,
               equalTo("abc"));

    source.foo = "xyz";

    assertThat(receivedValue,
               equalTo("xyz"));
  }

  [Test]
  public function fromPropertyConvertToProperty():void {
    source.foo = "abc";

    Bind.fromProperty(source, "foo")
        .convert(toUpperCase)
        .toProperty(target, "foo");

    assertThat(target.foo,
               equalTo("ABC"));

    source.foo = "xyz";

    assertThat(target.foo,
               equalTo("XYZ"));
  }

  [Test( expected="ArgumentError" )]
  public function fromPropertyConvertNullConverter():void {
    Bind.fromProperty(source, "foo")
        .convert(null);
  }

  [Test]
  public function fromPropertyConvertToFunction():void {
    source.foo = "abc";

    Bind.fromProperty(source, "foo")
        .convert(toUpperCase)
        .toFunction(target.receive);

    assertThat(target.receiveCount,
               equalTo(1));
    assertThat(target.receivedValues,
               array("ABC"));

    source.foo = "xyz";

    assertThat(target.receiveCount,
               equalTo(2));
    assertThat(target.receivedValues,
               array("XYZ"));
  }

  [Test( expected="ArgumentError" )]
  public function fromPropertyValidateNoArguments():void {
    Bind.fromProperty(source, "foo")
        .validate();
  }

  [Test( expected="ArgumentError" )]
  public function fromPropertyValidateNullArgument():void {
    Bind.fromProperty(source, "foo")
        .validate(null);
  }

  [Test( expected="ArgumentError" )]
  public function fromPropertyValidateNotMatcherOrFunction():void {
    Bind.fromProperty(source, "foo")
        .validate("hello");
  }

  [Test( expected="ArgumentError" )]
  public function fromPropertyValidateFirstOfTwoArgsNotFunction():void {
    Bind.fromProperty(source, "foo")
        .validate("stuff", equalTo(null));
  }

  [Test( expected="ArgumentError" )]
  public function fromPropertyValidateLastOfTwoArgsNotMatcher():void {
    Bind.fromProperty(source, "foo")
        .validate(emptyStringToNull(), "stuff");
  }

  [Test]
  public function fromPropertyValidateToProperty():void {
    source.foo = 1;
    target.bar = -1;

    Bind.fromProperty(source, "foo")
        .validate(greaterThan(1))
        .toProperty(target, "bar");

    assertThat(target.bar,
               equalTo(-1)); // validation fails, no change

    source.foo = 2;

    assertThat(target.bar,
               equalTo(2)); // validation passes, new value set

    source.foo = 0;

    assertThat(target.bar,
               equalTo(2)); // validation fails, no change
  }

  [Test]
  public function fromPropertyValidateWithFunctionToProperty():void {
    source.foo = "abc";
    target.bar = "xyz";

    Bind.fromProperty(source, "foo")
        .validate(
        function( value:String ):Boolean {
          return value.length > 0 && value.length < 5 && value.charAt(1) == "a";
        })
        .toProperty(target, "bar");

    assertThat(target.bar,
               equalTo("xyz")); // vaildation fails, no change

    source.foo = "bar";

    assertThat(target.bar,
               equalTo("bar")); // validation passes, new value set

    source.foo = "baz";
    assertThat(target.bar,
               equalTo("baz")); // validation passes, new value set
  }

  [Test]
  public function fromPropertyValidateConvertToProperty():void {
    source.foo = "5";
    target.bar = -1;

    var integerPattern:RegExp = /\d+/;

    Bind.fromProperty(source, "foo")
        .validate(re(integerPattern))
        .convert(toNumber)
        .toProperty(target, "bar");

    assertThat(target.bar,
               equalTo(5));

    source.foo = "foo";
    assertThat(target.bar,
               equalTo(5)); // validation failed, no change

    source.foo = "10";

    assertThat(target.bar,
               equalTo(10)); // validation passed, set new value
  }

  [Test]
  public function fromPropertyConvertValidateToProperty():void {
    source.foo = "1";
    target.bar = -1;

    Bind.fromProperty(source, "foo")
        .convert(toNumber)
        .validate(greaterThan(5))
        .toProperty(target, "bar");

    assertThat(target.bar,
               equalTo(-1)); // validation failed, no change

    source.foo = "6";

    assertThat(target.bar,
               equalTo(6)); // validation passed, set new value
  }

  [Test]
  public function fromPropertyValidateConvertValidateToProperty():void {
    source.foo = "abc";
    target.bar = 10;

    var integerPattern:RegExp = /\d+/;

    Bind.fromProperty(source, "foo")
        .validate(re(integerPattern))
        .convert(toNumber)
        .validate(greaterThan(5))
        .toProperty(target, "bar");

    assertThat(target.bar,
               equalTo(10)); // regexp validation failed, no change

    source.foo = "5";

    assertThat(target.bar,
               equalTo(10)); // range validation failed, no change

    source.foo = "6";

    assertThat(target.bar,
               equalTo(6)); // both validators passed, set new value
  }

  [Test( expected="ArgumentError" )]
  public function fromPropertyLogInvalidLevel():void {
    Bind.fromProperty(source, "foo")
        .log(LogEventLevel.INFO + LogEventLevel.WARN, "message");
  }

  [Test( expected="ArgumentError" )]
  public function fromPropertyLogNullMessage():void {
    Bind.fromProperty(source, "foo")
        .log(LogEventLevel.INFO, null);
  }

  [Test]
  public function fromPropertyLogToProperty():void {
    logEvents = [];
    Log.addTarget(this);

    source.foo = "abc";

    Bind.fromProperty(source, "foo")
        .log(LogEventLevel.INFO, "value is {0}")
        .toProperty(target, "bar");

    assertThat(logEvents,
               hasItem(hasProperties({
                 level:LogEventLevel.INFO,
                 message: "value is abc"
               })));

    source.foo = "xyz";
    assertThat(logEvents,
               hasItem(hasProperties({
                 level:LogEventLevel.INFO,
                 message: "value is xyz"
               })));
  }

  [Test( expected="ArgumentError" )]
  public function fromPropertyFormatNullFormat():void {
    Bind.fromProperty(source, "foo")
        .format(null);
  }

  [Test]
  public function fromPropertyFormatToProperty():void {
    source.foo = "Hello";

    Bind.fromProperty(source, "foo")
        .format("{0}, world!")
        .toProperty(target, "bar");

    assertThat(target.bar,
               equalTo("Hello, world!"));
  }

  [Test( async )]
  public function fromPropertyDelayToProperty():void {
    source.foo = 1;

    Bind.fromProperty(source, "foo")
        .log(LogEventLevel.INFO, "fromPropertyDelayToProperty: delaying value {0}")
        .delay(50)
        .log(LogEventLevel.INFO, "fromPropertyDelayToProperty: delay expired for value {0}")
        .toProperty(target, "bar");

    assertThat(target.bar,
               equalTo(null));

    source.foo = 2;
    assertThat(target.bar,
               equalTo(null));

    source.foo = 3;
    assertThat(target.bar,
               equalTo(null));

    Async.proceedOnEvent(this, target, "barChanged", 100, verifyTargetChanged);
    function verifyTargetChanged( event:* ):void {
      assertThat(target.bar,
                 equalTo(1));
    }
  }

  [Test( async )]
  public function twoWayDelayed():void {
    source.foo = 1;

    function plusOne( value:Number ):Number {
      return value + 1;
    }

    Bind.twoWay(
        Bind.fromProperty(source, "foo")
            .convert(plusOne),
        Bind.fromProperty(target, "bar")
            .log(LogEventLevel.INFO, "twoWayDelayed: delaying value {0}")
            .delay(50)
            .log(LogEventLevel.INFO, "twoWayDelayed: delay expired for value {0}"));

    assertThat(target.bar,
               equalTo(2));

    target.bar = 3;
    target.bar = 4;
    target.bar = 5;

    Async.proceedOnEvent(this, source, "fooChanged", 100, verifySourceChanged);

    Async.failOnEvent(this, target, "barChanged"); // ensure two-way binding does not rebound

    function verifySourceChanged( event:* ):void {
      assertThat(source.foo,
                 equalTo(5));

    }
  }

  [Test]
  public function fromAllFormatToProperty():void {
    source.foo = "Hello";
    source.bar = "world";

    Bind.fromAll(
        Bind.fromProperty(source, "foo"),
        Bind.fromProperty(source, "bar")
        )
        .format("{0}, {1}!")
        .toProperty(target, "baz");

    assertThat(target.baz,
               equalTo("Hello, world!"));

    source.bar = "children";

    assertThat(target.baz,
               equalTo("Hello, children!"));
  }

  [Test]
  public function fromAllLogToProperty():void {
    logEvents = [];
    Log.addTarget(this);

    source.foo = "ABC";
    source.bar = "123";

    Bind.fromAll(
        Bind.fromProperty(source, "foo"),
        Bind.fromProperty(source, "bar")
        )
        .log(LogEventLevel.INFO, "{0}'s and {1}'s")
        .toProperty(target, "baz");

    assertThat(logEvents,
               hasItem(hasProperties({
                 level: LogEventLevel.INFO,
                 message: "ABC's and 123's"
               })));

    source.foo = "XYZ";
    source.bar = "pdq";

    assertThat(logEvents,
               hasItem(hasProperties({
                 level: LogEventLevel.INFO,
                 message: "XYZ's and pdq's"
               })));
  }

  [Test]
  public function twoWay():void {
    source.foo = 10;
    target.bar = null;

    Bind.twoWay(
        Bind.fromProperty(source, "foo"),
        Bind.fromProperty(target, "bar"));

    assertThat(target.bar,
               equalTo(10));

    source.foo = 11;

    assertThat(target.bar,
               equalTo(11));

    target.bar = 12;

    assertThat(source.foo,
               equalTo(12));
  }

  [Test( expected="ArgumentError" )]
  public function twoWaySourceNotInstanceOfIPropertyPipeline():void {
    Bind.twoWay(
        Bind.fromAll(Bind.fromProperty(source, "foo"),
                     Bind.fromProperty(source, "bar")),
        Bind.fromProperty(target, "baz"));
  }

  [Test( expected="ArgumentError" )]
  public function twoWayTargetNotInstanceOfIPropertyPipeline():void {
    Bind.twoWay(
        Bind.fromProperty(target, "baz"),
        Bind.fromAll(Bind.fromProperty(source, "foo"),
                     Bind.fromProperty(source, "bar")));
  }

  [Test]
  public function twoWayWithConvertAndValidate():void {
    source.foo = null;
    target.bar = "dummy";

    var integerPattern:RegExp = /\d+/;

    Bind.twoWay(
        Bind.fromProperty(source, "foo")
            .convert(numberToString),
        Bind.fromProperty(target, "bar")
            .validate(re(integerPattern))
            .convert(toNumber)
            .validate(lessThan(10)));
  }

  [Test]
  public function twoWayMutuallyShortCircuits():void {
    source.foo = "abc";
    target.bar = null;

    Bind.twoWay(
        Bind.fromProperty(source, "foo")
            .convert(toUpperCase),
        Bind.fromProperty(target, "bar"));

    assertThat(target.bar,
               equalTo("ABC"));
    assertThat(source.foo,
               equalTo("abc")); // would be uppercase if target-to-source binding executed

    target.bar = "xyz";

    assertThat(source.foo,
               equalTo("xyz"));
    assertThat(target.bar,
               equalTo("xyz")); // would be uppercase if source-to-target binding executed

  }

  [Test]
  public function collectFromPropertyToProperty():void {
    function createBindings():void {
      Bind.fromProperty(source, "foo")
          .toProperty(target, "bar");
    }

    var collected:Array = BindTracker.collect(createBindings);

    assertThat(collected,
               array(instanceOf(ChangeWatcher)));

    source.foo = 1;
    assertThat(target.bar,
               equalTo(1));

    unwatchAll(collected);

    source.foo = 2;
    assertThat(target.bar,
               equalTo(1)); // unchanged, change watcher is disposed
  }

  [Test]
  public function collectFromPropertyToFunction():void {
    function createBindings():void {
      Bind.fromProperty(source, "foo")
          .toFunction(target.receive);
    }

    var collected:Array = BindTracker.collect(createBindings);

    assertThat(collected,
               array(instanceOf(ChangeWatcher)));

    assertThat(target.receiveCount,
               equalTo(1));

    source.foo = 1;
    assertThat(target.receiveCount,
               equalTo(2));

    unwatchAll(collected);

    source.foo = 2;
    assertThat(target.receiveCount,
               equalTo(2));
  }

  [Test]
  public function collectTwoWay():void {
    function createBindings():void {
      Bind.twoWay(
          Bind.fromProperty(source, "foo"),
          Bind.fromProperty(target, "bar"));
    }

    var collected:Array = BindTracker.collect(createBindings);

    assertThat(collected,
               array(instanceOf(ChangeWatcher),
                     instanceOf(ChangeWatcher)));

    source.foo = 1;
    assertThat(target.bar,
               equalTo(1));

    target.bar = 2;
    assertThat(source.foo,
               equalTo(2));

    unwatchAll(collected);

    source.foo = 3;
    assertThat(target.bar,
               equalTo(2)); // unchanged, change watcher is disposed

    target.bar = 4;
    assertThat(source.foo,
               equalTo(3)); // unchanged, change watcher is disposed
  }

  [Test]
  public function collectNested():void {
    var expected:Array;

    function createBindingsInner():void {
      Bind.fromProperty(source, "foo")
          .toProperty(target, "bar");
    }

    function createBindingsOuter():void {
      expected = BindTracker.collect(createBindingsInner);
    }

    var actual:Array = BindTracker.collect(createBindingsOuter);

    assertThat(expected,
               array(instanceOf(ChangeWatcher)));

    assertThat(actual,
               array(expected[0]));
  }

  [Test]
  public function collectFromAll():void {
    function createBindings():void {
      Bind.fromAll(
          Bind.fromProperty(source, "foo"),
          Bind.fromProperty(source, "bar")
          )
          .convert(sum)
          .toProperty(target, "baz");
    }

    source.foo = 1;
    source.bar = 2;

    var collected:Array = BindTracker.collect(createBindings);

    assertThat(target.baz,
               equalTo(3));

    source.foo = 5;
    assertThat(target.baz,
               equalTo(7));

    source.bar = 10;
    assertThat(target.baz,
               equalTo(15));

    unwatchAll(collected);

    source.foo = 100;
    assertThat(target.baz,
               equalTo(15)); // unchanged, change watcher is disposed

    source.bar = 500;
    assertThat(target.baz,
               equalTo(15)); // unchanged, change watcher is disposed
  }

  [Test( expected="ArgumentError" )]
  public function fromAllNoSources():void {
    Bind.fromAll();
  }

  [Test( expected="ArgumentError" )]
  public function fromAllSingleSource():void {
    Bind.fromAll(Bind.fromProperty(source, "foo"));
  }

  [Test( expected="ArgumentError" )]
  public function fromAllSourcesNotIPipelines():void {
    Bind.fromAll(
        "foo",
        "bar"
        );
  }

  [Test( expected="ArgumentError" )]
  public function fromAllNullSources():void {
    Bind.fromAll(
        Bind.fromProperty(source, "foo"),
        null
        );
  }

  [Test]
  public function fromAll():void {
    source.foo = 2;
    source.bar = 3;
    target.baz = null;

    Bind.fromAll(
        Bind.fromProperty(source, "foo"),
        Bind.fromProperty(source, "bar")
        )
        .toProperty(target, "baz");

    assertThat(target.baz,
               array(2,
                     3));

    source.foo = 4;

    assertThat(target.baz,
               array(4,
                     3));

    source.bar = 6;

    assertThat(target.baz,
               array(4,
                     6));
  }

  [Test]
  public function fromAllConvert():void {
    source.foo = 2;
    source.bar = 3;
    target.baz = null;

    Bind.fromAll(
        Bind.fromProperty(source, "foo"),
        Bind.fromProperty(source, "bar")
        )
        .convert(sum)
        .toProperty(target, "baz");

    assertThat(target.baz,
               equalTo(5));

    source.foo = 4;

    assertThat(target.baz,
               equalTo(7));

    source.bar = 6;

    assertThat(target.baz,
               equalTo(10));
  }

  [Test]
  public function fromAllValidate():void {
    source.foo = 2;
    source.bar = 3;
    target.baz = null;

    Bind.fromAll(
        Bind.fromProperty(source, "foo"),
        Bind.fromProperty(source, "bar")
        )
        .validate(array(greaterThan(0),
                        lessThan(10)))
        .toProperty(target, "baz");

    assertThat(target.baz,
               array(2,
                     3));

    source.foo = 1;
    assertThat(target.baz,
               array(1,
                     3));

    source.bar = 9;
    assertThat(target.baz,
               array(1,
                     9));

    source.foo = 0; // fails validation
    assertThat(target.baz,
               array(1,
                     9)); // no change

    source.foo = 3;
    assertThat(target.baz,
               array(3,
                     9));

    source.bar = 10; // fails validation
    assertThat(target.baz,
               array(3,
                     9)); // no change

    source.bar = 7;
    assertThat(target.baz,
               array(3,
                     7));
  }

  [Test]
  public function fromAllValidateAttribute():void {
    source.foo = 1;
    source.bar = 2;

    Bind.fromAll(
        Bind.fromProperty(source, "foo"),
        Bind.fromProperty(source, "bar")
        )
        .validate(sum, lessThan(5))
        .toProperty(target, "baz");

    assertThat(target.baz,
               array(1, 2));

    source.foo = 2;
    assertThat(target.baz,
               array(2, 2));

    source.bar = 3; // sum is not out of bounds
    assertThat(target.baz,
               array(2, 2)); // no change

    source.foo = -1;
    assertThat(target.baz,
               array(-1, 3));
  }

  [Test]
  public function groupBindings():void {
    source.foo = 1;

    // source.foo -> source.bar -> source.baz -> source.foo etc
    var group:BindGroup = new BindGroup();
    Bind.fromProperty(source, "foo").group(group).toProperty(source, "bar");
    Bind.fromProperty(source, "bar").group(group).toProperty(source, "baz");
    Bind.fromProperty(source, "baz").group(group).toProperty(source, "foo");

    assertThat(source.bar,
               equalTo(1));
    assertThat(source.baz,
               equalTo(1));

    source.foo = 2;

    assertThat(source.bar,
               equalTo(2));
    assertThat(source.baz,
               equalTo(1)); // unchanged

    source.bar = 3;

    assertThat(source.baz,
               equalTo(3));
    assertThat(source.foo,
               equalTo(2)); // unchanged

    source.baz = 4;

    assertThat(source.foo,
               equalTo(4));
    assertThat(source.bar,
               equalTo(3)); // unchanged
  }

  [Test]
  public function groupBindingsTwoWay():void {
    source.foo = 1;

    var group:BindGroup = new BindGroup();

    Bind.twoWay(
        Bind.fromProperty(source, "foo"),
        Bind.fromProperty(target, "bar"),
        group);

    assertThat(target.bar,
               equalTo(1));

    Bind.twoWay(
        Bind.fromProperty(source, "foo"),
        Bind.fromProperty(target, "baz"),
        group);

    assertThat(target.baz,
               equalTo(1));

    source.foo = 2;

    assertThat(target.bar,
               equalTo(2)); // change events listeners are called in serial
    assertThat(target.baz,
               equalTo(2)); // so there is never contention for the group

    target.bar = 3;

    assertThat(source.foo,
               equalTo(3));
    // a binding in the group is running by the time source.foo->target.baz binding fires,
    // so it aborts
    assertThat(target.baz,
               equalTo(2));

    target.baz = 4;

    assertThat(source.foo,
               equalTo(4));
    assertThat(target.bar,
               equalTo(3)); // ditto previous block
  }

  [Test]
  public function groupBindingsSingleSourceToMultipleTargets():void {
    // This idiom often comes up in UIs, where a single data point in the model is represented by
    // several fields in the user interface.  By grouping all bindings, we ensure that a change in
    // one of these three places does not propagate inappropriately.

    // This test derived from a real-world issue where bindings overwrote the related fields
    // unexpectedly.

    source.foo = "stuff";

    var group:BindGroup = new BindGroup();

    Bind.fromProperty(source, "foo")// The data model
        .group(group)
        .convert(toCondition(not(equalTo(null))))
        .toProperty(target, "bar"); // e.g. a checkbox: "Is there a foo?"

    Bind.fromProperty(source, "foo")
        .group(group)
        .toProperty(target, "baz"); // e.g. a text input: "Enter foo name:"

    var selectionAndTextToText:Function = function( selection:Boolean,
                                                    text:String ):String {
      return selection
          ? text
          : null;
    };

    Bind.fromAll(
        Bind.fromProperty(target, "bar"),
        Bind.fromProperty(target, "baz")
        )
        .group(group)
        .convert(selectionAndTextToText)
        .toProperty(source, "foo");

    assertThat(target.bar,
               equalTo(true));
    assertThat(target.baz,
               equalTo("stuff"));

    target.baz = "junk";

    assertThat(source.foo,
               equalTo("junk"));

    target.bar = false;

    assertThat(source.foo,
               equalTo(null));
    assertThat(target.baz,
               equalTo("junk")); // make sure change to source.foo didn't bounce back

    target.baz = "things";

    assertThat(target.bar,
               equalTo(false)); // make sure change to source.foo didn't bounce back
    assertThat(source.foo,
               equalTo(null)); // no change because target.bar is still false
  }

  private static function numberToString( value:* ):String {
    return value == null
        ? null
        : String(value);
  }

  private static function toNumber( value:String ):* {
    return Number(value);
  }

  private static function toUpperCase( value:String ):String {
    return value.toUpperCase();
  }

  private function sum( ... values ):* {
    var result:Number = 0;
    for each (var value:Number in values) {
      result += value;
    }
    return result;
  }

  // ILoggingTarget interface implementation

  public function get filters():Array {
    return [ 'com.googlecode.bindme.*' ];
  }

  public function set filters( ignored:Array ):void {
  }

  public function get level():int {
    return LogEventLevel.DEBUG;
  }

  public function set level( ignored:int ):void {
  }

  public function addLogger( logger:ILogger ):void {
    if (logger) {
      logger.addEventListener(LogEvent.LOG, handleLogEvent);
    }
  }

  public function removeLogger( logger:ILogger ):void {
    if (logger) {
      logger.removeEventListener(LogEvent.LOG, handleLogEvent);
    }
  }

  private function handleLogEvent( event:LogEvent ):void {
    logEvents.push(event);
  }
}

}
