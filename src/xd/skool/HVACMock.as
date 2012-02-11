////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2008 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package xd.skool
{

  public class HVACMock implements HVAC
  {
    public var isBlowerOn:Boolean;
    public var isCoolerOn:Boolean;
    public var isHeaterOn:Boolean;

    private var _temperature:int;

    public function get currentTemperature():int
    {
      return _temperature;
    }

    public function setTemperatureTo(value:int):void
    {
      _temperature = value;
    }

    public function switchBlowerOff():void
    {
      isBlowerOn = false;
    }

    public function switchBlowerOn():void
    {
      isBlowerOn = true;
    }

    public function switchCoolerOff():void
    {
      isCoolerOn = false;
    }

    public function switchCoolerOn():void
    {
      isCoolerOn = true;
    }

    public function switchHeaterOff():void
    {
      isHeaterOn = false;
    }

    public function switchHeaterOn():void
    {
      isHeaterOn = true;
    }
    //
  }
}
