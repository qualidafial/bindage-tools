package com.overstock.bindme.impl {
import com.overstock.bindme.IPipelineBuilder;

public class MultiPipelineBuilder extends PipelineBuilder {
  private var sources:Array;

  public function MultiPipelineBuilder( sources:Array ) {
    if (sources.length < 2) {
      throw new ArgumentError("Multi-source pipelines must provide at least two sources")
    }
    for each (var source:Object in sources) {
      if (!(source is IPipelineBuilder)) {
        throw new ArgumentError("Source pipelines must be instances of IPipeline");
      }
    }

    this.sources = sources.slice();
  }

  override protected function pipelineRunner( pipeline:Function ):Function {
    var args:Array = new Array(sources.length);

    function pipelineRunner():void {
      pipeline(args.slice());
    }

    var runner:Function = pipelineRunner;

    for (var i:int = 0; i < sources.length; i++) {
      var source:IPipelineBuilder = sources[i];

      var setArg:Function = setArgPipeline(argSetter(args, i), runner);
      runner = source.runner(setArg);
    }

    return runner;
  }

  override public function watch( handler:Function ):void {
    for each (var source:IPipelineBuilder in sources) {
      source.watch(handler);
    }
  }

  private static function setArgPipeline( setArgument:Function,
                                          nextStep:Function ):Function {
    return function( value:* ):void {
      setArgument(value);
      nextStep();
    };
  }

  private static function argSetter( args:Array,
                                     index:int ):Function {
    return function( value:* ):void {
      args[index] = value;
    }
  }

}

}
