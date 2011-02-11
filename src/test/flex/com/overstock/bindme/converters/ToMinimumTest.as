package com.overstock.bindme.converters {
import org.flexunit.assertThat;
import org.hamcrest.object.equalTo;

public class ToMinimumTest {

  function ToMinimumTest() {
  }

  [Test]
  public function testToMinimum():void {
    var converter:Function = toMinimum();
    assertThat(converter(),
               equalTo(null));
    assertThat(converter(null, 1),
               equalTo(1));
    assertThat(converter(3, 5, 1),
               equalTo(1));
  }

}

}