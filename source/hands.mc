using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

function drawHands(dc) {
	dc.setPenWidth(1);
	var time = Sys.getClockTime();
	var dayMinutes = time.min + time.hour * 60;

	var angle = Math.PI * dayMinutes / 360.0;
	var handHour = [ [ centerX - Math.sin(angle) * radiusBattery * 2,
					   centerY + Math.cos(angle) * radiusBattery * 2],
					 [ centerX - Math.sin(angle) * radiusBattery * 1.75 + Math.cos(angle) * radiusBattery * 0.875,
					   centerY + Math.cos(angle) * radiusBattery * 1.75 + Math.sin(angle) * radiusBattery * 0.875],
					 [ centerX + Math.cos(angle) * radiusBattery * 1.375, 
					   centerY + Math.sin(angle) * radiusBattery * 1.375],
					 [ centerX + Math.sin(angle) * radius * 0.5 + Math.cos(angle) * radiusBattery * 0.5,
					   centerY - Math.cos(angle) * radius * 0.5 + Math.sin(angle) * radiusBattery * 0.5],
					 [ centerX + Math.sin(angle) * radius * 0.55,
					   centerY - Math.cos(angle) * radius * 0.55],
					 [ centerX + Math.sin(angle) * radius * 0.5 - Math.cos(angle) * radiusBattery * 0.5,
					   centerY - Math.cos(angle) * radius * 0.5 - Math.sin(angle) * radiusBattery * 0.5],
					 [ centerX - Math.cos(angle) * radiusBattery * 1.375,
					   centerY - Math.sin(angle) * radiusBattery * 1.375],
					 [ centerX - Math.sin(angle) * radiusBattery * 1.75 - Math.cos(angle) * radiusBattery * 0.875,
					   centerY + Math.cos(angle) * radiusBattery * 1.75 - Math.sin(angle) * radiusBattery * 0.875] ];
	dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
	dc.fillPolygon(handHour);

	// hardcoded index!
	dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
	dc.fillPolygon(handHour.slice(0, 5));

	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
	for (var i = 0; i < handHour.size() - 1; i++) {
		dc.drawLine(handHour[i][0], handHour[i][1], handHour[i+1][0], handHour[i+1][1]);
	}
	dc.drawLine(handHour[0][0], handHour[0][1], handHour[handHour.size()-1][0], handHour[handHour.size()-1][1]);
	dc.drawLine(handHour[0][0], handHour[0][1], handHour[4][0], handHour[4][1]);

	// draw two polygons per hand: one larger gray
	// minute hand
	angle = Math.PI * dayMinutes / 30.0;
	var handMin = [ [ centerX - Math.sin(angle) * radiusBattery * 2.5,
					  centerY + Math.cos(angle) * radiusBattery * 2.5],
					[ centerX - Math.sin(angle) * radiusBattery * 2.125 + Math.cos(angle) * radiusBattery * 0.625,
					  centerY + Math.cos(angle) * radiusBattery * 2.125 + Math.sin(angle) * radiusBattery * 0.625],
					[ centerX + Math.cos(angle) * radiusBattery,
					  centerY + Math.sin(angle) * radiusBattery],
					[ centerX + Math.sin(angle) * radius * 0.8 + Math.cos(angle) * radiusBattery * 0.375,
					  centerY - Math.cos(angle) * radius * 0.8 + Math.sin(angle) * radiusBattery * 0.375],
					[ centerX + Math.sin(angle) * radius * 0.85,
					  centerY - Math.cos(angle) * radius * 0.85],
					[ centerX + Math.sin(angle) * radius * 0.8 - Math.cos(angle) * radiusBattery * 0.375,
					  centerY - Math.cos(angle) * radius * 0.8 - Math.sin(angle) * radiusBattery * 0.375],
					[ centerX - Math.cos(angle) * radiusBattery,
					  centerY - Math.sin(angle) * radiusBattery],
					[ centerX - Math.sin(angle) * radiusBattery * 2.125 - Math.cos(angle) * radiusBattery * 0.625,
					  centerY + Math.cos(angle) * radiusBattery * 2.125 - Math.sin(angle) * radiusBattery * 0.625] ];
	dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
	dc.fillPolygon(handMin);

	// hardcoded index!
	dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
	dc.fillPolygon(handMin.slice(0, 5));

	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
	for (var i = 0; i < handMin.size() - 1; i++) {
		dc.drawLine(handMin[i][0], handMin[i][1], handMin[i+1][0], handMin[i+1][1]);
	}
	dc.drawLine(handMin[0][0], handMin[0][1], handMin[handMin.size() - 1][0], handMin[handMin.size() - 1][1]);
	dc.drawLine(handMin[0][0], handMin[0][1], handMin[4][0], handMin[4][1]);
}
