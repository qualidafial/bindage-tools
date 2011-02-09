package com.overstock.bindme.converters {
import org.flexunit.assertThat;
import org.hamcrest.object.equalTo;

public class ValueToStringTest {

  function ValueToStringTest() {
  }

  [Test]
  public function testValueToString():void {
    assertThat(valueToString(null),
               equalTo(null));
    assertThat(valueToString(NaN),
               equalTo("NaN"));
    assertThat(valueToString(1.2),
               equalTo("1.2"));
  }

}

}