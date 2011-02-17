package com.overstock.bindme.converters {
import org.flexunit.assertThat;
import org.hamcrest.CustomMatcher;
import org.hamcrest.Matcher;
import org.hamcrest.collection.hasItem;
import org.hamcrest.number.lessThan;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.hasProperty;

public class IfValueTest {

  function IfValueTest() {
  }

  [Test]
  public function testIfValue():void {
    function toUpperCase( value:String ):String {
      return value.toUpperCase();
    }

    function toLowerCase( value:String ):String {
      return value.toLowerCase();
    }

    var converter:Function = ifValue(hasProperty("length", lessThan(5)))
        .thenConvert(toLowerCase)
        .elseConvert(toUpperCase);

    assertThat(converter("AaBb"),
               equalTo("aabb"));
    assertThat(converter("AaBbCc"),
               equalTo("AABBCC"));
  }

  [Test]
  public function testIfValueMultipleValues():void {
    function toSum( ...addends ):Number {
      var result:Number = 0;

      for each (var addend:Number in addends) {
        result += addend;
      }

      return result;
    }

    function toProduct( ...factors ):Number {
      var result:Number = 1;

      for each (var factor:Number in factors) {
        result *= factor;
      }

      return result;
    }

    var isOdd:Matcher = new CustomMatcher("is odd", function( value:Number ):Boolean {
      return value % 2 == 1;
    });

    var converter:Function = ifValue(hasItem(isOdd))
        .thenConvert(toProduct)
        .elseConvert(toSum);

    assertThat(converter([0, 2, 4]), // no odd elements
               equalTo(6)); // sum

    assertThat(converter([2, 3, 4]), // 1 odd element
               equalTo(24)); // product
  }

}

}