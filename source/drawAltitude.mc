using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

function drawAltitude(dc, altitude) {
	var fontHeight = Gfx.getFontHeight(Gfx.FONT_XTINY);
	dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
	dc.setPenWidth(symbolScale);
	var mtSymbol = [ [0, 10], [4, 2], [6, 6], [5, 4], [7, 0], [13, 11] ];
	for (var i = 0; i < mtSymbol.size() - 1; i++) {
		dc.drawLine(symbolScale * mtSymbol[i][0] + centerX + radiusBattery / 2,
		            symbolScale * mtSymbol[i][1] + centerY - radius / 4 - 8,
		            symbolScale * mtSymbol[i + 1][0] + centerX + radiusBattery / 2,
		            symbolScale * mtSymbol[i + 1][1] + centerY - radius / 4 - 8);
	}
	dc.drawText(centerX + radiusBattery / 2 + 15,
				centerY - radius / 4 - 9 - fontHeight / 4,
				Gfx.FONT_TINY, altitude.format("%1.0f"), Gfx.TEXT_JUSTIFY_LEFT);
}
