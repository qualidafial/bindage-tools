/*
 * Copyright 2011 Overstock.com and others.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.googlecode.bindagetools.impl {
import com.googlecode.bindagetools.IPipelineBuilder;

/**
 * @private
 */
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
    return function( ...values ):void {
      var value:* = values.length == 1
          ? values[0]
          : values;
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
