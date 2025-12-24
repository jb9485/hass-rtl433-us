# RTL433 US Edition - Home Assistant Add-on

## Fair Warning!

* **I'm not a developer. I don't know what I'm doing. I have been left alone without adult supervision. These are not my pants.** This repo is subject to random breaking changes as I tinker and learn. The documentation below may be right or blatantly wrong at any given time. I don't suggest you use this repo unless you are OK with that.

## Overview

This Home Assistant add-on integrates **rtl_433** with a focus on US frequencies (433 MHz and 915 MHz). It is built specifically for the **RTL-SDR Blog V4** dongle and publishes decoded data to MQTT in key-value format for easy use in Home Assistant.

## Current Status

- Full support for RTL-SDR Blog V4 (R828D tuner detection, proper 915 MHz operation).
- Reliable operation through powered USB hubs (tested on Raspberry Pi with Genesys Logic hub).
- Single dongle configuration with user-selectable frequency (433 MHz or 915 MHz).
- Uses custom librtlsdr from rtlsdrblog fork with kernel driver detach enabled.
- USB access via broad `/dev/bus/usb` passthrough plus `"usb": true` in config.json for HAOS permission handling.

Multi-dongle and advanced options are not implemented in the current code.

## Requirements

- Home Assistant with Supervisor.
- RTL-SDR Blog V4 dongle (recommended; other dongles untested).
- Powered USB hub recommended for stable operation on Raspberry Pi hosts.
- MQTT broker (e.g., core-mosquitto).

## Installation

1. Add repository: https://github.com/jb9485/hass-rtl433-us
2. Install "RTL_433 US" add-on.
3. Configure MQTT host/port/user/pass.
4. Set frequency option to 433 or 915.
5. Start the add-on.

## Troubleshooting

- If "usb_open error -1" appears, ensure the dongle is on a powered hub and reboot the host.
- Check host `lsusb` for device visibility (ID 0bda:2838).
- Logs will show "Detached kernel driver" and tuner detection on success.

## Credits

- rtl_433 by merbanan
- librtlsdr modifications from rtlsdrblog
- Maintained by jb9485

Last updated: December 23, 2025