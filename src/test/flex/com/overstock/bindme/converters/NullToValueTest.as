package com.overstock.bindme.converters {
import org.flexunit.assertThat;
import org.hamcrest.object.equalTo;

public class NullToValueTest {

  function NullToValueTest() {
  }

  [Test]
  public function testEmptyStringToNull():void {
    var converter:Function = nullToValue("foo");
    assertThat(converter(null),
               equalTo("foo"));
    assertThat(converter(5),
               equalTo(5));

  }

}

}