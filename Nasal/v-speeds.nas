# Calculate V speeds and stall speed

var speed_calc = func {
	var v1 = 0.0;
	var vr = 0.0;
	var v2 = 0.0;
	var weight = getprop("/yasim/gross-weight-lbs") / 1000;
	var flap_pos = getprop("controls/flight/flaps");
	var flap = 5;
	if (flap_pos > 0.3 and flap_pos < 0.6) flap = 15;
	if (flap_pos > 0.6) flap = 20;

	if (flap == 5) {
		v1 = (0.30 * (weight - 100)) + 71;
		vr = (0.28 * (weight - 100)) + 82;
		v2 = (0.24 * (weight - 100)) + 101;
	}
	if (flap == 15) {
		v1 = (0.28 * (weight - 100)) + 71;
		vr = (0.27 * (weight - 100)) + 78;
		v2 = (0.23 * (weight - 100)) + 95;
	}
	if (flap == 20) {
		v1 = (0.29 * (weight - 100)) + 65;
		vr = (0.26 * (weight - 100)) + 74;
		v2 = (0.23 * (weight - 100)) + 91;
	}

	var vgrosswt = math.sqrt(getprop("/yasim/gross-weight-lbs")/getprop("/limits/mass-and-balance/maximum-takeoff-mass-lbs"));

	var vref_table = [
                [0, vgrosswt * 160 + 80],
                [0.033, vgrosswt * 160 + 60],
                [0.166, vgrosswt * 160 + 40],
                [0.500, vgrosswt * 160 + 20],
                [0.666, vgrosswt * 160 + 20],
                [0.833, vgrosswt * 162],
                [1.000, vgrosswt * 160]];

	var vref = interpolate_table(vref_table, flap_pos);
	var stall = (vref - 25 + getprop("instrumentation/altimeter/indicated-altitude-ft") / 1000);

	setprop("/instrumentation/fmc/vspeeds/V1",v1);
	setprop("/instrumentation/fmc/vspeeds/VR",vr);
	setprop("/instrumentation/fmc/vspeeds/V2",v2);
	setprop("/instrumentation/fmc/vspeeds/stall-speed",stall);

	settimer(speed_calc, 5);
}

setlistener("/sim/signals/fdm-initialized", func {
	settimer(speed_calc, 2);
},0,0);


# interpolates a value
var interpolate_table = func(table, v)
 {
 var x = 0;
 forindex (i; table)
  {
  if (v >= table[i][0])
   {
   x = i + 1 < size(table) ? (v - table[i][0]) / (table[i + 1][0] - table[i][0]) * (table[i + 1][1] - table[i][1]) + table[i][1] : table[i][1];
   }
  }
 return x;
 };
