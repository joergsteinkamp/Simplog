using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

function drawAlarmCount(dc, alarmCount) {
	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
	var image = Ui.loadResource(Rez.Drawables.alarm);
	dc.drawBitmap(centerX + 6, centerY - radius / 1.6  , image);
}
