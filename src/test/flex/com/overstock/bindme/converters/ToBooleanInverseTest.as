package com.overstock.bindme.converters {
import org.flexunit.assertThat;
import org.hamcrest.object.equalTo;

public class ToBooleanInverseTest {

  function ToBooleanInverseTest() {
  }

  [Test]
  public function testToBooleanInverse():void {
    assertThat(toBooleanInverse(false),
               equalTo(true));
    assertThat(toBooleanInverse(true),
               equalTo(false));

    assertThat(toBooleanInverse(null),
               equalTo(true));
    assertThat(toBooleanInverse(""),
               equalTo(true));
    assertThat(toBooleanInverse("non-empty string"),
               equalTo(false));
    assertThat(toBooleanInverse({ some: "object" }),
               equalTo(false));
  }

}

}