package com.overstock.bindme.converters {
import org.hamcrest.Matcher;

/**
 * Returns a function which returns a Boolean of whether the value matches the given condition.
 *
 * @param condition the condition that values will be tested against.
 */
public function toCondition( condition:Matcher ):Function {
  return function( value:* ):Boolean {
    return condition.matches(value);
  }
}

}
