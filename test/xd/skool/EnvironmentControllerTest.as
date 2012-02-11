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
  import org.hamcrest.object.notNullValue;
  import org.hamcrest.object.equalTo;
  import org.flexunit.assertThat;
  import org.flexunit.asserts.assertNotNull;
  import flash.utils.Timer;
  import flash.events.TimerEvent;
  import flash.utils.getTimer;
  import org.flexunit.asserts.assertTrue;

  public class EnvironmentControllerTest
  {
    private var controller:EnvironmentController;
    private var hvacSystem:HVACMock;
    private var waiting:Boolean;
    private var timer:Timer;
    
    [Before]
    public function setup():void
    {
      controller = new EnvironmentController();
      hvacSystem = new HVACMock();
      controller.initialize(hvacSystem);
    }
    
    [After]
    public function teardown():void
    {
      controller = null;
    }
    
    [Test]
    public function controllerShouldExist():void
    {
      assertNotNull(controller);
    }
    
    [Test]
    public function controllerShouldTick():void
    {
      controller.tick() 
    }
    
    [Test]
    public function heaterWillTurnOnIfTemperatureDropBelowThreshold():void
    {
       makeItTooCold();
       assertThat(hvacSystem.isHeaterOn, equalTo(true));
    }

    [Test]
    public function heaterWillTurnOffOnceTargetTempIsReached():void
    {
      makeItTooCold(); // turns heater on
      makeItTargetTemp();
      assertThat(hvacSystem.isHeaterOn, equalTo(false));
    }
    
    [Test]
    public function coolerWillTurnOnIfTemperatureAboveThreshold():void
    {
       makeItTooHot();
       assertThat(hvacSystem.isCoolerOn, equalTo(true));
    }

    [Test]
    public function coolerWillAndBlowerTurnOffOnceTargetTempIsReached():void
    {
      makeItTooHot();
      makeItTargetTemp();
      assertThat(hvacSystem.isCoolerOn, equalTo(false));
      assertThat(hvacSystem.isBlowerOn, equalTo(false));
    }
    
    [Test]
    public function whenHeaterIsSwitchedOffBlowerStillOnAtFourthTick():void
    {
      makeItTooCold(); 
      makeItTargetTemp();
      tickMany(4);
      assertThat(hvacSystem.isBlowerOn, equalTo(true));
    }
       
    [Test]
    public function whenHeaterIsSwitchedOffBlowerShouldShutOffAfterFiveTicks():void
    {
      makeItTooCold(); 
      makeItTargetTemp();
      tickMany(5);
      assertThat(hvacSystem.isBlowerOn, equalTo(false));
    }
    
    [Test]
    public function stayingInRangeWillNotAffectSettling():void
    {
      makeItTooCold(); 
      makeItTargetTemp();
      tickMany(2);
      hvacSystem.setTemperatureTo(68);
      tickMany(3);
      assertThat(hvacSystem.isBlowerOn, equalTo(false));
    }
    
    [Test]
    public function coolerWillNotTurnOnWhileRelaxing():void
    {
      assertThat(hvacSystem.isCoolerOn, equalTo(false));
    }
    
    [Test]
    public function whenHeaterIsOnBlowerHasToBeOn():void
    {
      makeItTooHot();
      assertThat(hvacSystem.isBlowerOn, equalTo(true));
    }
    
    [Test]
    public function hotAlarmWillBeOnWhenTooHot():void
    {
      makeItTooHot();
      assertThat(controller.isHighTempAlarm, equalTo(true));
    }
    
    [Test]
    public function hotAlarmWillBeOffWhenNominal():void
    {
      makeItTooHot();
      makeItTargetTemp();
      assertThat(controller.isHighTempAlarm, equalTo(false));
    }
    
    [Test]
    public function coldAlarmWillBeOffWhenNominal():void
    {
      makeItTooCold();
      makeItTargetTemp();
      assertThat(controller.isLowTempAlarm, equalTo(false));
    }
    
    [Test]
    public function coldAlarmWillBeOnWhenTooCold():void
    {
      makeItTooCold();
      assertThat(controller.isLowTempAlarm, equalTo(true));
    }
    
    
    [Test]
    public function thisWillTakeALongTime():void
    {
      var i:int;
      var start:int = getTimer();
      var limit:int = 100 * 1000000;
      trace("waiting...");
      while (i < limit) {
        //trace("tick",i++);
        i++;
      }
      
      var elapsed:int = getTimer() - start;
      
      trace("elapsed", elapsed/1000);
      assertTrue(true);
    }

    private function tickMany(ticks:Number):void
    { 
      var count:int = 0;
      while (count < ticks) {
        controller.tick();
        count++;
      }
    }
    
    private function makeItTooCold():void
    {
      var cold:int = EnvironmentController.TARGET_TEMPERATURE - EnvironmentController.DEVIATION_ALLOWED;
      hvacSystem.setTemperatureTo(cold);
      controller.tick();
    }
    
    private function makeItTargetTemp():void
    {
      hvacSystem.setTemperatureTo(70);// target is 70;
      controller.tick();
    }
    
    private function makeItTooHot():void
    {
      var hot:int = EnvironmentController.TARGET_TEMPERATURE + EnvironmentController.DEVIATION_ALLOWED;
      hvacSystem.setTemperatureTo(hot);
      controller.tick();
    }
    
  }
}