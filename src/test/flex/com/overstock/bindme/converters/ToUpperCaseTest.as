package com.overstock.bindme.converters {
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;

public class ToUpperCaseTest {

  function ToUpperCaseTest() {
  }

  [Test]
  public function testToUpperCase():void {
    var converter:Function = toUpperCase();

    assertThat(converter(null),
               equalTo(null));
    assertThat(converter("ABC"),
               equalTo("ABC"));
    assertThat(converter("abc"),
               equalTo("ABC"));
  }

}

}