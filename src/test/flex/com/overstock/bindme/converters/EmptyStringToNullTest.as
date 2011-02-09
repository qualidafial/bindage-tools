package com.overstock.bindme.converters {
import org.flexunit.assertThat;
import org.hamcrest.object.equalTo;

public class EmptyStringToNullTest {

  function EmptyStringToNullTest() {
  }

  [Test]
  public function testEmptyStringToNull():void {
    assertThat(emptyStringToNull(null),
               equalTo(null));
    assertThat(emptyStringToNull(""),
               equalTo(null));
    assertThat(emptyStringToNull("abc"),
               equalTo("abc"));
  }

}

}