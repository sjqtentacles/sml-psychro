(* demo.sml - psychrometric calculations: saturation vapor pressure, dew
   point, relative humidity, humidity ratio, wet-bulb temperature, and
   moist-air enthalpy. Deterministic: identical output on every run and both
   compilers. *)

structure P = Psychro

fun fmt n x =
  let val x = if Real.== (x, 0.0) then 0.0 else x
  in Real.fmt (StringCvt.FIX (SOME n)) x end

val () = print "Saturation vapor pressure (Magnus formula):\n"
val () =
  List.app
    (fn tC => print ("  satVaporPressure(" ^ fmt 1 tC ^ "C) = "
                     ^ fmt 2 (P.satVaporPressure tC) ^ " Pa\n"))
    [0.0, 20.0, 30.0, 100.0]

val () = print "\nDew point from relative humidity:\n"
val dp1 = P.rhToDewPoint {tC = 20.0, rh = 0.5}
val () = print ("  rhToDewPoint {tC=20.0, rh=0.5} = " ^ fmt 3 dp1 ^ " C\n")

val () = print "\nRelative humidity from dew point (round-trip check):\n"
val rh1 = P.dewPointToRh {tC = 20.0, dewC = dp1}
val () = print ("  dewPointToRh {tC=20.0, dewC=" ^ fmt 3 dp1 ^ "} = "
                ^ fmt 4 rh1 ^ "\n")

val () = print "\nHumidity ratio at sea-level pressure:\n"
val w1 = P.humidityRatio {tC = 25.0, rh = 0.5, pressurePa = 101325.0}
val () = print ("  humidityRatio {tC=25.0, rh=0.5, pressurePa=101325.0} = "
                ^ fmt 6 w1 ^ " kg/kg\n")

val () = print "\nWet-bulb temperature (Sprung equation, bisection):\n"
val wb1 = P.wetBulb {tC = 30.0, rh = 0.5, pressurePa = 101325.0}
val () = print ("  wetBulb {tC=30.0, rh=0.5, pressurePa=101325.0} = "
                ^ fmt 2 wb1 ^ " C\n")

val () = print "\nMoist-air enthalpy:\n"
val h1 = P.enthalpyMoist {tC = 25.0, w = w1}
val () = print ("  enthalpyMoist {tC=25.0, w=" ^ fmt 6 w1 ^ "} = "
                ^ fmt 3 h1 ^ " kJ/kg\n")
