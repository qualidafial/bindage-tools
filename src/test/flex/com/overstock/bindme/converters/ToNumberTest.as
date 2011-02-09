package com.overstock.bindme.converters {
import org.flexunit.assertThat;
import org.hamcrest.object.equalTo;

public class ToNumberTest {

  function ToNumberTest() {
  }

  [Test]
  public function testToNumber():void {
    assertThat(toNumber(null),
               equalTo(null));

    assertThat(toNumber(""),
               equalTo(null));

    assertThat(toNumber("1"),
               equalTo(1));
  }

}

}