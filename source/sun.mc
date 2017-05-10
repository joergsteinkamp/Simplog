//using Toybox.Time as Time;
using Toybox.Time.Gregorian as Cal;
using Toybox.Math as Math;
using Toybox.Graphics as Gfx;

function drawSun(dc, time, location, altitude) {
	//update only once an hour
	if (sunTimes == null || Cal.info(time, Time.FORMAT_SHORT).min == 0) {
	   sunTimes = sunRiseSet(time, location, altitude);
	}
	var sunRise = Cal.info(sunTimes[0], Cal.FORMAT_SHORT);
    var sunSet = Cal.info(sunTimes[1], Cal.FORMAT_SHORT);
	
	dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);
	dc.drawText(centerX, centerY + radius/5, Gfx.FONT_TINY,
				Lang.format("$1$:$2$ $3$:$4$", [sunRise.hour, sunRise.min, sunSet.hour, sunSet.min]), Gfx.TEXT_JUSTIFY_CENTER);
	
	//System.println(Lang.format("$1$:$2$", [sunRise.hour, sunRise.min]));
	//System.println(Lang.format("$1$:$2$", [sunSet.hour, sunSet.min]));
	
	
}

function sunRiseSet(time, location, altitude) {
	var JulianOffset = 2451545.0;
	var deg2rad = Math.PI / 180.0;
	var tilt = 23.4397;
	// get the location infos
	var long = 8.0;
	var lat  = 50.0;
	if (location != null) {
		long = location.toDegrees()[1];
	    lat  = location.toDegrees()[0];
	} else {
		System.println("sunRiseSet: Cannot get current location!");
	}
	// get the time and time zone infos
	//var ltime = Cal.info(time, Time.FORMAT_SHORT);
	//var utc = Cal.utcInfo(time, Time.FORMAT_SHORT);
	//var ltimeHourOffset = ltime.hour - utc.hour;
	//var ltimeMinOffset  = ltime.min - utc.min;

    var refDate = Cal.moment({ :year=>2000, :month=>1, :day=>1, :hour=>12, :minute=>0, :second=>0 });

	// current rounded days since 1. Jan 2000 12:00 
	var N = Math.round((time.value() - refDate.value()) / Cal.SECONDS_PER_DAY);
    
	// shift by longitude
  	var J = N - long / 360.0;
 
  	// solar mean anomaly (in degree)
  	var M = (357.5291 + 0.98560028 * J);
  	var rest = M - Math.floor(M);
  	M = (M.toLong() % 360) + rest;

  	// equation of the center
  	var C = 1.9148 * Math.sin(deg2rad * M) + 0.02 * Math.sin(2.0 * deg2rad * M)  + 0.0003 * Math.sin(3.0 * deg2rad * M);

 	// ecliptic longitude (degree)
    var lambda = (M + C + 180.0 + 102.9372);
    rest = lambda - Math.floor(lambda);
    lambda = (lambda.toLong() % 360) + rest;
 
  	// time of solar transit (solar noon)
  	var Jtransit = J + 0.0053 * Math.sin(deg2rad * M) - 0.0069 * Math.sin(2.0 * deg2rad * lambda);
  	var sunTransit = refDate.value() + Jtransit * Cal.SECONDS_PER_DAY;

  	// declination of the sun (radian)
  	var delta = Math.asin(Math.sin(deg2rad * lambda) * Math.sin(deg2rad * tilt));

	// hour angle
  	var omega = (Math.sin(deg2rad * (-0.83 - 2.076 * Math.sqrt(altitude) / 60.0)) - 
  	Math.sin(deg2rad * lat) * Math.sin(delta)) / (Math.cos(deg2rad * lat) * Math.cos(delta));
	
	var	dt = (Jtransit - Math.acos(omega) / (2.0 * Math.PI)) * Cal.SECONDS_PER_DAY;
	var sunRise = refDate.add(Cal.duration({ :seconds => dt}));
	dt = (Jtransit + Math.acos(omega) / (2.0 * Math.PI)) * Cal.SECONDS_PER_DAY;
	var sunSet = refDate.add(Cal.duration({ :seconds => dt}));
	
	//var sunRise = refDate.value() + (Jtransit - Math.acos(omega)/(2.0 * Math.PI)) * Cal.SECONDS_PER_DAY;
    //var sunSet  = refDate.value() + (Jtransit + Math.acos(omega)/(2.0 * Math.PI)) * Cal.SECONDS_PER_DAY;
	return([sunRise, sunSet]);
}
