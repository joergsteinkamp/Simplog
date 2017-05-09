using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.ActivityMonitor as AM;
using Toybox.Activity as Act;
using Toybox.Graphics as Gfx;

function drawMessages(dc) {
	var offsetX = 3 * symbolScale;
	var offsetY = 5 * symbolScale;
	var fontHeight = Gfx.getFontHeight(Gfx.FONT_XTINY);
	// is the phone connected?
	if (Sys.getDeviceSettings().phoneConnected) {
		dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
		dc.setPenWidth(symbolScale);
		var btSymbol = [ [0, 9], [6, 3], [3, 0], [3, 12], [6, 9], [-1, 2] ];
		for (var i = 0; i < btSymbol.size() - 1; i++) {
			dc.drawLine(symbolScale * btSymbol[i][0] + centerX - offsetX,
			            symbolScale * btSymbol[i][1] + centerY - radius/1.6 - offsetY,
			            symbolScale * btSymbol[i+1][0] + centerX - offsetX,
			            symbolScale * btSymbol[i+1][1] + centerY - radius/1.6 - offsetY);
		}
	}

	// f_js_20170211
	// is an alarm set?
	var alarmCount = Sys.getDeviceSettings().alarmCount;
	//alarmCount=1;
	if (alarmCount > 0) {
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
		var image = Ui.loadResource(Rez.Drawables.alarm);
		dc.drawBitmap(centerX - 6, centerY - radius/2.0 , image);			
	}

	var messageCount = Sys.getDeviceSettings().notificationCount;
	//messageCount = 17;
	// number of notifications
	if (messageCount > 0) {
		var digits = Math.floor(1+Math.log(messageCount, 10));
		dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);
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
	// Heart rate
	fontHeight = Gfx.getFontHeight(Gfx.FONT_TINY);
	var hrHist =  AM.getHeartRateHistory(1, true);
	var hr = hrHist.next().heartRate;
	if (hr != null && hr < 250) {
		dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
		var image = Ui.loadResource(Rez.Drawables.heart);
		dc.drawBitmap(centerX/2.5 - 2, centerY-radius/3.5 ,image);
		dc.drawText(centerX/2.5 + 15,
					centerY - radius/3.5 - 5,
					Gfx.FONT_TINY, hr.format("%1.0f"), Gfx.TEXT_JUSTIFY_LEFT);
	} else {
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
		dc.drawText(18, centerY - fontHeight/2, Gfx.FONT_TINY, 9, Gfx.TEXT_JUSTIFY_CENTER);
	}

	var altitude = Act.getActivityInfo().altitude;
	if (altitude != null) {
		dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
		dc.setPenWidth(symbolScale);
		var mtSymbol = [ [0, 10], [4, 2], [6, 6], [5, 4], [7, 0], [13, 11] ];
		for (var i = 0; i < mtSymbol.size() - 1; i++) {
			dc.drawLine(symbolScale * mtSymbol[i][0] + centerX/2.5,
			            symbolScale * mtSymbol[i][1] + centerY - radius/2.2,
			            symbolScale * mtSymbol[i+1][0] + centerX/2.5,
			            symbolScale * mtSymbol[i+1][1] + centerY - radius/2.2);
		}
		dc.drawText(centerX/2.5 + 15,
					centerY - radius/2.2 - 6,
					Gfx.FONT_TINY, altitude.format("%1.0f"), Gfx.TEXT_JUSTIFY_LEFT);
	}
}
