using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

function drawHeartRate(dc, centerX, centerY, radius, radiusBattery, heartRate) {
	dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
	var image = Ui.loadResource(Rez.Drawables.heart);
	dc.drawBitmap(centerX - radiusBattery - radius / 7.4, 
				  centerY - radiusBattery - radius / 4 + 1, image);
	dc.drawText(centerX - radiusBattery - radius / 7.4 - 3,
				centerY - radiusBattery - radius / 4 - 5,
				Gfx.FONT_TINY, heartRate.format("%1.0f"), Gfx.TEXT_JUSTIFY_RIGHT);	
}
