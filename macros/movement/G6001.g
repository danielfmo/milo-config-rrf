; G6001.g
; Probe a corner in X and Y by detecting Z and then moving out
; by a given distance to probe the corner from X and Y.
; Allow WCS Zero to be set on given
; corner.
;
; USAGE: "G6001"
;
; NOTE: MUST be used with a negative Z (so 0 to -<n> rather than 0 to <n>)

G27      ; park spindle away from work piece so we know we're
         ; starting from a safe location.

; Variables used to store user inputs.
var probeCorner     = null
var probeDistanceZ  = null
var probeDistanceXY = null
var zeroWCS         = null
var toolDiameter    = 0    ; Only used if featureTouchProbe == false

; Prompt user to place the touch probe over the work piece
; Allow the user to pick the corner that we're probing
M291 P"Select corner to probe" R"Corner to probe" S4 T0 J1 K{global.originCorners}
if input != null
    set var.probeCorner = input

; Prompt user for a probe depth for edges
M291 P"Select probe depth from material surface when probing edges" R"Probe depth" S4 T0 J1 K{"-2mm","-4mm","-6mm","-8mm","-10mm"}
if input != null
    set var.probeDistanceZ = { (input + 1) * 2 }

; Prompt user for how far outwards to move from their chosen
; position before moving inwards to probe corner edges.
M291 P"Select how far to probe towards each edge of the corner" R"Corner probing distance" S4 T0 J1 K{"5mm","10mm","15mm","20mm","25mm","30mm"}
if input != null
    set var.probeDistanceXY = { (input + 1) * 5 }

if { !exists(param.W) }
    ; Prompt user for WCS index to zero
    M291 P"Select WCS to set X=0, Y=0, Z=0 on" R"WCS to zero" S4 T0 J1 K{global.wcsNames}
    if input != null
        ; Add 1 to the selection because we get a zero-indexed number
        set var.zeroWCS = { (input+1) }
else
    set var.zeroWCS = param.W

if { !global.featureTouchProbe }
    ; If user does not have touch probe, prompt for tool diameter
    M291 P"Enter tool diameter in mm" R"Tool Diameter" S6 T0 L0.5 H100 J1 
    if input != null
        set var.toolDiameter = input

if { var.probeCorner != null && var.probeDistanceXY != null && var.probeDistanceZ != null && var.zeroWCS != null }
    ; Call macro with arguments
    G6001.1 C{var.probeCorner} D{var.probeDistanceXY} I{var.probeDistanceZ} R{var.toolDiameter/2} W{var.zeroWCS} 