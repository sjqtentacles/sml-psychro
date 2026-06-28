signature PSYCHRO =
sig
  (* Saturation vapor pressure in Pa, given dry-bulb temp in Celsius (Magnus formula) *)
  val satVaporPressure : real -> real

  (* Relative humidity (0..1) -> dew point in Celsius *)
  val rhToDewPoint : {tC:real, rh:real} -> real

  (* Dew point in Celsius -> relative humidity (0..1) *)
  val dewPointToRh : {tC:real, dewC:real} -> real

  (* Humidity ratio (kg_water/kg_dry_air): tC=dry bulb, rh=0..1, pressurePa *)
  val humidityRatio : {tC:real, rh:real, pressurePa:real} -> real

  (* Wet-bulb temperature (Celsius) by iteration/bisection.
     tC=dry bulb, rh=relative humidity 0..1, pressurePa=total pressure *)
  val wetBulb : {tC:real, rh:real, pressurePa:real} -> real

  (* Enthalpy of moist air (kJ/kg_dry_air): tC=dry bulb, w=humidity ratio *)
  val enthalpyMoist : {tC:real, w:real} -> real
end
