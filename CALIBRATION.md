# IR probe calibration

#### Prerequisites:
- Endstops heights are approximately equal (measure from top of motor brackets using digital calipers)
- Nozzle and bed heated up

#### Calibration
- Home printer with `G28`
- Decrease Z until nozzle slightly touches a small object of known thickness (e.g. paper or a thickness gauge)
- Set current coordinates to known position with `G92 Z0.1` (for a .1mm sheet)
- Move up nozzle by 5mm with `G0 Z5`
- Measure probe trigger with `G30 S-1`
- The reported Z is the probe's Z offset (height difference between probe trigger height and nozzle tip) and should be used for the G31 configuration in config.g. The height offset should be in the range 1.0 to 2.0 mm for a differential IR probe.

# Bed calibration

#### Prerequisites
- Printer height is approximately set (autocalibration might drive the nozzle into the bed if the height is much too high since it starts by moving down without measuring)

#### Calibration
- Autocalibrate with `G32`
- Note `M665` and `M666` values
- Repeat autocalibration until values converge
- Store values for `M665` and `M666` to config.g
