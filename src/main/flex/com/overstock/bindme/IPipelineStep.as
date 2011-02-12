package com.overstock.bindme {

/**
 * A step in a data binding pipeline.
 */
public interface IPipelineStep {

  /**
   * Returns a function which accepts the expected value(s) in the binding pipeline,
   * executes this step, and calls the next step with the same value(s) when finished.
   * @param next the next step in the pipeline.
   */
  function wrapStep( next:Function ):Function;

}

}
