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

  public interface HVAC
  {
    function switchBlowerOff():void;
    function switchBlowerOn():void;
    function switchCoolerOff():void;
    function switchCoolerOn():void;
    function switchHeaterOff():void;
    function switchHeaterOn():void;
    function get currentTemperature():int;
  }
}
