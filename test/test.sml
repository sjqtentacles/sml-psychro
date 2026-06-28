structure Tests =
struct
  open Harness
  fun close name (e, a, eps) = check name (Real.abs (e - a) <= eps)

  fun run () =
  let
    val () = section "saturation vapor pressure"
    val () = close "sat 20C ~2339 Pa"    (2339.0,   Psychro.satVaporPressure 20.0,  10.0)
    (* Magnus formula has ~2% error at 100C; actual = 101325 Pa, formula gives ~103500 Pa *)
    val () = close "sat 100C ~101325 Pa" (101325.0, Psychro.satVaporPressure 100.0, 3000.0)

    val () = section "rh <-> dew point"
    val dp = Psychro.rhToDewPoint {tC = 20.0, rh = 1.0}
    val () = close "RH=100% dewpoint=tC" (20.0, dp, 0.05)
    val rh2 = Psychro.dewPointToRh {tC = 20.0, dewC = dp}
    val () = close "dewPointToRh round-trip" (1.0, rh2, 0.01)

    val () = section "humidity ratio"
    val w = Psychro.humidityRatio {tC = 20.0, rh = 0.5, pressurePa = 101325.0}
    val () = check "humidity ratio > 0" (w > 0.0)
    val () = check "humidity ratio finite" (Real.isFinite w)

    val () = section "wet bulb"
    val wb = Psychro.wetBulb {tC = 30.0, rh = 0.5, pressurePa = 101325.0}
    val () = close "wet bulb 30C/50% ~22C" (22.0, wb, 2.0)
    val () = check "wet bulb <= dry bulb" (wb <= 30.0)
    val () = check "wet bulb finite" (Real.isFinite wb)

    val () = section "moist enthalpy"
    val h = Psychro.enthalpyMoist {tC = 25.0, w = 0.01}
    val () = close "enthalpy 25C w=0.01" (50.6, h, 0.5)

  in Harness.run () end
end
