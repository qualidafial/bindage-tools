package com.overstock.bindme.converters {
import org.flexunit.assertThat;
import org.hamcrest.number.lessThan;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.hasProperty;

public class IfValueTest {

  function IfValueTest() {
  }

  [Test]
  public function testDependingOn():void {
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

}

}