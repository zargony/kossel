; Configuration file for Kossel Zargony

; Communication and general
M111 S0                             ; Debug off
M550 Pkossel			        	; Machine name and Netbios name (can be anything you like)
M551 Preprap                        ; Machine password (used for FTP)
M540 P0xBE:0xEF:0xDE:0xAD:0xFE:0xED ; MAC Address
M552 P0.0.0.0						; IP address (0 = use DHCP)
M554 P192.168.1.1                   ; Gateway
M553 P255.255.255.0                 ; Netmask
M555 P2                             ; Set output to look like Marlin
M575 P1 B57600 S1					; Comms parameters for PanelDue

G21                                 ; Work in millimetres
G90                                 ; Send absolute coordinates...
M83                                 ; ...but relative extruder moves

; Axis and motor configuration
M569 P0 S1							; Drive 0 goes forwards
M569 P1 S1							; Drive 1 goes forwards
M569 P2 S1							; Drive 2 goes forwards
M569 P3 S0							; Drive 3 goes backwards
M569 P4 S0							; Drive 4 goes backwards
M574 X2 Y2 Z2 S1					; set endstop configuration (all endstops at high end, active high)
M665 L241.987 R124.272 H258.651 B80 X-0.476 Y0.827 Z0	; set delta radius, diagonal rod length, printable radius, homed height and XY tower corrections
M666 X0.75 Y0.13 Z-0.88				; put your endstop adjustments here, or let auto calibration find them
M92 X160 Y160 Z160					; Set axis steps/mm
M906 X1000 Y1000 Z1000 E1300 I60	; Set motor currents (mA) and increase idle current to 60%
M201 X2000 Y2000 Z2000 E1000		; Accelerations (mm/s^2)
M203 X20000 Y20000 Z20000 E3600		; Maximum speeds (mm/min)
M566 X1200 Y1200 Z1200 E1200		; Maximum instant speed changes mm/minute

; Thermistors
M305 P0 T100000 B3950 R4700 H30 L-500	; Put your own H and/or L values here to set the bed thermistor ADC correction
M305 P1 T100000 B4267 R4700 H-3 L-150	; Put your own H and/or L values here to set the first nozzle thermistor ADC correction
M570 S180							; Hot end may be a little slow to heat up so allow it 180 seconds

; Heating/PID settings
M307 H0 A95.2 C516.7 D0.5 S1.00 B0	; heating process parameters for bed
M307 H1 A582.3 C149.9 D3.5 S1.00 B0	; heating process parameters for extruder 0

; Tool definitions
M563 P0 D0 H1                       ; Define tool 0
G10 P0 S0 R0                        ; Set tool 0 operating and standby temperatures
M92 E193                           	; Set extruder steps per mm

; Z probe and compensation definition
M558 P1 X0 Y0 Z0 H3 F200 T9000		; Z probe is a switch and is not used for homing any axes
G31 X-13.5 Y-2.0 Z0.539 P500		; Set the zprobe height and threshold (put your own values here)

;*** If you are using axis compensation, put the figures in the following command
M556 S78 X0 Y0 Z0                   ; Axis compensation here

M207 S4.5 F3600 Z0.5				; Set firmware retraction details
M572 D0 S0.1						; set pressure advance

M208 S1 Z-0.2						; set minimum Z
;
T0									; select first hot end
