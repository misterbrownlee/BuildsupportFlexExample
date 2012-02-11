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

  import flashx.textLayout.events.UpdateCompleteEvent;
  import mx.events.CubeEvent;

  public class EnvironmentController
  {
    public static const DEVIATION_ALLOWED:int = 5;
    public static const TARGET_TEMPERATURE:int = 70;
    private static const RELAX_TIME_PERIOD:int = 3;
    
    private static const NO_ALARM:Number = 0;
    private static const SETTLE_STOPPED:Number = 0;
    private static const RELAX_STOPPED:Number = 0;

    private var alarmType:int;
    private var hvacSystem:HVAC;
    private var isBlowing:Boolean;
    private var isCooling:Boolean;
    private var isHeating:Boolean;
    private var lowBoundry:int = TARGET_TEMPERATURE - 5;
    private var relaxProgress:int = RELAX_STOPPED;
    private var settleProgress:int = SETTLE_STOPPED;
    private var upperBoundry:int = TARGET_TEMPERATURE + 5;

    public function initialize(system:HVAC):void
    {
      hvacSystem = system;
    }

    public function get isHighTempAlarm():Boolean
    {
      return alarmType > NO_ALARM;
    }

    public function get isLowTempAlarm():Boolean
    {
      return alarmType < NO_ALARM;
    }

    public function tick():void
    {
      updateSystemState();
    }

    private function updateAlarmLevel():void
    {
      var value:int = NO_ALARM;
      if (outOfNominalRange())
      {
        value = tooHot() ? 1 : -1
      }
      alarmType = value;
    }
    
    private function outOfNominalRange():Boolean
    {
      return tooHot() || tooCold();
    }
    
    private function tooCold():Boolean
    {
      return isBelowThreshold();
    }

    private function tooHot():Boolean
    {
      return isAboveThreshold();
    }

    private function isAboveThreshold():Boolean
    {
      return hvacSystem.currentTemperature >= upperBoundry;
    }

    private function isBelowThreshold():Boolean
    {
      return hvacSystem.currentTemperature <= lowBoundry;
    }

    private function isBlowerNeeded():Boolean
    {
      return isCooling || isHeating || isSettling;
    }

    private function get isRelaxing():Boolean
    {
      return relaxProgress > RELAX_STOPPED;
    }

    private function get isSettling():Boolean
    {
      return settleProgress > SETTLE_STOPPED;
    }

    private function startHeatingOrCoolingIfNeeded():void
    {
      if (alarmType != NO_ALARM) {
        tooCold() ? switchHeaterOn() : switchCoolerOn();
      }
    }

    private function stopSystem():void
    {
      if (alarmType == NO_ALARM) {
        switchHeaterOff();
        switchCoolerOff();
        switchBlowerOff();
      }
    }

    private function switchBlowerOff():void
    {
      if (!isBlowerNeeded())
      {
        hvacSystem.switchBlowerOff();
        isBlowing = false;
      }
    }

    private function switchBlowerOn():void
    {
      hvacSystem.switchBlowerOn();
      isBlowing = true;
    }

    private function switchCoolerOff():void
    {
      if (isCooling)
      {
        hvacSystem.switchCoolerOff();
        relaxProgress = RELAX_TIME_PERIOD;
        isCooling = false;
      }
    }

    private function switchCoolerOn():void
    {
      if (!isRelaxing)
      {
        hvacSystem.switchCoolerOn();
        isCooling = true;
        switchBlowerOn();
      }
    }

    private function switchHeaterOff():void
    {
      if (isHeating)
      {
        hvacSystem.switchHeaterOff();
        settleProgress = 5;
        isHeating = false;
      }
    }

    private function switchHeaterOn():void
    {
      hvacSystem.switchHeaterOn();
      settleProgress = NO_ALARM;
      isHeating = true;
      switchBlowerOn();
    }


    private function updateHeatingAndCooling():void
    {
      stopSystem();
      startHeatingOrCoolingIfNeeded();
    }

    private function updateRelaxationProgress():void
    {
      if (isRelaxing)
      {
        relaxProgress--;
      }
    }

    private function updateSettlementProgress():void
    {
      if (isSettling)
      {
        settleProgress--;
      }
    }

    private function updateSystemState():void
    {
      updateRelaxationProgress();
      updateSettlementProgress();
      updateAlarmLevel();
      updateHeatingAndCooling();
    }
  }
}
