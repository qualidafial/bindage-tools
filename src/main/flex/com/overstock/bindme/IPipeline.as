package com.overstock.bindme {
import org.hamcrest.Matcher;

public interface IPipeline {

  function append( step:IPipelineStep ):IPipeline;

  function convert( converter:Function ):IPipeline;

  function validate( condition:Matcher ):IPipeline;

  function toProperty( target:Object,
                       property:String ):IPipeline;

  function toFunction( func:Function ):IPipeline;

}

}
