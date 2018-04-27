Boeing B738-800X

Installation:
-------------

Full version: (folder B737-800X)
---------------------------------------
1/ Delete old release (delete all folder "XPLANE11/Aircraft/Boeing B738-800X")
2/ Copy folder "B737-800X" to "XPLANE11/Aircraft/"
3/ Enjoy

Only update version: (B737-800X_v_vv.zip) - CLEAN INSTALL
----------------------------------------------------------
1/ Unzip file "B738X.zip"
2/ Copy folder "Boeing B738-800" from "XPLANE11/Aircraft/Laminar Research/" to folder "XPLANE11/Aircraft/"
3/ Rename folder "Boeing B738-800" in  "XPLANE11/Aircraft/" to "Boeing B738-800X"
4/ Copy all unziped files to your new renamed folder
5/ Enjoy


SYSTEMS:
- autopilot (LVL CHG, VNAV, LNAV, HDG, VOR LOC, APP-ILS, APP-RNAV, APP-LOC/VNAV, ALT HLD, VS, AUTOLAND)
- autothrottle (N1, SPEED, TAKEOFF, A/P GA, F/D GA)
- IRS system (OFF, ALIGN, NAV, ATT)
- anti-ice (engines and wings)
- air bleed (ENG1, ENG2, APU, LPACK, RPACK, ISOLATION VALVE)
- windows heat
- hydraulic pumps (hydro and electric pumps)
- fuel pumps (all fuel pumps working)
- autobrakes (RTO, 1, 2, 3, MAX)
- speedbrake system (after RTO and landing)
- engine starter (GRD, OFF, CNT, FLT)
- engines idle rpm logic N1 and N2 (ground, flight and approach mode)
- automatic crossover altitude
- gear leveler (down, up, off) with landing gear limit operating for default command "Landing gear toggle"
- apu start delay and shutdown after cooling
- yaw damper system

PFD and MCP:
- flaps and landing gear retract speed limits
- Vmo and Mmo speed limits
- minimal a maximal maneuver flaps speed limits
- speed bugs V1, VR, V2+20, VREF, 80kts, flaps UP-1-5-15
- annunciators flashing rectangle for engaged pitch, roll, speed and command modes 
- add annunciators ARM, N1, RETARD, FLARE, GA, THR HLD, TO/GA, ALT ACQ, VNAV PTH, VNAV ALT, SINGLE CH
- annunciators ALT disagree and SPD disagree
- flashing "8", if MCP speed dial is above flaps, landing gear or Vmo limits
- flashing "A", if MCP speed dial is under minimal maneuver flaps limit
- VNAV vertical path indicator

ND:
- TCAS system
- real size navaids, airport and waypoint
- course dashline for selected VORs
- course dashline for destination runway (if tuned ILS frequency)
- VNAV vertical path indicator
- calculate T/C, T/D, DECEL
- EFIS DATA for waypoints

EICAS:
- display lower unit (engine, systems)

FMC:
- own FMC (in development)

OTHERS:
- improved autobrakes and RTO brake forces
- improved landing and taxi lights brightness

FMOD SOUNDS by AudioBirdXP

SIM COCKPIT BUILDER
- list of custom commands (B738_Commands.txt)
- list of datarefs (B738_Datarefs.txt)
  A/P switches and lights, fuel pumps, engines and APU starter, air bleed, landing gear


Release note:
-------------
3.26b:
------
- improved and tuned autoland

3.26a:
------
- optimise code
- graphics correction on ND
- slightly improved autoland

3.26:
-----
- rewrite code for drawing on NDs
- fixed more bugs and typo bugs

3.259:
------
- fixed bugs
- tested with xplane 11.20b5

3.258:
------
- graphics corrections on ND
- fixed brakes, landing gear toggle,...

3.257:
------
- graphics correction on ND
- fixed small bugs

3.256:
------
- fixed bugs (FMC freeze)
- changed manipulators for VR

3.255:
------
- add ACARS - ATIS REQ for airport
- fixed small bugs (FMC freeze,...)

3.254:
------
- improved logic for change STAR/APP in flight
- improved logic for detect flight phase
- add code for Terrain plugin by DrGluck (for next update Terrain plugin)

3.253:
------
- fixed small bugs
- changed manipulators for Xplane 11.20b4

3.252:
------
- fixed bugs (VNAV descent, FO FMC ...)
- graphics correction

3.251:
-----
- First Officer FMC working
- add MAP CTR mode
- update xchecklist file modify by @curvian (thanks)
- fixed small bugs and graphic correction
Note: if you use terrain plugin by DrGluck, Terrain plugin will draw terrain correctly after update new version (I hope soon).

3.25z:
------
- graphic correction on both NDs

3.25y:
------
- tuned A/T code
- tuned A/P
- small graphics correction
- fixed bugs (holding pattern,...)

3.25x:
------
- tuned A/T code
- fixed small bugs and graphics correction on ND

3.25w:
------
- new tuned flight model by Twkster
- add Display Control Panel feature
- add option BARO UNITS (after load plane)
- fixed small bugs

