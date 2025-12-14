# RTL433 US Edition - Home Assistant Add-on

## Fair Warning!
- **I'm not a developer.  I don't know what I'm doing.  I have been left alone without adult supervision.  These are not my pants.**  This repo is subject to random breaking changes as I tinker and learn.  The documenation below may be right or blatently wrong at any given time. I don't suggest you use this repo unless you are OK with that.

## Overview

This Home Assistant add-on integrates **RTL_433**, a widely-used tool for decoding and capturing signals from various wireless devices, with a focus on **US-specific frequency bands**. It is optimized for the **RTL-SDR Blog V4** hardware dongle and supports both **433 MHz** and **915 MHz** operations. This add-on enables seamless reception (when it works) of signals from weather sensors, remote controls, doorbells, and other IoT devices commonly used in the US market.

The add-on publishes decoded data directly to an **MQTT broker** in **key-value (kv) format**, making it easy to integrate with Home Assistant's MQTT integration for automated sensor entities and automations.

### Key Features
- **Full RTL-SDR Blog V4 Support**: Includes PPM (parts per million) correction for accurate tuning and high sample rates for better signal capture.
- **Native 915 MHz Reception**: Bypasses the common 250 kHz lockout issue on standard RTL-SDR devices.
- **User-Selectable Frequencies**: Choose between 433 MHz or 915 MHz, or configure for both.
- **Multi-Dongle Support**: Use multiple RTL-SDR dongles (one per frequency band) for simultaneous monitoring.
- **Direct MQTT Publishing**: Outputs data to the `rtl_433/#` topic in a structured key-value format compatible with Home Assistant.
- **Mosquitto Broker Compatibility**: Works out-of-the-box with Home Assistant's built-in MQTT broker.
- **Frequency Hopping Example**: Supports configurations for scanning both 433 MHz and 915 MHz (e.g., using multiple dongles).

This add-on is particularly useful for US users dealing with FCC-regulated frequencies, ensuring reliable performance without the need for custom hardware modifications.  At least in theory.

## Requirements
- **Home Assistant**: Version 2023.6 or later (with Supervisor for add-on management).
- **Hardware**: RTL-SDR Blog V4 dongle (recommended; other RTL-SDR v3+ devices may work with reduced features. Or they may run amok in your fridge and spoil all your milk.  I don't have one to test and be sure.).
- **MQTT Integration**: Enabled in Home Assistant with a running broker (e.g., Mosquitto add-on).
- **USB Access**: Ensure your Home Assistant host (e.g., HAOS on Raspberry Pi) has USB passthrough enabled for the RTL-SDR dongle.

## Installation

1. **Add the Repository**:
   - Navigate to **Settings > Add-ons > Add-on Store** in your Home Assistant interface.
   - Click the three dots (⋮) in the top-right corner and select **Repositories**.
   - Add the following repository URL:  
     `https://github.com/jb9485/hass-rtl433-us`

2. **Install the Add-on**:
   - Search for and select the **"RTL433 US Edition"** add-on from the store.
   - Click **Install**. The add-on will download and prepare.

3. **Configure the Add-on**:
   - Open the add-on's **Configuration** tab.
   - Set your MQTT broker details (host, port, username, password).
   - Select your desired frequency (433 MHz or 915 MHz).
   - If using multiple dongles, specify device paths (e.g., `/dev/ttyUSB0`).
   - Optional: Enable logging verbosity or custom RTL_433 flags for advanced tuning.
   - Example basic configuration (YAML):
     ```yaml
     mqtt:
       host: core-mosquitto  # Or your broker's IP
       port: 1883
       user: mqtt_user
       pass: mqtt_pass
     frequency: 915  # MHz (or 433)
     dongles:
       - device: /dev/bus/usb/001/002  # USB path for dongle 1
         ppm: 0  # PPM correction (auto-detected if 0)
     ```

4. **Start the Add-on**:
   - Click **Start** in the **Info** tab.
   - Check the **Log** tab for any errors (e.g., dongle detection issues).

5. **Verify MQTT Output**:
   - Use **MQTT Explorer** (a free desktop tool) or Home Assistant's MQTT integration to subscribe to `rtl_433/#`.
   - Trigger a supported device (e.g., a 915 MHz weather sensor) and observe incoming messages.

## Usage

### Integrating with Home Assistant
1. **Enable MQTT Sensors**:
   - In Home Assistant, go to **Settings > Devices & Services > MQTT**.
   - Auto-discover entities or manually add sensors via YAML configuration.
   - Example sensor for a temperature device:
     ```yaml
     mqtt:
       sensor:
         - name: "Outdoor Temperature"
           state_topic: "rtl_433/devices/thermo"
           value_template: "{{ value_json.temperature_C }}"
           unit_of_measurement: "°C"
           device_class: temperature
     ```

2. **Supported Devices**:
   - RTL_433 supports hundreds of devices out-of-the-box (e.g., Acurite, Oregon Scientific, Honeywell).
   - Check the [RTL_433 device support list](https://github.com/merbanan/rtl_433/blob/master/README.md#supported-devices) for compatibility.
   - US-focused: Prioritizes 433 MHz and 915 MHz devices common in North America.
   - I only have the RTL SDR V4, others should work but they at 100% untested.

3. **Advanced Configurations**:
   - **Multi-Frequency Hopping**: Use two dongles—one for 433 MHz and one for 915 MHz. Example config:
     ```yaml
     dongles:
       - device: /dev/bus/usb/001/002
         frequency: 915
       - device: /dev/bus/usb/001/003
         frequency: 433
     ```
   - **Custom RTL_433 Flags**: Add flags like `-R 0 -R 1` to enable/disable specific decoders in the add-on config.
   - **PPM Calibration**: Run `rtl_test` on your host to determine PPM offset, then apply it in the config.

### Troubleshooting
- **No Data Received**: Verify dongle connection with `lsusb` on the host. Ensure no other processes (e.g., other SDR software) are using the device.
- **Frequency Lock Issues**: Stick to RTL-SDR V4 for 915 MHz; older dongles may require software tweaks.
- **MQTT Connection Errors**: Double-check broker credentials and network access.
- **High CPU Usage**: Reduce sample rate in config or limit active decoders.
- **Logs**: Enable debug mode in the add-on for verbose RTL_433 output.

For common issues, refer to the [RTL_433 GitHub issues](https://github.com/merbanan/rtl_433/issues) or open a new issue in this repo.

## Contributing
This add-on is open-source! Contributions are welcome:
- Fork the repo and submit pull requests for bug fixes, new features, or device support.
- Report issues via GitHub Issues.
- Test on your hardware and share configs.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details (if not present, it inherits from upstream RTL_433).

## Credits
- Built on [RTL_433](https://github.com/merbanan/rtl_433) by merbanan.
- Home Assistant add-on framework.
- Maintained by [jb9485](https://github.com/jb9485).


---

*Last Updated: December 13, 2025*  
For the latest changes, check the [repository commits](https://github.com/jb9485/hass-rtl433-us/commits/main). If you encounter issues, ensure your setup matches the current version.