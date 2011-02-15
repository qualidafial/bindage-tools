package com.overstock.bindme.converters {
import org.hamcrest.Matcher;

internal class ConditionalConverter implements IThenConvertStubbing, IElseConvertStubbing {
  private var condition:Matcher;
  private var thenConverter:Function;
  private var elseConverter:Function;

  public function ConditionalConverter( condition:Matcher ) {
    this.condition = condition;
  }

  public function thenConvert( thenConverter:Function ):IElseConvertStubbing {
    this.thenConverter = thenConverter;
    return this;
  }

  public function elseConvert( elseConverter:Function ):Function {
    this.elseConverter = elseConverter;
    return convertConditionally;
  }

  private function convertConditionally( value:* ):* {
    var converterArgs:Array = (value is Array)
        ? value as Array
        : [value];

    return condition.matches(value)
        ? thenConverter.apply(null, converterArgs)
        : elseConverter.apply(null, converterArgs);
  }
}

}