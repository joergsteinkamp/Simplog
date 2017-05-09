using Toybox.Time as Time;
using Toybox.Time.Gregorian as Cal;
using Toybox.Math as Math;
using Toybox.Activity as Act;

function sunRiseSet() {
	var JulianOffset = 2451545.0;
	var deg2rad = Math.PI / 180.0;
	var tilt = 23.4397;
	// get the location infos
	var altitude = Act.getActivityInfo().altitude;
	System.println(altitude);
	var location = Act.getActivityInfo().currentLocation;
	var long = 8.0;
	var lat  = 50.0;
	if (location != null) {
		long = location.toDegrees()[1];
	    lat  = location.toDegrees()[0];
	} else {
		System.println("Cannot get currentLocation!");
	}
	// get the time and time zone infos
    var time = Time.now();
	var ltime = Cal.info(time, Time.FORMAT_SHORT);
	var utc = Cal.utcInfo(time, Time.FORMAT_SHORT);
	var ltimeHourOffset = ltime.hour - utc.hour;
	var ltimeMinOffset  = ltime.min - utc.min;

    var refDate = Cal.moment({ :year=>2000, :month=>1, :day=>1, :hour=>12, :minute=>0, :second=>0 });

	// current rounded days since 1. Jan 2000 12:00 
	var N = Math.round((time.value() - refDate.value()) / Cal.SECONDS_PER_DAY);
    System.println(N);
    
	// shift by longitude
  	var J = N - long / 360.0;
  	System.println(J);

  	// solar mean anomaly (in degree)
  	var M = (357.5291 + 0.98560028 * J).toLong() % 360;
	System.println(M);

  	// equation of the center
  	var C = 1.9148 * Math.sin(deg2rad * M) + 0.02 * Math.sin(2.0 * deg2rad * M)  + 0.0003 * Math.sin(3.0 * deg2rad * M);
  	System.println(C);

 	// ecliptic longitude (degree)
    var lambda = (M + C + 180.0 + 102.9372).toLong() % 360;
    System.println(lambda);

  	// time of solar transit (solar noon)
  	var Jtransit = J + 0.0053 * Math.sin(deg2rad * M) - 0.0069 * Math.sin(2.0 * deg2rad * lambda);
  	var sunTransit = refDate.value() + Jtransit * Cal.SECONDS_PER_DAY;
	System.println(Jtransit);
	System.println(sunTransit);

  	// declination of the sun (radian)
  	var delta = Math.asin(Math.sin(deg2rad * lambda) * Math.sin(deg2rad * tilt));
	System.println(delta);

	// hour angle
  	var omega = (Math.sin(deg2rad * (-0.83 - 2.076 * Math.sqrt(altitude) / 60.0)) - 
  	Math.sin(deg2rad * lat) * Math.sin(delta)) / (Math.cos(deg2rad * lat) * Math.cos(delta));
	System.println(omega);
	
	var	dt = (Jtransit - Math.acos(omega) / (2.0 * Math.PI)) * Cal.SECONDS_PER_DAY;
	var sunRise = refDate.add(Cal.duration({ :seconds => dt}));
	dt = (Jtransit + Math.acos(omega) / (2.0 * Math.PI)) * Cal.SECONDS_PER_DAY;
	var sunSet = refDate.add(Cal.duration({ :seconds => dt}));
	
	//var sunRise = refDate.value() + (Jtransit - Math.acos(omega)/(2.0 * Math.PI)) * Cal.SECONDS_PER_DAY;
    //var sunSet  = refDate.value() + (Jtransit + Math.acos(omega)/(2.0 * Math.PI)) * Cal.SECONDS_PER_DAY;
	System.println(sunRise);
	System.println(sunSet);
	return({ :rise => sunRise, :set=>sunSet});
	

  //return(as.POSIXct(c(sun.rise, sun.transit, sun.set), tz=tz))

}