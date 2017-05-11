using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

function drawNotificationCount(dc, notificationCount) {
	var fontHeight = Gfx.getFontHeight(Gfx.FONT_XTINY);
	var digits = Math.floor(1 + Math.log(notificationCount, 10));
	dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);
	dc.setPenWidth(symbolScale);
	var width = fontHeight * (2 + digits) / 3;
	dc.fillRoundedRectangle(centerX - radius + radius / 55.0 * fontHeight,
							centerY - fontHeight / 2,
							width, fontHeight, 4);

	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_YELLOW);
	dc.drawText(centerX - radius + radius / 55.0 * fontHeight + fontHeight / 2 * (1 + digits * 2) / 3 + 2,
				centerY - 1,
				Gfx.FONT_XTINY, notificationCount, Gfx.TEXT_JUSTIFY_VCENTER);
}
