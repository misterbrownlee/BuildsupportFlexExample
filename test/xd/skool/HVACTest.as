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
  import org.hamcrest.assertThat;
  import org.hamcrest.object.equalTo;

  public class HVACTest
  {
    private var hvacSystem:HVACMock;

    [Before]
    public function setup():void
    {
      hvacSystem = new HVACMock();
    }
    
    [After]
    public function teardown():void
    {
      hvacSystem = null;
    }
    
    [Test]
    public function whenInitalizedHardwareShouldBeOff():void
    {
      assertThat(hvacSystem.isHeaterOn, equalTo(false));
      assertThat(hvacSystem.isBlowerOn, equalTo(false));
      assertThat(hvacSystem.isCoolerOn, equalTo(false));
    }
    
    [Test]
    public function hvacCanReportTemperature():void {
      assertThat(!isNaN(hvacSystem.currentTemperature), equalTo(true));
    }
    
    [Test]
    public function heaterCanBeSwitchedOn():void
    {
      hvacSystem.switchHeaterOn();
      assertThat(hvacSystem.isHeaterOn, equalTo(true));
    }
    
    [Test]
    public function heaterCanBeSwitchedOff():void
    {
      hvacSystem.switchHeaterOn();
      hvacSystem.switchHeaterOff();
      assertThat(hvacSystem.isHeaterOn, equalTo(false));
    }
    
    [Test]
    public function blowerCanBeSwitchedOn():void
    {
      hvacSystem.switchBlowerOn();
      assertThat(hvacSystem.isBlowerOn, equalTo(true));
    }
    
    [Test]
    public function blowerCanBeSwitchedOff():void
    {
      hvacSystem.switchBlowerOn();
      hvacSystem.switchBlowerOff();
      assertThat(hvacSystem.isBlowerOn, equalTo(false));
    }
    
    
    [Test]
    public function coolerCanBeSwitchedOn():void
    {
      hvacSystem.switchCoolerOn();
      assertThat(hvacSystem.isCoolerOn, equalTo(true));
    }
    
    [Test]
    public function coolerCanBeSwitchedOff():void
    {
      hvacSystem.switchCoolerOn();
      hvacSystem.switchCoolerOff();
      assertThat(hvacSystem.isCoolerOn, equalTo(false));
    }
    
  }
}