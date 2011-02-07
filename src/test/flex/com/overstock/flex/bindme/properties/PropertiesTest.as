package com.overstock.flex.bindme.properties {
import com.overstock.flex.bindme.*;

import mx.collections.ArrayCollection;

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;

public class PropertiesTest {

  function PropertiesTest() {
  }

  private var stuff:ArrayCollection;

  [Before]
  public function setUp():void {
    stuff = new ArrayCollection([ "foo", "bar", "baz" ]);
  }

  [Test]
  public function itemAt():void {
    var property:Property = Properties.itemAt(1);
    assertThat(property.getValue(stuff),
               equalTo("bar"));
  }

}
}