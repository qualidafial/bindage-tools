package com.overstock.bindme {
public interface IPipeline {

  function append( step:IPipelineStep ):IPipeline;

  function convert( converter:Function ):IPipeline;

  function validate( ...condition ):IPipeline;

  function toProperty( target:Object,
                       property:String ):IPipeline;

  function toFunction( func:Function ):IPipeline;

  /**
   * Returns a <code>function():void</code> which, when invoked,
   * retrieves the binding source value(s) and pushes them through the binding pipeline,
   * with the final value(s) sent to the specified pipeline function.
   *
   * @param func a <code>function(value0, ...valueN):void</code> which will be invoked with the
   * value(s) in the pipeline when returned runner is invoked.
   *
   * @return a <code>function():void</code> which, when invoked, runs the binding pipeline
   * through to the specified pipeline function.
   */
  function runner( func:Function ):Function;

  /**
   * Sets up event listeners, such that the specified runner is invoked whenever any of this
   * pipeline's binding sources changes values.
   *
   * @param runner a <code>function(...values):void</code> which will be invoked whenever
   * any of thispipeline's binding sources changes values.
   */
  function watch( runner:Function ):void;

}

}
