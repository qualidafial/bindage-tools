package com.overstock.bindme.properties {
import mx.collections.ArrayCollection;

import org.hamcrest.assertThat;
import org.hamcrest.collection.array;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.hasProperties;
import org.hamcrest.object.instanceOf;

public class ItemAtTest {

  public function ItemAtTest() {
  }

  [Test( expected="ArgumentError" )]
  public function testItemAtNegativeIndex():void {
    itemAt(-1);
  }

  [Test]
  public function itemAtProperties():void {
    assertThat(itemAt(2),
               hasProperties({
                               name: "getItemAt",
                               getter: instanceOf(Function),
                               setter:instanceOf(Function)
                             }));
  }

  [Test]
  public function testItemAtWithArrayCollection():void {
    var coll:ArrayCollection = new ArrayCollection(["a", "b", "c"]);

    assertThat(itemAt(1).getter(coll),
               equalTo("b"))

    assertThat(itemAt(3).getter(coll), // out of bounds
               equalTo(null));

    itemAt(0).setter(coll, "x");
    assertThat(coll,
               array("x", "b", "c"));

    itemAt(3).setter(coll, "y"); // out of bounds, ignored
    assertThat(coll,
               array("x", "b", "c"));
  }

  [Test]
  public function testItemAtWithArray():void {
    var coll:Array = ["a", "b", "c"];

    assertThat(itemAt(1).getter(coll),
               equalTo("b"));

    assertThat(itemAt(3).getter(coll), // out of bounds
               equalTo(null));

    itemAt(0).setter(coll, "x");
    assertThat(coll,
               array("x", "b", "c"));

    itemAt(3).setter(coll, "y");
    assertThat(coll,
               array("x", "b", "c"));
  }

}

}
