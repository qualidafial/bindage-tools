package com.overstock.bindme.mockito {
import org.mockito.api.Answer;

public function callFunction( f:Function ):Answer {
  return new CallFunctionAnswer(f);
}

}
