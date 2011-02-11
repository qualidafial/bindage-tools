package com.overstock.bindme.converters {
import org.flexunit.assertThat;
import org.hamcrest.object.equalTo;

public class ValueToStringTest {

  function ValueToStringTest() {
  }

  [Test]
  public function testValueToString():void {
    var converter:Function = valueToString();
    assertThat(converter(null),
               equalTo(null));
    assertThat(converter(NaN),
               equalTo("NaN"));
    assertThat(converter(1.2),
               equalTo("1.2"));
  }

}

}