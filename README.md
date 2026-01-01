# RTL433 US Edition - Home Assistant Add-on

## Fair Warning!

* **I'm not a developer. I don't know what I'm doing. I have been left alone without adult supervision. These are not my pants.** This repo is subject to random breaking changes as I tinker and learn. The documentation below may be right or blatantly wrong at any given time. I don't suggest you use this repo unless you are OK with that.  Are ya feeling *lucky*?

## Overview

This Home Assistant add-on integrates **rtl_433** with a focus on US frequencies (433 MHz and 915 MHz). It is built specifically for the **RTL-SDR Blog V4** dongle and publishes decoded data to MQTT in key-value format for easy use in Home Assistant. Supports single or dual dongles for simultaneous listening on both frequencies.

## Current Status

- Full support for RTL-SDR Blog V4 (R828D tuner detection, proper 915 MHz operation).
- Reliable operation through powered USB hubs (tested on Raspberry Pi with Genesys Logic hub).
- Configurable for one or two dongles, each assigned to a specific frequency (433 MHz or 915 MHz).
- Dongle assignment via USB index (e.g., "0", "1") or custom serial number (e.g., "00000433").
- Uses custom librtlsdr from rtlsdrblog fork with kernel driver detach enabled.
- USB access via broad `/dev/bus/usb` passthrough plus `"usb": true` in config.json for HAOS permission handling.
- Publishes to MQTT sub-topics like `rtl_433/<freq>mhz/devices/<model>/<channel>/<id>/<field>` for compatibility with auto-discovery add-ons.

## Requirements

- Home Assistant with Supervisor.
- RTL-SDR Blog V4 dongle(s) (recommended; other dongles untested).
- Powered USB hub recommended for stable operation on Raspberry Pi hosts.
- MQTT broker (e.g., core-mosquitto).
- For dual dongles: Separate antennas tuned to 433 MHz and 915 MHz.

## Installation

1. Add repository: https://github.com/jb9485/hass-rtl433-us
2. Install "RTL_433 US" add-on.
3. Configure MQTT host/port/user/pass.
4. Set `frequency` and `device` for the primary dongle (e.g., frequency=915, device="0").
5. For dual dongles, set `second_frequency` and `second_device` (e.g., second_frequency=433, second_device="1").
6. Start the add-on.

## Configuring Dongles for Reliability

For stable dongle assignment (especially if USB enumeration changes on reboot):
- Use a separate Linux machine to set unique serial numbers with `rtl_eeprom` (part of `rtl-sdr` package).
- Install `rtl-sdr`: `sudo apt install rtl-sdr`.
- Plug in one dongle, run `rtl_eeprom -d 0 -s 00000915` for 915 MHz dongle (adjust index if needed).
- Unplug/replug, repeat for 433 MHz dongle: `rtl_eeprom -d 0 -s 00000433`.
- In add-on config, use serials instead of indices (e.g., device="00000915").

## Troubleshooting

- If "usb_open error -1" appears, ensure the dongle is on a powered hub and reboot the host.
- Check host `lsusb` for device visibility (ID 0bda:2838).
- Logs will show "Detached kernel driver" and tuner detection on success.
- For no data: Ensure protocols are decoded (add `-R 0` for all in run.sh if testing).
- Entities in HA "unknown": Ensure auto-discovery add-on is running and configured to match topics.

## Credits

- rtl_433 by merbanan
- librtlsdr modifications from rtlsdrblog
- Maintained by jb9485

Last updated: December 31, 2025