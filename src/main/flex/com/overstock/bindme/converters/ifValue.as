package com.overstock.bindme.converters {
import org.hamcrest.Matcher;

/**
 * Begins stubbing for a conditional converter.
 *
 * @param condition the condition to test for
 * @return an IThenValue to continue stubbing
 */
public function ifValue( condition:Matcher ):IThenConvertStubbing {
  return new ConditionalConverter(condition);
}

}