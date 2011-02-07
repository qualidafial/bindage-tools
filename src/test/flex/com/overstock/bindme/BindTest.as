package com.overstock.bindme {
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.instanceOf;

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
               instanceOf(IOngoingBinding));
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
  [Ignore]
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

  private function toUpperCase( value:String ):String {
    return value.toUpperCase();
  }
}

}
