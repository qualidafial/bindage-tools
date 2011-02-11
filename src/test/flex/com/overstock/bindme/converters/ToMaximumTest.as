package com.overstock.bindme.converters {
import org.flexunit.assertThat;
import org.hamcrest.object.equalTo;

public class ToMaximumTest {

  function ToMaximumTest() {
  }

  [Test]
  public function testToMaximum():void {
    var converter:Function = toMaximum();
    assertThat(converter(),
               equalTo(null));
    assertThat(converter(null, 1),
               equalTo(1));
    assertThat(converter(3, 5, 1),
               equalTo(5));
  }

}

}