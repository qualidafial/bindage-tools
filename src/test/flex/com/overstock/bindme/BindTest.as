package com.overstock.bindme {
import mx.binding.utils.ChangeWatcher;

import org.hamcrest.assertThat;
import org.hamcrest.collection.array;
import org.hamcrest.number.greaterThan;
import org.hamcrest.number.lessThan;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.instanceOf;
import org.hamcrest.text.re;

public class BindTest {

  private var source:Bean;
  private var target:Bean;

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
               instanceOf(IPipeline));
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
  public function fromPropertyValidateConvertToProperty():void {
    source.foo = "foo";
    target.bar = -1;

    var integerPattern:RegExp = /\d+/;

    Bind.fromProperty(source, "foo")
        .validate(re(integerPattern))
        .convert(toNumber)
        .toProperty(target, "bar");

    assertThat(target.bar,
               equalTo(-1)); // validation failed, no change

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

    var collected:Array = Bind.collect(createBindings);

    assertThat(collected,
               array(instanceOf(ChangeWatcher)));

    source.foo = 1;
    assertThat(target.bar,
               equalTo(1));

    ChangeWatcher(collected[0]).unwatch();

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

    var collected:Array = Bind.collect(createBindings);

    assertThat(collected,
               array(instanceOf(ChangeWatcher)));

    assertThat(target.receiveCount,
               equalTo(1));

    source.foo = 1;
    assertThat(target.receiveCount,
               equalTo(2));

    ChangeWatcher(collected[0]).unwatch();

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

    var collected:Array = Bind.collect(createBindings);

    assertThat(collected,
               array(instanceOf(ChangeWatcher),
                     instanceOf(ChangeWatcher)));

    source.foo = 1;
    assertThat(target.bar,
               equalTo(1));

    target.bar = 2;
    assertThat(source.foo,
               equalTo(2));

    ChangeWatcher(collected[0]).unwatch();
    ChangeWatcher(collected[1]).unwatch();

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
      expected = Bind.collect(createBindingsInner);
    }

    var actual:Array = Bind.collect(createBindingsOuter);

    assertThat(expected,
               array(instanceOf(ChangeWatcher)));

    assertThat(actual,
               array(expected[0]));
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
        .convert(add)
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

  private function add( a:*,
                        b:* ):* {
    return a + b;
  }
}

}
