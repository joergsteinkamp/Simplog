using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

function drawMessages(dc, phoneConnected, alarmCount, notificationCount, heartRate, altitude) {
	var offsetX = 3 * symbolScale;
	var offsetY = 5 * symbolScale;
	var fontHeight = Gfx.getFontHeight(Gfx.FONT_XTINY);

	// is the phone connected?
	if (phoneConnected) {
		dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
		dc.setPenWidth(symbolScale);
		var btSymbol = [ [0, 9], [6, 3], [3, 0], [3, 12], [6, 9], [-1, 2] ];
		for (var i = 0; i < btSymbol.size() - 1; i++) {
			dc.drawLine(symbolScale * btSymbol[i][0] + centerX - offsetX,
			            symbolScale * btSymbol[i][1] + centerY - radius / 1.6 - offsetY,
			            symbolScale * btSymbol[i + 1][0] + centerX - offsetX,
			            symbolScale * btSymbol[i + 1][1] + centerY - radius / 1.6 - offsetY);
		}
	}

	// alarms;
	if (alarmCount > 0) {
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
		var image = Ui.loadResource(Rez.Drawables.alarm);
		dc.drawBitmap(centerX - 6, centerY - radius / 2.0 , image);			
	}

	// number of notifications
	if (notificationCount > 0) {
		var digits = Math.floor(1+Math.log(notificationCount, 10));
		dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);
		dc.setPenWidth(symbolScale);
		var width = fontHeight * (2 + digits) / 3;
		dc.fillRoundedRectangle(centerX + radius / 4,
								centerY - radius / 3 - fontHeight,
								width, fontHeight, 4);

		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_YELLOW);
		dc.drawText(centerX + radius / 4 + fontHeight / 2 * (1 + digits * 2) / 3 + 2,
					centerY - radius / 3 - fontHeight / 2 - 1,
					Gfx.FONT_XTINY, notificationCount, Gfx.TEXT_JUSTIFY_VCENTER);
	}

	System.println(radius);

	// Heart rate
	fontHeight = Gfx.getFontHeight(Gfx.FONT_TINY);
	if (heartRate != null && heartRate < 250) {
		dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
		var image = Ui.loadResource(Rez.Drawables.heart);
		//dc.drawBitmap(centerX / 2.5 - 2, centerY - radius / 3.5 , image);
		//dc.drawText(centerX / 2.5 + 15,
		//			centerY - radius / 3.5 - 5,
		//			Gfx.FONT_TINY, heartRate.format("%1.0f"), Gfx.TEXT_JUSTIFY_LEFT);
		dc.drawBitmap(centerX - radiusBattery - radius / 7.4, 
					  centerY - radiusBattery - radius / 5.7, image);
		dc.drawText(centerX - radiusBattery - radius / 7.4 - 3,
					centerY - radiusBattery - radius / 5.7 - 4,
					Gfx.FONT_TINY, heartRate.format("%1.0f"), Gfx.TEXT_JUSTIFY_RIGHT);
		
	}

	// altitude
	if (altitude != null) {
		dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
		dc.setPenWidth(symbolScale);
		var mtSymbol = [ [0, 10], [4, 2], [6, 6], [5, 4], [7, 0], [13, 11] ];
		for (var i = 0; i < mtSymbol.size() - 1; i++) {
			//dc.drawLine(symbolScale * mtSymbol[i][0] + centerX / 2.5,
			//            symbolScale * mtSymbol[i][1] + centerY - radius / 2.2,
			//            symbolScale * mtSymbol[i + 1][0] + centerX / 2.5,
			//            symbolScale * mtSymbol[i + 1][1] + centerY - radius / 2.2);
			dc.drawLine(symbolScale * mtSymbol[i][0] + centerX + radiusBattery / 2,
			            symbolScale * mtSymbol[i][1] + centerY - radius / 5.7 - 8,
			            symbolScale * mtSymbol[i + 1][0] + centerX + radiusBattery / 2,
			            symbolScale * mtSymbol[i + 1][1] + centerY - radius / 5.7 - 8);
			
		}
		//dc.drawText(centerX/2.5 + 15,
		//			centerY - radius / 2.2 - 6,
		//			Gfx.FONT_TINY, altitude.format("%1.0f"), Gfx.TEXT_JUSTIFY_LEFT);
		dc.drawText(centerX + radiusBattery / 2 + 15,
					centerY - radius / 5.7 - 9 - fontHeight / 4,
					Gfx.FONT_TINY, altitude.format("%1.0f"), Gfx.TEXT_JUSTIFY_LEFT);
	}
}
