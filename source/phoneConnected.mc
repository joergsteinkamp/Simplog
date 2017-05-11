using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

function drawPhoneConnected(dc) {
	dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
	dc.setPenWidth(symbolScale);
	var btSymbol = [ [0, 9], [6, 3], [3, 0], [3, 12], [6, 9], [-1, 2] ];
	for (var i = 0; i < btSymbol.size() - 1; i++) {
		dc.drawLine(symbolScale * btSymbol[i][0] + centerX - 15,
		            symbolScale * btSymbol[i][1] + centerY - radius / 1.6,
		            symbolScale * btSymbol[i + 1][0] + centerX - 15,
		            symbolScale * btSymbol[i + 1][1] + centerY - radius / 1.6);
	}
}
