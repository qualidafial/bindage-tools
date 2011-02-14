package com.overstock.bindme.converters {
import org.hamcrest.Matcher;

/**
 * Returns a converter function which returns a Boolean value indicating whether the value(s) in
 * the pipeline match the specified condition.
 *
 * @param condition the condition that pipeline value(s) will be tested against.
 */
public function toCondition( condition:Matcher ):Function {
  return function( value:* ):Boolean {
    return condition.matches(value);
  }
}

}
