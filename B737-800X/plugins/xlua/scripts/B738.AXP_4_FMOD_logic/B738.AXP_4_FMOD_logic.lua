-- LAST CHANGE: 03-04-2018 by AXP

-------------------------------------------- DEFINING VARIABLES  ---------------------------------------------------------------------------------------
-------------------------- new flight phase and passenger control 1709A +

leg_started = 0
leg_ended = 0

start_leg_commanded = 0
end_leg_commanded = 0


play_belts = 0 
belts_fastened = 0

play_arrival_crosscheck = 0

play_80 = 0


is_hotstart = 0
-- passengers_leave = create_dataref("laminar/b738/fmodpack/flightphase_pax_leave", "number") 
passengers_talk = 0
-- passengers_board
passengers_board = 0


-- is_trip_reset = 0 


-- plane on ground - all wheels
on_the_ground = 0

-- plane on air more than 30 sec and any wheel touch the ground (protect against bump toachdown)
touch_down = 0

-- plane on air more than 30 seconds
was_air_delay = 0

-- plane on ground more than 7 seconds
was_ground_delay = 0

play_landed_ann_armed = 0

-- 1-8-2017 AXP plane has not performed a landing yet
flightphase_landed = 0
flightphase_boarding = 0
flightphase_climb = 0
flightphase_taxi = 0
flightphase_descent = 0
flightphase_cruise = 0
flightphase_pre_takeoff = 0
PAX_premastervolume = 10

flight_leg_finished = 0 
-- 1-8-2017 "1000 to go" callouts have not yet been played (descent and climb)
--togo_climb_played = 0
--togo_des_played = 0
after_takeoff_played = 0
positive_rate_played = 0 
alert_fo_400_played = 0
alert_fo_1000_played = 0
cruise_msg_played = 0
play_welcome_msg = 0
welcome_msg_played = 0
gate_departure_played = 0 
gate_departure_initialized = 0
gate_arrival_initialized = 0
cabindoor_closed = 0 


descent_msg_played = 0 

play_taxi_to_gate = 0
taxi_to_gate_played = 0

ground_time = 0		-- time on the ground 0-30sec
air_time = 0		-- time in the air 0-100 sec

departure_time = 0
arrival_time = 0


plane_on_the_ground = 0

play_dta = 0 

-- 1-8-2017 AXP fire test variables

play_firebells = 0 

play_positive_rate = 0

climb_to_alt = 0 
descend_to_alt = 0

play_seatbelt = 0
play_seatbelt_10k = 0

passengers_leave = 0
passengers_talk = 0

-----------------------------------
-- load state

load_effect = 0
N1_current = 0
N1_factor = 0
sink_factor = 0

-----------------------------------

fire_handles_lights = 0

--------------------------------------

-- FA in cockpit

FA_departure_time = 0
FA_leo_time = 0
FA_max_time = 300

-- laminar/B738/push_button/flt_dk_door_close

-------------------------------------------- FINDING COMMANDS ---------------------------------------------------------------------------------------

close_fdd = find_command("laminar/B738/push_button/flt_dk_door_close")

-------------------------------------------- FINDING DATAREFS ---------------------------------------------------------------------------------------

--- DEV

is_dev_event = find_dataref("axp/dev_event")


--- DEV

FAC_volume = find_dataref("laminar/b738/fmodpack/fmod_vol_FAC")

-- new menu controls
start_leg_commanded = find_dataref("laminar/b738/fmodpack/fmod_start_leg")
end_leg_commanded = find_dataref("laminar/b738/fmodpack/fmod_end_leg")

cargo_play_state = find_dataref("laminar/b738/fmodpack/fmod_play_cargo")

replay_mode_on = find_dataref("sim/time/is_in_replay")

busloadamps = find_dataref("sim/cockpit2/electrical/bus_load_amps[0]")
gpu_avail = find_dataref("laminar/B738/gpu_available")
apu_gen        = find_dataref("sim/cockpit/electrical/generator_apu_on")
gpu_on        = find_dataref("sim/cockpit/electrical/gpu_on")
apu_temp      = find_dataref("laminar/B738/electrical/apu_temp")
standbypwr    = find_dataref("sim/cockpit2/electrical/battery_on[1]")
-- minimums    = find_dataref("sim/cockpit/misc/radio_altimeter_minimum")
ft_agl   = find_dataref("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot")
fpm  = find_dataref("sim/flightmodel/position/vh_ind_fpm")

left_pack  = find_dataref("laminar/B738/air/l_pack_pos")
right_pack  = find_dataref("laminar/B738/air/r_pack_pos")

cab_util = find_dataref("laminar/B738/toggle_switch/cab_util_pos")

pressure_L = find_dataref("laminar/B738/indicators/duct_press_L")
pressure_R = find_dataref("laminar/B738/indicators/duct_press_R")

recircLon = find_dataref("laminar/B738/air/l_recirc_fan_pos")
recircRon = find_dataref("laminar/B738/air/r_recirc_fan_pos")

bleed_valve_L = find_dataref("laminar/B738/toggle_switch/bleed_air_1_pos")
bleed_valve_R = find_dataref("laminar/B738/toggle_switch/bleed_air_2_pos")
bleed_valve_APU = find_dataref("laminar/B738/toggle_switch/bleed_air_apu_pos")

eng_genL  = find_dataref("sim/cockpit/electrical/generator_on[0]")
eng_genR  = find_dataref("sim/cockpit/electrical/generator_on[1]")

is_eng1_on = find_dataref("sim/flightmodel/engine/ENGN_running[0]")
is_eng2_on = find_dataref("sim/flightmodel/engine/ENGN_running[1]")

is_eng1_starter = find_dataref("sim/flightmodel2/engines/starter_is_running[0]")
is_eng2_starter = find_dataref("sim/flightmodel2/engines/starter_is_running[1]")

vvi_dial_show		= find_dataref("laminar/B738/autopilot/vvi_dial_show")
vvi_dial			= find_dataref("sim/cockpit2/autopilot/vvi_dial_fpm")

spd_dial_show		= find_dataref("laminar/B738/autopilot/show_ias")
spd_dial			= find_dataref("sim/cockpit2/autopilot/airspeed_dial_kts_mach")

-- datarefs for after landing announcements (not needed for that anymore but used by other functions)
is_autospeedbrake_up = find_dataref("sim/flightmodel/controls/sbrkrat")
is_plane_onground =  find_dataref("sim/flightmodel/failures/onground_any")
current_gs = find_dataref("sim/flightmodel/position/groundspeed")
-- datarefs for V1 alert
calculated_V1 =  find_dataref("laminar/B738/FMS/v1_calc")
autobrake_status = find_dataref("laminar/B738/autobrake/autobrake_pos")
-- TO config and Cabin altitude warnings
alt_horn_cut_disable	= find_dataref("laminar/B738/alert/alt_horn_cut_disable")
cabin_alt				= find_dataref("sim/cockpit2/pressurization/indicators/cabin_altitude_ft")
to_config				= find_dataref("laminar/B738/system/takeoff_config_warn")
-- Below G/S warning
below_gs_disable		= find_dataref("laminar/B738/alert/below_gs_disable")
below_gs_warn			= find_dataref("laminar/B738/system/below_gs_warn")
chosen_airport_set = find_dataref ("laminar/b738/fmodpack/fmod_airport_set")

--- datarefs for fuel pump detection and battery on?

