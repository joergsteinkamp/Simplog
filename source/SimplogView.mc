using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Cal;
using Toybox.Activity as Act;
using Toybox.ActivityMonitor as AM;
using Toybox.System as Sys;
using Toybox.Math as Math;
using Toybox.Lang as Lang;
// using Toybox.Sensor as Sensor;

class SimplogView extends Ui.WatchFace {
	// display properties
	hidden var centerX, centerY, radius;
	// size of colored battery indicator (center point) 
	hidden var radiusBattery = 8;
	// scale factor for symbols
	hidden var symbolScale = 1;

	hidden var sunTimes;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
    	centerX = dc.getWidth() / 2;
    	centerY = dc.getHeight() / 2;
    	radius = centerX < centerY ? centerX : centerY;
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        var time = Time.now();
		var altitude = Act.getActivityInfo().altitude;
		var location = Act.getActivityInfo().currentLocation;

		var phoneConnected = Sys.getDeviceSettings().phoneConnected;
		var alarmCount = Sys.getDeviceSettings().alarmCount;
		var notificationCount = Sys.getDeviceSettings().notificationCount;
		var heartRate = 0;
		if (AM has :getHeartRateHistory) {
		  var hrHist =  AM.getHeartRateHistory(1, true);
		  heartRate = hrHist.next().heartRate;
		// No Sensor access in watch mode!
		//} else if (Sensor has :getInfo) {
		//  var sensorInfo = Sensor.getInfo();
		//  if (sensorInfo has :heartRate) {
		//    heartRate = sensorInfo.heartRate;
		//  }
		} else {
		  heartRate = null;
		}
		
		
		//var heartRate = 0.0;
		//var nHeartRate = 0;
		//while (heartRateSample != null && nHeartRate < 61) {
			//heartRate += heartRateSample.heartRate;
			//heartRateSample = hrHist.next();
			//nHeartRate++;
		//}
		//heartRate /= nHeartRate;
		//System.println(heartRate);

		//phoneConnected = true;
		//alarmCount = 1;
		//notificationCount=19;
		//altitude=200;

		//var amInfo = AM.getInfo();
		//System.println(amInfo.moveBarLevel);
		//System.println(AM.MOVE_BAR_LEVEL_MAX);
		//System.println(AM.MOVE_BAR_LEVEL_MIN);
		//System.println(amInfo.steps);
		//System.println(amInfo.stepGoal);
		//System.println(amInfo.floorsClimbed);
		//System.println(amInfo.floorsClimbedGoal);
		//var DS = System.getDeviceSettings();
		//System.println(DS.screenShape);
		//System.println(DS.partNumber);

        // clear the display
        erase(dc);

        // draw the watch components
        drawTicks(dc);
		drawDay(dc, time);

		// draw the notification count bellow the watch hands 
		if (notificationCount > 0) {
			drawNotificationCount(dc, notificationCount);
		}

		drawHands(dc);
		drawBattery(dc);

		// draw info fields on top, so they are not covered by the watch hands
		if (phoneConnected) {
			drawPhoneConnected(dc);
		}
		if (alarmCount > 0) {
			drawAlarmCount(dc, alarmCount);
		}
		if (heartRate != null && heartRate < 250 && heartRate > 0) {
			drawHeartRate(dc, heartRate);
		}
		if (altitude != null) {
			drawAltitude(dc, altitude);
		}
		if (location != null) {
			drawSun(dc, time, location, altitude);
		}
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

	// reset the display
	function erase(dc) {
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
		dc.clear();
	}
}
