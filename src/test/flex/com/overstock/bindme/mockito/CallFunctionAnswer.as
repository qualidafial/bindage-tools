package com.overstock.bindme.mockito {
import org.mockito.api.Answer;
import org.mockito.api.StubbingContext;
import org.mockito.api.StubbingContextAware;

public class CallFunctionAnswer implements Answer, StubbingContextAware {
  private var f:Function;

  private var stubbingContext:StubbingContext;

  public function CallFunctionAnswer( f:Function ) {
    this.f = f;
  }

  public function useContext( stubbingContext:StubbingContext ):void {
    this.stubbingContext = stubbingContext;
  }

  public function give():* {
    return f.apply(null, stubbingContext.args);
  }
}
}
