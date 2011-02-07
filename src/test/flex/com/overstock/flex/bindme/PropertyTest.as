package com.overstock.flex.bindme {
import com.overstock.flex.bindme.properties.Properties;

import mx.collections.ArrayCollection;

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;

public class PropertyTest {

  function PropertyTest() {
  }

  private var property:Property;
  private var _value:String;

  public function get value():String {
    return _value;
  }

  public function set value( value:String ):void {
    _value = value;
  }

  [Before]
  public function setUp():void {
    _value = "value";
  }

  [Test]
  public function getValue():void {
    property = Property.make("value");

    assertThat(property.getValue(this),
               equalTo("value"));
  }

  [Test]
  public function setValue():void {
    property = Property.make("value");

    property.setValue(this, "new value");

    assertThat(_value,
               equalTo("new value"));
  }

  public const thing:* = { stuff: new ArrayCollection() };

  [Test]
  public function nestedProperty():void {
    property = Property
        .make("thing.stuff")
        .chain(Properties.itemAt(1))
        .chain("value");

    thing.stuff = new ArrayCollection([
                                        { value: null },
                                        { value: null },
                                        { value: null }
                                      ]);

    var newValue:String = "grum";
    property.setValue(this, newValue);

    assertThat(thing.stuff.getItemAt(1).value,
               equalTo(newValue));
    assertThat(property.getValue(this),
               equalTo(newValue));
  }

}
}