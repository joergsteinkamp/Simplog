// draw the weekday and day of the month at hour 3
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Time.Gregorian as Cal;

function drawDay(dc, time) {
    var date = Cal.info(time, Time.FORMAT_MEDIUM);
	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
	var wday = Lang.format("$1$", [date.day_of_week]);
	var dom  = Lang.format("$1$", [date.day]);
	var dateStr = Lang.format("$1$ $2$", [wday.substring(0, 2), dom]);
	dc.drawText(centerX + radius - 2, centerY - Gfx.getFontHeight(Gfx.FONT_TINY)/2,
	            Gfx.FONT_TINY, dateStr, Gfx.TEXT_JUSTIFY_RIGHT);
}
