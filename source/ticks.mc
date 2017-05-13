// draw the minute ticks and labels
using Toybox.Graphics as Gfx;
using Toybox.Math as Math;

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
		if ((i > 13 && i < 17) || i == 0) {
			continue;
		} else if (i % 5 == 0) {
			dc.setPenWidth(3);
			length = 6;
			innerX = centerX + Math.sin(angle) * (radius - length);
			innerY = centerY - Math.cos(angle) * (radius - length);
			fontX = centerX + Math.sin(angle) * (radius - 3*length);
			fontY = centerY - 2 * length - Math.cos(angle) * (radius - 3 * length);
    		dc.drawText(fontX, fontY, Gfx.FONT_TINY, i / 5, Gfx.TEXT_JUSTIFY_CENTER);
		} else {
			dc.setPenWidth(2);
			length = 3;
			innerX = centerX + Math.sin(angle) * (radius - length);
			innerY = centerY - Math.cos(angle) * (radius - length);
		}
		outerX = centerX + Math.sin(angle) * (radius);
		outerY = centerY - Math.cos(angle) * (radius);
	    dc.drawLine(innerX, innerY, outerX, outerY);
	}
}
