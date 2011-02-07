package com.overstock.flex.bindme.condition {
import mx.collections.ArrayCollection;

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;

public class ValidatorsTest {

  [Test]
  public function testStringToNumber():void {
    assertThat(Validators.stringToNumber(null),
               equalTo(true));
    assertThat(Validators.stringToNumber(""),
               equalTo(true));
    assertThat(Validators.stringToNumber("5"),
               equalTo(true));

    assertThat(Validators.stringToNumber("5a"),
               equalTo(false));
    assertThat(Validators.stringToNumber("abc"),
               equalTo(false));
  }

  [Test]
  public function testAllOf():void {
    assertThat(Validators.allOf(value(false), value(false))(null),
               equalTo(false));
    assertThat(Validators.allOf(value(false), value(true))(null),
               equalTo(false));
    assertThat(Validators.allOf(value(true), value(false))(null),
               equalTo(false));
    assertThat(Validators.allOf(value(true), value(true))(null),
               equalTo(true));
  }

  [Test]
  public function testAnyOf():void {
    assertThat(Validators.anyOf(value(false), value(false))(null),
               equalTo(false));
    assertThat(Validators.anyOf(value(false), value(true))(null),
               equalTo(true));
    assertThat(Validators.anyOf(value(true), value(false))(null),
               equalTo(true));
    assertThat(Validators.anyOf(value(true), value(true))(null),
               equalTo(true));
  }

  [Test]
  public function testXor():void {
    assertThat(Validators.xor(value(false), value(false))(null),
               equalTo(false));
    assertThat(Validators.xor(value(false), value(true))(null),
               equalTo(true));
    assertThat(Validators.xor(value(true), value(false))(null),
               equalTo(true));
    assertThat(Validators.xor(value(true), value(true))(null),
               equalTo(false));
  }

  [Test]
  public function testNot():void {
    assertThat(Validators.not(value(true))(null),
               equalTo(false));
    assertThat(Validators.not(value(false))(null),
               equalTo(true));
  }

  private function value( value:Boolean ):Function {
    return function( ignored:* ):Boolean {
      return value;
    };
  }

  [Test]
  public function testLessThan():void {
    assertThat(Validators.lessThan(0)(-1),
               equalTo(true));
    assertThat(Validators.lessThan(0)(0),
               equalTo(false));
    assertThat(Validators.lessThan(0)(1),
               equalTo(false));
  }

  [Test]
  public function testLessEqual():void {
    assertThat(Validators.lessEqual(0)(-1),
               equalTo(true));
    assertThat(Validators.lessEqual(0)(0),
               equalTo(true));
    assertThat(Validators.lessEqual(0)(1),
               equalTo(false));
  }

  [Test]
  public function testEqual():void {
    assertThat(Validators.equal(0)(-1),
               equalTo(false));
    assertThat(Validators.equal(0)(0),
               equalTo(true));
    assertThat(Validators.equal(0)(1),
               equalTo(false));
  }

  [Test]
  public function testNotEqual():void {
    assertThat(Validators.notEqual(0)(-1),
               equalTo(true));
    assertThat(Validators.notEqual(0)(0),
               equalTo(false));
    assertThat(Validators.notEqual(0)(1),
               equalTo(true));
  }

  [Test]
  public function testGreaterEqual():void {
    assertThat(Validators.greaterEqual(0)(-1),
               equalTo(false));
    assertThat(Validators.greaterEqual(0)(0),
               equalTo(true));
    assertThat(Validators.greaterEqual(0)(1),
               equalTo(true));
  }

  [Test]
  public function testGreaterThan():void {
    assertThat(Validators.greaterThan(0)(-1),
               equalTo(false));
    assertThat(Validators.greaterThan(0)(0),
               equalTo(false));
    assertThat(Validators.greaterThan(0)(1),
               equalTo(true));
  }

  [Test]
  public function testIsEmpty():void {
    assertThat(Validators.isEmpty(null),
               equalTo(true));

    assertThat(Validators.isEmpty([]),
               equalTo(true));
    assertThat(Validators.isEmpty([null]),
               equalTo(false));

    assertThat(Validators.isEmpty(new ArrayCollection()),
               equalTo(true));
    assertThat(Validators.isEmpty(new ArrayCollection([null])),
               equalTo(false));

    assertThat(Validators.isEmpty(""),
               equalTo(true));
    assertThat(Validators.isEmpty("foo"),
               equalTo(false));
  }

  [Test]
  public function testIsNotEmpty():void {
    assertThat(Validators.isNotEmpty(null),
               equalTo(false));

    assertThat(Validators.isNotEmpty([]),
               equalTo(false));
    assertThat(Validators.isNotEmpty([null]),
               equalTo(true));

    assertThat(Validators.isNotEmpty(new ArrayCollection()),
               equalTo(false));
    assertThat(Validators.isNotEmpty(new ArrayCollection([null])),
               equalTo(true));

    assertThat(Validators.isNotEmpty(""),
               equalTo(false));
    assertThat(Validators.isNotEmpty("foo"),
               equalTo(true));
  }

}

}