fuel1 = find_dataref("laminar/B738/fuel/fuel_tank_pos_lft1")
fuel2 = find_dataref("laminar/B738/fuel/fuel_tank_pos_lft2")
fuel3 = find_dataref("laminar/B738/fuel/fuel_tank_pos_ctr1")
fuel4 = find_dataref("laminar/B738/fuel/fuel_tank_pos_ctr2")
fuel5 = find_dataref("laminar/B738/fuel/fuel_tank_pos_rgt1")
fuel6 = find_dataref("laminar/B738/fuel/fuel_tank_pos_rgt2")
bat_on = find_dataref("sim/cockpit/electrical/battery_on")



-- for fuel pumps
simDR_bus_volts1		= find_dataref("sim/cockpit2/electrical/bus_volts[0]")
simDR_bus_volts2		= find_dataref("sim/cockpit2/electrical/bus_volts[1]")
-- for V1 callout
fms_v1			= find_dataref("laminar/B738/FMS/v1")
simDR_airspeed_pilot	= find_dataref("sim/cockpit2/gauges/indicators/airspeed_kts_pilot")
v1r_bugs		= find_dataref("laminar/B738/FMS/v1r_bugs")

-- NEW 1-8-2017 AXP  for rotate callout
fms_vr = find_dataref("laminar/B738/FMS/vr")

-- NEW 1-8-2017 AXP for 400 and 1000 call-outs at takeoff

vvi_fpm = find_dataref("sim/cockpit2/gauges/indicators/vvi_fpm_pilot")

-- NEW 1-8-2017 AXP for "1000 to go" callout
efis_alt = find_dataref("sim/cockpit2/gauges/indicators/altitude_ft_pilot") -- displayed altitude
fmc_descent_alt = find_dataref("laminar/B738/autopilot/fmc_descent_alt")

fmc_ed_alt = find_dataref("laminar/B738/fms/ed_alt")

-- NEW 1-8-2017 AXP refs to help determine the flight phase

fuel_cutoff1 = find_dataref("laminar/B738/engine/mixture_ratio1")
fuel_cutoff2 = find_dataref("laminar/B738/engine/mixture_ratio2")
tc_dist = find_dataref("laminar/B738/fms/vnav_tc_dist")
tc_show = find_dataref("laminar/B738/nd/tc_show")
mcp_alt = find_dataref("sim/cockpit2/autopilot/altitude_dial_ft")
fmc_cruise_alt = find_dataref("laminar/B738/autopilot/fmc_cruise_alt")

seatbelt_auto = find_dataref("laminar/B738/toggle_switch/seatbelt_sign_pos")

fmc_flight_phase = find_dataref("laminar/B738/FMS/flight_phase")

landing_lights_on = find_dataref("laminar/B738/switch/land_lights_ret_left_pos")


flightdeck_door_open = find_dataref("laminar/B738/toggle_switch/flt_dk_door")
PA_mic_on = find_dataref("laminar/B738/audio/capt/mic_button6")

-- ********************** refs to calculate gear warning (1 = down, 0 = up) audiobirdxp

gear_nose	= find_dataref("sim/flightmodel/movingparts/gear1def")
gear_main1	= find_dataref("sim/flightmodel/movingparts/gear2def")
gear_main2	= find_dataref("sim/flightmodel/movingparts/gear2def")
ias			= find_dataref("sim/flightmodel/position/indicated_airspeed")


-- ********* refs to calculate pre landing announcement trigger 7-8-2017 *******
-- 1-8-2017 AXP change ed_dist to ed_to_dist
ed_dist				= find_dataref("laminar/B738/fms/ed_to_dist")
ed_found			= find_dataref("laminar/B738/fms/ed_idx")
offset				= find_dataref("laminar/B738/fms/vnav_idx")
simDR_fmc_dist2		= find_dataref("laminar/B738/fms/lnav_dist2_next")
B738_legs_num		= find_dataref("laminar/B738/vnav/legs_num")



-- ********************** refs to suppress touch_down going to 1 while taxiing

is_taxi = find_dataref("sim/cockpit2/switches/generic_lights_switch[4]")
is_anticollision_on = find_dataref("sim/cockpit/electrical/beacon_lights_on")

-- NEW 1-8-2017 AXP refs to play fire alarms correctly

is_light_test = find_dataref("laminar/B738/toggle_switch/bright_test")

is_apu_fire = find_dataref("laminar/B738/annunciator/apu_fire")
is_cargo_fire = find_dataref("laminar/B738/annunciator/cargo_fire")
is_eng1_fire = find_dataref("laminar/B738/annunciator/engine1_fire")
is_eng2_fire = find_dataref("laminar/B738/annunciator/engine2_fire")


-- for diverse

flight_time = find_dataref("sim/time/total_flight_time_sec")

-- seatbelt auto

flap_pos = find_dataref("sim/flightmodel/controls/flaprqst")
gearhandle_down = find_dataref("sim/cockpit2/controls/gear_handle_down")

-- NEW 4-8-2017 AXP TCAS system

tcas_testing = find_dataref("laminar/B738/EFIS/tcas_test_show")
tcas_ra = find_dataref("laminar/B738/TCAS/traffic_ra")


trip_reset = find_dataref("laminar/B738/toggle_switch/emer_exit_lights")

-- 1801S load state

N1_eng_0 = find_dataref("sim/flightmodel/engine/ENGN_N1_[0]")
N1_eng_1 = find_dataref("sim/flightmodel/engine/ENGN_N1_[1]")

------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------- CREATING DATAREFS ---------------------------------------------------------------------------------------
--- FA in cockpit

FA_departure_time = create_dataref("laminar/b738/fmodpack/axp_FA_dep_timer", "number")
FA_leo_time = create_dataref("laminar/b738/fmodpack/axp_FA_leo_timer", "number")

--------------- fire test details

fire_handles_lights = create_dataref("laminar/b738/fmodpack/axp_fire_handles_lights", "number")


------------ load state

load_effect = create_dataref("laminar/b738/fmodpack/axp_load_effect", "number")
N1_current = create_dataref("laminar/b738/fmodpack/axp_N1_current", "number")
N1_factor = create_dataref("laminar/b738/fmodpack/axp_N1_factor", "number")
sink_factor = create_dataref("laminar/b738/fmodpack/axp_sink_factor", "number")
--onground = create_dataref("sim/flightmodel/failures/onground_all", "number")



----------- arrival cross check msg

play_arrival_crosscheck = create_dataref("laminar/b738/fmodpack/play_arrival_crosscheck", "number") 

play_80 = create_dataref("laminar/b738/fmodpack/play_80", "number") 
---------- seatbelt control

play_belts = create_dataref("laminar/b738/fmodpack/play_belts", "number") 
belts_fastened = create_dataref("laminar/b738/fmodpack/belts_fastened", "number") 


------- new mixer control

-- muffle_amount = create_dataref("laminar/b738/fmodpack/muffle_amount", "number")

-- NEW 4-8-2017 AXP TCAS system

true_tcas_alert = create_dataref("laminar/b738/fmodpack/play_tcas_alert", "number")


-- dataref to show if AC power is established (gyro, fans,...)
ac_is_established   = create_dataref("laminar/b738/fmodpack/ac_established", "number")
-- APP minimums callout
-- appromins    = create_dataref("laminar/b738/fmodpack/appro_mins", "number")
-- datarefs for pack operation
packsLon   = create_dataref("laminar/b738/fmodpack/packs_L", "number")
packsRon   = create_dataref("laminar/b738/fmodpack/packs_R", "number")

