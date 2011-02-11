package com.overstock.bindme.converters {
import org.flexunit.assertThat;
import org.hamcrest.object.equalTo;

public class ToNumberTest {

  function ToNumberTest() {
  }

  [Test]
  public function testToNumber():void {
    var converter:Function = toNumber();
    assertThat(converter(null),
               equalTo(null));

    assertThat(converter(""),
               equalTo(null));

    assertThat(converter("1"),
               equalTo(1));
  }

}

}