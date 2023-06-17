; Probe the current tool length and save its' offset.
; We calculate the offset based on the height of the
; toolsetter, and its' offset to the material surface
; we're working with.

; NOTE: This is designed to work with a NEGATIVE Z - that is, MAX is 0 and MIN is -<something>

M5       ; stop spindle just in case

G21      ; Switch to mm

G27 C1   ; park spindle

; Variables used to store tool position references.
var actualToolZ     = 0 ; Actual Z co-ordinate probed with tool

; Reset tool Z offset
G10 P{state.currentTool} Z0

if global.probeConfirmMove
    M291 P{"Move to X=" ^ global.toolSetterX ^ ", Y=" ^ global.toolSetterY ^ then probe X=" ^ param.D ^ "?"} R"Safety check" S3

M118 P0 L2 S{"Probing tool length at X=" ^ global.toolSetterX ^ ", Y=" ^ global.toolSetterY }

; Probe tool length multiple times and average
; Allow operator to jog tool over bolt after rough probing move to confirm
; lowest tool point.
G6003 X{global.toolSetterX} Y{global.toolSetterY} S{global.zMax} B{global.toolSetterDistanceZ} J1 K1 C{global.toolSetterNumProbes} A{global.toolSetterProbeSpeed}

; Park.
G27 C1

; Our tool offset is the difference between our expected tool Z and our actual
; tool Z. Expected tool Z is calculated during G6000 by probing the reference
; surface and then adding the offset of the toolsetter to it.
set var.actualToolZ = global.probeCoordinateZ
set var.toolOffset = var.actualToolZ - global.expectedToolZ
M118 P0 L2 S{"Expected Tool Z =" ^ global.expectedToolZ ^ ", Actual Tool Z=" ^ var.actualToolZ ^ " Tool Offset = " ^ var.toolOffset }

G10 P{state.currentTool} X0 Y0 Z{var.toolOffset} 