play_recirc_L = create_dataref("laminar/b738/fmodpack/recirc_L", "number")
play_recirc_R = create_dataref("laminar/b738/fmodpack/recirc_R", "number")

play_eqcooling = create_dataref("laminar/b738/fmodpack/eqcooling", "number")

-- dataref to mute VS dial when autopilot is dialing
play_vvi_dial = create_dataref("laminar/b738/fmodpack/play_vvi_dial_sound", "number")

-- dataref to mute SPD dial when autopilot is dialing
play_spd_dial = create_dataref("laminar/b738/fmodpack/play_spd_dial_sound", "number")

-- dataref after landing announcements
play_landed_announcement = create_dataref("laminar/b738/fmodpack/play_landed", "number")
-- dataref for V1 alert
play_V1 = create_dataref("laminar/b738/fmodpack/play_V1", "number")





-- NEW 1-8-17 AXP - dataref for "rotate" callout
play_Vr = create_dataref("laminar/b738/fmodpack/play_Vr", "number")




-- NEW 1-8-2017 AXP for 400 and 1000 call-outs at takeoff and "1000 to go" callout

play_fo_400 = create_dataref("laminar/b738/fmodpack/play_fo_400", "number")
play_fo_1000 = create_dataref("laminar/b738/fmodpack/play_fo_1000", "number")
--play_fo_1000_to_go_climb = create_dataref("laminar/b738/fmodpack/play_fo_1000_to_go_climb", "number")
--play_fo_1000_to_go_descent = create_dataref("laminar/b738/fmodpack/play_fo_1000_to_go_descent", "number")

-- for testing purposes only
--togo_climb_played = create_dataref("laminar/b738/fmodpack/togo_climb_played", "number")
--togo_des_played = create_dataref("laminar/b738/fmodpack/togo_des_played", "number")
after_takeoff_played = create_dataref("laminar/b738/fmodpack/after_takeoff_played", "number")
positive_rate_played = create_dataref("laminar/b738/fmodpack/fmod_positive_rate_played", "number")
alert_fo_400_played = create_dataref("laminar/b738/fmodpack/fmod_alert_fo_400_played", "number")
alert_fo_1000_played = create_dataref("laminar/b738/fmodpack/fmod_alert_fo_1000_played", "number")
climb_to_alt = create_dataref("laminar/b738/fmodpack/climb_to_alt", "number") 
descend_to_alt = create_dataref("laminar/b738/fmodpack/descend_to_alt", "number") 
cruise_msg_played = create_dataref("laminar/b738/fmodpack/cruise_msg_played", "number")
welcome_msg_played = create_dataref("laminar/b738/fmodpack/welcome_msg_played", "number")
gate_departure_played = create_dataref("laminar/b738/fmodpack/gate_departure_played", "number")
descent_msg_played = create_dataref("laminar/b738/fmodpack/descent_msg_played", "number")
gate_departure_initialized = create_dataref("laminar/b738/fmodpack/gate_departure_initialized", "number")
gate_arrival_initialized = create_dataref("laminar/b738/fmodpack/gate_arrival_initialized", "number")

play_taxi_to_gate = create_dataref("laminar/b738/fmodpack/play_taxi_to_gate", "number")
taxi_to_gate_played = create_dataref("laminar/b738/fmodpack/taxi_to_gate_played", "number")

departure_time = create_dataref("laminar/b738/fmodpack/departure_timer", "number")
arrival_time = create_dataref("laminar/b738/fmodpack/arrival_timer", "number")

-- NEW 1-8-2017 AXP to determine flight phases to control announcements etc.
flightphase_landed  = create_dataref("laminar/b738/fmodpack/flightphase_landed", "number")
flightphase_boarding  = create_dataref("laminar/b738/fmodpack/flightphase_boarding", "number")
flightphase_climb = create_dataref("laminar/b738/fmodpack/flightphase_climb", "number") 
flightphase_taxi = create_dataref("laminar/b738/fmodpack/flightphase_taxi", "number") 
flightphase_descent = create_dataref("laminar/b738/fmodpack/flightphase_descent", "number") 
flightphase_cruise = create_dataref("laminar/b738/fmodpack/flightphase_cruise", "number") 
flightphase_pre_takeoff = create_dataref("laminar/b738/fmodpack/flightphase_pre_takeoff", "number") 

passengers_leave = create_dataref("laminar/b738/fmodpack/flightphase_pax_leave", "number") 

play_dta = create_dataref("laminar/b738/fmodpack/play_dta", "number") 
play_gate_departure = create_dataref("laminar/b738/fmodpack/play_gate_departure", "number")
cabindoor_closed = create_dataref("laminar/b738/fmodpack/cabindoor_closed", "number")
play_after_takeoff = create_dataref("laminar/b738/fmodpack/play_after_takeoff", "number")
play_positive_rate = create_dataref("laminar/b738/fmodpack/fmod_play_positive_rate", "number")



play_seatbelt = create_dataref("laminar/b738/fmodpack/play_seatbelt", "number")
play_seatbelt_10k = create_dataref("laminar/b738/fmodpack/play_seatbelt10k", "number")

-- NEW 1-8-2017 AXP This controls the PAX activities volume (except applause) depending on the flightphase BEFORE the master volume set by the user with laminar/b738/fmodpack/fmod_vol_int_pax
PAX_premastervolume = create_dataref("laminar/b738/fmodpack/vol_int_paxpremaster", "number")

-- dataref for converted ground speed
real_gs = create_dataref("laminar/b738/fmodpack/real_groundspeed", "number")

