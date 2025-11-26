# RTL433 US Edition (V4 + Multi-Dongle + Hopping)

The only rtl_433 add-on that **actually works** in the US with RTL-SDR Blog V4.

### Features
- Full RTL-SDR Blog V4 support (PPM correction, high sample rates)
- 915 MHz native (no more 250 kHz lock!)
- Hopping between 433 & 915 MHz (sub-second)
- Multiple dongles (one per band)
- Direct MQTT publishing (kv format)
- Home Assistant MQTT discovery ready
- No deprecated code. No ignored config. No excuses.

### Setup
1. Add repository: `https://github.com/yourusername/hass-rtl433-us`
2. Install "RTL433 US Edition"
3. Configure devices & MQTT
4. Start → watch `rtl_433/#` in MQTT Explorer

### Example: 915 MHz + 433 MHz Hopping
```yaml
devices:
  - frequency: 915000000
    sample_rate: 1000000
    gain: 45
    ppm: 70
    label: "US 915 MHz"
  - frequency: 433920000
    sample_rate: 250000
    gain: 40
    label: "EU 433 MHz"
hop_interval: 0.8
