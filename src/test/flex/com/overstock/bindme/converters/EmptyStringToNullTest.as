package com.overstock.bindme.converters {
import org.flexunit.assertThat;
import org.hamcrest.object.equalTo;

public class EmptyStringToNullTest {

  function EmptyStringToNullTest() {
  }

  [Test]
  public function testEmptyStringToNull():void {
    var converter:Function = emptyStringToNull();
    assertThat(converter(null),
               equalTo(null));
    assertThat(converter(""),
               equalTo(null));
    assertThat(converter("abc"),
               equalTo("abc"));
  }

}

}