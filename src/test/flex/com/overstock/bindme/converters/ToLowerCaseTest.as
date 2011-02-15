package com.overstock.bindme.converters {
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;

public class ToLowerCaseTest {

  function ToLowerCaseTest() {
  }

  [Test]
  public function testToLowerCase():void {
    var converter:Function = toLowerCase();

    assertThat(converter(null),
               equalTo(null));
    assertThat(converter("abc"),
               equalTo("abc"));
    assertThat(converter("ABC"),
               equalTo("abc"));
  }

}

}