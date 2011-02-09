package com.overstock.bindme.converters {
import org.flexunit.assertThat;
import org.hamcrest.object.equalTo;

public class ToMaximumTest {

  function ToMaximumTest() {
  }

  [Test]
  public function testToMaximum():void {
    assertThat(toMaximum(),
               equalTo(null));
    assertThat(toMaximum(null, 1),
               equalTo(1));
    assertThat(toMaximum(3, 5, 1),
               equalTo(5));
  }

}

}