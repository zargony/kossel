; Auto calibration routine for delta printers
; Before running this, you should have set up your zprobe Z offset to suit your build, in the G31 command in config.g.

M561						; clear any bed transform, otherwise homing may be at the wrong height
G31 X0 Y0					; don't want any probe offset for this
G28							; home the printer

G1 X0 Y80 Z10 F9000		; go to just above the first probe point to speed up probing

; Probe the bed and do 6- or 7-factor auto calibration
G30 P0 X0 Y80 Z-99999 H0
G30 P1 X-69.3 Y40 Z-99999 H0
G30 P2 X-69.3 Y-40 Z-99999 H0
G30 P3 X0 Y-80 Z-99999 H0
G30 P4 X69.3 Y-40 Z-99999 H0
G30 P5 X69.3 Y40 Z-99999 H0
G30 P6 X0 Y41.5 Z-99999 H0
G30 P7 X-35.9 Y20.8 Z-99999 H0
G30 P8 X-35.9 Y-20.8 Z-99999 H0
G30 P9 X0 Y-41.5 Z-99999 H0
G30 P10 X35.9 Y-20.8 Z-99999 H0
G30 P11 X35.9 Y20.8 Z-99999 H0
G30 P12 X0 Y0 Z-99999 H0 S6

; Define grid for measuring bed heightmap with G29 if desired (measure circle with radius 80mm in steps of 20mm)
M557 R80 S20
;G29

G1 X0 Y0 Z150 F9000			; get the head out of the way of the bed
