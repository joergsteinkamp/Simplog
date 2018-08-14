using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Time;
using Toybox.Activity as Act;
using Toybox.ActivityMonitor as AM;
using Toybox.System as Sys;
using Toybox.Timer;
class SimplogView extends Ui.WatchFace {
	// display properties
	var centerX, centerY, radius;
	// size of colored battery indicator (center point) 
	var radiusBattery = 8;
	// scale factor for symbols
	var symbolScale = 1;

	var inLowPower = true;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
    	self.centerX = dc.getWidth() / 2;
    	self.centerY = dc.getHeight() / 2;
    	self.radius = self.centerX < self.centerY ? self.centerX : self.centerY;
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
        var actInfo  = Act.getActivityInfo();
		var altitude = actInfo.altitude;
		var location = actInfo.currentLocation;

		var devStat = Sys.getDeviceSettings();
		var phoneConnected    = devStat.phoneConnected;
		var alarmCount        = devStat.alarmCount;
		var notificationCount = devStat.notificationCount;
		var heartRate = 0;
		if (AM has :getHeartRateHistory) {
		  var hrHist =  AM.getHeartRateHistory(1, true);
		  heartRate = hrHist.next().heartRate;
		} else {
		  heartRate = null;
		}

		//phoneConnected = true;
		//alarmCount = 1;
		//notificationCount=19;
		//altitude=200;
		//location = null;
	
        // clear the display
        erase(dc);

        // draw the watch components
        drawTicks(dc, self.centerX, self.centerY, self.radius);
		drawDay(dc, time, self.centerX, self.centerY, self.radius);

		// draw the notification count bellow the watch hands 
		if (notificationCount > 0) {
			drawNotificationCount(dc, self.centerX, self.centerY, self.radius, self.symbolScale, notificationCount);
		}

		drawHands(dc, self.centerX, self.centerY, self.radius, self.radiusBattery, inLowPower);
		drawBattery(dc, self.centerX, self.centerY, self.radius, self.radiusBattery, self.symbolScale);

		// draw info fields on top, so they are not covered by the watch hands
		if (phoneConnected) {
			drawPhoneConnected(dc, self.centerX, self.centerY, self.radius, self.symbolScale);
		}
		if (alarmCount > 0) {
			drawAlarmCount(dc, self.centerX, self.centerY, self.radius, alarmCount);
		}
		if (heartRate != null && heartRate < 250 && heartRate > 0) {
			drawHeartRate(dc, self.centerX, self.centerY, self.radius, self.radiusBattery, heartRate);
		}
		if (altitude != null) {
			drawAltitude(dc, self.centerX, self.centerY, self.radius, self.radiusBattery, self.symbolScale, altitude);
		}
		//if (location != null) {
			drawSun(dc, self.centerX, self.centerY, self.radius, time, location, altitude);
		//}
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
     	inLowPower=false;
    	Ui.requestUpdate();
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
        inLowPower=true;
    	Ui.requestUpdate();
    }

	// reset the display
	function erase(dc) {
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
		dc.clear();
	}
}