-- is the plane on the ground? 
-- is it moving (to avoid V1 being played when GS = 0 and calculated V1 = 0) ? (GS > 10 because even standing still GS is always > 0 in XP11)
-- is the converted groundspeed (XP groundspeed value * 1.94) >= calculated V1 from the FMS? (the event is self-terminating, so it's okay to have play_V1 go to "1" as soon as calculated_V1 is reached)
-- is the autobrake set to RTO? (to avoid V1 being played during landing roll)

-- dataref for TO config and Cabin altitude warnings
horn_alert = create_dataref("laminar/b738/fmodpack/horn_alert", "number")
-- dataref for Below G/S warning
below_gs_alert = create_dataref("laminar/b738/fmodpack/below_gs_alert", "number")

-- for airport ambience
enable_airport_ambience = create_dataref("laminar/b738/fmodpack/fmod_enable_airport_ambience", "number")

--- dataref to play fuel pumps

play_fuelpumps = create_dataref("laminar/b738/fmodpack/fmod_playfuelpumps", "number")

-- ********************** ref to play  gear warning audiobirdxp

--play_gearwarn = create_dataref("laminar/b738/fmodpack/fmod_playgearwarn", "number")

-- ********************** NEW refs 7-8-2017 to play pre landing announcement



play_firebells = create_dataref("laminar/b738/fmodpack/fmod_play_firebells", "number")

-------------------------- new flight phase and passenger control 1709A +

leg_started = create_dataref("laminar/b738/fmodpack/leg_started", "number")
leg_ended = create_dataref("laminar/b738/fmodpack/leg_ended", "number")


-- passengers_leave = create_dataref("laminar/b738/fmodpack/flightphase_pax_leave", "number") 
passengers_talk = create_dataref("laminar/b738/fmodpack/pax_talk", "number") 
-- passengers_board
passengers_board = create_dataref("laminar/b738/fmodpack/pax_board", "number") 


-- is_trip_reset = create_dataref("laminar/b738/fmodpack/flightphase_tripreset", "number") 

-------------------------- new flight phase and passenger control 1709A +




-- wheels on the ground
simDR_on_ground_0				= find_dataref("sim/flightmodel2/gear/on_ground[0]")
simDR_on_ground_1				= find_dataref("sim/flightmodel2/gear/on_ground[1]")
simDR_on_ground_2				= find_dataref("sim/flightmodel2/gear/on_ground[2]")
simDR_radio_height_pilot_ft		= find_dataref("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot")

is_hotstart = create_dataref("laminar/b738/fmodpack/hotstart", "number") 



-- TOO LOW , GEAR warning if attempting to land with landing gears up
-- maybe rather take annunciators going green instead of actual landing gear deployment?

-- function gear_warn()
	-- if ft_agl < 500 and ias < 178 and fpm < 0 and (gear_nose + gear_main1 + gear_main2) < 3 then
	-- play_gearwarn = 1
	-- else
	-- play_gearwarn = 0
	-- end
-- end

function detect_fuel_pumps()
	if simDR_bus_volts1 > 10 or simDR_bus_volts2 > 10 then
		if fuel1 == 1 or fuel2 == 1 or fuel3 == 1 or fuel4 == 1 or fuel5 == 1 or fuel6 == 1 then 
			play_fuelpumps = 1
		else
			play_fuelpumps = 0 
		end
	else
		play_fuelpumps = 0 
	end
end



function play_airport_ambience()
	if is_plane_onground == 0 then 
		enable_airport_ambience = 0
	elseif is_plane_onground == 1 then
		 enable_airport_ambience = (chosen_airport_set +1)
	end
end


function alert_80()
	if simDR_on_ground_2 == 1 or simDR_on_ground_1 == 1 then
  		if ias >= 80 and ias <= 82 then
			play_80 = 1
		elseif ias < 80 or ias > 82 then
			play_80 = 0
		end
	else
  		play_80 = 0
	end
end

function alert_V1()
	if v1r_bugs == 1 and simDR_airspeed_pilot >= fms_v1 then
  		play_V1 = 1
	else
  		play_V1 = 0
	end
end


-- ***** NEW FUNCTION *****-- AXP 1-8-17

function alert_VR()
	if v1r_bugs == 1 and simDR_airspeed_pilot >= fms_vr then
  		play_Vr = 1
	else
  		play_Vr = 0
	end
end

-- ***** NEW FUNCTION *****-- AXP 1-8-17

function alert_400()
	if alert_fo_400_played == 0 and vvi_fpm > 0 and ft_agl >= 400 and ft_agl <= 450 then -- plane is climbing and plane 400 ft above ground
		play_fo_400 = 1
		alert_fo_400_played = 1
	else
		play_fo_400 = 0
	end   
end

-- ***** NEW FUNCTION *****-- AXP 1-8-17


function alert_1000()
	if alert_fo_1000_played == 0 and vvi_fpm > 0 and ft_agl >= 1000 and ft_agl <= 1050 then -- plane is climbing and plane 1000 ft above ground
		play_fo_1000 = 1
		alert_fo_1000_played = 1
	else
		play_fo_1000 = 0
	end   
end


function acgyrologic()
    if gpu_on == 1 or eng_genL == 1 or eng_genR == 1 or apu_gen == 1 then
		if simDR_bus_volts1 > 0 or simDR_bus_volts2 > 0 then
        	ac_is_established = 1
		else
			ac_is_established = 0
		end
    else
        ac_is_established = 0
    end
    
end



function recirclogic()

	if standbypwr > 0 then

		if recircLon > 0 and left_pack == 1 and right_pack == 1 and cab_util == 1 then		-- L recircs only operate with standby power on and BOTH packs on AUTO (not high, neither pack off) AND cabin utility ON
			play_recirc_L = 1
		elseif recircLon == 0 or left_pack == 0 or right_pack == 0 or left_pack == 2 or right_pack == 2 or cab_util == 0 then
			play_recirc_L = 0
		end

		if recircRon > 0 and left_pack == 1 and right_pack == 1 then		-- recircs only operate with standby power on and BOTH packs on AUTO (not high, neither pack off)
			play_recirc_R = 1
		elseif recircRon == 0 or left_pack == 0 or right_pack == 0 or left_pack == 2 or right_pack == 2 then
			play_recirc_R = 0
		end

	else
		play_recirc_L = 0
		play_recirc_R = 0
	end

end

function eqcoolinglogic()

	if busloadamps > 0 or gpu_avail == 1 then
		play_eqcooling = 1
	else
		play_eqcooling = 0
	end
end




-- PACK LOGIC: AC blows in air if either the engine bleeds air and the pack for that side is turned on OR the APU bleeds air into the system and pack for that side is turned on

function pack_play_L()
    if left_pack > 0 and bleed_valve_L == 1 and pressure_L > 0 and cab_util == 1 then
        packsLon = 1
    elseif left_pack > 0 and bleed_valve_APU == 1 and pressure_L > 0  and cab_util == 1 then
        packsLon = 1
    else
        packsLon = 0
    end
    
end

function pack_play_R()
    if right_pack > 0 and bleed_valve_R == 1 and pressure_R > 0 and cab_util == 1 then
        packsRon = 1
    elseif right_pack > 0 and bleed_valve_APU == 1 and pressure_R > 0 and cab_util == 1 then
        packsRon = 1
    else
        packsRon = 0
    end
    
end


--function appromins_func()
--	if ft_agl < minimums + 105 and ft_agl > minimums + 100 and fpm < 0 and minimums > 0 then
--		appromins = 1
--	else
--		appromins = 0
--	end
   
--end

-- VVI DIAL ---------------------------------------------

function vvi_dial_func()
	if vvi_dial_show == 1 then
		play_vvi_dial = vvi_dial
	end
end

---------------------------------------------------------

-- TO CONFIG and ALT HORN CUTOUT
function alt_horn_cutout_func()
	local horn = 0
	if alt_horn_cut_disable == 0 and cabin_alt > 10000 then
		horn = 1
	end
	if to_config == 1 then
		horn = 1
	end
	horn_alert = horn
end

-- BELOW G/S
function below_gs_func()
	if below_gs_disable == 0 and below_gs_warn == 1 then
		below_gs_alert = 1
	else
		below_gs_alert = 0
	end
end


-- SPD DIAL ---------------------------------------------
function spd_dial_func()
	if spd_dial_show == 1 then
		play_spd_dial = spd_dial
	end
end


function was_air_delay_timer()
	was_air_delay = 1
end

function was_ground_delay_timer()
	was_ground_delay = 1
end

-- 1-8-2017 AXP modified to set flightphase to landed when touchdown occurs / EDIT wrote new function for that

function ground_air_logic()
	-- on the ground
	if simDR_on_ground_0 == 1 and simDR_on_ground_1 == 1 and simDR_on_ground_2 == 1 then
		on_the_ground = 1
		touch_down = 0
	end
	if simDR_on_ground_0 == 0 and simDR_on_ground_1 == 0 and simDR_on_ground_2 == 0 then
		on_the_ground = 0
		was_ground_delay = 0
	end
	
	if on_the_ground == 0 and was_air_delay == 0 then
		if is_timer_scheduled(was_air_delay_timer) == false then
			run_after_time(was_air_delay_timer, 30)	-- 30 seconds
		end
	end
	
	if on_the_ground == 1 and was_ground_delay == 0 then
		if is_timer_scheduled(was_ground_delay_timer) == false then
			run_after_time(was_ground_delay_timer, 5)	-- 5 seconds
		end
	end
	
	if was_air_delay == 1 then
		if simDR_on_ground_0 == 1 or simDR_on_ground_1 ==1 or simDR_on_ground_2 == 1 then
			touch_down = 1
			was_air_delay = 0
--			flightphase_landed = 1
		end
	end
	
end



-- ***** MODIFIED FUNCTION 7-8-2017 
-- modified GS condition from <20 to <30 (which is rough measure for maximum taxi speed)
-- added is_taxi to determin if plane is taxiing (by position of taxi light switch)

function announcement_crew_landed()
	
	real_gs = (current_gs * 1.94)	-- knots
	
	if touch_down == 1 and is_taxi == 0 then
		play_landed_ann_armed = 1
	end
	if play_landed_ann_armed == 1 and on_the_ground == 1 and real_gs < 100 and is_taxi == 0 and flight_time > 40 then 	-- added flight time restriction
		--play_landed_announcement = 1																					-- fauulty, replaced with touch_down as trigger
		play_landed_ann_armed = 0
	end
	if was_ground_delay == 1 and real_gs < 30 then
		-- play_landed_announcement = 0
	end
	if was_air_delay == 1 then
		play_landed_ann_armed = 0
	end
	
end

-- modified with height AGL 1-8-17 AXP
--function detect_prelanding()

--	if offset == ed_found and ed_found > 0 then

--           if play_preland == 0 then
--		if ed_found > B738_legs_num then
			-- E/D is Destination airport
--			if simDR_fmc_dist2 < 40 and ft_agl <= 10000 then 	-- 40 miles and 10000
--				play_preland = 1 
--				PAX_premastervolume = 9.5	--- YOUR TRIGGER ---
--			end
--		else
			-- E/D is waypoint before Destination airport 
--			if simDR_fmc_dist2 < 35 and ft_agl <= 10000 then 	-- 35 miles and 10000
--				play_preland = 1 
--				PAX_premastervolume = 9.5		--- YOUR TRIGGER ---
--			end
--		end

--           end
--	else
--		play_preland  = 0 	--- YOUR TRIGGER ---
--	end
--end

-- plane on the ground
function plane_on_ground()
	
	if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1 or simDR_on_ground_2 == 1 then
		plane_on_the_ground = 1
	else
		plane_on_the_ground = 0
	end

end

-- timer for plane on the ground 0 - 30 sec
function ground_timer()
	if plane_on_the_ground == 1 then
		if ground_time < 30 then
			ground_time = ground_time + 1
		end
	else
		air_time = 0
	end
end

-- timer for plane in the air 0 - 100 sec
function air_timer()
	if plane_on_the_ground == 0 then
		if air_time < 100 then
			air_time = ground_time + 1
		end
	else
		ground_time = 0
	end
end



-- 1-8-2017 AXP new functions to detect various flight phases

function detect_landed()

	if touch_down == 1 and flight_time > 40 then  -- prevent touch down setting landing to 1  at reload

			flightphase_landed = 1
			passengers_talk = 1
			flightphase_climb = 0		-- end airborne flight phases upon landing
			flightphase_descent = 0		-- end airborne flight phases upon landing
			flightphase_boarding = 0	-- no boarding sounds before engine shutdown
			after_takeoff_played = 0	-- reset all played indicators for next leg of the flight
			--togo_des_played = 0		-- reset all played indicators for next leg of the flight
			--togo_climb_played = 0		-- reset all played indicators for next leg of the flight
			positive_rate_played = 0	-- reset all played indicators for next leg of the flight
			alert_fo_400_played = 0		-- reset all played indicators for next leg of the flight
			alert_fo_1000_played = 0	-- reset all played indicators for next leg of the flight
			cruise_msg_played = 0		-- reset all played indicators for next leg of the flight
			descent_msg_played = 0		-- reset all played indicators for next leg of the flight
			-- welcome_msg_played = 0		-- not reset by landed,  must be reset by leg_ended
			PAX_premastervolume = 10
			is_hotstart = 0	
			gate_departure_initialized = 0
			--cabindoor_closed = 1

			if taxi_to_gate_played == 0 then		-- check if taxi to gate announcements / applause have been played. If not, play them and set played to 1
				play_taxi_to_gate = 1
				taxi_to_gate_played = 1
			end

	elseif touch_down == 1 and flight_time < 40 then
			flightphase_landed = 0
			play_taxi_to_gate = 0
	
	end

end


function detect_boarding()		--

	if on_the_ground == 1 and is_taxi == 0 and is_anticollision_on == 0 and fuel_cutoff1 == 0 and fuel_cutoff2 == 0 then  -- engines shut down after landing or before new flight and AC established and not taxiing
		flightphase_boarding = 1
		--if gate_departure_initialized == 0 and flightphase_landed == 0 and flightphase_taxi == 0 and flightphase_pre_takeoff == 0 and is_hotstart == 0 then 
		--	cabindoor_closed = 0				-- as long as boarding is active and plane has not just landed, assume cabin door open
		--end
		PAX_premastervolume = 10			-- max PAX volume
	else
		flightphase_boarding = 0
	end
end



function detect_gate_departure()

	if is_anticollision_on > 0 and flightphase_landed == 0 and on_the_ground == 1 and is_hotstart == 0 then
		if leg_started == 1 and leg_ended == 0 then
			if gate_departure_played == 0 then
				play_gate_departure = 1
				gate_departure_played = 1
			end
		end
		passengers_talk = 1
		PAX_premastervolume = 9.5	
		gate_departure_initialized = 1
		--run_after_time(departure_timer, 1)
	else
		play_gate_departure = 0
		-- gate_departure_initialized = 0
	end

end

function detect_gate_arrival()


	if is_dev_event == 1 and on_the_ground == 1 then

		gate_arrival_initialized = 1
		play_arrival_crosscheck = 1

	elseif is_dev_event == 0 and flightphase_landed == 1 and flightphase_boarding == 1 and is_hotstart == 0 then

		gate_arrival_initialized = 1
		play_arrival_crosscheck = 1
	end

end

-- added hotstart exclusion
function departure_timer()
	if cabindoor_closed == 0 and departure_time < 5 then
			departure_time = departure_time + 1
	elseif departure_time == 5 then
		--cabindoor_closed = 1
		departure_time = 0					-- if 5 secs have passed since gate_departure was initiated, play cabin door closing sound
	elseif gate_departure_initialized == 0 and is_hotstart == 0 then
		departure_time = 0
		--cabindoor_closed = 0
	--elseif is_hotstart == 1 then
	--	cabindoor_closed = 1
	end
end

function arrival_timer()
	if cabindoor_closed == 1 and arrival_time < 5 then
			arrival_time = arrival_time + 1
	elseif arrival_time == 5 and is_hotstart == 0 then
		--cabindoor_closed = 0
		arrival_time = 0					-- if 25 secs have passed since gate_arrival was initiated, play cabin door opens
	elseif gate_arrival_initialized == 0 then
		arrival_time = 0
		--cabindoor_closed = 1
	end
end


function detect_closecabindoor()

	if gate_departure_initialized == 1 then
	 	if is_timer_scheduled(departure_timer) == false then
		 	run_after_time(departure_timer, 1)
		end
	end
end

function detect_opencabindoor()

	if gate_arrival_initialized == 1 then
	 	if is_timer_scheduled(arrival_timer) == false then
		 	run_after_time(arrival_timer, 1)
		end
	end
end


function detect_taxi()			-- not super necessary now but maybe in future

	if on_the_ground == 1 and is_taxi == 1 then		-- this just determines that taxiing is intended or occurring. It's not the trigger for pre-taxi announcements.
		flightphase_taxi = 1
		passengers_talk = 1
		PAX_premastervolume = 9.5	
		--cabindoor_closed = 1
	else
		flightphase_taxi = 0
	end

end

function detect_pre_takeoff()			-- quietens PAX before take off

	if on_the_ground == 1 and flightphase_taxi == 0 and flightphase_boarding == 0 and flightphase_landed == 0  and landing_lights_on > 0  then		-- this just determines that taxiing is intended or occurring. It's not the trigger for pre-taxi announcements.
		flightphase_pre_takeoff = 1
		passengers_talk = 1
		PAX_premastervolume = 8	
		--cabindoor_closed = 1
	else
		flightphase_pre_takeoff = 0
	end

end



-- 1-8-2017 AXP new function to trigger "doors to automatic etc." announcements when starting to taxi (but not after landing)
-- obsolete but kept for upcoming checklists
function play_taxi_announcements()

	if flightphase_taxi == 1 and flightphase_landed == 0 then
		play_dta = 1
		PAX_premastervolume = 9.8
	else
		play_dta = 0
	end	

end

function find_climb_to_alt()

	if mcp_alt > fmc_cruise_alt then
		climb_to_alt = mcp_alt
	elseif fmc_cruise_alt > mcp_alt then
		climb_to_alt = fmc_cruise_alt
	elseif fmc_cruise_alt == mcp_alt then
		climb_to_alt = fmc_cruise_alt
	end

end

function find_descend_to_alt()

	if mcp_alt < fmc_cruise_alt then
		descend_to_alt = mcp_alt
	elseif fmc_cruise_alt < mcp_alt then
		descend_to_alt = fmc_cruise_alt
	end

end

function detect_climb()

-- function to detect climbing to a higher altitude 
-- registers either to alt set on MCP (if higher than cruise or no cruise is set - manual control) or in FMC
-- needed to register alt changes that deviate from FMC cruise alt (because flight phase in FMC stays on "2" regardless of manual changes)



	if on_the_ground == 0 and vvi_fpm > 50 then -- not on the ground -- climbing

		if efis_alt < (mcp_alt - 300) then -- current alt < mcp alt
			if mcp_alt >= fmc_cruise_alt then  -- which alt is higher? mcp or cruise. if mcp is at least cruise and efis alt is lower we are still climbing
				flightphase_climb = 1
				passengers_talk = 1
				PAX_premastervolume = 9.5	
			elseif mcp_alt < fmc_cruise_alt then -- mcp alt is lower than cruise alt, so we are still climbing ... 
				if efis_alt < (fmc_cruise_alt - 300) then  --... if efis alt is lower than cruise
					flightphase_climb = 1
					passengers_talk = 1
					PAX_premastervolume =  9.5	
				else										--... if efis alt is not lower, we are not climbing anymore
					flightphase_climb = 0
					PAX_premastervolume = 9.5	
				end
			end
		
		elseif efis_alt > (fmc_cruise_alt - 300) and efis_alt > (mcp_alt - 300) then  -- efis alt is neither lower than mcp alt nor FMC cruise alt 
			flightphase_climb = 0
			PAX_premastervolume = 9.5	
		end
	else									--... we are not airborne or vertical speed is 0 or negative (or both)
		flightphase_climb = 0
	end
end


-- 1-8-2017 AXP new function to detect climb

function detect_descent()

	if on_the_ground == 0 and ft_agl > 100 and flightphase_climb == 0 then		-- airborne , not climbing
		if efis_alt > (descend_to_alt + 300) and vvi_fpm < -500 then
			flightphase_descent = 1
			passengers_talk = 1
			PAX_premastervolume = 9.5
		else
			flightphase_descent = 0
		end
	else
		flightphase_descent = 0
	end
end	

-- add new variable laminar/b738/fmodpack/flightphase_pax_talk to enable better control for special flights

function detect_cruise()


	if on_the_ground == 0 and flightphase_climb == 0 and flightphase_descent == 0 and efis_alt >= (climb_to_alt - 300) and efis_alt <= (climb_to_alt + 300) then		-- neither climbing nor descending phase and FL is about that of governing set altitude (FMC or manual, whatever is higher)
		flightphase_cruise = 1
		passengers_talk = 1
		PAX_premastervolume = 10
	else
		flightphase_cruise = 0
	end
end



function detect_seatbelt_autoplay()

	if seatbelt_auto == 1 and on_the_ground == 0 and ft_agl > 2000 and flightphase_climb == 0 then 		-- seatbelt switch auto / flying / above 2k feet AGL

		if flap_pos > 0.1 then																			-- flaps lower than UP
			play_seatbelt = 1
		elseif flap_pos < 0.1 and gearhandle_down < 1 then
			play_seatbelt = 0
		end

		if gearhandle_down == 1 then																	-- gear down
			play_seatbelt = 1
		elseif gearhandle_down < 1 and flap_pos < 0.1 then
			play_seatbelt = 0
		end

	else
		play_seatbelt = 0
	end

end

function detect_seatbelt_10k()																			-- auto play on crossing 10k feet AGL

	if seatbelt_auto == 1 and on_the_ground == 0 and ft_agl > 2000  then

		if efis_alt >= 9990 and efis_alt <= 10010 then   -- to prevent constant dinging if you cruise at 10k feet
			play_seatbelt_10k = 1
		else
			play_seatbelt_10k = 0
		end
	else
		play_seatbelt_10k = 0
	end

end



-- 1-8-2017 AXP new function to play  after take off bla

function play_after_takeoff_announcements()

	if flightphase_climb == 1 and ft_agl >= 10000 and after_takeoff_played == 0 then -- plane is in climb phase and about 8000 feet AGL and after takeoff bla has not been played yet.
		play_after_takeoff = 1			-- play the announcements
		after_takeoff_played = 1		-- prevents that message is played twice in one flight
	else 
		play_after_takeoff = 0
	end
end

-- 1-8-2017 AXP new function to play  positive rate callout

function alert_positive_rate()
-- removed due to simpler trigger -------------------------------------------------------------------------

	if positive_rate_played == 0 and  vvi_fpm >= 10 and ft_agl >= 15  then -- plane is in climb phase and at least 30 feet above ground, callout has not been made on this leg of the flight yet
		play_positive_rate = 1			-- play the announcements
		positive_rate_played = 1		-- prevents that message is played twice in one leg of the flight
	else 
		play_positive_rate = 0
	end
end



-- 1-8-2017 AXP new function to decide if firebells are to be played

-- 4-8-2017 AXP detect if TCAS is performing test to suppress false alerts playing during test (normal alert dataref is set to 1 during TCAS self test)

function detect_true_TCAS()

	if tcas_testing == 0 then	-- if no test is performed...

		if tcas_ra == 1 then
			true_tcas_alert = 1	-- when _ra goes to 1 it's a real alert => play alert

		elseif tcas_ra == 0 then
			true_tcas_alert = 0
		end

	elseif tcas_testing == 1 then   -- suppress alerts while testing
			true_tcas_alert = 0
	end

end


-- assuming board control through menu
function leg_control()

	if start_leg_commanded == 1 then
		leg_started = 1
		leg_ended = 0
	elseif start_leg_commanded == 0 then
		leg_started = 0
		leg_ended = 1
	elseif end_leg_commanded == 1 then
		leg_started = 0 
		leg_ended = 1
	end

	if leg_ended == 1 and leg_started == 0 then
		flightphase_landed = 0 											-- reset  for next leg 
		welcome_msg_played = 0
		descent_msg_played = 0
		cruise_msg_played = 0
		taxi_to_gate_played = 0
		gate_departure_played = 0 
		gate_departure_initialized = 0
		gate_arrival_initialized = 0
		play_arrival_crosscheck = 0 
		--if is_hotstart == 0 then
		--	cabindoor_closed = 0
		--end

		--if is_hotstart == 1 then
		--	cabindoor_closed = 1
		--end

		-- is_hotstart = 0	
		departure_time = 0
		arrival_time = 0
		belts_fastened = 0
	end

end

-- cargo / catering / cleaning sounds


function logic_cargo()
	
	if leg_started == 1 and leg_ended == 0 then				-- flight leg started (i.e. boarding initiated?)
		
		if cargo_play_state == 1 then						-- if playing, fade out cargo / catering ect. sounds

			cargo_play_state = 0
		end
	end

	if on_the_ground == 0 then

		cargo_play_state = 0
	
	end
	
end



function pax_talk()

	if on_the_ground == 1 then
		if leg_started == 1 and leg_ended == 0  then
			passengers_talk = 1
		else
			passengers_talk = 0
		end

	elseif on_the_ground == 0 then			-- to make sure PAX talk when starting flight mid-air
		passengers_talk = 1
	end
end

function pax_board()

	if leg_started == 1 and leg_ended == 0 and flightphase_boarding == 1 and is_taxi == 0 then	-- automatic boarding noise when at gate / engines off / taxi lights off / anti co lights off
		passengers_board = 1
	else
		passengers_board = 0
	end
end

function pax_belts()


-- CONDITIONS TO (UN)FASTEN BELTS

	if leg_started == 1 then			-- Are PAX onboard, flight started?

		if belts_fastened == 0 then 	-- belts have not been fastened yet

			if seatbelt_auto == 2 then	-- fasten seatbelt signs are on
				play_belts = 1
				belts_fastened = 1		-- PAX are wearing belts
			end

			if seatbelt_auto < 2 then	-- seatbelt signs supposed OFF and seatbelts have already been unfastened 
				play_belts = 0			-- do not play
			end

		elseif belts_fastened == 1 then	-- belts are fastened

			if seatbelt_auto == 0 then	-- seatbelt signs OFF
				play_belts = 1
				belts_fastened = 0		-- PAX are NOT wearing belts
			end

			if seatbelt_auto >= 1 then	-- seatbelt signs are not OFF and PAX are already wearing their belts
				play_belts = 0			-- do not play
			end

		end
	else								-- no flight in progress? do not play PAX related sounds
		belts_fastened = 0
		play_belts = 0
	end

end






function detect_hotstart()

	if fuel_cutoff1 == 1 and fuel_cutoff2 == 1 and flight_time < 10 then
		is_hotstart = 1
		passengers_talk = 1
		--cabindoor_closed = 1
		belts_fastened = 1
		leg_started = 1
		leg_ended = 0
	--elseif fuel_cutoff1 == 1 and fuel_cutoff2 == 1 and flight_time >= 400 then
	--	is_hotstart = 0
	elseif on_the_ground == 0 and flight_time < 10 then
		is_hotstart = 1
		--cabindoor_closed = 1
	elseif fuel_cutoff1 < 1 or fuel_cutoff2 < 1 then
		is_hotstart = 0 
		
	end



	if is_hotstart == 1 and flight_time >= 10 then
		start_leg_commanded = 1
	end

end


function bellhop()

	if on_the_ground == 0 then
		cabindoor_closed = 1
	end

	if on_the_ground == 1 then

		if gate_departure_initialized == 1 and departure_time >= 5 then
			cabindoor_closed = 1
		end

		if gate_arrival_initialized == 1 and arrival_time >= 5 then
			cabindoor_closed = 0
		end

		if leg_ended == 1 and leg_started == 0 then
			cabindoor_closed = 0
		end 

		if is_hotstart == 1  then
			cabindoor_closed = 1
		end 

		if current_gs > 2 then
			cabindoor_closed = 1
		end

		if is_taxi > 0 then
			cabindoor_closed = 1
		end 

		if is_anticollision_on > 0 then
			cabindoor_closed = 1
		end

		if is_eng1_on == 1 or is_eng2_on == 1 or is_eng1_starter == 1 or  is_eng2_starter == 1 then
			cabindoor_closed = 1
		end

	end
end


-- --------------------------------------------------------- 

-- new AXP 1801S

function detect_load_level()

---- set up factors

--- engine N1 (avoid double calculation)

	if N1_eng_0 > N1_eng_1 then 
		N1_current = N1_eng_0
	elseif N1_eng_1 > N1_eng_0 then
		N1_current = N1_eng_1
	elseif N1_eng_0 == N1_eng_1 then
		N1_current = N1_eng_0
	end


-- N1_factor

	if N1_current <= 75 then
		N1_factor = 0
	elseif N1_current > 75 and N1_current <= 78 then
		N1_factor = 0.1
	elseif N1_current > 79 and N1_current <= 80 then
		N1_factor = 0.2
	elseif N1_current > 80 and N1_current <= 81 then
		N1_factor = 0.4
	elseif N1_current > 81 and N1_current <= 82 then
		N1_factor = 0.6
	elseif N1_current > 82 and N1_current <= 83 then
		N1_factor = 0.7
	elseif N1_current > 83 and N1_current <= 84 then
		N1_factor = 0.9
	elseif N1_current > 84 and N1_current <= 85 then
		N1_factor = 1
	
	end


--- sink rate factor

	if is_plane_onground == 0 then
		if vvi_fpm <= -500 then 
			sink_factor = 0
		elseif vvi_fpm > -500 and vvi_fpm <= -300 then
			sink_factor = 0
		elseif vvi_fpm > -300 and vvi_fpm <= -150 then
			sink_factor = 0.12
		elseif vvi_fpm > -150 and vvi_fpm <= -100 then
			sink_factor = 0.15
		elseif vvi_fpm > -100 and vvi_fpm <= -80 then
			sink_factor = 0.18
		elseif vvi_fpm > -80 and vvi_fpm <= -50 then
			sink_factor = 0.2
		elseif vvi_fpm > -50 and vvi_fpm <= 0 then
			sink_factor = 0.25
		elseif vvi_fpm > 0 and vvi_fpm <= 10 then
			sink_factor = 0.3
		elseif vvi_fpm > 10 and vvi_fpm <= 20 then
			sink_factor = 0.35
		elseif vvi_fpm > 20 and vvi_fpm <= 25 then
			sink_factor = 0.4
		elseif vvi_fpm > 25 and vvi_fpm <= 30 then
			sink_factor = 0.5
		elseif vvi_fpm > 30 and vvi_fpm <= 40 then
			sink_factor = 0.55
		elseif vvi_fpm > 40 and vvi_fpm <= 45 then
			sink_factor = 0.6
		elseif vvi_fpm > 45 and vvi_fpm <= 50 then
			sink_factor = 0.75
		elseif vvi_fpm > 50 and vvi_fpm <= 55 then
			sink_factor = 0.85
		elseif vvi_fpm > 55 and vvi_fpm <= 65 then
			sink_factor = 0.9
		elseif vvi_fpm > 65 then
			sink_factor = 1
		end

	elseif is_plane_onground == 1 then
		sink_factor = 1
	end

--- load effect calculation


load_effect = 1 - N1_factor - sink_factor

end

----- fire test details


function detect_fire_handles()

	if is_cargo_fire == 1 or is_eng1_fire == 1 or is_eng2_fire == 1 or is_apu_fire == 1 then 
		fire_handles_lights = 1
	else
		fire_handles_lights = 0
	end
end

------------- FA in cockpit ---------------------------------------

--- timers

function FA_departure_timer()

	if  flightphase_landed == 0 and FA_departure_time < FA_max_time then

		FA_departure_time = FA_departure_time + 1

	elseif flightphase_landed == 1 then

		FA_departure_time = 0
	end

	if leg_ended == 1 and leg_started == 0 then

		FA_departure_time = 0
	end

end

function FA_leo_timer()

	if  flightphase_landed == 0 and FA_leo_time < 180 then

		FA_leo_time = FA_leo_time + 1

	elseif flightphase_landed == 1 then

		FA_leo_time = 0
	end

	if leg_ended == 1 and leg_started == 0 then

		FA_leo_time = 0
	end

end




--- main function

function FA_logic_timers()

	--- start upon initializing gate departure
	if gate_departure_initialized == 1 then
		if is_timer_scheduled(FA_departure_timer) == false then
			run_after_time(FA_departure_timer, 1)
		end
	end

		--- start upon boarding
	if leg_started == 1 and leg_ended == 0 then
		if is_timer_scheduled(FA_leo_timer) == false then
			run_after_time(FA_leo_timer, 1)
		end
	end


end

function detect_trisha_door()

	if  on_the_ground == 1 and gate_departure_initialized == 1 and FA_departure_time >= 25 and FA_departure_time <= 26 and FAC_volume > 0 then
			close_fdd:once()
	end
end




function flight_start()



	PAX_premastervolume = 10
	on_the_ground = 0
	touch_down = 0
	was_air_delay = 0
	was_ground_delay = 0
	play_landed_ann_armed = 0
	--- 1-8-2017 new AXP - FO module ------------------------------------------------------------------
	--play_fo_1000_to_go_climb = 0
	--play_fo_1000_to_go_descent = 0
	play_fo_1000 = 0
	play_fo_400 = 0
	-- 1-8-2017 new AXP - announcements------------------------------------------------------------------
	play_after_takeoff = 0
	play_gate_departure = 0
	cabindoor_closed = 0 
	play_dta = 0
	play_positive_rate = 0
	play_seatbelt = 0
	play_seatbelt_10k = 0
	--- flight phases -----------------------------------------------------------------------------------
	flightphase_landed = 0
	flightphase_boarding  = 0
	flightphase_climb = 0
	flightphase_taxi = 0
	flightphase_descent = 0
	flightphase_cruise = 0
	flightphase_pre_takeoff = 0
	passengers_leave = 0
	passengers_talk = 0
	flight_leg_finished = 0 
	--- markers to avoid multiple playing in one leg of the flight --------------------------------------
	--togo_des_played = 0
	--togo_climb_played = 0
	after_takeoff_played = 0
	positive_rate_played = 0
	alert_fo_400_played = 0
	alert_fo_1000_played = 0
	cruise_msg_played = 0 
	play_welcome_msg = 0
	welcome_msg_played = 0
	gate_departure_played  = 0
	descent_msg_played = 0 

play_taxi_to_gate = 0
taxi_to_gate_played = 0


	-- 1-8-2017 new Zibo
	ground_time = 0	
	air_time = 0
	-- 1-7-2017 AXP NEW var for flight time
	plane_on_the_ground = 0
	-- 1-7-2017 AXP NEW  for fire alert
	play_firebells = 0

	climb_to_alt = 0 
	descend_to_alt = 0

-------------------------- new flight phase and passenger control 1709A +

leg_started = 0
leg_ended = 0

start_leg_commanded = 0
end_leg_commanded = 0


passengers_board = 0
passengers_talk = 0
-- is_trip_reset = 0 
departure_time = 0
arrival_time = 0
gate_departure_initialized = 0
gate_arrival_initialized = 0
is_hotstart = 0
play_belts = 0 
belts_fastened = 0
play_arrival_crosscheck = 0
play_80 = 0

----------------------------------
-- load state
load_effect = 0
N1_current = 0
N1_factor = 0
sink_factor = 0

---- fire test

fire_handles_lights = 0

----- FA in cockpit

FA_departure_time = 0
FA_leo_time = 0
FA_max_time = 300


-----------------------------------


	if is_timer_scheduled(ground_timer) == false then
		run_after_time(ground_timer, 1)	-- Every 1 sec
	end

	if is_timer_scheduled(air_timer) == false then
		run_after_time(air_timer, 1)	-- Every 1 sec
	end



end


function after_physics()

	 --gear_warn()
	 detect_fuel_pumps()
	 play_airport_ambience()
	 -- 1-8-2017 new AXP  -------------------------------------------------------
	 alert_V1()
	 alert_80()
	 alert_VR()
	 alert_400()
	 alert_1000()
	 --alert_1000_to_go_climb()
	 --alert_1000_to_go_descent()
	 -- new zibo
	 plane_on_ground()
	 -- 1-8-2017 new AXP  -------------------------------------------------------
	 detect_landed()
	 detect_boarding()
	 detect_gate_departure()
	 detect_gate_arrival()
	 detect_closecabindoor()
	 detect_opencabindoor()
	 detect_taxi()
	 play_taxi_announcements()
	 detect_climb()
	 detect_descent()
	 detect_cruise()
	 --alert_welcome_msg()
	 --alert_cruise_msg()
	 --alert_descent_msg()
	 --detect_prelanding()
	 detect_seatbelt_autoplay()
	 detect_seatbelt_10k()
	 detect_fire_handles()
	 -- detect_pax_leave()
	 play_after_takeoff_announcements()
	 alert_positive_rate()
	 -- 3-8-2017 new AXP  -------------------------------------------------------
	 detect_pre_takeoff()
	 find_climb_to_alt()
	 find_descend_to_alt()
	 -- 4-8-2017 new AXP  -------------------------------------------------------
	 detect_true_TCAS()
	 ----------------------------------------------------------------------------
	 announcement_crew_landed()
	 acgyrologic()
	 recirclogic()
	 eqcoolinglogic()
	 --appromins_func()
	 pack_play_L()
	 pack_play_R()
	 vvi_dial_func()
	 alt_horn_cutout_func()
	 below_gs_func()
	 spd_dial_func()
	 ground_air_logic()

--- new flight phase c.

	--detect_tripreset()
	leg_control()
	logic_cargo()
	pax_talk()
	pax_board()
	pax_belts()
	detect_hotstart()
	--detect_muffle_amount()
	detect_load_level()
	FA_logic_timers()
	detect_trisha_door()
	bellhop()



	 
	 

	 end
