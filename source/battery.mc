// draw the battery status at hour 12
// >80% white; >50 blue; >20% green; >10% yellow; >5% orange; <5% red
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

function drawBattery(dc, centerX, centerY, radius, radiusBattery, symbolScale) {
	var battStat = Sys.getSystemStats().battery.toNumber();
	if (battStat > 80) {
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
	} else if (battStat > 50) {
		dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
	} else if (battStat > 20) {
		dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
	} else if (battStat > 10) {
		dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);
	} else if (battStat > 5) {
		dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);	
	} else {
		dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
	}
	dc.fillCircle(centerX, centerY, radiusBattery * symbolScale + 2);
	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
	dc.setPenWidth(3);
	dc.drawCircle(centerX, centerY, radius*symbolScale + 2);
}
