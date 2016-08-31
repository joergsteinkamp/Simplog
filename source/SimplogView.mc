using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;

// js_mz_20160826
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Cal;
using Toybox.ActivityMonitor as AM;
using Toybox.Activity as Act;

class SimplogView extends Ui.WatchFace {

	// f_js_20160826
	// display properties
	hidden var centerX, centerY, radius;
	// size of colored battery indicator (center point) 
	hidden var radiusBattery = 6;
	// scale factor for symbols
	hidden var symbolScale = 1;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
    	// f_js_20160826
    	centerX = dc.getWidth() / 2;
    	centerY = dc.getHeight() / 2;
    	radius = centerX < centerY ? centerY : centerX;
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
        var date = Cal.info(time, Time.FORMAT_MEDIUM);

        // clear the display
        erase(dc);

        // draw the watch components
        drawTicks(dc);
		drawDay(dc, date);

		drawHands(dc);
		drawBattery(dc);

		// draw info fields on top, so it is not hidden by the watch hands
		drawMessages(dc);
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

	// f_js_20160826 
	// draw the minute ticks and labels
	function drawTicks(dc) {
		var length = 0;
		var angle  = 0;
		var innerX = 0;
		var outerX = 0;
		var innerY = 0;
		var outerY = 0;
		var fontX  = 0;
		var fontY  = 0;
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
		for (var i = 1; i <= 60; i++) {
			angle = Math.PI * i / 30;
			// skip hours 12 and 3
			if ((i>13 && i<17) || i==0) {
				continue;
			} else if (i%5 == 0) {
				dc.setPenWidth(2);
				length = 6;
				innerX = centerX + Math.sin(angle) * (radius - length);
				innerY = centerY - Math.cos(angle) * (radius - length);
				fontX = centerX + Math.sin(angle) * (radius - 3*length);
				fontY = centerY - 2*length - Math.cos(angle) * (radius - 3*length);
	    		dc.drawText(fontX, fontY, Gfx.FONT_TINY, i/5, Gfx.TEXT_JUSTIFY_CENTER);
			} else {
				dc.setPenWidth(1);
				length = 2;
				innerX = centerX + Math.sin(angle) * (radius - length);
				innerY = centerY - Math.cos(angle) * (radius - length);
			}
			outerX = centerX + Math.sin(angle) * (radius);
			outerY = centerY - Math.cos(angle) * (radius);
		    dc.drawLine(innerX, innerY, outerX, outerY);
		}
	}
	
	// f_js_20160826
	// draw the weekday and day of the month at hour 3
	function drawDay(dc, date) {
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
		var wday = Lang.format("$1$", [date.day_of_week]);
		var dom  = Lang.format("$1$", [date.day]);
		var dateStr = Lang.format("$1$ $2$", [wday.substring(0, 2), dom]);
		dc.drawText(2*radius-2, centerY - Gfx.getFontHeight(Gfx.FONT_TINY)/2,
		            Gfx.FONT_TINY, dateStr, Gfx.TEXT_JUSTIFY_RIGHT);
	}
	
