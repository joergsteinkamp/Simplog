using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

function drawHeartRate(dc, heartRate) {
	dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
	var image = Ui.loadResource(Rez.Drawables.heart);
	dc.drawBitmap(centerX - radiusBattery - radius / 7.4, 
				  centerY - radiusBattery - radius / 4, image);
	dc.drawText(centerX - radiusBattery - radius / 7.4 - 3,
				centerY - radiusBattery - radius / 4 - 6,
				Gfx.FONT_TINY, heartRate.format("%1.0f"), Gfx.TEXT_JUSTIFY_RIGHT);	
}
