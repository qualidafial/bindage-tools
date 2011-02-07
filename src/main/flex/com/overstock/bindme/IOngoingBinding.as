package com.overstock.bindme {

public interface IOngoingBinding {
  function toProperty( target:Object,
                       property:String ):IOngoingBinding;

  function toFunction( func:Function ):IOngoingBinding;

  function convert( converter:Function ):IOngoingBinding;
}

}
