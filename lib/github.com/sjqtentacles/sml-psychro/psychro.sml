structure Psychro :> PSYCHRO =
struct
  (* Magnus formula: saturation vapor pressure in hPa *)
  fun satVaporPressureHPa tC =
    6.112 * Math.exp (17.62 * tC / (243.12 + tC))

  fun satVaporPressure tC = satVaporPressureHPa tC * 100.0

  fun rhToDewPoint {tC, rh} =
    let val gamma = Math.ln (rh * satVaporPressureHPa tC / 6.112)
    in 243.12 * gamma / (17.62 - gamma) end

  fun dewPointToRh {tC, dewC} =
    satVaporPressure dewC / satVaporPressure tC

  fun humidityRatio {tC, rh, pressurePa} =
    let val e = rh * satVaporPressure tC
    in 0.622 * e / (pressurePa - e) end

  fun satHumidityRatio tC pressurePa =
    let val es = satVaporPressure tC
    in 0.622 * es / (pressurePa - es) end

  (* Sprung psychrometric equation: wet-bulb bisection *)
  fun wetBulb {tC, rh, pressurePa} =
    let
      val wActual = humidityRatio {tC = tC, rh = rh, pressurePa = pressurePa}
      fun f wb =
        satHumidityRatio wb pressurePa
        - 6.6e~4 * (1.0 + 0.00115 * wb) * (tC - wb)
        - wActual
      fun bisect lo hi =
        if hi - lo < 0.001 then (lo + hi) / 2.0
        else let val mid = (lo + hi) / 2.0
             in if f lo * f mid <= 0.0 then bisect lo mid
                else bisect mid hi end
      val dp = rhToDewPoint {tC = tC, rh = rh}
    in bisect dp tC end

  fun enthalpyMoist {tC, w} =
    1.006 * tC + w * (2501.0 + 1.86 * tC)
end
