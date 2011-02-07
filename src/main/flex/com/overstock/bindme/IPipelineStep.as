package com.overstock.bindme {

public interface IPipelineStep {

  function wrapStep( nextStep:Function ):Function;

}

}