	// f_js_20160826
	// draw the battery status at hour 12
	// >80 green; >50% blue; >20% yellow; >10% orange; <10% red
	function drawBattery(dc) {
		var battStat = Sys.getSystemStats().battery.toNumber();
		if (battStat > 80) {
			dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
		} else if (battStat > 50) {
			dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_BLACK);
		} else if (battStat > 20) {
			dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_BLACK);
		} else if (battStat > 10) {
			dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_BLACK);
		} else if (battStat > 5) {
			dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_BLACK);	
		} else {
			dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_BLACK);
		}
		dc.fillCircle(centerX, centerY, radiusBattery * symbolScale);
	}
	
	function drawHands(dc) {
		var time = Sys.getClockTime();
		var dayMinutes = time.min + time.hour * 60;
		// draw two polygons per hand: one larger gray
		// minute hand
		var angle = Math.PI * dayMinutes / 30;
		dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_BLACK);
		var innerX = centerX - Math.sin(angle + Math.PI/6) * radiusBattery;
		var innerY = centerY + Math.cos(angle + Math.PI/6) * radiusBattery;
		var midX1  = centerX + Math.sin(angle + Math.PI/6) * radiusBattery * 1.45;
		var midY1  = centerY - Math.cos(angle + Math.PI/6) * radiusBattery * 1.45;
		var midX2  = centerX + Math.sin(angle - Math.PI/6) * radiusBattery * 1.45;
		var midY2  = centerY - Math.cos(angle - Math.PI/6) * radiusBattery * 1.45;
		var outerX = centerX + Math.sin(angle) * radius * 0.7;
		var outerY = centerY - Math.cos(angle) * radius * 0.7;
		dc.fillPolygon([[innerX, innerY], [midX1, midY1], [outerX, outerY], [midX2, midY2]]);

		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
		innerX = centerX - Math.sin(angle + Math.PI/6) * radiusBattery;
		innerY = centerY + Math.cos(angle + Math.PI/6) * radiusBattery;
		midX1  = centerX + Math.sin(angle + Math.PI/6) * radiusBattery * 1.25;
		midY1  = centerY - Math.cos(angle + Math.PI/6) * radiusBattery * 1.25;
		midX2  = centerX + Math.sin(angle - Math.PI/6) * radiusBattery * 1.25;
		midY2  = centerY - Math.cos(angle - Math.PI/6) * radiusBattery * 1.25;
		outerX = centerX + Math.sin(angle) * radius * 0.67;
		outerY = centerY - Math.cos(angle) * radius * 0.67;
		dc.fillPolygon([[innerX, innerY], [midX1, midY1], [outerX, outerY], [midX2, midY2]]);

		// hour hand
		dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_BLACK);
		angle = Math.PI * dayMinutes / 360;
		innerX = centerX - Math.sin(angle + Math.PI/4) * radiusBattery;
		innerY = centerY + Math.cos(angle + Math.PI/4) * radiusBattery;
		midX1  = centerX + Math.sin(angle + Math.PI/4) * radiusBattery * 1.55;
		midY1  = centerY - Math.cos(angle + Math.PI/4) * radiusBattery * 1.55;
		midX2  = centerX + Math.sin(angle - Math.PI/4) * radiusBattery * 1.55;
		midY2  = centerY - Math.cos(angle - Math.PI/4) * radiusBattery * 1.55;
		outerX = centerX + Math.sin(angle) * radius * 0.5;
		outerY = centerY - Math.cos(angle) * radius * 0.5;
		dc.fillPolygon([[innerX, innerY], [midX1, midY1], [outerX, outerY], [midX2, midY2]]);

		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
		innerX = centerX - Math.sin(angle + Math.PI/4) * radiusBattery;
		innerY = centerY + Math.cos(angle + Math.PI/4) * radiusBattery;
		midX1  = centerX + Math.sin(angle + Math.PI/4) * radiusBattery * 1.35;
		midY1  = centerY - Math.cos(angle + Math.PI/4) * radiusBattery * 1.35;
		midX2  = centerX + Math.sin(angle - Math.PI/4) * radiusBattery * 1.35;
		midY2  = centerY - Math.cos(angle - Math.PI/4) * radiusBattery * 1.35;
		outerX = centerX + Math.sin(angle) * radius * 0.48;
		outerY = centerY - Math.cos(angle) * radius * 0.48;
		dc.fillPolygon([[innerX, innerY], [midX1, midY1], [outerX, outerY], [midX2, midY2]]);

	}
	
	function drawMessages(dc) {
		var offsetX = 3 * symbolScale;
		var offsetY = 6 * symbolScale;
		var fontHeight = Gfx.getFontHeight(Gfx.FONT_XTINY);
		// is the phone connected?
		if (Sys.getDeviceSettings().phoneConnected) {
			dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_BLACK);
			dc.setPenWidth(symbolScale);
			var btSymbol = [ [0, 9], [6, 3], [3, 0], [3, 12], [6, 9], [-1, 2] ];
			for (var i = 0; i < btSymbol.size() - 1; i++) {
				dc.drawLine(symbolScale * btSymbol[i][0] + centerX - offsetX,
				            symbolScale * btSymbol[i][1] + centerY - radius/1.6 - offsetY,
				            symbolScale * btSymbol[i+1][0] + centerX - offsetX,
				            symbolScale * btSymbol[i+1][1] + centerY - radius/1.6 - offsetY);
			}
		}

		var messageCount = Sys.getDeviceSettings().notificationCount;
		// number of notifications
		if (messageCount > 0) {
			var digits = Math.floor(1+Math.log(messageCount, 10));
			dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_BLACK);
			dc.setPenWidth(symbolScale);
			var width = fontHeight * (2+digits)/3;
			dc.fillRoundedRectangle(centerX + radius/4,
									centerY - radius/3 - fontHeight,
									width, fontHeight, 4);

			dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_YELLOW);
			dc.drawText(centerX + radius/4 + fontHeight/2 * (1+digits*2)/3 + 2,
						centerY - radius/3 - fontHeight/2 - 1,
						Gfx.FONT_XTINY, messageCount, Gfx.TEXT_JUSTIFY_VCENTER);
		}

		var hrHist =  AM.getHeartRateHistory(1, true);
		var hr = hrHist.next().heartRate;
		if (hr != null && hr < 250) {
			dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
			var image = Ui.loadResource(Rez.Drawables.heart);
			dc.drawBitmap(centerX/2.5 - 2, centerY-radius/3.5 ,image);
			dc.drawText(centerX/2.5 + 15,
						centerY - radius/3.5 - 4,
						Gfx.FONT_XTINY, hr.format("%1.0f"), Gfx.TEXT_JUSTIFY_LEFT);
		} else {
			dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
			dc.drawText(18, centerY- Gfx.getFontHeight(Gfx.FONT_TINY)/2, Gfx.FONT_TINY, 9, Gfx.TEXT_JUSTIFY_CENTER);
		}
		
		var altitude = Act.getActivityInfo().altitude;
		if (altitude != null) {
			dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_BLACK);
			dc.setPenWidth(symbolScale);
			var mtSymbol = [ [0, 10], [4, 2], [6, 6], [5, 4], [7, 0], [13, 11] ];
			for (var i = 0; i < mtSymbol.size() - 1; i++) {
				dc.drawLine(symbolScale * mtSymbol[i][0] + centerX/2.5,
				            symbolScale * mtSymbol[i][1] + centerY - radius/2.2,
				            symbolScale * mtSymbol[i+1][0] + centerX/2.5,
				            symbolScale * mtSymbol[i+1][1] + centerY - radius/2.2);
			}
			dc.drawText(centerX/2.5 + 15,
						centerY - radius/2.2 - 4,
						Gfx.FONT_XTINY, altitude.format("%1.0f"), Gfx.TEXT_JUSTIFY_LEFT);
		}
	}

	function drawGraph(dc) {
		// HR number and history colored by bereich
		
		// elevation (grey)
	}
}
