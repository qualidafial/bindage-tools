package com.overstock.bindme.converters {
import org.flexunit.assertThat;
import org.hamcrest.object.equalTo;

public class ToMinimumTest {

  function ToMinimumTest() {
  }

  [Test]
  public function testToMinimum():void {
    assertThat(toMinimum(),
               equalTo(null));
    assertThat(toMinimum(null, 1),
               equalTo(1));
    assertThat(toMinimum(3, 5, 1),
               equalTo(1));
  }

}

}