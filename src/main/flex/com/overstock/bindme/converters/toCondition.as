package com.overstock.bindme.converters {
import org.hamcrest.Matcher;

public function toCondition( condition:Matcher ):Function {
  return function( value:* ):Boolean {
    return condition.matches(value);
  }
}

}
