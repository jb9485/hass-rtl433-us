# RTL433 US Edition (V4 + Multi-Dongle + Hopping)

The only rtl_433 add-on that **actually works** on multiple frequencies in the US with RTL-SDR Blog V4.

### Features
- Full RTL-SDR Blog V4 support (PPM correction, high sample rates)
- 915 MHz native (no more 250 kHz lock!)
- User select between 433 & 915 MHz
- Multiple dongles (one per band)
- Direct MQTT publishing (kv format)
- Mosquito MQTT broker ready


### Setup
1. Add repository: `https://github.com/jb9485/hass-rtl433-us`
2. Install "RTL433 US Edition"
3. Configure devices & MQTT
4. Start → watch `rtl_433/#` in MQTT Explorer

### Example: 915 MHz + 433 MHz Hopping

