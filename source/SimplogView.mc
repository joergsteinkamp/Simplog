using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Time as Time;
using Toybox.Activity as Act;
using Toybox.ActivityMonitor as AM;
using Toybox.System as Sys;

class SimplogView extends Ui.WatchFace {
	// f_js_20160826
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
    	// f_js_20160826
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
        // f_js_201608026
        var time = Time.now();
		var altitude = Act.getActivityInfo().altitude;
		var location = Act.getActivityInfo().currentLocation;

		var phoneConnected = Sys.getDeviceSettings().phoneConnected;
		var alarmCount = Sys.getDeviceSettings().alarmCount;
		var notificationCount = Sys.getDeviceSettings().notificationCount;
		var hrHist =  AM.getHeartRateHistory(1, true);
		var heartRate = hrHist.next().heartRate;

        // clear the display
        erase(dc);

        // draw the watch components
        drawTicks(dc);
		drawDay(dc, time);

		drawHands(dc);
		drawBattery(dc);

		drawSun(dc, time, location, altitude);

		// draw info fields on top, so it is not hidden by the watch hands
		drawMessages(dc, phoneConnected, alarmCount, notificationCount, heartRate, altitude);
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

	// f_js_20160826
	// reset the display
	function erase(dc) {
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
		dc.clear();
	}
}
