# sml-psychro

[![CI](https://github.com/sjqtentacles/sml-psychro/actions/workflows/ci.yml/badge.svg)](https://github.com/sjqtentacles/sml-psychro/actions/workflows/ci.yml)

Zero-dependency Standard ML library for **psychrometric calculations**: saturation vapor pressure, dew point, humidity ratio, wet-bulb temperature (Sprung formula), and moist-air enthalpy.

## API

```sml
signature PSYCHRO =
sig
  val satVaporPressure : real -> real                              (* tC -> Pa *)
  val rhToDewPoint     : {tC:real, rh:real} -> real               (* rh 0..1 -> dew pt C *)
  val dewPointToRh     : {tC:real, dewC:real} -> real             (* -> rh 0..1 *)
  val humidityRatio    : {tC:real, rh:real, pressurePa:real} -> real (* kg/kg *)
  val wetBulb          : {tC:real, rh:real, pressurePa:real} -> real (* C *)
  val enthalpyMoist    : {tC:real, w:real} -> real                 (* kJ/kg_dry *)
end
```

## Example

```sml
val svp  = Psychro.satVaporPressure 20.0    (* ~2339 Pa *)
val dp   = Psychro.rhToDewPoint {tC=20.0, rh=0.5}   (* ~9.27 C *)
val wb   = Psychro.wetBulb {tC=30.0, rh=0.5, pressurePa=101325.0}  (* ~22 C *)
val h    = Psychro.enthalpyMoist {tC=25.0, w=0.01}  (* ~50.6 kJ/kg *)
```

`make example` builds and runs [`examples/demo.sml`](examples/demo.sml), which
exercises all six functions above -- saturation vapor pressure over a range of
dry-bulb temperatures, a dew-point/relative-humidity round trip, humidity
ratio, wet-bulb temperature, and moist-air enthalpy (output is byte-identical
under MLton and Poly/ML):

```
Saturation vapor pressure (Magnus formula):
  satVaporPressure(0.0C) = 611.20 Pa
  satVaporPressure(20.0C) = 2332.60 Pa
  satVaporPressure(30.0C) = 4233.72 Pa
  satVaporPressure(100.0C) = 103844.92 Pa

Dew point from relative humidity:
  rhToDewPoint {tC=20.0, rh=0.5} = 9.255 C

Relative humidity from dew point (round-trip check):
  dewPointToRh {tC=20.0, dewC=9.255} = 0.5000

Humidity ratio at sea-level pressure:
  humidityRatio {tC=25.0, rh=0.5, pressurePa=101325.0} = 0.009853 kg/kg

Wet-bulb temperature (Sprung equation, bisection):
  wetBulb {tC=30.0, rh=0.5, pressurePa=101325.0} = 23.18 C

Moist-air enthalpy:
  enthalpyMoist {tC=25.0, w=0.009853} = 50.250 kJ/kg
```

## Scope and limitations

- Saturation vapor pressure uses the **Magnus formula** (accurate to ~0.1% for 0..60 °C; ~2% error near 100 °C).
- Wet-bulb uses the **Sprung psychrometric equation** with bisection between dew point and dry-bulb.
- All relative-humidity inputs are in the range **0..1**.
- Enthalpy uses the standard linear approximation (ASHRAE).
- No ice-bulb or below-freezing corrections.

## Build and test

```
make all-tests   # MLton + Poly/ML
make test        # MLton only
make test-poly   # Poly/ML only
```
