; Configuration file for Kossel Zargony

; Communication and general
M111 S0                             ; Debug off
M550 Pkossel		        		; Machine name (can be anything you like)
M551 Preprap                        ; Machine password (used for FTP)
M540 P0xBE:0xEF:0xDE:0xAD:0xFE:0xED ; MAC Address
M552 P0.0.0.0						; IP address (0 = use DHCP)
M554 P192.168.0.254                 ; Gateway
M553 P255.255.255.0                 ; Netmask
M555 P2                             ; Set output to look like Marlin
M575 P1 B57600 S1                   ; Set auxiliary serial port baud rate and require checksum (for PanelDue)

; Axis and motor configuration
M569 P0 S1							; Drive 0 goes forwards
M569 P1 S1							; Drive 1 goes forwards
M569 P2 S1							; Drive 2 goes forwards
M569 P3 S0							; Drive 3 goes backwards
M569 P4 S0							; Drive 4 goes backwards
M574 X2 Y2 Z2 P1					; set endstop configuration (all endstops at high end, active high)

M665 L241.987 R124.272 H258.651 B80 X-0.476 Y0.827 Z0	; set delta radius, diagonal rod length, printable radius, homed height and XY tower corrections
M666 X0.75 Y0.13 Z-0.88				; put your endstop adjustments here, or use auto calibration to find them
M92 X160 Y160 Z160					; Set axis steps/mm (20 tooth pulleys, 0.9deg/step motors)
M906 X1000 Y1000 Z1000 E1300 I60	; Set motor currents (mA) and increase idle current to 60%
M201 X3000 Y3000 Z3000 E1000		; Accelerations (mm/s^2)
M203 X18000 Y18000 Z18000 E3600		; Maximum speeds (mm/min)
M566 X600 Y600 Z600 E600			; Maximum instant speed changes
G21                                 ; Work in millimetres
G90                                 ; Send absolute coordinates...
M83                                 ; ...but relative extruder moves

; Thermistors and heaters
M305 P0 T100000 B3950 R4700 H30 L-500	; Put your own H and/or L values here to set the bed thermistor ADC correction.
M305 P1 T100000 B4267 R4700 H-3 L-150	; E3Dv6 hot end. Put your own H and/or L values here if necessary to set the first nozzle thermistor ADC correction.
M301 H0 P20 I0.5 D1000 T0.85 W150 B5 ; PID settings for the bed
M301 H1 P10 I0.10 D100 T0.50		; PID settings for extruder 0
M570 S200							; Allow extra heating time

; Tool definitions
M563 P0 D0 H1                       ; Define tool 0
G10 P0 S0 R0                        ; Set tool 0 operating and standby temperatures
M92 E193	                       	; Set extruder steps per mm for first and second extruders

; Z probe and compensation definition
M558 P1 X0 Y0 Z0 H3 F300 T9000		; Z probe is IR and is not used for homing any axes, Z probe dive height 3mm, probing speed 300mm/min, travel speed 9000mm/min
G31 X-13.5 Y-2.0 Z0.690 P500		; Set the zprobe offset and threshold (put your own values here). For a delta, use zero X and Y offset.

;*** If you are using axis compensation, put the figures in the following command
M556 S78 X0 Y0 Z0                   ; Axis compensation here

M207 S4.5 F3600 Z1.0				; Set firmware retraction details
M572 D0 S0.1						; set pressure advance

T0									; select first print head