3.25v:
------
- corrected systems
- fixed small bugs
- add flap 25 bug on PFD
- add nosewheel steer manipulator in cockpit for VR (set option NOSEWHEEL AXIS to VR)
- add command for smoothly brake ("laminar/B738/brake_smoothly" - "Brake smoothly"- don't forget set option TOE BRAKE AXIS to OFF)

3.25u:
------
- corrected systems
- fixed bugs

3.25t:
-------
- add AFS system
- add code for detect engine out
- corrected some systems
- fixed typo errors and bugs

3.25s:
------
- fixed holding pattern (I change LNAV code and I forget change code for HOLD)
- chock - changed feature CHOCK (in fmc). If you set CHOCK to OFF, then parking brake is set after load plane (if plane is on the ground, of course). If you set CHOCK to ON and set TURNAROUND state, then parking brake is set after load plane, otherwise chockk are set.
- new better A/T code

3.25r:
------
- improved autothrottle code

3.25q:
------
- add own autothrottle code (basic code - preview version)

3.25p:
------
- new code for control descent path
- fixed bug in calculate descent path


3.25o:
------
- add calculate descent path by wind
- fixed small bugs
- tested with xplane 11.20b3

3.25n:
------
- new VNAV descent path code
- fixed small bugs

3.25m:
------
Fixed typo bugs, graphics bugs and system correction:
- round fuel tank display: less spacing between big and small digit
- INVALID ENTRY not delete contents of scratchpad
- DEP airport not automatically copy to RTE page
- Chronometer needle changed to LCD segments
- fixed bug with VREF on FO PFD
- fixed FAULT/INOP switch (annunciates)
- fixed Cargo test switch (annunciates)
- fixed deviation info if tumed VOR
- fixed autoland

3.25l:
------
- fixed graphic bugs (Green arc, acf icon on FO ND,...)
- corrected some systems


3.25k:
------
- graphic correction on ND
- tuned gently autoland
- corrected some systems

3.25j:
------
- tuned flight model by Twkster (better landing stab, rudder pedal steering)
- add aircraft symbol to MAP mode (ND)
- fixed own database if default navdata are missing
- fixed small bugs (flaps bug on PFD, GW predict...)
Note: You need delete files B738X_apt.dat and B738X_rnw.dat (located in root B738X install folder).


3.25i:
------
- rewrited code for LNAV

3.25h:
------
- add predict fuel for T/C, T/D and E/D
- add predict gross weight on approach page

3.25g:
------
- add predict fuel (approximately, not finished yet)
- fixed small bugs

3.25f:
------
- add RTE DATA page


3.25e:
------
- fixed bugs in magnetic variation and accurate geo model

3.25d:
------
- fixed parking brake with Better Pushback plugin
- fixed decode CIFS

3.25c:
------
- gently tuned A/P and acf stability
- better access to fmod action menu
- fixed small bugs (brakes,...)


3.25b:
------
- fixed GPWS terrain inhibit
- LNAV correction
- graphics correction


3.25a: hot fix
------
- fixed issue for MacOS/Linux users

3.25:
-----
- add GPWS system with 5 modes and submodes
- add landing gear warning system (aural and visual)
- add 3D lights to cockpit and cabin
- add left and right wing passenger seats (VR - teleport hotspot)
- add manipulator for flightdeck door
- changed manipulator for Speedbrake
- finished RMI instrument
- improved LNAV code
- improved TAXI code
- tuned and tweaked AP
- tuned and tweaked flight model by Twkster
- small graphics and animation improvements (cockpit, cabin, flightdeckdoor, landing lights ...)
- renamed some MENU options, changed Fuel and CG page, add settings for null zone - pitch, roll, yaw
- fixed FMC EXEC lights
- fixed magnetic variation on ND for VOR selected
- fixed acceleration on the ground
- fixed handles above windshield - captain and f/o
- fixed bugs (time calculation T/C, T/D, E/D,.....)
- tested with xplane 11.11 and 11.20vr6

3.24z:
- add RMI

3.24y:
------
- add ADF
- fixed small bugs

3.24x:
------
- tuned and tweaked AP
- fixed bugs (climb with VNAV/LVL CHG,...)

3.24w:
------
- add map lights (captain and f/o)
- fixed small bugs (vor1/2 swap arrows,...)

3.24v:
------
- new flightmodel from twkster
- tuned and tweaked AP, autoland, VR,...
- fixed small bugs

3.24u:
------
- fixed flaps animation
- fixed freeze FMC (typo error)
- fixed small bugs

3.24t:
------
OTHERS
- improved steering code for taxi
- fixed AP for flightmodel tuned by twkster (LVL CHG, ALT HOLD, VNAV, AP constants)
- fixed small bugs

3.24s:
------
OTHERS
- improved steering code for taxi
- fixed small bugs (FMC switch page, load flightplan fms v11, compas light switch,...)

3.24r:
------
- fixed annunciates during autoland

3.24p:
------
- tuned AP constant for twkster flightmodel 4.0
- corrected fire test (engine, apu, cargo)
- corrected flight recorder test
- fix small bugs (decode CIFP,...)

3.24o: (beta)
------
- twkster flight model
- fixed some bugs (decode CIFP, windshield effect...)


3.24n: (beta)
------
- tweaked flight model by twkster (moded by me)
- improved thrust curve (for taxi thrust)
- correct function CHR button for reset chrono timer - hold 2 seconds
- fixed bugs

3.24m:
------
FMC
- fixed switch page CLB, CRZ, DES
OTHERS
- fixed typo errors (bug with cruise wind on PERF INIT page,...)

3.24l:
------
OTHERS
- improved and fixed LNAV code
- optimised code
- fixed small bugs

3.24k:
------
ND
- add heading bug in center mode
OTHERS
- improved code for clocks
- optimise code for airways
- autosafe config after unlaod airplane
- fixed small bugs

3.24j: hot fix
--------------
OTHERS
- fixed add SID/STAR/APP waypoints

3.24i:
------
OTHERS
- add flight recorder test
- add wing-body overheat test
- corrected state of switches after close guarded covers
- corrected switch alternate flaps (position UP is hold magnetic)
- fixed small bugs


3.24h:
------
OTHERS
- add calculate magnetic declination (variation) by WMM2015 geomagnetic model
- fixed freeze FMC for MacOS and Linux

3.24g:
------
OTHERS
- add support XEnviro 1.08 and above for windshield effect (see XTRAS/OTHERS/Windshield effects: ON/XE/OFF)
- add override lock gear lever

3.24f:
------
AP
- corrected ALT HOLD mode (new code)
OTHERS
- add detend for flaps leveler
- add horn cutout (animation only - prepared for gear warn horn)

3.24e:
------
OTHERS
- fixed switch from VNAV SPD to VNAV PATH
- fixed graphics bug for MCP vvi dial
- increased speed for MCP course knobs
- fixed anti-ice annunciates (six pack) when pitot heat off


3.24d:
------
FMC
- fixed issue with route for airway to airway
- add manual speed restrict for climb and descent page
OTHERS
- fixed small bugs (config warning issue,...)

3.24c:
------
OTHERS
- graphics correction for ND
- gently optimalised code
- fixed small bugs
- add working flight record switch

3.24b:
------
OTHERS
- optimalised code

3.24a:
------
OTHERS
- fixed Baro DA bug
- fixed graphics bug with IRS position on FMC
- optimise file for draw instruments in 3D cockpit

3.24:
-----
OTHERS
- improved LNAV (for sharp angle)
- corrected electric AC power (on instrument CPS freq and AC volts)
- add feature for CLR button (hold CLR erase entire scratchpad)
- add correction for fire test system
- improved FMC find navaid code
- other small correction (AP, cold&dark state for NDs...)

3.23y:
------
FMC
- add support SID, STAR, APP for fmx flight plan format (own B738X format)
VR
- changed manipulators for switches and knobs
OTHERS
- small improvments (add input for plan fuel, improved climb (CLB1, CLB2) thrust calculation,... )

3.23x:
------
OTHERS
- improved ND display code
- fixed bugs (typo errors)

3.23w:
------
AP
- fixed issue with LVL CHG for during climb
VR
- add manipulators for DH/DA
FMC
- add option ROLL for NOSEWHEEL AXIS (XTRAS/OTHERS, you can use it for taxi if you haven't pedals for steering with roll axis)

3.32v:
------
OTHERS
- improved code for entry SID, STAR, APP
- improved code for ND

3.23u:
------
FMC
- fixed bug with CLR button
- fixed minor bugs

3.23t:
------
FMC
- improved switch to next waypoint
- fixed bug with new cruise altitude
OTHERS
- fixed bug with GoAround

3.23s:
------
FMC
- fixed navigation for "great circle" to waypoint
VR
- improved AP knobs (speed, heading, altitude, courses)
- improved panel and instrument lighting knobs
- fixed some schwitches

3.23r:
------
FMOD
- add presets for fmod sound (load/save with/without name, max. 8 chars for name)
OTHERS
- improved AP constant
- fixed small bugs
- VR ready (with vr_config)

3.23q:
------
OTHERS
- add manipulator for both yokes
- fixed manipulator for throttle leveler
- changed manipulator for landing gear (with auto aretation)
- fixed minor bugs

3.23p:
------
FMC
- add along route waypoint
OTHERS
- tweaked windshield effect
- fixed minor bug

3.23o:
------
- fixed bug and tweaked windshield effect
- fixed initial windows temperature if it starts with engine running

3.23n:
------
- fixed bug and tweaked windshield effect

3.23m:
------
- fixed bug for windshield effect

3.23l:
OTHERS
- rewrite code for windshield effect
Note: Windshield effect default ON.

3.23k:
------
- rewrited some textures for windshield effect


3.23j:
------
OTHERS
- fixed small bugs

3.23i:
------
OTHERS
- fixed minor bugs


3.23h:
------
FMC
- add FIX page (still in progress)
OTHERS
- fixed minor bugs (VR/CR waypoint calculation, range OAT temp,...)


3.23g: quick update
------
FMC
- add import fms v11 flight plan (now support both fms flight plan v3 and v11 - detection automatically)

Note: You must enter reference and destination airport before import flight plan. Ref ICAO and Des ICAO must be the same as in imported flight plan.


3.23f:
------
OTHERS
- fixed and improved LNAV/VNAV
- add and improved code for check and load navdata


3.23e:
------
OTHERS
- fixed some bugs and corection systems

3.23d:
------
OTHERS
- fixed some bugs

3.23c: quick fix
------
OTHERS
- fixed DIRECT to waypoint
- fixed bugs in code (type errors)
- gently tweak AP

3.23b:
------
LNAV
-improved LNAV bank logic
OTHERS
- improved stability in high speed (swaying)
- fixed some bugs (SID-RW waypoints,...)


3.23a:
------
FMOD
- new item for new FMOD 1713-12-23 by AudioBirdXP
OTHERS
- some correction for systems (as real plane)
- fixed bugs (3D cockpit lights, alt restrict,...)
Tested in Xplane 11.11r2.

IMPORTANT for user running on Xplane 11.05
------------------------------------------
Use acf file in folder XPLANE_1105 for Xplane 11.05 (folder with file in package):
- copy file "b738.acf" from folder "XPLANE_1105" to folder "B737-800X" with option "overwrite"

3.23:
------
FMOD
- new menu and option for new FMOD 1713 by AudioBirdXP
OTHERS
- add new items to NDs
- some correction for systems (as real plane)
- fixed some bugs

IMPORTANT !!!
-------------
You need install FMOD 1713 by AudiobirdXP. This release not works correctly with old FMOD.


Installation B737-800X release 3.23
------------------------------------

Two methods installation:

A/ Full install
   1/ Delete folder "<xplane11 path>/Aircraft/B737-800X" (if you have installed previous release)
   2/ Download folder "B737-800X"
   3/ Copy downloaded folder "B737-800X" to folder "<xplane11 path>/Aircraft"
   4/ Download and install FMOD by AudiobirdXP (See Instalation notes in fmod package)
   5/ Install other stuff for B737-800X
   
B/ Incremental update (if you have installed previous release)
   1/ Delete folder "<xplane11 path>/Aircraft/B737-800X/plugins"
   2/ Delete folder "<xplane11 path>/Aircraft/B737-800X/fmod"
   3/ Download file "B737-800X_3_23.zip" and unzip
   4/ Copy all unziped folders and files to folder "<xplane11 path>/Aircraft" with option "overwrite files"
   5/ Download and install FMOD by AudiobirdXP (See Instalation notes in fmod package)
   6/ Install other stuff for B737-800X

C/ Enjoy



----------------------------------------------------------------------------------------------------------------------------


3.22x:
------
- add code for missed aproach on NDs
- fixed and improved missed approach code
- fixed bug in LNAV code
- fixed altitude on PFD
- fixed landing green ligths status
- fixed small bugs

3.22w:
------
OTHERS
- fixed wind indicator on ND
- some correction for systems and displays

3.22v:
------
OTHERS
- fixed and improved code (hold, int dir, AP...)

3.22u:
------
FMC
- rewrite code for HOLD page (not finished yet)
OTHERS
- fixed small bugs

3.22t:
------
ND
- add drawing holding pattern
OTHERS
- improved holding pattern code
- fixed some bugs (AP, add first waypoint on route page via SEL page,...)
- some correction for systems (as real plane) - engine valves, hydraulic...
Thank you very much to @Fay (real pilot B737-800) for testing, correction and videos.

3.22s:
------
- slightly improved LNAV code
- some correction for systems (as real plane) - FMC, spar valves, AP...
Thank you very much to @Fay (real pilot B737-800) for testing, correction and videos.


3.22r:
------
OTHERS
- fixed bugs and corrections (AF/RF legs,...)

3.22q:
------
- add autofill OAT after press 1LSK on N1 limit page
- fixed small bugs (navdata of date,...)
- some correction for systems (as real plane) - AP,...
Thank you very much to @Fay (real pilot B737-800) for testing, correction and videos.


3.22p:
------
- some correction for systems (as real plane) - APU start, A/T, OAT for N1 takeoff, duct pressure...
Thank you very much to @Fay (real pilot B737-800) for testing, correction and videos.

Note (systems): OAT not filled automatically on N1 page (FMC) by last update from Boeing FMC firmware. A/T can't engaged until not calculate valid N1 limit.
 

3.22o:
------
- fixed LNAV

3.22n:
------
- correction for flight model (thanks to @twkster)
- fixed and improved LNAV code

3.22m:
------
- fixed crash on Mac/Linux OS
- fixed corrupted files

3.22k:
------
- fixed and correction for CG calculation (thanks to @twkster)
- correction for flight model (thanks to @twkster)
- fixed small bugs (F/D, TCAS on ND,...)

3.22j:
------
- fixed read/write CG value from/to xplane
- fixed AF/RF legs for sharp turn
- fixed small bugs (Fuel gauge, ...)

3.22i:
------
- new engine start code (fixed bugs and improved code)
- fixed CG on "FUEL AND ..."page - wrong write CG to xplane
- fixed decode CR/VR waypoints for SID, STAR, APP

3.22h:
------
- fixed LNAV issue
- fixed NDB waypoints for Navigraph navdata
- fixed CHOCKS issue
- fixed other a little bugs and correction (speed in mach format ".xxx" without slash "/",...)

3.22g:
------
LNAV
- improved LNAV code for radii turn with correct displayed ANP
OTHERS
- add new datarefs for compatibility with 3rd plugins (CPFlight,...)
- fixed small bugs (calc VNAV descent path,...)
- fixed issue with double sounds callout (xplane 11.10 beta) - thanks to @AudioBirdXP

3.22f:
------
FMC
- add calculation CG as %MAC
- fixed bugs with NDB waypoints for SID, STAR, APP
OTHERS
- some correction for systems and FMC (as real plane) - electric...
Thank you very much to @Fay and @twkster for testing and tunning plane (real pilots).

3.22e:
------
OTHERS
- some correction for systems and FMC (as real plane) - electric...
Thank you very much to @Fay (real pilot B737-800).


3.22d:
------
OTHERS
- some correction for systems and FMC (as real plane) - engines start, electric...
Thank you very much to @Fay (real pilot B737-800).


3.22c:
------
- fixed more bugs in decode CIFS datas
- fixed small bugs

3.22b:
------
- fixed bug with Takeoff thrust
- fixed small bugs

3.22a:
------
- new code for LNAV with RNP
- fixed small bugs (Legs MOD on ND, entry runway on RTE page, wipers,...)

3.22:
-----
- add custom waypoints to custom database (<xplane path>/Custom Data/B738X_wptx.dat)
- fixed more small bugs (AUtobrake, RNP,...)

3.21z:
------
- fixed approach modes, now it should work: ILS, LNAV/VNAV, LOC/VNAV, LOC/GP, FAC/GP
- fixed LNAV code
- fixed small bugs (Descent now,Oherhead pnl gap...)

3.21y:
------
- fixed small bugs (VNAV, numbering custom waypoints, FMC message UNABLE REQD..., ...)
- fixed FO PFD display
- improved code (LNAV, RNP,...)
- better compatibility with xplane 11.10b7 (not guaranteed)

3.21x:
------
- add RNP/ANP value on LEGS page
- fixed small bugs and improved code

3.21w:
------
- add move one airway (waypoints of airway) to next one (f.x. remove discontinuity) on ROUTE page
- fixed horizontal pointer for LOC, VOR approach
- fixed small bugs and improved code


3.21v: hot fix
------
- fixed FMC freeze


3.21u:
------
FMC
- changed code for activate and mod mode
LNAV
- improved code for approach (better RNP)
OTHERS
- fixed small bugs and improved code

3.21t:
------
- added code for manual pressurization
- fixed issue with save config file - HDG UP
- fixed issue with outflow valve (animation)
- fixed small bugs (ILS frequnce/course on Approach page, first wpt on Route page, WPT330/10...)

3.21s:
------
- fixed issue with ND during taxi and pushback
- fixed small bugs

3.21r:
------
OTHERS
- fixed issue with generators after load plane
- fixed other small bugs
- some correction for systems (as real plane) - reverses, outflow valve, RAM door...
Thank you very much to @Fay (real pilot B737-800) for testing and correction.
SPECIAL
If you hold FMC MENU buttons more than 3 seconds, FMC will restarted, LNAV and VNAV disconnected. (I hope, temporary solution for freeze FMC).


3.21p: hot fix
------
- fixed start engines
- fixed DH radio on both PFD (captain and first officer)


3.21o:
------
FMC
- add support lat_lon waypoints for import fms flight plan
- automatically divide fuel to fuel tanks after load plane
OTHERS
- fixed small bugs
- some correction for systems (as real plane)
Thank you very much to @Fay (real pilot B737-800) for testing and correction.


3.21n:
------
- add Payload to FMC (MENU/XTRAS/FUEL AND ...)
- fixed engine starting time when you load plane first time
- fixed generators system
- fixed A/P GoAround mode
- fixed fill fuel tanks
- fixed small bugs

3.21m: hot fix
------
- fixed engine 2 start
- fixed "FUEL AND..." filled correct fuel tanks

3.21l:
------
FMC
- add not active route on ND (captain side only yet)
- add option "FUEL AND..." for correct fuel tank (XTRAS/FUEL AND...)
- fixed add waypoint AAAxxx/xx to end of route (LEGS page)
- fixed change cruise altitude (CRZ page)
OTHERS
- fixed start engine without fuel pumps ON
- fixed small bugs
- some correction for systems and FMC (as real plane) - APU, GPU, generators...
Thank you very much to @Fay (real pilot B737-800) for testing and correction.

3.21k:
------
OTHERS
- some correction for systems and FMC (as real plane) - A/P, F/D, all pumps, Fire system, Wing anti ice....
Thank you very much to @Fay (real pilot B737-800) for testing and correction.


3.21j: test version
------
FMC
- fixed issue with freeze FMC
- fixed DIR INTC in MOD mode
OTHERS
- some correction for systems and FMC (as real plane) - A/T,...
Thank you very much to @Fay (real pilot B737-800) for testing and correction.


3.21i:
------
FMC
- add confirm HOLD EXIT with EXEC button
- fixed issue with LEGS STEP

3.21h:
------
FMC
- add manually entered Lat/Lon waypoits (format AxxBxxx or Axxxx.xBxxxxx.x => A=N/S, B=W/E)
OTHERS
- some correction for systems and FMC (as real plane)
- fixed EXEC lights on FMCs
Thank you very much to @Fay (real pilot B737-800) for testing and correction.


3.21g:
------
- some correction for systems and FMC (as real plane)
Thank you very much to @Fay (real pilot B737-800) for testing and correction.

3.21f:
------
- tuned A/T engine for better control speed
- add more plane for TCAS systems (up to 19 planes - max. xplane 11 available)
- some correction of systems (as real plane)
- fixed some bugs (fuel flow,...)
Thank you very much to @Fay (real pilot B737-800) for testing and correction.

3.21e:
------
- add option SYNC BARO CPT->FO (MENU/XTRAS/OTHERS), default OFF (When ON, FO baro is disabled)
- fixed DIR INTC with displayed intercept course on ND
- fixed small bugs (ILS mag var, STAR/APP...)

3.21d:
------
Corrected some systems:
- Yaw damper (turn on/off, automatically off)
- A/T system
- FMC allows change origin in flight mode
Thank you very much to @Fay (for test in real B737-800 and make videos from real B737-800).

3.21c:
------
- change code for route airway to airway
- add MOD LEGS on ND (captain side only) - preview yet


3.21b: (hot fix)
------
- fixed issue with destination runways
- fixed small bugs

3.21a:
------
- add correct vertical speed feature (range -7900 to 6000, from -1000 to 1000 increment 50, otherwise increment 100)
- add option for ND: TRK-UP/HDG-UP (See MENU/XTRAS/OTHERS) - default TRK-UP
- add VREF+20 bug
- changed minimum and maximum maneuvering speed (amber line) - CDS software upgrade BP02/04/06
- fixed HOLD termination exit path
- fixed small bugs
 

3.21:
-----
- fixed issue with Descent now (capture VNAV path)
- fixed issue with "RF" and "AF" waypoints (CIFS)
- fixed DIR INTC to active waypoint when LNAV not engaged
- fixed calculation derate thrust
- fixed small bugs

3.20z:
------
- fixed turn on Autoland (it was temporary disabled)
- fixed small bugs


3.20y:
------
- new calculation for VNAV climb (calc T/C will be improved)
- add FMC in flight mode available diverted to other airport
- fixed VNAV climb (continue climb affter restrict alt)

3.20x:
------
- improved flight phase detect code
- fixed more bugs (missed approach, A/P...)

3.20w: (hot fix)
------
- fixed issue with fuel tank
- fixed calculation CI/VI (CIFS) waypoints
- fixed caluclation CA/VA/FA (CIFS) waypoints


3.20v:
------
- add First Officer FMC (...still in progress.. - no data entry yet)
- add feature select APP after FMC activated in missed approach mode (select MA wpt, FMC switch to MA wpt or press TO/GA button)
- disable IAF with Holding and Hold Fix

3.20u: (hot fix)
------
- fixed issue with align IRS (typo error)
- new code accept position to 3NM from real position for align IRS


3.20t:(hot fix)
------
- fixed FAC, G/P (typo error)
- fixed LNAV/VNAV on final approach
- fixed Speedbrake (autoposition when leveler is between down and arm)

3.20s:
------
- fixed issue with parking brake (after select before 10NM runway)
- fixed issue with incorrect switch speed mode after disengage AP (ex.:for autoland)
- fixed VHF source feature (I forget for this feature when I change code for AP)
- fixed restrict format for altitude and flight level (FL: xxx, FLxxx / ALT: xxxx, xxxxx) 


3.20r:
------
- add decode CIFS waypoint "PI" - Procedure turn
- improved taxi (roll friction)
- changed initial clock mode (Captain - UTC, First Officer - LOCAL)
- fixed small bugs (A/P, G/A flight phase armed, CHRONO/ET...)

3.20p:
------
- rewrited code for detect B738X main folder
- add IAF with holding waypoints (with altitude and single circuit termination)
- fixed green arc on ND (when VNAV engaged)
- fixed small bugs

3.20o: test release
-------------------
- rewrited code for AP modes and PFD annunciates
- rewrited code for FAC capture to Final approach course
- moved own database to main folder B737-800X (files: B738X_apt.dat, B738X_rnw.dat)
- fixed issue with renumbering destination runway (position lat,lon = 0,0)
- fixed small bugs

3.20n:
------
- fixed decode CIFS for some waypoints
- fixed vnav calculation (UNABLE CRZ ALT)
- fixed small bugs


3.20m:
------
- improved taxi (less power to taxi)
- fixed small bugs


3.20l:
------
- fixed calculation geometric vnav path for alt restrict Above/Below
- fixed issue with decode G/S altitude (FAF)
- fixed small bugs (HDG light after LNAV arm,...)

3.20k:
------
- add calculation VNAV descent geometric path
- add protect overspeed in VNAV descent
- LNAV engaged until distance to route is less than 3NM (otherwise LNAV armed only)
- fixed small bugs (SPD INTV, add wpt on RTE page, APP, VOR LOC...)

3.20j:
------
- fixed bugs in code for input airways on Route page
- fixed small bugs

3.20i:
------
- improved IAN approach (FAC, G/P) (new code)
- improved hold restrict alt during descent (new code)
- improved vnav path descent code (new code)
- fixed small bugs in decode CIFS
- fixed small bugs

3.20h:
------
- add format xxx/.xxx for climb, cruise and descent speed
- corrected IAN approach (FAC, G/P)
- fixed small bugs

3.20g:
------
- fixed hold restrict alt during descent
- fixed issue with  add STAR, APP waypoints (and during flight too)
- fixed F/D Go-around mode
- fixed small bugs

3.20f:(hot fix)
------
- new code for change STAR, APP in flight
- fixed issue with add STAR, APP waypoints (double wpt,..)
- fixed for cruise wind on PERF INIT page
- fixed small bugs

3.20e:
------
- add support default command "sim/engines/TOGA_power" for TO/GA button
- improved detect flight phase
- add detection Missed approach
- fixed small bugs (autopilot A/T modes,...)

3.20d:(hot fix)
------
- fixed issue with airways
- fixed code for flight phase
- fixed small bugs

3.20c:
------
- fixed issue with SID, STAR, APP waypoints (lat, lon)
- fixed issue with airways (airway to airway)
- improved entry to segment Arc to Fix
- fixed small bugs

3.20b: (hot fix)
------
- corrected Arc to Fix turn direction
- improved exit from Arc to Fix (next waypoint)
- fixed small bugs (IF, TF, CF)

3.20:
-----
- fixed issue with decode CIFS data
- fixed small bugs (distance to ref ICAO, ...) 


3.19:
-----
- SID/STAR/APP waypoints: add Arc to Fix, Constant Radius Arc
- fixed bugs

3.18:
-----
- rewrite code for decode waypoints of SID, STAR, APP
  working waypoints: Track/Direct to Fix, Course to Fix, Course to Intercept, Course/Fix to Alt, Track/Course to Dist, Track to Fix Dist, Course to radial, VECTOR, HOLD
- fixed LNAV - capture first waypoint

3.17:
-----
- fixed add STAR wpt (fixed issue with Des icao too)
- fixed VNAV descent calculation
- fixed VNAV descent (hold restrict altitude)
- fixed small bugs

3.16:
-----
- rewrite code for add SID, STAR, APP waypoints
- fixed add STAR without APP
- fixed rename old name runways by CIFS data
- rewrite code for flightphase (prepared for diversion to airport)
- fixed small bugs

3.15:
-----
- fixed ETA to actual waypoint on ND
- fixed message Unable crz alt
- fixed E/D point for Navigraph navdata
- fixed PROGRESS page
- improved VNAV, LNAV code
- fixed small bugs


3.14 (PI):
-----
- fixed airways for MacOS and Linux OS
- fixed bug in calculate T/D (sometimes message UNABLE CRZ ALT)
- fixed calculate waypoints for SID, STAR, APP
- slightly improved fps
- fixed small bugs


3.13:
-----
- add support any navaid or fix for add manually waypoints (format SEA330/10)
- fixed small bugs
- fixed callout 80kts from AudiobirdXP

3.12:
-----
- fixed controll navaids on FO ND
- fixed calculate waypoints for SID, STAR, APP
- fixed TCAS
- fixed issue with FMOD 1710 by AudiobirdXP
- fixed brightness for ND objects
- fixed small bugs (FAC,...)

3.11:
-----
FMC
- add OFFSET page (lateral offset route) - distance format: L10.0 / L10 / 10L / 10.0L (the same with R)
- added HOLD page (it works with route waypoints yet)
ROUTE page
- add SAVE ROUTE -> select save fpln format in XTRAS menu
- import flightplan with the same name by this priority: fmx, fml, fms
- import flightplan up to 12 chars for filename
- add manually waypoint: place-bearing/distance (format VVVxxx/xx, for example SEA330/10)
- add Direct To with Intercepr course
LNAV
- new own LNAV engine with bank logic
- added LNAV engine with HOLD entry pattern (direct, parallel, tear-drop)
- added LNAV engine with support HOLD termination: manual, altitude, single circuit
- support Fly Over Waypoints
NDs
- add 5NM range
- independent NDs
XTRAS/OTHERS page
- add option FLIGHTPLAN SAVE FORMAT (FMX - own format, FMS - fms format) - defualt FMX format
XTRAS/FMOD SOUNDS
- add option ANNOUNCEMENT SET NR
OTHERS
- added support DME navaids
- compatibility with new FMOD 1710 by AudiobirdXP
- fixed small bugs

Limitation:
- weather (WX RADAR) can show only on one ND at same time
- weather (WX RADAR) is inhibited for map range 5NM
- PLN mode for FO ND is inhibited for display route (until I finish FO FMC)

Note:
- terrain plugin by DrGluck for ND not work correctly (wait for update plugin by DrGluck)






3.10z: ALPHA release !!! - only for testing
------------------------
NDs - still in development
- add core engine for independent NDs

3.10y: ALPHA release !!! - only for testing
------------------------
OTHERS
- fixed EXEC lights on FMC
- fixed detect Airac cycle
- fixed small bugs

3.10x: ALPHA release !!! - only for testing
------------------------
OTHERS
- improved stability
- fixed crash

3.10w: ALPHA release !!! - only for testing
------------------------
OTHERS
- fixed more typpo errors and bugs
- clean code
- fixed recreate own navdata (B738X_apt.dat, B738X_rnw.dat)

3.10v: ALPHA release !!! - only for testing
------------------------
LNAV
- add HOLD entry pattern (direct, parallel, tear-drop)
- support HOLD termination: manual, altitude, single circuit
- improved detection code for next waypoint
OTHERS
- fixed small bugs

3.10u: ALPHA release !!! - only for testing
------------------------
LNAV
- add core engine for HOLD (entry pattern not implemented yet, only HOLD on track waypoints, none ND drawing)
OTHERS
- fixed small bugs

3.10t: ALPHA release !!! - only for testing
------------------------
LNAV
- high accuracy for LNAV (precision LNAV/VNAV - RNAV approach)
- added support DME navaids (it was bug)
OTHERS
- correction OFFSET page
- add prompt ACTIVATE for flight plan
- add HOLD page (only read Hold waypoints from Legs yet!!!)
- add support for new release FMOD by AudiobirdXP
- fixed small bugs

3.10s: ALPHA release !!! - only for testing
------------------------
LNAV
- rewrite code for LNAV
- support turn procedure for SID, STAR, APP waypoints and more
- added bank angle logic
OTHERS
- fixed small bugs (LNAV/VNAV, G/P,...)

3.10r: ALPHA release !!! - only for testing
------------------------
ROUTE
- rewrite code for calculate SID, STAR, APP waypoints
- support Fly Over Waypoints
OTHERS
- improved import fms flightplan
- fixed small bugs

3.10q: ALPHA release !!! - only for testing
------------------------
ROUTE
- improved code for offset waypoints
- add manually waypoint: place-bearing/distance (format VVVxxx/xx, for example SEA330/10)
- add Direct To with Intercepr course
OTHERS
- fixed small bugs

3.10p: ALPHA release !!! - only for testing
------------------------
ROUTE
- calculate conditional waypoints
- add OFFSET page (lateral offset route) - distance format: L10.0 / L10 / 10L / 10.0L (the same with R)
OTHERS
- fixed small bugs (VNAV ALT, ALT INTV, ALT ACQ...)

3.10o: ALPHA release !!! - only for testing
------------------------
ROUTE
- support import flight plan fml format (default xplane 11 format)
Note: Import flightplan with the same name by this priority: fmx, fml, fms
VNAV
- fixed ALT INTV feature
- fixed annunciate on PFD for SPD INTV feature
OTHERS:
- updated List of Datarefs and Commands


3.10n: ALPHA release !!! - only for testing
------------------------
- fixed bug with SIDs, STARs and APPs
- fixed bug with created own database for runways

PLANE NEEDS REBUILD OWN DATABASE !!!
1/ Delete file "<xplane11 path>/Output/FMS plans/B738X_apt.dat"
2/ Delete file "<xplane11 path>/Output/FMS plans/B738X_rnw.dat"

Note: After delete this file, airplane loaded time is longest (only once). This files are automatically updated with xplane 11 update (new release xplane 11).

3.10m: ALPHA release !!! - only for testing
------------------------
ND
- add 5NM range
- prepared for independent NDs
OTHERS
- improved detection renamed runways
- fixed small bugs


3.10l: ALPHA release !!! - only for testing
------------------------
- improved compatibility with default SID, STAR, APP datas
- fixed some issue and bugs

3.10k: ALPHA release !!! - only for testing
------------------------
ROUTE
- fixed more bugs

3.10j: ALPHA release !!! - only for testing
------------------------
ROUTE
- add support for airway to airway entry

3.10i: ALPHA release !!! - only for testing
------------------------
LNAV
- add code for LNAV engine
OTHERS
- fixed small bugs

3.10h: ALPHA release !!! - only for testing
------------------------
ROUTE page
- add support airways for default data
- fixed issue add waypoint as first waypoint
- allow add airway for DISCONTINUITY
- add SAVE ROUTE -> select save fpln format in XTRAS menu
- add import own fmx format
- CO ROUTE: imports own fmx format, if not found then imports fms format
XTRAS/OTHERS page
- add option FLIGHTPLAN SAVE FORMAT (FMX - own format, FMS - fms format) - defualt FMX format
OTHERS
- fixed small bugs

Note:
Own FMX format will be extend for more items.

TO DO:
------
- calculate radial waypoints for SIDs, STARs, APPs
LNAV engine:
- HOLD, ...
ND display:
- finish all modes (APP, VOR) - CTR/EXP
- independent ND display (captain, first officer)
- add 5NM range
FMC:
- add HOLD page, FIX page


3.10g: ALPHA release !!! - only for testing
------------------------
- fix issue with SEL DESIRED page for route


3.10f: ALPHA release !!! - only for testing
------------------------
- fix issue with connect SID, STAR, APP

3.10e: ALPHA release !!! - only for testing
------------------------
- fix change SID, STAR, APP waypoints

3.10d: ALPHA release !!! - only for testing
------------------------
- add ROUTE page
- fixed small bugs

LEGS page:
- add waypoints with SELECT DESIRED page
- delete and overwrite waypoints
DEP/ARR page:
- add SIDs, STARs and APPs with TRANSes
LNAV engine:
- detect actual waypoint and switch to next waypoint
- core engine
ROUTE page:
- import *.fms flightplan only (support up to 12 chars for filename)
- add ROUTE page for create flight plan with airways

TO DO:
------
- calculate radial waypoints for SIDs, STARs, APPs
LNAV engine:
- HOLD, ...
ND display:
- finish all modes (APP, VOR) - CTR/EXP
- independent ND display (captain, first officer)
- add 5NM range
FMC:
- add HOLD page, FIX page


3.10c: ALPHA release !!! - only for testing
------------------------
- add calculation INTC waypoints
- add draw route on ND
- fixed issue for SIDs, STARs and TRANSs (for some waypoints, for ex. KBUR APP)
- fixed VOR/LOC and APP mode (during LNAV/VNAV)
- fixed small bugs

LEGS page:
- add waypoints with SELECT DESIRED page
- delete and overwrite waypoints
DEP/ARR page:
- add SIDs, STARs and APPs with TRANSes
LNAV engine:
- detect actual waypoint and switch to next waypoint
- core engine
ROUTE page:
- import *.fms flightplan only (support up to 12 chars for filename)

TO DO:
------
- calculate radial waypoints for SIDs, STARs, APPs
LNAV engine:
- HOLD, ...
ND display:
- finish all modes (APP, VOR) - CTR/EXP
- independent ND display (captain, first officer)
- add 5NM range
ROUTE page:
- add waypoints with airways
FMC:
- add HOLD page, FIX page


3.10b: ALPHA release !!! - only for testing
------------------------
- fixed issue with STARs (typo error)
- fixed issue with sounds in LNAV mode
- unblocking MCP heading during LNAV
- fixed small bugs

LEGS page:
- add waypoints with SELECT DESIRED page
- delete and overwrite waypoints
DEP/ARR page:
- add SIDs, STARs and APPs with TRANSes
LNAV engine:
- detect actual waypoint and switch to next waypoint
ROUTE page:
- import *.fms flightplan only (support up to 12 chars for filename)
LNAV engine:
- core engine

TO DO:
------
- calculate intercept and radial waypoints for SIDs, STARs, APPs
LNAV engine:
- HOLD, ...
ND display:
- display engine for route
- independent ND display (captain, first officer)
- add 5NM range
ROUTE page:
- add waypoints with airways
FMC:
- add HOLD page, FIX page


3.10a: ALPHA release !!! - only for testing
------------------------
LEGS page:
- add waypoints with SELECT DESIRED page
- delete and overwrite waypoints
DEP/ARR page:
- add SIDs, STARs and APPs with TRANSes
LNAV engine:
- detect actual waypoint and switch to next waypoint
ROUTE page:
- import *.fms flightplan only

TO DO:
------
- calculate intercept and radial waypoints for SIDs, STARs, APPs
LNAV engine:
- core engine, HOLD, ...
ND display:
- display engine for route
- independent ND display (captain, first officer)
- add 5NM range
ROUTE page:
- add waypoints with airways
FMC:
- add HOLD page, FIX page


3.06p:
------
- fixed Approach page for Airport with only one STAR
- fixed IRS alignment time displayed up to 15 minutes
- fixed animation for Clock buttons (captain and first officer)
- corrected align Rheostat knobs for temp zones
- add option NOSEWHEEL AXIS > ON, YAW (XTRAS/OTHERS)
- add command "AP Disconnect button" -> "laminar/B738/autopilot/disconnect_button" (real place on yoke)



3.06o:
------
- fixed APU AGT temp
- fixed speed restrict during descent
- add flaps and slats test
- new temperature air condition indicator in degree C (thanks to @Sciaietto)
- gently improved fps
- fixed small bugs (EFIS, ALT HLD,...)

3.06n:
------
- fixed indicator for Center fuel tank (side by side) - alert CONFIG only
- gently calibrated temperature indicator for air conditioner
- fixed RNAV, VNAV and IAN engine
- add annunciate STAB OUT OF TRIM
- add feature A/P disconnect (second push extinguished A/P warn lights)
- fixed small bugs

3.06m:
------
- fixed Master Caution system
- fixed Vspeed calc
- improved N1 limit engine
- improved VNAV descent and RNAV engine
- fixed small bugs (FMC Arrival page, ...)

3.06l:
------
- fixed Master Caution lights
- add windows control temperature system
- improved wing anti ice system
- add FMC P/RST button
- add air conditioning system
- fixed small bugs (vnav, calc Vspeed, DRlanding_gear...)

3.06k:
------
- fixed reset OFF SCHED DESCENT
- add feature AUTO FAIL pressurization
- add pressurization system
- improved code detecting flight phase
- fixed small bugs (vnav,....)

3.06j:
------
- modify Clocks (Captain and First Officer) by FCOM
- add feature OFF SCHED DESCENT
- add annunciates ALTN and MANUAL pressurization
- small graphics corrections
- fixed small bugs


3.06i:
------
- fixed compatibility with BetterPushback (parking brake issue after finish pushback)
- add Master caution system with Six pack Recall
- small graphics corrections
- fixed small bugs


3.06h:
------
- fixed issue with Seatbelt sign switch (click region)
- fixed light OIL FILTER BYPASS
- fixed NOT IN DATABASE for airport works in default FMC (POS INIT page)
- improved APU system (start and shutdown)
- small graphics corrections

3.06g:
------
- fixed C/O button during VNAV engaged
- fixed NOT IN DATABASE for airport works in default FMC
- small graphics corrections

3.06f:
------
- autoupdate own database for airports and runways
- correctly displayed airports (with runways longest than 1700 m)
- fixed Emergency guard cover bug
- fixed small bugs

3.06e:
------
- improved THROTTLE NOISE LOCK feature
- fixed parkingbrake set when you begin in air
- add ref runway and des runway on ND
- add runway lenght in Takeoff page and Approach page
- add option Fuel gauge (Side by side / Over Under) to XTRAS/OTHERS (default Side by side)
- updated checklist by Remogio & DrGluck for Xchacklist 1.21+ plugin
- fixed small bugs
Note:
When plane loaded first time, it creates own airport database (it takes some time).

3.06d:
------
XTRAS
- add option OFF for THROTTLE NOISE LOCK

3.06c:
------
XTRAS
- add option THROTTLE NOISE LOCK (default 5 = 0.05 = 5% from throttle range 0.00 - 1.00)
OTHERS
- improved hydraulic systems (standby, flight control - rudder, ailerons and elevator)
- improved TOE BRAKE AXIS> OFF mode for stability on runway
- fixed small bugs


3.06b:
------
XTRAS
- add option PARKBRAKE REMOVE CHOCKS (default ON)
FMC
- fixed correct calculate Trim for takeoff (for Flaps 10,15,25) - thanks to @zulu_time
- tweak Radii of gyration by @zulu_time
- small graphics correction
OTHERS
- fixed small bugs

3.06:
-----
- add "Turn around state" (XTRAS/OTHERS) for Engine not running Xplane option
- modeled standby hydraulic rudder
- fixed small bugs

3.05z:
------
- fixed missing background lights
- fixed issue with GPU in cold'n'dark state
- GPU available when Parking brake SET or Chocks ON
- fixed panel lights (all off)
- fixed Emergency light in cold'n'dark state
- improved VNAV and RNAV path calc
- improved stability FMC


3.05y:
------
- add new animate buttons and commands (FLT CTRL A,...)
- add MIC button as TO/GA button
- add modeled brake system with brake accumulator
- changed intial state of switches for Cold'n'dark state
- update checklist by DrGluck for Xcheklist 1.21+ plugin by Sparker
- update B738_Commands.txt (updated list of custom commands)
- some graphics corrections
- fixed some bugs

3.05x:
------
- fixed Crossfeed fuel light
- add new commands (FLT CTRL A,...)
- add new animate buttons (TAT test,...)
- add new wiper system
- some graphics corrections
- fixed some bugs


3.05w:
------
- fixed error message for light airplane_generic_sp in Log.txt
- fixed APU start at low altitude (without fuel pump ON)
- new BARO/RADIO adjust feature as real
- add new commands (Logo light,...) - see file B738_Commands.txt
- update B738_Commands.txt (updated list of custom commands)


3.05v:
------
- fixed backlight textures
- new model and texture for manual landing gear extension
- modeled landing gear system
- fixed some bugs (APU off, Start valve, Crossfeed valve...)

3.05u:
------
- fixed issue with disengage autobrake
- fixed graphics bug with left landing gear
- add switches GPWS SYS TEST and GPWS INHBT for FLAP, GEAR, TERR (with covers)
- add switches MACH WARN TEST 1 and MACH WARN TEST 2
- add TO/GA buttons on throttle leveler
- corrected A/T disengage buttons on throttle leveler
- add manual gear extension door and handles -> modeled by Ciano35


3.05t:
------
- fixed distance to destination on PROG page
- add chocks for maingear and nosegear (use option CHOCK ON/OFF in XTRAS/OTHERS menu) - thanks Ciano35 for chocks modelling
- add 3D pilots for external view by Zlin142
- add APU fire animation and command
- update checklist by DrGluck for Xcheklist 1.21+ plugin by Sparker
- add some animations for buttons, switches and covers (prepared only)

3.05s:
------
3D COCKPIT
- add commands and animation for TO/GA buttons
- add commands and animation for Captain and FO Six Pack (it not works yet)
- some graphics correction
- fixed grahics issue in PROGRESS PAGE
- temporary disabled LNAV bank logic, you can use bank limit knob for LNAV too


3.05r:
------
- fixed issue with Left fuel pumps
- add Side by side circle fuel on EICAS
- add annuciates LOW, IMBAL, CONFIG on EICAS

3.05q:
------
- fixed Left pumps Low pressure annunciators
- fixed missing PI data for runway wind and slope
- fixed correct PI data for CG
- add bank logic for LNAV
- add TO/GA button to Throttle leveler (without animation yet)
- some graphics correction
- fixed small bugs
Note:
-----
MFD ENG button don't work as TO/GA button.

3.05p:
------
- fixed VOR1/2 distance on ND (format xxx and xx.x in NM)
- added APU fuel burn code


3.05o:
------
- fixed speed restrict code
- add data for vert deviation on PFD
- fixed small bugs
- fixed dataref for VS button


3.05n:
------
VNAV
- fixed for calc Decel point
- fixed smoothly descent
- fixed small graphics issue with T/C, T/D and Decel
IAN
- add annunciates Single Ch
OTHERS
- fixed small bugs
- small improoved


3.05m:
------
- add annunciate for vert deviation on PFD (IAN system - FMC)
- improved VNAV descent code (alt restricts)
- fixed small bugs


3.05l:
------
- add IAN system (for LNAV/VNAV and LOC/VNAV)
- add parking brake release after apply both differential brakes to max
- graphics PFD annunciates and corrections
- fixed small bugs


3.05k:
------
FLIGHT MODEL v3.0 by AeroSimDevGroup
- flap drag reduced
- engine EGT fix
- engine high speed performance/inlet efficiency adjusted
OTHERS
- fixed issue with LBS/KGS read from config
- fixed small bugs


3.05j:
------
- add capture on PFD for horizontal a vertical pointer (VOR/LOC, G/S)
- fixed PFD annunciates (VOR LOC, G/S,...)
- fixed issue with default HOLD page on captain side
- fixed "ghost T/D"
- fixed small bugs



3.05i:
------
- add manual vspeeds feature (only V1, Vr, Vref yet)
- fixed issue with BetterPushback plugin
- change to read/write custom dataref for parking brake ratio -> "laminar/B738/parking_brake_pos"
- tested with X-plane 11.02r2


3.05h:
------
- small graphics corrections on PFD
- fixed ALT INTV feature
- fixed FD for LNAV, VNAV engage (LNAV above 50ft RA, VNAV above 400ft RA)
- fixed VNAV speeds for LNAV/VNAV approach
- fixed small bugs (MCP alt on PFD,...)
- add Preflight status to FMC


3.05g:
------
- fixed issue with automatic descent after crossing T/D
- fixed issue with brake
- fixed issue with annunciates (N1,...)
- fixed small bugs

3.05f:
------
- fixed TO GA annunciates
- new code for detect flight phase
- fixed small bugs (LVL CHG,...)


3.05e:
------
- fixed A/T disconnect light
- new engine and graphics for PFD autopilot annunciates (no more overlapping text)
- add FMC message light
- modify damper constant for landing gear
- add support for BetterPushback (thanks @skiselkov)

3.05d:
------
- fixed small issue with crs on captain and first officer side
- edited taxi and runways lights (lower lights power)
- add VNAV approach logic
- fixed small bug in ALT ACQ mode


3.05c:
------
- improved taxi when TOE BRAKE AXIS > OFF (yaw axis control nosesteer)
- corrected Bank angle feature - it is works for HDG and VOR mode (by FCOM)
- improved displayed FD
- add VNAV SPD descent mode

3.05b:
------
- fixed autobrake
- improved simply T/C calc
- fixed PFD pth dev source
- fixed TO -> LVL CHG after press CMD button
- fixed small bugs

3.05a:
------
- fixed issue with LVL CHG when A/P off
- fixed small bugs on TO mode
- fixed unload plane (toe brakes)

3.04:
-----
AUTOPILOT
- fixed autopilot
- fixed autoland
OTHERS
- fixed small bugs


3.03:
OTHERS
- fixed some wrong files in release 3.02

3.02:
-----
FMOD by AudioBird XP - you need install FMOD v1.0 and above
- add items to FMOD SOUNDS menu
FMC
- add DIR INTC navaid
AUTOPILOT
- fixed autoland engine (after improved AP for spd, pitch and roll)
- correctly restrict flaps speed for VNAV climb
OTHERS
- fixed small bugs (vert dev ind,...)


3.01:
-----
FMC
- fixed issue with calc vnav speed (it was calculated only when it was entry CI)
AUTOPILOT
- improved autopilot for speed, roll and pitch
OTHERS
- fixed unload aircraft (issue when you change to other plane)
- fixed small bugs

3.00:
-----
FMC
- add Acceleration height
- fixed issue vnav speed when cruise altitude below 10000 ft
AUTOPILOT
- fixed FMC SPD mode when reached cruise altitude
OTHERS
- fixed small bugs

2.99:
-----
FMC
- fixed freeze if you change STAR when waypoint include STARs
OTHERS
- improved steer nose when Toe brake axis off
- fixed small bugs (graphics, overlapping text..)

2.98:
-----
FMC
- add calculate short trip cruise altitude
- add magenta type for actual waypoint and restrict datas
- fixed issue with freeze FMC
ND
- add numeric vertical path error
- fixed correct shows vertical path marker and value
AUTOPILOT
- improved VNAV descent mode
AUTOPILOT and AUTOTHROTLE
- rewrited code for A/P and A/T
- rewrite code for roll and pitch modes
OTHERS
- fixed toe brakes (xplane 11 assigned toe brakes to yaw axis, when toe brake axis don't assigned)
- add items TOE BRAKE AXIS ON/OFF
- add commands "Toe brake left", "Toe brake right" and "Toe brake both"
- fixed small bugs


2.98f:
------
AUTOPILOT
- fixed captain CRS and first officer CRS
- fixed autoland (throttle management)
- tweaked VNAV descent throttle
FMC
- some small graphics corrections

2.98e:
------
FMC
- add calculate short trip cruise altitude
- add magenta type for actual waypoint and restrict datas
ND
- add numeric path error
AUTOPILOT
- improved VNAV descent mode
OTHERS
- fixed small bugs


2.98d:
------
FMC
- fixed freeze on LEGS STEP page
- fixed graphics correction on PROG page
AUTOPILOT
- fixed slowly throttle to idle in LVL CHG mode
- fixed lock idle throttle in VNAV mode during descent
- fixed G/A mode (all modes)
PFD
- fixed N1 and MCP overlaping annunciates

2.98c:
------
FMC
- fixed FMC freeze

2.98b:
------
AUTOPILOT
- fixed select pitch and roll modes without FD
- fixed bank selector works in HDG mode when VOR/LOC armed
FMC
- fixed issue with missing chars (magenta)


2.98a:
-----
AUTOPILOT and AUTOTHROTLE
- rewrited code for A/P and A/T
- rewrite code for roll and pitch modes
FMS
- graphics correction for pages (magenta type)
OTHERS
- fixed toe brakes (xplane 11 assigned toe brakes to yaw axis, when toe brake axis don't assigned)
- add items TOE BRAKE AXIS ON/OFF
- add commands "Toe brake left", "Toe brake right" and "Toe brake both"
- fixed small bugs


2.97:
-----
AUTOLAND
- improved autoland system
PFD
- fixed correctly vnav path
ND
- fixed correctly vnav path
- add T/C, T/D, DECEL on EFIS PLN mode
AUTOPILOT
- add feature ALT INTV delete next alt restrict
- add LNAV/VNAV
- fixed FD correctly on ground


2.96 only fix:
---------------
FMOD by AudioBird XP
- add items to FMOD SOUNDS menu
FMC
- fixed issue with FMC
OTHERS
- fixed small bugs

2.95 fix:
---------
- fixed issue with Ref icao on POS INIT page
 
2.95:
-----
FMC
- fixed some bugs with add, delete, overwrite waypoints
- fixed bugs with calc position T/C, T/D, DECEL
- fixed issue when Origin and Dest is the same (issue with show flightplan on FMC)
AUTOPILOT
- improved AUTOLAND system
- add A/P, A/T cancel lights button
OTHERS
- fixed small bugs


2.94fix:
--------
- fixed PAUSE AT T/D

2.94:
-----
AUTOPILOT
- add VNAV ALT feature with ALT INTV
- fixed small bugs in VNAV mode
IRS
- fixed issue with align IRS from cold and dark state
FMC
- add items CHOCK, PAUSE AT T/D (before about 8nm)
- add DIR INTC to active waypoint (twice 1LSK on LEGS page)
FMOD by AudioBird_XP
- add items to FMOD SOUNDS menu
OTHERS
- fixed small bugs (annuciates,...)


2.93:
-----
FMC
- fixed issue with correctly working CLR and DELETE buttons
AUTOPILOT
- fixed: SPEED mode disengage VNAV pitch mode
OTHERS
- fixed fuel APU fuel pump system (start with left AFT or FWD pump)
- fixed small bug with speedbrake after touchdown
- fixed small bugs

2.92:
-----
AUTOPILOT
- fixed FD VNAV pitch mode
- fixed connection FD and A/P systems
FMC
- add some alert messages
- fixed issue with CLR button
- fixed issue with message APPRCH VREF NOT SELECTED
FMOD by AudioBird_XP
- add items to FMOD SOUNDS menu

Note:
VNAV can be armed on the ground only. When VNAV armed it automatically enagaged above 400 ft RA. VNAV can be engaged above 400 ft RA.
A/P works with FD set to ON (captain side and/or fo side) only.

2.91:
-----
FMC
- fixed some issue with DirIntc feature
- fixed speed restrict for actual waypoint
- add message buffer (as real FMC)
- add message ALT CONSTRAINT
OTHERS
- new detect code for find FMOD by AudioBird_XP
- fixed small bugs

2.90:
-----
FMOD by AudioBird_XP
- add items to FMOD SOUNDS menu
- fixed default value for items
- fixed AIRPORT item
FMC
- fixed message CHECK ALT TGT
- add some alert messages (DISCONTINUITY, TAI...)
ND
- add ETA to next waypoint
AUTOPILOT
- improved bank logic (VOR LOC, APP)
OTHERS
- add items Hide Yoke (XTRAS/OTHERS)
- fixed small bugs


2.89:
-----
FMOD by AudioBird XP
- add items to FMOD SOUNDS menu
PFD
- fixed small bug with transition level
FMC
- add message CHECK ALT TGT
OTHERS
- enable draw waypoints for all EFIS range
- fixed issue with VOR LOC and APP when LNAV engaged before
- fixed issue with route and legs when IRS not alligned
- fixed EGT temp when engine not rotating
- fixed small bugs

2.88:
-----
FLIGHTMODEL by AeroSimDevGroup
- revert back flightmodel from release 2.86
FMC
- add pages XTRAS -> FMOD SOUNDS, OTHERS (align time)
- add options DEFAULT, SAVE (save units, fmod sounds, align time)
PFD
- add annunciator VNAV arm
OTHERS
- fixed EGT temp (depend by outside temp)
- fixed small bugs

Note:
Option Align time: REAL -> align time is depend of place on Earth

2.87:
-----
FLIGHMODEL by AeroSimDevGoup
- fixed small bugs at high density altitude
FMC
- fixed change climb and cruise speed
- add some messages


2.86:
-----
FMC
- add read CG from xplane 11 (press 3LSK when scratchline blank on Takeoff ref page)
OTHERS
- change range Baro DH to 15000 ft
- fixed small bugs (APU, V1 callout, Autopilot)
- clean FMC code

2.85:
-----
FMC
- added option Save for save config sounds FMOD by audiobird_xp (XTRAS page)
OTHERS
- fixed GPWS Glideslope warning
- fixed V1 aureal

2.84:
-----
FLIGHT MODEL by AeroSimDevGroup
- fixed flight controls
- fixed spoilers logic, speed brake logic and ground spoilers logic
- spoilers now deploy in right sequence and correct angles to touchdown, in flight and RTO
- fixed engine over temp in most situations
FMC
- add detecting version FMOD by AudioBird XP
Note:
You must have installed plane in folder "Xplane11/Aircraft/B737-800X" for correct version detection.

2.83:
-----
FMOD
- add code for FMOD by AudioBird XP
AUTOPILOT
- fixed VNAV can engaged on the ground
- fixed Takeoff mode
OTHERS
- fixed some issue

2.82: hot fix for 2.81
-----
FMC
- add page XTRAS for setting FMOD by AudioBird XP (in Menu page)
- fixed change descent speed on Descent page (it was possible only when descent not active)
AUTOPILOT
- fixed some issue (VS, LVL CHG....)

2.81:
-----
FMOD
- add FMOD by AudioBird XP RC1 B2
FMC
- add page XTRAS for setting FMOD by AudioBird XP (in Menu page)
- fixed change descent speed on Descent page (it was possible only when descent not active)
AUTOPILOT
- fixed some issue (VS, LVL CHG....)

2.80:
-----
FMC
- fixed issue on LEGS page (direct to, overwrite waypoints)
AUTOPILOT
- fixed issue with ALT HLD
OTHERS
- fixed small bugs

2.79:
-----
FMC
- fixed issue with airport as waypoint
- fixed issue with restrict flaps speed during descent when it not filled GW
APU
- fixed APU bus avaible after stabilized EGT
GPU
- GPU not available when parking brake not set
OTHERS
- add push buttons Below G/S - captain and first officer (prepared for FMOD by audiobird_xp)
- add some code for FMOD by audiobird_xp
- fixed flaps bugs during descent
- fixed small bugs

2.78:
-----
FMC
- fixed some issue on LEGS page (directto, add waypoint, overwrite waypoint-shortcut)
- fixed issue with HOLD page (you can to use for add waypoint and overwrite waypoint-shortcut)
OTHERS
- graphics correction for annunciates
- fixed small bugs in APU system
- add some code for FMOD by audiobird_xp


2.77:
-----
AUTOPILOT
- fixed VNAV bank angle limit logic for VNAV
FMC
- fixed issue with Cruise climb and Cruise descent
APU
- new APU system
OTHERS
- adjust climb and cruise thrust
- fixed correct thrust after engaged Takeoff mode

Note:
APU START - set and hold APU switch to START position about 2 seconds and then release. APU starts about 25 seconds.

2.76:
-----
OTHERS
- fixed climb thrust (EGT issue)
- connect IRS system with PFD, ND and A/P
- fixed N2 spool time
- fixed others bugs

2.75:
-----
AUTOPILOT
- fixed bank angle selector for HDG mode only
FMC
- fixed issue with lost T/D
- add message Unavaible cruise altitude
OTHERS
- added working push button for Alt horn cutout (prepared for FMOD by audiobird XP)
- added datarefs (prepared for FMOD by audiobird XP)
- fixed others bugs


2.74:
-----
FMC
- add Progress page (only first page works yet)
OTHERS
- fixed others bugs

2.73:
-----
VNAV
- new VNAV engine (with all restricts)
- add speed flaps restricts during descent flight phase
FMC
- update Descent page - add speed flaps restricts
OTHERS
- fixed units for FF on Lower DU
- fixed correct ILS course on Approach page (it shows 0-359 degree)
- fixed others bugs

2.72:
-----
FMC
- LEGS page: fixed correctly speed and alt restrict format
  (spd: xxx/, alt: xxx, xxxx, xxxxx, FLxxx, spd&alt: xxx/xxxxx, xxx/FLxxx, for alt+: A,B)
OTHERS
- fixed small bugs

2.71:
-----
FMC
- change LEGS page
VNAV
- fixed VNAV engine (fixed autodescent after reached T/C)
OTHERS
- fixed diferrential brakes
SIM COCKPIT BUILDER
- add commands for Runway lights ON/OFF

2.70:
-----
FMC
- fixed sometimes freeze FMC pages
VNAV
- fixed calc for T/D (correct shows altitude, sometimes it was show incorrect)
OTHERS
- fixed small bugs
- fixed differential brakes

2.69:
-----
VNAV
- fixed graphics issue with T/C, T/D, DECEL (larger precision calc)
OTHERS
- correct graphics on ND for graphics compatibility with Terrain plugin by DrGluck
- fixed small bugs

2.68:
-----
FMC
- fixed insert the nearest navaid on LEGS page
(type navaid to scratchline and press 1LSK..5LSK for insert the nearest navaid), press EXEC or 6LSK(cancel)


2.67: hot fix
-----
- fixed issue with FMC and VNAV (freeze, not complete lags pages....)


2.66:
-----
FMC
- fixed RESET features on MENU page
- LEGS page add the nearest waypoint to flightplan (sometimes not working correctly - it will be fixed)
OTHERS
- fixed small bugs (VNAV,...)

2.65:
-----
VNAV
- fixed small bugs for descent path
PFD
- add show APP G/S during LNAV
FMC
- fixed INIT REF button (it shows correct pages)
OTHERS
- fixed small bugs

2.64:
-----
VNAV
- fixed small bug for descent path calculation
- fixed other small bugs
REVERSE THRUST
- reverse thrust locked above 10ft RA
A/T
- fixed issue with thrust modes

2.63:
-----
FMC
- add calculation ISA DEV and T/C OAT
- fixed correct graphic on POS INIT page
- new VNAV engine
OTHERS
- fixed small bugs

2.62:
-----
FMC
- fixed correct E/D (when E/D is first wpt of approach)
- fixed calculate G/P for RNAV, LOC/VNAV
AUTOPILOT
- fixed issue with VNAV after reached T/D


2.61:
-----
FMC
- fixed bugs on approach page (correct ils, loc data)
- small graphics corrections on pages
AUTOPILOT
- fixed SPEED mode with N1 limit
SIMCOCKPIT BULIDER
- dataref "laminar/B738/autopilot/mcp_alt_dial" is writeable
OTHERS
- fixed small bugs

2.60:
-----
OTHERS
- fixed FMC freeze after deselect SID
- fixed animation slats
- fixed small bugs and modify VNAV engine (prepared for VNAV calc all restriction)
- fixed small bugs


2.59: (hot fix)
-----
OTHERS
- fixed aircraft stability (horizontal oscilation)
FMC
- fixed show correct page on startup

2.58:
-----
FMC
- show freq, id, course only for approach: ILS, LOC, GLS
AUTOPILOT
- fixed issue with throttle after disconnect A/P
VNAV
- fixed display issue with T/C
- fixed some issue with cruise climb mode (if not correct set MCP alt before run cruise climb)
- fixed correct E/D
EFIS
- fixed correct Fuel Flow in kgsx1000/hours
WINGS
- fixed flaps animation
OTHERS
- fixed small bugs (sometimes on Captain FMC buttons not working,...)


2.57:
-----
FLIGHT MODEL
- update flight model by AeroSimDevGroup (thanks Alan)
   - update flight controls
   - update wings
OTHERS
- fixed small bugs

Note:
-----
Wings:

- 737-800 Airfoils - The aircraft's core airfoils have been re-generated to handle higher Reynolds numbers.  This means the models handling will feel quite different at low altitude and high speeds.
- Slight change to the wings, dihedral has been adjusted for a better in cruise nose attitude.  The problem here, is I can only get a "best fit" without complete external flight model.  Either the aircraft flies a little bit off in take off, landing or cruise.  Or you can get the attitude correct for just one of those.  I have chosen to get as close as possible across as many regimes as possible!

Flight controls:

- Ailerons now correctly phase out at high speed.  With the roll spoilers doing the majority of the lateral control of the aircraft above 250 knots.
- In flight spoilers increased their drag effect
- Flap extension time increased


2.56:
-----
FMC (update Approach page)
- add Destination ICAO, Runway, Approach, Frequency, Id, Course
- add G/S enable/disable
OTHERS
- fixed small bugs


2.55:
-----
FMC
- fixed issue with select SID, STAR, APP, RWY, TRANS
- fixed graphics issue Vnav Path on PFD (flickering)
EICAS
- add units kgs for Fuel and Fuel flow (change units by FMC - Menu page)
OTHERS
- fixed small bugs (graphics issue on PFD, LNAV/VNAV, LOC/VNAV...)


2.54:
-----
VNAV
- fixed correct E/D waypoint
- fixed Vert dev path displayed on PFD
FMC
- INIT REF - add relevant pages (POS INIT, T/O, APP, INDEX)
- fixed correct value VERT DEV on Descend page (LO <-> HI)
AUTOPILOT
- add APP feature RNAV (LNAV/VNAV) and LOC/VNAV (it will be add correct annuciates on PFD later)
OTHERS
- fixed small bugs

Note:
For select SID, STAR, TRANS, APP (temporary solution)-> use EXEC every step, for ex. select STAR, press EXEC, select TRANS, press EXEC,...
APP RNAV and LOC/VNAV -> select RNAV or LOC approach on Arr page, select Transition if Trans exists, check G/S to OFF. Press APP button for angaged APP RNAV or LOC/VNAV and you can see G/P arm on PFD.

2.53:
-----
VNAV
- fixed switch from climb to descent phase during climb (after aply DIR INTC feature)
FMC
- update Descent page (time to alt restrict waypoint)
AUTOPILOT (Climb phase)
- when N1 engaged and no pitch mode, after engaged AP, AP change speed mode to SPEED with current speed and when airspeed > MCP speed then pitch mode change to VS
OTHERS
- fixed small bugs

2.52:
-----
VNAV
- fixed issue with altitude restrict during climb and descent
- fixed issue with VNAV off (if not set MCP alt to cruise alt during alt restrict)
FMC
- fixed issue with LEGS PLN mode (step waypoints)

Note:
When desync LEGS PLN STEP, use temporary FO FMC for sync STEP LEGS - see folder VIDEA_TUTORIAL -> Sync_step.mp4

2.51:
-----
FMC
- add LEGS PLN mode (step waypoints)
- fixed Dep and Arr decode CIFS
VNAV
- fixed speed restrict 250/10000 during descent
PFD
- add green arc for VNAV pitch mode
OTHERS
- fixed small bugs

2.50:
-----
VNAV
- fixed DECEL if exist more than one DECEL points
- fixed waypoints distance
- fixed small bugs
OTHERS
- tested with XPLANE 11.01r2

2.49:
-----
ND
- add ETA time to waypoints (EFIS DATA button)
FMC
- fixed issue with select SID and STAR
VNAV
- fixed issue with engaged VNAV

2.48fix:
--------
- fixed corrupted code

2.48:
----
FMC
- calculate VNAV speed and altitude
- update climb and descent page
- simply calculation T/C
- calculation T/D and DECEL
- add message NAV DATA OUT OF DATE
- show G/S (enable/disable) on ARR page
VNAV
- new own VNAV engine with speed and alt restrictions
PFD
- displayed T/C, T/D and DECEL
- VNAV PTH dev displayed during descent
- add EFIS DATA for waypoints (displayed restrict alt and ETA - ETA not computed yet)
YAW DAMPER
- add yaw damper system (it moves yaw damper to off position after system fail)
OTHERS
- fixed starter: real N2 rises and max % N2
- fixed LVL CHG and VS engaged before AP engaged
- fixed T/C OAT range (-70C to 70C, -94F to 158F)
- others small bugs fixed
Note:
For create route -> press RTE button for displayed route page and press 6LSK button (<FPLN - it displayed default route page)
For load route -> press RTE button for displayed route page, type name and press 2LSK button
For save route -> press RTE buttonfor displayed route page, type name and press 3RSK button (SAVE ROUTE>)
LEGS page -> only delete waypoints and direct to feature (DIREC TO -> select waypoint with 1LSK..5LSK and press 2LSK on first page of LEGS page)


2.48z (hot fixies):
-----
FMC
- rewrite code for VNAV engine (new code with fixed freeze FMC)
- add virtual path for RNAV

2.48y (hot fixies):
-----
FMC
- fixed freeze FMC when no restricts speed or altitude data
- fixed issue with Dep page after entry reference ICAO on POS INIT page
- fixed issue with select SID after select RWY from page > 1
- fixed issue with decode SID and STAR for runway when xxB -> only xxL, xxR and not xxC

2.48x: (beta)
------
FMC
- calculate VNAV speed and altitude
- update climb and descent page
- simply calculation T/C
- calculation T/D and DECEL
- add message NAV DATA OUT OF DATE
- show G/S (enable/disable) on ARR page
VNAV
- new own VNAV engine with speed and alt restrictions
PFD
- displayed T/C, T/D and DECEL
- VNAV PTH dev displayed during descent
- add EFIS DATA for waypoints (displayed restrict alt and ETA - ETA not computed yet)
YAW DAMPER
- add yaw damper system (it moves yaw damper to off position after system fail)
OTHERS
- fixed starter: real N2 rises and max % N2
- fixed LVL CHG and VS engaged before AP engaged
- fixed T/C OAT range (-70C to 70C, -94F to 158F)
- others small bugs fixed
Note:
For create route -> press RTE button for displayed route page and press 6LSK button (<FPLN - it displayed default route page)
For load route -> press RTE button for displayed route page, type name and press 2LSK button
For save route -> press RTE buttonfor displayed route page, type name and press 3RSK button (SAVE ROUTE>)
LEGS page -> only delete waypoints and direct to feature (DIREC TO -> select waypoint with 1LSK..5LSK and press 2LSK on first page of LEGS page)

2.48o: (alpha version)
------
FMC
- VNAV with speed and altitude restrict
- update Descent page (speed and altitude restrict)
OTHERS
- small bugs fixed
Note:
Speed calculation is not correct (displayed on Legs page), but speed restrict works well. DECEL will be fixed.

2.48n: (aplha version)
------
FMC
- fixed Dep page for runway without SID
- add message NAV DATA OUT OF DATE
- add calculate T/D
PFD
- VNAV PTH dev displayed during descent
OTHERS
- fixed small bugs

2.48m: (alpha version)
------
FMC
- fixed Discontinuity on LEGS page
- fixed show G/S (enable/disable) on ARR page
- fixed simply T/C calculation
OTHERS
- fixed starter: real N2 rises and max % N2
- fixed LVL CHG and VS engaged before AP engaged

2.48l: (alpha version)
------
FMC
- update climb page (speed and alt restrictions, T/C)
VNAV
- own VNAV SPEED climb with speed and alt restrictions
OTHERS
- fixed small bugs (graphics FD, ALT ACQ, LVL CHG, VREF)

2.48k: (alpha version)
------
FMC
- fixed Arr page

2.48j: (alpha version)
------
FMC
- add VNAV climb simply calculation (for testing engine)
- add T/C and DECEL calculation
ND
- add T/C and DECEL
OTHERS
- fixed small bugs

2.48i: (aplha version)
------
FMC
- add SAVE ROUTE 3RSK on RTE page (entry name and press 3RSK)
- fixed flight number on RTE page
- fixed discontinuity in LEGS page
OTHERS
- slightly improved fps
- fixed small bugs


2.48h: (alpha version)
------
FMC
- add waypoints (displayed up to next 10 WPTs)
- add EFIS DATA for waypoints (displayed restrict alt and ETA - ETA not computed yet)
- fixed T/C OAT range (-70C to 70C, -94F to 158F)
OTHERS
- fixed small bugs

2.48g: (alpha vesrion)
------
FMC
- add Trans on Dep page
- fixed some issue with Dep page
- fixed some issue with Arr page

2.48f: (alpha vesrsion)
------
FMC
- fixed Arrivals page
- fixed some bugs

2.48e: (alpha version) - fix for 2.48d
------
FMC
- fixed old file

2.48d: (aplha version)
------
FMC
- add Legs page (displayed legs loaded with new FMC via CO ROUTE only)
A/P G/A
- fixed disconnect A/P when flaps not up or glideslope engaged

Note:
-----
All new FMC pages in development (Route, Dep/Arr,Legs) - if you have any issue with new pages, use First Officer FMC temporary for this pages.
For edit flight plan you can press <6RSK> (FPLN) for entry to default FMC. Created flight plan can be read with CO ROUTE (type name and press 2LSK) - format *.fml. Legs page displayed legs loaded via new FMC by CO ROUTE. Legs page displayed restrict speed and alt only (not calculated). You can edit restrictions for waypoints. Calculation not implemented yet - now working default calculation (no displayed). You can try edit legs. First waypoint not able edited. Second waypoint is target waypoint FMC (plane fly to second waipoint). For DIRECT TO: select any target waypoint (use button 1LSK..5LSK, NEXT, PREV) and then select overwrite waypoint (use button 1LSK..5LSK, NEXT, PREV).

2.48c: (alpha version)
------
FMC
- add transition to approach page
- add displayed flight plan on Route page (no edit yet)

Note:
-----
All new FMC pages in development (Route, Dep/Arr) - if you have any issue, use First Officer FMC temporary.
For edit flight plan you can press <6RSK> (FPLN) for entry to default FMC.
When you selected non ILS approach with new FMC don't forget enable G/S for using APP with G/S.

2.48b: (alpha version)
------
FMC
- add approach page (without transition)
- add read flight plan (route)
YAW DAMPER
- add yaw damper system (it moves yaw damper to off position after found fail in system)

Note:
-----
All pages in development. Use First Officer FMC for Departure and Approach temporary.

2.48a: (alpha version)
------
FMC
- add route page
- add departure page - in development
APU
- fixed correct APU start switch (after 2 seconds springed from START to ON)

Note:
-----
Route page 
- not loaded data from co route to FMC (but data are loaded to default FMC and navigation working properly)
- for go to default route page pres <RTE> and <6RSK> (FPLN)
Departure page
- only reference departure without transition

2.47:
-----
ND
- fixed center line runway (long about 14 NM)
- more number objects VOR, VOR-DME, FIX (displayed up 50 objects now)
AUTOBRAKE
- fixed disarm when brake leveler down one notch and thrust 3 seconds after touchdown
OTHERS
- fixed small bugs

2.46: (fix for update 2.45)
-----
ND
- correcion graphics - small font type
OTHERS
- fix for update 2.45
- fixed small bugs

2.45:
-----
ND
- add more number objects VOR, VOR-DME, FIX (displayed up 40 objects now)
- graphics correction - fixed active waypoint
- graphics correction VOR1/2 course line (if VOR1/2 tuned - VOR is green, and if EFIS VOR1/2 on too - displayed course line too)
LANDING LIGHTS
- change landing lights retractable to 3 state (retract, extend, on)
SIM COCKPIT BUILDER
- add commands for landing lights retractable
- for simply command use default command for landing lights on, landing lights off, landing lights toggle
OTHERS
- fixed small bugs


2.44b: hot fix 2
------
ND
- fixed magnetic declination

2.44: hot fix
-----
ND
- hot fix for ND (one missing line in code)

2.43:
-----
FMC
- new code for DIRECT TO WPT (only for waypoints from first LEGS page)
ND
- improved performance

How it works:
1/ Press <LEGS> button (must to be pressed)
2/ Select waypoint - use buttons <3LSK>, <4LSK> or <5LSK>
3/ Press <2LSK>
4/ Press <EXEC> for accept MOD LEGS (modification legs)   or   press <6LSK> for cancel MOD LEGS


2.42:
-----
ND
- improved performance (impact on fps)
- graphics corrections

2.41: hot fix
-----
ND
- fixed issue with loading default Xplane11 navaids

2.40:
-----
ND
- add ILS runway line (show if ILS tuned to NAV1 and max ILS distance 80NM)

2.39:
-----
ND
- graphic correction
APU
- modify APU system (starting, shutdown)
YAW DAMPER
- fixed Yaw damper
OTHERS
- fixed cover guard switches (Standby power, Transfer bus) and Pedestal brightness knob
- fixed small bugs (ALT ACQ, graphic)
SIM COCKPIT BUILDER
- update B738_Commands.txt (add command for Yaw dumper)

2.38:
------
ND
- add VORTACs, VORs, VOR DMEs, APTs(only with LOC, GS or ILS), FIXs
APU
- corrected temp for APU
- fixed annunciator LOW OIL PRESS
OTHERS
- landing gear softer suspension
- fixed small bugs

2.37:
-----
NAVDATA
- automatic find first custom navdata and then default navdata
- no need edit scriptfile for path to XPLANE 11


2.36:
-----
NAVDATA
- read custom or default navdata AIRAC
ELECTRIC
- fixed Battery and Standby power for Cold n Dark

2.35B
-----
NAVDATA
- fixed issue on MAC OS

2.35:
-----
PFD
- improved graphics for DH minimum
ELECTRIC
- fixed correct function guard cover battery and standby power
OTHERS
- fixed graphics issue on PFD and ND
NAVDATA
- beta test for read navdata cycle (install update, open file "B738X/plugins/xlua/scripts/B738.fms/B738.fms.lua" with Notepad, change value XPLANE_PATH = "your path to xplane" and save)

2.34:
-----
ELECTRIC
- fixed correct function switch for APU GEN1, APU GEN2, GEN1, GEN2, GPU
- change switches to momentary switches for GPU
SIM COCKPIT BUILDER
- update B738_Commands.txt and B738_Datarefs.txt
OTHERS
- fixed issue with sometimes jerking animation throttle leveler

2.33:
-----
VNAV
- add confirm DES NOW with EXEC button (6RSK - DES NOW arm/disarm)
- calculate DES NOW show/hide
- add displayed vertical path during descent after crossing T/D with VNAV engaged
PFD
- add VNAV vertical path
OTHERS
- fixed small issue
SIM COCKPIT BUILDER
- update B738_Commands.txt and B738_Datarefs.txt

2.32:
-----
LIGHTS
- tuned lights (landing, runway turnoff, taxi)
VNAV
- fixed xplane11 bug - sometimes VNAV not descent (I report bug since PB9)
ELECTRIC
- change switches to momentary switches for GEN1, GEN2, APU GEN1 and APU GEN2
SIM COCKPIT BUILDER
- update B738_Commands.txt for electric switches


2.31:
-----
VNAV
- add SPD INTV during descent
FMC
- new direct to waypoint
- edit discontinuity as default FMC

Note:
-----
Direct to waypoint >>> how it works
1/ press <LEGS> button
2/ use <PREV>, <NEXT> and <1LSK> to <5LSK> buttons for select waypoint
3/ press <LEGS> button
4/ press <1LSK> button


2.31 beta:
----------
VNAV
- add SPD INTV during descent

2.30:
-----
VNAV
- fixed VNAV enagaged if before it enagaged LVL CHG
- fixed DESCENT NOW (descent -1000 fpm until reached VNAV path profile)
OTHERS
- fixed small bugs

2.29:
-----
VNAV
- fixed SPD INTV during climb
PFD
- add minimum BARO altitude for captain and first officer
- add flash rectangle for altitude alert
- add flash rectangle for FD, CMD, LAND3 and SINGLE CH
SIM COCKPIT BUILDER
- update commands - see file "B738_Commands.txt"
OTHERS
- fixed small bugs

2.28:
-----
SOUND
- edited default sounds (engines, APU, avionics, flaps, landing gear, wind...)
FMC
- correct descent restriction speed inverse type
PFD
- add BARO altitude minimum on captain side (not working yet)
- fixed flaps bugs on speed tape
OTHERS
- fixed small bugs
- tuned A/P constants

2.27:
-----
ND
- add dashline for VOR1 and VOR2 (captain and first officer)
REVERSE THRUST
- fixed command "Hold thrust reverse at max." (if hold ->reverse thrust max, if release -> reverse thrust off)

2.27a (alpha version):
----------------------
ND
- add dashline for VOR1 vector course

2.26:
-----
AUTOPILOT
- fixed issue with VNAV after reset flight
- fixed some issue with VNAV, VS...
FMC
- add command RESET (FMC) on MENU page (1RSK)
PFD
- fixed rectangle flash animation on PFD
OTHERS
- tested with XPLANE11 RC1


2.25: hot fix for release 2.24
------------------------------
- fixed issue with flight phase cruise
- fixed button lights for VNAV

2.24:
-----
AUTOPILOT
- fixed button lights for VOR/LOC arm, APP arm, ALT HLD, N1
- fixed issue with VNAV engage if MCP ALT is not correct set
- fixed issue with ALT ACQ (sometimes incorrect engaged)
- fixed annunciates on PFD
OTHERS
- correct update file b738.acf


2.23:
-----
AIRCRAFT
- tuned autopilot constants
REVERSE THRUST
- locked reverse thrust when thrust lever is not idle (vice versa)
AUTOBRAKE
- fixed bug with autobrake
AUTOLAND
- tweak autoland
OTHERS
- fixed small bugs

2.22:
-----
AUTOPILOT
- add ALT ACQ to VNAV climb and descent
- corrected annunciate VNAV climb pitch mode to VNAV SPD
- fixed some issue with VNAV engaged
OTHERS
- fixed small bugs


2.21:
-----
AUTOLAND
- fixed bug and tweak autoland for smooth landing
SIM COCKPIT BUILDER
- update B738_Datarefs.txt
OTHERS
- fixed small bugs (FMC, A/P...)
- tweak some value in acf file
- tested with XPLANE11 PB17


2.20:
-----
PFD
- fixed issue with VOR/LOC annun if A/P off
AUTOPILOT
- tweak autoland for smooth landing
OTHERS
- fixed small bugs
- tested with XPLANE11 PB16 

2.19: (need clean install or delete folder B738-800X/plugins/xlua/scripts/B738.sim_cockpit)
-----
SIM COCKPIT BUILDER
- fixed datarefs for landing gear
OTHERS
- fixed datarefs for checklist by DrGluck
- any graphics correction
- fixed small bugs

2.18:
-----
AUTOPILOT
- fixed bug in autoland code and tweaked
SIM COCKPIT BUILDER
- add commands for engines mixture

2.17:
-----
AUTOPILOT
- fixed bug in autoland code and tweaked
SIM COCKPIT BUILDER
- update Datarefs and Commands (See files B738_Datarefs.txt and B738_Commands.txt)

2.16:
-----
AUTOPILOT
- fixed issue with APP and AUTOLAND disconnect
- fixed small issue with ALT ACQ
- fixed bug in autoland code (it will be tweaked yet)
PFD
- correct animation ILS test for AUTOLAND
OTHERS
- tweak fuel flow for ASDG flight model
- fixed others small bugs

2.15:
-----
PFD
- change animation for recangle throthle, roll and pitch mode
AUTOPILOT
- fixed ALT ACQ mode
COM2
- fixed frequency down kHz
OTHERS
- fix issue with course for pilot and copilot
- fixed others small bugs

2.14:
-----
FLIGHT MODEL
- ASDG flight model
PFD
- add annunciates LNAV/VNAV, LOC/VNAV for copilot
OTHERS
- takeoff thrust correctly calculate by PI (26K, 24K, 22K, RED 26K, RED 24K, RED 22K)
- navigation VHF NAV switch works correctly
- fixed others small bugs

2.13b: ASDG flight model
------
FMC
- add display speed restriction in climb phase
VNAV
- fixed some issue with manage speed
PFD
- correction radio height as real
OTHER
- fixed bugs


2.12b: ASDG flight model
------
- the same as version with default flight model
- fix issue with oscillation


2.12: (default flight model)
-----
FMC
- fixed issue with position N,S and E,W
- fixed some issue with next and prev button
- fixed issue with Drag required
AUTOPILOT
- new code for manage climb and cruise speed
VNAV
- fixed annunciates ALT ACQ


2.11b2 (beta)
- hot fix for roll oscillation
VNAV
- fixed issue with descent before E/D point
- fixed annuciates ALT ACQ

2.11b: (beta)
------
- add flight model by AeroSimDevGroup

2.11:
-----
VNAV
- fixed issue with clearence altitude during climb
- fixed some issue with descent and early descent
OTHERS
- fixed some issue with flight phase
- fixed small bugs 

2.10:
-----
VNAV
- fixed issue with climb and speed restriction
- fixed issue with VNAV at end of descent
- correction path angle for descent
FMC
- fixed issue with set cruise altitude on climb and cruise pages
PFD
- graphics corrections
OTHERS
- fixed small bugs


2.09:
-----
VNAV
- add annunciates LNAV/VNAV and LOC/VNAV on PFD (on captain side only)
- add features LNAV/VNAV and LOC/VNAV (you can test for bugs report)
FMC
- add VNAV PTH track error to Descent page
OTHERS
- fixed small bugs

2.08:
-----
VNAV
- add Descent now feature
- add clearence altitude for descent
- add VOR LOC + VNAV PATH, APP + VNAV (test version - you can try it)
MFD
- add VNAV Path
OTHERS
- fixed small bugs
- tested with XPLANE11 PB14

2.07:
-----
AUTOLAND
- rewrite engine for autoland (will be tweak yet)
OTHERS
- fixed small bugs

2.06:
-----
FMC
- add format for AOT end OAT 
    valid format for Celsius: x, xx, xC, xxC, /x, /xx, /xC, /xxC
    valid format for Fahreinheit: xF,xxF, /xF, /xxF
TCAS
- TA/RA systems - calculation completed (without aural and sound alert)
Note:
TCAS RA below 1000 ft (AGL) is automatically inhibited.

2.05:
-----
TCAS
- fixed issue with TA/RA calculation for aircraft with declared on ground
- fixed graphics issue
Note:
(Vertical tau not calculate yet.)

2.04:
-----
TCAS
- fixed calculation TA/RA
SIM COCKPIT BUILDER
- update commands list (B738_Commands.txt)

2.03:
-----
FMC
- correct displayed target speeed after press SPD INTERV on climb and cruise pages (xxx/MCP)
TCAS
- improved graphics (arrows, range)
- add TCAS TEST graphics
- add TRAFFIC message to ND
- fixed issue with diplayed airplanes and improved calculation (TA/RA)
- fixed some bugs
ND
- improved graphics (center mode magenta dash line)

2.02:
-----
TCAS
- new TCAS system (working on captain side EFIS only)
Not implemented:
- no sound alert
- no alert message "TRAFFIC"
- 10 aircraft only

2.01:
-----
FMC
- add T/D for descent page
- add message DRAG REQUIRED
VNAV
- add SPD INTRV feature (for climb and cruise only)

2.00:
-----
ND
- add magenta dash line to HDG sel
FMC
- add forecast descent page (some data are static)
- add correction altitude and levels

1.99:
-----
EFIS
- add real function Barometer set for captain and first officer
PFD
- add annunciates for barometer setting
- add preselect barometer setting

1.98:
-----
AUTOBRAKES
- new brakes system with tweak brake forces
- fixed autobrakes
PFD
- add annunciate LAND 3
- correct displayed VREF speed bug
AUTOLAND
- little tweak autoland

1.97:
-----
AUTOLAND
- fixed issue with autoland
LIGHTS
- tweak lights slightly
OTHERS
- optimalization some panel textures

1.96:
-----
FMC
- add change descent speed
- add select ECON descent mode
IRS
- fixed issue with alignment in bad weather
OTHERS
- fixed some small issue
KNOWN ISSUE
- issue with pie for N1,EGT, N2

1.95:
-----
FMC
- add descent pages (some data are static and no entry for change speed yet)
- add simply calculation for ECON SPD DES mode
- add temporary access to DIR INTC page (in flight go to LEGS page and press button 1L..5L)
EICAS
- oil press is displayed on Lower DU for idle thrust
IRS
- fixed issue with displayed groundspeed (was limited to 400 kts)
OTHERS
- fixed some small issue
KNOWN ISSUE
- no pie for N1,EGT, N2

1.94: hot fix
-----
FMS
- fixed issue with key "A"
- fixed issue with key "Q" and "R" (swap)

1.93:
-----
EFIS
- add green arc for V/S mode on first officer side
FMC
- add simply calculation T/C time and distance
ENGINES
- new code for engines idle modes (new model XPLANE11 PB12)
OTHERS
- integrated default FMC to 3D FMC (on captain side for pages in development)
- improved stability for SPEED mode
- tested with Xplane 12 PB12
KNOWN ISSUE
- no pie for N1,EGT, N2

1.92:
-----
EFIS
- add green arc for V/S mode
EICAS
- add assumed temperature for takeoff thrust
- add annunciates TAI for engines (Thermal Anti-Ice)
OTHERS
- hot fix for Xplane11 PB12


1.91:
-----
FMC
- calculation Vspeeds V1, Vr, V2 (RED 26K, RED 24K, RED 22K - ALT - TEMP - RWY COND), runway wind and slope adjustments not implemented yet
- add wind direction and speed on cruise pages
- add simply calculation T/D time
- add simply calculation cruise climb time and distance
- add simply calculation cruise descent time and distance
ENGINE IDLE MODE
- fixed issue with engine idle mode
OTHERS
- fixed issue with COURSE on captain and first officer side (Xplane11 bug)

1.90:
-----
FMC
- graphics corrections (add inverse type, small corrections on pages)
- add change cruise altitude in CLB mode
- add change climb speed and cruise speed
- add working ECON speeds: ECON CLB and ECON CRZ (only simply calculation yet)
- fixed FMC logic display pages
OTHER
- fixed some small issue

1.89:
-----
AUTOPILOT
- add animation for buttons SPD INTV and ALT INTV
FMC
- add change cruise altitude with ALT INTV button
OTHER
- fixed some small issue

1.88:
-----
FMC
- add max altitude calculation - cruise page
- add change new cruise altitude in CRZ CLB and CRZ DES mode
VNAV
- fixed issue with crossover altitude
OTHER
- fixed some small issue

1.87:
-----
FMC
- add pages cruise climb, cruise des (some data are static yet)
- add EXEC button lights
VNAV
- small fixes
ENGINE IDLE MODES
- fixed for ground operations
OTHERS
- fixed some small issue

1.86:
-----
VNAV
- rewrite VNAV code
FMC
- rewrite thrust modes code
- add climb page (only 1 of 2 - some data are static)
- add cruise page (only 1 of 6 - some data are static)
OTHERS
- fixed some small issue

1.85:
-----
A/T
- fixed issue with enagage LVL CHG
- fixed issue with thrust ratio for SPEED mode
- fixed TAKEOFF mode command FD to speed V2 + 20
VNAV
- add command speed to V2+20 (until acceleration height)
- add command speed to flaps speeds (230 kts or less when leading edge flaps are not fully retracted)
FMC
- calculation Vspeeds V1, Vr, V2 (26K, 24K, 22K -- ALT -- TEMP -- DRY, WET), runway wind and slope adjustments not implemented yet

1.84:
-----
VNAV
- add alert sound when VNAV automatically disengaged
- fixed small issue when sometimes VNAV not descent automatically
A/T
- fixed small issue with animation a throttle ratio
OTHERS
- fixed some small bugs

1.83:
-----
A/T
- new code for A/T throttle with N1 limit mode (will be tuned yet for better precission)
VNAV
- fixed some issue with VNAV
FMC
- calculation Cruise thrust
- calculation optimal altitude (TRIP)

1.82:
-----
FMC
- calculation Go Around thrust
OTHERS
- fixed some small bugs

1.81:
-----
FMC
- calculation Takeoff thrust (full thrust 26K and assumed temp reduced thrust RED 26K only)
- calculation Climb thrust
- add new messages alert
EICAS
- correct temperature to TAT

1.80:
-----
N1 engine
- new engine for manage N1 thrust with N1 limits
VNAV
- new code for climb and cruise - not default VNAV engine (no more speeds change at climb and cruise alt)
FMC
- add message alert sound for new messages (ENTER IRS POS, ENTER IRS HDG, RESET MCP ALT)

Note:
5 NM before TOD, FMC displayed message RESET MCP ALT and plays alert sound


1.79:
-----
FMC
- <Takeoff> pages completed
- <Approach> page completed
OTHERS
- tested with Xplane 11 PB10

Note for Approach page:
GW => entry weight or press 1L button for entry from xplane
Select Vref => selecting Vref with 1R, 2R or 3R large font displayed speed Vref and next select save Vref to 4R
Manual entry Vref => Entry flap and speed and press button 4R (format: FF/, SSS, /SSS, FF/SSS), speed > Vref40 and < Vref15
Wind correction => default +5 kt, maximum +20 kt (format: S, SS)

1.78:
-----
EICAS
- fixed bug - correct N1 thrust set displayed
FMC
- N1 Limit pages completed (on ground, in flight) - thrust not calculate yet
- fixed auto thrust mode logic
OTHERS
- fixed issue with A/T N1 mode with LVL CHG engaged if AP off

1.77:
-----
PFD
- add annunciate NO VSPD
EICAS
- add bug for N1 limit
- add annunciates MAN, TO, TO-1, TO-2, D-TO, D-TO 1, D-TO 2, CLB, CLB 1, CLB 2, CRZ, GA, CON
- N1 thrust limit set now working
FMC
- add N1 thrust modes (thrust not calculate yet, it is predefined)
- connect to default FMC for some pages (RTE, LEGS, FIX, HOLD, PROG, CLB, CRZ, DES)
OTHERS
- fixed issue with speed tape annunciates
- fixed isuue with graphics on MCP (move slightly up display graphics)
- fixed some small isuue

1.76:
-----
FMC
- <Perf Init> snd <Perf Limits> pages completed
IRS
- fixed small bugs

1.75:
-----
FMC
- <Pos init> and <Pos Ref> pages completed

1.74:
-----
FMC
- pages Menu, Ident, Pos init, Init/Ref, Takeoff, Approach, Perf Init, N1 limit
- brithnes with knobs on FMC
- V speeds bugs setting via Takeoff (flaps 1,5,15) and Approach pages (flaps 15,30,40)
- units lbs or kgs (select on Menu page)
- mapping all keys as real (DIR INTC-> Menu, FIX-> N1 Limit...)
- calculation TRIM from CG, weight and flaps
- calculation Vspeeds from pressure alt, flaps, weight, outside temp
IRS SYSTEM
- fixed some issue with logic, graphics, annunciates


1.73:
-----
IRS SYSTEM
- new logic IRS system
- working modes: OFF, ALIGN, NAV, ATT (without manual entry value - is automatic temporary)
- add annunciate DC ON
- shutdown cycle real time 30 seconnds
- alignment time from 2 to 5 minutes (real 5 to 17 minutes)

1.72:
-----
IRS SYSTEM
- fixed issue when align was able with electric off
- fixed IRS logic
- fixed issue with annunaciates
- change: alignment time to 2 minutes and shutdown cycle to 15 seconds
COCKPIT
- smoothly adjust animation knobs

1.71:
-----
IRS SYSTEM
- add general IRS logic
- add ALIGN mode (time for alignment is 5 mins - real time is more)
COCKPIT
- add some switches
OTHERS
- fixed small bugs

1.70:
-----
AUTOPILOT
- fixed isuue with VNAV - smoothly climb (with restrict speed)

1.69:
-----
AUTOPILOT
- fixed some isuue with autoilot logic
- fixed some issue with VNAV
PFD
- add annunciates IAS disagree and ALT disagree
OTHERS
- add switch No Smoking
- add switches CAB UTIL, IFE/PASS SEAT, Fuel flow (only animation)

1.68:
-----
AUTOPILOT
- fixed issue with all modes Takeoff, A/P GoAround (after touchdown), F/D GoAround
- fixed issue with Flight director for Takeoff without F/D on
OTHERS
- fixed cockpit lights at night after flight starts
- fixed small bugs


1.67:
-----
AUTOPILOT
- fixed issue with VNAV - automatic descent below cleared MCP altitude
- add: F/D Takeoff can engaged without F/D switches off, if speed > 80kts and altitude below 2000ft RA
  and to 150 seconds after lift-off
- add: A/P GoAround after touchdown (you can engage A/P GoAround to 2 seconds after touchdown)
LOWER DU
- fixed issue with brightness switch for Lower DU
OTHERS
- fixed small bugs
- testing with XPLANE 11 PB9

1.66:
-----
AUTOPILOT - VNAV
- fixed issue if speed change to mach
- fixed issue on PFD annunciates N1 if thrust is set to N1
- fixed issue with set cleared altitude to MCP

1.65:
-----
AUTOPILOT
- new VNAV code with default FMS (implemented descent after T/D point)
- fixed some issue with F/D with LVL CHG mode

1.64:
-----
EICAS
- add brake temp on display lower unit (simply calculation)
AUTOBRAKES
- improved little autobraked forces
- improved RTO brakes forces
- fixed small issue with engaged autobrakes and RTO
OTHERS
- fixed small bugs

1.63:
-----
EICAS
- display lower unit (will be add brake temp later)
- centered engine page on display lower unit
SIM COCKPIT BUILDER
- add datarefs for A/P and others (see B738_Datarefs.txt)
OTHERS
- fixed small bugs

1.62:
-----
AUTOBRAKES
- improved autobraked forces (lower)
LIGHTS
- improved lights - brithness (landing, runway, taxi lights)
- automatic cockpit lights after reload flight in night (forward panel, glareshield, dome light)
SIM COCKPIT BUILDER
- add file "B738_Datarefs.txt" (A/P lights only - to be add)

1.61:
-----
AUTOLAND
- new code for autoland (FLARE begins at 50 ft RA)
CALCULATION
- precission calculate V1,VR, V2, VREF, Vflaps
- precission calculate VREF, Vflaps bugs (correctly speed)
OTHERS
- fixed small bugs

1.60:
-----
- hot fix for autoland

1.59:
-----
AUTOLAND
- smoothly tuned autoland
- fixed issue with glideslope below 400 ft
AUTOBRAKE
- fixed issue with autobrake and RTO (Xplane11 PB8 bug)

1.58:
-----
PFD
- fixed maximum speed limits tape Vmo (340kts) and Mmo (0.85)
AUTOLAND
- new code for autoland
OTHERS
- fixed some small bugs

1.57:
-----
- fixed small bugs (A/P and A/T logic, graphics, PFD...)

1.56:
----
PFD
-add flaps bugs UP, 1, 5, 15
-add 80 kts bug
OTHERS
- hot fix for release 1.55 (PFD not displayed all items)
- tested with XPLANE 11 Public Beta 8

1.55:
-----
AUTOLAND
- tweak autoland (for smoothly landing)
AUTOPILOT
- fixed issue A/P sometimes not engaged after reload aircraft
ENGINE
- tweak code for engines idle rpm logic
PFD
- fixed issue with red/black tapes and amber lines (maneuver speeds)

1.54
----
AUTOLAND
- tweak autoland (for smoothly landing)
AUTOPILOT
- fixed any issue with A/P and A/T logic
PFD
- add minimum and maximum maneuver speeds
- fixed any animation issue
OTHERS
- tested with XPLANE 11 Public Beta 7

1.53
----
AUTOPILOT A/T A/P
- fixed flight director for Takeoff, A/P Go-Around and F/D Go-Around modes
- fixed issue with ALT HLD light button
AUTOLAND
- fixed autoland (smoothly landing) and flight director

1.52
----
AUTOLAND
- fixed issue autoland can engaged without F/D on
- add ILS test (if engages both A/P and glideslope captured annunciates VOR/LOC and G/S are flashing about 5 seconds)
- tweak autoland smoothly
AUTOPILOT
- fixed issue APP logic (approach mode)
OTHERS
- fixed issue with F/D, if A/P engaged
- fixed some small bugs (A/P logic, A/T logic, PFD ...)

1.51
----
AUTOPILOT A/T A/P
- fixed issue A/P GA if push twice T/GO button, speed flaps limit inhibited (N1 Go-Around thrust)
- add F/D GA (Go-Around) mode (MFD ENG is TEMPORARY -> TO/GA button or use default commnand "Autopilot take-off go-around")
OTHERS
- fixed some small bugs


1.50
----
AUTOPILOT A/T
- fixed issue A/P GA if engaged above 400 ft
- default approach altitude = 4000 ft (for setting: use DataRefEditor > "laminar/B738/autopilot/fmc_approach_alt")
PFD
- add annunciates ALT ACQ
- fixed isuue with animation
OTHERS
- fixed some small bugs

1.49
----
AUTOPILOT A/T
- add A/P GA (goaround) mode (MFD ENG is TEMPORARY -> TO/GA button)
- replace default command "Autopilot take-off go-around" (you can use deffault command now)
- fixed issue LVL VHG enable engaged, if set altitude to MCP alt dial > or < 200 ft as aircraft altitude
AUTOLAND
- new autoland code (it will be tuned)
PFD
- fixed issue flaps maneveur speed tape displayed if you are flying only

1.47
----
- hot fixed issue with TAKEOFF mode with RTO armed
1.46
----
AUTOPILOT A/T
- new code for A/T logic
- add TAKEOFF mode (MFD ENG is TEMPORARY -> TO/GA button)
PFD
- change V2+15 to V2+20
OTHERS
- fixed some small bugs with autopilot logic and PFD graphics

1.45
----
AUTOPILOT
- change minimum speed for MCP airspeed dial
OTHERS
- fixed some small bugs with autopilot logic and PFD graphics

1.44
----
AUTOPILOT
- fixed issue with V/S pitch mode

1.43
----
PFD
- add V1, VR, V2+15, VREF bugs
Note:
- simply calculation V1, VR, V2+15, VREF
- default takeoff flaps = 5, approach flaps = 40
- setting takeoff and approach flaps via DataRefEditor plugin only
  (laminar/B738/FMS/takeoff_flaps, laminar/B738/FMS/approach_flaps)
  takeoff flaps: 1, 2, 5 only
  approach flaps: 15, 30, 40 only

1.42
----
AUTOPILOT
- add A/P and A/T disengage lights flashing, if disengaged
- fixed any others issue
- known issue disengage FMS light flashing with A/T disengage light
PFD
- fixed issue with rectangle animation, if a/p engaged with selected roll and pitch modes


1.41
----
ENGINE
- fixed any issue with idle logic
AUTOPILOT
- fixed isuue, after LVL CHG disengaged, thrust leveler working now
- fixed issue, now Autoland can engaged with both F/D> ON only
- fixed issue, disconnect A/P not disengage A/T and SPEED mode
- fixed issue, if SPEED engaged then you can change speed mode to N1 now
- fixed issue, if glideslope capture then ALT HOLD mode is inhibited
- fixed any others issue
PFD
- fixed isuue with graphics FD (Flight director)
OTHERS
- tested with XPLANE PB6

1.40
----
ENGINE
- fixed code for engines idle rpm

1.39:
-----
ENGINE
- tweak engine idle rpm
- raise N1 thrust
PFD
- fixed some issue with graphics, if A/P is off
AUTOPILOT
- fixed some small issue with buttons lights
SIM COCKPIT BUILDER
- add custom commands: Landing gear down, Landing gear up, Landing gear off, Landing gear down one, Landing gear up one

1.38:
-----
ENGINE and AIR BLEED
- new code for engines idle rpm logic N1 and N2 (ground, flight and approach mode)
- fixed issue with left duct and right duct air bleed
PFD
- fixed issue graphics for V/S arm
- known issue with graphics on PFD, if A/P is off
AUTOPILOT
- new autopilot logic

1.37:
-----
ENGINE
- new code for engines idle rpm logic N1 and N2 (ground, flight and approach mode)

1.36:
-----
- fixed issue with engines start levers

1.35:
-----
SPEEDBRAKE
- fixed after RTO code
ENGINE
- fixed issue after landing, if thrust reverse used to 4 seconds after landing then engine idle mode not change to ground
  it will change to ground idle mode after reverse thrust deactivated (after 4 seconds)

1.34:
-----
LANDING GEAR
- add landing gear limit operating for landing gear systems
ENGINE
- new code for engines idle rpm logic N1 and N2 (ground, flight and approach mode)
SPEEDBRAKE
- after landing, if SPEED BRAKE lever is in the ARMED position, then SPEED BRAKE lever automatically moves to the UP.
- after an RTO or landing, if SPEED BRAKE lever is in the DOWN position and these condition occur:
   - landing gear wheels spin up more than 60 kts
   - both thrust levers are retarded to IDLE
   - reverse thrust lever are positioned fo reverse thrust
  then SPEED BRAKE lever automatically moves to the UP.
- after an RTO or landing, if SPEED BRAKE lever is in the UP and thrust is not idle, then SPEED BRAKE lever automatically moves to the DOWN.


1.33:
-----
PFD
- fixed issue with animation, if autoland engaged

1.32:
-----
ENGINE
- engines idle rpm logic N1 and N2 (ground, flight and approach mode)

1.31:
-----
FUEL PUMP
- fixed fuel pump LOW PRESSURE lights for Center tanks and Main tanks
Center tanks:
illuminated - fuel pump output pressure is low and Fuel pump switch is on
extinguished - fuel pump output pressure is normal or Fuel pump switch is off
Main tanks:
illuminated - fuel pump oytput pressure is low or Fuel pump switch is off
extinguished - fuel pump output pressure is normal

SIM COCKPIT BUILDER
Fuel pumps datarefs
- Dataref: "laminar/B738/fuel/fuel_tank_pos_lft1" => 0-off, 1-on
- Dataref: "laminar/B738/fuel/fuel_tank_pos_lft2" => 0-off, 1-on
- Dataref: "laminar/B738/fuel/fuel_tank_pos_ctr1" => 0-off, 1-on
- Dataref: "laminar/B738/fuel/fuel_tank_pos_ctr2" => 0-off, 1-on
- Dataref: "laminar/B738/fuel/fuel_tank_pos_rgt1" => 0-off, 1-on
- Dataref: "laminar/B738/fuel/fuel_tank_pos_rgt2" => 0-off, 1-on

1.30:
-----
AUTOBRAKE RTO
- if AUTOBRAKE set to RTO in air, AUTOBRAKE not engaged and AUTO BRAKE DISARM light illuminates after touchdown
APU
- fixed if start delay running (APU still not running) and switch to OFF, then APU starting off
ENGINE START
- new starting engine code

1.29:
-----
AUTOBRAKE RTO
- fixed AUTOBRAKE RTO release to OFF after takeoff

----
1.28:
-----
ENGINE START
- fixed starting engines
SIM COCKPIT BUILDER
- Dataref: "laminar/B738/engine/starter1_pos" => 0-GRD, 1-AUTO, 2-CNT, 3-FLT
- Dataref: "laminar/B738/engine/starter2_pos" => 0-GRD, 1-AUTO, 2-CNT, 3-FLT
- Dataref: "laminar/B738/toggle_switch/bleed_air_1_pos" => 0-off, 1-on
- Dataref: "laminar/B738/toggle_switch/bleed_air_2_pos" => 0-off, 1-on
- Dataref: "laminar/B738/toggle_switch/bleed_air_apu_pos" => 0-off, 1-on
- Dataref: "laminar/B738/air/l_pack_pos" => 0-off, 1-on
- Dataref: "laminar/B738/air/r_pack_pos" => 0-off, 1-on
- Dataref: "laminar/B738/air/isolation_valve_pos" => 0-close, 1-auto, 2-open

1.27:
-----
ENGINE START
- temporary fixed starting engines

1.26:
-----
AUTOPILOT
- fixed throttle ratio, if you move joy throttle for N1, LVL CHG and VNAV modes
SIM COCKPIT BUILDER
- Dataref: "laminar/B738/controls/gear_handle_down" => 0-up, 0.5-off, 1-down
- add list of custom commands - file "B738_Commands.txt"

1.25:
-----
MCP
- flashing "8", if MCP speed dial is above flaps, landing gear or Vmo limits
- flashing "A", if MCP speed dial is under minimal maneuver flaps limit

1.24
----
AUTOLAND
- A/T disengaged 2 seconds after touchdown
- fixed smoothly autoland touchdown

1.23
----
GENERAL
- fixed missing files
- tested with Public beta 5
PFD
- fixed annunciator for LVL CHG and VNAV mode, if aircraft descent then PFD change RETARD to ARM after engines are idle


1.22
----
AUTOPILOT
- fixed issue with N1 mode after reload aircraft with engaged N1 (N1 hangs)
PFD
- add Vmo and Mmo speed limits
- add minimal maneuver flaps speed limits

1.21
----
SYSTEM
- deactivated protection system: flaps extend and gear extend !!!
PFD
- add speed flaps retract limit and gear retract limit

1.20
----
SOUNDS
- change sounds roll on ground and runway from MD80
- change sounds skid dry from MD80
- change sounds flaps from B747
- change sounds gear from B747

1.19
-----
AUTOPILOT - V/S
- now working correctly if armed
FUEL PUMPS
- fixed issue: if you switch fuel pumps sometimes breaks pumps fuel to engine (for one second), and engine off
AUTOBRAKE
- fixed issue: if you use reverse, it autobrakes don't off


1.18
-----
AUTOPILOT - VNAV
- fixed issue with airspeed in mach/kts
- fixed issue if you VNAV engaged via fly
AUTOPILOT - ALT HLD
- fixed if engaged ALT HLD then A/P engaged SPEED mode too

1.17
-----
ANTI ICE
- add animation for anti ice valves for wings and engines (if you turn on anti ice, valve is open - bright, and then dim if no icing)
AUTOPILOT - VNAV
- You can enter data to FMS conventional methods
AUTOPILOT - V/S
- if you press V/S button : V/S engaged with actual vertical speed to target MCP altitude
- In ALT HOLD mode: select target MCP altitude, select MCP vertical speed (V/S arm illuminated), 
and press V/S button for engage V/S mode with selected MCP vertical speed to target MCP altitude


1.16
-----
AUTOPILOT
- add automatic change kts to mach and mach to kts (crossover altittude FL260)
- fixed for default VNAV light
For use default VNAV > both EFIS VOR 1 and EFIS VOR 2 set to INOP!!!
AUTOLAND
- fixed smoothly autoland
VNAV
- fixed for FMS mach speed - climb, cruise, descent (crossover altitude implemented)

1.15
-----
AUTOPILOT - VNAV - with default FMS (automatic descent not impemented)
- smoothly change target FMC SPD
- default CRUISE ALTITUDE = 20000 ft, DESCENT ALTITUDE = 4000 ft
- issue convertion mach to kts (i need formulas)

Instruction:
1/ Open default FMS
2/ Fill flightplan.
3/ Select SID and STAR.
4/ Press CLR button for clear message
5/ Press CLB (CLIMB PAGE) and set Target speed (format KKK for kts or /.MM for mach), Restriction (format KKK/AAAA or KKK/AAAAA) 
6/ Press CRZ (CRUISE PAGE) and set Target speed (format KKK for kts or /.MM for mach), Cruise altitude (format AAAA or AAAAA or FLAAA)
7/ Press DES (DESCENT PAGE) and set Target speed (format KKK for kts or /.MM for mach), Restriction (format KKK/AAAA or KKK/AAAAA)
For setting value use direct CLB, CRZ, DES only.

8/ Set on MCP alt your cleared altitude.
9/ Take off and engage A/P and VNAV
10/ Aircraft climb to MCP altitude
11/ Set on MCP next your cleared altitude.
12/ Aircraft climb to MCP altitude.
...
13 / If your MCP altitude >= cruise altitude, then your aircraft set speed to cruise speed.
14/ Set on MCP your cleared altitude.
15/ If you are on T/D point (not implemented), press LVL CHG (If you VNAV on and at cruise altitude, VNAV is DESCENT NOW button temporary).
16/ Aircraft descent to MCP altitude
17/ Set on MCP your cleared altitude.
18/ Aircraft descent to MCP altitude
...
 



1.14
-----
- fixed issue with VNAV, if airspeed dial is switch to mach

1.13
-----
- fixed issue with animation on PFD

1.12
-----
PFD
- graphic corrections and animations on PFD for thrust, roll and pitch modes

1.11
-----
AUTOPILOT
- modify LVL CHG
- modify VNAV: only working with preselect value. You can to change with DataRef plugin (CRUISE_ALTITUDE, DESCENT_ALTITUDE, CRUISE_SPEED).
              Descent automatic not implemented. 
              If you are at cruise altitude and VNAV is ON, you must press LVL CHG for DESCENT NOW (VNAV stays turned ON).
              If VNAV is active, IAS dial display is blank.

If you want to use default VNAV, only change EFIS VOR1 and EFIS VOR2 on captain side to position INOP.

1.11b2
-------
- add annunciators PFD for pitch, roll, speed modes
- some correction in code
- fixed N1, VNAV
- add DataRef: fmc_cruise_altitude, fmc_descent_altitude, fmc_cruise_speed (You can change it by DataRef plugin)

1.11b - this is BETA !!!!
-----
AIR BLEED SYSTEM
- fixed some issue with starting right engine

AUTOPILOT
- fixed N1, SPD, ALT HLD, LNAV
   - N1 thrust =  preselect to 95 %
- new new new >>> VNAV for testing <<< new new new
   - preselect cruise altitude = 20000 ft
   - preselect descent altitude = 3000 ft for intercept ILS
   - preselect cruise speed = 320 kts
   - preselect climb and descent speed = 270 kts
   - preselect restriction: under 10000 ft -> speed 250 kts
   - if you are at cruise altitude and VNAV is ON, you must press LVL CHG (it is no change VNAV to off) for DESCENT NOW - (Descent automatic not implemented)
- Autopilot display default annunciators for pitch, roll, speed modes (temporary)
If you open file "XPLANE/Aircraft/Boeing B737-800X/plugins/xlua/scripts/B738.glaresheild/B738.glaresheild.lua"  can change on begin preselect value:
CRUISE_ALTITUDE, DESCENT_ALTITUDE, CRUISE_SPEED, CLIMB_SPEED, DESCENT_SPEED, N1_thrust.

1.10
-----
AUTOBRAKE SYSTEM
- fixed if you land with Autobrake position to RTO: After touchdown AUTO BRAKE DISARM light illuminates.

AUTOPILOT
- temporary fixed if you have LNAV armed or engaged to switch VOR LOC

1.09
-----
- add animation for switches L RECIRC, R RECIRC, TRIM AIR

AUTOBRAKE SYSTEM
- NEW autobrake system independent of default
- mode RTO (Reject Takeoff):
     conditions for arm:
       - airplane on ground
       - switch position to RTO
       - wheel speed < 60 kts
       - thrust idle
     When you switch to RTO, AUTO BRAKE DISARM light illuminates for 1 to 2 seconds and then extinguished (automatic self-test).
     RTO mode is engaged, if wheel speed > 90 kts and thrust are retarded to iddle.
- mode 1 -2 -3 - MAX:
      conditions for arm: on air
      After landing autobrake application begin when:
         - thrust levers are retarded to idle
         - the main wheels spin-up
     If you aplly manual brakes or thrust is not idle, then autobrake disarm and AUTO BRAKE DISARM light illuminates.
- mode OFF:
     Autobrake and RTO disarm.

1.08
-----
- fixed small issue with ENGINE STARTER in mode OFF
- fixed LOW PRESSURE fuel pump

AIR BLEED SYSTEM
- fixed start Engine using other Engine running: L PACK > OFF, R PACK > OFF, Isolation Valve opened (no switch ISOLATION VALVE)

1.07
-----
WINDOW HEAT
- all Window Heat switches are working: Left side, Left front, Right side, Right front

AIR BLEED SYSTEM
- correct ISOLATION VALVE on AUTO mode:
        ISOLATION VALVE closed: ENG 1 BLEED AIR > ON, ENG 2 BLEED AIR > ON, L PACK > AUTO or HIGH, R PACK > AUTO or HIGH
        ISOLATION VALVE opened: otherwise
- if START VALVE engine 1 open -> ENG 1 BLEED AIR VALVE close
- if START VALVE engine 2 open -> ENG 2 BLEED AIR VALVE close

1.06
-----
ENGINE ANTI ICE
- both Engine Anti Ice are on, if engines are runnig. (Left Engine Anti Ice for left engine, Right Engine Anti Ice fo right engine)

WING ANTI ICE
- LEFT wing anti ice system is on, if L DUCT > 15 psi and switch WING ANTI ICE > ON
- RIGHT wing anti ice system is on, if R DUCT > 15 psi and switch WING ANTI ICE > ON
On the ground: if thrust > takeoff thrust (50%) then wing anti ice system is OFF

1.05
-----
- APU generator switches - add APU GEN BUS 1 and  APU GEN BUS 2
- fixed ISOLATION VALVE - it working corectly in all positions
- small fix for smoothly animation DUCT PRESS
- small fix LOW PRESSURE for all hydraulic pumps

1.04
-----
- AIR BLEED SYSTEM done. (only isuue with animation DUCT PRESS)
!!! If DUAL BLEED illuminated (both APU bleed open and ENG bleed open), trust must be on idle (duct max 30 psi), otherwise you can damage APU pressurization !!!

- HYDRAULIC: both hydro pumps and both electric hydro pumps - working

- AUTOLAND: fixed smoothly touchdown

1.04b
----
- beta AIR BLEED SYSTEM - L Pack, R pack, Isolation Valve
(some issue with animation DUCT PRESS, engine can starting with PACK auto or high,...)

1.03
-----
- fixed VOR LOC mode on A/P

1.02
-----
- temporary fixed Autobrakes (all modes: RTO, Off, 1, 2, 3, MAX) for Public Beta 2 (It's a bug)
- modified touchdown for Autoland (...better touchdown in progress...)


1.00-1.01
----------
APU switch
- working starting delay from 30 to 60 second
- shutdown after cooling - delay 60 seconds

FUEL switch
- working all fuel selectors and all fuel pump

ENGINE starter
- working all modes: GRD, OFF, CNT, FLT

MCP
- ALT dial: click = decrease / increase 100 ft
                 hold = decrease / increase 1000 ft
                 mousewheel = increase / decrease 100 ft
- At 350 ft RA: if FLARE not armed then A/P disengage
- beta test:  AUTOLAND function using with default A/P
	Push APP on autopilot, if LOC captured then PFD display: "SINGLE CH"
                  Push second A/P CMD - activated autoland (it must be engaged minimal at 800 ft RA)
	If LOC captured
	At 1500 ft RA - both MASTER lights illumined, PFD display: "CMD". (NAV1, NAV2 and CRS1,CRS must be the same, otherwise Autoland disengaged.)
	At 1300 ft RA - FLARE armed
	At 400 ft RA - autopilot trims gently nose up, FLARE is activated at 50ft RA (maneuvre)
                  At 27 ft RA - autopilot RETARD thrust
	Touchdown - A/P and A/T disconect
	Autoland cancel: push A/P disengage button
- working both flight director with MASTER mode pilot and copilot
- fixed F/D captain and First officer - autopilot master
- fixed CMD A for NAV1, CMD B for NAV2
- fixed disengage A/T, if you takeoff and aircraft jump on runway
- better touchdown (...in progress...)

GEAR leveler
- working: down / up / off - you can use default command  "Landing gear toggle."
