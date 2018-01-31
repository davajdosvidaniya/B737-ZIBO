--[[
*****************************************************************************************
* Program Script Name	:	B738.systems
*
* Author Name			:	Jim Gregory, Alex Unruh
*
*   Revisions:
*   -- DATE --	--- REV NO ---		--- DESCRIPTION ---
*   2016-08-24	0.01a				Start of Dev
*
*
*
*
*****************************************************************************************
*         COPYRIGHT � 2016 JIM GREGORY / LAMINAR RESEARCH - ALL RIGHTS RESERVED
*****************************************************************************************
--]]



--*************************************************************************************--
--** 					              XLUA GLOBALS              				     **--
--*************************************************************************************--

--[[

SIM_PERIOD - this contains the duration of the current frame in seconds (so it is alway a
fraction).  Use this to normalize rates,  e.g. to add 3 units of fuel per second in a
per-frame callback you’d do fuel = fuel + 3 * SIM_PERIOD.

IN_REPLAY - evaluates to 0 if replay is off, 1 if replay mode is on

--]]


--*************************************************************************************--
--** 					               CONSTANTS                    				 **--
--*************************************************************************************--

APU_FUEL_BURN = 0.027778	-- kg/sec

WIPER_LOW_SPEED = 0.5
WIPER_HIGH_SPEED = 0.25
WIPER_TIMER = 0.03
WIPER_INT_TIMER = 2

LANDGEAR_NOSE_UP_TIME = 11.5
LANDGEAR_LEFT_UP_TIME = 14.1
LANDGEAR_RIGHT_UP_TIME = 14.3
LANDGEAR_NOSE_DN_TIME = 15.1
LANDGEAR_LEFT_DN_TIME = 17.7
LANDGEAR_RIGHT_DN_TIME = 17.4
LANDGEAR_NOSE_MAN_TIME = 17.3
LANDGEAR_LEFT_MAN_TIME = 19.8
LANDGEAR_RIGHT_MAN_TIME = 19.2


--*************************************************************************************--
--** 					            GLOBAL VARIABLES                				 **--
--*************************************************************************************--

B738bleedAir            = {}

B738bleedAir.engine1    = {}
B738bleedAir.engine2    = {}
B738bleedAir.apu        = {}
B738bleedAir.l_pack		= {}
B738bleedAir.r_pack		= {}
B738bleedAir.isolation	= {}


B738bleedAir.engine1.psi	= 0
B738bleedAir.engine2.psi	= 0
B738bleedAir.apu.psi		= 0


B738bleedAir.engine1.bleed_air_valve        = {}
B738bleedAir.engine2.bleed_air_valve        = {}
B738bleedAir.apu.bleed_air_valve            = {}
B738bleedAir.l_pack.bleed_air_valve         = {}
B738bleedAir.r_pack.bleed_air_valve         = {}
B738bleedAir.isolation.bleed_air_valve      = {}


B738bleedAir.engine1.bleed_air_valve.target_pos = 0.0
B738bleedAir.engine2.bleed_air_valve.target_pos = 0.0
B738bleedAir.apu.bleed_air_valve.target_pos     = 0.0
B738bleedAir.l_pack.bleed_air_valve.target_pos		= 0.0
B738bleedAir.r_pack.bleed_air_valve.target_pos		= 0.0
B738bleedAir.isolation.bleed_air_valve.target_pos	= 0.0


B738bleedAir.engine1.bleed_air_valve.pos        = create_dataref("laminar/B738/air/engine1/bleed_valve_pos", "number")
B738bleedAir.engine2.bleed_air_valve.pos        = create_dataref("laminar/B738/air/engine2/bleed_valve_pos", "number")
B738bleedAir.apu.bleed_air_valve.pos            = create_dataref("laminar/B738/air/apu/bleed_valve_pos", "number")
B738bleedAir.l_pack.bleed_air_valve.pos			= create_dataref("laminar/B738/air/l_pack/bleed_valve_pos", "number")
B738bleedAir.r_pack.bleed_air_valve.pos			= create_dataref("laminar/B738/air/r_pack/bleed_valve_pos", "number")
B738bleedAir.isolation.bleed_air_valve.pos		= create_dataref("laminar/B738/air/isolation/bleed_valve_pos", "number")

ignition1 = 0
ignition2 = 0

apu_start_active = 0
apu_shutdown_active = 0

apu_start_eng1 = 0		-- APU can start Engine 1
apu_start_eng2 = 0		-- APU can start Engine 2
eng1_start_eng2 = 0		-- Engine 1 can start Engine 2
eng2_start_eng1 = 0		-- Engine 2 can start Engine 1
eng1_starting = 0		-- Engine 1 starting
eng2_starting = 0		-- Engine 2 starting
pack_mode = 0

l_duct_in = 0
r_duct_in = 0

bleed_valve_min_act_press = 7.0

l_duct_out = 0.00
r_duct_out = 0.00
l_duct_out_target = 0.00
r_duct_out_target = 0.00

B738_tank_l_status = 0
B738_tank_c_status = 0
B738_tank_r_status = 0

aircraft_was_on_air = 0
aircraft_landing = 0
aircraft_landing2 = 0
after_RTO = 0
autobrake_ratio = 0
touchdown_3s = 0
speed_brake_old = 0

tcas_lat = 0
tcas_lon = 0
tcas_el  = 0
tcas_tara = 0
tcas_tara_status = 0
tcas_dis = 0

tcas_dis_1 = 0
tcas_dis_2 = 0
tcas_dis_3 = 0
tcas_dis_4 = 0
tcas_dis_5 = 0
tcas_dis_6 = 0
tcas_dis_7 = 0
tcas_dis_8 = 0
tcas_dis_9 = 0
tcas_dis_10 = 0
tcas_dis_11 = 0
tcas_dis_12 = 0
tcas_dis_13 = 0
tcas_dis_14 = 0
tcas_dis_15 = 0
tcas_dis_16 = 0
tcas_dis_17 = 0
tcas_dis_18 = 0
tcas_dis_19 = 0

tcas_el_0 = 0	-- my elevation
tcas_el_1 = 0
tcas_el_2 = 0
tcas_el_3 = 0
tcas_el_4 = 0
tcas_el_5 = 0
tcas_el_6 = 0
tcas_el_7 = 0
tcas_el_8 = 0
tcas_el_9 = 0
tcas_el_10 = 0
tcas_el_11 = 0
tcas_el_12 = 0
tcas_el_13 = 0
tcas_el_14 = 0
tcas_el_15 = 0
tcas_el_16 = 0
tcas_el_17 = 0
tcas_el_18 = 0
tcas_el_19 = 0

apu_temp = 0
apu_temp_target = 0
brake_force = 0

left_brake = 0
right_brake = 0
--parkbrake_force = 0

apu_fuel_pump_status = 0
apu_fuel_tank_status = 1

tank_imbal = 0
tank_config = 0

flap_cover_target = 0
gear_cover_target = 0
terr_cover_target = 0
man_landgear_cover_target = 0
man_landgear_target = 0
fdr_cover_target = 0

--landing_gear_act = 0
landing_gear0_act = 0
landing_gear1_act = 0
landing_gear2_act = 0
landing_gear_target = 0

gpws_test_timer = 0

flt_ctr_A_target = 0
flt_ctr_B_target = 0
spoiler_A_target = 0
spoiler_B_target = 0
alt_flaps_target = 0

left_wiper_target = 0
right_wiper_target = 0
left_wiper_speed = 0
right_wiper_speed = 0
left_wiper_timer = 0
right_wiper_timer = 0
l_wiper_first = 0
r_wiper_first = 0

landgear_emergency = 0

brake_compress = 0
brake_decompress = 0
brake_press_target = 0
simDR_brake_old = 0
simDR_left_brake_old = 0
simDR_right_brake_old = 0
brake_inop = 0

first_time = 0

hyd_A_pressure = 0
hyd_B_pressure = 0
hyd_stdby_pressure = 0
hyd_1_max = 0
hyd_2_max = 0
hyd_1_qnt = 0
hyd_2_qnt = 0

act_roll_ratio = 0
act_roll_ratio_trg = 0
act_pitch_ratio = 0
act_pitch_ratio_trg = 0
act_heading_ratio = 0
act_heading_ratio_trg = 0

temp_cont_cab = 0
temp_fwd = 0
temp_aft = 0
temp_fwd_pass_cab = 0
temp_aft_pass_cab = 0
temp_l_pack = 0
temp_r_pack = 0

temp_cont_cab_tgt = 0
temp_fwd_pass_cab_tgt = 0
temp_aft_pass_cab_tgt = 0
temp_l_pack_tgt = 0
temp_r_pack_tgt = 0

fuel_prev_0 = 0
fuel_prev_1 = 0
fuel_prev_2 = 0

yaw_damper_switch_status = 0
yaw_damper_switch_old = 0
irs_left_old = 0
irs_right_old = 0
was_align_left = 0
was_align_right = 0

last_fuel_tank = 0

first_generators1 = 0
first_generators2 = 0

alt_pressurize_auto = 0
alt_pressurize_land = 0
target_cabin_alt = 0
tgt_outflow_valve = 0
press_set_vvi = 800
dump_all = 0

lost_inertial = 0

gear_handle_aret = 0
gear_handle_pos_old = 0
gear_lock = 0

--*************************************************************************************--
--** 					            LOCAL VARIABLES                 				 **--
--*************************************************************************************--

--local B738_cross_feed_selector_knob_target = 0

local pax_oxy = 0

local ground_timer = 0

local dual_bleed = 0

--*************************************************************************************--
--** 				             FIND X-PLANE DATAREFS            			    	 **--
--*************************************************************************************--

-- ANNUNS

simDR_electrical_bus_volts0 = find_dataref("sim/cockpit2/electrical/bus_volts[0]")
simDR_electrical_bus_volts1 = find_dataref("sim/cockpit2/electrical/bus_volts[1]")
simDR_generic_brightness_ratio63 = find_dataref("sim/flightmodel2/lights/generic_lights_brightness_ratio[63]")

--simDR_generic_brightness_switch63 = find_dataref("sim/cockpit2/switches/generic_lights_switch[63]")



simDR_startup_running               = find_dataref("sim/operation/prefs/startup_running")
simDR_electric_hyd_pump_switch		= find_dataref("sim/cockpit2/switches/electric_hydraulic_pump_on")
--simDR_fuel_tank_pump1				= find_dataref("sim/cockpit2/fuel/fuel_tank_pump_on[0]")
--simDR_fuel_tank_pump2				= find_dataref("sim/cockpit2/fuel/fuel_tank_pump_on[1]")
--simDR_fuel_tank_pump3				= find_dataref("sim/cockpit2/fuel/fuel_tank_pump_on[2]")

--simDR_APU_starter_switch = find_dataref("sim/cockpit2/electrical/APU_starter_switch")

simDR_generator1_failure = find_dataref("sim/operation/failures/rel_genera0")
simDR_generator2_failure = find_dataref("sim/operation/failures/rel_genera1")

simDR_generator1_on	= find_dataref("sim/cockpit/electrical/generator_on[0]")
simDR_generator2_on	= find_dataref("sim/cockpit/electrical/generator_on[1]")


--simDR_cross_tie = find_dataref("sim/cockpit2/electrical/cross_tie")

simDR_pax_oxy = find_dataref("sim/operation/failures/rel_pass_o2_on")

simDR_cabin_alt = find_dataref("sim/cockpit2/pressurization/indicators/cabin_altitude_ft")

simDR_bleed_air_mode = find_dataref("sim/cockpit2/pressurization/actuators/bleed_air_mode")

simDR_bleed_fail_1 = find_dataref("sim/operation/failures/rel_bleed_air_lft")
simDR_bleed_fail_2 = find_dataref("sim/operation/failures/rel_bleed_air_rgt")

simDR_apu_bleed_fail = find_dataref("sim/operation/failures/rel_APU_press")

-- DUCT PRESSURE

simDR_apu_N1_pct			= find_dataref("sim/cockpit2/electrical/APU_N1_percent")
simDR_engine_N1_pct1		= find_dataref("sim/cockpit2/engine/indicators/N1_percent[0]")
simDR_engine_N1_pct2		= find_dataref("sim/cockpit2/engine/indicators/N1_percent[1]")


--------------------------- CUSTOM
simDR_engine_N2_pct1		= find_dataref("sim/cockpit2/engine/indicators/N2_percent[0]")
simDR_engine_N2_pct2		= find_dataref("sim/cockpit2/engine/indicators/N2_percent[1]")
simDR_engine_ign1			= find_dataref("sim/cockpit2/engine/actuators/ignition_key[0]")
simDR_engine_ign2			= find_dataref("sim/cockpit2/engine/actuators/ignition_key[1]")
simDR_apu_run				= find_dataref("sim/cockpit/engine/APU_running")

simDR_eng_N2_pct1_inop		= find_dataref("sim/operation/failures/rel_N2_ind0")
simDR_eng_N2_pct2_inop		= find_dataref("sim/operation/failures/rel_N2_ind1")

--simDR_engine_mixture1		= find_dataref("sim/cockpit2/engine/actuators/mixture_ratio[0]")	-- 0.0 cutoff, 1.0 full rich
--simDR_engine_mixture2		= find_dataref("sim/cockpit2/engine/actuators/mixture_ratio[1]")
simDR_engine_mixture1		= find_dataref("laminar/B738/engine/mixture_ratio1")	-- 0.0 cutoff, 1.0 full rich
simDR_engine_mixture2		= find_dataref("laminar/B738/engine/mixture_ratio2")

--simDR_on_ground				= find_dataref("sim/flightmodel2/gear/on_ground[0]")
--------------------------------------


--simDR_elec_bus_volts0		= find_dataref("sim/cockpit2/electrical/bus_volts")

simDR_tank_l_status			= find_dataref("sim/cockpit2/fuel/fuel_tank_pump_on[0]")
simDR_tank_c_status			= find_dataref("sim/cockpit2/fuel/fuel_tank_pump_on[1]")
simDR_tank_r_status			= find_dataref("sim/cockpit2/fuel/fuel_tank_pump_on[2]")

simDR_fuel_selector_l		= find_dataref("sim/cockpit2/fuel/fuel_tank_selector_left")
simDR_fuel_selector_r		= find_dataref("sim/cockpit2/fuel/fuel_tank_selector_right")

simDR_left_tank_level		= find_dataref("sim/cockpit2/fuel/fuel_quantity[0]")
simDR_right_tank_level		= find_dataref("sim/cockpit2/fuel/fuel_quantity[2]")
simDR_center_tank_level		= find_dataref("sim/cockpit2/fuel/fuel_quantity[1]")
simDR_aircraft_on_ground    = find_dataref("sim/flightmodel/failures/onground_all")
simDR_aircraft_on_ground_any	= find_dataref("sim/flightmodel/failures/onground_any")
simDR_yaw_damper_switch		= find_dataref("sim/cockpit2/switches/yaw_damper_on")
simDR_apu_generator_switch	= find_dataref("sim/cockpit2/electrical/APU_generator_on")

simDR_strobes_switch		= find_dataref("sim/cockpit2/switches/strobe_lights_on")
simDR_nav_switch			= find_dataref("sim/cockpit2/switches/navigation_lights_on")
simDR_landing_light_on_0	= find_dataref("sim/cockpit2/switches/landing_lights_switch[0]")
simDR_landing_light_on_1	= find_dataref("sim/cockpit2/switches/landing_lights_switch[1]")
simDR_landing_light_on_2	= find_dataref("sim/cockpit2/switches/landing_lights_switch[2]")
simDR_landing_light_on_3	= find_dataref("sim/cockpit2/switches/landing_lights_switch[3]")
simDR_avionics_switch		= find_dataref("sim/cockpit2/switches/avionics_power_on")

simDR_transponder_mode		= find_dataref("sim/cockpit2/radios/actuators/transponder_mode")

simDR_stby_power_volts		= find_dataref("sim/cockpit2/electrical/battery_voltage_indicated_volts[1]")
simDR_grd_power_volts		= find_dataref("sim/cockpit2/electrical/dc_voltmeter_selection[0]")
simDR_gen1_amps				= find_dataref("sim/cockpit2/electrical/generator_amps[0]")
simDR_apu_gen_amps			= find_dataref("sim/cockpit2/electrical/APU_generator_amps")
simDR_gen2_amps				= find_dataref("sim/cockpit2/electrical/generator_amps[1]")
simDR_inverter_on			= find_dataref("sim/cockpit2/electrical/inverter_on[0]")
simDR_gpu_amps				= find_dataref("sim/cockpit/electrical/gpu_amps")

simDR_prop_mode0			= find_dataref("sim/cockpit2/engine/actuators/prop_mode[0]")
simDR_prop_mode1			= find_dataref("sim/cockpit2/engine/actuators/prop_mode[1]")

--simDR_idle_speed0			= find_dataref("sim/cockpit2/engine/actuators/idle_speed[0]")
--simDR_idle_speed1			= find_dataref("sim/cockpit2/engine/actuators/idle_speed[1]")


simDR_gear_handle_status	= find_dataref("sim/cockpit/switches/gear_handle_status")

simDR_apu_status 			= find_dataref("sim/cockpit2/electrical/APU_N1_percent")
simDR_apu_on				= find_dataref("sim/cockpit/electrical/generator_apu_on")

simDR_throttle_all		= find_dataref("sim/cockpit2/engine/actuators/throttle_ratio_all")
simDR_aircraft_groundspeed      = find_dataref("sim/flightmodel/position/groundspeed")
simDR_brake						= find_dataref("sim/cockpit2/controls/parking_brake_ratio")
simDR_left_brake				= find_dataref("sim/cockpit2/controls/left_brake_ratio")
simDR_right_brake				= find_dataref("sim/cockpit2/controls/right_brake_ratio")
simDR_on_ground_0				= find_dataref("sim/flightmodel2/gear/on_ground[0]")
simDR_on_ground_1				= find_dataref("sim/flightmodel2/gear/on_ground[1]")
simDR_on_ground_2				= find_dataref("sim/flightmodel2/gear/on_ground[2]")
simDR_radio_height_pilot_ft		= find_dataref("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot")
simDR_nosewheel_speed			= find_dataref("sim/flightmodel/misc/nosewheel_speed")

simDR_reverse1_deploy			= find_dataref("sim/flightmodel2/engines/thrust_reverser_deploy_ratio[0]")
simDR_reverse2_deploy			= find_dataref("sim/flightmodel2/engines/thrust_reverser_deploy_ratio[1]")

simDR_throttle_override			= find_dataref("sim/operation/override/override_throttles")

simDR_airspeed_pilot			= find_dataref("sim/cockpit2/gauges/indicators/airspeed_kts_pilot")

simDR_ground_speed				= find_dataref("sim/flightmodel/position/groundspeed")

simDR_altitude_pilot			= find_dataref("sim/cockpit2/gauges/indicators/altitude_ft_pilot")
simDR_vvi_fpm_pilot				= find_dataref("sim/cockpit2/gauges/indicators/vvi_fpm_pilot")

--simDR_ground_speed		= find_dataref("sim/time/ground_speed")
simDR_air_temp			= find_dataref("sim/cockpit2/temperature/outside_air_temp_degc")
simDR_total_weight		= find_dataref("sim/flightmodel/weight/m_total")


simDR_speedbrake_ratio			= find_dataref("sim/cockpit2/controls/speedbrake_ratio")
simDR_reverser_on_0				= find_dataref("sim/cockpit/warnings/annunciators/reverser_on[0]")
simDR_reverser_on_1				= find_dataref("sim/cockpit/warnings/annunciators/reverser_on[1]")

B738DR_eng1_N1					= find_dataref("laminar/B738/engine/indicators/N1_percent_1")
B738DR_eng2_N1					= find_dataref("laminar/B738/engine/indicators/N1_percent_2")


simDR_pitot_capt		= find_dataref("sim/cockpit2/ice/ice_pitot_heat_on_pilot")
simDR_pitot_fo			= find_dataref("sim/cockpit2/ice/ice_pitot_heat_on_copilot")
simDR_aoa_capt			= find_dataref("sim/cockpit2/ice/ice_AOA_heat_on")
simDR_aoa_fo			= find_dataref("sim/cockpit2/ice/ice_AOA_heat_on_copilot")

--- TACS ---
--simDR_mag_hdg			= find_dataref("sim/cockpit/misc/compass_indicated")
simDR_mag_hdg			= find_dataref("sim/cockpit2/gauges/indicators/ground_track_mag_pilot")

simDR_efis_map_range	= find_dataref("sim/cockpit2/EFIS/map_range")
simDR_map_mode_is_HSI	= find_dataref("sim/cockpit2/EFIS/map_mode_is_HSI")
B738DR_EFIS_TCAS_on		= find_dataref("laminar/B738/EFIS/tcas_on")

simDR_ahars_mag_hdg		= find_dataref("sim/cockpit2/gauges/indicators/heading_AHARS_deg_mag_pilot")


simDR_lat				= find_dataref("sim/flightmodel/position/latitude")
simDR_lon				= find_dataref("sim/flightmodel/position/longitude")
simDR_el				= find_dataref("sim/flightmodel/position/elevation")

simDR_ai_1_lat			= find_dataref("sim/multiplayer/position/plane1_lat")
simDR_ai_1_lon			= find_dataref("sim/multiplayer/position/plane1_lon")
simDR_ai_1_el			= find_dataref("sim/multiplayer/position/plane1_el")
simDR_ai_1_z			= find_dataref("sim/multiplayer/position/plane1_z")

simDR_ai_2_lat			= find_dataref("sim/multiplayer/position/plane2_lat")
simDR_ai_2_lon			= find_dataref("sim/multiplayer/position/plane2_lon")
simDR_ai_2_el			= find_dataref("sim/multiplayer/position/plane2_el")
simDR_ai_2_z			= find_dataref("sim/multiplayer/position/plane2_z")

simDR_ai_3_lat			= find_dataref("sim/multiplayer/position/plane3_lat")
simDR_ai_3_lon			= find_dataref("sim/multiplayer/position/plane3_lon")
simDR_ai_3_el			= find_dataref("sim/multiplayer/position/plane3_el")
simDR_ai_3_z			= find_dataref("sim/multiplayer/position/plane3_z")

simDR_ai_4_lat			= find_dataref("sim/multiplayer/position/plane4_lat")
simDR_ai_4_lon			= find_dataref("sim/multiplayer/position/plane4_lon")
simDR_ai_4_el			= find_dataref("sim/multiplayer/position/plane4_el")
simDR_ai_4_z			= find_dataref("sim/multiplayer/position/plane4_z")

simDR_ai_5_lat			= find_dataref("sim/multiplayer/position/plane5_lat")
simDR_ai_5_lon			= find_dataref("sim/multiplayer/position/plane5_lon")
simDR_ai_5_el			= find_dataref("sim/multiplayer/position/plane5_el")
simDR_ai_5_z			= find_dataref("sim/multiplayer/position/plane5_z")

simDR_ai_6_lat			= find_dataref("sim/multiplayer/position/plane6_lat")
simDR_ai_6_lon			= find_dataref("sim/multiplayer/position/plane6_lon")
simDR_ai_6_el			= find_dataref("sim/multiplayer/position/plane6_el")
simDR_ai_6_z			= find_dataref("sim/multiplayer/position/plane6_z")

simDR_ai_7_lat			= find_dataref("sim/multiplayer/position/plane7_lat")
simDR_ai_7_lon			= find_dataref("sim/multiplayer/position/plane7_lon")
simDR_ai_7_el			= find_dataref("sim/multiplayer/position/plane7_el")
simDR_ai_7_z			= find_dataref("sim/multiplayer/position/plane7_z")

simDR_ai_8_lat			= find_dataref("sim/multiplayer/position/plane8_lat")
simDR_ai_8_lon			= find_dataref("sim/multiplayer/position/plane8_lon")
simDR_ai_8_el			= find_dataref("sim/multiplayer/position/plane8_el")
simDR_ai_8_z			= find_dataref("sim/multiplayer/position/plane8_z")

simDR_ai_9_lat			= find_dataref("sim/multiplayer/position/plane9_lat")
simDR_ai_9_lon			= find_dataref("sim/multiplayer/position/plane9_lon")
simDR_ai_9_el			= find_dataref("sim/multiplayer/position/plane9_el")
simDR_ai_9_z			= find_dataref("sim/multiplayer/position/plane9_z")

simDR_ai_10_lat			= find_dataref("sim/multiplayer/position/plane10_lat")
simDR_ai_10_lon			= find_dataref("sim/multiplayer/position/plane10_lon")
simDR_ai_10_el			= find_dataref("sim/multiplayer/position/plane10_el")
simDR_ai_10_z			= find_dataref("sim/multiplayer/position/plane10_z")

simDR_ai_11_lat			= find_dataref("sim/multiplayer/position/plane11_lat")
simDR_ai_11_lon			= find_dataref("sim/multiplayer/position/plane11_lon")
simDR_ai_11_el			= find_dataref("sim/multiplayer/position/plane11_el")
simDR_ai_11_z			= find_dataref("sim/multiplayer/position/plane11_z")

simDR_ai_12_lat			= find_dataref("sim/multiplayer/position/plane12_lat")
simDR_ai_12_lon			= find_dataref("sim/multiplayer/position/plane12_lon")
simDR_ai_12_el			= find_dataref("sim/multiplayer/position/plane12_el")
simDR_ai_12_z			= find_dataref("sim/multiplayer/position/plane12_z")

simDR_ai_13_lat			= find_dataref("sim/multiplayer/position/plane13_lat")
simDR_ai_13_lon			= find_dataref("sim/multiplayer/position/plane13_lon")
simDR_ai_13_el			= find_dataref("sim/multiplayer/position/plane13_el")
simDR_ai_13_z			= find_dataref("sim/multiplayer/position/plane13_z")

simDR_ai_14_lat			= find_dataref("sim/multiplayer/position/plane14_lat")
simDR_ai_14_lon			= find_dataref("sim/multiplayer/position/plane14_lon")
simDR_ai_14_el			= find_dataref("sim/multiplayer/position/plane14_el")
simDR_ai_14_z			= find_dataref("sim/multiplayer/position/plane14_z")

simDR_ai_15_lat			= find_dataref("sim/multiplayer/position/plane15_lat")
simDR_ai_15_lon			= find_dataref("sim/multiplayer/position/plane15_lon")
simDR_ai_15_el			= find_dataref("sim/multiplayer/position/plane15_el")
simDR_ai_15_z			= find_dataref("sim/multiplayer/position/plane15_z")

simDR_ai_16_lat			= find_dataref("sim/multiplayer/position/plane16_lat")
simDR_ai_16_lon			= find_dataref("sim/multiplayer/position/plane16_lon")
simDR_ai_16_el			= find_dataref("sim/multiplayer/position/plane16_el")
simDR_ai_16_z			= find_dataref("sim/multiplayer/position/plane16_z")

simDR_ai_17_lat			= find_dataref("sim/multiplayer/position/plane17_lat")
simDR_ai_17_lon			= find_dataref("sim/multiplayer/position/plane17_lon")
simDR_ai_17_el			= find_dataref("sim/multiplayer/position/plane17_el")
simDR_ai_17_z			= find_dataref("sim/multiplayer/position/plane17_z")

simDR_ai_18_lat			= find_dataref("sim/multiplayer/position/plane18_lat")
simDR_ai_18_lon			= find_dataref("sim/multiplayer/position/plane18_lon")
simDR_ai_18_el			= find_dataref("sim/multiplayer/position/plane18_el")
simDR_ai_18_z			= find_dataref("sim/multiplayer/position/plane18_z")

simDR_ai_19_lat			= find_dataref("sim/multiplayer/position/plane19_lat")
simDR_ai_19_lon			= find_dataref("sim/multiplayer/position/plane19_lon")
simDR_ai_19_el			= find_dataref("sim/multiplayer/position/plane19_el")
simDR_ai_19_z			= find_dataref("sim/multiplayer/position/plane19_z")

B738DR_cabin_alt_wrn		= find_dataref("laminar/B738/annunciator/cabin_alt")

simDR_toe_brakes_ovr	= find_dataref("sim/operation/override/override_toe_brakes")

simDR_steer_cmd			= find_dataref("sim/flightmodel2/gear/tire_steer_command_deg[0]")
simDR_steer_ovr			= find_dataref("sim/operation/override/override_wheel_steer")
simDR_yoke_hdg_ratio	= find_dataref("sim/cockpit2/controls/yoke_heading_ratio")
simDR_yoke_roll2_ratio	= find_dataref("sim/cockpit2/controls/yoke_roll_ratio")
simDR_faxil_plug		= find_dataref("sim/flightmodel/forces/faxil_plug_acf")
--simDR_ovr_forces		= find_dataref("sim/operation/override/override_forces")

simDR_fuel_tank_weight_kg 	= find_dataref("sim/flightmodel/weight/m_fuel")
simDR_fuel_flow_kg_sec 		= find_dataref("sim/cockpit2/engine/indicators/fuel_flow_kg_sec")

simDR_gear_deploy_0		= find_dataref("sim/aircraft/parts/acf_gear_deploy[0]")
simDR_gear_deploy_1		= find_dataref("sim/aircraft/parts/acf_gear_deploy[1]")
simDR_gear_deploy_2		= find_dataref("sim/aircraft/parts/acf_gear_deploy[2]")
--simDR_gear_handle		= find_dataref("im/cockpit2/controls/gear_handle_down")

simDR_hydraulic_press_1	= find_dataref("sim/cockpit2/hydraulics/indicators/hydraulic_pressure_1")
simDR_hydraulic_press_2	= find_dataref("sim/cockpit2/hydraulics/indicators/hydraulic_pressure_2")

simDR_gpu_on				= find_dataref("sim/cockpit/electrical/gpu_on")

simDR_press_max_alt		= find_dataref("sim/cockpit/pressure/max_allowable_altitude")
simDR_press_set_alt		= find_dataref("sim/cockpit/pressure/cabin_altitude_set_m_msl")
simDR_press_set_vvi		= find_dataref("sim/cockpit/pressure/cabin_vvi_set_m_msec")
simDR_dump_all			= find_dataref("sim/cockpit/pressure/dump_all")
simDR_dump_to_alt		= find_dataref("sim/cockpit/pressure/dump_to_alt")
simDR_cabin_vvi 		= find_dataref("sim/cockpit/pressure/cabin_vvi_actual_m_msec")
simDR_cabin_alt_tgt 	= find_dataref("sim/cockpit2/pressurization/actuators/cabin_altitude_ft")

simDR_TAT				= find_dataref("sim/cockpit2/temperature/outside_air_LE_temp_degc")

simDR_roll_brake		= find_dataref("sim/aircraft/overflow/acf_brake_co")
simDR_roll_co			= find_dataref("sim/aircraft/overflow/acf_roll_co")

simDR_outflow_ratio		= find_dataref("sim/flightmodel2/misc/pressure_outflow_ratio")

simDR_panel_brightness 		= find_dataref("sim/cockpit2/switches/panel_brightness_ratio")
simDR_instrument_brightness	= find_dataref("sim/cockpit2/switches/instrument_brightness_ratio")

simDR_engine_fire_ext_on 					= find_dataref("sim/cockpit2/engine/actuators/fire_extinguisher_on")
B738DR_engine01_fire_ext_switch_pos_arm 	= find_dataref("laminar/B738/fire/engine01/ext_switch/pos_arm")
B738DR_engine02_fire_ext_switch_pos_arm 	= find_dataref("laminar/B738/fire/engine02/ext_switch/pos_arm")
B738DR_apu_fire_ext_switch_pos_arm 			= find_dataref("laminar/B738/fire/apu/ext_switch/pos_arm")

simDR_flaps_ratio				= find_dataref("sim/cockpit2/controls/flap_ratio")
simDR_throttle_1				= find_dataref("sim/cockpit2/engine/actuators/throttle_ratio[0]")
simDR_throttle_2				= find_dataref("sim/cockpit2/engine/actuators/throttle_ratio[1]")

--*************************************************************************************--
--** 				               FIND X-PLANE COMMANDS                   	    	 **--
--*************************************************************************************--

simCMD_capt_AOA_ice_on				= find_command("sim/ice/AOA_heat0_on")
simCMD_capt_AOA_ice_off				= find_command("sim/ice/AOA_heat0_off")

simCMD_fo_AOA_ice_on				= find_command("sim/ice/AOA_heat1_on")
simCMD_fo_AOA_ice_off				= find_command("sim/ice/AOA_heat1_off")

simCMD_capt_pitot_ice_on			= find_command("sim/ice/pitot_heat0_on")
simCMD_capt_pitot_ice_off			= find_command("sim/ice/pitot_heat0_off")

simCMD_fo_pitot_ice_on				= find_command("sim/ice/pitot_heat1_on")
simCMD_fo_pitot_ice_off				= find_command("sim/ice/pitot_heat1_off")

simCMD_apu_off						= find_command("sim/electrical/APU_off")
simCMD_apu_on						= find_command("sim/electrical/APU_on")
simCMD_apu_start					= find_command("sim/electrical/APU_start")

simCMD_hydro_pumps_toggle			= find_command("sim/flight_controls/hydraulic_tog")
simCMD_hydro_pumps_on				= find_command("sim/flight_controls/hydraulic_on")
simCMD_hydro_pumps_off				= find_command("sim/flight_controls/hydraulic_off")


simCMD_stall_test					= find_command("sim/annunciator/test_stall")
simCMD_xponder_ident				= find_command("sim/transponder/transponder_ident")

simCMD_nav1_standy_flip				= find_command("sim/radios/nav1_standy_flip")
simCMD_nav2_standy_flip				= find_command("sim/radios/nav2_standy_flip")

simCMD_dc_volt_left					= find_command("sim/electrical/dc_volt_lft")
simCMD_dc_volt_center				= find_command("sim/electrical/dc_volt_ctr")
simCMD_dc_volt_right				= find_command("sim/electrical/dc_volt_rgt")

simCMD_hi_lo_idle_toggle			= find_command("sim/engines/idle_hi_lo_toggle")

simCMD_gear_down 					= find_command("sim/flight_controls/landing_gear_down")
simCMD_gear_up 						= find_command("sim/flight_controls/landing_gear_up")

simCMD_apu_gen_off 				= find_command("sim/electrical/APU_generator_off")
simCMD_apu_gen_on 				= find_command("sim/electrical/APU_generator_on")

simCMD_generator_1_off			= find_command("sim/electrical/generator_1_off")
simCMD_generator_1_on			= find_command("sim/electrical/generator_1_on")
simCMD_generator_2_off			= find_command("sim/electrical/generator_2_off")
simCMD_generator_2_on			= find_command("sim/electrical/generator_2_on")

simCMD_gpu_on					= find_command("sim/electrical/GPU_on")
simCMD_gpu_off					= find_command("sim/electrical/GPU_off")

simDR_lndgear_emer_on			= find_command("sim/flight_controls/landing_gear_emer_on")
simDR_lndgear_emer_off			= find_command("sim/flight_controls/landing_gear_emer_off")

simDR_override_heading			= find_dataref("sim/operation/override/override_joystick_heading")
simDR_override_pitch			= find_dataref("sim/operation/override/override_joystick_pitch")
simDR_override_roll				= find_dataref("sim/operation/override/override_joystick_roll")

-- simDR_yoke_heading_ratio		= find_dataref("sim/joystick/joystick_axis_values[3]")
-- simDR_yoke_pitch_ratio			= find_dataref("sim/joystick/joystick_axis_values[0]")
-- simDR_yoke_roll_ratio			= find_dataref("sim/joystick/joystick_axis_values[1]")


simDR_heading_ratio			= find_dataref("sim/joystick/yoke_heading_ratio")
simDR_pitch_ratio			= find_dataref("sim/joystick/yoke_pitch_ratio")
simDR_roll_ratio			= find_dataref("sim/joystick/yoke_roll_ratio")

simDR_spoiler_left			= find_dataref("sim/flightmodel2/wing/spoiler1_deg[0]")
simDR_spoiler_right			= find_dataref("sim/flightmodel2/wing/spoiler1_deg[1]")

simDR_bus_volts1		= find_dataref("sim/cockpit2/electrical/bus_volts[0]")
simDR_bus_volts2		= find_dataref("sim/cockpit2/electrical/bus_volts[1]")
simDR_bus_volts3		= find_dataref("sim/cockpit2/electrical/bus_volts[2]")
simDR_bus_battery1		= find_dataref("sim/cockpit2/electrical/battery_voltage_actual_volts[0]")
simDR_bus_battery2		= find_dataref("sim/cockpit2/electrical/battery_voltage_actual_volts[1]")
simDR_bus_battery1_on	= find_dataref("sim/cockpit2/electrical/battery_on[0]")
simDR_bus_battery2_on	= find_dataref("sim/cockpit2/electrical/battery_on[1]")

simDR_bus_transfer_on 		= find_dataref("sim/cockpit2/electrical/cross_tie")

simDR_starter_torque 	= find_dataref("sim/aircraft/engine/acf_starter_torque_ratio")
simDR_starter_max_rpm 	= find_dataref("sim/aircraft/engine/acf_starter_max_rpm_ratio")

--*************************************************************************************--
--** 				              FIND CUSTOM DATAREFS             			    	 **--
--*************************************************************************************--

simDR_elevation_m				= find_dataref("sim/flightmodel/position/elevation")

simDR_nose_gear_fail = find_dataref("sim/operation/failures/rel_collapse1")
simDR_left_gear_fail = find_dataref("sim/operation/failures/rel_collapse2")
simDR_right_gear_fail = find_dataref("sim/operation/failures/rel_collapse3")

B738DR_lights_test					= find_dataref("laminar/B738/annunciator/test")
B738DR_position_light_switch_pos	= find_dataref("laminar/B738/toggle_switch/position_light_pos")

simDR_tire_speed0			= find_dataref("sim/flightmodel/parts/tire_speed_now[0]")
simDR_tire_speed1			= find_dataref("sim/flightmodel/parts/tire_speed_now[1]")
simDR_tire_speed2			= find_dataref("sim/flightmodel/parts/tire_speed_now[2]")
simDR_side_slip				= find_dataref("sim/cockpit2/gauges/indicators/sideslip_degrees")

B738DR_thrust1_leveler		= find_dataref("laminar/B738/engine/thrust1_leveler")
B738DR_thrust2_leveler		= find_dataref("laminar/B738/engine/thrust2_leveler")

B738_landing_gear			= find_dataref("laminar/B738/switches/landing_gear")

B738DR_irs_left_mode		= find_dataref("laminar/B738/irs/irs_mode")
B738DR_irs_right_mode		= find_dataref("laminar/B738/irs/irs2_mode")

simDR_mag_variation		= find_dataref("sim/flightmodel/position/magnetic_variation")

B738DR_chock_status		= find_dataref("laminar/B738/fms/chock_status")

B738DR_apu_was_fire		= find_dataref("laminar/B738/fire/apu/was_fire")

B738DR_enable_gpwstest_long		= find_dataref("laminar/b738/fmodpack/fmod_gpwstest_long_on")
B738DR_enable_gpwstest_short	= find_dataref("laminar/b738/fmodpack/fmod_gpwstest_short_on")

B738DR_toe_brakes_ovr	= find_dataref("laminar/B738/fms/toe_brakes_ovr")
B738DR_nosewheel		= find_dataref("laminar/B738/effects/nosewheel")


B738DR_engine_no_running_state = find_dataref("laminar/B738/fms/engine_no_running_state")
B738DR_parkbrake_remove_chock = find_dataref("laminar/B738/fms/parkbrake_remove_chock")

B738DR_efis_map_range_capt 		= find_dataref("laminar/B738/EFIS/capt/map_range")
B738DR_efis_map_range_fo 		= find_dataref("laminar/B738/EFIS/fo/map_range")


B738DR_capt_map_mode		= find_dataref("laminar/B738/EFIS_control/capt/map_mode_pos")
B738DR_fo_map_mode			= find_dataref("laminar/B738/EFIS_control/fo/map_mode_pos")
B738DR_capt_exp_map_mode	= find_dataref("laminar/B738/EFIS_control/capt/exp_map")
B738DR_fo_exp_map_mode		= find_dataref("laminar/B738/EFIS_control/fo/exp_map")

B738DR_track_up				= find_dataref("laminar/B738/fms/track_up")
B738DR_track_up_active		= find_dataref("laminar/B738/fms/track_up_active")


B738DR_irs_source 			= find_dataref("laminar/B738/toggle_switch/irs_source")
B738DR_irs_left 			= find_dataref("laminar/B738/toggle_switch/irs_left")
B738DR_irs_right 			= find_dataref("laminar/B738/toggle_switch/irs_right")
B738DR_irs_align_fail_right	= find_dataref("laminar/B738/annunciator/irs_align_fail_right")
B738DR_irs_align_fail_left	= find_dataref("laminar/B738/annunciator/irs_align_fail_left")
alignment_left_remain		= find_dataref("laminar/B738/irs/alignment_left_remain")
alignment_right_remain		= find_dataref("laminar/B738/irs/alignment_right_remain")
B738DR_irs_align_left		= find_dataref("laminar/B738/annunciator/irs_align_left")
B738DR_irs_align_right		= find_dataref("laminar/B738/annunciator/irs_align_right")

B738DR_source_off_bus1		= find_dataref("laminar/B738/annunciator/source_off1")
B738DR_source_off_bus2		= find_dataref("laminar/B738/annunciator/source_off2")

simDR_engine1_on = find_dataref("sim/flightmodel2/engines/engine_is_burning_fuel[0]")
simDR_engine2_on = find_dataref("sim/flightmodel2/engines/engine_is_burning_fuel[1]")

B738DR_low_fuel_press_l1_annun	= find_dataref("laminar/B738/annunciator/low_fuel_press_l1")
B738DR_low_fuel_press_l2_annun	= find_dataref("laminar/B738/annunciator/low_fuel_press_l2")

B738DR_low_fuel_press_c1_annun	= find_dataref("laminar/B738/annunciator/low_fuel_press_c1")
B738DR_low_fuel_press_c2_annun	= find_dataref("laminar/B738/annunciator/low_fuel_press_c2")

B738DR_low_fuel_press_r1_annun	= find_dataref("laminar/B738/annunciator/low_fuel_press_r1")
B738DR_low_fuel_press_r2_annun	= find_dataref("laminar/B738/annunciator/low_fuel_press_r2")

B738DR_flight_phase				= find_dataref("laminar/B738/FMS/flight_phase")

simDR_gen1_on					= find_dataref("sim/cockpit2/electrical/generator_on[0]")
simDR_gen2_on					= find_dataref("sim/cockpit2/electrical/generator_on[1]")

simDR_gen_off_bus1 				= find_dataref("sim/cockpit2/annunciators/generator_off[0]")
simDR_gen_off_bus2 				= find_dataref("sim/cockpit2/annunciators/generator_off[1]")

--*************************************************************************************--
--** 				              FIND CUSTOM COMMANDS              			     **--
--*************************************************************************************--

B738CMD_position_light_switch_dn 	= find_command("laminar/B738/toggle_switch/position_light_down")

--*************************************************************************************--
--** 				        CREATE READ-ONLY CUSTOM DATAREFS               	         **--
--*************************************************************************************--


B738DR_apu_start_switch_position	= create_dataref("laminar/B738/spring_toggle_switch/APU_start_pos", "number")

B738DR_drive_disconnect1_switch_position = create_dataref("laminar/B738/one_way_switch/drive_disconnect1_pos", "number")
B738DR_drive_disconnect2_switch_position = create_dataref("laminar/B738/one_way_switch/drive_disconnect2_pos", "number")

B738DR_pas_oxy_switch_position = create_dataref("laminar/B738/one_way_switch/pax_oxy_pos", "number")

--B738DR_bleed_air_1_switch_position = create_dataref("laminar/B738/toggle_switch/bleed_air_1_pos", "number")
--B738DR_bleed_air_2_switch_position = create_dataref("laminar/B738/toggle_switch/bleed_air_2_pos", "number")
--B738DR_bleed_air_apu_switch_position = create_dataref("laminar/B738/toggle_switch/bleed_air_apu_pos", "number")

B738DR_dual_bleed_annun = create_dataref("laminar/B738/annunciator/dual_bleed", "number")

B738DR_trip_reset_button_pos = create_dataref("laminar/B738/push_button/trip_reset", "number")

B738DR_duct_pressure_L = create_dataref("laminar/B738/indicators/duct_press_L", "number")
B738DR_duct_pressure_R = create_dataref("laminar/B738/indicators/duct_press_R", "number")

B738DR_cross_feed_selector_knob 	= create_dataref("laminar/B738/knobs/cross_feed", "number")
B738DR_cross_feed_valve			 	= create_dataref("laminar/B738/fuel/cross_feed_valve", "number")

B738DR_stall_test1	= create_dataref("laminar/B738/push_button/stall_test1", "number")
B738DR_stall_test2	= create_dataref("laminar/B738/push_button/stall_test2", "number")

B738DR_transponder_knob_pos = create_dataref("laminar/B738/knob/transponder_pos", "number")
B738DR_transponder_ident_button = create_dataref("laminar/B738/push_button/transponder_ident", "number")

B738DR_nav1_freq_flip_button = create_dataref("laminar/B738/push_button/switch_freq_nav1", "number")
B738DR_nav2_freq_flip_button = create_dataref("laminar/B738/push_button/switch_freq_nav2", "number")

B738DR_dc_power_knob_pos	= create_dataref("laminar/B738/knob/dc_power", "number")
B738DR_ac_power_knob_pos	= create_dataref("laminar/B738/knob/ac_power", "number")

B738DR_ac_freq_mode0		= create_dataref("laminar/B738/ac_freq_mode0", "number")
B738DR_ac_freq_mode1		= create_dataref("laminar/B738/ac_freq_mode1", "number")
B738DR_ac_freq_mode2		= create_dataref("laminar/B738/ac_freq_mode2", "number")
B738DR_ac_freq_mode3		= create_dataref("laminar/B738/ac_freq_mode3", "number")
B738DR_ac_freq_mode4		= create_dataref("laminar/B738/ac_freq_mode4", "number")
B738DR_ac_freq_mode5		= create_dataref("laminar/B738/ac_freq_mode5", "number")

B738DR_ac_volt_mode1		= create_dataref("laminar/B738/ac_volt_mode1", "number")
B738DR_ac_volt_mode2		= create_dataref("laminar/B738/ac_volt_mode2", "number")
B738DR_ac_volt_mode3		= create_dataref("laminar/B738/ac_volt_mode3", "number")
B738DR_ac_volt_mode4		= create_dataref("laminar/B738/ac_volt_mode4", "number")
B738DR_ac_volt_mode5		= create_dataref("laminar/B738/ac_volt_mode5", "number")

B738DR_prop_mode_sync		= create_dataref("laminar/B738/engine/prop_mode_sync", "number")

B738DR_idle_mode_request	= create_dataref("laminar/B738/engine/idle_mode_request", "number")

B738DR_tire_speed0			= create_dataref("laminar/B738/systems/tire_speed0", "number")
B738DR_tire_speed1			= create_dataref("laminar/B738/systems/tire_speed1", "number")
B738DR_tire_speed2			= create_dataref("laminar/B738/systems/tire_speed2", "number")


--B738DR_parking_brake_pos	= create_dataref("laminar/B738/parking_brake_pos", "number")

B738_EFIS_TCAS_show			= create_dataref("laminar/B738/EFIS/tcas_show", "number")
B738_EFIS_tfc_show			= create_dataref("laminar/B738/EFIS/tfc_show", "number")
B738_EFIS_ta_only_show		= create_dataref("laminar/B738/EFIS/ta_only_show", "number")
B738_EFIS_tcas_test_show	= create_dataref("laminar/B738/EFIS/tcas_test_show", "number")
B738_EFIS_tcas_off_show		= create_dataref("laminar/B738/EFIS/tcas_off_show", "number")
B738_EFIS_tcas_fail_show	= create_dataref("laminar/B738/EFIS/tcas_fail_show", "number")
B738_EFIS_traffic_ra 		= create_dataref("laminar/B738/TCAS/traffic_ra", "number")
B738_EFIS_traffic_ta 		= create_dataref("laminar/B738/TCAS/traffic_ta", "number")

B738_EFIS_tfc_show_fo		= create_dataref("laminar/B738/EFIS/tfc_show_fo", "number")
B738_EFIS_ta_only_show_fo	= create_dataref("laminar/B738/EFIS/ta_only_show_fo", "number")
B738_EFIS_tcas_test_show_fo	= create_dataref("laminar/B738/EFIS/tcas_test_show_fo", "number")
B738_EFIS_tcas_off_show_fo	= create_dataref("laminar/B738/EFIS/tcas_off_show_fo", "number")
B738_EFIS_tcas_fail_show_fo	= create_dataref("laminar/B738/EFIS/tcas_fail_show_fo", "number")
B738_EFIS_traffic_ra_fo 	= create_dataref("laminar/B738/TCAS/traffic_ra_fo", "number")
B738_EFIS_traffic_ta_fo 	= create_dataref("laminar/B738/TCAS/traffic_ta_fo", "number")

B738DR_tcas_nearest_plane_m	= create_dataref("laminar/B738/TCAS/nearest_plane_m", "number")


--- TCAS
B738DR_tcas_x				= create_dataref("laminar/B738/TCAS/x", "number")
B738DR_tcas_y				= create_dataref("laminar/B738/TCAS/y", "number")
B738DR_tcas_alt				= create_dataref("laminar/B738/TCAS/alt", "string")
B738DR_tcas_alt_up_show		= create_dataref("laminar/B738/TCAS/alt_up_show", "number")
B738DR_tcas_alt_dn_show		= create_dataref("laminar/B738/TCAS/alt_dn_show", "number")
B738DR_tcas_arr_up_show		= create_dataref("laminar/B738/TCAS/arrow_up_show", "number")
B738DR_tcas_arr_dn_show		= create_dataref("laminar/B738/TCAS/arrow_dn_show", "number")
B738DR_tcas_box_show		= create_dataref("laminar/B738/TCAS/box_show", "number")
B738DR_tcas_circle_show		= create_dataref("laminar/B738/TCAS/circle_show", "number")
B738DR_tcas_diam_show		= create_dataref("laminar/B738/TCAS/diamond_show", "number")
B738DR_tcas_diam_e_show		= create_dataref("laminar/B738/TCAS/diamond_e_show", "number")
B738_EFIS_TCAS_show1		= create_dataref("laminar/B738/EFIS/tcas_show1", "number")

B738DR_tcas_x2				= create_dataref("laminar/B738/TCAS/x2", "number")
B738DR_tcas_y2				= create_dataref("laminar/B738/TCAS/y2", "number")
B738DR_tcas_alt2				= create_dataref("laminar/B738/TCAS/alt2", "string")
B738DR_tcas_alt_up_show2		= create_dataref("laminar/B738/TCAS/alt_up_show2", "number")
B738DR_tcas_alt_dn_show2		= create_dataref("laminar/B738/TCAS/alt_dn_show2", "number")
B738DR_tcas_arr_up_show2		= create_dataref("laminar/B738/TCAS/arrow_up_show2", "number")
B738DR_tcas_arr_dn_show2		= create_dataref("laminar/B738/TCAS/arrow_dn_show2", "number")
B738DR_tcas_box_show2		= create_dataref("laminar/B738/TCAS/box_show2", "number")
B738DR_tcas_circle_show2		= create_dataref("laminar/B738/TCAS/circle_show2", "number")
B738DR_tcas_diam_show2		= create_dataref("laminar/B738/TCAS/diamond_show2", "number")
B738DR_tcas_diam_e_show2		= create_dataref("laminar/B738/TCAS/diamond_e_show2", "number")
B738_EFIS_TCAS_show2		= create_dataref("laminar/B738/EFIS/tcas_show2", "number")

B738DR_tcas_x3				= create_dataref("laminar/B738/TCAS/x3", "number")
B738DR_tcas_y3				= create_dataref("laminar/B738/TCAS/y3", "number")
B738DR_tcas_alt3				= create_dataref("laminar/B738/TCAS/alt3", "string")
B738DR_tcas_alt_up_show3		= create_dataref("laminar/B738/TCAS/alt_up_show3", "number")
B738DR_tcas_alt_dn_show3		= create_dataref("laminar/B738/TCAS/alt_dn_show3", "number")
B738DR_tcas_arr_up_show3		= create_dataref("laminar/B738/TCAS/arrow_up_show3", "number")
B738DR_tcas_arr_dn_show3		= create_dataref("laminar/B738/TCAS/arrow_dn_show3", "number")
B738DR_tcas_box_show3		= create_dataref("laminar/B738/TCAS/box_show3", "number")
B738DR_tcas_circle_show3		= create_dataref("laminar/B738/TCAS/circle_show3", "number")
B738DR_tcas_diam_show3		= create_dataref("laminar/B738/TCAS/diamond_show3", "number")
B738DR_tcas_diam_e_show3		= create_dataref("laminar/B738/TCAS/diamond_e_show3", "number")
B738_EFIS_TCAS_show3		= create_dataref("laminar/B738/EFIS/tcas_show3", "number")

B738DR_tcas_x4				= create_dataref("laminar/B738/TCAS/x4", "number")
B738DR_tcas_y4				= create_dataref("laminar/B738/TCAS/y4", "number")
B738DR_tcas_alt4				= create_dataref("laminar/B738/TCAS/alt4", "string")
B738DR_tcas_alt_up_show4		= create_dataref("laminar/B738/TCAS/alt_up_show4", "number")
B738DR_tcas_alt_dn_show4		= create_dataref("laminar/B738/TCAS/alt_dn_show4", "number")
B738DR_tcas_arr_up_show4		= create_dataref("laminar/B738/TCAS/arrow_up_show4", "number")
B738DR_tcas_arr_dn_show4		= create_dataref("laminar/B738/TCAS/arrow_dn_show4", "number")
B738DR_tcas_box_show4		= create_dataref("laminar/B738/TCAS/box_show4", "number")
B738DR_tcas_circle_show4		= create_dataref("laminar/B738/TCAS/circle_show4", "number")
B738DR_tcas_diam_show4		= create_dataref("laminar/B738/TCAS/diamond_show4", "number")
B738DR_tcas_diam_e_show4		= create_dataref("laminar/B738/TCAS/diamond_e_show4", "number")
B738_EFIS_TCAS_show4		= create_dataref("laminar/B738/EFIS/tcas_show4", "number")

B738DR_tcas_x5				= create_dataref("laminar/B738/TCAS/x5", "number")
B738DR_tcas_y5				= create_dataref("laminar/B738/TCAS/y5", "number")
B738DR_tcas_alt5				= create_dataref("laminar/B738/TCAS/alt5", "string")
B738DR_tcas_alt_up_show5		= create_dataref("laminar/B738/TCAS/alt_up_show5", "number")
B738DR_tcas_alt_dn_show5		= create_dataref("laminar/B738/TCAS/alt_dn_show5", "number")
B738DR_tcas_arr_up_show5		= create_dataref("laminar/B738/TCAS/arrow_up_show5", "number")
B738DR_tcas_arr_dn_show5		= create_dataref("laminar/B738/TCAS/arrow_dn_show5", "number")
B738DR_tcas_box_show5		= create_dataref("laminar/B738/TCAS/box_show5", "number")
B738DR_tcas_circle_show5		= create_dataref("laminar/B738/TCAS/circle_show5", "number")
B738DR_tcas_diam_show5		= create_dataref("laminar/B738/TCAS/diamond_show5", "number")
B738DR_tcas_diam_e_show5		= create_dataref("laminar/B738/TCAS/diamond_e_show5", "number")
B738_EFIS_TCAS_show5		= create_dataref("laminar/B738/EFIS/tcas_show5", "number")

B738DR_tcas_x6			= create_dataref("laminar/B738/TCAS/x6", "number")
B738DR_tcas_y6				= create_dataref("laminar/B738/TCAS/y6", "number")
B738DR_tcas_alt6				= create_dataref("laminar/B738/TCAS/alt6", "string")
B738DR_tcas_alt_up_show6		= create_dataref("laminar/B738/TCAS/alt_up_show6", "number")
B738DR_tcas_alt_dn_show6		= create_dataref("laminar/B738/TCAS/alt_dn_show6", "number")
B738DR_tcas_arr_up_show6		= create_dataref("laminar/B738/TCAS/arrow_up_show6", "number")
B738DR_tcas_arr_dn_show6		= create_dataref("laminar/B738/TCAS/arrow_dn_show6", "number")
B738DR_tcas_box_show6		= create_dataref("laminar/B738/TCAS/box_show6", "number")
B738DR_tcas_circle_show6		= create_dataref("laminar/B738/TCAS/circle_show6", "number")
B738DR_tcas_diam_show6		= create_dataref("laminar/B738/TCAS/diamond_show6", "number")
B738DR_tcas_diam_e_show6		= create_dataref("laminar/B738/TCAS/diamond_e_show6", "number")
B738_EFIS_TCAS_show6		= create_dataref("laminar/B738/EFIS/tcas_show6", "number")

B738DR_tcas_x7				= create_dataref("laminar/B738/TCAS/x7", "number")
B738DR_tcas_y7				= create_dataref("laminar/B738/TCAS/y7", "number")
B738DR_tcas_alt7				= create_dataref("laminar/B738/TCAS/alt7", "string")
B738DR_tcas_alt_up_show7		= create_dataref("laminar/B738/TCAS/alt_up_show7", "number")
B738DR_tcas_alt_dn_show7		= create_dataref("laminar/B738/TCAS/alt_dn_show7", "number")
B738DR_tcas_arr_up_show7		= create_dataref("laminar/B738/TCAS/arrow_up_show7", "number")
B738DR_tcas_arr_dn_show7		= create_dataref("laminar/B738/TCAS/arrow_dn_show7", "number")
B738DR_tcas_box_show7		= create_dataref("laminar/B738/TCAS/box_show7", "number")
B738DR_tcas_circle_show7		= create_dataref("laminar/B738/TCAS/circle_show7", "number")
B738DR_tcas_diam_show7		= create_dataref("laminar/B738/TCAS/diamond_show7", "number")
B738DR_tcas_diam_e_show7		= create_dataref("laminar/B738/TCAS/diamond_e_show7", "number")
B738_EFIS_TCAS_show7		= create_dataref("laminar/B738/EFIS/tcas_show7", "number")

B738DR_tcas_x8				= create_dataref("laminar/B738/TCAS/x8", "number")
B738DR_tcas_y8				= create_dataref("laminar/B738/TCAS/y8", "number")
B738DR_tcas_alt8				= create_dataref("laminar/B738/TCAS/alt8", "string")
B738DR_tcas_alt_up_show8		= create_dataref("laminar/B738/TCAS/alt_up_show8", "number")
B738DR_tcas_alt_dn_show8		= create_dataref("laminar/B738/TCAS/alt_dn_show8", "number")
B738DR_tcas_arr_up_show8		= create_dataref("laminar/B738/TCAS/arrow_up_show8", "number")
B738DR_tcas_arr_dn_show8		= create_dataref("laminar/B738/TCAS/arrow_dn_show8", "number")
B738DR_tcas_box_show8		= create_dataref("laminar/B738/TCAS/box_show8", "number")
B738DR_tcas_circle_show8		= create_dataref("laminar/B738/TCAS/circle_show8", "number")
B738DR_tcas_diam_show8		= create_dataref("laminar/B738/TCAS/diamond_show8", "number")
B738DR_tcas_diam_e_show8		= create_dataref("laminar/B738/TCAS/diamond_e_show8", "number")
B738_EFIS_TCAS_show8		= create_dataref("laminar/B738/EFIS/tcas_show8", "number")

B738DR_tcas_x9				= create_dataref("laminar/B738/TCAS/x9", "number")
B738DR_tcas_y9				= create_dataref("laminar/B738/TCAS/y9", "number")
B738DR_tcas_alt9				= create_dataref("laminar/B738/TCAS/alt9", "string")
B738DR_tcas_alt_up_show9		= create_dataref("laminar/B738/TCAS/alt_up_show9", "number")
B738DR_tcas_alt_dn_show9		= create_dataref("laminar/B738/TCAS/alt_dn_show9", "number")
B738DR_tcas_arr_up_show9		= create_dataref("laminar/B738/TCAS/arrow_up_show9", "number")
B738DR_tcas_arr_dn_show9		= create_dataref("laminar/B738/TCAS/arrow_dn_show9", "number")
B738DR_tcas_box_show9		= create_dataref("laminar/B738/TCAS/box_show9", "number")
B738DR_tcas_circle_show9		= create_dataref("laminar/B738/TCAS/circle_show9", "number")
B738DR_tcas_diam_show9		= create_dataref("laminar/B738/TCAS/diamond_show9", "number")
B738DR_tcas_diam_e_show9		= create_dataref("laminar/B738/TCAS/diamond_e_show9", "number")
B738_EFIS_TCAS_show9		= create_dataref("laminar/B738/EFIS/tcas_show9", "number")

B738DR_tcas_x10				= create_dataref("laminar/B738/TCAS/x10", "number")
B738DR_tcas_y10				= create_dataref("laminar/B738/TCAS/y10", "number")
B738DR_tcas_alt10			= create_dataref("laminar/B738/TCAS/alt10", "string")
B738DR_tcas_alt_up_show10	= create_dataref("laminar/B738/TCAS/alt_up_show10", "number")
B738DR_tcas_alt_dn_show10	= create_dataref("laminar/B738/TCAS/alt_dn_show10", "number")
B738DR_tcas_arr_up_show10	= create_dataref("laminar/B738/TCAS/arrow_up_show10", "number")
B738DR_tcas_arr_dn_show10	= create_dataref("laminar/B738/TCAS/arrow_dn_show10", "number")
B738DR_tcas_box_show10		= create_dataref("laminar/B738/TCAS/box_show10", "number")
B738DR_tcas_circle_show10	= create_dataref("laminar/B738/TCAS/circle_show10", "number")
B738DR_tcas_diam_show10		= create_dataref("laminar/B738/TCAS/diamond_show10", "number")
B738DR_tcas_diam_e_show10	= create_dataref("laminar/B738/TCAS/diamond_e_show10", "number")
B738_EFIS_TCAS_show10		= create_dataref("laminar/B738/EFIS/tcas_show10", "number")

B738DR_tcas_x11				= create_dataref("laminar/B738/TCAS/x11", "number")
B738DR_tcas_y11				= create_dataref("laminar/B738/TCAS/y11", "number")
B738DR_tcas_alt11			= create_dataref("laminar/B738/TCAS/alt11", "string")
B738DR_tcas_alt_up_show11	= create_dataref("laminar/B738/TCAS/alt_up_show11", "number")
B738DR_tcas_alt_dn_show11	= create_dataref("laminar/B738/TCAS/alt_dn_show11", "number")
B738DR_tcas_arr_up_show11	= create_dataref("laminar/B738/TCAS/arrow_up_show11", "number")
B738DR_tcas_arr_dn_show11	= create_dataref("laminar/B738/TCAS/arrow_dn_show11", "number")
B738DR_tcas_box_show11		= create_dataref("laminar/B738/TCAS/box_show11", "number")
B738DR_tcas_circle_show11	= create_dataref("laminar/B738/TCAS/circle_show11", "number")
B738DR_tcas_diam_show11		= create_dataref("laminar/B738/TCAS/diamond_show11", "number")
B738DR_tcas_diam_e_show11	= create_dataref("laminar/B738/TCAS/diamond_e_show11", "number")
B738_EFIS_TCAS_show11		= create_dataref("laminar/B738/EFIS/tcas_show11", "number")

B738DR_tcas_x12				= create_dataref("laminar/B738/TCAS/x12", "number")
B738DR_tcas_y12				= create_dataref("laminar/B738/TCAS/y12", "number")
B738DR_tcas_alt12			= create_dataref("laminar/B738/TCAS/alt12", "string")
B738DR_tcas_alt_up_show12	= create_dataref("laminar/B738/TCAS/alt_up_show12", "number")
B738DR_tcas_alt_dn_show12	= create_dataref("laminar/B738/TCAS/alt_dn_show12", "number")
B738DR_tcas_arr_up_show12	= create_dataref("laminar/B738/TCAS/arrow_up_show12", "number")
B738DR_tcas_arr_dn_show12	= create_dataref("laminar/B738/TCAS/arrow_dn_show12", "number")
B738DR_tcas_box_show12		= create_dataref("laminar/B738/TCAS/box_show12", "number")
B738DR_tcas_circle_show12	= create_dataref("laminar/B738/TCAS/circle_show12", "number")
B738DR_tcas_diam_show12		= create_dataref("laminar/B738/TCAS/diamond_show12", "number")
B738DR_tcas_diam_e_show12	= create_dataref("laminar/B738/TCAS/diamond_e_show12", "number")
B738_EFIS_TCAS_show12		= create_dataref("laminar/B738/EFIS/tcas_show12", "number")

B738DR_tcas_x13				= create_dataref("laminar/B738/TCAS/x13", "number")
B738DR_tcas_y13				= create_dataref("laminar/B738/TCAS/y13", "number")
B738DR_tcas_alt13			= create_dataref("laminar/B738/TCAS/alt13", "string")
B738DR_tcas_alt_up_show13	= create_dataref("laminar/B738/TCAS/alt_up_show13", "number")
B738DR_tcas_alt_dn_show13	= create_dataref("laminar/B738/TCAS/alt_dn_show13", "number")
B738DR_tcas_arr_up_show13	= create_dataref("laminar/B738/TCAS/arrow_up_show13", "number")
B738DR_tcas_arr_dn_show13	= create_dataref("laminar/B738/TCAS/arrow_dn_show13", "number")
B738DR_tcas_box_show13		= create_dataref("laminar/B738/TCAS/box_show13", "number")
B738DR_tcas_circle_show13	= create_dataref("laminar/B738/TCAS/circle_show13", "number")
B738DR_tcas_diam_show13		= create_dataref("laminar/B738/TCAS/diamond_show13", "number")
B738DR_tcas_diam_e_show13	= create_dataref("laminar/B738/TCAS/diamond_e_show13", "number")
B738_EFIS_TCAS_show13		= create_dataref("laminar/B738/EFIS/tcas_show13", "number")

B738DR_tcas_x14				= create_dataref("laminar/B738/TCAS/x14", "number")
B738DR_tcas_y14				= create_dataref("laminar/B738/TCAS/y14", "number")
B738DR_tcas_alt14			= create_dataref("laminar/B738/TCAS/alt14", "string")
B738DR_tcas_alt_up_show14	= create_dataref("laminar/B738/TCAS/alt_up_show14", "number")
B738DR_tcas_alt_dn_show14	= create_dataref("laminar/B738/TCAS/alt_dn_show14", "number")
B738DR_tcas_arr_up_show14	= create_dataref("laminar/B738/TCAS/arrow_up_show14", "number")
B738DR_tcas_arr_dn_show14	= create_dataref("laminar/B738/TCAS/arrow_dn_show14", "number")
B738DR_tcas_box_show14		= create_dataref("laminar/B738/TCAS/box_show14", "number")
B738DR_tcas_circle_show14	= create_dataref("laminar/B738/TCAS/circle_show14", "number")
B738DR_tcas_diam_show14		= create_dataref("laminar/B738/TCAS/diamond_show14", "number")
B738DR_tcas_diam_e_show14	= create_dataref("laminar/B738/TCAS/diamond_e_show14", "number")
B738_EFIS_TCAS_show14		= create_dataref("laminar/B738/EFIS/tcas_show14", "number")

B738DR_tcas_x15				= create_dataref("laminar/B738/TCAS/x15", "number")
B738DR_tcas_y15				= create_dataref("laminar/B738/TCAS/y15", "number")
B738DR_tcas_alt15			= create_dataref("laminar/B738/TCAS/alt15", "string")
B738DR_tcas_alt_up_show15	= create_dataref("laminar/B738/TCAS/alt_up_show15", "number")
B738DR_tcas_alt_dn_show15	= create_dataref("laminar/B738/TCAS/alt_dn_show15", "number")
B738DR_tcas_arr_up_show15	= create_dataref("laminar/B738/TCAS/arrow_up_show15", "number")
B738DR_tcas_arr_dn_show15	= create_dataref("laminar/B738/TCAS/arrow_dn_show15", "number")
B738DR_tcas_box_show15		= create_dataref("laminar/B738/TCAS/box_show15", "number")
B738DR_tcas_circle_show15	= create_dataref("laminar/B738/TCAS/circle_show15", "number")
B738DR_tcas_diam_show15		= create_dataref("laminar/B738/TCAS/diamond_show15", "number")
B738DR_tcas_diam_e_show15	= create_dataref("laminar/B738/TCAS/diamond_e_show15", "number")
B738_EFIS_TCAS_show15		= create_dataref("laminar/B738/EFIS/tcas_show15", "number")

B738DR_tcas_x16				= create_dataref("laminar/B738/TCAS/x16", "number")
B738DR_tcas_y16				= create_dataref("laminar/B738/TCAS/y16", "number")
B738DR_tcas_alt16			= create_dataref("laminar/B738/TCAS/alt16", "string")
B738DR_tcas_alt_up_show16	= create_dataref("laminar/B738/TCAS/alt_up_show16", "number")
B738DR_tcas_alt_dn_show16	= create_dataref("laminar/B738/TCAS/alt_dn_show16", "number")
B738DR_tcas_arr_up_show16	= create_dataref("laminar/B738/TCAS/arrow_up_show16", "number")
B738DR_tcas_arr_dn_show16	= create_dataref("laminar/B738/TCAS/arrow_dn_show16", "number")
B738DR_tcas_box_show16		= create_dataref("laminar/B738/TCAS/box_show16", "number")
B738DR_tcas_circle_show16	= create_dataref("laminar/B738/TCAS/circle_show16", "number")
B738DR_tcas_diam_show16		= create_dataref("laminar/B738/TCAS/diamond_show16", "number")
B738DR_tcas_diam_e_show16	= create_dataref("laminar/B738/TCAS/diamond_e_show16", "number")
B738_EFIS_TCAS_show16		= create_dataref("laminar/B738/EFIS/tcas_show16", "number")

B738DR_tcas_x17				= create_dataref("laminar/B738/TCAS/x17", "number")
B738DR_tcas_y17				= create_dataref("laminar/B738/TCAS/y17", "number")
B738DR_tcas_alt17			= create_dataref("laminar/B738/TCAS/alt17", "string")
B738DR_tcas_alt_up_show17	= create_dataref("laminar/B738/TCAS/alt_up_show17", "number")
B738DR_tcas_alt_dn_show17	= create_dataref("laminar/B738/TCAS/alt_dn_show17", "number")
B738DR_tcas_arr_up_show17	= create_dataref("laminar/B738/TCAS/arrow_up_show17", "number")
B738DR_tcas_arr_dn_show17	= create_dataref("laminar/B738/TCAS/arrow_dn_show17", "number")
B738DR_tcas_box_show17		= create_dataref("laminar/B738/TCAS/box_show17", "number")
B738DR_tcas_circle_show17	= create_dataref("laminar/B738/TCAS/circle_show17", "number")
B738DR_tcas_diam_show17		= create_dataref("laminar/B738/TCAS/diamond_show17", "number")
B738DR_tcas_diam_e_show17	= create_dataref("laminar/B738/TCAS/diamond_e_show17", "number")
B738_EFIS_TCAS_show17		= create_dataref("laminar/B738/EFIS/tcas_show17", "number")

B738DR_tcas_x18				= create_dataref("laminar/B738/TCAS/x18", "number")
B738DR_tcas_y18				= create_dataref("laminar/B738/TCAS/y18", "number")
B738DR_tcas_alt18			= create_dataref("laminar/B738/TCAS/alt18", "string")
B738DR_tcas_alt_up_show18	= create_dataref("laminar/B738/TCAS/alt_up_show18", "number")
B738DR_tcas_alt_dn_show18	= create_dataref("laminar/B738/TCAS/alt_dn_show18", "number")
B738DR_tcas_arr_up_show18	= create_dataref("laminar/B738/TCAS/arrow_up_show18", "number")
B738DR_tcas_arr_dn_show18	= create_dataref("laminar/B738/TCAS/arrow_dn_show18", "number")
B738DR_tcas_box_show18		= create_dataref("laminar/B738/TCAS/box_show18", "number")
B738DR_tcas_circle_show18	= create_dataref("laminar/B738/TCAS/circle_show18", "number")
B738DR_tcas_diam_show18		= create_dataref("laminar/B738/TCAS/diamond_show18", "number")
B738DR_tcas_diam_e_show18	= create_dataref("laminar/B738/TCAS/diamond_e_show18", "number")
B738_EFIS_TCAS_show18		= create_dataref("laminar/B738/EFIS/tcas_show18", "number")

B738DR_tcas_x19				= create_dataref("laminar/B738/TCAS/x19", "number")
B738DR_tcas_y19				= create_dataref("laminar/B738/TCAS/y19", "number")
B738DR_tcas_alt19			= create_dataref("laminar/B738/TCAS/alt19", "string")
B738DR_tcas_alt_up_show19	= create_dataref("laminar/B738/TCAS/alt_up_show19", "number")
B738DR_tcas_alt_dn_show19	= create_dataref("laminar/B738/TCAS/alt_dn_show19", "number")
B738DR_tcas_arr_up_show19	= create_dataref("laminar/B738/TCAS/arrow_up_show19", "number")
B738DR_tcas_arr_dn_show19	= create_dataref("laminar/B738/TCAS/arrow_dn_show19", "number")
B738DR_tcas_box_show19		= create_dataref("laminar/B738/TCAS/box_show19", "number")
B738DR_tcas_circle_show19	= create_dataref("laminar/B738/TCAS/circle_show19", "number")
B738DR_tcas_diam_show19		= create_dataref("laminar/B738/TCAS/diamond_show19", "number")
B738DR_tcas_diam_e_show19	= create_dataref("laminar/B738/TCAS/diamond_e_show19", "number")
B738_EFIS_TCAS_show19		= create_dataref("laminar/B738/EFIS/tcas_show19", "number")




B738DR_apu_power_bus1		= create_dataref("laminar/B738/electrical/apu_power_bus1", "number")
B738DR_apu_power_bus2		= create_dataref("laminar/B738/electrical/apu_power_bus2", "number")
B738DR_apu_low_oil			= create_dataref("laminar/B738/electrical/apu_low_oil", "number")
B738DR_apu_temp				= create_dataref("laminar/B738/electrical/apu_temp", "number")
B738DR_apu_bus_enable		= create_dataref("laminar/B738/electrical/apu_bus_enable", "number")

simDR_flap_deg			= find_dataref("sim/flightmodel2/wing/flap1_deg[0]")
--B738DR_slat1_deg		= create_dataref("laminar/B738/slat1_deploy_ratio", "number")
B738DR_slat2_deg		= create_dataref("laminar/B738/slat2_deploy_ratio", "number")

B738DR_alt_horn_cutout_pos		= create_dataref("laminar/B738/push_button/alt_horn_cutout_pos", "number")
B738DR_alt_horn_cut_disable		= create_dataref("laminar/B738/alert/alt_horn_cut_disable", "number")
B738DR_below_gs_disable			= create_dataref("laminar/B738/alert/below_gs_disable", "number")
B738DR_below_gs_pilot			= create_dataref("laminar/B738/push_button/below_gs_pilot_pos", "number")
B738DR_below_gs_copilot			= create_dataref("laminar/B738/push_button/below_gs_copilot_pos", "number")
B738DR_below_gs					= find_dataref("laminar/B738/annunciator/below_gs")

B738DR_gear_horn_cutout_pos		= create_dataref("laminar/B738/push_button/gear_horn_cutout_pos", "number")
B738DR_gear_horn_cut_disable		= create_dataref("laminar/B738/alert/gear_horn_cut_disable", "number")


-- GPWS button and switches
B738DR_gpws_test_pos		= create_dataref("laminar/B738/push_button/gpws_test_pos", "number")
B738DR_gpws_gear_pos		= create_dataref("laminar/B738/toggle_switch/gpws_gear_pos", "number")
B738DR_gpws_flap_pos		= create_dataref("laminar/B738/toggle_switch/gpws_flap_pos", "number")
B738DR_gpws_terr_pos		= create_dataref("laminar/B738/toggle_switch/gpws_terr_pos", "number")
B738DR_gpws_gear_cover_pos	= create_dataref("laminar/B738/toggle_switch/gpws_gear_cover_pos", "number")
B738DR_gpws_flap_cover_pos	= create_dataref("laminar/B738/toggle_switch/gpws_flap_cover_pos", "number")
B738DR_gpws_terr_cover_pos	= create_dataref("laminar/B738/toggle_switch/gpws_terr_cover_pos", "number")
-- MACH airspeed warning 
B738DR_mach_warn1_pos		= create_dataref("laminar/B738/push_button/mach_warn1_pos", "number")
B738DR_mach_warn2_pos		= create_dataref("laminar/B738/push_button/mach_warn2_pos", "number")
-- FLAPS test
B738DR_flaps_test_pos		= create_dataref("laminar/B738/push_button/flaps_test_pos", "number")
--B738DR_power_on_buses		= create_dataref("laminar/B738/electric/power_on_buses", "number")


-- MANUAL LANDING GEAR
B738DR_landgear_cover_pos	= create_dataref("laminar/B738/emergency/landgear_cover_pos", "number")
B738DR_landgear_pos			= create_dataref("laminar/B738/emergency/landgear_pos", "number")

-- PFD MANUAL VSPEEDS
B738DR_man_vspd				= create_dataref("laminar/B738/pfd/vspeed", "number")
B738DR_man_vspeed_mode		= create_dataref("laminar/B738/pfd/vspeed_mode", "number")
B738DR_man_vspd_show		= create_dataref("laminar/B738/pfd/vspeed_show", "number")

B738DR_man_v1				= create_dataref("laminar/B738/pfd/vspeed_man_v1", "number")
B738DR_man_vr				= create_dataref("laminar/B738/pfd/vspeed_man_vr", "number")
B738DR_man_vref				= create_dataref("laminar/B738/pfd/vspeed_man_vref", "number")

-- FUEL TANK STATUS
B738DR_fuel_left_status		= create_dataref("laminar/B738/fuel/left_status", "number")
B738DR_fuel_right_status	= create_dataref("laminar/B738/fuel/right_status", "number")
B738DR_fuel_center_status	= create_dataref("laminar/B738/fuel/center_status", "number")
B738DR_left_tank_kgs		= create_dataref("laminar/B738/fuel/left_tank_kgs", "number")
B738DR_center_tank_kgs		= create_dataref("laminar/B738/fuel/center_tank_kgs", "number")
B738DR_right_tank_kgs		= create_dataref("laminar/B738/fuel/right_tank_kgs", "number")
B738DR_left_tank_lbs		= create_dataref("laminar/B738/fuel/left_tank_lbs", "number")
B738DR_center_tank_lbs		= create_dataref("laminar/B738/fuel/center_tank_lbs", "number")
B738DR_right_tank_lbs		= create_dataref("laminar/B738/fuel/right_tank_lbs", "number")

--landing_gear_act				= create_dataref("laminar/B738/gear/gear deploy", "number")

B738DR_hyd_A_pressure		= create_dataref("laminar/B738/hydraulic/A_pressure", "number")
B738DR_hyd_B_pressure		= create_dataref("laminar/B738/hydraulic/B_pressure", "number")
B738DR_hyd_stdby_pressure	= create_dataref("laminar/B738/hydraulic/standby_pressure", "number")
B738DR_hyd_A_status			= create_dataref("laminar/B738/hydraulic/A_status", "number")
B738DR_hyd_B_status			= create_dataref("laminar/B738/hydraulic/B_status", "number")
B738DR_hyd_stdby_status		= create_dataref("laminar/B738/hydraulic/standby_status", "number")
B738DR_hyd_A_rud			= create_dataref("laminar/B738/hydraulic/A_rudder", "number")
B738DR_hyd_B_rud			= create_dataref("laminar/B738/hydraulic/B_rudder", "number")
B738DR_hyd_A_qty			= create_dataref("laminar/B738/hydraulic/hyd_A_qty", "number")
B738DR_hyd_B_qty			= create_dataref("laminar/B738/hydraulic/hyd_B_qty", "number")

-- ENGINE START VALVES
B738DR_start_valve1		= create_dataref("laminar/B738/engine/start_valve1", "number")
B738DR_start_valve2		= create_dataref("laminar/B738/engine/start_valve2", "number")

-- FLIGHT CONTROL
B738DR_flt_ctr_A_cover_pos	= create_dataref("laminar/B738/switches/flt_ctr_A_cover_pos", "number")
B738DR_flt_ctr_B_cover_pos	= create_dataref("laminar/B738/switches/flt_ctr_B_cover_pos", "number")
B738DR_flt_ctr_A_pos		= create_dataref("laminar/B738/switches/flt_ctr_A_pos", "number")
B738DR_flt_ctr_B_pos		= create_dataref("laminar/B738/switches/flt_ctr_B_pos", "number")

-- SPOILER
B738DR_spoiler_A_cover_pos	= create_dataref("laminar/B738/switches/spoiler_A_cover_pos", "number")
B738DR_spoiler_B_cover_pos	= create_dataref("laminar/B738/switches/spoiler_B_cover_pos", "number")
B738DR_spoiler_A_pos		= create_dataref("laminar/B738/switches/spoiler_A_pos", "number")
B738DR_spoiler_B_pos		= create_dataref("laminar/B738/switches/spoiler_B_pos", "number")

-- ALERNATE FLAPS
B738DR_alt_flaps_cover_pos	= create_dataref("laminar/B738/switches/alt_flaps_cover_pos", "number")
B738DR_alt_flaps_pos		= create_dataref("laminar/B738/switches/alt_flaps_pos", "number")

-- WIPERS
B738DR_left_wiper_pos		= create_dataref("laminar/B738/switches/left_wiper_pos", "number")
B738DR_right_wiper_pos		= create_dataref("laminar/B738/switches/right_wiper_pos", "number")
B738DR_left_wiper_ratio		= create_dataref("laminar/B738/others/left_wiper_ratio", "number")
B738DR_right_wiper_ratio	= create_dataref("laminar/B738/others/right_wiper_ratio", "number")

B738DR_left_wiper_up		= create_dataref("laminar/B738/others/left_wiper_up", "number")
B738DR_right_wiper_up		= create_dataref("laminar/B738/others/right_wiper_up", "number")

-- TAT TEST
B738DR_tat_test_pos		= create_dataref("laminar/B738/push_button/tat_test_pos", "number")

-- GROUND SERVICE
B738DR_grd_call_pos		= create_dataref("laminar/B738/push_button/grd_call_pos", "number")
B738DR_attend_pos		= create_dataref("laminar/B738/push_button/attend_pos", "number")

-- DUCT LPACK/RPACK
B738DR_duct_ovht_test_pos		= create_dataref("laminar/B738/push_button/duct_ovht_test_pos", "number")

-- AC/DC MAINT
B738DR_acdc_maint_pos		= create_dataref("laminar/B738/push_button/acdc_maint_pos", "number")

-- BRAKE PRESS
B738DR_brake_press		= create_dataref("laminar/B738/brake/brake_press", "number")

-- ZONE TEMP
B738DR_zone_temp		= create_dataref("laminar/B738/zone_temp", "number")

-- FDR
B738DR_fdr_cover_pos	= create_dataref("laminar/B738/switches/fdr_cover_pos", "number")
B738DR_fdr_pos			= create_dataref("laminar/B738/switches/fdr_pos", "number")


B738DR_gpu_available	= create_dataref("laminar/B738/gpu_available", "number")

B738DR_pressurization_mode	= create_dataref("laminar/B738/pressurization_mode", "number")
B738DR_outflow_valve		= create_dataref("laminar/B738/outflow_valve", "number")
B738DR_cabin_vvi			= create_dataref("laminar/B738/cabin_vvi", "number")
B738DR_cabin_alt			= create_dataref("laminar/B738/cabin_alt", "number")

B738DR_fuel_flow_used		= create_dataref("laminar/B738/fuel_flow_used", "number")
B738DR_fuel_flow_used_show	= create_dataref("laminar/B738/fuel_flow_used_show", "number")


B738DR_tcas_test_test			= create_dataref("laminar/B738/tcas_test_test", "number")

B738DR_gen1_available		= create_dataref("laminar/B738/electric/gen1_available", "number")
B738DR_gen2_available		= create_dataref("laminar/B738/electric/gen2_available", "number")

B738DR_apu_start_load		= create_dataref("laminar/B738/electric/apu_start_load", "number")
B738DR_eng1_start_disable	= create_dataref("laminar/B738/engine/eng1_start_disable", "number")
B738DR_eng2_start_disable	= create_dataref("laminar/B738/engine/eng2_start_disable", "number")

-- ELECTRICAL BUSES
B738DR_ac_stdbus_status		= create_dataref("laminar/B738/electric/ac_stdbus_status", "number")
B738DR_ac_tnsbus1_status	= create_dataref("laminar/B738/electric/ac_tnsbus1_status", "number")
B738DR_ac_tnsbus2_status	= create_dataref("laminar/B738/electric/ac_tnsbus2_status", "number")
B738DR_dc_stdbus_status		= create_dataref("laminar/B738/electric/dc_stdbus_status", "number")
B738DR_dc_bus1_status		= create_dataref("laminar/B738/electric/dc_bus1_status", "number")
B738DR_dc_bus2_status		= create_dataref("laminar/B738/electric/dc_bus2_status", "number")
B738DR_hot_batbus_status	= create_dataref("laminar/B738/electric/hot_batbus_status", "number")
B738DR_batbus_status		= create_dataref("laminar/B738/electric/batbus_status", "number")

-- FMOD by AudioBird XP
B738DR_pull_up				= create_dataref("laminar/b738/fmodpack/msg_pull_up", "number")
B738DR_windshear			= create_dataref("laminar/b738/fmodpack/msg_windshear", "number")
B738DR_terrain				= create_dataref("laminar/b738/fmodpack/msg_terrain", "number")
B738DR_caution_terrain		= create_dataref("laminar/b738/fmodpack/msg_caution_terrain", "number")
B738DR_too_low_terrain		= create_dataref("laminar/b738/fmodpack/msg_too_low_terrain", "number")
B738DR_too_low_flaps		= create_dataref("laminar/b738/fmodpack/msg_too_low_flaps", "number")
B738DR_too_low_gear			= create_dataref("laminar/b738/fmodpack/msg_too_low_gear", "number")
B738DR_dont_sink			= create_dataref("laminar/b738/fmodpack/msg_dont_sink", "number")
B738DR_sink_rate			= create_dataref("laminar/b738/fmodpack/msg_sink_rate", "number")
B738DR_bank_angle			= create_dataref("laminar/b738/fmodpack/msg_bank_angle", "number")
B738DR_traffic				= create_dataref("laminar/b738/fmodpack/msg_traffic", "number")
B738DR_mon_vert_spd			= create_dataref("laminar/b738/fmodpack/msg_mon_vert_spd", "number")
B738DR_maint_vert_spd		= create_dataref("laminar/b738/fmodpack/msg_maint_vert_spd", "number")
B738DR_climb				= create_dataref("laminar/b738/fmodpack/msg_climb", "number")
B738DR_descent				= create_dataref("laminar/b738/fmodpack/msg_descent", "number")
B738DR_adj_vert_spd			= create_dataref("laminar/b738/fmodpack/msg_adj_vert_spd", "number")
B738DR_cross_climb			= create_dataref("laminar/b738/fmodpack/msg_cross_climb", "number")
B738DR_cross_descent		= create_dataref("laminar/b738/fmodpack/msg_cross_descent", "number")
B738DR_increase_climb		= create_dataref("laminar/b738/fmodpack/msg_increase_climb", "number")
B738DR_increase_descent		= create_dataref("laminar/b738/fmodpack/msg_increase_descent", "number")
B738DR_climb_now			= create_dataref("laminar/b738/fmodpack/msg_climb_now", "number")
B738DR_descent_now			= create_dataref("laminar/b738/fmodpack/msg_descent_now", "number")
B738DR_clear_of_conflict	= create_dataref("laminar/b738/fmodpack/msg_clear_of_conflict", "number")

B738DR_nd_fmc_source			= create_dataref("laminar/B738/nd/capt/fmc_source", "number")
B738DR_nd_fmc_source_fo		= create_dataref("laminar/B738/nd/fo/fmc_source", "number")

B738DR_lost_fo_inertial	= create_dataref("laminar/B738/systems/lost_fo_inertial", "number")

B738DR_mach_test_enable		= create_dataref("laminar/B738/systems/mach_test_enable", "number")
B738DR_cabin_gear_wrn 		= create_dataref("laminar/B738/systems/cabin_gear_wrn", "number")
fmod_flap_sound				= create_dataref("laminar/B738/fmod/flap_sound", "number")

--*************************************************************************************--
--** 				       READ-WRITE CUSTOM DATAREF HANDLERS     	        	     **--
--*************************************************************************************--

-- LANDING ALTITUDE SELECTOR
function B738DR_landing_alt_sel_rheo_DRhandler() end


-- CONT CAB TEMP CONTROL
function B738DR_cont_cab_temp_ctrl_rheo_DRhandler() end


-- FWD CAB TEMP CONTROL
function B738DR_fwd_cab_temp_ctrl_rheo_DRhandler() end


-- AFT CAB TEMP CONTROL
function B738DR_aft_cab_temp_ctrl_rheo_DRhandler() end


function B738DR_land_alt_knob_DRhandler()end


------------------------- CUSTOM

-- ENG 1 and 2 STARTER POSITION
function B738DR_engine1_starter_pos_DRhandler()end
function B738DR_engine2_starter_pos_DRhandler()end
function B738DR_fuel_pos_lft1_DRhandler()end
function B738DR_fuel_pos_lft2_DRhandler()end
function B738DR_fuel_pos_ctr1_DRhandler()end
function B738DR_fuel_pos_ctr2_DRhandler()end
function B738DR_fuel_pos_rgt1_DRhandler()end
function B738DR_fuel_pos_rgt2_DRhandler()end
function B738DR_gear_handle_pos_DRhandler()end
function B738DR_gear_lock_over_pos_DRhandler()end
function B738DR_gear_handle_act_DRhandler()end

function B738DR_l_pack_pos_DRhandler()end
function B738DR_r_pack_pos_DRhandler()end
function B738DR_isolation_valve_pos_DRhandler()end
function B738DR_l_recirc_fan_pos_DRhandler()end
function B738DR_r_recirc_fan_pos_DRhandler()end
function B738DR_trim_air_pos_DRhandler()end

function B738DR_APU_gen1_pos_DRhandler()end
function B738DR_APU_gen2_pos_DRhandler()end

function B738DR_gpu_pos_DRhandler()end

function B738DR_gen1_pos_DRhandler()end
function B738DR_gen2_pos_DRhandler()end

function B738DR_autobrake_pos_DRhandler()end
function B738DR_autobrake_RTO_test_DRhandler()end
function B738DR_autobrake_RTO_arm_DRhandler()end
function B738DR_autobrake_arm_DRhandler()end
function B738DR_autobrake_disarm_DRhandler()end


function B738DR_l_recirc_fan_pos_DRhandler()end
function B738DR_r_recirc_fan_pos_DRhandler()end
function B738DR_trim_air_pos_DRhandler()end

function B738DR_bleed_air_1_pos_DRhandler()end
function B738DR_bleed_air_2_pos_DRhandler()end
function B738DR_bleed_air_apu_pos_DRhandler()end

-------------------------

function B738DR_brake_temp_left_out_DRhandler()end
function B738DR_brake_temp_left_in_DRhandler()end
function B738DR_brake_temp_right_out_DRhandler()end
function B738DR_brake_temp_right_in_DRhandler()end

function B738DR_brake_temp_l_out_DRhandler()end
function B738DR_brake_temp_r_out_DRhandler()end
function B738DR_brake_temp_l_in_DRhandler()end
function B738DR_brake_temp_r_in_DRhandler()end

function B738DR_fuel_flow_pos_DRhandler()end

function B738DR_eng_start_source_DRhandler() end
function B738DR_air_valve_manual_DRhandler() end
function B738DR_eq_cool_exhaust_DRhandler() end
function B738DR_eq_cool_supply_DRhandler() end
function B738DR_dspl_ctrl_pnl_DRhandler() end
function B738DR_fmc_source_DRhandler() end
function B738DR_air_valve_ctrl_DRhandler() end
function B738DR_air_temp_source_DRhandler() end
function B738DR_window_ovht_test_DRhandler() end
function B738DR_service_interphone_DRhandler() end
function B738DR_alt_flaps_ctrl_DRhandler() end
function B738DR_flt_dk_door_DRhandler() end
function B738DR_main_pnl_du_fo_DRhandler() end
function B738DR_lower_du_fo_DRhandler() end
function B738DR_main_pnl_du_capt_DRhandler() end
function B738DR_lower_du_capt_DRhandler() end
function B738DR_spd_ref_DRhandler() end
function B738DR_spd_ref_adjust_DRhandler() end
function B738DR_dspl_source_DRhandler() end
-- function B738DR_minim_fo_DRhandler() end
-- function B738DR_minim_capt_DRhandler() end


function B738DR_tcas_test_DRhandler() end
function B738DR_tcas_test2_DRhandler() end


function B738DR_probes_capt_switch_pos_DRhandler() end
function B738DR_probes_fo_switch_pos_DRhandler() end

function B738DR_hydro_pumps1_switch_position_DRhandler() end
function B738DR_hydro_pumps2_switch_position_DRhandler() end
function B738DR_el_hydro_pumps1_switch_position_DRhandler() end
function B738DR_el_hydro_pumps2_switch_position_DRhandler() end

function B738_cross_feed_selector_DRhandler() end

function B738DR_yaw_damper_switch_pos_DRhandler() end

function B738_win_l_DRhandler() end

function B738_parking_brake_pos_DRhandler() end

function B738_landgear_time_DRhandler() end

function B738_sys_test_DRhandler() end
function B738_sys_test2_DRhandler() end

function B738DR_kill_systems_DRhandler() end

function B738DR_panel_brightness_DRhandler() end
function B738DR_instrument_brightness_DRhandler() end

function B738DR_flap_lever_stop_pos_DRhandler() end

--*************************************************************************************--
--** 				       CREATE READ-WRITE CUSTOM DATAREFS                         **--
--*************************************************************************************--

B738DR_flap_lever_stop_pos		= create_dataref("laminar/B738/handles/flap_lever/stop_pos", "number", B738DR_flap_lever_stop_pos_DRhandler)


B738DR_panel_brightness			= create_dataref("laminar/B738/electric/panel_brightness", "array[4]", B738DR_panel_brightness_DRhandler)
B738DR_instrument_brightness	= create_dataref("laminar/B738/electric/instrument_brightness", "array[16]", B738DR_instrument_brightness_DRhandler)


B738DR_kill_systems	= create_dataref("laminar/B738/perf/kill_systems", "number", B738DR_kill_systems_DRhandler)


DR_sys_test = create_dataref("laminar/B738/system_test", "number", B738_sys_test_DRhandler)
DR_sys_test2 = create_dataref("laminar/B738/system_test2", "number", B738_sys_test2_DRhandler)

DR_landgear_time			= create_dataref("laminar/B738/landgear_time", "number", B738_landgear_time_DRhandler)

B738DR_parking_brake_pos	= create_dataref("laminar/B738/parking_brake_pos", "number", B738_parking_brake_pos_DRhandler)

B738DR_probes_capt_switch_pos		= create_dataref("laminar/B738/toggle_switch/capt_probes_pos", "number", B738DR_probes_capt_switch_pos_DRhandler)
B738DR_probes_fo_switch_pos			= create_dataref("laminar/B738/toggle_switch/fo_probes_pos", "number", B738DR_probes_fo_switch_pos_DRhandler)

B738DR_hydro_pumps1_switch_position	= create_dataref("laminar/B738/toggle_switch/hydro_pumps1_pos", "number", B738DR_hydro_pumps1_switch_position_DRhandler)
B738DR_hydro_pumps2_switch_position	= create_dataref("laminar/B738/toggle_switch/hydro_pumps2_pos", "number", B738DR_hydro_pumps2_switch_position_DRhandler)

B738DR_el_hydro_pumps1_switch_position	= create_dataref("laminar/B738/toggle_switch/electric_hydro_pumps1_pos", "number", B738DR_el_hydro_pumps1_switch_position_DRhandler)
B738DR_el_hydro_pumps2_switch_position	= create_dataref("laminar/B738/toggle_switch/electric_hydro_pumps2_pos", "number", B738DR_el_hydro_pumps2_switch_position_DRhandler)

B738_cross_feed_selector_knob_target	= create_dataref("laminar/B738/knobs/cross_feed_pos", "number", B738_cross_feed_selector_DRhandler)

B738DR_yaw_damper_switch_pos		= create_dataref("laminar/B738/toggle_switch/yaw_dumper_pos", "number", B738DR_yaw_damper_switch_pos_DRhandler)


-- LANDING ALTITUDE SELECTOR
B738DR_landing_alt_sel_rheo		= create_dataref("laminar/B738/air/land_alt_sel/rheostat", "number", B738DR_landing_alt_sel_rheo_DRhandler)


-- CONT CAB TEMP CONTROL
B738DR_cont_cab_temp_ctrl_rheo	= create_dataref("laminar/B738/air/cont_cab_temp/rheostat", "number", B738DR_cont_cab_temp_ctrl_rheo_DRhandler)


-- FWD CAB TEMP CONTROL
B738DR_fwd_cab_temp_ctrl_rheo 	= create_dataref("laminar/B738/air/fwd_cab_temp/rheostat", "number", B738DR_fwd_cab_temp_ctrl_rheo_DRhandler)


-- AFT CAB TEMP CONTROL
B738DR_aft_cab_temp_ctrl_rheo	= create_dataref("laminar/B738/air/aft_cab_temp/rheostat", "number", B738DR_aft_cab_temp_ctrl_rheo_DRhandler)


B738DR_land_alt_knob 			= create_dataref("laminar/B738/pressurization/knobs/landing_alt", "number", B738DR_land_alt_knob_DRhandler)

B738DR_fuel_flow_pos 			= create_dataref("laminar/B738/toggle_switch/fuel_flow_pos", "number", B738DR_fuel_flow_pos_DRhandler)


B738DR_eng_start_source = 		create_dataref("laminar/B738/toggle_switch/eng_start_source", "number", B738DR_eng_start_source_DRhandler)
B738DR_air_valve_manual = 		create_dataref("laminar/B738/toggle_switch/air_valve_manual", "number", B738DR_air_valve_manual_DRhandler)
B738DR_eq_cool_exhaust = 		create_dataref("laminar/B738/toggle_switch/eq_cool_exhaust", "number", B738DR_eq_cool_exhaust_DRhandler)
B738DR_eq_cool_supply = 		create_dataref("laminar/B738/toggle_switch/eq_cool_supply", "number", B738DR_eq_cool_supply_DRhandler)
B738DR_dspl_ctrl_pnl = 			create_dataref("laminar/B738/toggle_switch/dspl_ctrl_pnl", "number", B738DR_dspl_ctrl_pnl_DRhandler)
B738DR_fmc_source = 			create_dataref("laminar/B738/toggle_switch/fmc_source", "number", B738DR_fmc_source_DRhandler)
B738DR_air_valve_ctrl = 		create_dataref("laminar/B738/toggle_switch/air_valve_ctrl", "number", B738DR_air_valve_ctrl_DRhandler)
B738DR_air_temp_source = 		create_dataref("laminar/B738/toggle_switch/air_temp_source", "number", B738DR_air_temp_source_DRhandler)
B738DR_window_ovht_test = 		create_dataref("laminar/B738/toggle_switch/window_ovht_test", "number", B738DR_window_ovht_test_DRhandler)
B738DR_service_interphone = 	create_dataref("laminar/B738/toggle_switch/service_interphone", "number", B738DR_service_interphone_DRhandler)
B738DR_alt_flaps_ctrl = 		create_dataref("laminar/B738/toggle_switch/alt_flaps_ctrl", "number", B738DR_alt_flaps_ctrl_DRhandler)
B738DR_flt_dk_door = 			create_dataref("laminar/B738/toggle_switch/flt_dk_door", "number", B738DR_flt_dk_door_DRhandler)
B738DR_main_pnl_du_fo = 		create_dataref("laminar/B738/toggle_switch/main_pnl_du_fo", "number", B738DR_main_pnl_du_fo_DRhandler)
B738DR_lower_du_fo = 			create_dataref("laminar/B738/toggle_switch/lower_du_fo", "number", B738DR_lower_du_fo_DRhandler)
B738DR_main_pnl_du_capt = 		create_dataref("laminar/B738/toggle_switch/main_pnl_du_capt", "number", B738DR_main_pnl_du_capt_DRhandler)
B738DR_lower_du_capt = 			create_dataref("laminar/B738/toggle_switch/lower_du_capt", "number", B738DR_lower_du_capt_DRhandler)
B738DR_spd_ref = 				create_dataref("laminar/B738/toggle_switch/spd_ref", "number", B738DR_spd_ref_DRhandler)
B738DR_spd_ref_adjust = 		create_dataref("laminar/B738/toggle_switch/spd_ref_adjust", "number", B738DR_spd_ref_adjust_DRhandler)
B738DR_dspl_source = 			create_dataref("laminar/B738/toggle_switch/dspl_source", "number", B738DR_dspl_source_DRhandler)
-- B738DR_minim_fo = 				create_dataref("laminar/B738/EFIS_control/fo/minimums", "number", B738DR_minim_fo_DRhandler)
-- B738DR_minim_capt = 			create_dataref("laminar/B738/EFIS_control/cpt/minimums", "number", B738DR_minim_capt_DRhandler)



-------------------------- CUSTOM

-- ENG 1 and 2 STARTER POSITION:  0-GRD, 1-OFF, 2-CNT, 3-FLT
B738DR_engine1_starter_pos		= create_dataref("laminar/B738/engine/starter1_pos", "number", B738DR_engine1_starter_pos_DRhandler)
B738DR_engine2_starter_pos		= create_dataref("laminar/B738/engine/starter2_pos", "number", B738DR_engine2_starter_pos_DRhandler)
B738DR_fuel_tank_pos_lft1		= create_dataref("laminar/B738/fuel/fuel_tank_pos_lft1", "number", B738DR_fuel_pos_lft1_DRhandler)
B738DR_fuel_tank_pos_lft2		= create_dataref("laminar/B738/fuel/fuel_tank_pos_lft2", "number", B738DR_fuel_pos_lft2_DRhandler)
B738DR_fuel_tank_pos_ctr1		= create_dataref("laminar/B738/fuel/fuel_tank_pos_ctr1", "number", B738DR_fuel_pos_ctr1_DRhandler)
B738DR_fuel_tank_pos_ctr2		= create_dataref("laminar/B738/fuel/fuel_tank_pos_ctr2", "number", B738DR_fuel_pos_ctr2_DRhandler)
B738DR_fuel_tank_pos_rgt1		= create_dataref("laminar/B738/fuel/fuel_tank_pos_rgt1", "number", B738DR_fuel_pos_rgt1_DRhandler)
B738DR_fuel_tank_pos_rgt2		= create_dataref("laminar/B738/fuel/fuel_tank_pos_rgt2", "number", B738DR_fuel_pos_rgt2_DRhandler)

B738DR_gear_handle_pos			= create_dataref("laminar/B738/controls/gear_handle_down", "number", B738DR_gear_handle_pos_DRhandler)
B738DR_gear_lock_override_pos	= create_dataref("laminar/B738/gear_lock_ovrd/position", "number", B738DR_gear_lock_over_pos_DRhandler)
B738DR_gear_handle_act			= create_dataref("laminar/B738/controls/gear_handle_act", "number", B738DR_gear_handle_act_DRhandler)

B738DR_bleed_air_1_switch_position = create_dataref("laminar/B738/toggle_switch/bleed_air_1_pos", "number", B738DR_bleed_air_1_pos_DRhandler)
B738DR_bleed_air_2_switch_position = create_dataref("laminar/B738/toggle_switch/bleed_air_2_pos", "number", B738DR_bleed_air_2_pos_DRhandler)
B738DR_bleed_air_apu_switch_position = create_dataref("laminar/B738/toggle_switch/bleed_air_apu_pos", "number", B738DR_bleed_air_apu_pos_DRhandler)

B738DR_l_pack_pos				= create_dataref("laminar/B738/air/l_pack_pos", "number", B738DR_l_pack_pos_DRhandler)
B738DR_r_pack_pos				= create_dataref("laminar/B738/air/r_pack_pos", "number", B738DR_r_pack_pos_DRhandler)
B738DR_isolation_valve_pos		= create_dataref("laminar/B738/air/isolation_valve_pos", "number", B738DR_isolation_valve_pos_DRhandler)
B738DR_l_recirc_fan_pos			= create_dataref("laminar/B738/air/l_recirc_fan_pos", "number", B738DR_l_recirc_fan_pos_DRhandler)
B738DR_r_recirc_fan_pos			= create_dataref("laminar/B738/air/r_recirc_fan_pos", "number", B738DR_r_recirc_fan_pos_DRhandler)
B738DR_trim_air_pos				= create_dataref("laminar/B738/air/trim_air_pos", "number", B738DR_trim_air_pos_DRhandler)

B738DR_apu_gen1_pos				= create_dataref("laminar/B738/electrical/apu_gen1_pos", "number", B738DR_APU_gen1_pos_DRhandler)
B738DR_apu_gen2_pos				= create_dataref("laminar/B738/electrical/apu_gen2_pos", "number", B738DR_APU_gen2_pos_DRhandler)

B738DR_gpu_pos					= create_dataref("laminar/B738/electrical/gpu_pos", "number", B738DR_gpu_pos_DRhandler)

B738DR_gen1_pos					= create_dataref("laminar/B738/electrical/gen1_pos", "number", B738DR_gen1_pos_DRhandler)
B738DR_gen2_pos					= create_dataref("laminar/B738/electrical/gen2_pos", "number", B738DR_gen2_pos_DRhandler)

B738DR_autobrake_pos			= create_dataref("laminar/B738/autobrake/autobrake_pos", "number", B738DR_autobrake_pos_DRhandler)
B738DR_autobrake_RTO_test		= create_dataref("laminar/B738/autobrake/autobrake_RTO_test", "number", B738DR_autobrake_RTO_test_DRhandler)
B738DR_autobrake_RTO_arm		= create_dataref("laminar/B738/autobrake/autobrake_RTO_arm", "number", B738DR_autobrake_RTO_arm_DRhandler)
B738DR_autobrake_arm			= create_dataref("laminar/B738/autobrake/autobrake_arm", "number", B738DR_autobrake_arm_DRhandler)
B738DR_autobrake_disarm			= create_dataref("laminar/B738/autobrake/autobrake_disarm", "number", B738DR_autobrake_disarm_DRhandler)

--------------------------
B738DR_brake_temp_left_out		= create_dataref("laminar/B738/systems/brake_temp_left_out", "number", B738DR_brake_temp_left_out_DRhandler)
B738DR_brake_temp_left_in		= create_dataref("laminar/B738/systems/brake_temp_left_in", "number", B738DR_brake_temp_left_in_DRhandler)
B738DR_brake_temp_right_out		= create_dataref("laminar/B738/systems/brake_temp_right_out", "number", B738DR_brake_temp_right_out_DRhandler)
B738DR_brake_temp_right_in		= create_dataref("laminar/B738/systems/brake_temp_right_in", "number", B738DR_brake_temp_right_in_DRhandler)

B738DR_brake_temp_l_out		= create_dataref("laminar/B738/systems/brake_temp_l_out", "number", B738DR_brake_temp_l_out_DRhandler)
B738DR_brake_temp_r_out		= create_dataref("laminar/B738/systems/brake_temp_r_out", "number", B738DR_brake_temp_r_out_DRhandler)
B738DR_brake_temp_l_in		= create_dataref("laminar/B738/systems/brake_temp_l_in", "number", B738DR_brake_temp_l_in_DRhandler)
B738DR_brake_temp_r_in		= create_dataref("laminar/B738/systems/brake_temp_r_in", "number", B738DR_brake_temp_r_in_DRhandler)

B738DR_tcas_test			= create_dataref("laminar/B738/TCAS/test", "number", B738DR_tcas_test_DRhandler)
B738DR_tcas_test2			= create_dataref("laminar/B738/TCAS/test2", "number", B738DR_tcas_test2_DRhandler)

--*************************************************************************************--
--** 				             CUSTOM COMMAND HANDLERS            			     **--
--*************************************************************************************--




-- CAPTAIN ANTI ICE PROBES 
function B738_probes_capt_switch_pos_CMDhandler(phase, duration)
 	if phase == 0 then
 		B738DR_probes_capt_switch_pos = 1 - B738DR_probes_capt_switch_pos
		-- if B738DR_probes_capt_switch_pos == 0 then
			-- B738DR_probes_capt_switch_pos = 1
 			-- simCMD_capt_AOA_ice_on:once()
			-- simCMD_capt_pitot_ice_on:once()
		-- elseif B738DR_probes_capt_switch_pos == 1 then
			-- B738DR_probes_capt_switch_pos = 0
 			-- simCMD_capt_AOA_ice_off:once()
			-- simCMD_capt_pitot_ice_off:once()
		-- end
	end
end

-- F/0 ANTI ICE PROBES 
function B738_probes_fo_switch_pos_CMDhandler(phase, duration)
 	if phase == 0 then
		B738DR_probes_fo_switch_pos = 1 - B738DR_probes_fo_switch_pos
 		-- if B738DR_probes_fo_switch_pos == 0 then
			-- B738DR_probes_fo_switch_pos = 1
 			-- simCMD_fo_AOA_ice_on:once()
			-- simCMD_fo_pitot_ice_on:once()
		-- elseif B738DR_probes_fo_switch_pos == 1 then
			-- B738DR_probes_fo_switch_pos = 0
 			-- simCMD_fo_AOA_ice_off:once()
			-- simCMD_fo_pitot_ice_off:once()
		-- end
	end
end


-- APU START SWITCH

function B738_apu_starter_switch_pos_CMDhandler(phase, duration)
	if phase == 0 then
        if B738DR_apu_start_switch_position == 1 then			-- ON
            B738DR_apu_start_switch_position = 0				-- OFF
        end		
    end
end


function B738_apu_starter_switch_neg_CMDhandler(phase, duration)
	if phase == 0 then
        if B738DR_apu_start_switch_position == 0 then			-- OFF
            B738DR_apu_start_switch_position = 1				-- ON
            simCMD_apu_on:once()
			-- if simDR_apu_status < 40 then
				-- B738DR_apu_low_oil = 1
			-- end
        elseif B738DR_apu_start_switch_position == 1 then		-- ON
            B738DR_apu_start_switch_position = 2				-- START
			apu_start_active = 1
			--run_after_time(apu_back_on, 1.5)
        end
    elseif phase == 2 then
    	if B738DR_apu_start_switch_position == 2 then			-- START
    		B738DR_apu_start_switch_position = 1				-- ON
			-- if apu_start_active == 0 then
				-- if is_timer_scheduled(apu_back_on) == true then
					-- stop_timer(apu_back_on)
				-- end
			-- end
			-- apu_start_active = 1
        end		
	end			
end	


-- DRIVE DISCONNECT

function B738_drive_disconnect1_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_drive_disconnect1_switch_position == 0 then
		B738DR_drive_disconnect1_switch_position = 1
		--simDR_generator1_failure = 6
		simDR_generator1_on = 0
		end
	end
end


function B738_drive_disconnect2_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_drive_disconnect2_switch_position == 0 then
		B738DR_drive_disconnect2_switch_position = 1
		--simDR_generator2_failure = 6
		simDR_generator2_on = 0
		end
	end
end

function B738_drive_disconnect1_off_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_drive_disconnect1_switch_position == 1 then
		B738DR_drive_disconnect1_switch_position = 0
		end
	end
end

function B738_drive_disconnect2_off_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_drive_disconnect2_switch_position == 1 then
		B738DR_drive_disconnect2_switch_position = 0
		end
	end
end


-- function drive_disconnect_reset()

	-- if simDR_generator1_failure == 0 then
	-- B738DR_drive_disconnect1_switch_position = 0
	-- end
	
	-- if simDR_generator2_failure == 0 then
	-- B738DR_drive_disconnect2_switch_position = 0
	-- end
	
-- end
	

-- PAX OXYGEN

function B738_pax_oxy_on_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_pas_oxy_switch_position == 0 then
		B738DR_pas_oxy_switch_position = 1
		pax_oxy = 6
		end
	end
end

function B738_pax_oxy_norm_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_pas_oxy_switch_position == 1 then
		B738DR_pas_oxy_switch_position = 0
		pax_oxy = 0
		end
	end
end

function trip_oxy_on()
	
	local cab_alt_status = 0
		if simDR_cabin_alt > 14000 then
		cab_alt_status = 6
		end
		
	if pax_oxy == 6 then
	simDR_pax_oxy = 6
	elseif cab_alt_status == 6 then
	simDR_pax_oxy = 6
	end

end


-- ENGINE HYDRO PUMPS
function B738_hydro_pumps1_switch_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_hydro_pumps1_switch_position = 1 - B738DR_hydro_pumps1_switch_position
		-- if B738DR_hydro_pumps1_switch_position == 0
		-- and B738DR_hydro_pumps2_switch_position == 0 then
		-- -- turn off hydro pumps
		-- simCMD_hydro_pumps_off:once()
		-- end
		-- if B738DR_hydro_pumps1_switch_position == 1
		-- and B738DR_hydro_pumps2_switch_position == 0 then
		-- -- turn on hydro pumps
		-- simCMD_hydro_pumps_on:once()
		-- end
	end	
end

function B738_hydro_pumps2_switch_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_hydro_pumps2_switch_position = 1 - B738DR_hydro_pumps2_switch_position
		-- if B738DR_hydro_pumps1_switch_position == 0
		-- and B738DR_hydro_pumps2_switch_position == 0 then
		-- -- turn off hydro pumps
		-- simCMD_hydro_pumps_off:once()
		-- end
		-- if B738DR_hydro_pumps1_switch_position == 0
		-- and B738DR_hydro_pumps2_switch_position == 1 then
		-- -- turn on hydro pumps
		-- simCMD_hydro_pumps_on:once()
		-- end
	end	
end

-- ELECTRIC HYDRO PUMPS

function B738_el_hydro_pumps1_switch_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_el_hydro_pumps1_switch_position = 1 - B738DR_el_hydro_pumps1_switch_position
		-- if B738DR_el_hydro_pumps1_switch_position == 0
		-- and B738DR_el_hydro_pumps2_switch_position == 0 then
			-- simDR_electric_hyd_pump_switch = 0
		-- else
			-- simDR_electric_hyd_pump_switch = 1
		-- end
	end
end

function B738_el_hydro_pumps2_switch_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_el_hydro_pumps2_switch_position = 1 - B738DR_el_hydro_pumps2_switch_position
		-- if B738DR_el_hydro_pumps1_switch_position == 0
		-- and B738DR_el_hydro_pumps2_switch_position == 0 then
			-- simDR_electric_hyd_pump_switch = 0
		-- else
			-- simDR_electric_hyd_pump_switch = 1
		-- end
	end
end

-- BLEED AIR

function B738_bleed_air_1_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_bleed_air_1_switch_position == 0 then
			B738DR_bleed_air_1_switch_position = 1
		elseif B738DR_bleed_air_1_switch_position == 1 then
			B738DR_bleed_air_1_switch_position = 0
		end
	end
end

function B738_bleed_air_2_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_bleed_air_2_switch_position == 0 then
			B738DR_bleed_air_2_switch_position = 1
		elseif B738DR_bleed_air_2_switch_position == 1 then
			B738DR_bleed_air_2_switch_position = 0
		end
	end
end

function B738_bleed_air_apu_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_bleed_air_apu_switch_position == 0 then
			B738DR_bleed_air_apu_switch_position = 1
		elseif B738DR_bleed_air_apu_switch_position == 1 then
			B738DR_bleed_air_apu_switch_position = 0
		end
	end
end

function B738_trip_reset_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_trip_reset_button_pos == 0 then
			B738DR_trip_reset_button_pos = 1
			simDR_bleed_fail_1 = 0
			simDR_bleed_fail_2 = 0
		end
	elseif phase == 2 then
		if B738DR_trip_reset_button_pos == 1 then
			B738DR_trip_reset_button_pos = 0		
		end
	end
end
		
function B738_crossfeed_valve_on_CMDhandler(phase, duration)
	if phase == 0 then
		if B738_cross_feed_selector_knob_target == 0 then
		B738_cross_feed_selector_knob_target = 1
		end
	end
end

function B738_crossfeed_valve_off_CMDhandler(phase, duration)
	if phase == 0 then
		if B738_cross_feed_selector_knob_target == 1 then
		B738_cross_feed_selector_knob_target = 0
		end
	end
end

-- STALL TEST

function B738_stall_test1_CMDhandler(phase, duration)
	if phase == 0 then
		if simDR_aircraft_on_ground == 1 then
			B738DR_stall_test1 = 1
			simCMD_stall_test:start()
		elseif simDR_aircraft_on_ground == 0 then
			B738DR_stall_test1 = 1
		end
	elseif phase == 2 then
		B738DR_stall_test1 = 0
		simCMD_stall_test:stop()
	end
end

function B738_stall_test2_CMDhandler(phase, duration)
	if phase == 0 then
		if simDR_aircraft_on_ground == 1 then
			B738DR_stall_test2 = 1
			simCMD_stall_test:start()
		elseif simDR_aircraft_on_ground == 0 then
			B738DR_stall_test2 = 1
		end
	elseif phase == 2 then
		B738DR_stall_test2 = 0
		simCMD_stall_test:stop()
	end
end

function B738_xponder_up_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_transponder_knob_pos == 0 then
		B738DR_transponder_knob_pos = 1
		simDR_transponder_mode = 1
	elseif B738DR_transponder_knob_pos == 1 then
		B738DR_transponder_knob_pos = 2
		simDR_transponder_mode = 2
	elseif B738DR_transponder_knob_pos == 2 then
		B738DR_transponder_knob_pos = 3
		simDR_transponder_mode = 2
	elseif B738DR_transponder_knob_pos == 3 then
		B738DR_transponder_knob_pos = 4
		simDR_transponder_mode = 2
	elseif B738DR_transponder_knob_pos == 4 then
		B738DR_transponder_knob_pos = 5
		simDR_transponder_mode = 2
		end
	end
end

function B738_xponder_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_transponder_knob_pos == 5 then
		B738DR_transponder_knob_pos = 4
		simDR_transponder_mode = 2
	elseif B738DR_transponder_knob_pos == 4 then
		B738DR_transponder_knob_pos = 3
		simDR_transponder_mode = 2
	elseif B738DR_transponder_knob_pos == 3 then
		B738DR_transponder_knob_pos = 2
		simDR_transponder_mode = 2
	elseif B738DR_transponder_knob_pos == 2 then
		B738DR_transponder_knob_pos = 1
		simDR_transponder_mode = 1
	elseif B738DR_transponder_knob_pos == 1 then
		B738DR_transponder_knob_pos = 0
		simDR_transponder_mode = 3
		end
	end
end

function B738_xponder_ident_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_transponder_ident_button = 1
		simCMD_xponder_ident:once()
	elseif phase == 2 then
		B738DR_transponder_ident_button = 0
	end
end
	
function B738_nav1_freq_flip_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_nav1_freq_flip_button = 1
		simCMD_nav1_standy_flip:start()
	elseif phase == 2 then
		B738DR_nav1_freq_flip_button = 0
		simCMD_nav1_standy_flip:stop()
	end
end

function B738_nav2_freq_flip_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_nav2_freq_flip_button = 1
		simCMD_nav2_standy_flip:start()
	elseif phase == 2 then
		B738DR_nav2_freq_flip_button = 0
		simCMD_nav2_standy_flip:stop()
	end
end

-- AC POWER KNOB


function B738_ac_power_knob_up_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_ac_power_knob_pos == 0 then
			B738DR_ac_power_knob_pos = 1
		elseif B738DR_ac_power_knob_pos == 1 then
			B738DR_ac_power_knob_pos = 2
		elseif B738DR_ac_power_knob_pos == 2 then
			B738DR_ac_power_knob_pos = 3
		elseif B738DR_ac_power_knob_pos == 3 then
			B738DR_ac_power_knob_pos = 4
		elseif B738DR_ac_power_knob_pos == 4 then
			B738DR_ac_power_knob_pos = 5
		elseif B738DR_ac_power_knob_pos == 5 then
			B738DR_ac_power_knob_pos = 6
		end
	end
end

function B738_ac_power_knob_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_ac_power_knob_pos == 6 then
			B738DR_ac_power_knob_pos = 5
		elseif B738DR_ac_power_knob_pos == 5 then
			B738DR_ac_power_knob_pos = 4
		elseif B738DR_ac_power_knob_pos == 4 then
			B738DR_ac_power_knob_pos = 3
		elseif B738DR_ac_power_knob_pos == 3 then
			B738DR_ac_power_knob_pos = 2
		elseif B738DR_ac_power_knob_pos == 2 then
			B738DR_ac_power_knob_pos = 1
		elseif B738DR_ac_power_knob_pos == 1 then
			B738DR_ac_power_knob_pos = 0
		end
	end
end

-- DC POWER KNOB			


function B738_dc_power_knob_up_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_dc_power_knob_pos == 0 then
			B738DR_dc_power_knob_pos = 1
		elseif B738DR_dc_power_knob_pos == 1 then
			B738DR_dc_power_knob_pos = 2
		elseif B738DR_dc_power_knob_pos == 2 then
			B738DR_dc_power_knob_pos = 3
			simCMD_dc_volt_left:once()
		elseif B738DR_dc_power_knob_pos == 3 then
			B738DR_dc_power_knob_pos = 4
			simCMD_dc_volt_center:once()
		elseif B738DR_dc_power_knob_pos == 4 then
			B738DR_dc_power_knob_pos = 5
			simCMD_dc_volt_right:once()
		elseif B738DR_dc_power_knob_pos == 5 then
			B738DR_dc_power_knob_pos = 6
		end
	end
end

function B738_dc_power_knob_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_dc_power_knob_pos == 6 then
			B738DR_dc_power_knob_pos = 5
			simCMD_dc_volt_right:once()
		elseif B738DR_dc_power_knob_pos == 5 then
			B738DR_dc_power_knob_pos = 4
			simCMD_dc_volt_center:once()
		elseif B738DR_dc_power_knob_pos == 4 then
			B738DR_dc_power_knob_pos = 3
			simCMD_dc_volt_left:once()
		elseif B738DR_dc_power_knob_pos == 3 then
			B738DR_dc_power_knob_pos = 2
		elseif B738DR_dc_power_knob_pos == 2 then
			B738DR_dc_power_knob_pos = 1
		elseif B738DR_dc_power_knob_pos == 1 then
			B738DR_dc_power_knob_pos = 0
		end
	end
end



--------------------

-- STARTER KNOB COMMANDS
function B738_eng1_start_left_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_engine1_starter_pos ~= 0 then
			B738DR_engine1_starter_pos = B738DR_engine1_starter_pos - 1
		end
	end
end
function B738_eng1_start_right_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_engine1_starter_pos < 3 then
			B738DR_engine1_starter_pos = B738DR_engine1_starter_pos + 1
		end
	end
end
function B738_eng2_start_left_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_engine2_starter_pos ~= 0 then
			B738DR_engine2_starter_pos = B738DR_engine2_starter_pos - 1
		end
	end
end
function B738_eng2_start_right_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_engine2_starter_pos < 3 then
			B738DR_engine2_starter_pos = B738DR_engine2_starter_pos + 1
		end
	end
end

function B738_eng1_start_grd_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_engine1_starter_pos = 0
	end
end
function B738_eng1_start_off_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_engine1_starter_pos = 1
	end
end
function B738_eng1_start_cont_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_engine1_starter_pos = 2
	end
end
function B738_eng1_start_flt_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_engine1_starter_pos = 3
	end
end

function B738_eng2_start_grd_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_engine2_starter_pos = 0
	end
end
function B738_eng2_start_off_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_engine2_starter_pos = 1
	end
end
function B738_eng2_start_cont_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_engine2_starter_pos = 2
	end
end
function B738_eng2_start_flt_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_engine2_starter_pos = 3
	end
end
-------------------------

function B738_gear_toggle_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_gear_handle_pos == 0 then			-- UP -> OFF
			B738DR_gear_handle_pos = 0.5
			B738DR_gear_handle_act = 0.5
			B738_landing_gear = 1	--off
		elseif B738DR_gear_handle_pos == 0.5 then	-- OFF -> DOWN
			B738DR_gear_handle_pos = 1
			B738DR_gear_handle_act = 1
			B738_landing_gear = 2	--down
			landing_gear_target = 1
		elseif B738DR_gear_handle_pos == 1 then		-- DOWN -> UP
			if gear_lock == 0 then		-- DOWN -> UP
				B738DR_gear_handle_pos = 0
				B738DR_gear_handle_act = 0
				B738_landing_gear = 0	--up
				if B738DR_landgear_pos < 0.9 and B738DR_landgear_cover_pos < 0.9 then
					landing_gear_target = 0
				end
			else
				B738DR_gear_handle_pos = 0.5
				B738DR_gear_handle_act = 0.5
				B738_landing_gear = 1	--off
			end
		end
	end
end

function B738_def_gear_down_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_gear_handle_pos == 0 then			-- UP -> OFF
			B738DR_gear_handle_pos = 0.5
			B738DR_gear_handle_act = 0.5
			B738_landing_gear = 1	--off
		elseif B738DR_gear_handle_pos == 0.5 then	-- OFF -> DOWN
			B738DR_gear_handle_pos = 1
			B738DR_gear_handle_act = 1
			B738_landing_gear = 2	--down
			landing_gear_target = 1
		end
	end
end

function B738_def_gear_up_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_gear_handle_pos == 1 then		-- DOWN -> UP
			if gear_lock == 0 then		-- DOWN -> UP
				B738DR_gear_handle_pos = 0
				B738DR_gear_handle_act = 0
				B738_landing_gear = 0	--up
				if B738DR_landgear_pos < 0.9 and B738DR_landgear_cover_pos < 0.9 then
					landing_gear_target = 0
				end
			else
				B738DR_gear_handle_pos = 0.5
				B738DR_gear_handle_act = 0.5
				B738_landing_gear = 1	--off
			end
		end
	end
end


------------------------------
--- AIR BLEED, ISO VALVE, L PACK, R PACK
-------------------------------
function B738_l_pack_up_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_l_pack_pos == 2 then
			B738DR_l_pack_pos = 1
		elseif B738DR_l_pack_pos == 1 then
			B738DR_l_pack_pos = 0
		end
	end
end

function B738_l_pack_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_l_pack_pos == 0 then
			B738DR_l_pack_pos = 1
		elseif B738DR_l_pack_pos == 1 then
			B738DR_l_pack_pos = 2
		end
	end
end

function B738_r_pack_up_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_r_pack_pos == 2 then
			B738DR_r_pack_pos = 1
		elseif B738DR_r_pack_pos == 1 then
			B738DR_r_pack_pos = 0
		end
	end
end

function B738_r_pack_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_r_pack_pos == 0 then
			B738DR_r_pack_pos = 1
		elseif B738DR_r_pack_pos == 1 then
			B738DR_r_pack_pos = 2
		end
	end
end

function B738_iso_valve_up_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_isolation_valve_pos == 2 then
			B738DR_isolation_valve_pos = 1
		elseif B738DR_isolation_valve_pos == 1 then
			B738DR_isolation_valve_pos = 0
		end
	end
end

function B738_iso_valve_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_isolation_valve_pos == 0 then
			B738DR_isolation_valve_pos = 1
		elseif B738DR_isolation_valve_pos == 1 then
			B738DR_isolation_valve_pos = 2
		end
	end
end

--- APU generator switches
function B738CMD_apu_gen1_up_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_apu_gen1_pos = -1
		B738DR_apu_power_bus1 = 0
	elseif phase == 2 then
		B738DR_apu_gen1_pos = 0
	end
end
function B738CMD_apu_gen1_dn_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_apu_gen1_pos = 1
		if B738DR_apu_bus_enable == 1 then
			B738DR_apu_power_bus1 = 1
			simCMD_apu_gen_on:once()
		end
		simCMD_generator_1_off:once()
		simCMD_gpu_off:once()
		--if B738DR_apu_temp > 95 then
		-- if simDR_apu_status > 94 then
			-- B738DR_apu_power_bus1 = 1
		-- end
	elseif phase == 2 then
		B738DR_apu_gen1_pos = 0
	end
end

function B738CMD_apu_gen2_up_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_apu_gen2_pos = -1
		B738DR_apu_power_bus2 = 0
	elseif phase == 2 then
		B738DR_apu_gen2_pos = 0
	end
end
function B738CMD_apu_gen2_dn_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_apu_gen2_pos = 1
		if B738DR_apu_bus_enable == 1 then
			B738DR_apu_power_bus2 = 1
			simCMD_apu_gen_on:once()
		end
		simCMD_generator_2_off:once()
		simCMD_gpu_off:once()
	elseif phase == 2 then
		B738DR_apu_gen2_pos = 0
	end
end

-- GPU
function B738CMD_gpu_up_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_gpu_pos = -1
		simCMD_gpu_off:once()
	elseif phase == 2 then
		B738DR_gpu_pos = 0
	end
end
function B738CMD_gpu_dn_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_gpu_pos = 1
		-- if simDR_aircraft_on_ground == 1 
		-- and simDR_aircraft_groundspeed < 0.05 
		-- and simDR_brake == 1 then
		if B738DR_gpu_available == 1 then
			simCMD_gpu_on:once()
			simCMD_generator_1_off:once()
			simCMD_generator_2_off:once()
			B738DR_apu_power_bus1 = 0
			B738DR_apu_power_bus2 = 0
		end
	elseif phase == 2 then
		B738DR_gpu_pos = 0
	end
end


-- GENERATORS
function B738CMD_gen1_up_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_gen1_pos = -1
		simCMD_generator_1_off:once()
	elseif phase == 2 then
		B738DR_gen1_pos = 0
	end
end
function B738CMD_gen1_dn_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_gen1_pos = 1
		if B738DR_gen1_available == 1 then
			simCMD_generator_1_on:once()
		end
		simCMD_gpu_off:once()
		B738DR_apu_power_bus1 = 0
	elseif phase == 2 then
		B738DR_gen1_pos = 0
	end
end

function B738CMD_gen2_up_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_gen2_pos = -1
		simCMD_generator_2_off:once()
	elseif phase == 2 then
		B738DR_gen2_pos = 0
	end
end
function B738CMD_gen2_dn_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_gen2_pos = 1
		if B738DR_gen2_available == 1 then
			simCMD_generator_2_on:once()
		end
		simCMD_gpu_off:once()
		B738DR_apu_power_bus2 = 0
	elseif phase == 2 then
		B738DR_gen2_pos = 0
	end
end


-- AUTOBRAKE knob --
function B738CMD_autobrake_up_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_autobrake_pos == 0 then
			B738DR_autobrake_pos = 1
			if B738DR_autobrake_RTO_arm == 2 then
				after_RTO = 1
			end
			B738DR_autobrake_RTO_arm = 0
			B738DR_autobrake_RTO_test = 0
			B738DR_autobrake_disarm = 0
			autobrake_ratio = 0
		elseif B738DR_autobrake_pos == 1 then
			B738DR_autobrake_pos = 2
			if simDR_on_ground_0 == 1 then
				B738DR_autobrake_disarm = 1
			end
		elseif B738DR_autobrake_pos == 2 then
			B738DR_autobrake_pos = 3
		elseif B738DR_autobrake_pos == 3 then
			B738DR_autobrake_pos = 4
		elseif B738DR_autobrake_pos == 4 then
			B738DR_autobrake_pos = 5
		end
	end
end
function B738CMD_autobrake_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_autobrake_pos == 1 then
			B738DR_autobrake_pos = 0
			if simDR_on_ground_0 == 1
			and simDR_ground_speed < 60
			and simDR_throttle_all < 0.1 then
				B738DR_autobrake_RTO_arm = 1
				B738DR_autobrake_RTO_test = 1
			end
		elseif B738DR_autobrake_pos == 2 then
			B738DR_autobrake_pos = 1
			B738DR_autobrake_arm = 0
			B738DR_autobrake_disarm = 0
			autobrake_ratio = 0
		elseif B738DR_autobrake_pos == 3 then
			B738DR_autobrake_pos = 2
		elseif B738DR_autobrake_pos == 4 then
			B738DR_autobrake_pos = 3
		elseif B738DR_autobrake_pos == 5 then
			B738DR_autobrake_pos = 4
		end
	end
end

-- L RECIRC FAN
function B738CMD_l_recirc_fan_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_l_recirc_fan_pos == 0 then
			B738DR_l_recirc_fan_pos = 1
		elseif B738DR_l_recirc_fan_pos == 1 then
			B738DR_l_recirc_fan_pos = 0
		end
	end
end

-- R RECIRC FAN
function B738CMD_r_recirc_fan_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_r_recirc_fan_pos == 0 then
			B738DR_r_recirc_fan_pos = 1
		elseif B738DR_r_recirc_fan_pos == 1 then
			B738DR_r_recirc_fan_pos = 0
		end
	end
end

-- TRIM AIR
function B738CMD_trim_air_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_trim_air_pos == 0 then
			B738DR_trim_air_pos = 1
		elseif B738DR_trim_air_pos == 1 then
			B738DR_trim_air_pos = 0
		end
	end
end

-- LANDING GEAR
function B738CMD_gear_down_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_gear_handle_pos = 1
		B738DR_gear_handle_act = 1
		B738_landing_gear = 2	--down
		landing_gear_target = 1
	end
end

function B738CMD_gear_up_CMDhandler(phase, duration)
	if phase == 0 then
		if gear_lock == 0 then
			B738DR_gear_handle_pos = 0
			B738DR_gear_handle_act = 0
			B738_landing_gear = 0	--up
			if B738DR_landgear_pos < 0.9 and B738DR_landgear_cover_pos < 0.9 then
				landing_gear_target = 0
			end
		end
	end
end

function B738CMD_gear_off_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_gear_handle_pos = 0.5
		B738DR_gear_handle_act = 0.5
		B738_landing_gear = 1	--off
	end
end

function B738CMD_gear_down_one_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_gear_handle_pos == 0 then
			B738DR_gear_handle_pos = 0.5
			B738DR_gear_handle_act = 0.5
			B738_landing_gear = 1	--off
		elseif B738DR_gear_handle_pos == 0.5 then
			B738DR_gear_handle_pos = 1
			B738DR_gear_handle_act = 1
			B738_landing_gear = 2	--down
			landing_gear_target = 1
		end
	end
end

function B738CMD_gear_up_one_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_gear_handle_pos == 1 then
			if gear_lock == 0 then
				B738DR_gear_handle_pos = 0
				B738DR_gear_handle_act = 0
				B738_landing_gear = 0	--up
				if B738DR_landgear_pos < 0.9 and B738DR_landgear_cover_pos < 0.9 then
					landing_gear_target = 0
				end
			else
				B738DR_gear_handle_pos = 0.5
				B738DR_gear_handle_act = 0.5
				B738_landing_gear = 1	--off
			end
		end
	end
end

-- FUEL FLOW
function B738_fuel_flow_up_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_fuel_flow_pos = -1
		B738DR_fuel_flow_used = 0
		if is_timer_scheduled(ff_used_timer_off) == true then
			stop_timer(ff_used_timer_off)
		end
	elseif phase == 2 then
		B738DR_fuel_flow_pos = 0
		last_fuel_tank = simDR_fuel_tank_weight_kg[0] + simDR_fuel_tank_weight_kg[1] + simDR_fuel_tank_weight_kg[2]
		if is_timer_scheduled(ff_used_timer_off) == false and B738DR_fuel_flow_used_show == 1 then
			run_after_time(ff_used_timer_off, 10)	-- 10 seconds
		end
	end
end

function B738_fuel_flow_dn_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_fuel_flow_pos = 1
		B738DR_fuel_flow_used_show = 1
		if is_timer_scheduled(ff_used_timer_off) == true then
			stop_timer(ff_used_timer_off)
		end
	elseif phase == 2 then
		B738DR_fuel_flow_pos = 0
		if is_timer_scheduled(ff_used_timer_off) == false then
			run_after_time(ff_used_timer_off, 10)	-- 10 seconds
		end
	end
end

---------------------------------------------------------

-- ENGINE STARTER SELECT
function B738_eng_start_lft_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_eng_start_source == 0 then
			B738DR_eng_start_source = -1
		elseif B738DR_eng_start_source == 1 then
			B738DR_eng_start_source = 0
		end
	end
end

function B738_eng_start_rgt_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_eng_start_source == -1 then
			B738DR_eng_start_source = 0
		elseif B738DR_eng_start_source == 0 then
			B738DR_eng_start_source = 1
		end
	end
end

-- AIR VALVE MANUAL CONTROL (spring)
function B738_air_valve_lft_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_air_valve_manual = -1
	elseif phase == 2 then
		B738DR_air_valve_manual = 0
	end
end

function B738_air_valve_rgt_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_air_valve_manual = 1
	elseif phase == 2 then
		B738DR_air_valve_manual = 0
	end
end

-- EQUIPMENT COOLING EXHAUST SWITCH
function B738_eq_cool_exhaust_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_eq_cool_exhaust == 0 then
			B738DR_eq_cool_exhaust = 1
		elseif B738DR_eq_cool_exhaust == 1 then
			B738DR_eq_cool_exhaust = 0
		end
	end
end

-- EQUIPMENT COOLING SUPPLY SWITCH
function B738_eq_cool_supply_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_eq_cool_supply == 0 then
			B738DR_eq_cool_supply = 1
		elseif B738DR_eq_cool_supply == 1 then
			B738DR_eq_cool_supply = 0
		end
	end
end

-- DISPLAY CONTROL PANEL SWITCH
function B738_dspl_ctrl_pnl_lft_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_dspl_ctrl_pnl == 0 then
			B738DR_dspl_ctrl_pnl = -1
		elseif B738DR_dspl_ctrl_pnl == 1 then
			B738DR_dspl_ctrl_pnl = 0
		end
	end
end

function B738_dspl_ctrl_pnl_rgt_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_dspl_ctrl_pnl == -1 then
			B738DR_dspl_ctrl_pnl = 0
		elseif B738DR_dspl_ctrl_pnl == 0 then
			B738DR_dspl_ctrl_pnl = 1
		end
	end
end

-- FMC NAVIGATION SWITCH
function B738_fmc_source_left_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_fmc_source == 0 then
			B738DR_fmc_source = -1
		elseif B738DR_fmc_source == 1 then
			B738DR_fmc_source = 0
		end
	end
end

function B738_fmc_source_right_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_fmc_source == -1 then
			B738DR_fmc_source = 0
		elseif B738DR_fmc_source == 0 then
			B738DR_fmc_source = 1
		end
	end
end

-- WINDOW OVERHEAT TEST SWITCH (spring)
function B738_ovht_test_up_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_window_ovht_test = -1
	elseif phase == 2 then
		B738DR_window_ovht_test = 0
	end
end

function B738_ovht_test_dn_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_window_ovht_test = 1
	elseif phase == 2 then
		B738DR_window_ovht_test = 0
	end
end

-- SERVICE INTERPHONE SWITCH
function B738_service_interphone_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_service_interphone == 0 then
			B738DR_service_interphone = 1
		elseif B738DR_service_interphone == 1 then
			B738DR_service_interphone = 0
		end
	end
end

-- ALTERNATE FLAPS CONTROL SWITCH
function B738_alt_flaps_ctrl_up_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_alt_flaps_ctrl == 0 then
			B738DR_alt_flaps_ctrl = -1
		elseif B738DR_alt_flaps_ctrl == 1 then
			B738DR_alt_flaps_ctrl = 0
		end
	elseif phase == 2 then
		if B738DR_batbus_status == 0 then
			B738DR_alt_flaps_ctrl = 0
		end
	end
end

function B738_alt_flaps_ctrl_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_alt_flaps_ctrl == -1 then
			B738DR_alt_flaps_ctrl = 0
		elseif B738DR_alt_flaps_ctrl == 0 then
			B738DR_alt_flaps_ctrl = 1
		end
	elseif phase == 2 then
		B738DR_alt_flaps_ctrl = 0
	end
end

-- AIR VALVE CONTROL MODE SWITCH
function B738_air_valve_ctrl_lft_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_air_valve_ctrl == 1 then
			B738DR_air_valve_ctrl = 0
			B738DR_pressurization_mode = 0
		elseif B738DR_air_valve_ctrl == 2 then
			B738DR_air_valve_ctrl = 1
			B738DR_pressurization_mode = 1
			--alt_pressurize_auto = simDR_press_max_alt
			--alt_pressurize_land = B738DR_landing_alt_sel_rheo
		end
	end
end

function B738_air_valve_ctrl_rgt_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_air_valve_ctrl == 0 then
			B738DR_air_valve_ctrl = 1
			B738DR_pressurization_mode = 1
		elseif B738DR_air_valve_ctrl == 1 then
			B738DR_air_valve_ctrl = 2
			B738DR_pressurization_mode = 2
			if simDR_altitude_pilot < alt_pressurize_land then
				simDR_dump_all = 1
				tgt_outflow_valve = 1
			else
				if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1 or simDR_on_ground_2 == 1 then
					simDR_dump_all = 1
					tgt_outflow_valve = 1
				else
					dump_all = 0
					tgt_outflow_valve = 0
					press_set_vvi = 2500
				end
			end
			
			
		end
	end
end

-- AIR TEMP SELECT SWITCH
function B738_air_temp_ctrl_lft_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_air_temp_source == 1 then
			B738DR_air_temp_source = 0
		elseif B738DR_air_temp_source == 2 then
			B738DR_air_temp_source = 1
		elseif B738DR_air_temp_source == 3 then
			B738DR_air_temp_source = 2
		elseif B738DR_air_temp_source == 4 then
			B738DR_air_temp_source = 3
		elseif B738DR_air_temp_source == 5 then
			B738DR_air_temp_source = 4
		elseif B738DR_air_temp_source == 6 then
			B738DR_air_temp_source = 5
		end
	end
end

function B738_air_temp_ctrl_rgt_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_air_temp_source == 0 then
			B738DR_air_temp_source = 1
		elseif B738DR_air_temp_source == 1 then
			B738DR_air_temp_source = 2
		elseif B738DR_air_temp_source == 2 then
			B738DR_air_temp_source = 3
		elseif B738DR_air_temp_source == 3 then
			B738DR_air_temp_source = 4
		elseif B738DR_air_temp_source == 4 then
			B738DR_air_temp_source = 5
		elseif B738DR_air_temp_source == 5 then
			B738DR_air_temp_source = 6
		end
	end
end

-- FLIGHT DECK DOOR SWITCH
function B738_flt_dk_door_left_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_flt_dk_door == 0 then
			B738DR_flt_dk_door = -1
		elseif B738DR_flt_dk_door == 1 then
			B738DR_flt_dk_door = 0
		end
	end
end

function B738_flt_dk_door_right_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_flt_dk_door == -1 then
			B738DR_flt_dk_door = 0
		elseif B738DR_flt_dk_door == 0 then
			B738DR_flt_dk_door = 1
		end
	end
end

-- First Officer MAIN PANEL DU SWITCH
function B738_main_pnl_du_fo_rgt_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_main_pnl_du_fo == 0 then
			B738DR_main_pnl_du_fo = -1
		elseif B738DR_main_pnl_du_fo == 1 then
			B738DR_main_pnl_du_fo = 0
		elseif B738DR_main_pnl_du_fo == 2 then
			B738DR_main_pnl_du_fo = 1
		elseif B738DR_main_pnl_du_fo == 3 then
			B738DR_main_pnl_du_fo = 2
		end
	end
end

function B738_main_pnl_du_fo_lft_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_main_pnl_du_fo == -1 then
			B738DR_main_pnl_du_fo = 0
		elseif B738DR_main_pnl_du_fo == 0 then
			B738DR_main_pnl_du_fo = 1
		elseif B738DR_main_pnl_du_fo == 1 then
			B738DR_main_pnl_du_fo = 2
		elseif B738DR_main_pnl_du_fo == 2 then
			B738DR_main_pnl_du_fo = 3
		end
	end
end

-- First Officer LOWER DU SWITCH
function B738_lower_du_fo_rgt_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_lower_du_fo == 0 then
			B738DR_lower_du_fo = -1
		elseif B738DR_lower_du_fo == 1 then
			B738DR_lower_du_fo = 0
		end
	end
end

function B738_lower_du_fo_lft_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_lower_du_fo == -1 then
			B738DR_lower_du_fo = 0
		elseif B738DR_lower_du_fo == 0 then
			B738DR_lower_du_fo = 1
		end
	end
end

-- Captain MAIN PANEL DU SWITCH
function B738_main_pnl_du_cpt_lft_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_main_pnl_du_capt == 0 then
			B738DR_main_pnl_du_capt = -1
		elseif B738DR_main_pnl_du_capt == 1 then
			B738DR_main_pnl_du_capt = 0
		elseif B738DR_main_pnl_du_capt == 2 then
			B738DR_main_pnl_du_capt = 1
		elseif B738DR_main_pnl_du_capt == 3 then
			B738DR_main_pnl_du_capt = 2
		end
	end
end

function B738_main_pnl_du_cpt_rgt_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_main_pnl_du_capt == -1 then
			B738DR_main_pnl_du_capt = 0
		elseif B738DR_main_pnl_du_capt == 0 then
			B738DR_main_pnl_du_capt = 1
		elseif B738DR_main_pnl_du_capt == 1 then
			B738DR_main_pnl_du_capt = 2
		elseif B738DR_main_pnl_du_capt == 2 then
			B738DR_main_pnl_du_capt = 3
		end
	end
end

-- Captain LOWER DU SWITCH
function B738_lower_du_cpt_lft_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_lower_du_capt == 0 then
			B738DR_lower_du_capt = -1
		elseif B738DR_lower_du_capt == 1 then
			B738DR_lower_du_capt = 0
		end
	end
end

function B738_lower_du_cpt_rgt_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_lower_du_capt == -1 then
			B738DR_lower_du_capt = 0
		elseif B738DR_lower_du_capt == 0 then
			B738DR_lower_du_capt = 1
		end
	end
end

-- DISPLAY SOURCE SWITCH
function B738_dspl_source_left_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_dspl_source == 0 then
			B738DR_dspl_source = -1
		elseif B738DR_dspl_source == 1 then
			B738DR_dspl_source = 0
		end
	end
end

function B738_dspl_source_right_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_dspl_source == -1 then
			B738DR_dspl_source = 0
		elseif B738DR_dspl_source == 0 then
			B738DR_dspl_source = 1
		end
	end
end


-- SPD REF SET SWITCH
function B738_spd_ref_left_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_spd_ref == 1 then
			B738DR_spd_ref = 0
		elseif B738DR_spd_ref == 2 then
			B738DR_spd_ref = 1
			B738DR_spd_ref_adjust = B738DR_man_v1
		elseif B738DR_spd_ref == 3 then
			B738DR_spd_ref = 2
			B738DR_spd_ref_adjust = B738DR_man_vr
		elseif B738DR_spd_ref == 4 then
			B738DR_spd_ref = 3
		elseif B738DR_spd_ref == 5 then
			B738DR_spd_ref = 4
			B738DR_spd_ref_adjust = B738DR_man_vref
		elseif B738DR_spd_ref == 6 then
			B738DR_spd_ref = 5
		end
	end
end

function B738_spd_ref_right_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_spd_ref == 0 then
			B738DR_spd_ref = 1
			B738DR_spd_ref_adjust = B738DR_man_v1
		elseif B738DR_spd_ref == 1 then
			B738DR_spd_ref = 2
			B738DR_spd_ref_adjust = B738DR_man_vr
		elseif B738DR_spd_ref == 2 then
			B738DR_spd_ref = 3
		elseif B738DR_spd_ref == 3 then
			B738DR_spd_ref = 4
			B738DR_spd_ref_adjust = B738DR_man_vref
		elseif B738DR_spd_ref == 4 then
			B738DR_spd_ref = 5
		elseif B738DR_spd_ref == 5 then
			B738DR_spd_ref = 6
		end
	end
end

-- SPD REF SET ADJUST KNOB
function B738_spd_ref_adj_left_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_spd_ref_adjust > 101 then
			B738DR_spd_ref_adjust = B738DR_spd_ref_adjust - 1
		end
	end
end

function B738_spd_ref_adj_right_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_spd_ref_adjust < 200 then
			B738DR_spd_ref_adjust = B738DR_spd_ref_adjust + 1
		end
	end
end

-- -- First Officer MINIMUMS SET SWITCH
-- function B738_fo_minimums_up_CMDhandler(phase, duration)
	-- if phase == 0 then
		-- if B738DR_minim_fo == 1 then
			-- B738DR_minim_fo = 0
		-- end
	-- end
-- end

-- function B738_fo_minimums_dn_CMDhandler(phase, duration)
	-- if phase == 0 then
		-- if B738DR_minim_fo == 0 then
			-- B738DR_minim_fo = 1
		-- end
	-- end
-- end

-- -- Captain MINIMUMS SET SWITCH
-- function B738_cpt_minimums_up_CMDhandler(phase, duration)
	-- if phase == 0 then
		-- if B738DR_minim_capt == 1 then
			-- B738DR_minim_capt = 0
		-- end
	-- end
-- end

-- function B738_cpt_minimums_dn_CMDhandler(phase, duration)
	-- if phase == 0 then
		-- if B738DR_minim_capt == 0 then
			-- B738DR_minim_capt = 1
		-- end
	-- end
-- end

-- PARKING BRAKES
function B738_park_brake_toggle_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_parking_brake_pos == 0 then
			B738DR_parking_brake_pos = 1
			--simDR_brake = 1
			--parkbrake_force = 1
			if B738DR_chock_status == 1 and B738DR_parkbrake_remove_chock == 1 then
				B738DR_chock_status = 0
			end
		else
			B738DR_parking_brake_pos = 0
			--simDR_brake = 0
			--parkbrake_force = 0
		end
	end
end

function B738_park_brake_reg_toggle_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_parking_brake_pos == 0 then
			B738DR_parking_brake_pos = 0.28 --0.24
			--simDR_brake = 0.24
			--parkbrake_force = 0.24
		else
			B738DR_parking_brake_pos = 0
			--simDR_brake = 0
			--parkbrake_force = 0
		end
	end
end

function B738_park_brake_CMDhandler(phase, duration)
	if phase == 0 or phase == 1 then
		B738DR_parking_brake_pos = 1
		--simDR_brake = 1
		--parkbrake_force = 1
		if B738DR_chock_status == 1 and B738DR_parkbrake_remove_chock == 1 then
			B738DR_chock_status = 0
		end
	elseif phase == 2 then
		B738DR_parking_brake_pos = 0
		--simDR_brake = 0
		--parkbrake_force = 0
	end
end

function B738_park_brake_reg_CMDhandler(phase, duration)
	if phase == 0 or phase == 1 then
		B738DR_parking_brake_pos = 0.28 --0.24
		--simDR_brake = 0.24
		--parkbrake_force = 0.24
	elseif phase == 2 then
		B738DR_parking_brake_pos = 0
		--simDR_brake = 0
		--parkbrake_force = 0
	end
end

function B738_fuel_pump_lft1_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_fuel_tank_pos_lft1 == 0 then
			B738DR_fuel_tank_pos_lft1 = 1
		else
			B738DR_fuel_tank_pos_lft1 = 0
		end
	end
end

function B738_fuel_pump_lft2_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_fuel_tank_pos_lft2 == 0 then
			B738DR_fuel_tank_pos_lft2 = 1
		else
			B738DR_fuel_tank_pos_lft2 = 0
		end
	end
end

function B738_fuel_pump_ctr1_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_fuel_tank_pos_ctr1 == 0 then
			B738DR_fuel_tank_pos_ctr1 = 1
		else
			B738DR_fuel_tank_pos_ctr1 = 0
		end
	end
end

function B738_fuel_pump_ctr2_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_fuel_tank_pos_ctr2 == 0 then
			B738DR_fuel_tank_pos_ctr2 = 1
		else
			B738DR_fuel_tank_pos_ctr2 = 0
		end
	end
end

function B738_fuel_pump_rgt1_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_fuel_tank_pos_rgt1 == 0 then
			B738DR_fuel_tank_pos_rgt1 = 1
		else
			B738DR_fuel_tank_pos_rgt1 = 0
		end
	end
end

function B738_fuel_pump_rgt2_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_fuel_tank_pos_rgt2 == 0 then
			B738DR_fuel_tank_pos_rgt2 = 1
		else
			B738DR_fuel_tank_pos_rgt2 = 0
		end
	end
end

function B738_yaw_dumper_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_yaw_damper_switch_pos == 0 then
			B738DR_yaw_damper_switch_pos = 1
			yaw_damper_switch_status = 2
		else
			B738DR_yaw_damper_switch_pos = 0
			yaw_damper_switch_status = 0
		end
	elseif phase == 2 then
		if B738DR_yaw_damper_switch_pos == 1 then
			yaw_damper_switch_status = 1
		end
	end
end


function B738_alt_horn_cutout_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_alt_horn_cutout_pos = 1
		B738DR_alt_horn_cut_disable = 1
	elseif phase == 2 then
		B738DR_alt_horn_cutout_pos = 0
	end
end

function B738_gear_horn_cutout_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_gear_horn_cutout_pos = 1
		if simDR_flaps_ratio < 0.625 and B738DR_cabin_gear_wrn == 1 then
			B738DR_gear_horn_cut_disable = 1
		end
	elseif phase == 2 then
		B738DR_gear_horn_cutout_pos = 0
	end
end


function B738_below_gs_disable_pilot_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_below_gs_pilot = 1
		if B738DR_below_gs ~= 0 then
			B738DR_below_gs_disable = 1
		end
	elseif phase == 2 then
		B738DR_below_gs_pilot = 0
	end
end


function B738_below_gs_disable_copilot_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_below_gs_copilot = 1
		if B738DR_below_gs ~= 0 then
			B738DR_below_gs_disable = 1
		end
	elseif phase == 2 then
		B738DR_below_gs_copilot = 0
	end
end

-- TOE BRAKES
function B738_toe_brake_left_handl(phase, duration)
	if phase == 0 then
		--simDR_left_brake = 0.3
		left_brake = 0.28 --0.52
	elseif phase == 2 then
		--simDR_left_brake = 0
		left_brake = 0
	end
end

function B738_toe_brake_right_handl(phase, duration)
	if phase == 0 then
		--simDR_right_brake = 0.3
		right_brake = 0.28 --0.52
	elseif phase == 2 then
		--simDR_right_brake = 0
		right_brake = 0
	end
end

function B738_toe_brake_both_handl(phase, duration)
	if phase == 0 then
		--simDR_left_brake = 0.3
		--simDR_right_brake = 0.3
		left_brake = 0.28 --0.52
		right_brake = 0.28 --0.52
	elseif phase == 2 then
		--simDR_left_brake = 0
		--simDR_right_brake = 0
		left_brake = 0
		right_brake = 0
	end
end


function B738_gpws_test_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_gpws_test_pos = 1
		gpws_test_timer = 0
	elseif phase == 1 then
		gpws_test_timer = gpws_test_timer + SIM_PERIOD
		if gpws_test_timer > 2.5 then
			gpws_test_timer = 2.5
		elseif gpws_test_timer > 2 then
			B738DR_enable_gpwstest_long = 1
		end
	elseif phase == 2 then
		B738DR_gpws_test_pos = 0
		if gpws_test_timer < 2 then
			B738DR_enable_gpwstest_short = 1
		end
	end
end

function B738_gpws_gear_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_gpws_gear_pos = 1 - B738DR_gpws_gear_pos
	end
end

function B738_gpws_flap_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_gpws_flap_pos = 1 - B738DR_gpws_flap_pos
	end
end

function B738_gpws_terr_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_gpws_terr_pos = 1 - B738DR_gpws_terr_pos
	end
end

function B738_gpws_gear_cover_CMDhandler(phase, duration)
	if phase == 0 then
		if gear_cover_target == 0 then
			gear_cover_target = 1
		else
			gear_cover_target = 0
		end
	end
end

function B738_gpws_flap_cover_CMDhandler(phase, duration)
	if phase == 0 then
		if flap_cover_target == 0 then
			flap_cover_target = 1
		else
			flap_cover_target = 0
		end
	end
end

function B738_gpws_terr_cover_CMDhandler(phase, duration)
	if phase == 0 then
		if terr_cover_target == 0 then
			terr_cover_target = 1
		else
			terr_cover_target = 0
		end
	end
end

function B738_man_lndgear_cover_CMDhandler(phase, duration)
	if phase == 0 then
		if man_landgear_cover_target == 0 then
			man_landgear_cover_target = 1
		else
			if B738DR_landgear_pos == 0 then
				man_landgear_cover_target = 0
			end
		end
	end
end

function B738_man_lndgear_CMDhandler(phase, duration)
	if phase == 0 then
		if man_landgear_target == 0 then
			if B738DR_landgear_cover_pos > 0.9 then
				man_landgear_target = 1
			end
		else
			man_landgear_target = 0
		end
	end
end


function B738_mach_warn1_test_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_mach_warn1_pos = 1
	elseif phase == 2 then
		B738DR_mach_warn1_pos = 0
	end
end

function B738_mach_warn2_test_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_mach_warn2_pos = 1
	elseif phase == 2 then
		B738DR_mach_warn2_pos = 0
	end
end

function B738_flaps_test_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_flaps_test_pos = 1
	elseif phase == 2 then
		B738DR_flaps_test_pos = 0
	end
end

function B738_tat_test_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_tat_test_pos = 1
	elseif phase == 2 then
		B738DR_tat_test_pos = 0
	end
end

function B738_grd_call_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_grd_call_pos = 1
	elseif phase == 2 then
		B738DR_grd_call_pos = 0
	end
end

function B738_attend_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_attend_pos = 1
	elseif phase == 2 then
		B738DR_attend_pos = 0
	end
end

function B738_duct_ovht_test_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_duct_ovht_test_pos = 1
	elseif phase == 2 then
		B738DR_duct_ovht_test_pos = 0
	end
end

function B738_fdr_cover_CMDhandler(phase, duration)
	if phase == 0 then
		if fdr_cover_target == 0 then
			fdr_cover_target = 1
		else
			fdr_cover_target = 0
		end
	end
end

function B738_fdr_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_fdr_pos = 1 - B738DR_fdr_pos
	end
end

function B738_acdc_maint_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_acdc_maint_pos = 1
	elseif phase == 2 then
		B738DR_acdc_maint_pos = 0
	end
end

function B738_flt_ctr_A_up_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_flt_ctr_A_pos == 0 then
			B738DR_flt_ctr_A_pos = -1
		elseif B738DR_flt_ctr_A_pos == 1 then
			B738DR_flt_ctr_A_pos = 0
		end
	end
end

function B738_flt_ctr_A_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_flt_ctr_A_pos == -1 then
			B738DR_flt_ctr_A_pos = 0
		elseif B738DR_flt_ctr_A_pos == 0 then
			B738DR_flt_ctr_A_pos = 1
		end
	end
end

function B738_flt_ctr_B_up_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_flt_ctr_B_pos == 0 then
			B738DR_flt_ctr_B_pos = -1
		elseif B738DR_flt_ctr_B_pos == 1 then
			B738DR_flt_ctr_B_pos = 0
		end
	end
end

function B738_flt_ctr_B_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_flt_ctr_B_pos == -1 then
			B738DR_flt_ctr_B_pos = 0
		elseif B738DR_flt_ctr_B_pos == 0 then
			B738DR_flt_ctr_B_pos = 1
		end
	end
end

function B738_flt_ctr_A_cover_CMDhandler(phase, duration)
	if phase == 0 then
		if flt_ctr_A_target == 0 then
			flt_ctr_A_target = 1
		else
			flt_ctr_A_target = 0
		end
	end
end

function B738_flt_ctr_B_cover_CMDhandler(phase, duration)
	if phase == 0 then
		if flt_ctr_B_target == 0 then
			flt_ctr_B_target = 1
		else
			flt_ctr_B_target = 0
		end
	end
end

function B738_spoiler_A_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_spoiler_A_pos = 1 - B738DR_spoiler_A_pos
	end
end

function B738_spoiler_B_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_spoiler_B_pos = 1 - B738DR_spoiler_B_pos
	end
end

function B738_spoiler_A_cover_CMDhandler(phase, duration)
	if phase == 0 then
		if spoiler_A_target == 0 then
			spoiler_A_target = 1
		else
			spoiler_A_target = 0
		end
	end
end

function B738_spoiler_B_cover_CMDhandler(phase, duration)
	if phase == 0 then
		if spoiler_B_target == 0 then
			spoiler_B_target = 1
		else
			spoiler_B_target = 0
		end
	end
end

function B738_alt_flaps_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_alt_flaps_pos = 1 - B738DR_alt_flaps_pos
	end
end

function B738_alt_flaps_cover_CMDhandler(phase, duration)
	if phase == 0 then
		if alt_flaps_target == 0 then
			alt_flaps_target = 1
		else
			alt_flaps_target = 0
		end
	end
end

function B738_left_wiper_up_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_left_wiper_pos == 0 then
			B738DR_left_wiper_pos = 1
			l_wiper_first = 1
		elseif B738DR_left_wiper_pos == 1 then
			B738DR_left_wiper_pos = 2
		elseif B738DR_left_wiper_pos == 2 then
			B738DR_left_wiper_pos = 3
		end
	end
end

function B738_left_wiper_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_left_wiper_pos == 1 then
			B738DR_left_wiper_pos = 0
		elseif B738DR_left_wiper_pos == 2 then
			B738DR_left_wiper_pos = 1
			l_wiper_first = 1
		elseif B738DR_left_wiper_pos == 3 then
			B738DR_left_wiper_pos = 2
		end
	end
end

function B738_right_wiper_up_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_right_wiper_pos == 0 then
			B738DR_right_wiper_pos = 1
			r_wiper_first = 1
		elseif B738DR_right_wiper_pos == 1 then
			B738DR_right_wiper_pos = 2
		elseif B738DR_right_wiper_pos == 2 then
			B738DR_right_wiper_pos = 3
		end
	end
end

function B738_right_wiper_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_right_wiper_pos == 1 then
			B738DR_right_wiper_pos = 0
		elseif B738DR_right_wiper_pos == 2 then
			B738DR_right_wiper_pos = 1
			r_wiper_first = 1
		elseif B738DR_right_wiper_pos == 3 then
			B738DR_right_wiper_pos = 2
		end
	end
end

function B738_gear_lock_override_CMDhandler(phase, duration)

    if phase == 0 then
        B738_gear_handle_lock_override = 1
        B738DR_gear_lock_override_pos = 1
    elseif phase == 1 then
        B738_gear_handle_lock_override = 1
        B738DR_gear_lock_override_pos = 1
    elseif phase == 2 then
        B738_gear_handle_lock_override = 0
        B738DR_gear_lock_override_pos = 0
    end
end

function empty_cmd()
end

function flap_sound(phase, duration)
	if phase == 0 then
		fmod_flap_sound = 1
	end
end

--*************************************************************************************--
--** 				              CREATE CUSTOM COMMANDS              			     **--
--*************************************************************************************--
B738CMD_tat_test			= create_command("laminar/B738/push_button/tat_test", "TAT test", B738_tat_test_CMDhandler)
B738CMD_grd_call			= create_command("laminar/B738/push_button/grd_call", "GROUND CALL", B738_grd_call_CMDhandler)
B738CMD_attend				= create_command("laminar/B738/push_button/attend", "ATTEND", B738_attend_CMDhandler)
B738CMD_duct_ovht_test		= create_command("laminar/B738/push_button/duct_ovht_test", "DUCT OVHT test", B738_duct_ovht_test_CMDhandler)
B738CMD_acdc_maint			= create_command("laminar/B738/push_button/acdc_maint", "AC/DC MAINT", B738_acdc_maint_CMDhandler)

B738CMD_flt_ctr_A_up		= create_command("laminar/B738/toggle_switch/flt_ctr_A_up", "Flight control A Up", B738_flt_ctr_A_up_CMDhandler)
B738CMD_flt_ctr_A_dn		= create_command("laminar/B738/toggle_switch/flt_ctr_A_dn", "Flight control A Down", B738_flt_ctr_A_dn_CMDhandler)
B738CMD_flt_ctr_B_up		= create_command("laminar/B738/toggle_switch/flt_ctr_B_up", "Flight control B Up", B738_flt_ctr_B_up_CMDhandler)
B738CMD_flt_ctr_B_dn		= create_command("laminar/B738/toggle_switch/flt_ctr_B_dn", "Flight control B Down", B738_flt_ctr_B_dn_CMDhandler)
B738CMD_flt_ctr_A_cover		= create_command("laminar/B738/toggle_switch/flt_ctr_A_cover", "Cover Flight control A", B738_flt_ctr_A_cover_CMDhandler)
B738CMD_flt_ctr_B_cover		= create_command("laminar/B738/toggle_switch/flt_ctr_B_cover", "Cover Flight control B", B738_flt_ctr_B_cover_CMDhandler)

B738CMD_spoiler_A			= create_command("laminar/B738/toggle_switch/spoiler_A", "Spoiler A", B738_spoiler_A_CMDhandler)
B738CMD_spoiler_B			= create_command("laminar/B738/toggle_switch/spoiler_B", "Spoiler B", B738_spoiler_B_CMDhandler)
B738CMD_spoiler_A_cover		= create_command("laminar/B738/toggle_switch/spoiler_A_cover", "Cover spoiler A", B738_spoiler_A_cover_CMDhandler)
B738CMD_spoiler_B_cover		= create_command("laminar/B738/toggle_switch/spoiler_B_cover", "Cover spoiler B", B738_spoiler_B_cover_CMDhandler)

B738CMD_alt_flaps			= create_command("laminar/B738/toggle_switch/alt_flaps", "Alternate flaps", B738_alt_flaps_CMDhandler)
B738CMD_alt_flaps_cover		= create_command("laminar/B738/toggle_switch/alt_flaps_cover", "Alternate Flaps", B738_alt_flaps_cover_CMDhandler)

B738CMD_left_wiper_up		= create_command("laminar/B738/knob/left_wiper_up", "Left wiper up", B738_left_wiper_up_CMDhandler)
B738CMD_left_wiper_dn		= create_command("laminar/B738/knob/left_wiper_dn", "Left wiper down", B738_left_wiper_dn_CMDhandler)
B738CMD_right_wiper_up		= create_command("laminar/B738/knob/right_wiper_up", "Right wiper up", B738_right_wiper_up_CMDhandler)
B738CMD_right_wiper_dn		= create_command("laminar/B738/knob/right_wiper_dn", "Right wiper down", B738_right_wiper_dn_CMDhandler)

B738CMD_gpws_test			= create_command("laminar/B738/push_button/gpws_test", "GPWS test button", B738_gpws_test_CMDhandler)
B738CMD_gpws_gear			= create_command("laminar/B738/toggle_switch/gpws_gear", "GPWS gear inhibited", B738_gpws_gear_CMDhandler)
B738CMD_gpws_flap			= create_command("laminar/B738/toggle_switch/gpws_flap", "GPWS flaps inhibited", B738_gpws_flap_CMDhandler)
B738CMD_gpws_terr			= create_command("laminar/B738/toggle_switch/gpws_terr", "GPWS terrain inhibited", B738_gpws_terr_CMDhandler)
B738CMD_gpws_gear_cover		= create_command("laminar/B738/toggle_switch/gpws_gear_cover", "GPWS gear inhibited cover", B738_gpws_gear_cover_CMDhandler)
B738CMD_gpws_flap_cover		= create_command("laminar/B738/toggle_switch/gpws_flap_cover", "GPWS flaps inhibited cover", B738_gpws_flap_cover_CMDhandler)
B738CMD_gpws_terr_cover		= create_command("laminar/B738/toggle_switch/gpws_terr_cover", "GPWS terrain inhibited cover", B738_gpws_terr_cover_CMDhandler)

B738CMD_man_lndgear_cover	= create_command("laminar/B738/toggle_switch/man_lndgear_cover", "Manual Landing gear cover", B738_man_lndgear_cover_CMDhandler)
B738CMD_man_lndgear			= create_command("laminar/B738/toggle_switch/man_lndgear", "Manual Landing gear", B738_man_lndgear_CMDhandler)


B738CMD_mach_warn1_test		= create_command("laminar/B738/push_button/mach_warn1_test", "MACH warning test1 button", B738_mach_warn1_test_CMDhandler)
B738CMD_mach_warn2_test		= create_command("laminar/B738/push_button/mach_warn2_test", "MACH warning test2 button", B738_mach_warn2_test_CMDhandler)
B738CMD_flaps_test			= create_command("laminar/B738/push_button/flaps_test", "FLAPS test", B738_flaps_test_CMDhandler)

B738CMD_toe_brake_left		= create_command("laminar/B738/push_button/toe_brake_left", "Toe brake left", B738_toe_brake_left_handl)
B738CMD_toe_brake_right		= create_command("laminar/B738/push_button/toe_brake_right", "Toe brake right", B738_toe_brake_right_handl)
B738CMD_toe_brake_both		= create_command("laminar/B738/push_button/toe_brake_both", "Toe brake both", B738_toe_brake_both_handl)

B738CMD_fuel_pump_lft1		= create_command("laminar/B738/toggle_switch/fuel_pump_lft1", "Fuel pump left1 toggle", B738_fuel_pump_lft1_CMDhandler)
B738CMD_fuel_pump_lft2		= create_command("laminar/B738/toggle_switch/fuel_pump_lft2", "Fuel pump left2 toggle", B738_fuel_pump_lft2_CMDhandler)
B738CMD_fuel_pump_ctr1		= create_command("laminar/B738/toggle_switch/fuel_pump_ctr1", "Fuel pump center1 toggle", B738_fuel_pump_ctr1_CMDhandler)
B738CMD_fuel_pump_ctr2		= create_command("laminar/B738/toggle_switch/fuel_pump_ctr2", "Fuel pump center2 toggle", B738_fuel_pump_ctr2_CMDhandler)
B738CMD_fuel_pump_rgt1		= create_command("laminar/B738/toggle_switch/fuel_pump_rgt1", "Fuel pump right1 toggle", B738_fuel_pump_rgt1_CMDhandler)
B738CMD_fuel_pump_rgt2		= create_command("laminar/B738/toggle_switch/fuel_pump_rgt2", "Fuel pump right2 toggle", B738_fuel_pump_rgt2_CMDhandler)

-- FUEL CROSSFEED VALVE 

B738CMD_crossfeed_valve_on			= create_command("laminar/B738/toggle_switch/crossfeed_valve_on", "Fuel Crossfeed On", B738_crossfeed_valve_on_CMDhandler)
B738CMD_crossfeed_valve_off			= create_command("laminar/B738/toggle_switch/crossfeed_valve_off", "Fuel Crossfeed Off", B738_crossfeed_valve_off_CMDhandler)

-- CAPTAIN ANTI ICE PROBES
B738CMD_probes_capt_switch_pos 	= create_command("laminar/B738/toggle_switch/capt_probes_pos", "Probe Heat A On/Off", B738_probes_capt_switch_pos_CMDhandler)


-- F/O ANTI ICE PROBES
B738CMD_probes_fo_switch_pos 	= create_command("laminar/B738/toggle_switch/fo_probes_pos", "Probe Heat B On/Off", B738_probes_fo_switch_pos_CMDhandler)


-- APU STARTER SWITCH
B738CMD_apu_starter_switch_up	= create_command("laminar/B738/spring_toggle_switch/APU_start_pos_up", "APU Start Switch UP", B738_apu_starter_switch_pos_CMDhandler)
B738CMD_apu_starter_switch_dn	= create_command("laminar/B738/spring_toggle_switch/APU_start_pos_dn", "APU Start Switch Down", B738_apu_starter_switch_neg_CMDhandler)

-- ENGINE HYDRO PUMPS
B738CMD_hydro_pumps1_switch		= create_command("laminar/B738/toggle_switch/hydro_pumps1", "Engine Hydraulic Pumps 1", B738_hydro_pumps1_switch_CMDhandler)
B738CMD_hydro_pumps2_switch		= create_command("laminar/B738/toggle_switch/hydro_pumps2", "Engine Hydraulic Pumps 2", B738_hydro_pumps2_switch_CMDhandler)

-- ELECTRIC HYDRO PUMPS
B738CMD_el_hydro_pumps1_switch	= create_command("laminar/B738/toggle_switch/electric_hydro_pumps1", "Electric Hydraulic Pumps 1", B738_el_hydro_pumps1_switch_CMDhandler)
B738CMD_el_hydro_pumps2_switch	= create_command("laminar/B738/toggle_switch/electric_hydro_pumps2", "Electric Hydraulic Pumps 2", B738_el_hydro_pumps2_switch_CMDhandler)


-- DRIVE DISCONNECT

B738CMD_drive_disconnect1 = create_command("laminar/B738/one_way_switch/drive_disconnect1", "Drive Disconnect 1", B738_drive_disconnect1_CMDhandler)
B738CMD_drive_disconnect2 = create_command("laminar/B738/one_way_switch/drive_disconnect2", "Drive Disconnect 2", B738_drive_disconnect2_CMDhandler)

B738CMD_drive_disconnect1_off = create_command("laminar/B738/one_way_switch/drive_disconnect1_off", "Drive Disconnect 1 off", B738_drive_disconnect1_off_CMDhandler)
B738CMD_drive_disconnect2_off = create_command("laminar/B738/one_way_switch/drive_disconnect2_off", "Drive Disconnect 2 off", B738_drive_disconnect2_off_CMDhandler)

B738CMD_pax_oxy_on = create_command("laminar/B738/one_way_switch/pax_oxy_on", "Passenger Oxygen On", B738_pax_oxy_on_CMDhandler)
B738CMD_pax_oxy_norm = create_command("laminar/B738/one_way_switch/pax_oxy_norm", "Passenger Oxygen Normal", B738_pax_oxy_norm_CMDhandler)

-- BLEED AIR

B738CMD_bleed_air_1 = create_command("laminar/B738/toggle_switch/bleed_air_1", "Bleed Air Eng1 On/Off", B738_bleed_air_1_CMDhandler)
B738CMD_bleed_air_2 = create_command("laminar/B738/toggle_switch/bleed_air_2", "Bleed Air Eng2 On/Off", B738_bleed_air_2_CMDhandler)
B738CMD_bleed_air_apu = create_command("laminar/B738/toggle_switch/bleed_air_apu", "Bleed Air APU On/Off", B738_bleed_air_apu_CMDhandler)

B738CMD_trip_reset = create_command("laminar/B738/push_button/bleed_trip_reset", "Bleed Air Trip Reset", B738_trip_reset_CMDhandler)

-- STALL TESTS

B738CMD_stall_test1 = create_command("laminar/B738/push_button/stall_test1_press", "Stall Test 1", B738_stall_test1_CMDhandler)
B738CMD_stall_test2 = create_command("laminar/B738/push_button/stall_test2_press", "Stall Test 2", B738_stall_test2_CMDhandler)

-- TRANSPONDER MODES

B738CMD_xponder_mode_up = create_command("laminar/B738/knob/transponder_mode_up", "Transponder Mode Up", B738_xponder_up_CMDhandler)
B738CMD_xponder_mode_dn = create_command("laminar/B738/knob/transponder_mode_dn", "Transponder Mode DN", B738_xponder_dn_CMDhandler)

B738CMD_xponder_ident = create_command("laminar/B738/push_button/transponder_ident_dn", "Transponder IDENT", B738_xponder_ident_CMDhandler)

B738CMD_nav1_freq_flip = create_command("laminar/B738/push_button/switch_freq_nav1_press", "NAV 1 Frequency Swap", B738_nav1_freq_flip_CMDhandler)
B738CMD_nav2_freq_flip = create_command("laminar/B738/push_button/switch_freq_nav2_press", "NAV 2 Frequency Swap", B738_nav2_freq_flip_CMDhandler)

-- ELECTRICAL PANEL KNOBS

B738CMD_ac_power_knob_up	= create_command("laminar/B738/knob/ac_power_up", "AC POWER PANEL Up", B738_ac_power_knob_up_CMDhandler)
B738CMD_ac_power_knob_dn	= create_command("laminar/B738/knob/ac_power_dn", "AC POWER PANEL Down", B738_ac_power_knob_dn_CMDhandler)

B738CMD_dc_power_knob_up	= create_command("laminar/B738/knob/dc_power_up", "DC POWER PANEL Up", B738_dc_power_knob_up_CMDhandler)
B738CMD_dc_power_knob_dn	= create_command("laminar/B738/knob/dc_power_dn", "DC POWER PANEL Down", B738_dc_power_knob_dn_CMDhandler)

-------------------
-- ENGINE STARTER KNOBS
B738CMD_eng1_start_left		= create_command("laminar/B738/knob/eng1_start_left", "ENGINE STARTER1 Left", B738_eng1_start_left_CMDhandler)
B738CMD_eng1_start_right	= create_command("laminar/B738/knob/eng1_start_right", "ENGINE STARTER1 Right", B738_eng1_start_right_CMDhandler)
B738CMD_eng2_start_left		= create_command("laminar/B738/knob/eng2_start_left", "ENGINE STARTER2 Left", B738_eng2_start_left_CMDhandler)
B738CMD_eng2_start_right	= create_command("laminar/B738/knob/eng2_start_right", "ENGINE STARTER2 Right", B738_eng2_start_right_CMDhandler)

B738CMD_eng1_start_grd	= create_command("laminar/B738/rotary/eng1_start_grd", "ENGINE STARTER1 GRD", B738_eng1_start_grd_CMDhandler)
B738CMD_eng1_start_off	= create_command("laminar/B738/rotary/eng1_start_off", "ENGINE STARTER1 OFF", B738_eng1_start_off_CMDhandler)
B738CMD_eng1_start_cont	= create_command("laminar/B738/rotary/eng1_start_cont", "ENGINE STARTER1 CONT", B738_eng1_start_cont_CMDhandler)
B738CMD_eng1_start_flt	= create_command("laminar/B738/rotary/eng1_start_flt", "ENGINE STARTER1 FLT", B738_eng1_start_flt_CMDhandler)
B738CMD_eng2_start_grd	= create_command("laminar/B738/rotary/eng2_start_grd", "ENGINE STARTER2 GRD", B738_eng2_start_grd_CMDhandler)
B738CMD_eng2_start_off	= create_command("laminar/B738/rotary/eng2_start_off", "ENGINE STARTER2 OFF", B738_eng2_start_off_CMDhandler)
B738CMD_eng2_start_cont	= create_command("laminar/B738/rotary/eng2_start_cont", "ENGINE STARTER2 CONT", B738_eng2_start_cont_CMDhandler)
B738CMD_eng2_start_flt	= create_command("laminar/B738/rotary/eng2_start_flt", "ENGINE STARTER2 FLT", B738_eng2_start_flt_CMDhandler)
-------------------
B738CMD_l_pack_up		= create_command("laminar/B738/toggle_switch/l_pack_up", "L PACK up", B738_l_pack_up_CMDhandler)
B738CMD_l_pack_dn		= create_command("laminar/B738/toggle_switch/l_pack_dn", "L PACK down", B738_l_pack_dn_CMDhandler)
B738CMD_r_pack_up		= create_command("laminar/B738/toggle_switch/r_pack_up", "R PACK up", B738_r_pack_up_CMDhandler)
B738CMD_r_pack_dn		= create_command("laminar/B738/toggle_switch/r_pack_dn", "R PACK down", B738_r_pack_dn_CMDhandler)
B738CMD_iso_valve_up	= create_command("laminar/B738/toggle_switch/iso_valve_up", "ISOALTION VALVE up", B738_iso_valve_up_CMDhandler)
B738CMD_iso_valve_dn	= create_command("laminar/B738/toggle_switch/iso_valve_dn", "ISOLATION VALVE down", B738_iso_valve_dn_CMDhandler)

-- B738CMD_apu_gen1		= create_command("laminar/B738/toggle_switch/apu_gen1", "APU generator1 on/off", B738CMD_apu_gen1_CMDhandler)
-- B738CMD_apu_gen2		= create_command("laminar/B738/toggle_switch/apu_gen2", "APU generator2 on/off", B738CMD_apu_gen2_CMDhandler)

B738CMD_apu_gen1_up		= create_command("laminar/B738/toggle_switch/apu_gen1_up", "APU generator1 up", B738CMD_apu_gen1_up_CMDhandler)
B738CMD_apu_gen1_dn		= create_command("laminar/B738/toggle_switch/apu_gen1_dn", "APU generator1 dn", B738CMD_apu_gen1_dn_CMDhandler)
B738CMD_apu_gen2_up		= create_command("laminar/B738/toggle_switch/apu_gen2_up", "APU generator2 up", B738CMD_apu_gen2_up_CMDhandler)
B738CMD_apu_gen2_dn		= create_command("laminar/B738/toggle_switch/apu_gen2_dn", "APU generator2 dn", B738CMD_apu_gen2_dn_CMDhandler)

B738CMD_gen1_up			= create_command("laminar/B738/toggle_switch/gen1_up", "Generator1 up", B738CMD_gen1_up_CMDhandler)
B738CMD_gen1_dn			= create_command("laminar/B738/toggle_switch/gen1_dn", "Generator1 dn", B738CMD_gen1_dn_CMDhandler)
B738CMD_gen2_up			= create_command("laminar/B738/toggle_switch/gen2_up", "Generator2 up", B738CMD_gen2_up_CMDhandler)
B738CMD_gen2_dn			= create_command("laminar/B738/toggle_switch/gen2_dn", "Generator2 dn", B738CMD_gen2_dn_CMDhandler)

B738CMD_gpu_up			= create_command("laminar/B738/toggle_switch/gpu_up", "GPU up", B738CMD_gpu_up_CMDhandler)
B738CMD_gpu_dn			= create_command("laminar/B738/toggle_switch/gpu_dn", "GPU dn", B738CMD_gpu_dn_CMDhandler)

B738CMD_autobrake_up	= create_command("laminar/B738/knob/autobrake_up", "AUTOBRAKE up", B738CMD_autobrake_up_CMDhandler)
B738CMD_autobrake_dn	= create_command("laminar/B738/knob/autobrake_dn", "AUTOBRAKE down", B738CMD_autobrake_dn_CMDhandler)

B738CMD_l_recirc_fan		= create_command("laminar/B738/toggle_switch/l_recirc_fan", "Left RECIRC on/off", B738CMD_l_recirc_fan_CMDhandler)
B738CMD_r_recirc_fan		= create_command("laminar/B738/toggle_switch/r_recirc_fan", "Right RECIRC on/off", B738CMD_r_recirc_fan_CMDhandler)
B738CMD_trim_air			= create_command("laminar/B738/toggle_switch/trim_air", "Trim Air on/off", B738CMD_trim_air_CMDhandler)

B738CMD_gear_down			= create_command("laminar/B738/push_button/gear_down", "Landing gear down", B738CMD_gear_down_CMDhandler)
B738CMD_gear_up				= create_command("laminar/B738/push_button/gear_up", "Landing gear up", B738CMD_gear_up_CMDhandler)
B738CMD_gear_off			= create_command("laminar/B738/push_button/gear_off", "Landing gear off", B738CMD_gear_off_CMDhandler)
B738CMD_gear_down_one		= create_command("laminar/B738/push_button/gear_down_one", "Landing gear down one", B738CMD_gear_down_one_CMDhandler)
B738CMD_gear_up_one			= create_command("laminar/B738/push_button/gear_up_one", "Landing gear up one", B738CMD_gear_up_one_CMDhandler)


-- FUEL FLOW SWITCH
B738CMD_fuel_flow_up = create_command("laminar/B738/toggle_switch/fuel_flow_up", "Fuel Flow Switch Up", B738_fuel_flow_up_CMDhandler)
B738CMD_fuel_flow_dn = create_command("laminar/B738/toggle_switch/fuel_flow_dn", "Fuel Flow Switch Down", B738_fuel_flow_dn_CMDhandler)


B738CMD_eng_start_lft = create_command("laminar/B738/toggle_switch/eng_start_source_left", "Engine starter left", B738_eng_start_lft_CMDhandler)
B738CMD_eng_start_rgt = create_command("laminar/B738/toggle_switch/eng_start_source_right", "Engine starter right", B738_eng_start_rgt_CMDhandler)
B738CMD_air_valve_lft = create_command("laminar/B738/toggle_switch/air_valve_manual_left", "Air valve manual left", B738_air_valve_lft_CMDhandler)
B738CMD_air_valve_rgt = create_command("laminar/B738/toggle_switch/air_valve_manual_right", "Air valve manual right", B738_air_valve_rgt_CMDhandler)
B738CMD_eq_cool_exhaust = create_command("laminar/B738/toggle_switch/eq_cool_exhaust", "Equipment cooling exhaust", B738_eq_cool_exhaust_CMDhandler)
B738CMD_eq_cool_supply = create_command("laminar/B738/toggle_switch/eq_cool_supply", "Equipment cooling supply", B738_eq_cool_supply_CMDhandler)
B738CMD_dspl_ctrl_pnl_lft = create_command("laminar/B738/toggle_switch/dspl_ctrl_pnl_left", "Display control panel left", B738_dspl_ctrl_pnl_lft_CMDhandler)
B738CMD_dspl_ctrl_pnl_rgt = create_command("laminar/B738/toggle_switch/dspl_ctrl_pnl_right", "Display control panel right", B738_dspl_ctrl_pnl_rgt_CMDhandler)
B738CMD_fmc_source_left = create_command("laminar/B738/toggle_switch/fmc_source_left", "FMC source left", B738_fmc_source_left_CMDhandler)
B738CMD_fmc_source_right = create_command("laminar/B738/toggle_switch/fmc_source_right", "FMC source right", B738_fmc_source_right_CMDhandler)
B738CMD_ovht_test_up = create_command("laminar/B738/toggle_switch/window_ovht_test_up", "Windows overheat test left", B738_ovht_test_up_CMDhandler)
B738CMD_ovht_test_dn = create_command("laminar/B738/toggle_switch/window_ovht_test_dn", "Windows overheat test right", B738_ovht_test_dn_CMDhandler)
B738CMD_service_interphone = create_command("laminar/B738/toggle_switch/service_interphone", "Service interphone", B738_service_interphone_CMDhandler)
B738CMD_alt_flaps_ctrl_up = create_command("laminar/B738/toggle_switch/alt_flaps_ctrl_up", "Alternate flaps ctrl up", B738_alt_flaps_ctrl_up_CMDhandler)
B738CMD_alt_flaps_ctrl_dn = create_command("laminar/B738/toggle_switch/alt_flaps_ctrl_dn", "Alternate flaps ctrl down", B738_alt_flaps_ctrl_dn_CMDhandler)
B738CMD_air_valve_ctrl_lft = create_command("laminar/B738/toggle_switch/air_valve_ctrl_left", "Air valve control left", B738_air_valve_ctrl_lft_CMDhandler)
B738CMD_air_valve_ctrl_rgt = create_command("laminar/B738/toggle_switch/air_valve_ctrl_right", "Air valve control right", B738_air_valve_ctrl_rgt_CMDhandler)
B738CMD_air_temp_ctrl_lft = create_command("laminar/B738/toggle_switch/air_temp_source_left", "Air temp control left", B738_air_temp_ctrl_lft_CMDhandler)
B738CMD_air_temp_ctrl_rgt = create_command("laminar/B738/toggle_switch/air_temp_source_right", "Air temp control right", B738_air_temp_ctrl_rgt_CMDhandler)
B738CMD_flt_dk_door_left = create_command("laminar/B738/toggle_switch/flt_dk_door_left", "Flight deck door left", B738_flt_dk_door_left_CMDhandler)
B738CMD_flt_dk_door_right = create_command("laminar/B738/toggle_switch/flt_dk_door_right", "Flight deck door right", B738_flt_dk_door_right_CMDhandler)
B738CMD_main_pnl_du_fo_lft = create_command("laminar/B738/toggle_switch/main_pnl_du_fo_left", "Main panel DU FO left", B738_main_pnl_du_fo_lft_CMDhandler)
B738CMD_main_pnl_du_fo_rgt = create_command("laminar/B738/toggle_switch/main_pnl_du_fo_right", "Main panel DU FO right", B738_main_pnl_du_fo_rgt_CMDhandler)
B738CMD_lower_du_fo_lft = create_command("laminar/B738/toggle_switch/lower_du_fo_left", "Lower DU FO left", B738_lower_du_fo_lft_CMDhandler)
B738CMD_lower_du_fo_rgt = create_command("laminar/B738/toggle_switch/lower_du_fo_right", "Lower DU FO right", B738_lower_du_fo_rgt_CMDhandler)
B738CMD_main_pnl_du_cpt_lft = create_command("laminar/B738/toggle_switch/main_pnl_du_capt_left", "Main panel DU CPT left", B738_main_pnl_du_cpt_lft_CMDhandler)
B738CMD_main_pnl_du_cpt_rgt = create_command("laminar/B738/toggle_switch/main_pnl_du_capt_right", "Main panel DU CPT right", B738_main_pnl_du_cpt_rgt_CMDhandler)
B738CMD_lower_du_cpt_lft = create_command("laminar/B738/toggle_switch/lower_du_capt_left", "Lower DU CPT left", B738_lower_du_cpt_lft_CMDhandler)
B738CMD_lower_du_cpt_rgt = create_command("laminar/B738/toggle_switch/lower_du_capt_right", "Lower DU CPT right", B738_lower_du_cpt_rgt_CMDhandler)
B738CMD_dspl_source_left = create_command("laminar/B738/toggle_switch/dspl_source_left", "Display source left", B738_dspl_source_left_CMDhandler)
B738CMD_dspl_source_right = create_command("laminar/B738/toggle_switch/dspl_source_right", "Display source right", B738_dspl_source_right_CMDhandler)
B738CMD_spd_ref_left = create_command("laminar/B738/toggle_switch/spd_ref_left", "SPD set select left", B738_spd_ref_left_CMDhandler)
B738CMD_spd_ref_right = create_command("laminar/B738/toggle_switch/spd_ref_right", "SPD set select right", B738_spd_ref_right_CMDhandler)
B738CMD_spd_ref_adj_left = create_command("laminar/B738/toggle_switch/spd_ref_adjust_left", "SPD set adjust left", B738_spd_ref_adj_left_CMDhandler)
B738CMD_spd_ref_adj_right = create_command("laminar/B738/toggle_switch/spd_ref_adjust_right", "SPD set adjust right", B738_spd_ref_adj_right_CMDhandler)
-- B738CMD_fo_minimums_up = create_command("laminar/B738/EFIS_control/fo/minimums_up", "FO Minimums select up", B738_fo_minimums_up_CMDhandler)
-- B738CMD_fo_minimums_dn = create_command("laminar/B738/EFIS_control/fo/minimums_dn", "FO Minimums select down", B738_fo_minimums_dn_CMDhandler)
-- B738CMD_cpt_minimums_up = create_command("laminar/B738/EFIS_control/cpt/minimums_up", "CAPT Minimums select up", B738_cpt_minimums_up_CMDhandler)
-- B738CMD_cpt_minimums_dn = create_command("laminar/B738/EFIS_control/cpt/minimums_dn", "CAPT Minimums select down", B738_cpt_minimums_dn_CMDhandler)

B738CMD_yaw_dumper = create_command("laminar/B738/toggle_switch/yaw_dumper", "Yaw dumper toggle", B738_yaw_dumper_CMDhandler)

B738CMD_alt_horn_cutout 	= create_command("laminar/B738/alert/alt_horn_cutout", "Alt Horn Cutout", B738_alt_horn_cutout_CMDhandler)
B738CMD_below_gs_pilot 		= create_command("laminar/B738/alert/below_gs_pilot", "Below G/S_pilot", B738_below_gs_disable_pilot_CMDhandler)
B738CMD_below_gs_copilot 	= create_command("laminar/B738/alert/below_gs_copilot", "Below G/S_copilot", B738_below_gs_disable_copilot_CMDhandler)
B738CMD_gear_horn_cutout 	= create_command("laminar/B738/alert/gear_horn_cutout", "Gear Horn Cutout", B738_gear_horn_cutout_CMDhandler)

B738CMD_fdr_cover		= create_command("laminar/B738/toggle_switch/fdr_cover", "Cover FDR", B738_fdr_cover_CMDhandler)
B738CMD_fdr				= create_command("laminar/B738/toggle_switch/fdr", "FDR", B738_fdr_CMDhandler)

B738CMD_gear_lock_override 		= create_command("laminar/B738/gear_lock/override", "Gear Lock Override", B738_gear_lock_override_CMDhandler)

--*************************************************************************************--
--** 				             X-PLANE COMMAND HANDLERS               	    	 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				             REPLACE X-PLANE COMMANDS                  	    	 **--
--*************************************************************************************--

B738CMD_def_gear_toggle		= replace_command("sim/flight_controls/landing_gear_toggle", B738_gear_toggle_CMDhandler)
B738CMD_def_gear_down		= replace_command("sim/flight_controls/landing_gear_down", B738_def_gear_down_CMDhandler)
B738CMD_def_gear_up			= replace_command("sim/flight_controls/landing_gear_up", B738_def_gear_up_CMDhandler)

B738CMD_park_brake_toggle		= replace_command("sim/flight_controls/brakes_toggle_max", B738_park_brake_toggle_CMDhandler)
B738CMD_park_brake_reg_toggle	= replace_command("sim/flight_controls/brakes_toggle_regular", B738_park_brake_reg_toggle_CMDhandler)
B738CMD_park_brake				= replace_command("sim/flight_controls/brakes_max", B738_park_brake_CMDhandler)
B738CMD_park_brake_reg			= replace_command("sim/flight_controls/brakes_regular", B738_park_brake_reg_CMDhandler)

--*************************************************************************************--
--** 				              WRAP X-PLANE COMMANDS                  	    	 **--
--*************************************************************************************--

B738CMD_flaps_up				= wrap_command("sim/flight_controls/flaps_up", empty_cmd, flap_sound)
B738CMD_flaps_dn				= wrap_command("sim/flight_controls/flaps_down", empty_cmd, flap_sound)


--*************************************************************************************--
--** 					           OBJECT CONSTRUCTORS         		        		 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				                  CREATE OBJECTS              	     			 **--
--*************************************************************************************--




--**********************************************************************************
--                             J O Y    A X I S 
--**********************************************************************************

axis_n = 0
simDR_axis = {}
for axis_n = 0, 249 do
	simDR_axis[axis_n] = find_dataref("sim/joystick/joystick_axis_values[" .. tostring(axis_n) .. "]")
end


B738DR_joy_axis_heading 		= create_dataref("laminar/B738/axis/heading", "number")
B738DR_joy_axis_pitch 			= create_dataref("laminar/B738/axis/pitch", "number")
B738DR_joy_axis_roll 			= create_dataref("laminar/B738/axis/roll", "number")
B738DR_joy_axis_throttle		= create_dataref("laminar/B738/axis/throttle", "number")
B738DR_joy_axis_throttle1		= create_dataref("laminar/B738/axis/throttle1", "number")
B738DR_joy_axis_throttle2		= create_dataref("laminar/B738/axis/throttle2", "number")
B738DR_joy_axis_left_toe_brake	= create_dataref("laminar/B738/axis/left_toe_brake", "number")
B738DR_joy_axis_right_toe_brake	= create_dataref("laminar/B738/axis/right_toe_brake", "number")
B738DR_joy_axis_nosewheel		= create_dataref("laminar/B738/axis/nosewheel", "number")

simDR_yoke_heading_ratio = 0
simDR_yoke_pitch_ratio = 0
simDR_yoke_roll_ratio = 0

joy_axis_pitch = -1
joy_axis_roll = -1
joy_axis_heading = -1
joy_axis_throttle = -1
joy_axis_throttle1 = -1
joy_axis_throttle2 = -1
joy_axis_left_toe_brake = -1
joy_axis_right_toe_brake = -1
joy_axis_nosewheel = -1

	file_name = "Output/preferences/X-Plane Joystick Settings.prf"
	file_joy = io.open(file_name, "r")
	if file_joy ~= nil then
		joy_line = file_joy:read()
		while joy_line do
			if string.sub(joy_line, 1, 13) == "_joy_AXIS_use" then
				joy_1, joy_2 = string.find(joy_line, " ")
				if joy_1 ~= nil then
					joy_3 = joy_1 + 1
					joy_4 = string.len(joy_line)
					joy_5 = joy_1 - 1
					if joy_3 <= joy_4 then
						joy_num = tonumber(string.sub(joy_line, joy_3, -1))
						joy_axis = tonumber(string.sub(joy_line, 14, joy_5))
						if joy_num == 1 then
							joy_axis_pitch = joy_axis
						elseif joy_num == 2 then
							joy_axis_roll = joy_axis
						elseif joy_num == 3 then
							joy_axis_heading = joy_axis
						elseif joy_num == 4 then
							joy_axis_throttle = joy_axis
						elseif joy_num == 20 then
							joy_axis_throttle1 = joy_axis
						elseif joy_num == 21 then
							joy_axis_throttle2 = joy_axis
						elseif joy_num == 6 then
							joy_axis_left_toe_brake = joy_axis
						elseif joy_num == 7 then
							joy_axis_right_toe_brake = joy_axis
						elseif joy_num == 37 then
							joy_axis_nosewheel = joy_axis
						end
					end
				end
			end
			joy_line = file_joy:read()
		end
		file_joy:close()
	end


--*************************************************************************************--
--** 				                 SYSTEM FUNCTIONS           	    			 **--
--*************************************************************************************--



----- RESCALE FLOAT AND CLAMP TO OUTER LIMITS -------------------------------------------

function B738_rescale(in1, out1, in2, out2, x)
    if x < in1 then return out1 end
    if x > in2 then return out2 end
    return out1 + (out2 - out1) * (x - in1) / (in2 - in1)
end

----- ANIMATION UTILITY -----------------------------------------------------------------

function B738_set_anim_value(current_value, target, min, max, speed)

    if target >= (max - 0.001) and current_value >= (max - 0.01) then
        return max
    elseif target <= (min + 0.001) and current_value <= (min + 0.01) then
        return min
    else
        return current_value + ((target - current_value) * (speed * SIM_PERIOD))
    end

end


function B738_set_anim_time(current_value2, target2, min2, max2, up_down2, speed2)

	local range = math.abs(min2-max2)
	if up_down2 == 0 then
		if target2 < current_value2 then
			current_value2 = current_value2 - ((SIM_PERIOD / speed2) * range)
			if current_value2 < target2 then
				current_value2 = target2
			end
		end
		if current_value2 < min2 then
			current_value2 = min2
		end
	else
		if target2 > current_value2 then
			current_value2 = current_value2 + ((SIM_PERIOD / speed2) * range)
			if current_value2 > target2 then
				current_value2 = target2
			end
		end
		if current_value2 > max2 then
			current_value2 = max2
		end
	end
	return current_value2

end

function B738_set_animation_rate(current_value3, target3, min, max, speed)
	local calc_result = 0
	local calc_speed = speed
	if calc_speed <= 0 then
		calc_speed = 1
	end
	if target3 >= (max - 0.001) and current_value3 >= (max - 0.01) then
        return max
    elseif target3 <= (min + 0.001) and current_value3 <= (min + 0.01) then
        return min
    elseif current_value3 > max then
		return max
    elseif current_value3 < min then
		return min
	elseif current_value3 < target3 then
		calc_result = current_value3 + (SIM_PERIOD / calc_speed)
		if calc_result > target3 then
			calc_result = target3
		end
		return calc_result
	else
		calc_result = current_value3 - (SIM_PERIOD / calc_speed)
		if calc_result < target3 then
			calc_result = target3
		end
        return calc_result
    end
end


function roundUpToIncrement(number, increment)

    local y = number / increment
    local q = math.ceil(y)
    local z = q * increment

    return z

end

function roundDownToIncrement(number, increment)

    local y = number / increment
    local q = math.floor(y)
    local z = q * increment

    return z

end


function B738_prop_mode_sync()

	if simDR_prop_mode0 == 1
	and simDR_prop_mode1 == 1 then
		B738DR_prop_mode_sync = 0
	elseif simDR_prop_mode0 == 3
	and simDR_prop_mode1 == 3 then
		B738DR_prop_mode_sync = 1
	elseif simDR_prop_mode0 ~= simDR_prop_mode1 then
		B738DR_prop_mode_sync = 2
	end
			
--[[

0 - both forward
1 - both reverse
2 - disagree

]]--
		
end


----- CROSSFEED KNOB POSITION ANIMATION --------------------------------------------

function B738_crossfeed_knob_animation()

	B738DR_cross_feed_selector_knob = B738_set_anim_value(B738DR_cross_feed_selector_knob, B738_cross_feed_selector_knob_target, 0.0, 1.0, 5.0)

	if B738_cross_feed_selector_knob_target == 0 then
		B738DR_cross_feed_valve = B738_set_anim_time(B738DR_cross_feed_valve, B738_cross_feed_selector_knob_target, 0.0, 1.0, 0, 4.0)
	else
		B738DR_cross_feed_valve = B738_set_anim_time(B738DR_cross_feed_valve, B738_cross_feed_selector_knob_target, 0.0, 1.0, 1, 4.0)
	end

end

-- FUEL TANK SELECTION

function B738_fuel_tank_selection()

	-- local tank_r_status = simDR_tank_r_status
	-- local tank_c_status = simDR_tank_c_status
	-- local tank_l_status = simDR_tank_l_status

	local tank_r_status = B738_tank_r_status
	local tank_c_status = B738_tank_c_status
	local tank_l_status = B738_tank_l_status


	--simDR_fuel_selector_l		0=off, 1=left, 2=center, 3=right, 4=all
	--simDR_fuel_selector_r		0=off, 1=left, 2=center, 3=right, 4=all	
	--simDR_center_tank_level	

	local fuel_selector_l = 0
	local fuel_selector_r = 0

	if tank_l_status == 0			----- CASE 1 (0 0 0 | 0 0)
		and tank_c_status == 0
		and tank_r_status == 0 then
		fuel_selector_l = 0
		fuel_selector_r = 0
		elseif B738DR_cross_feed_selector_knob == 1 then  -- CROSSFEED
		fuel_selector_l = 4
		fuel_selector_r = 4
	end	

	if tank_l_status == 1			----- CASE 2 (1 0 0 | 1 0)
		and tank_c_status == 0
		and tank_r_status == 0 then
		fuel_selector_l = 1
		fuel_selector_r = 0
		elseif B738DR_cross_feed_selector_knob == 1 then  -- CROSSFEED
		fuel_selector_l = 4
		fuel_selector_r = 4
	end	

	if tank_l_status == 0			----- CASE 3 (0 1 0 | 2 2)
		and tank_c_status == 1
		and tank_r_status == 0 then
		fuel_selector_l = 2
		fuel_selector_r = 2
		elseif B738DR_cross_feed_selector_knob == 1 then  -- CROSSFEED
		fuel_selector_l = 4
		fuel_selector_r = 4
	end	

	if tank_l_status == 0			----- CASE 4 (0 0 1 | 0 3)
		and tank_c_status == 0
		and tank_r_status == 1 then
		fuel_selector_l = 0
		fuel_selector_r = 3
		elseif B738DR_cross_feed_selector_knob == 1 then  -- CROSSFEED
		fuel_selector_l = 4
		fuel_selector_r = 4
	end	

	if tank_l_status == 1			----- CASE 5 (1 0 1 | 1 3)
		and tank_c_status == 0
		and tank_r_status == 1 then
		fuel_selector_l = 1
		fuel_selector_r = 3
		elseif B738DR_cross_feed_selector_knob == 1 then  -- CROSSFEED
		fuel_selector_l = 4
		fuel_selector_r = 4
	end	

---------------------

	if tank_l_status == 1			----- CASE 6a (1 1 0 | 2 2) -- CENTER HAS FUEL
		and tank_c_status == 1
		and tank_r_status == 0
		and simDR_center_tank_level > 10 then
		fuel_selector_l = 2
		fuel_selector_r = 2
		elseif B738DR_cross_feed_selector_knob == 1 then  -- CROSSFEED
		fuel_selector_l = 4
		fuel_selector_r = 4
	end
	
		if tank_l_status == 1			----- CASE 6b (1 1 0 | 1 0)  -- EMPTY CENTER
		and tank_c_status == 1
		and tank_r_status == 0
		and simDR_center_tank_level < 10 then
		fuel_selector_l = 1
		fuel_selector_r = 0
		elseif B738DR_cross_feed_selector_knob == 1 then  -- CROSSFEED
		fuel_selector_l = 4
		fuel_selector_r = 4
	end	

---------------------
	
	if tank_l_status == 0			----- CASE 7a (0 1 1 | 2 2) -- CENTER HAS FUEL
		and tank_c_status == 1
		and tank_r_status == 1
		and simDR_center_tank_level > 10 then
		fuel_selector_l = 2
		fuel_selector_r = 2
		elseif B738DR_cross_feed_selector_knob == 1 then  -- CROSSFEED
		fuel_selector_l = 4
		fuel_selector_r = 4
	end	

	if tank_l_status == 0			----- CASE 7b (0 1 1 | 0 3) -- EMPTY CENTER
		and tank_c_status == 1
		and tank_r_status == 1
		and simDR_center_tank_level < 10 then
		fuel_selector_l = 0
		fuel_selector_r = 3
		elseif B738DR_cross_feed_selector_knob == 1 then  -- CROSSFEED
		fuel_selector_l = 4
		fuel_selector_r = 4
	end	

---------------------

	if tank_l_status == 1			----- CASE 8a (1 1 1 | 2 2) -- CENTER HAS FUEL
		and tank_c_status == 1
		and tank_r_status == 1
		and simDR_center_tank_level > 10 then
		fuel_selector_l = 2
		fuel_selector_r = 2
		elseif B738DR_cross_feed_selector_knob == 1 then  -- CROSSFEED
		fuel_selector_l = 4
		fuel_selector_r = 4
	end

	if tank_l_status == 1			----- CASE 8b (1 1 1 | 1 3) -- EMPTY CENTER
		and tank_c_status == 1
		and tank_r_status == 1
		and simDR_center_tank_level < 10 then
		fuel_selector_l = 1
		fuel_selector_r = 3
		elseif B738DR_cross_feed_selector_knob == 1 then  -- CROSSFEED
		fuel_selector_l = 4
		fuel_selector_r = 4
	end

	if B738DR_engine01_fire_ext_switch_pos_arm == 1 then
		fuel_selector_l = 0
	end
	if B738DR_engine02_fire_ext_switch_pos_arm == 1 then
		fuel_selector_r = 0
	end
	
	simDR_fuel_selector_l = fuel_selector_l
	simDR_fuel_selector_r = fuel_selector_r
	
	simDR_tank_r_status = B738_tank_r_status
	simDR_tank_c_status = B738_tank_c_status
	simDR_tank_l_status = B738_tank_l_status


	
end		
	


-- BLEED AIR MODE

function B738_bleed_air_state()

	local eng1_bleed = B738DR_bleed_air_1_switch_position
	local apu_bleed = B738DR_bleed_air_apu_switch_position
	local eng2_bleed = B738DR_bleed_air_2_switch_position
	local l_pack = B738DR_l_pack_pos
	local r_pack = B738DR_r_pack_pos
	local iso_valve = B738DR_isolation_valve_pos

-- simDR_bleed_air_mode    0=off, 1=left, 2=both, 3=right, 4=apu, 5=auto	

	if eng1_bleed == 0				-- CASE 1 (0 0 0 | 0)
		and apu_bleed == 0
		and eng2_bleed == 0 then
--		simDR_bleed_air_mode = 0
		pack_mode = 0
		dual_bleed = 0
	end
	
	if eng1_bleed == 1				-- CASE 2 (1 0 0 | 1)
		and apu_bleed == 0
		and eng2_bleed == 0 then
--		simDR_bleed_air_mode = 1
		pack_mode = 1
		dual_bleed = 0
	end
		
	if eng1_bleed == 0				-- CASE 3 (0 1 0 | 4)
		and apu_bleed == 1
		and eng2_bleed == 0 then
--		simDR_bleed_air_mode = 4
		pack_mode = 4
		dual_bleed = 0
	end

	if eng1_bleed == 0				-- CASE 4 (0 0 1 | 3)
		and apu_bleed == 0
		and eng2_bleed == 1 then
--		simDR_bleed_air_mode = 3
		pack_mode = 3
		dual_bleed = 0
	end

	if eng1_bleed == 1				-- CASE 5 (1 1 0 | 5)
		and apu_bleed == 1
		and eng2_bleed == 0 then
--		simDR_bleed_air_mode = 5
		pack_mode = 5
		dual_bleed = 1
	end

	if eng1_bleed == 0				-- CASE 6 (0 1 1 | 5)
		and apu_bleed == 1
		and eng2_bleed == 1 then
		pack_mode = 5
--		simDR_bleed_air_mode = 5
		if B738bleedAir.isolation.bleed_air_valve.pos > 0.1 then
			dual_bleed = 1
		else
			dual_bleed = 0
		end
	end
	
	if eng1_bleed == 1				-- CASE 7 (1 0 1 | 2)
		and apu_bleed == 0
		and eng2_bleed == 1 then
--		simDR_bleed_air_mode = 2
		pack_mode = 2
		dual_bleed = 0
	end
	
	if eng1_bleed == 1				-- CASE 8 (1 1 1 | 5)
		and apu_bleed == 1
		and eng2_bleed == 1 then
--		simDR_bleed_air_mode = 5
		pack_mode = 5
		dual_bleed = 1
	end

	-- if l_pack == 0 and r_pack == 0 then		-- L PACK: OFF, R PACK: OFF
		-- pack_mode = 0
	-- end

	apu_start_eng1 = 1
	if l_pack > 0.95 then		-- L PACK: AUTO or HIGH
		apu_start_eng1 = 0
	end

	if l_pack == 0 and B738bleedAir.isolation.bleed_air_valve.pos > 0.95 and r_pack > 0.95 then	-- L PACK: OFF, ISO valve: OPEN, R PACK: AUTO or HIGH
		apu_start_eng1 = 0
	end
	
	apu_start_eng2 = 0
	if l_pack == 0 and B738bleedAir.isolation.bleed_air_valve.pos > 0.95 and r_pack == 0 then		-- L PACK: OFF, ISO valve: OPEN, R PACK: OFF
		apu_start_eng2 = 1
	end
	if apu_bleed == 0 or simDR_apu_status < 90 then		-- APU bleed: OFF  or  APU not running
		apu_start_eng1 = 0
		apu_start_eng2 = 0
	end

	eng1_start_eng2 = 0
	eng2_start_eng1 = 0
	if l_pack == 0 and B738bleedAir.isolation.bleed_air_valve.pos > 0.95 and r_pack == 0 then		-- L PACK: OFF, ISO valve: OPEN, R PACK: OFF
		if eng1_bleed == 1 then
			eng1_start_eng2 = 1
		end
		if eng2_bleed == 1 then
			eng2_start_eng1 = 1
		end
	end
	
	
	------------------------------------------------------------------
	-- if eng1_starting == 1 then		-- running start engine 1
		-- if apu_start_eng1 == 0 then
			-- if eng2_start_eng1 == 1 then
				-- pack_mode = 2	-- bleed air eng 2
			-- else
				-- pack_mode = 0	-- bleed air off
			-- end
		-- else
			-- pack_mode = 4	-- bleed air apu
		-- end
	-- end

	-- if eng2_starting == 1 then		-- running start engine 2
		-- if apu_start_eng2 == 0 then
			-- if eng1_start_eng2 == 1 then
				-- pack_mode = 1	-- bleed air eng 1
			-- else
				-- pack_mode = 0	-- bleed air off
			-- end
		-- else
			-- pack_mode = 4	-- bleed air apu
		-- end
	-- end
	----------------------------------------------------------------------
	
	simDR_bleed_air_mode = pack_mode


-- DUAL BLEED ANNUN

	local bus1Power = B738_rescale(0.0, 0.0, 28.0, 1.0, simDR_electrical_bus_volts0)
	local bus2Power = B738_rescale(0.0, 0.0, 28.0, 1.0, simDR_electrical_bus_volts1)
	local busPower  = math.max(bus1Power, bus2Power)
	local brightness_level = simDR_generic_brightness_ratio63 * busPower
	
	B738DR_dual_bleed_annun = dual_bleed * brightness_level


	if B738DR_lights_test == 1 then
		B738DR_dual_bleed_annun = 1 * brightness_level
	end

end


----- BLEED AIR SUPPLY ------------------------------------------------------------------
local int, frac = math.modf(os.clock())
local seed = math.random(1, frac*1000.0)
math.randomseed(seed)
--local rndm_max_apu_bleed_psi    = math.random(40, 50) + math.random()	-- add 5 psi
local rndm_max_apu_bleed_psi    = math.random(34, 36) + math.random()	-- add 5 psi
local rndm_max_eng1_bleed_psi   = math.random(56, 64) + math.random()	-- add 5 psi
local rndm_max_eng2_bleed_psi   = math.random(55, 62) + math.random()	-- add 5 psi

local freq_ac_mode0				= math.random(395, 405) + math.random()
local freq_ac_mode1				= math.random(395, 405) + math.random()
local freq_ac_mode2				= math.random(395, 405) + math.random()
local freq_ac_mode3				= math.random(395, 405) + math.random()
local freq_ac_mode4				= math.random(395, 405) + math.random()
local freq_ac_mode5				= math.random(395, 405) + math.random()

local volts_ac_mode1			= math.random(112, 118) + math.random()
local volts_ac_mode2			= math.random(112, 118) + math.random()
local volts_ac_mode3			= math.random(112, 118) + math.random()
local volts_ac_mode4			= math.random(112, 118) + math.random()
local volts_ac_mode5			= math.random(112, 118) + math.random()

-- ACDC

function B738_ac_dc_power()

	local gpu_available = 0
	if simDR_aircraft_on_ground == 1 
	and simDR_aircraft_groundspeed < 0.05 
	and simDR_brake == 1 then
		gpu_available = 1
	end
	if B738DR_chock_status == 1 then
		gpu_available = 1
	end
	B738DR_gpu_available = gpu_available
	
	
	if simDR_stby_power_volts == 0 then
		B738DR_ac_freq_mode0 = 0
	elseif simDR_stby_power_volts > 0 then
		B738DR_ac_freq_mode0 = freq_ac_mode0
	end
	
	
	-- if simDR_gpu_amps == 0 then
		-- B738DR_ac_freq_mode1 = 0
		-- B738DR_ac_volt_mode1 = 0
	-- elseif simDR_gpu_amps > 0 then
		-- B738DR_ac_freq_mode1 = freq_ac_mode1
		-- B738DR_ac_volt_mode1 = volts_ac_mode1
	-- end
	
	-- if simDR_gen1_amps == 0 then
		-- B738DR_ac_freq_mode2 = 0
		-- B738DR_ac_volt_mode2 = 0
	-- elseif simDR_gen1_amps > 0 then
		-- B738DR_ac_freq_mode2 = freq_ac_mode2
		-- B738DR_ac_volt_mode2 = volts_ac_mode2
	-- end

	-- if simDR_apu_gen_amps == 0 then
		-- B738DR_ac_freq_mode3 = 0
		-- B738DR_ac_volt_mode3 = 0
	-- elseif simDR_apu_gen_amps > 0 then
		-- B738DR_ac_freq_mode3 = freq_ac_mode3
		-- B738DR_ac_volt_mode3 = volts_ac_mode3
	-- end
	
	-- if simDR_gen2_amps == 0 then
		-- B738DR_ac_freq_mode4 = 0
		-- B738DR_ac_volt_mode4 = 0
	-- elseif simDR_gen2_amps > 0 then
		-- B738DR_ac_freq_mode4 = freq_ac_mode4
		-- B738DR_ac_volt_mode4 = volts_ac_mode4
	-- end
	
	if gpu_available == 0 then
		B738DR_ac_freq_mode1 = 0
		B738DR_ac_volt_mode1 = 0
	else
		B738DR_ac_freq_mode1 = freq_ac_mode1
		B738DR_ac_volt_mode1 = volts_ac_mode1
	end
	
	if B738DR_gen1_available == 0 then
		B738DR_ac_freq_mode2 = 0
		B738DR_ac_volt_mode2 = 0
	else
		B738DR_ac_freq_mode2 = freq_ac_mode2
		B738DR_ac_volt_mode2 = volts_ac_mode2
	end
	
	if B738DR_apu_bus_enable == 0 then
		B738DR_ac_freq_mode3 = 0
		B738DR_ac_volt_mode3 = 0
	else
		B738DR_ac_freq_mode3 = freq_ac_mode3
		B738DR_ac_volt_mode3 = volts_ac_mode3
	end
	
	if B738DR_gen2_available == 0 then
		B738DR_ac_freq_mode4 = 0
		B738DR_ac_volt_mode4 = 0
	else
		B738DR_ac_freq_mode4 = freq_ac_mode4
		B738DR_ac_volt_mode4 = volts_ac_mode4
	end
	
	if simDR_inverter_on == 0 then
		B738DR_ac_freq_mode5 = 0
		B738DR_ac_volt_mode5 = 0
	elseif simDR_inverter_on == 1 then
		B738DR_ac_freq_mode5 = freq_ac_mode5
		B738DR_ac_volt_mode5 = volts_ac_mode5
	end
	
end


function B738_rpm(rpm, idle, new_idle)

	local k = 105 - idle
	local new_k = 105 - new_idle
	
	if rpm <= idle then
		return rpm / idle * new_idle
	else
		return ((rpm - idle) / k * new_k) + new_idle 
	end

end


-- BLEED AIR CON'T

function B738_bleed_air_supply()

    -- APU
	B738bleedAir.apu.psi = B738_rescale(0, 0, 100.0, rndm_max_apu_bleed_psi, simDR_apu_N1_pct)

    local rescale  = 0
    -- ENGINE 1
--	rescale = B738_rpm(simDR_engine_N1_pct1, 21.4, 31.5)
--	B738bleedAir.engine1.psi = B738_rescale(0, 0, 100.0, rndm_max_eng1_bleed_psi, rescale)
	-- rescale = B738DR_eng1_N1 + 10
	-- B738bleedAir.engine1.psi = B738_rescale(0, 0, 100.0, rndm_max_eng1_bleed_psi, rescale)
	rescale = B738DR_eng1_N1
	if rescale < 20 then
		B738bleedAir.engine1.psi = B738_rescale(0, 0, 19.0, 28.0, rescale)
	else
		B738bleedAir.engine1.psi = B738_rescale(19.0, 28.0, 105.0, rndm_max_eng1_bleed_psi, rescale)
	end

    -- ENGINE 2
--	rescale = B738_rpm(simDR_engine_N1_pct2, 21.4, 31.5)
 --   B738bleedAir.engine2.psi = B738_rescale(0, 0, 100.0, rndm_max_eng2_bleed_psi, rescale)
	-- rescale = B738DR_eng2_N1 + 10
    -- B738bleedAir.engine2.psi = B738_rescale(0, 0, 100.0, rndm_max_eng2_bleed_psi, rescale)
	rescale = B738DR_eng2_N1
	if rescale < 20 then
		B738bleedAir.engine2.psi = B738_rescale(0, 0, 19.0, 28.0, rescale)
	else
		B738bleedAir.engine2.psi = B738_rescale(19.0, 28.0, 105.0, rndm_max_eng2_bleed_psi, rescale)
	end

end


----- BLEED VALVES -------
function B738_bleed_air_valves()

    -- POWER REQUIRED - ELECTRIC VALVES ARE NORMALLY CLOSED WHEN THERE IS NO POWER


    ----- APU VALVE ---------------------------------------------------------------------
    B738bleedAir.apu.bleed_air_valve.target_pos = 0.0							-- NORMALLY CLOSED
    if B738DR_bleed_air_apu_switch_position > 0.95
        and B738bleedAir.apu.psi > bleed_valve_min_act_press					-- BLEED AIR REQUIRED TO OPEN THE VALVE
    then
        B738bleedAir.apu.bleed_air_valve.target_pos = 1.0						-- OPERATED BY BLEED AIR PRESSURE (NO ELECTRIC REQUIREMENT)
    end

	if simDR_apu_bleed_fail == 1 or B738DR_apu_fire_ext_switch_pos_arm == 1 then	-- APU damaged or fail
		B738bleedAir.apu.bleed_air_valve.target_pos = 0
	end


    ----- ENGINE #1 BLEED AIR VALVE -----------------------------------------------------
    B738bleedAir.engine1.bleed_air_valve.target_pos = 0.0						-- NORMALLY CLOSED
    if B738DR_bleed_air_1_switch_position > 0.95
        and B738bleedAir.engine1.psi >= bleed_valve_min_act_press				-- BLEED AIR REQUIRED TO OPEN THE VALVE
    then
        B738bleedAir.engine1.bleed_air_valve.target_pos = 1.0					-- OPERATED BY BLEED AIR PRESSURE (NO ELECTRIC REQUIREMENT)
    end
	
	if B738DR_engine01_fire_ext_switch_pos_arm == 1 then
		B738bleedAir.engine1.bleed_air_valve.target_pos = 0.0
	end
 
    ----- ENGINE #2 BLEED AIR VALVE -----------------------------------------------------
    B738bleedAir.engine2.bleed_air_valve.target_pos = 0.0						-- NORMALLY CLOSED
    if B738DR_bleed_air_2_switch_position > 0.95
        and B738bleedAir.engine2.psi >= bleed_valve_min_act_press				-- BLEED AIR REQUIRED TO OPEN THE VALVE
    then
        B738bleedAir.engine2.bleed_air_valve.target_pos = 1.0					-- OPERATED BY BLEED AIR PRESSURE (NO ELECTRIC REQUIREMENT)
    end

	if B738DR_engine02_fire_ext_switch_pos_arm == 1 then
		B738bleedAir.engine2.bleed_air_valve.target_pos = 0.0
	end


	--- L PACK BLEED AIR VALVE
    B738bleedAir.l_pack.bleed_air_valve.target_pos = 0.0						-- NORMALLY CLOSED
    if B738DR_l_pack_pos > 0.95
	and B738DR_duct_pressure_L >= bleed_valve_min_act_press then				-- L PACK AUTO or HIGH
		--B738bleedAir.l_pack.bleed_air_valve.target_pos = 1.0					-- OPERATED BY BLEED AIR PRESSURE (NO ELECTRIC REQUIREMENT)
		B738bleedAir.l_pack.bleed_air_valve.target_pos = B738DR_l_pack_pos		-- OPERATED BY BLEED AIR PRESSURE (NO ELECTRIC REQUIREMENT)
    end

	--- R PACK BLEED AIR VALVE
    B738bleedAir.r_pack.bleed_air_valve.target_pos = 0.0						-- NORMALLY CLOSED
    if B738DR_r_pack_pos > 0.95
	and B738DR_duct_pressure_R >= bleed_valve_min_act_press then				-- R PACK AUTO or HIGH
		--B738bleedAir.r_pack.bleed_air_valve.target_pos = 1.0					-- OPERATED BY BLEED AIR PRESSURE (NO ELECTRIC REQUIREMENT)
		B738bleedAir.r_pack.bleed_air_valve.target_pos = B738DR_r_pack_pos		-- OPERATED BY BLEED AIR PRESSURE (NO ELECTRIC REQUIREMENT)
    end

	--- ISOLATION VALVE
    B738bleedAir.isolation.bleed_air_valve.target_pos = 0.0						-- NORMALLY CLOSED
    if B738DR_isolation_valve_pos == 1 then										-- ISOLATION VALVE AUTO
		if B738DR_bleed_air_1_switch_position > 0.95
		and B738DR_bleed_air_2_switch_position > 0.95
		and B738DR_l_pack_pos > 0.95
		and B738DR_r_pack_pos > 0.95 then
			B738bleedAir.isolation.bleed_air_valve.target_pos = 0.0		-- CLOSE
		else
			B738bleedAir.isolation.bleed_air_valve.target_pos = 1.0		-- OPEN
		end
    elseif B738DR_isolation_valve_pos == 2 then									-- ISOLATION VALVE OPEN
		B738bleedAir.isolation.bleed_air_valve.target_pos = 1.0				-- OPERATED BY BLEED AIR PRESSURE (NO ELECTRIC REQUIREMENT)
	end


end 

----- BLEED AIR VALVE ANIMATION -------

function B738_bleed_air_valve_animation()
    local valve_anm_speed = 0.49	--1.0

    -- APU BLEED VALVE
    B738bleedAir.apu.bleed_air_valve.pos	        = B738_set_anim_value(B738bleedAir.apu.bleed_air_valve.pos, B738bleedAir.apu.bleed_air_valve.target_pos, 0.0, 1.0, valve_anm_speed)

    -- ENGINE BLEED VALVES
    if simDR_engine_ign1 == 4 then	-- START 1 VALVE open -> ENG 1 BLEED AIR VALVE close
		B738bleedAir.engine1.bleed_air_valve.target_pos = 0
	end
    if simDR_engine_ign2 == 4 then	-- START 2 VALVE open -> ENG 2 BLEED AIR VALVE close
		B738bleedAir.engine2.bleed_air_valve.target_pos = 0
	end
	B738bleedAir.engine1.bleed_air_valve.pos        = B738_set_anim_value(B738bleedAir.engine1.bleed_air_valve.pos, B738bleedAir.engine1.bleed_air_valve.target_pos, 0.0, 1.0, valve_anm_speed)
    B738bleedAir.engine2.bleed_air_valve.pos        = B738_set_anim_value(B738bleedAir.engine2.bleed_air_valve.pos, B738bleedAir.engine2.bleed_air_valve.target_pos, 0.0, 1.0, valve_anm_speed)

    -- PACK BLEED VALVE
    --B738bleedAir.l_pack.bleed_air_valve.pos	        = B738_set_anim_value(B738bleedAir.l_pack.bleed_air_valve.pos, B738bleedAir.l_pack.bleed_air_valve.target_pos, 0.0, 1.0, valve_anm_speed)
    --B738bleedAir.r_pack.bleed_air_valve.pos	        = B738_set_anim_value(B738bleedAir.r_pack.bleed_air_valve.pos, B738bleedAir.r_pack.bleed_air_valve.target_pos, 0.0, 1.0, valve_anm_speed)
    B738bleedAir.l_pack.bleed_air_valve.pos	        = B738_set_anim_value(B738bleedAir.l_pack.bleed_air_valve.pos, B738bleedAir.l_pack.bleed_air_valve.target_pos, 0.0, 2.0, valve_anm_speed)
    B738bleedAir.r_pack.bleed_air_valve.pos	        = B738_set_anim_value(B738bleedAir.r_pack.bleed_air_valve.pos, B738bleedAir.r_pack.bleed_air_valve.target_pos, 0.0, 2.0, valve_anm_speed)

	-- ISOLATION VALVE
    B738bleedAir.isolation.bleed_air_valve.pos	    = B738_set_anim_value(B738bleedAir.isolation.bleed_air_valve.pos, B738bleedAir.isolation.bleed_air_valve.target_pos, 0.0, 1.0, valve_anm_speed)
	
end


----- BLEED AIR DUCT PRESSURE -----------------------------------------------------------

function B738_bleed_air_duct_pressure()

	local l_duct = 0.00
	local r_duct = 0.00
	local eng1_duct = 0.00
	local eng2_duct = 0.00
	local l_duct_delta = 0.00
	local r_duct_delta = 0.00
	local duct_delta = 0.00
	local apu_duct = 0.00

	-- APU DUCT
		apu_duct = B738bleedAir.apu.psi * B738bleedAir.apu.bleed_air_valve.pos
	-- LEFT DUCT
		-- l_duct_in = math.max(
			-- (B738bleedAir.apu.psi * B738bleedAir.apu.bleed_air_valve.pos),
			-- (B738bleedAir.engine1.psi * B738bleedAir.engine1.bleed_air_valve.pos))
		l_duct_in = math.max(apu_duct, (B738bleedAir.engine1.psi * B738bleedAir.engine1.bleed_air_valve.pos))
		l_duct = l_duct_in
		--l_duct = l_duct - (9.5 * (2 - B738bleedAir.l_pack.bleed_air_valve.pos))
		l_duct = l_duct - (4.1 * (2 - B738bleedAir.l_pack.bleed_air_valve.pos))
		l_duct = l_duct - (4.1 * (2 - B738bleedAir.r_pack.bleed_air_valve.pos) * B738bleedAir.isolation.bleed_air_valve.pos)
	
	-- RIGHT DUCT
		r_duct_in = B738bleedAir.engine2.psi * B738bleedAir.engine2.bleed_air_valve.pos
		r_duct = r_duct_in
		--r_duct = r_duct - (9.5 * (2 - B738bleedAir.r_pack.bleed_air_valve.pos))
		r_duct = r_duct - (4.1 * (2 - B738bleedAir.r_pack.bleed_air_valve.pos))
		r_duct = r_duct - (4.1 * (2 - B738bleedAir.l_pack.bleed_air_valve.pos) * B738bleedAir.isolation.bleed_air_valve.pos)
		
	-- ISOLATION VALVE
		
		-- --duct_delta = (math.max(l_duct, r_duct) * 0.8817) 
		duct_delta = (math.max(l_duct, r_duct) - 1.654) 
		l_duct_delta = duct_delta - l_duct
		r_duct_delta = duct_delta - r_duct
		l_duct = l_duct + (l_duct_delta * B738bleedAir.isolation.bleed_air_valve.pos)
		r_duct = r_duct + (r_duct_delta * B738bleedAir.isolation.bleed_air_valve.pos)
		
		
		l_duct_out_target = l_duct
		r_duct_out_target = r_duct
		l_duct_out = B738_set_anim_value(l_duct_out, l_duct_out_target, 0.0, 80.0, 1.0)
		r_duct_out = B738_set_anim_value(r_duct_out, r_duct_out_target, 0.0, 80.0, 1.0)
		B738DR_duct_pressure_L = l_duct_out
		B738DR_duct_pressure_R = r_duct_out

	--- DUAL BLEED - APU damaged if pressure engine > 30 psi
	eng1_duct = B738bleedAir.engine1.psi * B738bleedAir.engine1.bleed_air_valve.pos	-- ENG 1 pressure on L duct
	eng2_duct = r_duct_in * B738bleedAir.isolation.bleed_air_valve.pos				-- ENG 2 pressure on L duct
	
	-- apu damage: duct > apu duct + 13 psi
	apu_duct = rndm_max_apu_bleed_psi + 5
	if dual_bleed == 1 then
		if eng1_duct > apu_duct or eng2_duct > apu_duct then
			simDR_apu_bleed_fail = 1
		end
	end
	
end

--[[ CODE NEEDS TO BE REVISITED, THROTTLE OVERRIDE LIKELY NECESSARY IF WE'RE GOING TO DO THIS


---- ENGINE IDLE MODE ---------------------------------------------------------------------

function B738_ground_timer()

	if simDR_aircraft_on_ground == 1 then
		ground_timer = ground_timer + SIM_PERIOD
	elseif simDR_aircraft_on_ground == 0 then
		ground_timer = 0
	end
	
end

function B738_idle_mode_logic()


	if simDR_aircraft_on_ground_any == 0 then
		B738DR_idle_mode_request = 1
		end

	if simDR_aircraft_on_ground == 1 then
		if simDR_prop_mode0 == 1
		and simDR_prop_mode1 == 1
		and ground_timer > 5 then
		B738DR_idle_mode_request = 0
		end
	end


	if B738DR_idle_mode_request == 0 then
		if simDR_idle_speed0 == 1 then
		simCMD_hi_lo_idle_toggle:once()
		end
	elseif B738DR_idle_mode_request == 1 then
		if simDR_idle_speed0 == 0 then
		simCMD_hi_lo_idle_toggle:once()
		end	
	end


end


]]--

------------- CUSTOM



function B738_start_engine()
	
	--ENGINE 1
	--Position GRD
	if B738DR_engine1_starter_pos == 0 then
		if simDR_engine_mixture1 < 0.1 then		-- start lever> cutoff
			ignition1 = 4
		end
		if simDR_engine_N2_pct1 > 56 and simDR_engine_N2_pct1 < 58 then -- release to OFF and starter off
			ignition1 = 3
			B738DR_engine1_starter_pos = 1
		end
		if simDR_engine_mixture1 > 0.5 then		-- start lever> idle
			if ignition1 ~= 4 then
				ignition1 = 3
			end
		end
	-- Position AUTO
	elseif B738DR_engine1_starter_pos == 1 then
		ignition1 = 0
		if simDR_engine_mixture1 > 0.5 then		-- start lever> idle
			if simDR_engine_N2_pct1 > 50 and simDR_engine_N2_pct1 < 57 then
				ignition1 = 3
			end
			if simDR_on_ground_0 == 0 and simDR_on_ground_1 == 0 and simDR_on_ground_2 == 0 
			and simDR_engine_N2_pct1 < 70 and simDR_engine_N2_pct1 > 5 then
				ignition1 = 3
			end
		end
	-- Position CNT
	elseif B738DR_engine1_starter_pos == 2 then
		ignition1 = 0
		if simDR_engine_mixture1 > 0.5 and simDR_engine_N1_pct1 > 19 then
			if simDR_on_ground_0 == 0 and simDR_on_ground_1 == 0 and simDR_on_ground_2 == 0 then
				if simDR_engine_N2_pct1 < 70 then
					ignition1 = 3
				end
			else
				ignition1 = 3
			end
		end
	-- Position FLT
	elseif B738DR_engine1_starter_pos == 3 then
		ignition1 = 0
		if simDR_engine_mixture1 > 0.5 then		-- start lever> idle
			ignition1 = 3
		end
	end
	
	-- ENGINE 2
	-- Position GRD
	if B738DR_engine2_starter_pos == 0 then
		if simDR_engine_mixture2 < 0.1 then		-- start lever> cutoff
			ignition2 = 4
		end
		if simDR_engine_N2_pct2 > 56 and simDR_engine_N2_pct2 < 58 then -- release to OFF and starter off
			ignition2 = 3
			B738DR_engine2_starter_pos = 1
		end
		if simDR_engine_mixture2 > 0.5 then		-- start lever> idle
			if ignition2 ~= 4 then
				ignition2 = 3
			end
		end
	-- Position AUTO
	elseif B738DR_engine2_starter_pos == 1 then
		ignition2 = 0
		if simDR_engine_mixture2 > 0.5 then		-- start lever> idle
			if simDR_engine_N2_pct2 > 50 and simDR_engine_N2_pct2 < 57 then
				ignition2 = 3
			end
			if simDR_on_ground_0 == 0 and simDR_on_ground_1 == 0 and simDR_on_ground_2 == 0 
			and simDR_engine_N2_pct2 < 70 and simDR_engine_N2_pct2 > 5 then 
				ignition2 = 3
			end
		end
	-- Position CNT
	elseif B738DR_engine2_starter_pos == 2 then
		ignition2 = 0
		if simDR_engine_mixture2 > 0.5 and simDR_engine_N1_pct2 > 19 then
			if simDR_on_ground_0 == 0 and simDR_on_ground_1 == 0 and simDR_on_ground_2 == 0 then
				if simDR_engine_N2_pct2 < 70 then
					ignition2 = 3
				end
			else
				ignition2 = 3
			end
		end
	-- Position FLT
	elseif B738DR_engine2_starter_pos == 3 then
		ignition2 = 0
		if simDR_engine_mixture2 > 0.5 then		-- start lever> idle
			ignition2 = 3
		end
	end
	
	---- ENGINES START
	
	-- B738DR_eng1_start_disable = 0
	-- if apu_start_eng1 == 0 and eng2_start_eng1 == 0 then
		-- if ignition1 == 4  and simDR_engine_N1_pct1 < 19 then
			-- B738DR_eng1_start_disable = 1
		-- end
	-- end
	
	-- B738DR_eng2_start_disable = 0
	-- if apu_start_eng2 == 0 and eng1_start_eng2 == 0 then
		-- if ignition2 == 4 and simDR_engine_N1_pct2 < 19 then
			-- B738DR_eng2_start_disable = 1
		-- end
	-- end
	
	local eng1_start_disable = 0
	if apu_start_eng1 == 0 and eng2_start_eng1 == 0 then
		if ignition1 == 4 and simDR_engine_N1_pct1 < 19 then
			eng1_start_disable = 1
		end
	end
	
	local eng2_start_disable = 0
	if apu_start_eng2 == 0 and eng1_start_eng2 == 0 then
		if ignition2 == 4 and simDR_engine_N1_pct2 < 19 then
			eng2_start_disable = 1
		end
	end
	if eng1_start_disable == 1 or eng2_start_disable == 1 then
		simDR_starter_torque = 0.1
		simDR_starter_max_rpm = 0.128
	elseif ignition1 == 4 and ignition2 == 4 then
		simDR_starter_torque = 0.1
		simDR_starter_max_rpm = 0.128
	else
		simDR_starter_torque = 0.160	--0.175
		simDR_starter_max_rpm = 0.38
	end
	
	if B738DR_duct_pressure_L < 8 then
		if ignition1 == 4 then
			ignition1 = 3
		end
	end
	
	if B738DR_duct_pressure_R < 8 then
		if ignition2 == 4 then
			ignition2 = 3
		end
	end
 	----
	
	simDR_engine_ign1 = ignition1
	simDR_engine_ign2 = ignition2
	
	-- start valve
	if simDR_engine_ign1 == 4 then
		B738DR_start_valve1 = B738_set_anim_time(B738DR_start_valve1, 1.0, 0.0, 1.0, 1, 2.5)
	else
		B738DR_start_valve1 = B738_set_anim_time(B738DR_start_valve1, 0.0, 0.0, 1.0, 0, 2.5)
	end
	if simDR_engine_ign2 == 4 then
		B738DR_start_valve2 = B738_set_anim_time(B738DR_start_valve2, 1.0, 0.0, 1.0, 1, 2.5)
	else
		B738DR_start_valve2 = B738_set_anim_time(B738DR_start_valve2, 0.0, 0.0, 1.0, 0, 2.5)
	end
	
end



function B738_apu_bleed_starter()
	-- starting engine 1 begin
	eng1_starting = 0
	if ignition1 == 4 then
		eng1_starting = 1
	end

	-- starting engine 2 begin
	eng2_starting = 0
	if ignition2 == 4 then
		eng2_starting = 1
	end
end

function B738_fuel_pump()
	
	-- left tank
	if simDR_engine_N1_pct1 < 0.3 then
		B738_tank_l_status = 0
	end
	if simDR_engine_N1_pct1 > 0.7 then
		B738_tank_l_status = 1
	end
	
	--right tank
	if simDR_engine_N1_pct2 < 0.3 then
		B738_tank_r_status = 0
	end
	if simDR_engine_N1_pct2 > 0.7 then
		B738_tank_r_status = 1
	end
	
	if (B738DR_fuel_tank_pos_ctr1 == 1 and B738DR_ac_tnsbus1_status == 1) 
	or (B738DR_fuel_tank_pos_ctr2 == 1 and B738DR_ac_tnsbus2_status == 1) then
		B738_tank_c_status = 1
	else
		B738_tank_c_status = 0
	end
end

function apu_low_oil()
	if simDR_apu_status < 40 then
		B738DR_apu_low_oil = 1
	end
end

function apu_shutdown()
    simCMD_apu_off:once()
end

function apu_start_stop()
	simCMD_apu_start:stop() 
	simCMD_apu_on:once()
end

function apu_start()
	if B738DR_apu_fire_ext_switch_pos_arm == 0 and B738DR_batbus_status == 1 then
		simCMD_apu_start:start() 
		apu_start_active = 2
		apu_shutdown_active = 0
		run_after_time(apu_start_stop, 1.0)
	else
		apu_start_active = 0
	end
end

function apu_back_on()
	if B738DR_apu_start_switch_position == 2 then
		if simDR_elevation_m < 1200 and simDR_fuel_tank_weight_kg[0] > 0 then	-- below 1200 meters
			apu_start_active = 1
		else
			if apu_fuel_pump_status == 1 and apu_fuel_tank_status == 1 then
				apu_start_active = 1
			end
		end
	end
end

function apu_normal()
	apu_start_active = 3
end

function B738_apu_system2()
	
	local apu_turn_off = 0
	local apu_start_time = 0
	local apu_temp_lim = 0
	local apu_temp_oat = simDR_air_temp / 10
	
	if apu_temp_oat < 0 then
		apu_temp_oat = 0
	end
	
	if B738DR_apu_start_switch_position == 0 then				-- OFF
		if simDR_apu_run == 1 then								-- APU running
			if apu_shutdown_active == 0 then
				apu_shutdown_active = 1
			end
			apu_start_active = 0
		else
			if is_timer_scheduled(apu_start) == true then		-- running delay starting
				stop_timer(apu_start)							-- stop delay starting
				apu_start_active = 0
				simCMD_apu_off:once()
			end
			--B738DR_apu_low_oil = 0
		end
		B738DR_apu_bus_enable = 0
		B738DR_apu_low_oil = 0
	end
	if apu_start_active == 1 and B738DR_apu_was_fire == 0 and simDR_apu_bleed_fail == 0 and B738DR_batbus_status == 1 then	-- START on
		if simDR_apu_run == 0 then								-- APU not running
			if is_timer_scheduled(apu_start) == false then
				apu_temp_lim = math.min(60, (apu_temp_oat + 30))
				apu_temp_lim = math.max(0, (apu_temp_oat + 30))
				apu_start_time = B738_rescale(0, 28, 60, 8, apu_temp_lim)
				run_after_time(apu_start, apu_start_time)
				--run_after_time(apu_start, 16)					-- Delay START 16 seconds
				run_after_time(apu_low_oil, 5.5)				-- Delay 5.5 second
			end
		else
			apu_start_active = 3
			apu_shutdown_active = 0
		end
	elseif apu_start_active == 2 then
		if simDR_apu_status > apu_temp then
			apu_temp_target = simDR_apu_status
		end
		apu_temp = B738_set_anim_value(apu_temp, apu_temp_target, 0.0, 100.0, 8)
		if apu_temp > 95 then
			if is_timer_scheduled(apu_normal) == false then
				run_after_time(apu_normal, 8.5)					-- Delay 8.5 seconds
			end
		end
	elseif apu_start_active == 3 then
		apu_temp_target = 52
		apu_temp = B738_set_anim_value(apu_temp, apu_temp_target, 0.0, 100.0, 0.10)
		if apu_temp > 50 and apu_temp < 60 and simDR_apu_run == 1 and simDR_apu_status > 94 then
			B738DR_apu_bus_enable = 1
		end
		if apu_temp > 40 and simDR_apu_run == 1 and simDR_apu_status > 40 then
			B738DR_apu_low_oil = 0
		end
	end
	
	if is_timer_scheduled(apu_start) == true then
		B738DR_apu_start_load = 60		--drain 2x 60 Amper
	else
		B738DR_apu_start_load = 0
	end
	
	-- apu_fuel_pump_status = 0
	-- apu_fuel_tank_status = 0
	-- if B738DR_cross_feed_selector_knob == 0 then
		-- if simDR_tank_l_status == 1 or B738DR_fuel_tank_pos_ctr1 == 1 then
			-- apu_fuel_pump_status = 1
		-- end
		-- if simDR_tank_l_status == 1 and simDR_fuel_tank_weight_kg[0] > 0 then
			-- apu_fuel_tank_status = 1
		-- end
		-- if B738DR_fuel_tank_pos_ctr1 == 1 and simDR_fuel_tank_weight_kg[1] > 0 then
			-- apu_fuel_tank_status = 1
		-- end
		-- if simDR_elevation_m < 1200 and simDR_fuel_tank_weight_kg[0] > 0 then
			-- apu_fuel_tank_status = 1
		-- end
	-- else
		-- if simDR_tank_l_status == 1 or simDR_tank_c_status == 1 or simDR_tank_r_status == 1 then
			-- apu_fuel_pump_status = 1
		-- end
		-- if simDR_tank_l_status == 1 and simDR_fuel_tank_weight_kg[0] > 0 then
			-- apu_fuel_tank_status = 1
		-- end
		-- if simDR_tank_c_status == 1 and simDR_fuel_tank_weight_kg[1] > 0 then
			-- apu_fuel_tank_status = 1
		-- end
		-- if simDR_tank_r_status == 1 and simDR_fuel_tank_weight_kg[2] > 0 then
			-- apu_fuel_tank_status = 1
		-- end
		-- if simDR_elevation_m < 1200 and simDR_fuel_tank_weight_kg[0] > 0 then
			-- apu_fuel_tank_status = 1
		-- end
	-- end
	
	
	apu_fuel_pump_status = 0
	apu_fuel_tank_status = 0
	if B738DR_cross_feed_selector_knob == 0 then
		if (B738DR_low_fuel_press_l1_annun == 0 or B738DR_low_fuel_press_l2_annun == 0) 
		and simDR_fuel_tank_weight_kg[0] > 0 then
			apu_fuel_pump_status = 1
			apu_fuel_tank_status = 1
		end
		if B738DR_low_fuel_press_c1_annun == 0 and simDR_fuel_tank_weight_kg[1] > 0 then
			apu_fuel_pump_status = 1
			apu_fuel_tank_status = 1
		end
		if simDR_elevation_m < 1200 and simDR_fuel_tank_weight_kg[0] > 0 then
			apu_fuel_pump_status = 1
			apu_fuel_tank_status = 1
		end
	else
		if (B738DR_low_fuel_press_l1_annun == 0 or B738DR_low_fuel_press_l2_annun == 0) 
		and simDR_fuel_tank_weight_kg[0] > 0 then
			apu_fuel_pump_status = 1
			apu_fuel_tank_status = 1
		end
		if (B738DR_low_fuel_press_c1_annun == 0 or B738DR_low_fuel_press_c2_annun == 0) 
		and simDR_fuel_tank_weight_kg[1] > 0 then
			apu_fuel_pump_status = 1
			apu_fuel_tank_status = 1
		end
		if (B738DR_low_fuel_press_r1_annun == 0 or B738DR_low_fuel_press_r2_annun == 0) 
		and simDR_fuel_tank_weight_kg[2] > 0 then
			apu_fuel_pump_status = 1
			apu_fuel_tank_status = 1
		end
		if simDR_elevation_m < 1200 and simDR_fuel_tank_weight_kg[0] > 0 then
			apu_fuel_pump_status = 1
			apu_fuel_tank_status = 1
		end
	end
	if simDR_apu_run == 1 and simDR_fuel_tank_weight_kg[0] > 0 then
		apu_fuel_pump_status = 1
		apu_fuel_tank_status = 1
	end
	
	--if simDR_elevation_m > 1200 and apu_fuel_pump_status == 0 then	-- above 1200 meters
	if apu_fuel_pump_status == 0 then
		apu_turn_off = 1
	end
	
	if apu_fuel_tank_status == 0 then
		apu_turn_off = 1
	end
	
	if apu_turn_off == 1 or B738DR_apu_was_fire == 1 or simDR_apu_bleed_fail == 1 or B738DR_apu_fire_ext_switch_pos_arm == 1 then
		apu_shutdown_active = 1
		apu_start_active = 0
		B738DR_apu_bus_enable = 0
		if simDR_apu_run == 1 then
			simCMD_apu_off:once()
		end
		-- if is_timer_scheduled(apu_cooling) == false then
			-- run_after_time(apu_cooling, 5.5)					-- Delay START 5 seconds
		-- end
	end
	
	if apu_shutdown_active == 1 then
		--if apu_temp < (apu_temp_oat + 5) then
		if apu_temp < 10 then	-- 100 C
			apu_shutdown_active = 0
		--elseif apu_temp < 25 then
			simCMD_apu_off:once()
		end
	end
	
	if apu_start_active == 0 then
		if B738DR_apu_start_switch_position == 0 then
			apu_temp_target = 0
			if apu_shutdown_active == 0 then
				apu_temp = B738_set_anim_value(apu_temp, apu_temp_target, 0.0, 100.0, 3)
			else
				apu_temp = B738_set_anim_value(apu_temp, apu_temp_target, 0.0, 100.0, 0.03)
			end
		else
			apu_temp_target = apu_temp_oat
			if apu_shutdown_active == 0 then
				apu_temp = B738_set_anim_value(apu_temp, apu_temp_target, 0.0, 100.0, 3)
			else
				apu_temp = B738_set_anim_value(apu_temp, apu_temp_target, 0.0, 100.0, 0.03)
			end
		end
	end
	
	if B738DR_apu_bus_enable == 0 then
		B738DR_apu_power_bus1 = 0
		B738DR_apu_power_bus2 = 0
	end
	
	B738DR_apu_temp = apu_temp
	--B738DR_apu_temp = DR_sys_test


end


--AUTO BRAKE and SPEED BRAKE

function touchdnown_3sec()
	touchdown_3s = 1
end

function B738_autobrake()

	local throttle_idle = 1
	local throttle_idle_3s = 1
	local manual_brake = 0
	local gnd_spd = simDR_ground_speed * 1.94384
	local throttle_30 = 1
	
	-- if B738DR_parking_brake_pos > 0.1 
	-- or simDR_left_brake > 0.3
	-- or simDR_right_brake > 0.3 then		-- Laminar bug diff brake yaw axis
		-- manual_brake = 1
	-- end
	
	if brake_inop == 1 then
		if B738DR_autobrake_RTO_arm > 0 or B738DR_autobrake_arm > 0 then
			B738DR_autobrake_disarm = 1
		else
			B738DR_autobrake_disarm = 0
		end
		after_RTO = 0
		B738DR_autobrake_RTO_arm = 0
		B738DR_autobrake_RTO_test = 0
		B738DR_autobrake_arm = 0
		autobrake_ratio = 0
	end

	if B738DR_toe_brakes_ovr == 0 then
		brake_force = math.max(simDR_left_brake, simDR_right_brake)
	else
		brake_force = math.max(left_brake, right_brake)
	end
	--if B738DR_parking_brake_pos > 0.1
	--or parkbrake_force > 0.1
	if B738DR_parking_brake_pos > 0.1
	or brake_force > (autobrake_ratio + 0.05) then
	--or brake_force > 0.27 then
		manual_brake = 1
	end
	
	if B738DR_thrust1_leveler > 0.1 
	and B738DR_thrust2_leveler > 0.1 then
		if simDR_reverse1_deploy < 0.05
		and simDR_reverse2_deploy < 0.05 then
			throttle_idle = 0
		end
	end
	
	if touchdown_3s == 1 and throttle_idle == 0 then
		throttle_idle_3s = 0
	end
	
	if B738DR_thrust1_leveler > 0.10 
	and B738DR_thrust2_leveler > 0.10 then	--0.30
		if simDR_reverse1_deploy < 0.05
		and simDR_reverse2_deploy < 0.05 then
			throttle_30 = 0
		end
	end
	if touchdown_3s == 1 and throttle_30 == 0 then
		throttle_idle_3s = 0
	end
	
	
	-- AUTOBRAKE RTO Engaged
	if B738DR_autobrake_RTO_arm == 2 then
		if gnd_spd < 1.0 then 
			B738DR_autobrake_RTO_arm = 0		-- AUTOBRAKE RTO Disarm
			B738DR_autobrake_disarm = 1
			autobrake_ratio = 0
			after_RTO = 1
		end
		
		if simDR_speedbrake_ratio == 0
		and gnd_spd > 60
		and throttle_idle == 1 then				-- SPEED BRAKE DOWN
			if simDR_reverser_on_0 == 1 or simDR_reverser_on_1 == 1 then
				simDR_speedbrake_ratio = 1.0	-- SPEED BRAKE UP
			end
		end
	end
	
	if after_RTO == 1 and throttle_idle == 0 then	-- SPEED BRAKE UP
		simDR_speedbrake_ratio = 0.0				-- SPEED BRAKE DOWN
		after_RTO = 0
	end
	
	-- AUTOBRAKE Engaged
	if B738DR_autobrake_arm == 2 then
		if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1
		or simDR_on_ground_2 == 1 then
			if gnd_spd < 1.0
			or throttle_idle_3s == 0
			or manual_brake == 1 then
				B738DR_autobrake_arm = 0			-- AUTOBRAKE Disarm
				B738DR_autobrake_disarm = 1
				autobrake_ratio = 0
				if is_timer_scheduled(touchdnown_3sec) == true then
					stop_timer(touchdnown_3sec, 3)
				end
			else
				if touchdown_3s == 0 then
					if is_timer_scheduled(touchdnown_3sec) == false then
						run_after_time(touchdnown_3sec, 3)
					end
				end
			end
		-- else
			-- touchdown_3s = 0
		end
	end
	
	-- AUTOBRAKE RTO not armed but position RTO
	if simDR_radio_height_pilot_ft > 100 
	and aircraft_was_on_air == 0 then		-- aircraft above 100 ft RA
		aircraft_was_on_air = 1
		aircraft_landing = 0
		aircraft_landing2 = 0
	end
	if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1 
	or simDR_on_ground_2 == 1 then				-- if aircraft on the ground
		if aircraft_was_on_air == 1 then		-- if aircraft touch down
			aircraft_was_on_air = 0
			aircraft_landing = 1
			aircraft_landing2 = 1
			if B738DR_autobrake_pos == 0 then	-- RTO
				B738DR_autobrake_disarm = 1
			end
		end
	end
	
	if aircraft_landing == 1 then
		if simDR_speedbrake_ratio == 0
		and gnd_spd > 60
		and throttle_idle == 1 then				-- SPEED BRAKE DOWN
			if simDR_reverser_on_0 == 1 or simDR_reverser_on_1 == 1 then
				simDR_speedbrake_ratio = 1.0	-- SPEED BRAKE UP
			end
		end
	end
	
	if aircraft_landing2 == 1 and throttle_30 == 0 then	-- SPEED BRAKE UP
		if simDR_speedbrake_ratio > 0 then
			simDR_speedbrake_ratio = 0.0					-- SPEED BRAKE DOWN
		end
		aircraft_landing2 = 0
	end
	
	if aircraft_landing == 1 and gnd_spd < 60.0 then
		aircraft_landing = 0
	end
	
	-- AUTOBRAKE RTO Armed
	if B738DR_autobrake_RTO_arm == 1 then
		if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1 
		or simDR_on_ground_2 == 1 then
			if gnd_spd > 90.0 then
				if B738DR_thrust1_leveler < 0.08
				or B738DR_thrust2_leveler < 0.08 then		-- throttle idle
					--simDR_brake = 0.24
					autobrake_ratio = 0.31
					B738DR_autobrake_RTO_arm = 2		-- AUTOBRAKE RTO Engaged
				end
			end
		end
		if simDR_radio_height_pilot_ft > 50 then
			B738DR_autobrake_RTO_arm = 0		-- AUTOBRAKE RTO Disarmed
			B738DR_autobrake_pos = 1			-- AUTOBRAKE RTO release to OFF
		end
	end
	-- AUTOBRAKE 1 - 2 - 3 - MAX
	-- AUTOBRAKE OFF
	if simDR_radio_height_pilot_ft > 100
	and B738DR_autobrake_arm == 0 then
		if B738DR_autobrake_pos > 1.95 then
			B738DR_autobrake_arm = 1
			touchdown_3s = 0
		end
	end
	-- AUTOBRAKE Armed
	if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1 
	or simDR_on_ground_2 == 1 then
		if B738DR_autobrake_arm == 1 then
			B738DR_autobrake_arm = 2			-- AUTOBRAKE Engaged
			if B738DR_autobrake_pos == 2 then
				--simDR_brake = 0.055
				autobrake_ratio = 0.05 --0.075
			elseif B738DR_autobrake_pos == 3 then
				--simDR_brake = 0.11
				autobrake_ratio = 0.10 --0.15
			elseif B738DR_autobrake_pos == 4 then
				--simDR_brake = 0.165
				autobrake_ratio = 0.15 --0.225
			elseif B738DR_autobrake_pos == 5 then
				--simDR_brake = 0.22
				autobrake_ratio = 0.2 --0.30
			end
		end
	end

end


-- indicated brake temp from 0.0 to 0.9
function B738_brake_temp_indicate(temp)

	local temp_0 = 0
	
	temp_0 = math.floor((temp * 10) + 0.5) / 10
	if temp_0 < 0.1 then
		return 0.1
	else
		if temp_0 > 9.9 then
			return 9.9
		else
			return temp_0
		end
	end

end

function B738_brake_cooling(temp, temp_outside)

	local out_temp_100 = temp_outside / 100
	local temp_100 = 0
	local delta_temp = 0
	local qr_speed = simDR_airspeed_pilot	--simDR_ground_speed
	local out_temp_k = 0
	local out_temp_k2 = 1
	
	out_temp_100 = 5 + out_temp_100
	temp_100 = 5 + temp

	if simDR_gear_deploy_0 > 0.1 then	-- landing gear down
		out_temp_k2 = qr_speed / 84
		out_temp_100 = out_temp_100 - out_temp_k2
		if out_temp_100 < 0 then
			out_temp_100 = 0.00
		end
	else
		out_temp_100 = 0.14		-- 14 degees C
	end
	
	delta_temp = temp_100 - out_temp_100
	delta_temp = delta_temp * 5
	out_temp_k = delta_temp * delta_temp * 0.0015		-- 0.0007
	
	return out_temp_k * 0.01 * SIM_PERIOD
	
end

function B738_brake_power(brake_power, tire_speed)

	local weight = simDR_total_weight / 2204
	local weight_k = 0
	local delta_weight = 0
	local tire_spd = tire_speed
	
	delta_weight = weight - 80
	weight_k = delta_weight / 100
	weight_k = weight_k + 1
	tire_spd = tire_spd / 10
	tire_spd = tire_spd * tire_spd * 1.1
	return tire_spd * brake_power * weight_k * 0.047 * SIM_PERIOD	-- 0.017 -- 0.021

end

function B738_brake_temp()

	local temp_slide = 0
	local out_temp_100 = 0
	local brake = 0
	
	B738DR_tire_speed1 = simDR_tire_speed1
	B738DR_tire_speed2 = simDR_tire_speed2
	
	-- -- left and right
	if simDR_brake > 0.05 then
		if simDR_side_slip < 0 and B738DR_tire_speed1 > 30 then 	-- left
			temp_slide = -simDR_side_slip * B738DR_tire_speed1
			temp_slide = temp_slide * simDR_brake * 0.01
			temp_slide = temp_slide * 0.025 * SIM_PERIOD
			B738DR_brake_temp_l_out = B738DR_brake_temp_l_out + temp_slide
			B738DR_brake_temp_l_in  = B738DR_brake_temp_l_in + (temp_slide * 0.75)
		end
		if simDR_side_slip > 0 and B738DR_tire_speed2 > 30 then 	-- right
			temp_slide = simDR_side_slip * B738DR_tire_speed2
			temp_slide = temp_slide * simDR_brake * 0.01
			temp_slide = temp_slide * 0.025 * SIM_PERIOD
			B738DR_brake_temp_r_out = B738DR_brake_temp_r_out + temp_slide
			B738DR_brake_temp_r_in  = B738DR_brake_temp_r_in + (temp_slide * 0.75)
		end
	end
	B738DR_tire_speed0 = temp_slide
	-- brake power
	--brake = simDR_brake
	brake = math.max(simDR_left_brake, simDR_right_brake, simDR_brake)
	B738DR_brake_temp_l_out = B738DR_brake_temp_l_out + B738_brake_power(brake, B738DR_tire_speed1)
	B738DR_brake_temp_r_out = B738DR_brake_temp_r_out + B738_brake_power(brake, B738DR_tire_speed2)
	B738DR_brake_temp_l_in = B738DR_brake_temp_l_in + B738_brake_power(brake, B738DR_tire_speed1)
	B738DR_brake_temp_r_in = B738DR_brake_temp_r_in + B738_brake_power(brake, B738DR_tire_speed2)
	-- air cooling
	out_temp_100 = simDR_air_temp
	B738DR_brake_temp_l_out = B738DR_brake_temp_l_out - B738_brake_cooling(B738DR_brake_temp_l_out, out_temp_100)
	B738DR_brake_temp_r_out = B738DR_brake_temp_r_out - B738_brake_cooling(B738DR_brake_temp_r_out, out_temp_100)
	B738DR_brake_temp_l_in = B738DR_brake_temp_l_in - B738_brake_cooling(B738DR_brake_temp_l_in, out_temp_100)
	B738DR_brake_temp_r_in = B738DR_brake_temp_r_in - B738_brake_cooling(B738DR_brake_temp_r_in, out_temp_100)
	out_temp_100 = out_temp_100 / 100
	if B738DR_brake_temp_l_out < out_temp_100 then
		B738DR_brake_temp_l_out = out_temp_100
	end
	if B738DR_brake_temp_r_out < out_temp_100 then
		B738DR_brake_temp_r_out = out_temp_100
	end
	if B738DR_brake_temp_l_in < out_temp_100 then
		B738DR_brake_temp_l_in = out_temp_100
	end
	if B738DR_brake_temp_r_in < out_temp_100 then
		B738DR_brake_temp_r_in = out_temp_100
	end
	-- indicate temp
	B738DR_brake_temp_left_out = B738_brake_temp_indicate(B738DR_brake_temp_l_out)
	B738DR_brake_temp_right_out = B738_brake_temp_indicate(B738DR_brake_temp_r_out)
	B738DR_brake_temp_left_in = B738_brake_temp_indicate(B738DR_brake_temp_l_in)
	B738DR_brake_temp_right_in = B738_brake_temp_indicate(B738DR_brake_temp_r_in)

end

function yaw_damp_on()
		simDR_yaw_damper_switch = 1
end

function yaw_damp_off()
		simDR_yaw_damper_switch = 0
		B738DR_yaw_damper_switch_pos = 0
end

function B738_yaw_damp()

	local yaw_damp_hydr = 1
	--if B738DR_hyd_B_status == 0 and B738DR_hyd_stdby_status == 0 then
	if B738DR_hyd_B_status == 0 and B738DR_flt_ctr_B_pos == -1 then
		yaw_damp_hydr = 0
	end
	
	if B738DR_yaw_damper_switch_pos == 0 and simDR_yaw_damper_switch == 1 then
		simDR_yaw_damper_switch = 0
	end
	
	if yaw_damper_switch_old ~= B738DR_yaw_damper_switch_pos and B738DR_yaw_damper_switch_pos == 0 then
		was_align_left = 0
		was_align_right = 0
	end
	
	local irs_off = 0
	local irs_spring_off = 0
	if B738DR_irs_source == -1 then
		if B738DR_irs_left == 0 then
			irs_off = 1
			if was_align_left == 0 then
				irs_spring_off = 1
			end
		else
			if B738DR_irs_align_left == 1 or B738DR_irs_left_mode > 1 then
				was_align_left = 1
			end
			if was_align_left == 0 then
				irs_spring_off = 1
				irs_off = 1
			end
		end
		if B738DR_irs_align_fail_left == 1 then
			irs_off = 1
		end
	elseif B738DR_irs_source == 0 then
		if B738DR_irs_right == 0 and B738DR_irs_left == 0 then
			irs_off = 1
			if was_align_left == 0 and was_align_right == 0 then
				irs_spring_off = 1
			end
		else
			if B738DR_irs_align_left == 1 or B738DR_irs_left_mode > 1 then
				was_align_left = 1
			end
			if B738DR_irs_align_right == 1 or B738DR_irs_right_mode > 1 then
				was_align_right = 1
			end
			if was_align_left == 0 and was_align_right == 0 then
				irs_spring_off = 1
				irs_off = 1
			end
		end
		if B738DR_irs_align_fail_left == 1 and B738DR_irs_align_fail_right == 1 then
			irs_off = 1
		end
	elseif B738DR_irs_source == 1 then
		if B738DR_irs_right == 0 then
			irs_off = 1
			if was_align_right == 0 then
				irs_spring_off = 1
			end
		else
			if B738DR_irs_align_right == 1 or B738DR_irs_right_mode > 1 then
				was_align_right = 1
			end
			if was_align_right == 0 then
				irs_spring_off = 1
				irs_off = 1
			end
		end
		if B738DR_irs_align_fail_right == 1 then
			irs_off = 1
		end
	end
	
	if yaw_damp_hydr == 0 then
		irs_spring_off = 1
		irs_off = 1
	end
	
	-- turn off YD switch
	if irs_spring_off == 1 then
		if yaw_damper_switch_status == 1 then
			B738DR_yaw_damper_switch_pos = 0
			yaw_damper_switch_status = 0
		end
	end
	-- turn off YD
	if irs_off == 1 then
		if simDR_yaw_damper_switch == 1 then
			simDR_yaw_damper_switch = 0
		end
	end
	
	--if B738DR_irs_left_mode > 1 or B738DR_irs_right_mode > 1 then
	--if B738DR_irs_right == 0 and B738DR_irs_left == 0 then
	if irs_off == 0 and irs_spring_off == 0 then
		if B738DR_yaw_damper_switch_pos == 1 and simDR_yaw_damper_switch == 0 then --and yaw_damp_hydr == 1 then
			if is_timer_scheduled(yaw_damp_on) == false then
				run_after_time(yaw_damp_on, 2.0)
			end
		end
	end
	
	-- --if B738DR_irs_left_mode < 2 and B738DR_irs_right_mode < 2
	-- if irs_off == 1 and B738DR_yaw_damper_switch_pos == 1 then
		-- if is_timer_scheduled(yaw_damp_off) == false then
			-- run_after_time(yaw_damp_off, 1.5)
		-- end
	-- end
	
	-- if yaw_damp_hydr == 0 and B738DR_yaw_damper_switch_pos == 1 then
		-- if is_timer_scheduled(yaw_damp_off) == false then
			-- run_after_time(yaw_damp_off, 1.5)
		-- end
	-- end
	
	irs_left_old = B738DR_irs_left
	irs_right_old = B738DR_irs_right
	yaw_damper_switch_old = B738DR_yaw_damper_switch_pos

end

function turn_around_state()
	if first_time > 4 and first_time < 5 then
		first_time = 5
		if simDR_startup_running == 0 and B738DR_engine_no_running_state == 1 then
			-- GPU on
			--simCMD_gpu_on:once()
			simDR_gpu_on = 1
			-- YAW DAMPER
			simDR_yaw_damper_switch	= 1
			B738DR_yaw_damper_switch_pos = 1
			yaw_damper_switch_status = 1
			-- Position lights
			B738CMD_position_light_switch_dn:once()
			
			temp_cont_cab = 25
			temp_fwd = 27
			temp_aft = 26
			temp_fwd_pass_cab = 28
			temp_aft_pass_cab = 27
			temp_l_pack = math.max(simDR_TAT, 0)
			temp_r_pack = math.max(simDR_TAT, 0)
		end
		if B738DR_chock_status == 0 then
			if simDR_on_ground_0 == 1 and simDR_on_ground_1 == 1 and simDR_on_ground_2 == 1 then
				simDR_brake = 1
				B738DR_parking_brake_pos = simDR_brake
			else
				simDR_brake = 0
				B738DR_parking_brake_pos = simDR_brake
			end
		else
			simDR_brake = 0
			B738DR_parking_brake_pos = simDR_brake
		end

	end
	--if simDR_on_ground_0 == 1 and simDR_on_ground_1 == 1 and simDR_on_ground_2 == 1 then
		if first_time < 5 then
			first_time = first_time + SIM_PERIOD
		end
	--end
end


----- ON FLIGHT START--------------------------------------------------------------------
function B738_init_engineMGMT_fltStart()

    -- ALL MODES ------------------------------------------------------------------------


    -- COLD & DARK ----------------------------------------------------------------------
    if simDR_startup_running == 0 then
	    
		simDR_electric_hyd_pump_switch = 0
		B738DR_apu_start_switch_position = 0
		B738DR_el_hydro_pumps1_switch_position = 0
		B738DR_el_hydro_pumps2_switch_position = 0
		simDR_tank_l_status = 0
		simDR_tank_r_status = 0
		simDR_tank_c_status = 0
		simCMD_hydro_pumps_on:once()
		B738DR_hydro_pumps1_switch_position = 1
		B738DR_hydro_pumps2_switch_position = 1
		--simDR_cross_tie = 1
		simDR_bus_transfer_on = 1
		B738DR_pas_oxy_switch_position = 0	
		B738DR_drive_disconnect1_switch_position = 0
		B738DR_drive_disconnect2_switch_position = 0
		simDR_apu_generator_switch = 0
		B738DR_bleed_air_1_switch_position = 0
		B738DR_bleed_air_2_switch_position = 0
		B738DR_position_light_switch_pos = 0
		simDR_avionics_switch = 1
		B738DR_transponder_knob_pos = 1
		simDR_transponder_mode = 1		
		simDR_yaw_damper_switch	= 0
		B738DR_yaw_damper_switch_pos = 0
		yaw_damper_switch_status = 0
		--simDR_idle_speed0 = 0
		--simDR_idle_speed1 = 0

		B738DR_engine1_starter_pos = 1
		B738DR_engine2_starter_pos = 1
		B738DR_fuel_tank_pos_lft1 = 0
		B738DR_fuel_tank_pos_lft2 = 0
		B738DR_fuel_tank_pos_ctr1 = 0
		B738DR_fuel_tank_pos_ctr2 = 0
		B738DR_fuel_tank_pos_rgt1 = 0
		B738DR_fuel_tank_pos_rgt2 = 0
		
--		apu_start_active = 0
		if simDR_gear_handle_status == 0 then
			B738DR_gear_handle_pos = 0.5
			B738DR_gear_handle_act = 0.5
		else
			B738DR_gear_handle_pos = 1
			B738DR_gear_handle_act = 1
		end
		gear_handle_pos_old = B738DR_gear_handle_pos
		gear_lock = 0
		gear_handle_aret = 0
		B738DR_l_recirc_fan_pos = 1
		B738DR_r_recirc_fan_pos = 1
		B738DR_trim_air_pos = 0

		B738_tank_l_status = 0
		B738_tank_c_status = 0
		B738_tank_r_status = 0
		
		temp_cont_cab = math.max(simDR_TAT, 0)
		temp_fwd = math.max(simDR_TAT, 0)
		temp_aft = math.max(simDR_TAT, 0)
		temp_fwd_pass_cab = math.max(simDR_TAT, 0)
		temp_aft_pass_cab = math.max(simDR_TAT, 0)
		temp_l_pack = math.max(simDR_TAT, 0)
		temp_r_pack = math.max(simDR_TAT, 0)
		
		first_generators1 = 1
		first_generators2 = 1
		
		B738DR_mach_test_enable = 0
		
		-- ENGINES RUNNING ------------------------------------------------------------------
    elseif simDR_startup_running == 1 then

		B738DR_l_recirc_fan_pos = 1
		B738DR_r_recirc_fan_pos = 1
		B738DR_trim_air_pos = 1

		temp_cont_cab = 25
		temp_fwd = 27
		temp_aft = 26
		temp_fwd_pass_cab = 28
		temp_aft_pass_cab = 27
		temp_l_pack = 27
		temp_r_pack = 28
		
		B738DR_hydro_pumps1_switch_position = 1
		B738DR_hydro_pumps2_switch_position = 1
		B738DR_el_hydro_pumps1_switch_position = 1
		B738DR_el_hydro_pumps2_switch_position = 1
		B738DR_apu_start_switch_position = 0
		--simDR_cross_tie = 1
		simDR_bus_transfer_on = 1
		B738DR_pas_oxy_switch_position = 0
		B738DR_drive_disconnect1_switch_position = 0
		B738DR_drive_disconnect2_switch_position = 0
		simDR_yaw_damper_switch	= 1
		B738DR_yaw_damper_switch_pos = 1
		yaw_damper_switch_status = 1
		simDR_apu_generator_switch = 0
		B738DR_bleed_air_1_switch_position = 1
		B738DR_bleed_air_2_switch_position = 1
		B738DR_position_light_switch_pos = -1
		simDR_strobes_switch = 0
		simDR_nav_switch = 1
		simDR_landing_light_on_0 = 0
		simDR_landing_light_on_1 = 0
		simDR_landing_light_on_2 = 0
		simDR_landing_light_on_3 = 0
		simDR_avionics_switch = 1
		B738DR_transponder_knob_pos = 1	
		simDR_transponder_mode = 1		
		--simDR_idle_speed0 = 0
		--simDR_idle_speed1 = 0

		B738DR_engine1_starter_pos = 1
		B738DR_engine2_starter_pos = 1
		B738DR_fuel_tank_pos_lft1 = 1
		B738DR_fuel_tank_pos_lft2 = 1
		B738DR_fuel_tank_pos_ctr1 = 1
		B738DR_fuel_tank_pos_ctr2 = 1
		B738DR_fuel_tank_pos_rgt1 = 1
		B738DR_fuel_tank_pos_rgt2 = 1
--		apu_start_active = 0
		if simDR_gear_handle_status == 0 then
			B738DR_gear_handle_pos = 0.5
			B738DR_gear_handle_act = 0.5
		else
			B738DR_gear_handle_pos = 1
			B738DR_gear_handle_act = 1
		end
		gear_handle_pos_old = B738DR_gear_handle_pos
		gear_handle_aret = 0
		B738_tank_l_status = 1
		B738_tank_c_status = 1
		B738_tank_r_status = 1
		simDR_tank_l_status = 1
		simDR_tank_c_status = 1
		simDR_tank_r_status = 1
		
		B738DR_hyd_stdby_pressure = 2700
		B738DR_hyd_stdby_status = 1
		
		first_generators1 = 0
		first_generators2 = 0
		-- simDR_brake = 1
		-- B738DR_parking_brake_pos = simDR_brake
		DR_sys_test = 2
		B738DR_mach_test_enable = 1

    end
	irs_left_old = B738DR_irs_left
	irs_right_old = B738DR_irs_right
	was_align_left = 0
	was_align_right = 0
	yaw_damper_switch_old = 0
	
end

function tcas_clr(ai_plane)
	
	if ai_plane == 1 then
		B738DR_tcas_box_show = 0
		B738DR_tcas_circle_show = 0
		B738DR_tcas_diam_show = 0
		B738DR_tcas_diam_e_show = 0
		-- tcas_dis_1 = 0
		-- tcas_el_1 = 0
	elseif ai_plane == 2 then
		B738DR_tcas_box_show2 = 0
		B738DR_tcas_circle_show2 = 0
		B738DR_tcas_diam_show2 = 0
		B738DR_tcas_diam_e_show2 = 0
		-- tcas_dis_2 = 0
		-- tcas_el_2 = 0
	elseif ai_plane == 3 then
		B738DR_tcas_box_show3 = 0
		B738DR_tcas_circle_show3 = 0
		B738DR_tcas_diam_show3 = 0
		B738DR_tcas_diam_e_show3 = 0
		-- tcas_dis_3 = 0
		-- tcas_el_3 = 0
	elseif ai_plane == 4 then
		B738DR_tcas_box_show4 = 0
		B738DR_tcas_circle_show4 = 0
		B738DR_tcas_diam_show4 = 0
		B738DR_tcas_diam_e_show4 = 0
		-- tcas_dis_4 = 0
		-- tcas_el_4 = 0
	elseif ai_plane == 5 then
		B738DR_tcas_box_show5 = 0
		B738DR_tcas_circle_show5 = 0
		B738DR_tcas_diam_show5 = 0
		B738DR_tcas_diam_e_show5 = 0
		-- tcas_dis_5 = 0
		-- tcas_el_5 = 0
	elseif ai_plane == 6 then
		B738DR_tcas_box_show6 = 0
		B738DR_tcas_circle_show6 = 0
		B738DR_tcas_diam_show6 = 0
		B738DR_tcas_diam_e_show6 = 0
	elseif ai_plane == 7 then
		B738DR_tcas_box_show7 = 0
		B738DR_tcas_circle_show7 = 0
		B738DR_tcas_diam_show7 = 0
		B738DR_tcas_diam_e_show7 = 0
	elseif ai_plane == 8 then
		B738DR_tcas_box_show8 = 0
		B738DR_tcas_circle_show8 = 0
		B738DR_tcas_diam_show8 = 0
		B738DR_tcas_diam_e_show8 = 0
	elseif ai_plane == 9 then
		B738DR_tcas_box_show9 = 0
		B738DR_tcas_circle_show9 = 0
		B738DR_tcas_diam_show9 = 0
		B738DR_tcas_diam_e_show9 = 0
	elseif ai_plane == 10 then
		B738DR_tcas_box_show10 = 0
		B738DR_tcas_circle_show10 = 0
		B738DR_tcas_diam_show10 = 0
		B738DR_tcas_diam_e_show10 = 0
	elseif ai_plane == 11 then
		B738DR_tcas_box_show11 = 0
		B738DR_tcas_circle_show11 = 0
		B738DR_tcas_diam_show11 = 0
		B738DR_tcas_diam_e_show11 = 0
	elseif ai_plane == 12 then
		B738DR_tcas_box_show12 = 0
		B738DR_tcas_circle_show12 = 0
		B738DR_tcas_diam_show12 = 0
		B738DR_tcas_diam_e_show12 = 0
	elseif ai_plane == 13 then
		B738DR_tcas_box_show13 = 0
		B738DR_tcas_circle_show13 = 0
		B738DR_tcas_diam_show13 = 0
		B738DR_tcas_diam_e_show13 = 0
	elseif ai_plane == 14 then
		B738DR_tcas_box_show14 = 0
		B738DR_tcas_circle_show14 = 0
		B738DR_tcas_diam_show14 = 0
		B738DR_tcas_diam_e_show14 = 0
	elseif ai_plane == 15 then
		B738DR_tcas_box_show15 = 0
		B738DR_tcas_circle_show15 = 0
		B738DR_tcas_diam_show15 = 0
		B738DR_tcas_diam_e_show15 = 0
	elseif ai_plane == 16 then
		B738DR_tcas_box_show16 = 0
		B738DR_tcas_circle_show16 = 0
		B738DR_tcas_diam_show16 = 0
		B738DR_tcas_diam_e_show16 = 0
	elseif ai_plane == 17 then
		B738DR_tcas_box_show17 = 0
		B738DR_tcas_circle_show17 = 0
		B738DR_tcas_diam_show17 = 0
		B738DR_tcas_diam_e_show17 = 0
	elseif ai_plane == 18 then
		B738DR_tcas_box_show18 = 0
		B738DR_tcas_circle_show18 = 0
		B738DR_tcas_diam_show10 = 0
		B738DR_tcas_diam_e_show18 = 0
	elseif ai_plane == 19 then
		B738DR_tcas_box_show19 = 0
		B738DR_tcas_circle_show19 = 0
		B738DR_tcas_diam_show19 = 0
		B738DR_tcas_diam_e_show19 = 0
	end
end

function B738_tcas_calc()
	tcas_tara = 1
end

function B738_tcas(ai_plane)

	local mag_hdg = 0 --simDR_mag_hdg - simDR_mag_variation
	local tcas_alt = 0
	local tcas_abs_alt = 0
	--local tcas_dis = 0
	local tcas_dis_old = 0
	local tcas_hdg = 0
	local tcas_x = 0
	local tcas_y = 0
	local tcas_lat2 = 0
	local tcas_lon2 = 0
	local tcas_el2 = 0
	local tcas_z = 0
	local tcas_el_old = 0
	local delta_hdg = 0
	local delta_el = 0
  local delta_elev = 0
	local tcas_on_off = 0
	local tcas_zoom = 0
	local tcas_traffic = 0
	local range_tau = 0
	local vertical_tau = 0
	local ta_tau = 0
	local ta_dmod = 0
	local ra_tau = 0
	local ra_dmod = 0
	local ta_zthr = 0
	local ra_zthr = 0
	local check_gl = 0
	
	tcas_dis = 99
	
	if ai_plane == 1 then
		tcas_lat2 = simDR_ai_1_lat
		tcas_lon2 = simDR_ai_1_lon
		tcas_el2 = simDR_ai_1_el
		tcas_z = simDR_ai_1_z
		if tcas_tara == 1 then
			tcas_dis_old = tcas_dis_1
			tcas_el_old = tcas_el_1
		end
	elseif ai_plane == 2 then
		tcas_lat2 = simDR_ai_2_lat
		tcas_lon2 = simDR_ai_2_lon
		tcas_el2 = simDR_ai_2_el
		tcas_z = simDR_ai_2_z
		if tcas_tara == 1 then
			tcas_dis_old = tcas_dis_2
			tcas_el_old = tcas_el_2
		end
	elseif ai_plane == 3 then
		tcas_lat2 = simDR_ai_3_lat
		tcas_lon2 = simDR_ai_3_lon
		tcas_el2 = simDR_ai_3_el
		tcas_z = simDR_ai_3_z
		if tcas_tara == 1 then
			tcas_dis_old = tcas_dis_3
			tcas_el_old = tcas_el_3
		end
	elseif ai_plane == 4 then
		tcas_lat2 = simDR_ai_4_lat
		tcas_lon2 = simDR_ai_4_lon
		tcas_el2 = simDR_ai_4_el
		tcas_z = simDR_ai_4_z
		if tcas_tara == 1 then
			tcas_dis_old = tcas_dis_4
			tcas_el_old = tcas_el_4
		end
	elseif ai_plane == 5 then
		tcas_lat2 = simDR_ai_5_lat
		tcas_lon2 = simDR_ai_5_lon
		tcas_el2 = simDR_ai_5_el
		tcas_z = simDR_ai_5_z
		if tcas_tara == 1 then
			tcas_dis_old = tcas_dis_5
			tcas_el_old = tcas_el_5
		end
	elseif ai_plane == 6 then
		tcas_lat2 = simDR_ai_6_lat
		tcas_lon2 = simDR_ai_6_lon
		tcas_el2 = simDR_ai_6_el
		tcas_z = simDR_ai_6_z
		if tcas_tara == 1 then
			tcas_dis_old = tcas_dis_6
			tcas_el_old = tcas_el_6
		end
	elseif ai_plane == 7 then
		tcas_lat2 = simDR_ai_7_lat
		tcas_lon2 = simDR_ai_7_lon
		tcas_el2 = simDR_ai_7_el
		tcas_z = simDR_ai_7_z
		if tcas_tara == 1 then
			tcas_dis_old = tcas_dis_7
			tcas_el_old = tcas_el_7
		end
	elseif ai_plane == 8 then
		tcas_lat2 = simDR_ai_8_lat
		tcas_lon2 = simDR_ai_8_lon
		tcas_el2 = simDR_ai_8_el
		tcas_z = simDR_ai_8_z
		if tcas_tara == 1 then
			tcas_dis_old = tcas_dis_8
			tcas_el_old = tcas_el_8
		end
	elseif ai_plane == 9 then
		tcas_lat2 = simDR_ai_9_lat
		tcas_lon2 = simDR_ai_9_lon
		tcas_el2 = simDR_ai_9_el
		tcas_z = simDR_ai_9_z
		if tcas_tara == 1 then
			tcas_dis_old = tcas_dis_9
			tcas_el_old = tcas_el_9
		end
	elseif ai_plane == 10 then
		tcas_lat2 = simDR_ai_10_lat
		tcas_lon2 = simDR_ai_10_lon
		tcas_el2 = simDR_ai_10_el
		tcas_z = simDR_ai_10_z
		if tcas_tara == 1 then
			tcas_dis_old = tcas_dis_10
			tcas_el_old = tcas_el_10
		end
	elseif ai_plane == 11 then
		tcas_lat2 = simDR_ai_11_lat
		tcas_lon2 = simDR_ai_11_lon
		tcas_el2 = simDR_ai_11_el
		tcas_z = simDR_ai_11_z
		if tcas_tara == 1 then
			tcas_dis_old = tcas_dis_11
			tcas_el_old = tcas_el_11
		end
	elseif ai_plane == 12 then
		tcas_lat2 = simDR_ai_12_lat
		tcas_lon2 = simDR_ai_12_lon
		tcas_el2 = simDR_ai_12_el
		tcas_z = simDR_ai_12_z
		if tcas_tara == 1 then
			tcas_dis_old = tcas_dis_12
			tcas_el_old = tcas_el_12
		end
	elseif ai_plane == 13 then
		tcas_lat2 = simDR_ai_13_lat
		tcas_lon2 = simDR_ai_13_lon
		tcas_el2 = simDR_ai_13_el
		tcas_z = simDR_ai_13_z
		if tcas_tara == 1 then
			tcas_dis_old = tcas_dis_13
			tcas_el_old = tcas_el_13
		end
	elseif ai_plane == 14 then
		tcas_lat2 = simDR_ai_14_lat
		tcas_lon2 = simDR_ai_14_lon
		tcas_el2 = simDR_ai_14_el
		tcas_z = simDR_ai_14_z
		if tcas_tara == 1 then
			tcas_dis_old = tcas_dis_14
			tcas_el_old = tcas_el_14
		end
	elseif ai_plane == 15 then
		tcas_lat2 = simDR_ai_15_lat
		tcas_lon2 = simDR_ai_15_lon
		tcas_el2 = simDR_ai_15_el
		tcas_z = simDR_ai_15_z
		if tcas_tara == 1 then
			tcas_dis_old = tcas_dis_15
			tcas_el_old = tcas_el_15
		end
	elseif ai_plane == 16 then
		tcas_lat2 = simDR_ai_16_lat
		tcas_lon2 = simDR_ai_16_lon
		tcas_el2 = simDR_ai_16_el
		tcas_z = simDR_ai_16_z
		if tcas_tara == 1 then
			tcas_dis_old = tcas_dis_16
			tcas_el_old = tcas_el_16
		end
	elseif ai_plane == 17 then
		tcas_lat2 = simDR_ai_17_lat
		tcas_lon2 = simDR_ai_17_lon
		tcas_el2 = simDR_ai_17_el
		tcas_z = simDR_ai_17_z
		if tcas_tara == 1 then
			tcas_dis_old = tcas_dis_17
			tcas_el_old = tcas_el_17
		end
	elseif ai_plane == 18 then
		tcas_lat2 = simDR_ai_18_lat
		tcas_lon2 = simDR_ai_18_lon
		tcas_el2 = simDR_ai_18_el
		tcas_z = simDR_ai_18_z
		if tcas_tara == 1 then
			tcas_dis_old = tcas_dis_18
			tcas_el_old = tcas_el_18
		end
	elseif ai_plane == 19 then
		tcas_lat2 = simDR_ai_19_lat
		tcas_lon2 = simDR_ai_19_lon
		tcas_el2 = simDR_ai_19_el
		tcas_z = simDR_ai_19_z
		if tcas_tara == 1 then
			tcas_dis_old = tcas_dis_19
			tcas_el_old = tcas_el_19
		end
	end

	tcas_alt = tcas_el2 - tcas_el
	tcas_alt = tcas_alt * 3.2808399
	tcas_alt = tcas_alt / 100
	
	if tcas_alt >= -99 and tcas_alt <= 99 and tcas_z ~= 0 and B738DR_transponder_knob_pos > 0 then
		
		tcas_lat2 = math.rad(tcas_lat2)
		tcas_lon2 = math.rad(tcas_lon2)
		
		tcas_x = (tcas_lon2 - tcas_lon) * math.cos((tcas_lat + tcas_lat2)/2)
		tcas_y = tcas_lat2 - tcas_lat
		tcas_dis = math.sqrt(tcas_x*tcas_x + tcas_y*tcas_y) * 3440.064795	--nm
		
		if tcas_dis < 40 then
		
			if tcas_tara == 1 then
				tcas_abs_alt = (tcas_el2 - tcas_el) * 3.2808399		-- feet --tcas_alt
				if tcas_abs_alt < 0 then
					tcas_abs_alt = -tcas_abs_alt
				end
				
				if simDR_radio_height_pilot_ft < 1000 then
					ta_tau = 20
					ta_dmod = 0.30
					ra_tau = 0
					ra_dmod = 0
				elseif simDR_radio_height_pilot_ft < 2350 then
					ta_tau = 25
					ta_dmod = 0.33
					ra_tau = 15
					ra_dmod = 0.20
				elseif simDR_altitude_pilot < 5000 then
					ta_tau = 30
					ta_dmod = 0.48
					ra_tau = 20
					ra_dmod = 0.35
				elseif simDR_altitude_pilot < 10000 then
					ta_tau = 40
					ta_dmod = 0.75
					ra_tau = 25
					ra_dmod = 0.55
				elseif simDR_altitude_pilot < 20000 then
					ta_tau = 45
					ta_dmod = 1.00
					ra_tau = 30
					ra_dmod = 0.80
				else
					ta_tau = 48
					ta_dmod = 1.30
					ra_tau = 35
					ra_dmod = 1.1
				end
				ta_zthr = 850
				ra_zthr = 600
				if simDR_altitude_pilot > 20000 then
					ra_zthr = 700
				end
				
				-- range tau
				tcas_x = (tcas_dis_old - tcas_dis) * 1852	-- delta horizontal distance in meters
				if tcas_x > 0 then
					tcas_y = tcas_x / 2		-- closing speed m/s (every 2 seconds)
					range_tau = (tcas_dis * 1852) / tcas_y		-- seconds to CPA
				else
					range_tau = 100
				end
				
				--vertical tau
				tcas_x = (tcas_el - tcas_el_0) / 2			-- vertical speed m/s
				tcas_y = (tcas_el2 - tcas_el_old) / 2		-- intruder vertical speed m/s
				if tcas_el2 > tcas_el then		-- above
					tcas_x = tcas_x - tcas_y	-- closing vertical speed m/s
				else
					tcas_x = tcas_y - tcas_x	-- closing vertical speed m/s
				end
				if tcas_x > 0 then
					tcas_y = tcas_el - tcas_el2
					if tcas_y < 0 then
						tcas_y = -tcas_y		-- delta elv distance in meters
					end
					vertical_tau = tcas_y / tcas_x		-- seconds to CPA
				else
					vertical_tau = 100
				end
				--***-----
					if ai_plane == B738DR_tcas_test2 then
						B738DR_tcas_test = range_tau
					end
				--***-----
				
				-- calc traffic
				if tcas_dis > 6 and tcas_abs_alt > 1200 then
					-- other traffic
					tcas_traffic = 0
				else
					-- proximate traffic
					tcas_traffic = 1
					
					-- check declared on ground
					check_gl = 0
					if simDR_radio_height_pilot_ft < 1750 then
						tcas_x = (tcas_el / simDR_radio_height_pilot_ft) * 360	--bellow 360 ft RA declared on ground
						if tcas_el2 < tcas_x then
							check_gl = 1
						end
					end
					
					if check_gl == 0 then
					-- TA traffic
						tcas_x = 0
						tcas_y = 0
						if range_tau < ta_tau or tcas_dis < ta_dmod then
							tcas_x = 1
						end
						if vertical_tau < ta_tau or tcas_abs_alt < ta_zthr then
							tcas_y = 1
						end
						if tcas_x == 1 and tcas_y == 1 then
							tcas_traffic = 2
						end
						-- RA traffic
						if ra_tau > 0 then		-- below 1000 ft AGL no RAs
							tcas_x = 0
							tcas_y = 0
							if range_tau < ra_tau or tcas_dis < ra_dmod then
								tcas_x = 1
							end
							if vertical_tau < ra_tau or tcas_abs_alt < ra_zthr then
								tcas_y = 1
							end
							if tcas_x == 1 and tcas_y == 1 then
								tcas_traffic = 3
							end
						end
					end
				end
			end
			
			
			if B738DR_capt_map_mode < 2 then
				mag_hdg = simDR_ahars_mag_hdg - simDR_mag_variation
			elseif B738DR_capt_map_mode == 2 then
				if B738DR_track_up == 0 then
					mag_hdg = simDR_ahars_mag_hdg - simDR_mag_variation
				else
					if B738DR_track_up_active == 0 then
						mag_hdg = simDR_ahars_mag_hdg - simDR_mag_variation
					else
						mag_hdg = simDR_mag_hdg - simDR_mag_variation
					end
				end
			else
				mag_hdg = simDR_mag_hdg - simDR_mag_variation
			end
			
			
			tcas_y = math.sin(tcas_lon2 - tcas_lon) * math.cos(tcas_lat2)
			tcas_x = math.cos(tcas_lat) * math.sin(tcas_lat2) - math.sin(tcas_lat) * math.cos(tcas_lat2) * math.cos(tcas_lon2 - tcas_lon)
			tcas_hdg = math.atan2(tcas_y, tcas_x)
			tcas_hdg = math.deg(tcas_hdg)
			tcas_hdg = (tcas_hdg + 360) % 360
			
			delta_hdg = ((((tcas_hdg - mag_hdg) % 360) + 540) % 360) - 180
			
			if delta_hdg >= 0 and delta_hdg <= 90 then
				-- right
				tcas_on_off = 1
				delta_hdg = 90 - delta_hdg
				delta_hdg = math.rad(delta_hdg)
				tcas_y = tcas_dis * math.sin(delta_hdg)
				tcas_x = tcas_dis * math.cos(delta_hdg)
			elseif delta_hdg < 0 and delta_hdg >= -90 then
				-- left
				tcas_on_off = 1
				delta_hdg = 90 + delta_hdg
				delta_hdg = math.rad(delta_hdg)
				tcas_y = tcas_dis * math.sin(delta_hdg)
				tcas_x = -tcas_dis * math.cos(delta_hdg)
			elseif delta_hdg > 90 then
				-- right back
				tcas_on_off = 1
				if tcas_traffic == 3 then
					if tcas_dis > ra_dmod and tcas_abs_alt > ra_zthr then
						tcas_traffic = 2
					end
				end
				if tcas_traffic == 2 then
					if tcas_dis > ta_dmod and tcas_abs_alt > ta_zthr then
						tcas_traffic = 1
					end
				end
				delta_hdg = delta_hdg - 90
				delta_hdg = math.rad(delta_hdg)
				tcas_y = -tcas_dis * math.sin(delta_hdg)
				tcas_x = tcas_dis * math.cos(delta_hdg)
			elseif delta_hdg < -90 then
				-- left back
				tcas_on_off = 1
				if tcas_traffic == 3 then
					if tcas_dis > ra_dmod and tcas_abs_alt > ra_zthr then
						tcas_traffic = 2
					end
				end
				if tcas_traffic == 2 then
					if tcas_dis > ta_dmod and tcas_abs_alt > ta_zthr then
						tcas_traffic = 1
					end
				end
				delta_hdg = -90 - delta_hdg
				delta_hdg = math.rad(delta_hdg)
				tcas_y = -tcas_dis * math.sin(delta_hdg)
				tcas_x = -tcas_dis * math.cos(delta_hdg)
			end
			
			if B738DR_efis_map_range_capt == 0 then	-- 5 NM
				tcas_zoom = 2
			elseif B738DR_efis_map_range_capt == 1 then	-- 10 NM
				tcas_zoom = 1
			elseif B738DR_efis_map_range_capt == 2 then	-- 20 NM
				tcas_zoom = 0.5
			elseif B738DR_efis_map_range_capt == 3 then	-- 40 NM
				tcas_zoom = 0.25
			elseif B738DR_efis_map_range_capt == 4 then	-- 80 NM
				tcas_zoom = 0.125
			else
				tcas_on_off = 0
			end
			
			tcas_x = tcas_x * tcas_zoom		-- zoom
			tcas_y = tcas_y * tcas_zoom		-- zoom
			
			if tcas_y > 7.5 or tcas_y < -2 then
				tcas_on_off = 0
			end
			if tcas_x < -6.0 or tcas_x > 6.0 then
				tcas_on_off = 0
			end
			
			-- if simDR_map_mode_is_HSI == 1 then
				-- tcas_y = tcas_y + 5
			-- end
			
			if ai_plane == 1 then
			
				B738DR_tcas_x = tcas_x --* tcas_zoom		-- zoom
				B738DR_tcas_y = tcas_y --* tcas_zoom		-- zoom
				
				tcas_alt = math.floor(tcas_alt + 0.5)
				-- if tcas_alt == 0 then
					-- B738DR_tcas_alt = ""
					-- B738DR_tcas_alt_up_show = 0
					-- B738DR_tcas_alt_dn_show = 0
				if tcas_alt >= 0 then
					B738DR_tcas_alt = "+" .. string.sub(string.format("%03d", tcas_alt), 2, 3)
					B738DR_tcas_alt_up_show = 1
					B738DR_tcas_alt_dn_show = 0
				elseif tcas_alt < 0 then
					B738DR_tcas_alt = string.format("%03d", tcas_alt)
					B738DR_tcas_alt_up_show = 0
					B738DR_tcas_alt_dn_show = 1
				end
			
				if tcas_tara == 1 then
					delta_elev = tcas_el2 - tcas_el_old
					delta_elev = ((delta_elev * 3.2808399) / 2) * 60		-- vvi
					if delta_elev > 500 then
						B738DR_tcas_arr_up_show = 1
						B738DR_tcas_arr_dn_show = 0
					elseif delta_elev < -500 then
						B738DR_tcas_arr_up_show = 0
						B738DR_tcas_arr_dn_show = 1
					else
						B738DR_tcas_arr_up_show = 0
						B738DR_tcas_arr_dn_show = 0
					end
					
					tcas_dis_1 = tcas_dis
					tcas_el_1 = tcas_el2
					
					if tcas_traffic == 0 then
						-- other traffic
						B738DR_tcas_box_show = 0
						B738DR_tcas_circle_show = 0
						B738DR_tcas_diam_show = 0
						B738DR_tcas_diam_e_show = 1
					elseif tcas_traffic == 1 then
						-- proximate traffic
						B738DR_tcas_box_show = 0
						B738DR_tcas_circle_show = 0
						B738DR_tcas_diam_show = 1
						B738DR_tcas_diam_e_show = 0
					elseif tcas_traffic == 2 then
						-- TA traffic
						B738DR_tcas_box_show = 0
						B738DR_tcas_circle_show = 1
						B738DR_tcas_diam_show = 0
						B738DR_tcas_diam_e_show = 0
					elseif tcas_traffic == 3 then
						-- RA traffic
						B738DR_tcas_box_show = 1
						B738DR_tcas_circle_show = 0
						B738DR_tcas_diam_show = 0
						B738DR_tcas_diam_e_show = 0
					end
				end
			
			elseif ai_plane == 2 then
			
				B738DR_tcas_x2 = tcas_x --* tcas_zoom		-- zoom
				B738DR_tcas_y2 = tcas_y --* tcas_zoom		-- zoom
				
				tcas_alt = math.floor(tcas_alt + 0.5)
				-- if tcas_alt == 0 then
					-- B738DR_tcas_alt = ""
					-- B738DR_tcas_alt_up_show = 0
					-- B738DR_tcas_alt_dn_show = 0
				if tcas_alt >= 0 then
					B738DR_tcas_alt2 = "+" .. string.sub(string.format("%03d", tcas_alt), 2, 3)
					B738DR_tcas_alt_up_show2 = 1
					B738DR_tcas_alt_dn_show2 = 0
				elseif tcas_alt < 0 then
					B738DR_tcas_alt2 = string.format("%03d", tcas_alt)
					B738DR_tcas_alt_up_show2 = 0
					B738DR_tcas_alt_dn_show2 = 1
				end
			
				if tcas_tara == 1 then
					delta_elev = tcas_el2 - tcas_el_old
					delta_elev = ((delta_elev * 3.2808399) / 2) * 60		-- vvi
					if delta_elev > 500 then
						B738DR_tcas_arr_up_show2 = 1
						B738DR_tcas_arr_dn_show2 = 0
					elseif delta_elev < -500 then
						B738DR_tcas_arr_up_show2 = 0
						B738DR_tcas_arr_dn_show2 = 1
					else
						B738DR_tcas_arr_up_show2 = 0
						B738DR_tcas_arr_dn_show2 = 0
					end
					
					tcas_dis_2 = tcas_dis
					tcas_el_2 = tcas_el2
					
					if tcas_traffic == 0 then
						-- other traffic
						B738DR_tcas_box_show2 = 0
						B738DR_tcas_circle_show2 = 0
						B738DR_tcas_diam_show2 = 0
						B738DR_tcas_diam_e_show2 = 1
					elseif tcas_traffic == 1 then
						-- proximate traffic
						B738DR_tcas_box_show2 = 0
						B738DR_tcas_circle_show2 = 0
						B738DR_tcas_diam_show2 = 1
						B738DR_tcas_diam_e_show2 = 0
					elseif tcas_traffic == 2 then
						-- TA traffic
						B738DR_tcas_box_show2 = 0
						B738DR_tcas_circle_show2 = 1
						B738DR_tcas_diam_show2 = 0
						B738DR_tcas_diam_e_show2 = 0
					elseif tcas_traffic == 3 then
						-- RA traffic
						B738DR_tcas_box_show2 = 1
						B738DR_tcas_circle_show2 = 0
						B738DR_tcas_diam_show2 = 0
						B738DR_tcas_diam_e_show2 = 0
					end
				end
			
			elseif ai_plane == 3 then
			
				B738DR_tcas_x3 = tcas_x --* tcas_zoom		-- zoom
				B738DR_tcas_y3 = tcas_y --* tcas_zoom		-- zoom
				
				tcas_alt = math.floor(tcas_alt + 0.5)
				-- if tcas_alt == 0 then
					-- B738DR_tcas_alt = ""
					-- B738DR_tcas_alt_up_show = 0
					-- B738DR_tcas_alt_dn_show = 0
				if tcas_alt >= 0 then
					B738DR_tcas_alt3 = "+" .. string.sub(string.format("%03d", tcas_alt), 2, 3)
					B738DR_tcas_alt_up_show3 = 1
					B738DR_tcas_alt_dn_show3 = 0
				elseif tcas_alt < 0 then
					B738DR_tcas_alt3 = string.format("%03d", tcas_alt)
					B738DR_tcas_alt_up_show3 = 0
					B738DR_tcas_alt_dn_show3 = 1
				end
				
				if tcas_tara == 1 then
					delta_elev = tcas_el2 - tcas_el_old
					delta_elev = ((delta_elev * 3.2808399) / 2) * 60		-- vvi
					if delta_elev > 500 then
						B738DR_tcas_arr_up_show3 = 1
						B738DR_tcas_arr_dn_show3 = 0
					elseif delta_elev < -500 then
						B738DR_tcas_arr_up_show3 = 0
						B738DR_tcas_arr_dn_show3 = 1
					else
						B738DR_tcas_arr_up_show3 = 0
						B738DR_tcas_arr_dn_show3 = 0
					end
					
					tcas_dis_3 = tcas_dis
					tcas_el_3 = tcas_el2
					
					if tcas_traffic == 0 then
						-- other traffic
						B738DR_tcas_box_show3 = 0
						B738DR_tcas_circle_show3 = 0
						B738DR_tcas_diam_show3 = 0
						B738DR_tcas_diam_e_show3 = 1
					elseif tcas_traffic == 1 then
						-- proximate traffic
						B738DR_tcas_box_show3 = 0
						B738DR_tcas_circle_show3 = 0
						B738DR_tcas_diam_show3 = 1
						B738DR_tcas_diam_e_show3 = 0
					elseif tcas_traffic == 2 then
						-- TA traffic
						B738DR_tcas_box_show3 = 0
						B738DR_tcas_circle_show3 = 1
						B738DR_tcas_diam_show3 = 0
						B738DR_tcas_diam_e_show3 = 0
					elseif tcas_traffic == 3 then
						-- RA traffic
						B738DR_tcas_box_show3 = 1
						B738DR_tcas_circle_show3 = 0
						B738DR_tcas_diam_show3 = 0
						B738DR_tcas_diam_e_show3 = 0
					end
				end
				
			elseif ai_plane == 4 then
			
				B738DR_tcas_x4 = tcas_x --* tcas_zoom		-- zoom
				B738DR_tcas_y4 = tcas_y --* tcas_zoom		-- zoom
				
				tcas_alt = math.floor(tcas_alt + 0.5)
				-- if tcas_alt == 0 then
					-- B738DR_tcas_alt = ""
					-- B738DR_tcas_alt_up_show = 0
					-- B738DR_tcas_alt_dn_show = 0
				if tcas_alt >= 0 then
					B738DR_tcas_alt4 = "+" .. string.sub(string.format("%03d", tcas_alt), 2, 3)
					B738DR_tcas_alt_up_show4 = 1
					B738DR_tcas_alt_dn_show4 = 0
				elseif tcas_alt < 0 then
					B738DR_tcas_alt4 = string.format("%03d", tcas_alt)
					B738DR_tcas_alt_up_show4 = 0
					B738DR_tcas_alt_dn_show4 = 1
				end
			
				if tcas_tara == 1 then
					delta_elev = tcas_el2 - tcas_el_old
					delta_elev = ((delta_elev * 3.2808399) / 2) * 60		-- vvi
					if delta_elev > 500 then
						B738DR_tcas_arr_up_show4 = 1
						B738DR_tcas_arr_dn_show4 = 0
					elseif delta_elev < -500 then
						B738DR_tcas_arr_up_show4 = 0
						B738DR_tcas_arr_dn_show4 = 1
					else
						B738DR_tcas_arr_up_show4 = 0
						B738DR_tcas_arr_dn_show4 = 0
					end
					
					tcas_dis_4 = tcas_dis
					tcas_el_4 = tcas_el2
					
					if tcas_traffic == 0 then
						-- other traffic
						B738DR_tcas_box_show4 = 0
						B738DR_tcas_circle_show4 = 0
						B738DR_tcas_diam_show4 = 0
						B738DR_tcas_diam_e_show4 = 1
					elseif tcas_traffic == 1 then
						-- proximate traffic
						B738DR_tcas_box_show4 = 0
						B738DR_tcas_circle_show4 = 0
						B738DR_tcas_diam_show4 = 1
						B738DR_tcas_diam_e_show4 = 0
					elseif tcas_traffic == 2 then
						-- TA traffic
						B738DR_tcas_box_show4 = 0
						B738DR_tcas_circle_show4 = 1
						B738DR_tcas_diam_show4 = 0
						B738DR_tcas_diam_e_show4 = 0
					elseif tcas_traffic == 3 then
						-- RA traffic
						B738DR_tcas_box_show4 = 1
						B738DR_tcas_circle_show4 = 0
						B738DR_tcas_diam_show4 = 0
						B738DR_tcas_diam_e_show4 = 0
					end
				end
			
			elseif ai_plane == 5 then
			
				B738DR_tcas_x5 = tcas_x --* tcas_zoom		-- zoom
				B738DR_tcas_y5 = tcas_y --* tcas_zoom		-- zoom
				
				tcas_alt = math.floor(tcas_alt + 0.5)
				-- if tcas_alt == 0 then
					-- B738DR_tcas_alt = ""
					-- B738DR_tcas_alt_up_show = 0
					-- B738DR_tcas_alt_dn_show = 0
				if tcas_alt >= 0 then
					B738DR_tcas_alt5 = "+" .. string.sub(string.format("%03d", tcas_alt), 2, 3)
					B738DR_tcas_alt_up_show5 = 1
					B738DR_tcas_alt_dn_show5 = 0
				elseif tcas_alt < 0 then
					B738DR_tcas_alt5 = string.format("%03d", tcas_alt)
					B738DR_tcas_alt_up_show5 = 0
					B738DR_tcas_alt_dn_show5 = 1
				end
			
				if tcas_tara == 1 then
					delta_elev = tcas_el2 - tcas_el_old
					delta_elev = ((delta_elev * 3.2808399) / 2) * 60		-- vvi
					if delta_elev > 500 then
						B738DR_tcas_arr_up_show5 = 1
						B738DR_tcas_arr_dn_show5 = 0
					elseif delta_elev < -500 then
						B738DR_tcas_arr_up_show5 = 0
						B738DR_tcas_arr_dn_show5 = 1
					else
						B738DR_tcas_arr_up_show5 = 0
						B738DR_tcas_arr_dn_show5 = 0
					end
					
					tcas_dis_5 = tcas_dis
					tcas_el_5 = tcas_el2
					
					if tcas_traffic == 0 then
						-- other traffic
						B738DR_tcas_box_show5 = 0
						B738DR_tcas_circle_show5 = 0
						B738DR_tcas_diam_show5 = 0
						B738DR_tcas_diam_e_show5 = 1
					elseif tcas_traffic == 1 then
						-- proximate traffic
						B738DR_tcas_box_show5 = 0
						B738DR_tcas_circle_show5 = 0
						B738DR_tcas_diam_show5 = 1
						B738DR_tcas_diam_e_show5 = 0
					elseif tcas_traffic == 2 then
						-- TA traffic
						B738DR_tcas_box_show5 = 0
						B738DR_tcas_circle_show5 = 1
						B738DR_tcas_diam_show5 = 0
						B738DR_tcas_diam_e_show5 = 0
					elseif tcas_traffic == 3 then
						-- RA traffic
						B738DR_tcas_box_show5 = 1
						B738DR_tcas_circle_show5 = 0
						B738DR_tcas_diam_show5 = 0
						B738DR_tcas_diam_e_show5 = 0
					end
				end
			
			elseif ai_plane == 6 then
			
				B738DR_tcas_x6 = tcas_x --* tcas_zoom		-- zoom
				B738DR_tcas_y6 = tcas_y --* tcas_zoom		-- zoom
				
				tcas_alt = math.floor(tcas_alt + 0.5)
				-- if tcas_alt == 0 then
					-- B738DR_tcas_alt = ""
					-- B738DR_tcas_alt_up_show = 0
					-- B738DR_tcas_alt_dn_show = 0
				if tcas_alt >= 0 then
					B738DR_tcas_alt6 = "+" .. string.sub(string.format("%03d", tcas_alt), 2, 3)
					B738DR_tcas_alt_up_show6 = 1
					B738DR_tcas_alt_dn_show6 = 0
				elseif tcas_alt < 0 then
					B738DR_tcas_alt6 = string.format("%03d", tcas_alt)
					B738DR_tcas_alt_up_show6 = 0
					B738DR_tcas_alt_dn_show6 = 1
				end
			
				if tcas_tara == 1 then
					delta_elev = tcas_el2 - tcas_el_old
					delta_elev = ((delta_elev * 3.2808399) / 2) * 60		-- vvi
					if delta_elev > 500 then
						B738DR_tcas_arr_up_show6 = 1
						B738DR_tcas_arr_dn_show6 = 0
					elseif delta_elev < -500 then
						B738DR_tcas_arr_up_show6 = 0
						B738DR_tcas_arr_dn_show6 = 1
					else
						B738DR_tcas_arr_up_show6 = 0
						B738DR_tcas_arr_dn_show6 = 0
					end
					
					tcas_dis_6 = tcas_dis
					tcas_el_6 = tcas_el2
					
					if tcas_traffic == 0 then
						-- other traffic
						B738DR_tcas_box_show6 = 0
						B738DR_tcas_circle_show6 = 0
						B738DR_tcas_diam_show6 = 0
						B738DR_tcas_diam_e_show6 = 1
					elseif tcas_traffic == 1 then
						-- proximate traffic
						B738DR_tcas_box_show6 = 0
						B738DR_tcas_circle_show6 = 0
						B738DR_tcas_diam_show6 = 1
						B738DR_tcas_diam_e_show6 = 0
					elseif tcas_traffic == 2 then
						-- TA traffic
						B738DR_tcas_box_show6 = 0
						B738DR_tcas_circle_show6 = 1
						B738DR_tcas_diam_show6 = 0
						B738DR_tcas_diam_e_show6 = 0
					elseif tcas_traffic == 3 then
						-- RA traffic
						B738DR_tcas_box_show6 = 1
						B738DR_tcas_circle_show6 = 0
						B738DR_tcas_diam_show6 = 0
						B738DR_tcas_diam_e_show6 = 0
					end
				end
			
			elseif ai_plane == 7 then
			
				B738DR_tcas_x7 = tcas_x --* tcas_zoom		-- zoom
				B738DR_tcas_y7 = tcas_y --* tcas_zoom		-- zoom
				
				tcas_alt = math.floor(tcas_alt + 0.5)
				-- if tcas_alt == 0 then
					-- B738DR_tcas_alt = ""
					-- B738DR_tcas_alt_up_show = 0
					-- B738DR_tcas_alt_dn_show = 0
				if tcas_alt >= 0 then
					B738DR_tcas_alt7 = "+" .. string.sub(string.format("%03d", tcas_alt), 2, 3)
					B738DR_tcas_alt_up_show7 = 1
					B738DR_tcas_alt_dn_show7 = 0
				elseif tcas_alt < 0 then
					B738DR_tcas_alt7 = string.format("%03d", tcas_alt)
					B738DR_tcas_alt_up_show7 = 0
					B738DR_tcas_alt_dn_show7 = 1
				end
			
				if tcas_tara == 1 then
					delta_elev = tcas_el2 - tcas_el_old
					delta_elev = ((delta_elev * 3.2808399) / 2) * 60		-- vvi
					if delta_elev > 500 then
						B738DR_tcas_arr_up_show7 = 1
						B738DR_tcas_arr_dn_show7 = 0
					elseif delta_elev < -500 then
						B738DR_tcas_arr_up_show7 = 0
						B738DR_tcas_arr_dn_show7 = 1
					else
						B738DR_tcas_arr_up_show7 = 0
						B738DR_tcas_arr_dn_show7 = 0
					end
					
					tcas_dis_7 = tcas_dis
					tcas_el_7 = tcas_el2
					
					if tcas_traffic == 0 then
						-- other traffic
						B738DR_tcas_box_show7 = 0
						B738DR_tcas_circle_show7 = 0
						B738DR_tcas_diam_show7 = 0
						B738DR_tcas_diam_e_show7 = 1
					elseif tcas_traffic == 1 then
						-- proximate traffic
						B738DR_tcas_box_show7 = 0
						B738DR_tcas_circle_show7 = 0
						B738DR_tcas_diam_show7 = 1
						B738DR_tcas_diam_e_show7 = 0
					elseif tcas_traffic == 2 then
						-- TA traffic
						B738DR_tcas_box_show7 = 0
						B738DR_tcas_circle_show7 = 1
						B738DR_tcas_diam_show7 = 0
						B738DR_tcas_diam_e_show7 = 0
					elseif tcas_traffic == 3 then
						-- RA traffic
						B738DR_tcas_box_show7 = 1
						B738DR_tcas_circle_show7 = 0
						B738DR_tcas_diam_show7 = 0
						B738DR_tcas_diam_e_show7 = 0
					end
				end
			
			elseif ai_plane == 8 then
			
				B738DR_tcas_x8 = tcas_x --* tcas_zoom		-- zoom
				B738DR_tcas_y8 = tcas_y --* tcas_zoom		-- zoom
				
				tcas_alt = math.floor(tcas_alt + 0.5)
				-- if tcas_alt == 0 then
					-- B738DR_tcas_alt = ""
					-- B738DR_tcas_alt_up_show = 0
					-- B738DR_tcas_alt_dn_show = 0
				if tcas_alt >= 0 then
					B738DR_tcas_alt8 = "+" .. string.sub(string.format("%03d", tcas_alt), 2, 3)
					B738DR_tcas_alt_up_show8 = 1
					B738DR_tcas_alt_dn_show8 = 0
				elseif tcas_alt < 0 then
					B738DR_tcas_alt8 = string.format("%03d", tcas_alt)
					B738DR_tcas_alt_up_show8 = 0
					B738DR_tcas_alt_dn_show8 = 1
				end
			
				if tcas_tara == 1 then
					delta_elev = tcas_el2 - tcas_el_old
					delta_elev = ((delta_elev * 3.2808399) / 2) * 60		-- vvi
					if delta_elev > 500 then
						B738DR_tcas_arr_up_show8 = 1
						B738DR_tcas_arr_dn_show8 = 0
					elseif delta_elev < -500 then
						B738DR_tcas_arr_up_show8 = 0
						B738DR_tcas_arr_dn_show8 = 1
					else
						B738DR_tcas_arr_up_show8 = 0
						B738DR_tcas_arr_dn_show8 = 0
					end
					
					tcas_dis_8 = tcas_dis
					tcas_el_8 = tcas_el2
					
					if tcas_traffic == 0 then
						-- other traffic
						B738DR_tcas_box_show8 = 0
						B738DR_tcas_circle_show8 = 0
						B738DR_tcas_diam_show8 = 0
						B738DR_tcas_diam_e_show8 = 1
					elseif tcas_traffic == 1 then
						-- proximate traffic
						B738DR_tcas_box_show8 = 0
						B738DR_tcas_circle_show8 = 0
						B738DR_tcas_diam_show8 = 1
						B738DR_tcas_diam_e_show8 = 0
					elseif tcas_traffic == 2 then
						-- TA traffic
						B738DR_tcas_box_show8 = 0
						B738DR_tcas_circle_show8 = 1
						B738DR_tcas_diam_show8 = 0
						B738DR_tcas_diam_e_show8 = 0
					elseif tcas_traffic == 3 then
						-- RA traffic
						B738DR_tcas_box_show8 = 1
						B738DR_tcas_circle_show8 = 0
						B738DR_tcas_diam_show8 = 0
						B738DR_tcas_diam_e_show8 = 0
					end
				end
			
			elseif ai_plane == 9 then
			
				B738DR_tcas_x9 = tcas_x --* tcas_zoom		-- zoom
				B738DR_tcas_y9 = tcas_y --* tcas_zoom		-- zoom
				
				tcas_alt = math.floor(tcas_alt + 0.5)
				-- if tcas_alt == 0 then
					-- B738DR_tcas_alt = ""
					-- B738DR_tcas_alt_up_show = 0
					-- B738DR_tcas_alt_dn_show = 0
				if tcas_alt >= 0 then
					B738DR_tcas_alt9 = "+" .. string.sub(string.format("%03d", tcas_alt), 2, 3)
					B738DR_tcas_alt_up_show9 = 1
					B738DR_tcas_alt_dn_show9 = 0
				elseif tcas_alt < 0 then
					B738DR_tcas_alt9 = string.format("%03d", tcas_alt)
					B738DR_tcas_alt_up_show9 = 0
					B738DR_tcas_alt_dn_show9 = 1
				end
			
				if tcas_tara == 1 then
					delta_elev = tcas_el2 - tcas_el_old
					delta_elev = ((delta_elev * 3.2808399) / 2) * 60		-- vvi
					if delta_elev > 500 then
						B738DR_tcas_arr_up_show9 = 1
						B738DR_tcas_arr_dn_show9 = 0
					elseif delta_elev < -500 then
						B738DR_tcas_arr_up_show9 = 0
						B738DR_tcas_arr_dn_show9 = 1
					else
						B738DR_tcas_arr_up_show9 = 0
						B738DR_tcas_arr_dn_show9 = 0
					end
					
					tcas_dis_9 = tcas_dis
					tcas_el_9 = tcas_el2
					
					if tcas_traffic == 0 then
						-- other traffic
						B738DR_tcas_box_show9 = 0
						B738DR_tcas_circle_show9 = 0
						B738DR_tcas_diam_show9 = 0
						B738DR_tcas_diam_e_show9 = 1
					elseif tcas_traffic == 1 then
						-- proximate traffic
						B738DR_tcas_box_show9 = 0
						B738DR_tcas_circle_show9 = 0
						B738DR_tcas_diam_show9 = 1
						B738DR_tcas_diam_e_show9 = 0
					elseif tcas_traffic == 2 then
						-- TA traffic
						B738DR_tcas_box_show9 = 0
						B738DR_tcas_circle_show9 = 1
						B738DR_tcas_diam_show9 = 0
						B738DR_tcas_diam_e_show9 = 0
					elseif tcas_traffic == 3 then
						-- RA traffic
						B738DR_tcas_box_show9 = 1
						B738DR_tcas_circle_show9 = 0
						B738DR_tcas_diam_show9 = 0
						B738DR_tcas_diam_e_show9 = 0
					end
				end
			
			elseif ai_plane == 10 then
			
				B738DR_tcas_x10 = tcas_x --* tcas_zoom		-- zoom
				B738DR_tcas_y10 = tcas_y --* tcas_zoom		-- zoom
				
				tcas_alt = math.floor(tcas_alt + 0.5)
				-- if tcas_alt == 0 then
					-- B738DR_tcas_alt = ""
					-- B738DR_tcas_alt_up_show = 0
					-- B738DR_tcas_alt_dn_show = 0
				if tcas_alt >= 0 then
					B738DR_tcas_alt10 = "+" .. string.sub(string.format("%03d", tcas_alt), 2, 3)
					B738DR_tcas_alt_up_show10 = 1
					B738DR_tcas_alt_dn_show10 = 0
				elseif tcas_alt < 0 then
					B738DR_tcas_alt10 = string.format("%03d", tcas_alt)
					B738DR_tcas_alt_up_show10 = 0
					B738DR_tcas_alt_dn_show10 = 1
				end
			
				if tcas_tara == 1 then
					delta_elev = tcas_el2 - tcas_el_old
					delta_elev = ((delta_elev * 3.2808399) / 2) * 60		-- vvi
					if delta_elev > 500 then
						B738DR_tcas_arr_up_show10 = 1
						B738DR_tcas_arr_dn_show10 = 0
					elseif delta_elev < -500 then
						B738DR_tcas_arr_up_show10 = 0
						B738DR_tcas_arr_dn_show10 = 1
					else
						B738DR_tcas_arr_up_show10 = 0
						B738DR_tcas_arr_dn_show10 = 0
					end
					
					tcas_dis_10 = tcas_dis
					tcas_el_10 = tcas_el2
					
					if tcas_traffic == 0 then
						-- other traffic
						B738DR_tcas_box_show10 = 0
						B738DR_tcas_circle_show10 = 0
						B738DR_tcas_diam_show10 = 0
						B738DR_tcas_diam_e_show10 = 1
					elseif tcas_traffic == 1 then
						-- proximate traffic
						B738DR_tcas_box_show10 = 0
						B738DR_tcas_circle_show10 = 0
						B738DR_tcas_diam_show10 = 1
						B738DR_tcas_diam_e_show10 = 0
					elseif tcas_traffic == 2 then
						-- TA traffic
						B738DR_tcas_box_show10 = 0
						B738DR_tcas_circle_show10 = 1
						B738DR_tcas_diam_show10 = 0
						B738DR_tcas_diam_e_show10 = 0
					elseif tcas_traffic == 3 then
						-- RA traffic
						B738DR_tcas_box_show10 = 1
						B738DR_tcas_circle_show10 = 0
						B738DR_tcas_diam_show10 = 0
						B738DR_tcas_diam_e_show10 = 0
					end
				end
			elseif ai_plane == 11 then
			
				B738DR_tcas_x11 = tcas_x --* tcas_zoom		-- zoom
				B738DR_tcas_y11 = tcas_y --* tcas_zoom		-- zoom
				
				tcas_alt = math.floor(tcas_alt + 0.5)
				-- if tcas_alt == 0 then
					-- B738DR_tcas_alt = ""
					-- B738DR_tcas_alt_up_show = 0
					-- B738DR_tcas_alt_dn_show = 0
				if tcas_alt >= 0 then
					B738DR_tcas_alt11 = "+" .. string.sub(string.format("%03d", tcas_alt), 2, 3)
					B738DR_tcas_alt_up_show11 = 1
					B738DR_tcas_alt_dn_show11 = 0
				elseif tcas_alt < 0 then
					B738DR_tcas_alt11 = string.format("%03d", tcas_alt)
					B738DR_tcas_alt_up_show11 = 0
					B738DR_tcas_alt_dn_show11 = 1
				end
			
				if tcas_tara == 1 then
					delta_elev = tcas_el2 - tcas_el_old
					delta_elev = ((delta_elev * 3.2808399) / 2) * 60		-- vvi
					if delta_elev > 500 then
						B738DR_tcas_arr_up_show11 = 1
						B738DR_tcas_arr_dn_show11 = 0
					elseif delta_elev < -500 then
						B738DR_tcas_arr_up_show11 = 0
						B738DR_tcas_arr_dn_show11 = 1
					else
						B738DR_tcas_arr_up_show11 = 0
						B738DR_tcas_arr_dn_show11 = 0
					end
					
					tcas_dis_11 = tcas_dis
					tcas_el_11 = tcas_el2
					
					if tcas_traffic == 0 then
						-- other traffic
						B738DR_tcas_box_show11 = 0
						B738DR_tcas_circle_show11 = 0
						B738DR_tcas_diam_show11 = 0
						B738DR_tcas_diam_e_show11 = 1
					elseif tcas_traffic == 1 then
						-- proximate traffic
						B738DR_tcas_box_show11 = 0
						B738DR_tcas_circle_show11 = 0
						B738DR_tcas_diam_show11 = 1
						B738DR_tcas_diam_e_show11 = 0
					elseif tcas_traffic == 2 then
						-- TA traffic
						B738DR_tcas_box_show11 = 0
						B738DR_tcas_circle_show11 = 1
						B738DR_tcas_diam_show11 = 0
						B738DR_tcas_diam_e_show11 = 0
					elseif tcas_traffic == 3 then
						-- RA traffic
						B738DR_tcas_box_show11 = 1
						B738DR_tcas_circle_show11 = 0
						B738DR_tcas_diam_show11 = 0
						B738DR_tcas_diam_e_show11 = 0
					end
				end
			elseif ai_plane == 12 then
			
				B738DR_tcas_x12 = tcas_x --* tcas_zoom		-- zoom
				B738DR_tcas_y12 = tcas_y --* tcas_zoom		-- zoom
				
				tcas_alt = math.floor(tcas_alt + 0.5)
				-- if tcas_alt == 0 then
					-- B738DR_tcas_alt = ""
					-- B738DR_tcas_alt_up_show = 0
					-- B738DR_tcas_alt_dn_show = 0
				if tcas_alt >= 0 then
					B738DR_tcas_alt12 = "+" .. string.sub(string.format("%03d", tcas_alt), 2, 3)
					B738DR_tcas_alt_up_show12 = 1
					B738DR_tcas_alt_dn_show12 = 0
				elseif tcas_alt < 0 then
					B738DR_tcas_alt12 = string.format("%03d", tcas_alt)
					B738DR_tcas_alt_up_show12 = 0
					B738DR_tcas_alt_dn_show12 = 1
				end
			
				if tcas_tara == 1 then
					delta_elev = tcas_el2 - tcas_el_old
					delta_elev = ((delta_elev * 3.2808399) / 2) * 60		-- vvi
					if delta_elev > 500 then
						B738DR_tcas_arr_up_show12 = 1
						B738DR_tcas_arr_dn_show12 = 0
					elseif delta_elev < -500 then
						B738DR_tcas_arr_up_show12 = 0
						B738DR_tcas_arr_dn_show12 = 1
					else
						B738DR_tcas_arr_up_show12 = 0
						B738DR_tcas_arr_dn_show12 = 0
					end
					
					tcas_dis_12 = tcas_dis
					tcas_el_12 = tcas_el2
					
					if tcas_traffic == 0 then
						-- other traffic
						B738DR_tcas_box_show12 = 0
						B738DR_tcas_circle_show12 = 0
						B738DR_tcas_diam_show12 = 0
						B738DR_tcas_diam_e_show12 = 1
					elseif tcas_traffic == 1 then
						-- proximate traffic
						B738DR_tcas_box_show12 = 0
						B738DR_tcas_circle_show12 = 0
						B738DR_tcas_diam_show12 = 1
						B738DR_tcas_diam_e_show12 = 0
					elseif tcas_traffic == 2 then
						-- TA traffic
						B738DR_tcas_box_show12 = 0
						B738DR_tcas_circle_show12 = 1
						B738DR_tcas_diam_show12 = 0
						B738DR_tcas_diam_e_show12 = 0
					elseif tcas_traffic == 3 then
						-- RA traffic
						B738DR_tcas_box_show12 = 1
						B738DR_tcas_circle_show12 = 0
						B738DR_tcas_diam_show12 = 0
						B738DR_tcas_diam_e_show12 = 0
					end
				end
			elseif ai_plane == 13 then
			
				B738DR_tcas_x13 = tcas_x --* tcas_zoom		-- zoom
				B738DR_tcas_y13 = tcas_y --* tcas_zoom		-- zoom
				
				tcas_alt = math.floor(tcas_alt + 0.5)
				-- if tcas_alt == 0 then
					-- B738DR_tcas_alt = ""
					-- B738DR_tcas_alt_up_show = 0
					-- B738DR_tcas_alt_dn_show = 0
				if tcas_alt >= 0 then
					B738DR_tcas_alt13 = "+" .. string.sub(string.format("%03d", tcas_alt), 2, 3)
					B738DR_tcas_alt_up_show13 = 1
					B738DR_tcas_alt_dn_show13 = 0
				elseif tcas_alt < 0 then
					B738DR_tcas_alt13 = string.format("%03d", tcas_alt)
					B738DR_tcas_alt_up_show13 = 0
					B738DR_tcas_alt_dn_show13 = 1
				end
			
				if tcas_tara == 1 then
					delta_elev = tcas_el2 - tcas_el_old
					delta_elev = ((delta_elev * 3.2808399) / 2) * 60		-- vvi
					if delta_elev > 500 then
						B738DR_tcas_arr_up_show13 = 1
						B738DR_tcas_arr_dn_show13 = 0
					elseif delta_elev < -500 then
						B738DR_tcas_arr_up_show13 = 0
						B738DR_tcas_arr_dn_show13 = 1
					else
						B738DR_tcas_arr_up_show13 = 0
						B738DR_tcas_arr_dn_show13 = 0
					end
					
					tcas_dis_13 = tcas_dis
					tcas_el_13 = tcas_el2
					
					if tcas_traffic == 0 then
						-- other traffic
						B738DR_tcas_box_show13 = 0
						B738DR_tcas_circle_show13 = 0
						B738DR_tcas_diam_show13 = 0
						B738DR_tcas_diam_e_show13 = 1
					elseif tcas_traffic == 1 then
						-- proximate traffic
						B738DR_tcas_box_show13 = 0
						B738DR_tcas_circle_show13 = 0
						B738DR_tcas_diam_show13 = 1
						B738DR_tcas_diam_e_show13 = 0
					elseif tcas_traffic == 2 then
						-- TA traffic
						B738DR_tcas_box_show13 = 0
						B738DR_tcas_circle_show13 = 1
						B738DR_tcas_diam_show13 = 0
						B738DR_tcas_diam_e_show13 = 0
					elseif tcas_traffic == 3 then
						-- RA traffic
						B738DR_tcas_box_show13 = 1
						B738DR_tcas_circle_show13 = 0
						B738DR_tcas_diam_show13 = 0
						B738DR_tcas_diam_e_show13 = 0
					end
				end
			elseif ai_plane == 14 then
			
				B738DR_tcas_x14 = tcas_x --* tcas_zoom		-- zoom
				B738DR_tcas_y14 = tcas_y --* tcas_zoom		-- zoom
				
				tcas_alt = math.floor(tcas_alt + 0.5)
				-- if tcas_alt == 0 then
					-- B738DR_tcas_alt = ""
					-- B738DR_tcas_alt_up_show = 0
					-- B738DR_tcas_alt_dn_show = 0
				if tcas_alt >= 0 then
					B738DR_tcas_alt14 = "+" .. string.sub(string.format("%03d", tcas_alt), 2, 3)
					B738DR_tcas_alt_up_show14 = 1
					B738DR_tcas_alt_dn_show14 = 0
				elseif tcas_alt < 0 then
					B738DR_tcas_alt14 = string.format("%03d", tcas_alt)
					B738DR_tcas_alt_up_show14 = 0
					B738DR_tcas_alt_dn_show14 = 1
				end
			
				if tcas_tara == 1 then
					delta_elev = tcas_el2 - tcas_el_old
					delta_elev = ((delta_elev * 3.2808399) / 2) * 60		-- vvi
					if delta_elev > 500 then
						B738DR_tcas_arr_up_show14 = 1
						B738DR_tcas_arr_dn_show14 = 0
					elseif delta_elev < -500 then
						B738DR_tcas_arr_up_show14 = 0
						B738DR_tcas_arr_dn_show14 = 1
					else
						B738DR_tcas_arr_up_show14 = 0
						B738DR_tcas_arr_dn_show14 = 0
					end
					
					tcas_dis_14 = tcas_dis
					tcas_el_14 = tcas_el2
					
					if tcas_traffic == 0 then
						-- other traffic
						B738DR_tcas_box_show14 = 0
						B738DR_tcas_circle_show14 = 0
						B738DR_tcas_diam_show14 = 0
						B738DR_tcas_diam_e_show14 = 1
					elseif tcas_traffic == 1 then
						-- proximate traffic
						B738DR_tcas_box_show14 = 0
						B738DR_tcas_circle_show14 = 0
						B738DR_tcas_diam_show14 = 1
						B738DR_tcas_diam_e_show14 = 0
					elseif tcas_traffic == 2 then
						-- TA traffic
						B738DR_tcas_box_show14 = 0
						B738DR_tcas_circle_show14 = 1
						B738DR_tcas_diam_show14 = 0
						B738DR_tcas_diam_e_show14 = 0
					elseif tcas_traffic == 3 then
						-- RA traffic
						B738DR_tcas_box_show14 = 1
						B738DR_tcas_circle_show14 = 0
						B738DR_tcas_diam_show14 = 0
						B738DR_tcas_diam_e_show14 = 0
					end
				end
			elseif ai_plane == 15 then
			
				B738DR_tcas_x15 = tcas_x --* tcas_zoom		-- zoom
				B738DR_tcas_y15 = tcas_y --* tcas_zoom		-- zoom
				
				tcas_alt = math.floor(tcas_alt + 0.5)
				-- if tcas_alt == 0 then
					-- B738DR_tcas_alt = ""
					-- B738DR_tcas_alt_up_show = 0
					-- B738DR_tcas_alt_dn_show = 0
				if tcas_alt >= 0 then
					B738DR_tcas_alt15 = "+" .. string.sub(string.format("%03d", tcas_alt), 2, 3)
					B738DR_tcas_alt_up_show15 = 1
					B738DR_tcas_alt_dn_show15 = 0
				elseif tcas_alt < 0 then
					B738DR_tcas_alt15 = string.format("%03d", tcas_alt)
					B738DR_tcas_alt_up_show15 = 0
					B738DR_tcas_alt_dn_show15 = 1
				end
			
				if tcas_tara == 1 then
					delta_elev = tcas_el2 - tcas_el_old
					delta_elev = ((delta_elev * 3.2808399) / 2) * 60		-- vvi
					if delta_elev > 500 then
						B738DR_tcas_arr_up_show15 = 1
						B738DR_tcas_arr_dn_show15 = 0
					elseif delta_elev < -500 then
						B738DR_tcas_arr_up_show15 = 0
						B738DR_tcas_arr_dn_show15 = 1
					else
						B738DR_tcas_arr_up_show15 = 0
						B738DR_tcas_arr_dn_show15 = 0
					end
					
					tcas_dis_15 = tcas_dis
					tcas_el_15 = tcas_el2
					
					if tcas_traffic == 0 then
						-- other traffic
						B738DR_tcas_box_show15 = 0
						B738DR_tcas_circle_show15 = 0
						B738DR_tcas_diam_show15 = 0
						B738DR_tcas_diam_e_show15 = 1
					elseif tcas_traffic == 1 then
						-- proximate traffic
						B738DR_tcas_box_show15 = 0
						B738DR_tcas_circle_show15 = 0
						B738DR_tcas_diam_show15 = 1
						B738DR_tcas_diam_e_show15 = 0
					elseif tcas_traffic == 2 then
						-- TA traffic
						B738DR_tcas_box_show15 = 0
						B738DR_tcas_circle_show15 = 1
						B738DR_tcas_diam_show15 = 0
						B738DR_tcas_diam_e_show15 = 0
					elseif tcas_traffic == 3 then
						-- RA traffic
						B738DR_tcas_box_show15 = 1
						B738DR_tcas_circle_show15 = 0
						B738DR_tcas_diam_show15 = 0
						B738DR_tcas_diam_e_show15 = 0
					end
				end
			elseif ai_plane == 16 then
			
				B738DR_tcas_x16 = tcas_x --* tcas_zoom		-- zoom
				B738DR_tcas_y16 = tcas_y --* tcas_zoom		-- zoom
				
				tcas_alt = math.floor(tcas_alt + 0.5)
				-- if tcas_alt == 0 then
					-- B738DR_tcas_alt = ""
					-- B738DR_tcas_alt_up_show = 0
					-- B738DR_tcas_alt_dn_show = 0
				if tcas_alt >= 0 then
					B738DR_tcas_alt16 = "+" .. string.sub(string.format("%03d", tcas_alt), 2, 3)
					B738DR_tcas_alt_up_show16 = 1
					B738DR_tcas_alt_dn_show16 = 0
				elseif tcas_alt < 0 then
					B738DR_tcas_alt16 = string.format("%03d", tcas_alt)
					B738DR_tcas_alt_up_show16 = 0
					B738DR_tcas_alt_dn_show16 = 1
				end
			
				if tcas_tara == 1 then
					delta_elev = tcas_el2 - tcas_el_old
					delta_elev = ((delta_elev * 3.2808399) / 2) * 60		-- vvi
					if delta_elev > 500 then
						B738DR_tcas_arr_up_show16 = 1
						B738DR_tcas_arr_dn_show16 = 0
					elseif delta_elev < -500 then
						B738DR_tcas_arr_up_show16 = 0
						B738DR_tcas_arr_dn_show16 = 1
					else
						B738DR_tcas_arr_up_show16 = 0
						B738DR_tcas_arr_dn_show16 = 0
					end
					
					tcas_dis_16 = tcas_dis
					tcas_el_16 = tcas_el2
					
					if tcas_traffic == 0 then
						-- other traffic
						B738DR_tcas_box_show16 = 0
						B738DR_tcas_circle_show16 = 0
						B738DR_tcas_diam_show16 = 0
						B738DR_tcas_diam_e_show16 = 1
					elseif tcas_traffic == 1 then
						-- proximate traffic
						B738DR_tcas_box_show16 = 0
						B738DR_tcas_circle_show16 = 0
						B738DR_tcas_diam_show16 = 1
						B738DR_tcas_diam_e_show16 = 0
					elseif tcas_traffic == 2 then
						-- TA traffic
						B738DR_tcas_box_show16 = 0
						B738DR_tcas_circle_show16 = 1
						B738DR_tcas_diam_show16 = 0
						B738DR_tcas_diam_e_show16 = 0
					elseif tcas_traffic == 3 then
						-- RA traffic
						B738DR_tcas_box_show16 = 1
						B738DR_tcas_circle_show16 = 0
						B738DR_tcas_diam_show16 = 0
						B738DR_tcas_diam_e_show16 = 0
					end
				end
			elseif ai_plane == 17 then
			
				B738DR_tcas_x17 = tcas_x --* tcas_zoom		-- zoom
				B738DR_tcas_y17 = tcas_y --* tcas_zoom		-- zoom
				
				tcas_alt = math.floor(tcas_alt + 0.5)
				-- if tcas_alt == 0 then
					-- B738DR_tcas_alt = ""
					-- B738DR_tcas_alt_up_show = 0
					-- B738DR_tcas_alt_dn_show = 0
				if tcas_alt >= 0 then
					B738DR_tcas_alt17 = "+" .. string.sub(string.format("%03d", tcas_alt), 2, 3)
					B738DR_tcas_alt_up_show17 = 1
					B738DR_tcas_alt_dn_show17 = 0
				elseif tcas_alt < 0 then
					B738DR_tcas_alt17 = string.format("%03d", tcas_alt)
					B738DR_tcas_alt_up_show17 = 0
					B738DR_tcas_alt_dn_show17 = 1
				end
			
				if tcas_tara == 1 then
					delta_elev = tcas_el2 - tcas_el_old
					delta_elev = ((delta_elev * 3.2808399) / 2) * 60		-- vvi
					if delta_elev > 500 then
						B738DR_tcas_arr_up_show17 = 1
						B738DR_tcas_arr_dn_show17 = 0
					elseif delta_elev < -500 then
						B738DR_tcas_arr_up_show17 = 0
						B738DR_tcas_arr_dn_show17 = 1
					else
						B738DR_tcas_arr_up_show17 = 0
						B738DR_tcas_arr_dn_show17 = 0
					end
					
					tcas_dis_17 = tcas_dis
					tcas_el_17 = tcas_el2
					
					if tcas_traffic == 0 then
						-- other traffic
						B738DR_tcas_box_show17 = 0
						B738DR_tcas_circle_show17 = 0
						B738DR_tcas_diam_show17 = 0
						B738DR_tcas_diam_e_show17 = 1
					elseif tcas_traffic == 1 then
						-- proximate traffic
						B738DR_tcas_box_show17 = 0
						B738DR_tcas_circle_show17 = 0
						B738DR_tcas_diam_show17 = 1
						B738DR_tcas_diam_e_show17 = 0
					elseif tcas_traffic == 2 then
						-- TA traffic
						B738DR_tcas_box_show17 = 0
						B738DR_tcas_circle_show17 = 1
						B738DR_tcas_diam_show17 = 0
						B738DR_tcas_diam_e_show17 = 0
					elseif tcas_traffic == 3 then
						-- RA traffic
						B738DR_tcas_box_show17 = 1
						B738DR_tcas_circle_show17 = 0
						B738DR_tcas_diam_show17 = 0
						B738DR_tcas_diam_e_show17 = 0
					end
				end
			elseif ai_plane == 18 then
			
				B738DR_tcas_x18 = tcas_x --* tcas_zoom		-- zoom
				B738DR_tcas_y18 = tcas_y --* tcas_zoom		-- zoom
				
				tcas_alt = math.floor(tcas_alt + 0.5)
				-- if tcas_alt == 0 then
					-- B738DR_tcas_alt = ""
					-- B738DR_tcas_alt_up_show = 0
					-- B738DR_tcas_alt_dn_show = 0
				if tcas_alt >= 0 then
					B738DR_tcas_alt18 = "+" .. string.sub(string.format("%03d", tcas_alt), 2, 3)
					B738DR_tcas_alt_up_show18 = 1
					B738DR_tcas_alt_dn_show18 = 0
				elseif tcas_alt < 0 then
					B738DR_tcas_alt18 = string.format("%03d", tcas_alt)
					B738DR_tcas_alt_up_show18 = 0
					B738DR_tcas_alt_dn_show18 = 1
				end
			
				if tcas_tara == 1 then
					delta_elev = tcas_el2 - tcas_el_old
					delta_elev = ((delta_elev * 3.2808399) / 2) * 60		-- vvi
					if delta_elev > 500 then
						B738DR_tcas_arr_up_show18 = 1
						B738DR_tcas_arr_dn_show18 = 0
					elseif delta_elev < -500 then
						B738DR_tcas_arr_up_show18 = 0
						B738DR_tcas_arr_dn_show18 = 1
					else
						B738DR_tcas_arr_up_show18 = 0
						B738DR_tcas_arr_dn_show18 = 0
					end
					
					tcas_dis_18 = tcas_dis
					tcas_el_18 = tcas_el2
					
					if tcas_traffic == 0 then
						-- other traffic
						B738DR_tcas_box_show18 = 0
						B738DR_tcas_circle_show18 = 0
						B738DR_tcas_diam_show18 = 0
						B738DR_tcas_diam_e_show18 = 1
					elseif tcas_traffic == 1 then
						-- proximate traffic
						B738DR_tcas_box_show18 = 0
						B738DR_tcas_circle_show18 = 0
						B738DR_tcas_diam_show18 = 1
						B738DR_tcas_diam_e_show18 = 0
					elseif tcas_traffic == 2 then
						-- TA traffic
						B738DR_tcas_box_show18 = 0
						B738DR_tcas_circle_show18 = 1
						B738DR_tcas_diam_show18 = 0
						B738DR_tcas_diam_e_show18 = 0
					elseif tcas_traffic == 3 then
						-- RA traffic
						B738DR_tcas_box_show18 = 1
						B738DR_tcas_circle_show18 = 0
						B738DR_tcas_diam_show18 = 0
						B738DR_tcas_diam_e_show18 = 0
					end
				end
			elseif ai_plane == 19 then
			
				B738DR_tcas_x19 = tcas_x --* tcas_zoom		-- zoom
				B738DR_tcas_y19 = tcas_y --* tcas_zoom		-- zoom
				
				tcas_alt = math.floor(tcas_alt + 0.5)
				-- if tcas_alt == 0 then
					-- B738DR_tcas_alt = ""
					-- B738DR_tcas_alt_up_show = 0
					-- B738DR_tcas_alt_dn_show = 0
				if tcas_alt >= 0 then
					B738DR_tcas_alt19 = "+" .. string.sub(string.format("%03d", tcas_alt), 2, 3)
					B738DR_tcas_alt_up_show19 = 1
					B738DR_tcas_alt_dn_show19 = 0
				elseif tcas_alt < 0 then
					B738DR_tcas_alt19 = string.format("%03d", tcas_alt)
					B738DR_tcas_alt_up_show19 = 0
					B738DR_tcas_alt_dn_show19 = 1
				end
			
				if tcas_tara == 1 then
					delta_elev = tcas_el2 - tcas_el_old
					delta_elev = ((delta_elev * 3.2808399) / 2) * 60		-- vvi
					if delta_elev > 500 then
						B738DR_tcas_arr_up_show19 = 1
						B738DR_tcas_arr_dn_show19 = 0
					elseif delta_elev < -500 then
						B738DR_tcas_arr_up_show19 = 0
						B738DR_tcas_arr_dn_show19 = 1
					else
						B738DR_tcas_arr_up_show19 = 0
						B738DR_tcas_arr_dn_show19 = 0
					end
					
					tcas_dis_19 = tcas_dis
					tcas_el_19 = tcas_el2
					
					if tcas_traffic == 0 then
						-- other traffic
						B738DR_tcas_box_show19 = 0
						B738DR_tcas_circle_show19 = 0
						B738DR_tcas_diam_show19 = 0
						B738DR_tcas_diam_e_show19 = 1
					elseif tcas_traffic == 1 then
						-- proximate traffic
						B738DR_tcas_box_show19 = 0
						B738DR_tcas_circle_show19 = 0
						B738DR_tcas_diam_show19 = 1
						B738DR_tcas_diam_e_show19 = 0
					elseif tcas_traffic == 2 then
						-- TA traffic
						B738DR_tcas_box_show19 = 0
						B738DR_tcas_circle_show19 = 1
						B738DR_tcas_diam_show19 = 0
						B738DR_tcas_diam_e_show19 = 0
					elseif tcas_traffic == 3 then
						-- RA traffic
						B738DR_tcas_box_show19 = 1
						B738DR_tcas_circle_show19 = 0
						B738DR_tcas_diam_show19 = 0
						B738DR_tcas_diam_e_show19 = 0
					end
				end
			
			end
		end
	end
	
	if tcas_on_off == 0 then
		if ai_plane == 1 then
			B738_EFIS_TCAS_show1 = 0
			-- B738DR_tcas_box_show = 0
			-- B738DR_tcas_circle_show = 0
			-- B738DR_tcas_diam_show = 0
			-- B738DR_tcas_diam_e_show = 0
		elseif ai_plane == 2 then
			B738_EFIS_TCAS_show2 = 0
			-- B738DR_tcas_box_show2 = 0
			-- B738DR_tcas_circle_show2 = 0
			-- B738DR_tcas_diam_show2 = 0
			-- B738DR_tcas_diam_e_show2 = 0
		elseif ai_plane == 3 then
			B738_EFIS_TCAS_show3 = 0
			-- B738DR_tcas_box_show3 = 0
			-- B738DR_tcas_circle_show3 = 0
			-- B738DR_tcas_diam_show3 = 0
			-- B738DR_tcas_diam_e_show3 = 0
		elseif ai_plane == 4 then
			B738_EFIS_TCAS_show4 = 0
			-- B738DR_tcas_box_show4 = 0
			-- B738DR_tcas_circle_show4 = 0
			-- B738DR_tcas_diam_show4 = 0
			-- B738DR_tcas_diam_e_show4 = 0
		elseif ai_plane == 5 then
			B738_EFIS_TCAS_show5 = 0
			-- B738DR_tcas_box_show5 = 0
			-- B738DR_tcas_circle_show5 = 0
			-- B738DR_tcas_diam_show5 = 0
			-- B738DR_tcas_diam_e_show5 = 0
		elseif ai_plane == 6 then
			B738_EFIS_TCAS_show6 = 0
			-- B738DR_tcas_box_show6 = 0
			-- B738DR_tcas_circle_show6 = 0
			-- B738DR_tcas_diam_show6 = 0
			-- B738DR_tcas_diam_e_show6 = 0
		elseif ai_plane == 7 then
			B738_EFIS_TCAS_show7 = 0
			-- B738DR_tcas_box_show7 = 0
			-- B738DR_tcas_circle_show7 = 0
			-- B738DR_tcas_diam_show7 = 0
			-- B738DR_tcas_diam_e_show7 = 0
		elseif ai_plane == 8 then
			B738_EFIS_TCAS_show8 = 0
			-- B738DR_tcas_box_show8 = 0
			-- B738DR_tcas_circle_show8 = 0
			-- B738DR_tcas_diam_show8 = 0
			-- B738DR_tcas_diam_e_show8 = 0
		elseif ai_plane == 9 then
			B738_EFIS_TCAS_show9 = 0
			-- B738DR_tcas_box_show9 = 0
			-- B738DR_tcas_circle_show9 = 0
			-- B738DR_tcas_diam_show9 = 0
			-- B738DR_tcas_diam_e_show9 = 0
		elseif ai_plane == 10 then
			B738_EFIS_TCAS_show10 = 0
			-- B738DR_tcas_box_show10 = 0
			-- B738DR_tcas_circle_show10 = 0
			-- B738DR_tcas_diam_show10 = 0
			-- B738DR_tcas_diam_e_show10 = 0
		elseif ai_plane == 11 then
			B738_EFIS_TCAS_show11 = 0
		elseif ai_plane == 12 then
			B738_EFIS_TCAS_show12 = 0
		elseif ai_plane == 13 then
			B738_EFIS_TCAS_show13 = 0
		elseif ai_plane == 14 then
			B738_EFIS_TCAS_show14 = 0
		elseif ai_plane == 15 then
			B738_EFIS_TCAS_show15 = 0
		elseif ai_plane == 16 then
			B738_EFIS_TCAS_show16 = 0
		elseif ai_plane == 17 then
			B738_EFIS_TCAS_show17 = 0
		elseif ai_plane == 18 then
			B738_EFIS_TCAS_show18 = 0
		elseif ai_plane == 19 then
			B738_EFIS_TCAS_show19 = 0
		end
	else
		if ai_plane == 1 then
			B738_EFIS_TCAS_show1 = 1
		elseif ai_plane == 2 then
			B738_EFIS_TCAS_show2 = 1
		elseif ai_plane == 3 then
			B738_EFIS_TCAS_show3 = 1
		elseif ai_plane == 4 then
			B738_EFIS_TCAS_show4 = 1
		elseif ai_plane == 5 then
			B738_EFIS_TCAS_show5 = 1
		elseif ai_plane == 6 then
			B738_EFIS_TCAS_show6 = 1
		elseif ai_plane == 7 then
			B738_EFIS_TCAS_show7 = 1
		elseif ai_plane == 8 then
			B738_EFIS_TCAS_show8 = 1
		elseif ai_plane == 9 then
			B738_EFIS_TCAS_show9 = 1
		elseif ai_plane == 10 then
			B738_EFIS_TCAS_show10 = 1
		elseif ai_plane == 11 then
			B738_EFIS_TCAS_show11 = 1
		elseif ai_plane == 12 then
			B738_EFIS_TCAS_show12 = 1
		elseif ai_plane == 13 then
			B738_EFIS_TCAS_show13 = 1
		elseif ai_plane == 14 then
			B738_EFIS_TCAS_show14 = 1
		elseif ai_plane == 15 then
			B738_EFIS_TCAS_show15 = 1
		elseif ai_plane == 16 then
			B738_EFIS_TCAS_show16 = 1
		elseif ai_plane == 17 then
			B738_EFIS_TCAS_show17 = 1
		elseif ai_plane == 18 then
			B738_EFIS_TCAS_show18 = 1
		elseif ai_plane == 19 then
			B738_EFIS_TCAS_show19 = 1
		end
	end

end

function tcas_test()

		local tcas_zoom = 0
		-- traffic test
		tcas_clr(1)
		tcas_clr(2)
		tcas_clr(3)
		tcas_clr(4)
		tcas_clr(5)
		tcas_clr(6)
		tcas_clr(7)
		tcas_clr(8)
		tcas_clr(9)
		tcas_clr(10)
		tcas_clr(11)
		tcas_clr(12)
		tcas_clr(13)
		tcas_clr(14)
		tcas_clr(15)
		tcas_clr(16)
		tcas_clr(17)
		tcas_clr(18)
		tcas_clr(19)
		if B738DR_efis_map_range_capt == 0 then	-- 5 NM
			tcas_zoom = 2
		elseif B738DR_efis_map_range_capt == 1 then	-- 10 NM
			tcas_zoom = 1
		elseif B738DR_efis_map_range_capt == 2 then	-- 20 NM
			tcas_zoom = 0.5
		elseif B738DR_efis_map_range_capt == 3 then	-- 40 NM
			tcas_zoom = 0.25
		elseif B738DR_efis_map_range_capt == 4 then	-- 80 NM
			tcas_zoom = 0.125
		else
			tcas_zoom = 0.125
		end
		B738_EFIS_traffic_ra = 1
		B738_EFIS_traffic_ta = 0
		-- AI 1
		B738DR_tcas_box_show = 1
		B738DR_tcas_x = 1.2 * tcas_zoom
		B738DR_tcas_y = 1 * tcas_zoom
		B738DR_tcas_arr_up_show = 0
		B738DR_tcas_arr_dn_show = 0
		B738DR_tcas_alt = "+00"
		B738DR_tcas_alt_up_show = 1
		B738DR_tcas_alt_dn_show = 0
		B738_EFIS_TCAS_show1 = 1
		-- AI 2
		B738DR_tcas_circle_show2 = 1
		B738DR_tcas_x2 = -1.2 * tcas_zoom
		B738DR_tcas_y2 = 1 * tcas_zoom
		B738DR_tcas_arr_up_show2 = 0
		B738DR_tcas_arr_dn_show2 = 0
		B738DR_tcas_alt2 = "-05"
		B738DR_tcas_alt_up_show2 = 0
		B738DR_tcas_alt_dn_show2 = 1
		B738_EFIS_TCAS_show2 = 1
		-- AI 3
		B738DR_tcas_diam_show3 = 1
		B738DR_tcas_x3 = 1.2 * tcas_zoom
		B738DR_tcas_y3 = 3 * tcas_zoom
		B738DR_tcas_arr_up_show3 = 0
		B738DR_tcas_arr_dn_show3 = 1
		B738DR_tcas_alt3 = ""
		B738DR_tcas_alt_up_show3 = 0
		B738DR_tcas_alt_dn_show3 = 0
		B738_EFIS_TCAS_show3 = 1
		-- AI 4
		B738DR_tcas_diam_e_show4 = 1
		B738DR_tcas_x4 = -1.2 * tcas_zoom
		B738DR_tcas_y4 = 3 * tcas_zoom
		B738DR_tcas_arr_up_show4 = 1
		B738DR_tcas_arr_dn_show4 = 0
		B738DR_tcas_alt4 = "+24"
		B738DR_tcas_alt_up_show4 = 1
		B738DR_tcas_alt_dn_show4 = 0
		B738_EFIS_TCAS_show4 = 1
		
		B738_EFIS_TCAS_show = 1
end

function B738_tcas_system()

	tcas_lat = math.rad(simDR_lat)
	tcas_lon = math.rad(simDR_lon)
	tcas_el = simDR_el
	local ii = 0
	
	if is_timer_scheduled(B738_tcas_calc) == false then
		run_at_interval(B738_tcas_calc, 2)		-- calc every 2 seconds
	end

	if B738DR_transponder_knob_pos > 0 then
		local tcas_tara_test = 0
		local nearest_plane = 99
		--tcas_tara_status = 0
		
		for ii = 1, 19 do
			B738_tcas(ii)
			if tcas_dis < nearest_plane then
				nearest_plane = tcas_dis
			end
		end
		
		-- B738_tcas(1)
		-- if tcas_dis < nearest_plane then
			-- nearest_plane = tcas_dis
		-- end
		-- B738_tcas(2)
		-- if tcas_dis < nearest_plane then
			-- nearest_plane = tcas_dis
		-- end
		-- B738_tcas(3)
		-- if tcas_dis < nearest_plane then
			-- nearest_plane = tcas_dis
		-- end
		-- B738_tcas(4)
		-- if tcas_dis < nearest_plane then
			-- nearest_plane = tcas_dis
		-- end
		-- B738_tcas(5)
		-- if tcas_dis < nearest_plane then
			-- nearest_plane = tcas_dis
		-- end
		-- B738_tcas(6)
		-- if tcas_dis < nearest_plane then
			-- nearest_plane = tcas_dis
		-- end
		-- B738_tcas(7)
		-- if tcas_dis < nearest_plane then
			-- nearest_plane = tcas_dis
		-- end
		-- B738_tcas(8)
		-- if tcas_dis < nearest_plane then
			-- nearest_plane = tcas_dis
		-- end
		-- B738_tcas(9)
		-- if tcas_dis < nearest_plane then
			-- nearest_plane = tcas_dis
		-- end
		-- B738_tcas(10)
		-- if tcas_dis < nearest_plane then
			-- nearest_plane = tcas_dis
		-- end
		-- B738_tcas(11)
		-- if tcas_dis < nearest_plane then
			-- nearest_plane = tcas_dis
		-- end
		-- B738_tcas(12)
		-- if tcas_dis < nearest_plane then
			-- nearest_plane = tcas_dis
		-- end
		-- B738_tcas(13)
		-- if tcas_dis < nearest_plane then
			-- nearest_plane = tcas_dis
		-- end
		-- B738_tcas(14)
		-- if tcas_dis < nearest_plane then
			-- nearest_plane = tcas_dis
		-- end
		-- B738_tcas(15)
		-- if tcas_dis < nearest_plane then
			-- nearest_plane = tcas_dis
		-- end
		-- B738_tcas(16)
		-- if tcas_dis < nearest_plane then
			-- nearest_plane = tcas_dis
		-- end
		-- B738_tcas(17)
		-- if tcas_dis < nearest_plane then
			-- nearest_plane = tcas_dis
		-- end
		-- B738_tcas(18)
		-- if tcas_dis < nearest_plane then
			-- nearest_plane = tcas_dis
		-- end
		-- B738_tcas(19)
		-- if tcas_dis < nearest_plane then
			-- nearest_plane = tcas_dis
		-- end
		B738DR_tcas_nearest_plane_m = nearest_plane * 1852
		
		if tcas_tara == 1 then
			tcas_el_0 = tcas_el
		end
		tcas_tara = 0
		
		if B738_EFIS_TCAS_show1 == 1 and B738DR_tcas_box_show == 1 then
			tcas_tara_test = 1
		end
		if B738_EFIS_TCAS_show2 == 1 and B738DR_tcas_box_show2 == 1 then
			tcas_tara_test = 1
		end
		if B738_EFIS_TCAS_show3 == 1 and B738DR_tcas_box_show3 == 1 then
			tcas_tara_test = 1
		end
		if B738_EFIS_TCAS_show4 == 1 and B738DR_tcas_box_show4 == 1 then
			tcas_tara_test = 1
		end
		if B738_EFIS_TCAS_show5 == 1 and B738DR_tcas_box_show5 == 1 then
			tcas_tara_test = 1
		end
		if B738_EFIS_TCAS_show6 == 1 and B738DR_tcas_box_show6 == 1 then
			tcas_tara_test = 1
		end
		if B738_EFIS_TCAS_show7 == 1 and B738DR_tcas_box_show7 == 1 then
			tcas_tara_test = 1
		end
		if B738_EFIS_TCAS_show8 == 1 and B738DR_tcas_box_show8 == 1 then
			tcas_tara_test = 1
		end
		if B738_EFIS_TCAS_show9 == 1 and B738DR_tcas_box_show9 == 1 then
			tcas_tara_test = 1
		end
		if B738_EFIS_TCAS_show10 == 1 and B738DR_tcas_box_show10 == 1 then
			tcas_tara_test = 1
		end
		if B738_EFIS_TCAS_show11 == 1 and B738DR_tcas_box_show11 == 1 then
			tcas_tara_test = 1
		end
		if B738_EFIS_TCAS_show12 == 1 and B738DR_tcas_box_show12 == 1 then
			tcas_tara_test = 1
		end
		if B738_EFIS_TCAS_show13 == 1 and B738DR_tcas_box_show13 == 1 then
			tcas_tara_test = 1
		end
		if B738_EFIS_TCAS_show14 == 1 and B738DR_tcas_box_show14 == 1 then
			tcas_tara_test = 1
		end
		if B738_EFIS_TCAS_show15 == 1 and B738DR_tcas_box_show15 == 1 then
			tcas_tara_test = 1
		end
		if B738_EFIS_TCAS_show16 == 1 and B738DR_tcas_box_show16 == 1 then
			tcas_tara_test = 1
		end
		if B738_EFIS_TCAS_show17 == 1 and B738DR_tcas_box_show17 == 1 then
			tcas_tara_test = 1
		end
		if B738_EFIS_TCAS_show18 == 1 and B738DR_tcas_box_show18 == 1 then
			tcas_tara_test = 1
		end
		if B738_EFIS_TCAS_show19 == 1 and B738DR_tcas_box_show19 == 1 then
			tcas_tara_test = 1
		end
		
		if tcas_tara_test == 1 then
			if B738DR_transponder_knob_pos == 5 then
				B738_EFIS_traffic_ra = 1
				B738_EFIS_traffic_ta = 0
			else
				B738_EFIS_traffic_ra = 0
				B738_EFIS_traffic_ta = 1
			end
		else
			tcas_tara_test = 0
			if B738_EFIS_TCAS_show1 == 1 and B738DR_tcas_circle_show == 1 then
				tcas_tara_test = 1
			end
			if B738_EFIS_TCAS_show2 == 1 and B738DR_tcas_circle_show2 == 1 then
				tcas_tara_test = 1
			end
			if B738_EFIS_TCAS_show3 == 1 and B738DR_tcas_circle_show3 == 1 then
				tcas_tara_test = 1
			end
			if B738_EFIS_TCAS_show4 == 1 and B738DR_tcas_circle_show4 == 1 then
				tcas_tara_test = 1
			end
			if B738_EFIS_TCAS_show5 == 1 and B738DR_tcas_circle_show5 == 1 then
				tcas_tara_test = 1
			end
			if B738_EFIS_TCAS_show6 == 1 and B738DR_tcas_circle_show6 == 1 then
				tcas_tara_test = 1
			end
			if B738_EFIS_TCAS_show7 == 1 and B738DR_tcas_circle_show7 == 1 then
				tcas_tara_test = 1
			end
			if B738_EFIS_TCAS_show8 == 1 and B738DR_tcas_circle_show8 == 1 then
				tcas_tara_test = 1
			end
			if B738_EFIS_TCAS_show9 == 1 and B738DR_tcas_circle_show9 == 1 then
				tcas_tara_test = 1
			end
			if B738_EFIS_TCAS_show10 == 1 and B738DR_tcas_circle_show10 == 1 then
				tcas_tara_test = 1
			end
			if B738_EFIS_TCAS_show11 == 1 and B738DR_tcas_circle_show11 == 1 then
				tcas_tara_test = 1
			end
			if B738_EFIS_TCAS_show12 == 1 and B738DR_tcas_circle_show12 == 1 then
				tcas_tara_test = 1
			end
			if B738_EFIS_TCAS_show13 == 1 and B738DR_tcas_circle_show13 == 1 then
				tcas_tara_test = 1
			end
			if B738_EFIS_TCAS_show14 == 1 and B738DR_tcas_circle_show14 == 1 then
				tcas_tara_test = 1
			end
			if B738_EFIS_TCAS_show15 == 1 and B738DR_tcas_circle_show15 == 1 then
				tcas_tara_test = 1
			end
			if B738_EFIS_TCAS_show16 == 1 and B738DR_tcas_circle_show16 == 1 then
				tcas_tara_test = 1
			end
			if B738_EFIS_TCAS_show17 == 1 and B738DR_tcas_circle_show17 == 1 then
				tcas_tara_test = 1
			end
			if B738_EFIS_TCAS_show18 == 1 and B738DR_tcas_circle_show18 == 1 then
				tcas_tara_test = 1
			end
			if B738_EFIS_TCAS_show19 == 1 and B738DR_tcas_circle_show19 == 1 then
				tcas_tara_test = 1
			end
			if tcas_tara_test == 1 then
				B738_EFIS_traffic_ra = 0
				B738_EFIS_traffic_ta = 1
			else
				B738_EFIS_traffic_ra = 0
				B738_EFIS_traffic_ta = 0
			end
		end
	end
	
	B738_EFIS_tcas_fail_show = 0
	
	if B738DR_transponder_knob_pos == 0 then
		B738_EFIS_tfc_show = 0
		B738_EFIS_ta_only_show = 0
		B738_EFIS_tcas_test_show = 1
		B738_EFIS_tcas_off_show = 0
		-- B738_EFIS_tfc_show_fo = 0
		-- B738_EFIS_ta_only_show_fo = 0
		-- B738_EFIS_tcas_test_show_fo = 1
		-- B738_EFIS_tcas_off_show_fo = 0
		--B738_EFIS_TCAS_show = 0
		tcas_test()
	elseif B738DR_transponder_knob_pos < 4 then
		B738_EFIS_tfc_show = 0
		B738_EFIS_ta_only_show = 0
		B738_EFIS_tcas_test_show = 0
		B738_EFIS_tcas_off_show = 1
		-- B738_EFIS_tfc_show_fo = 0
		-- B738_EFIS_ta_only_show_fo = 0
		-- B738_EFIS_tcas_test_show_fo = 0
		-- B738_EFIS_tcas_off_show_fo = 1
		B738_EFIS_TCAS_show = 0
	elseif B738DR_transponder_knob_pos == 4 then
		B738_EFIS_tfc_show = 0
		B738_EFIS_ta_only_show = 1
		B738_EFIS_tcas_test_show = 0
		B738_EFIS_tcas_off_show = 0
		-- B738_EFIS_tfc_show_fo = 0
		-- B738_EFIS_ta_only_show_fo = 1
		-- B738_EFIS_tcas_test_show_fo = 0
		-- B738_EFIS_tcas_off_show_fo = 0
		B738_EFIS_TCAS_show = 1
	elseif B738DR_transponder_knob_pos == 5 then
		B738_EFIS_tfc_show = 1
		B738_EFIS_ta_only_show = 0
		B738_EFIS_tcas_test_show = 0
		B738_EFIS_tcas_off_show = 0
		-- B738_EFIS_tfc_show_fo = 1
		-- B738_EFIS_ta_only_show_fo = 0
		-- B738_EFIS_tcas_test_show_fo = 0
		-- B738_EFIS_tcas_off_show_fo = 0
		B738_EFIS_TCAS_show = 1
	end
	
	if B738DR_EFIS_TCAS_on == 0 
	or (B738DR_capt_map_mode < 2 and B738DR_capt_exp_map_mode == 0)
	or B738DR_capt_map_mode == 3 then
		B738_EFIS_TCAS_show = 0
		B738_EFIS_tfc_show = 0
		B738_EFIS_ta_only_show = 0
		B738_EFIS_tcas_test_show = 0
		B738_EFIS_TCAS_show = 0
		
		B738_EFIS_traffic_ra = 0
		B738_EFIS_traffic_ta = 0
		tcas_tara = 1
	end
	
	--- TEMPORARY
	if B738_EFIS_TCAS_show == 0 then
		B738_EFIS_traffic_ra = 0
		B738_EFIS_traffic_ta = 0
	end
	-------------

end

function tcas_show1_19()

	B738_EFIS_TCAS_show1 = 1
	B738_EFIS_TCAS_show2 = 1
	B738_EFIS_TCAS_show3 = 1
	B738_EFIS_TCAS_show4 = 1
	B738_EFIS_TCAS_show5 = 1
	B738_EFIS_TCAS_show6 = 1
	B738_EFIS_TCAS_show7 = 1
	B738_EFIS_TCAS_show8 = 1
	B738_EFIS_TCAS_show9 = 1
	B738_EFIS_TCAS_show10 = 1
	B738_EFIS_TCAS_show11 = 1
	B738_EFIS_TCAS_show12 = 1
	B738_EFIS_TCAS_show13 = 1
	B738_EFIS_TCAS_show14 = 1
	B738_EFIS_TCAS_show15 = 1
	B738_EFIS_TCAS_show16 = 1
	B738_EFIS_TCAS_show17 = 1
	B738_EFIS_TCAS_show18 = 1
	B738_EFIS_TCAS_show19 = 1

end

function B738_hydropumps()

		-- engine hydropumps
		if B738DR_hydro_pumps1_switch_position == 0
		and B738DR_hydro_pumps2_switch_position == 0 then
			-- turn off hydro pumps
			simCMD_hydro_pumps_off:once()
		elseif B738DR_engine01_fire_ext_switch_pos_arm == 1 and B738DR_engine02_fire_ext_switch_pos_arm == 1 then
			simCMD_hydro_pumps_off:once()
		else
			-- turn on hydro pumps
			simCMD_hydro_pumps_on:once()
		end
		
		-- electric hydropumps
		if B738DR_el_hydro_pumps1_switch_position == 0
		and B738DR_el_hydro_pumps2_switch_position == 0 then
			simDR_electric_hyd_pump_switch = 0
		else
			--if B738DR_source_off_bus1 == 0 or B738DR_source_off_bus2 == 0 then
			if B738DR_ac_tnsbus1_status == 1 or B738DR_ac_tnsbus2_status == 1 then
				simDR_electric_hyd_pump_switch = 1
			else
				simDR_electric_hyd_pump_switch = 0
			end
		end

end

function B738_probes_antiice()
 		
		-- Captain
		if B738DR_probes_capt_switch_pos == 1 then
			if B738DR_ac_stdbus_status == 0 then
				if simDR_aoa_capt == 1 then
					simCMD_capt_AOA_ice_off:once()
				end
				if simDR_pitot_capt == 1 then
					simCMD_capt_pitot_ice_off:once()
				end
			else
				if simDR_aoa_capt == 0 then
					simCMD_capt_AOA_ice_on:once()
				end
				if simDR_pitot_capt == 0 then
					simCMD_capt_pitot_ice_on:once()
				end
			end
		elseif B738DR_probes_capt_switch_pos == 0 then
 			if simDR_aoa_capt == 1 then
				simCMD_capt_AOA_ice_off:once()
			end
			if simDR_pitot_capt == 1 then
				simCMD_capt_pitot_ice_off:once()
			end
		end
		
		-- First Officer
		if B738DR_probes_fo_switch_pos == 1 then
			if B738DR_ac_tnsbus2_status == 0 then
				if simDR_aoa_fo == 1 then
					simCMD_fo_AOA_ice_off:once()
				end
				if simDR_pitot_fo == 1 then
					simCMD_fo_pitot_ice_off:once()
				end
			else
				if simDR_aoa_fo == 0 then
					simCMD_fo_AOA_ice_on:once()
				end
				if simDR_pitot_fo == 0 then
					simCMD_fo_pitot_ice_on:once()
				end
			end
		elseif B738DR_probes_fo_switch_pos == 0 then
			if simDR_aoa_fo == 1 then
				simCMD_fo_AOA_ice_off:once()
			end
			if simDR_pitot_fo == 1 then
				simCMD_fo_pitot_ice_off:once()
			end
		end

end

function B738_apu_gen()
	if B738DR_apu_power_bus1 == 0 and B738DR_apu_power_bus2 == 0 then
		if simDR_apu_on == 1 then
			simCMD_apu_gen_off:once()
		end
	else
		if simDR_apu_on == 0 then
			simCMD_apu_gen_on:once()
		end
	end
end

function B738_slats()

	local flaps_deg = simDR_flap_deg
	
	if flaps_deg <= 8 then
		B738DR_slat2_deg = B738_rescale(0, 0, 8, 0.5, flaps_deg)
	elseif flaps_deg > 8 and flaps_deg <= 14 then
		B738DR_slat2_deg = 0.5
	elseif flaps_deg > 14 and flaps_deg <= 19 then
		B738DR_slat2_deg = B738_rescale(14, 0.5, 19, 1.0, flaps_deg)
	else
		B738DR_slat2_deg = 1.0
	end

end

function B738_alt_horn_cut()
	if B738DR_cabin_alt_wrn == 0 then
		B738DR_alt_horn_cut_disable = 0
	end
end

function B738_gear_horn_cut()
	
	local cabin_gear_wrn = 0
	
	if B738DR_gear_handle_pos ~= 1 then
		if simDR_flaps_ratio >= 0.625 and B738DR_flight_phase > 4 and B738DR_flight_phase < 8 then
			cabin_gear_wrn = 1
		end
	end
	B738DR_cabin_gear_wrn = cabin_gear_wrn

	if B738DR_cabin_gear_wrn == 0 then
		B738DR_gear_horn_cut_disable = 0
	elseif simDR_throttle_1 > 0.7 or simDR_throttle_2 > 0.7 then
		B738DR_gear_horn_cut_disable = 1
	end
	
end

function B738_below_gs_disable()
	if B738DR_below_gs == 0 then
		B738DR_below_gs_disable = 0
	end
end


function B738_nose_steer()
	
	local nose_steer_deg_trg = 0
	local steer_left_brake = 0
	local steer_right_brake = 0
	local steer_position = 0
	local steer_pos_min = 0
	local steer_pos_max = 0
	
	local yoke_steer = 0
	
	-- deactivate Parking brate
	if simDR_left_brake > 0.9 and simDR_right_brake > 0.9 then
		B738DR_parking_brake_pos = 0
	end
	if left_brake > 0.25 and right_brake > 0.25 then
		B738DR_parking_brake_pos = 0
	end
	
	if B738DR_toe_brakes_ovr == 0 then
		simDR_brake = math.max(autobrake_ratio, B738DR_parking_brake_pos)
	else
		simDR_brake = B738DR_parking_brake_pos
	end
	
	
	if B738DR_chock_status == 0 then
	
		if simDR_faxil_plug ~= 0 then
			return
		end
		
		if B738DR_toe_brakes_ovr == 0 then
			simDR_steer_ovr = 0
			simDR_toe_brakes_ovr = 0
		else
			if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1
			or simDR_on_ground_2 == 1 then
				if B738DR_nosewheel == 1 then
					yoke_steer = simDR_yoke_hdg_ratio
				elseif B738DR_nosewheel == 2 then
					yoke_steer = simDR_yoke_roll2_ratio
				end
				if simDR_airspeed_pilot < 45 then
					simDR_toe_brakes_ovr = 1
					nose_steer_deg_trg = B738_rescale(-1, -65, 1, 65, yoke_steer)
					if B738DR_nosewheel == 0 then
						steer_position = simDR_steer_cmd
						steer_pos_min = -65
						steer_pos_max = 65
					else
						steer_position = yoke_steer
						steer_pos_min = -1
						steer_pos_max = 1
					end
					if steer_position < 0 then
						steer_left_brake = -B738_rescale(steer_pos_min, -0.15, steer_pos_max, 0.15, steer_position)
						steer_right_brake = 0
						if simDR_ground_speed < 5 then
							steer_left_brake = B738_rescale(0, 0, 5, steer_left_brake, simDR_ground_speed)
						end
					else
						steer_left_brake = 0
						steer_right_brake = B738_rescale(steer_pos_min, -0.15, steer_pos_max, 0.15, steer_position)
						if simDR_ground_speed < 5 then
							steer_right_brake = B738_rescale(0, 0, 5, steer_right_brake, simDR_ground_speed)
						end
					end
					if B738DR_nosewheel > 0 then
						simDR_steer_ovr = 1
						--simDR_steer_cmd = B738_set_anim_value(simDR_steer_cmd, nose_steer_deg_trg, -65, 65, 8)
						simDR_steer_cmd = B738_set_anim_value(simDR_steer_cmd, nose_steer_deg_trg, -65, 65, 4)
					else
						simDR_steer_ovr = 0
					end
					simDR_left_brake = math.max(left_brake, steer_left_brake, autobrake_ratio)
					simDR_right_brake = math.max(right_brake, steer_right_brake, autobrake_ratio)
				else
					simDR_steer_ovr = 0
					if left_brake > 0 or right_brake > 0 then
						simDR_toe_brakes_ovr = 1
						simDR_left_brake = left_brake
						simDR_right_brake = right_brake
					else
						simDR_toe_brakes_ovr = 0
					end
					if B738DR_nosewheel > 0 then
						simDR_steer_cmd = 0
					end
					simDR_brake = math.max(autobrake_ratio, B738DR_parking_brake_pos)
				end
			else
				simDR_steer_ovr = 0
				if left_brake > 0 or right_brake > 0 then
					simDR_toe_brakes_ovr = 1
					simDR_left_brake = left_brake
					simDR_right_brake = right_brake
				else
					simDR_toe_brakes_ovr = 0
				end
				simDR_steer_cmd = 0
				simDR_brake = math.max(autobrake_ratio, B738DR_parking_brake_pos)
			end
			
		end
	
	else
		simDR_steer_ovr = 1
		--simDR_left_brake = left_brake
		--simDR_right_brake = right_brake
	end
	
	local ground_speed_kts = simDR_ground_speed * 1.9438
	local limit_ground_speed = math.min(80, ground_speed_kts)
	local limit_ground_speed2 = math.min(20, ground_speed_kts)
	local max_roll_brake = B738_rescale(0, 0.9, 40, 1.5, limit_ground_speed)
	local min_roll_brake = B738_rescale(0, 0.8, 40, 0.9, limit_ground_speed)
	local abs_steer_cmd = simDR_steer_cmd
	if abs_steer_cmd < 0 then
		abs_steer_cmd = -abs_steer_cmd
	end
	simDR_roll_brake = B738_rescale(0, min_roll_brake, 65, max_roll_brake, abs_steer_cmd)
	if ground_speed_kts < 2 then
		simDR_roll_co = 0.021
	else
		simDR_roll_co = B738_rescale(0, 0.015, 20, 0.025, limit_ground_speed2)
	end
end


function B738_manual_vspeed()

	-- auto
	if B738DR_spd_ref == 0 then
		B738DR_man_vspd_show = 0
		B738DR_man_vspeed_mode = 0
	
	-- set
	elseif B738DR_spd_ref == 6 then
		B738DR_man_vspd_show = 0
		B738DR_man_vspeed_mode = 0
	
	else
		-- on the ground
		if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1
		or simDR_on_ground_2 == 1 then
			
			-- V1
			if B738DR_spd_ref == 1 then
				B738DR_man_vspd_show = 1
				B738DR_man_vspeed_mode = 1
				B738DR_man_v1 = B738DR_spd_ref_adjust
				B738DR_man_vspd = B738DR_man_v1
				
			-- Vr
			elseif B738DR_spd_ref == 2 then
				B738DR_man_vspd_show = 1
				B738DR_man_vspeed_mode = 2
				B738DR_man_vr = B738DR_spd_ref_adjust
				B738DR_man_vspd = B738DR_man_vr
			
			-- Vref
			elseif B738DR_spd_ref == 4 then
				B738DR_man_vspd_show = 0
				B738DR_man_vspeed_mode = 4
			else
				B738DR_man_vspd_show = 0
				B738DR_man_vspeed_mode = 0
			end
		
		-- in air
		else
			-- V1
			if B738DR_spd_ref == 1 then
				B738DR_man_vspd_show = 0
				B738DR_man_vspeed_mode = 4
			
			-- Vr
			elseif B738DR_spd_ref == 2 then
				B738DR_man_vspd_show = 0
				B738DR_man_vspeed_mode = 4
			
			-- Vref
			elseif B738DR_spd_ref == 4 then
				B738DR_man_vspd_show = 1
				B738DR_man_vspeed_mode = 3
				B738DR_man_vref = B738DR_spd_ref_adjust
				B738DR_man_vspd = B738DR_man_vref
			else
				B738DR_man_vspd_show = 0
				B738DR_man_vspeed_mode = 0
			end
		end
	end

end

function B738_APU_fuel_burn()
	-- 100 kg/hours = 0.027778 kg/sec
	-- simDR_tank_r_status
	-- simDR_tank_c_status
	-- simDR_tank_l_status
	-- B738DR_fuel_tank_pos_lft1	Left AFT
	-- B738DR_fuel_tank_pos_lft2	Left FWD
	-- B738DR_fuel_tank_pos_rgt1	Right AFT
	-- B738DR_fuel_tank_pos_rgt2	Right FWD
	-- B738DR_fuel_tank_pos_ctr1	Center L
	-- B738DR_fuel_tank_pos_ctr2	Center R
	-- B738DR_cross_feed_selector_knob	0-off, 1-on
	
	local tank_status = simDR_tank_r_status + simDR_tank_c_status + simDR_tank_l_status
	local apu_fuel_ratio = APU_FUEL_BURN
	
	if simDR_apu_run == 1 then
		if tank_status == 0 then
			simDR_fuel_tank_weight_kg[0] = math.max (0, simDR_fuel_tank_weight_kg[0] - apu_fuel_ratio)
		else
			if B738DR_cross_feed_selector_knob == 0 then
				if simDR_tank_l_status == 1 and B738DR_fuel_tank_pos_ctr1 == 1 then
					apu_fuel_ratio = APU_FUEL_BURN / 2
				end
				-- left tank => AFT 1 or FWD 1
				if simDR_tank_l_status == 1 then
					simDR_fuel_tank_weight_kg[0] = math.max (0, simDR_fuel_tank_weight_kg[0] - apu_fuel_ratio)
				end
				-- center tank => CTR L
				if B738DR_fuel_tank_pos_ctr1 == 1 then
					simDR_fuel_tank_weight_kg[1] = math.max (0, simDR_fuel_tank_weight_kg[1] - apu_fuel_ratio)
				end
			else
				apu_fuel_ratio = APU_FUEL_BURN / tank_status
				-- left tank
				if simDR_tank_l_status == 1 then
					simDR_fuel_tank_weight_kg[0] = math.max (0, simDR_fuel_tank_weight_kg[0] - apu_fuel_ratio)
				end
				-- center tank
				if simDR_tank_c_status == 1 then
					simDR_fuel_tank_weight_kg[1] = math.max (0, simDR_fuel_tank_weight_kg[1] - apu_fuel_ratio)
				end
				-- right tank
				if simDR_tank_r_status == 1 then
					simDR_fuel_tank_weight_kg[2] = math.max (0, simDR_fuel_tank_weight_kg[2] - apu_fuel_ratio)
				end
			end
		end
	end
	
	
end

function B738_fuel_tank_status()

	local imbal_enable = 0
	local diff_tank = 0
	
	if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1
	or simDR_on_ground_2 == 1 then
		imbal_enable = 0
	else
		imbal_enable = 1
	end
	diff_tank = math.abs(simDR_fuel_tank_weight_kg[0] - simDR_fuel_tank_weight_kg[2])
	if diff_tank > 453 then
		tank_imbal = 1
	end
	if diff_tank < 91 then
		tank_imbal = 0
	end
	
	-- LEFT TANK
	if simDR_fuel_tank_weight_kg[0] <= 453 then
		B738DR_fuel_left_status = 1			-- LOW
	else
		if tank_imbal == 0 or imbal_enable == 0 then
			B738DR_fuel_left_status = 0
		else
			B738DR_fuel_left_status = 2		--IMBAL
		end
	end
	
	-- RIGHT TANK
	if simDR_fuel_tank_weight_kg[2] <= 453 then
		B738DR_fuel_right_status = 1		-- LOW
	else
		if tank_imbal == 0 or imbal_enable == 0 then
			B738DR_fuel_right_status = 0
		else
			B738DR_fuel_right_status = 2	-- IMBAL
		end
	end
	
	-- CENTER TANK
	local engine_running = 1
	
	if simDR_engine_N1_pct1 < 11 and simDR_engine_N1_pct2 < 11 then
		engine_running = 0
	end
	-- if simDR_fuel_tank_weight_kg[1] > 726 and simDR_tank_c_status == 0 then
		-- tank_config = 1
	-- else
		-- if simDR_tank_c_status == 1 then
			-- tank_config = 0
		-- end
	-- end
	-- if engine_running == 0 or simDR_fuel_tank_weight_kg[1] < 363 then
		-- tank_config = 0
	-- end
	-- if simDR_fuel_tank_weight_kg[1] <= 453 then
		-- B738DR_fuel_center_status = 1		-- LOW
	-- else
		-- if tank_config == 0 then
			-- B738DR_fuel_center_status = 0
		-- else
			-- B738DR_fuel_center_status = 3	-- CONFIG
		-- end
	-- end
	if engine_running == 1 and simDR_fuel_tank_weight_kg[1] > 726 and simDR_tank_c_status == 0 then
		tank_config = 1
	else
		tank_config = 0
	end
	-- if engine_running == 0 and simDR_fuel_tank_weight_kg[1] < 363 then
		-- tank_config = 0
	-- end
	if tank_config == 0 then
		B738DR_fuel_center_status = 0
	else
		B738DR_fuel_center_status = 3	-- CONFIG
	end
	
	B738DR_left_tank_kgs = roundUpToIncrement(simDR_fuel_tank_weight_kg[0], 10)
	B738DR_center_tank_kgs = roundUpToIncrement(simDR_fuel_tank_weight_kg[1], 10)
	B738DR_right_tank_kgs = roundUpToIncrement(simDR_fuel_tank_weight_kg[2], 10)
	B738DR_left_tank_lbs = roundUpToIncrement(simDR_fuel_tank_weight_kg[0] * 2.20462262, 10)
	B738DR_center_tank_lbs = roundUpToIncrement(simDR_fuel_tank_weight_kg[1] * 2.20462262, 10)
	B738DR_right_tank_lbs = roundUpToIncrement(simDR_fuel_tank_weight_kg[2] * 2.20462262, 10)

end

function B738_gpws()
	
	B738DR_gpws_flap_cover_pos = B738_set_anim_value(B738DR_gpws_flap_cover_pos, flap_cover_target, 0.0, 1.0, 10.0)
	B738DR_gpws_gear_cover_pos = B738_set_anim_value(B738DR_gpws_gear_cover_pos, gear_cover_target, 0.0, 1.0, 10.0)
	B738DR_gpws_terr_cover_pos = B738_set_anim_value(B738DR_gpws_terr_cover_pos, terr_cover_target, 0.0, 1.0, 10.0)
	
	if B738DR_gpws_flap_cover_pos < 0.3 and B738DR_gpws_flap_pos == 1 then
		B738DR_gpws_flap_pos = 0
	end
	if B738DR_gpws_gear_cover_pos < 0.3 and B738DR_gpws_gear_pos == 1 then
		B738DR_gpws_gear_pos = 0
	end
	if B738DR_gpws_terr_cover_pos < 0.3 and B738DR_gpws_terr_pos == 1 then
		B738DR_gpws_terr_pos = 0
	end
	
	if B738DR_gpws_test_pos == 0 and gpws_test_timer > 0 then
		if gpws_test_timer > 2 then
			B738DR_enable_gpwstest_long = 0
			gpws_test_timer = 0
		else	--if  gpws_test_timer > 0 then
			gpws_test_timer = gpws_test_timer - 0.05
			if gpws_test_timer <= 0 then
				B738DR_enable_gpwstest_short = 0
				gpws_test_timer = 0
			end
		end
	end
	
	B738DR_fdr_cover_pos = B738_set_anim_value(B738DR_fdr_cover_pos, fdr_cover_target, 0.0, 1.0, 10.0)
	if B738DR_fdr_pos == 1 then
		if fdr_cover_target == 0 and B738DR_fdr_cover_pos < 0.3 then
			B738DR_fdr_pos = 0
		end
	end

end

function gear_handle_timer()
	gear_handle_aret = 1
end

function B738_gear_handle()
	
	local min_tgt_gear = 0
  if B738DR_gear_lock_override_pos == 1 then
		gear_lock = 0
		min_tgt_gear = 0
	elseif simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1 or simDR_on_ground_2 == 1 then
		gear_lock = 1
		min_tgt_gear = 0.5
	else
		gear_lock = 0
		min_tgt_gear = 0
	end
	
	if B738DR_gear_handle_pos < 0.5 then
		B738DR_gear_handle_pos = B738DR_gear_handle_act
	else
		B738DR_gear_handle_pos = math.max(B738DR_gear_handle_act, min_tgt_gear)
	end
	
	if B738DR_gear_handle_pos ~= gear_handle_pos_old then
		if is_timer_scheduled(gear_handle_timer) == true then
			stop_timer(gear_handle_timer)
		end
		gear_handle_aret = 0
	else
		if is_timer_scheduled(gear_handle_timer) == false then
			run_after_time(gear_handle_timer, 0.6)
		end
	end
	gear_handle_pos_old = B738DR_gear_handle_pos
	
	if gear_handle_aret == 1 then
		if B738DR_gear_handle_pos > 0.85 then
			B738DR_gear_handle_pos = 1
			B738DR_gear_handle_act = 1
			B738CMD_gear_down:once()
		elseif B738DR_gear_handle_pos < 0.15 then
			B738DR_gear_handle_pos = 0
			B738DR_gear_handle_act = 0
			B738CMD_gear_up:once()
		elseif B738DR_gear_handle_pos > 0.35 and B738DR_gear_handle_pos < 0.70 then
			B738DR_gear_handle_pos = 0.5
			B738DR_gear_handle_act = 0.5
			B738CMD_gear_off:once()
		end
		gear_handle_aret = 0
	end
	
	
end

function B738_man_land_gear()
	
	 local int, frac = math.modf(os.clock())
	 local seed = 0
	 local dif_time = 0
	
	B738DR_landgear_cover_pos = B738_set_anim_value(B738DR_landgear_cover_pos, man_landgear_cover_target, 0.0, 1.0, 10.0)
	B738DR_landgear_pos = B738_set_anim_value(B738DR_landgear_pos, man_landgear_target, 0.0, 1.0, 10.0)
	if B738DR_landgear_pos > 0.9 then --and B738DR_landgear_pos < 0.95 then
		landing_gear_target = 1
		simDR_gear_handle_status = 1
	end
	
	-- generate time
	if landing_gear0_act == 1 and landing_gear_target == 0 then
		seed = math.random(1, frac*1000.0)
		math.randomseed(seed)
		dif_time = math.random(0.1, 0.6)
		
		LANDGEAR_NOSE_UP_TIME = math.random(12, 13)
		LANDGEAR_LEFT_UP_TIME = math.random(14, 15)
		if LANDGEAR_LEFT_UP_TIME > 14.5 then
			LANDGEAR_RIGHT_UP_TIME = LANDGEAR_LEFT_UP_TIME - dif_time
		else
			LANDGEAR_RIGHT_UP_TIME = LANDGEAR_LEFT_UP_TIME + dif_time
		end
	end
	
	if landing_gear0_act == 0 and landing_gear_target == 1 then
		seed = math.random(1, frac*1000.0)
		math.randomseed(seed)
		dif_time = math.random(0.1, 0.6)
		
		LANDGEAR_NOSE_DN_TIME = math.random(15, 16)
		LANDGEAR_LEFT_DN_TIME = math.random(17, 18)
		if LANDGEAR_LEFT_UP_TIME > 17.5 then
			LANDGEAR_RIGHT_UP_TIME = LANDGEAR_LEFT_UP_TIME - dif_time
		else
			LANDGEAR_RIGHT_UP_TIME = LANDGEAR_LEFT_UP_TIME + dif_time
		end
		
		LANDGEAR_NOSE_MAN_TIME = math.random(16, 17)
		LANDGEAR_LEFT_MAN_TIME = math.random(18, 19)
		if LANDGEAR_LEFT_UP_TIME > 17.5 then
			LANDGEAR_RIGHT_MAN_TIME = LANDGEAR_LEFT_MAN_TIME - dif_time
		else
			LANDGEAR_RIGHT_MAN_TIME = LANDGEAR_LEFT_MAN_TIME + dif_time
		end
	end
	
	-- no wheel on the ground
	if simDR_on_ground_0 == 0 and simDR_on_ground_1 == 0
	and simDR_on_ground_2 == 0 then
		if B738DR_hyd_A_status > 0 then
			if landing_gear_target == 0 then
				if simDR_airspeed_pilot < 235 then
					if B738DR_gear_handle_pos ~= 0.5 then
						--landing_gear_act = B738_set_anim_time(landing_gear_act, landing_gear_target, 0.0, 1.0, 0, 14.0)
						landing_gear0_act = B738_set_anim_time(landing_gear0_act, landing_gear_target, 0.0, 1.0, 0, LANDGEAR_NOSE_UP_TIME)
						landing_gear1_act = B738_set_anim_time(landing_gear1_act, landing_gear_target, 0.0, 1.0, 0, LANDGEAR_LEFT_UP_TIME)
						landing_gear2_act = B738_set_anim_time(landing_gear2_act, landing_gear_target, 0.0, 1.0, 0, LANDGEAR_RIGHT_UP_TIME)
					end
					simDR_gear_handle_status = 0
				end
			else
				if simDR_airspeed_pilot < 270 then
					if B738DR_gear_handle_pos ~= 0.5 or B738DR_landgear_pos > 0.9 then
						--landing_gear_act = B738_set_anim_time(landing_gear_act, landing_gear_target, 0.0, 1.0, 1, 17.0)
						landing_gear0_act = B738_set_anim_time(landing_gear0_act, landing_gear_target, 0.0, 1.0, 1, LANDGEAR_NOSE_DN_TIME)
						landing_gear1_act = B738_set_anim_time(landing_gear1_act, landing_gear_target, 0.0, 1.0, 1, LANDGEAR_LEFT_DN_TIME)
						landing_gear2_act = B738_set_anim_time(landing_gear2_act, landing_gear_target, 0.0, 1.0, 1, LANDGEAR_RIGHT_DN_TIME)
					end
					simDR_gear_handle_status = 1
				end
			end
		else
			if simDR_airspeed_pilot < 270 and B738DR_landgear_pos > 0.9 then
				--landing_gear_act = B738_set_anim_time(landing_gear_act, landing_gear_target, 0.0, 1.0, 1, 19.0)		-- manual gear extend 19 secs
				landing_gear0_act = B738_set_anim_time(landing_gear0_act, 1, 0.0, 1.0, 1, LANDGEAR_NOSE_MAN_TIME)
				landing_gear1_act = B738_set_anim_time(landing_gear1_act, 1, 0.0, 1.0, 1, LANDGEAR_LEFT_MAN_TIME)
				landing_gear2_act = B738_set_anim_time(landing_gear2_act, 1, 0.0, 1.0, 1, LANDGEAR_RIGHT_MAN_TIME)
				--simDR_gear_handle_status = 1
			end
		end
	end
	
	simDR_gear_deploy_0 = landing_gear0_act
	simDR_gear_deploy_1 = landing_gear1_act
	simDR_gear_deploy_2 = landing_gear2_act
	
end


function B738_hydraulic_sys()
	
	-- HYD A pressure
	local el_hyd_pump_A = 0
	local hyd_A_pressure_target1 = 0
	local hyd_min = 0
	if B738DR_el_hydro_pumps1_switch_position == 1 and B738DR_ac_tnsbus2_status == 1 then
		hyd_A_pressure_target1 = 2850
		el_hyd_pump_A = 1
	end
	local hyd_A_pressure_target2 = 0
	if B738DR_hydro_pumps1_switch_position == 1 and B738DR_engine01_fire_ext_switch_pos_arm == 0 then
		if simDR_engine_N1_pct1 > 18 then
			hyd_min = hyd_1_max - 83
			hyd_min = math.max(2810, hyd_min)
			--hyd_A_pressure_target2 = B738_rescale(18, 1120, 105, hyd_1_max, simDR_engine_N1_pct1)
			hyd_A_pressure_target2 = B738_rescale(18, hyd_min, 105, hyd_1_max, simDR_engine_N1_pct1)
		else
			hyd_A_pressure_target2 = B738_rescale(0, 0, 18, 1120, simDR_engine_N1_pct1)
		end
	end
	local hyd_A_pressure_target = math.max(hyd_A_pressure_target1, hyd_A_pressure_target2)
	if hyd_A_pressure_target > hyd_A_pressure then
		if el_hyd_pump_A == 1 then
			hyd_A_pressure = B738_set_anim_value(hyd_A_pressure, hyd_A_pressure_target, 0, 3500, 1.15)
		else
			hyd_A_pressure = B738_set_anim_value(hyd_A_pressure, hyd_A_pressure_target, 0, 3500, 0.11)
		end
	else
		if hyd_A_pressure > 1000 then
			hyd_A_pressure = B738_set_anim_value(hyd_A_pressure, hyd_A_pressure_target, 0, 3500, 0.10)
		else
			hyd_A_pressure = B738_set_anim_value(hyd_A_pressure, hyd_A_pressure_target, 0, 3500, 0.05)
		end
	end
	B738DR_hyd_A_pressure = roundDownToIncrement(hyd_A_pressure, 10)
	
	-- HYD B pressure
	local el_hyd_pump_B = 0
	local hyd_B_pressure_target1 = 0
	if B738DR_el_hydro_pumps2_switch_position == 1 and B738DR_ac_tnsbus1_status == 1 then
		hyd_B_pressure_target1 = 2820
		el_hyd_pump_B = 1
	end
	local hyd_B_pressure_target2 = 0
	if B738DR_hydro_pumps2_switch_position == 1 and B738DR_engine02_fire_ext_switch_pos_arm == 0 then
		if simDR_engine_N1_pct2 > 18 then
			hyd_min = hyd_2_max - 83
			hyd_min = math.max(2810, hyd_min)
			--hyd_B_pressure_target2 = B738_rescale(18, 1120, 105, hyd_2_max, simDR_engine_N1_pct2)
			hyd_B_pressure_target2 = B738_rescale(18, hyd_min, 105, hyd_2_max, simDR_engine_N1_pct2)
		else
			hyd_B_pressure_target2 = B738_rescale(0, 0, 18, 1120, simDR_engine_N1_pct2)
		end
	end
	local hyd_B_pressure_target = math.max(hyd_B_pressure_target1, hyd_B_pressure_target2)
	if hyd_B_pressure_target > hyd_B_pressure then
		if el_hyd_pump_B == 1 then
			hyd_B_pressure = B738_set_anim_value(hyd_B_pressure, hyd_B_pressure_target, 0, 3500, 1.15)
		else
			hyd_B_pressure = B738_set_anim_value(hyd_B_pressure, hyd_B_pressure_target, 0, 3500, 0.11)
		end
	else
		if hyd_B_pressure > 500 then
			hyd_B_pressure = B738_set_anim_value(hyd_B_pressure, hyd_B_pressure_target, 0, 3500, 0.37)
		else
			hyd_B_pressure = B738_set_anim_value(hyd_B_pressure, hyd_B_pressure_target, 0, 3500, 0.09)
		end
	end
	B738DR_hyd_B_pressure = roundDownToIncrement(hyd_B_pressure, 10)
	
	-- HYD STANDBY
	local hyd_stdby_pressure_target = 0
	-- if simDR_engine_N1_pct2 > 18 then
		-- hyd_stdby_pressure_target = B738_rescale(18, 1120, 105, hyd_2_max, simDR_engine_N1_pct2)
	-- else
		-- hyd_stdby_pressure_target = B738_rescale(0, 0, 18, 1120, simDR_engine_N1_pct2)
	-- end
	hyd_stdby_pressure_target = 2700
	if hyd_stdby_pressure_target > hyd_stdby_pressure then
		hyd_stdby_pressure = B738_set_anim_value(hyd_stdby_pressure, hyd_stdby_pressure_target, 0, 2980, 0.63)
	else
		hyd_stdby_pressure = B738_set_anim_value(hyd_stdby_pressure, hyd_stdby_pressure_target, 0, 2980, 0.18)
	end
	B738DR_hyd_stdby_pressure = roundDownToIncrement(hyd_stdby_pressure, 10)
	
	-- HYD A
	if B738DR_hyd_A_pressure > 1000 then	-- HYD system A
		B738DR_hyd_A_status = 1		-- norm
	else
		B738DR_hyd_A_status = 0		-- fail
	end
	
	-- HYD B
	if B738DR_hyd_B_pressure > 1000 then	-- HYD system B
		B738DR_hyd_B_status = 1		-- norm
	else
		B738DR_hyd_B_status = 0		-- fail
	end
	
	-- HYD STANDBY
	if B738DR_hyd_stdby_pressure > 1000 then	-- HYD system STANDBY
		B738DR_hyd_stdby_status = 1		-- norm
	else
		B738DR_hyd_stdby_status = 0		-- fail
	end
	
	
	-- HYD A RUD
	if B738DR_flt_ctr_A_pos == 0 then
		B738DR_hyd_A_rud = 0	-- off
	else
		if B738DR_hyd_stdby_status == 0 and B738DR_hyd_A_status == 0 then
			B738DR_hyd_A_rud = 0	-- off
		else
			B738DR_hyd_A_rud = 1	-- auto/on
		end
	end
	
	-- HYD B RUD
	if B738DR_flt_ctr_B_pos == 0 then
		B738DR_hyd_B_rud = 0	-- off
	else
		if B738DR_hyd_stdby_status == 0 and B738DR_hyd_B_status == 0 then
			B738DR_hyd_B_rud = 0	-- off
		else
			B738DR_hyd_B_rud = 1	-- auto/on
		end
	end
	
	local yoke_heading_ratio = 0
	local yoke_pitch_ratio = 0
	local yoke_roll_ratio = 0
	local yoke_heading_ratio_tgt = 0
	local yoke_pitch_ratio_tgt = 0
	local yoke_roll_ratio_tgt = 0
	simDR_yoke_heading_ratio = B738DR_joy_axis_heading	--simDR_axis[B738DR_joy_axis_heading]
	simDR_yoke_pitch_ratio = B738DR_joy_axis_pitch		--simDR_axis[B738DR_joy_axis_pitch]
	simDR_yoke_roll_ratio = B738DR_joy_axis_roll		--simDR_axis[B738DR_joy_axis_roll]
	
	
	if B738DR_hyd_A_rud == 0 and B738DR_hyd_B_rud == 0 then
		
		simDR_override_heading = 1
		simDR_override_pitch = 1
		simDR_override_roll = 1
		
		yoke_heading_ratio_tgt = simDR_yoke_heading_ratio
		if yoke_heading_ratio_tgt > 0.2 then
			yoke_heading_ratio_tgt = 0.2
		end
		if yoke_heading_ratio_tgt < -0.2 then
			yoke_heading_ratio_tgt = -0.2
		end
		--yoke_heading_ratio = B738_rescale(-1, 0, 1, 2, yoke_heading_ratio_tgt) - 1
		act_heading_ratio = B738_set_anim_value(act_heading_ratio, yoke_heading_ratio_tgt, -1, 1, 1)
		-- if act_heading_ratio > 0.2 or act_heading_ratio < -0.2 then
			-- act_heading_ratio_trg = 0
			-- act_heading_ratio = B738_set_anim_value(act_heading_ratio, act_heading_ratio_trg, -1, 1, 1)
		-- else
			-- if yoke_heading_ratio == 0 then
				-- act_heading_ratio_trg = 0
				-- act_heading_ratio = B738_set_anim_value(act_heading_ratio, act_heading_ratio_trg, -1, 1, 1)
			-- else
				-- act_heading_ratio = yoke_heading_ratio
			-- end
		-- end
		
		yoke_pitch_ratio_tgt = simDR_yoke_pitch_ratio
		if yoke_pitch_ratio_tgt > 0.2 then
			yoke_pitch_ratio_tgt = 0.2
		end
		if yoke_pitch_ratio_tgt < -0.2 then
			yoke_pitch_ratio_tgt = -0.2
		end
		--yoke_pitch_ratio = B738_rescale(0, 0, 1, 2, yoke_pitch_ratio_tgt) - 1
		act_pitch_ratio = B738_set_anim_value(act_pitch_ratio, yoke_pitch_ratio_tgt, -1, 1, 1)
		-- if act_pitch_ratio > 0.2 or act_pitch_ratio < -0.2 then
			-- act_pitch_ratio_trg = 0
			-- act_pitch_ratio = B738_set_anim_value(act_pitch_ratio, act_pitch_ratio_trg, -1, 1, 1)
		-- else
			-- if yoke_pitch_ratio == 0 then
				-- act_pitch_ratio_trg = 0
				-- act_pitch_ratio = B738_set_anim_value(act_pitch_ratio, act_pitch_ratio_trg, -1, 1, 1)
			-- else
				-- act_pitch_ratio = yoke_pitch_ratio
			-- end
		-- end
		
		yoke_roll_ratio_tgt = simDR_yoke_roll_ratio
		if yoke_roll_ratio_tgt > 0.2 then
			yoke_roll_ratio_tgt = 0.2
		end
		if yoke_roll_ratio_tgt < -0.2 then
			yoke_roll_ratio_tgt = -0.2
		end
		--yoke_roll_ratio = B738_rescale(0, 0, 1, 2, yoke_roll_ratio_tgt) - 1
		act_roll_ratio = B738_set_anim_value(act_roll_ratio, yoke_roll_ratio_tgt, -1, 1, 1)
		-- if act_roll_ratio > 0.2 or act_roll_ratio < -0.2 then
			-- act_roll_ratio_trg = 0
			-- act_roll_ratio = B738_set_anim_value(act_roll_ratio, act_roll_ratio_trg, -1, 1, 1)
		-- else
			-- if yoke_roll_ratio == 0 then
				-- act_roll_ratio_trg = 0
				-- act_roll_ratio = B738_set_anim_value(act_roll_ratio, act_roll_ratio_trg, -1, 1, 1)
			-- else
				-- act_roll_ratio = yoke_roll_ratio
			-- end
		-- end
		
		simDR_heading_ratio = act_heading_ratio
		simDR_pitch_ratio = act_pitch_ratio
		simDR_roll_ratio = act_roll_ratio
	
	else
		
		simDR_override_heading = 0
		simDR_override_pitch = 0
		simDR_override_roll = 0
		act_heading_ratio = simDR_heading_ratio
		act_pitch_ratio = simDR_pitch_ratio
		act_roll_ratio = simDR_roll_ratio
		
	end
	
	-- HYD QUANTITY
	local hyd_1_corr = B738_rescale(0, 0, 50, 5, simDR_spoiler_left)
	local hyd_2_corr = B738_rescale(0, 0, 50, 5, simDR_spoiler_right)
	
	B738DR_hyd_A_qty = hyd_1_qnt + hyd_1_corr
	B738DR_hyd_B_qty = hyd_2_qnt + hyd_2_corr

end

function B738_wipers()

	--if simDR_bus_battery1 > 12 and simDR_bus_battery1_on == 1 then
	if B738DR_ac_tnsbus1_status == 1 then
		-- LEFT WIPER
		if B738DR_left_wiper_ratio == 72 then
			left_wiper_timer = left_wiper_timer + SIM_PERIOD
			if left_wiper_timer >= WIPER_TIMER then
				left_wiper_target = 0
				left_wiper_timer = 0
			end
		end
		
		if B738DR_left_wiper_pos > 0 then
			if B738DR_left_wiper_ratio == 0 then
				left_wiper_timer = left_wiper_timer + SIM_PERIOD
				if B738DR_left_wiper_pos == 1 then
					if left_wiper_timer >= WIPER_INT_TIMER or l_wiper_first == 1 then
						left_wiper_target = 72
						left_wiper_timer = 0
						l_wiper_first = 0
					end
				else
					if left_wiper_timer >= WIPER_TIMER then
						left_wiper_target = 72
						left_wiper_timer = 0
					end
				end
			end
		end
		
		if B738DR_left_wiper_pos == 1 then
			left_wiper_speed = WIPER_LOW_SPEED
		elseif B738DR_left_wiper_pos == 2 then
			left_wiper_speed = WIPER_LOW_SPEED
		elseif B738DR_left_wiper_pos == 3 then
			left_wiper_speed = WIPER_HIGH_SPEED
		end
		
		if left_wiper_target == 0 then
			B738DR_left_wiper_ratio = B738_set_anim_time(B738DR_left_wiper_ratio, left_wiper_target, 0.0, 72.0, 0, left_wiper_speed)
		else
			B738DR_left_wiper_ratio = B738_set_anim_time(B738DR_left_wiper_ratio, left_wiper_target, 0.0, 72.0, 1, left_wiper_speed)
		end
		
		if left_wiper_target == 0 then
			if B738DR_left_wiper_ratio > 0 then
				B738DR_left_wiper_up = 0
			else
				B738DR_left_wiper_up = -1
			end
		else
			B738DR_left_wiper_up = 1
		end
	else
		B738DR_left_wiper_up = -1
		left_wiper_target = 0
	end
	
	
	if B738DR_ac_tnsbus2_status == 1 then
		
		-- RIGHT WIPER
		if B738DR_right_wiper_ratio == 72 then
			right_wiper_timer = right_wiper_timer + SIM_PERIOD
			if right_wiper_timer >= WIPER_TIMER then
				right_wiper_target = 0
				right_wiper_timer = 0
			end
		end
		
		if B738DR_right_wiper_pos > 0 then
			if B738DR_right_wiper_ratio == 0 then
				right_wiper_timer = right_wiper_timer + SIM_PERIOD
				if B738DR_right_wiper_pos == 1 then
					if right_wiper_timer >= WIPER_INT_TIMER or r_wiper_first == 1 then
						right_wiper_target = 72
						right_wiper_timer = 0
						r_wiper_first = 0
					end
				else
					if right_wiper_timer >= WIPER_TIMER then
						right_wiper_target = 72
						right_wiper_timer = 0
					end
				end
			end
		end
		
		if B738DR_right_wiper_pos == 1 then
			right_wiper_speed = WIPER_LOW_SPEED
		elseif B738DR_right_wiper_pos == 2 then
			right_wiper_speed = WIPER_LOW_SPEED
		elseif B738DR_right_wiper_pos == 3 then
			right_wiper_speed = WIPER_HIGH_SPEED
		end
		
		if right_wiper_target == 0 then
			B738DR_right_wiper_ratio = B738_set_anim_time(B738DR_right_wiper_ratio, right_wiper_target, 0.0, 72.0, 0, right_wiper_speed)
		else
			B738DR_right_wiper_ratio = B738_set_anim_time(B738DR_right_wiper_ratio, right_wiper_target, 0.0, 72.0, 1, right_wiper_speed)
		end
		
		if right_wiper_target == 0 then
			if B738DR_right_wiper_ratio > 0 then
				B738DR_right_wiper_up = 0
			else
				B738DR_right_wiper_up = -1
			end
		else
			B738DR_right_wiper_up = 1
		end
		
	else
		right_wiper_target = 0
		B738DR_right_wiper_up = -1
	end
	
end

function real_systems_update()
	
	-- BRAKE PRESSURE
	brake_press_target = B738DR_brake_press + brake_compress - brake_decompress
	brake_press_target = math.max(1000, brake_press_target, hyd_A_pressure, hyd_B_pressure)
	brake_decompress = 0
	
end

function B738_brakes_press_system()
	
	--brake_press_target = 3120	-- 3120 psi
	
	local delta_pressure = 0
	local brake1 = 0
	local brake2 = 0
	local brake3 = 0
	
	if B738DR_hyd_B_status == 0 then
		brake1 = B738_rescale(0, 0, 3000, 3310, hyd_A_pressure)
		delta_pressure = math.max(0, brake1 - B738DR_brake_press)
		delta_pressure = math.min(3310, delta_pressure)
	else
		brake1 = B738_rescale(0, 0, 3000, 3320, hyd_B_pressure)
		delta_pressure = math.max(0, brake1 - B738DR_brake_press)
		delta_pressure = math.min(3320, delta_pressure)
	end
	
	brake_compress = B738_rescale(0, 0, 3400, 6540, delta_pressure)
	
	if B738DR_parking_brake_pos ~= simDR_brake_old then
		brake3 = 150
	end
	if simDR_left_brake ~= simDR_left_brake_old then
		if simDR_left_brake > 0 then
			brake2 = B738_rescale(0, 0, 1, 20, simDR_left_brake)
		end
	end
	if simDR_right_brake ~= simDR_right_brake_old then
		if simDR_right_brake > 0 then
			brake2 = brake2 + B738_rescale(0, 0, 1, 20, simDR_right_brake)
		end
	end
	if autobrake_ratio > 0 then
		brake2 = brake2 + B738_rescale(0, 0, 1, 20, autobrake_ratio)
	end
	
	delta_pressure = brake_decompress + brake3 + brake2
	delta_pressure = delta_pressure - B738_rescale(0, 0, 3310, 18, brake1)
	if delta_pressure > 0 then
		brake_decompress = delta_pressure
	end
	
	simDR_brake_old = B738DR_parking_brake_pos
	simDR_left_brake_old = simDR_left_brake
	simDR_right_brake_old = simDR_right_brake
	
	if B738DR_brake_press < 700 then
		simDR_toe_brakes_ovr = 1
		simDR_brake = 0
		simDR_left_brake = 0
		simDR_right_brake = 0
		brake_inop = 1
	else
		--simDR_toe_brakes_ovr = B738DR_toe_brakes_ovr
		brake_inop = 0
	end
	
	-- brake press indicator
	B738DR_brake_press = B738_set_anim_value(B738DR_brake_press, brake_press_target, 0, 4000, 0.2)
	
end

function animate_covers()
	B738DR_flt_ctr_A_cover_pos = B738_set_anim_value(B738DR_flt_ctr_A_cover_pos, flt_ctr_A_target, 0.0, 1.0, 10.0)
	B738DR_flt_ctr_B_cover_pos = B738_set_anim_value(B738DR_flt_ctr_B_cover_pos, flt_ctr_B_target, 0.0, 1.0, 10.0)
	B738DR_spoiler_A_cover_pos = B738_set_anim_value(B738DR_spoiler_A_cover_pos, spoiler_A_target, 0.0, 1.0, 10.0)
	B738DR_spoiler_B_cover_pos = B738_set_anim_value(B738DR_spoiler_B_cover_pos, spoiler_B_target, 0.0, 1.0, 10.0)
	B738DR_alt_flaps_cover_pos = B738_set_anim_value(B738DR_alt_flaps_cover_pos, alt_flaps_target, 0.0, 1.0, 10.0)
	
	-- if B738DR_flt_ctr_A_cover_pos < 0.3 and B738DR_flt_ctr_A_pos == -1 then
		-- B738DR_flt_ctr_A_pos = 0
	-- end
	-- if B738DR_flt_ctr_B_cover_pos < 0.3 and B738DR_flt_ctr_B_pos == -1 then
		-- B738DR_flt_ctr_B_pos = 0
	-- end
	-- if B738DR_spoiler_A_cover_pos < 0.3 and B738DR_spoiler_A_pos == 1 then
		-- B738DR_spoiler_A_pos = 0
	-- end
	-- if B738DR_spoiler_B_cover_pos < 0.3 and B738DR_spoiler_B_pos == 1 then
		-- B738DR_spoiler_B_pos = 0
	-- end
	-- if B738DR_alt_flaps_cover_pos < 0.3 and B738DR_alt_flaps_pos == 1 then
		-- B738DR_alt_flaps_pos = 0
	-- end
	
	if B738DR_flt_ctr_A_cover_pos < 0.3 and B738DR_flt_ctr_A_pos ~= 1 then
		B738DR_flt_ctr_A_pos = 1
	end
	if B738DR_flt_ctr_B_cover_pos < 0.3 and B738DR_flt_ctr_B_pos ~= 1 then
		B738DR_flt_ctr_B_pos = 1
	end
	if B738DR_spoiler_A_cover_pos < 0.3 and B738DR_spoiler_A_pos ~= 0 then
		B738DR_spoiler_A_pos = 0
	end
	if B738DR_spoiler_B_cover_pos < 0.3 and B738DR_spoiler_B_pos ~= 0 then
		B738DR_spoiler_B_pos = 0
	end
	if B738DR_alt_flaps_cover_pos < 0.3 and B738DR_alt_flaps_pos ~= 0 then
		B738DR_alt_flaps_pos = 0
	end

end

function init_sys()

	 local int, frac = math.modf(os.clock())
	 local seed = math.random(1, frac*1000.0)
	 local differ = math.random(0, 35)
	 --hyd_1_max = math.random(2985, 3075)
	 hyd_1_max = math.random(2885, 2975)
	 if hyd_1_max < 2930 then
		hyd_2_max = hyd_1_max + differ
	 else
		hyd_2_max = hyd_1_max - differ
	 end
	 hyd_1_qnt = math.random(82, 88)
	 differ = math.random(0, 3)
	 if hyd_1_qnt < 85 then
		hyd_2_qnt = hyd_1_qnt + differ
	 else
		hyd_2_qnt = hyd_1_qnt - differ
	 end

end


function read_axis()
	
	if joy_axis_heading >= 0 then
		B738DR_joy_axis_heading = simDR_axis[joy_axis_heading]
	else
		B738DR_joy_axis_heading = -1
	end
	if joy_axis_pitch >= 0 then
		B738DR_joy_axis_pitch = simDR_axis[joy_axis_pitch]
	else
		B738DR_joy_axis_pitch = -1
	end
	if joy_axis_roll >= 0 then
		B738DR_joy_axis_roll = simDR_axis[joy_axis_roll]
	else
		B738DR_joy_axis_roll = -1
	end
	if joy_axis_throttle >= 0 then
		B738DR_joy_axis_throttle = simDR_axis[joy_axis_throttle]
		-- B738DR_joy_axis_throttle_min = simDR_axis_min[joy_axis_throttle]
		-- B738DR_joy_axis_throttle_max = simDR_axis_max[joy_axis_throttle]
	else
		B738DR_joy_axis_throttle = -1
	end
	if joy_axis_throttle1 >= 0 then
		B738DR_joy_axis_throttle1 = simDR_axis[joy_axis_throttle1]
		-- B738DR_joy_axis_throttle1_min = simDR_axis_min[joy_axis_throttle]
		-- B738DR_joy_axis_throttle1_max = simDR_axis_max[joy_axis_throttle]
	else
		B738DR_joy_axis_throttle1 = -1
	end
	if joy_axis_throttle2 >= 0 then
		B738DR_joy_axis_throttle2 = simDR_axis[joy_axis_throttle2]
		-- B738DR_joy_axis_throttle2_min = simDR_axis_min[joy_axis_throttle]
		-- B738DR_joy_axis_throttle2_max = simDR_axis_max[joy_axis_throttle]
	else
		B738DR_joy_axis_throttle2 = -1
	end
	if joy_axis_left_toe_brake >= 0 then
		B738DR_joy_axis_left_toe_brake = simDR_axis[joy_axis_left_toe_brake]
	else
		B738DR_joy_axis_left_toe_brake = -1
	end
	if joy_axis_right_toe_brake >= 0 then
		B738DR_joy_axis_right_toe_brake = simDR_axis[joy_axis_right_toe_brake]
	else
		B738DR_joy_axis_right_toe_brake = -1
	end
	if joy_axis_nosewheel >= 0 then
		B738DR_joy_axis_nosewheel = simDR_axis[joy_axis_nosewheel]
	else
		B738DR_joy_axis_nosewheel = -1
	end

end

function B738_pressurization()
	
	-- MODE: 0 - off, 1 - normal, 2 - alternate, 3 - manual
	local press_mode = 0
	local target_cabin_vvi = 0
	
	-- AUTO
	if B738DR_air_valve_ctrl == 0 then
		if B738DR_ac_tnsbus1_status == 1 then
			press_mode = 1
		elseif B738DR_ac_tnsbus2_status == 1 then
			press_mode = 2
		else
			press_mode = 0
		end
	-- ALTN
	elseif B738DR_air_valve_ctrl == 1 then
		if B738DR_ac_tnsbus2_status == 0 then
			press_mode = 0
		else
			press_mode = 2
		end
	-- MANUAL
	elseif B738DR_air_valve_ctrl == 2 then
		if B738DR_batbus_status == 0 then
			press_mode = 0
		else
			press_mode = 3
		end
	end
	
	if press_mode == 0 then
		dump_all = 1
		target_cabin_vvi = simDR_cabin_vvi
		target_cabin_alt = 41000
		B738DR_cabin_alt = simDR_cabin_alt
	elseif press_mode < 3 then
		target_cabin_alt = 8000
		tgt_outflow_valve = 0
		if simDR_altitude_pilot > 10000 then
			if (simDR_altitude_pilot - 450) > alt_pressurize_auto then
				if alt_pressurize_auto < 10000 then
					target_cabin_alt = 8000 + (simDR_altitude_pilot - 10000)
				else
					target_cabin_alt = 8000 + (simDR_altitude_pilot - alt_pressurize_auto)
				end
			end
			
			if target_cabin_alt == 8000 then
				dump_all = 0
				press_set_vvi = 800 --1500
				target_cabin_vvi = simDR_cabin_vvi
				B738DR_cabin_alt = simDR_cabin_alt
			else
				if simDR_cabin_alt < (target_cabin_alt - 50) then
					dump_all = 1
				end
				if simDR_cabin_alt > target_cabin_alt then
					dump_all = 0
					press_set_vvi = 8000 --1800
				end
				if simDR_cabin_alt > (target_cabin_alt - 500) and simDR_cabin_alt < (target_cabin_alt + 500) then
					target_cabin_vvi = 0
				else
					target_cabin_vvi = simDR_cabin_vvi
				end
				B738DR_cabin_alt = target_cabin_alt
			end
		else
			dump_all = 0
			target_cabin_vvi = simDR_cabin_vvi
			B738DR_cabin_alt = simDR_cabin_alt
			press_set_vvi = 800 --1500
		end
		if simDR_altitude_pilot < alt_pressurize_land then
			simDR_dump_all = 1
			tgt_outflow_valve = 1
		else
			if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1 or simDR_on_ground_2 == 1 then
				simDR_dump_all = 1
				tgt_outflow_valve = 1
			else
				simDR_dump_all = dump_all
			end
		end
	else
		if B738DR_air_valve_manual == -1 then
			dump_all = 0
			tgt_outflow_valve = 0
			press_set_vvi = 800 --2500
		end
		if B738DR_air_valve_manual == 1 then
			dump_all = 1
			tgt_outflow_valve = 1
		end
		if dump_all == 0 then
			target_cabin_alt = 0
		else
			target_cabin_alt = 41000
		end
		target_cabin_vvi = simDR_cabin_vvi
		B738DR_cabin_alt = simDR_cabin_alt
	end
	
	B738DR_cabin_vvi = B738_set_anim_value(B738DR_cabin_vvi, target_cabin_vvi, -4500, 4500, 0.8)
	
	simDR_cabin_alt_tgt = target_cabin_alt
	B738DR_pressurization_mode = press_mode
	simDR_press_set_vvi = press_set_vvi
	
	--if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1 or simDR_on_ground_2 == 1 then
		alt_pressurize_auto = simDR_press_max_alt
		alt_pressurize_land = B738DR_landing_alt_sel_rheo
	--end
	
	
	B738DR_outflow_valve = B738_set_anim_value(B738DR_outflow_valve, tgt_outflow_valve, 0, 1, 0.8)
	
end


function B738_air_cond()

	local rate_speed1 = 18
	local rate_speed2 = 23
	local rate_speed3 = 23
	local tat = 0
	local temp_zone = 0
	
	if B738DR_cont_cab_temp_ctrl_rheo == 0 then
		-- OFF
		temp_cont_cab_tgt = 24	--75F / 24 C
		temp_l_pack_tgt = 24	--75F / 24 C
	elseif B738DR_cont_cab_temp_ctrl_rheo == 0.5 then
		-- AUTO
		temp_cont_cab_tgt = 25	--75 F / 24 C
		temp_l_pack_tgt = temp_cont_cab_tgt
	else
		-- MANUAL
		temp_cont_cab_tgt = B738_rescale(0.0, 18, 1, 30, B738DR_cont_cab_temp_ctrl_rheo)	-- 65F-85F / 18C-30C 
		temp_l_pack_tgt = temp_cont_cab_tgt
	end
	
	if B738DR_fwd_cab_temp_ctrl_rheo == 0.5 then
		-- AUTO
		temp_fwd_pass_cab_tgt = 27
	else
		-- MANUAL
		temp_fwd_pass_cab_tgt = B738_rescale(0.0, 18, 1, 30, B738DR_fwd_cab_temp_ctrl_rheo)
	end
	
	if B738DR_aft_cab_temp_ctrl_rheo == 0.5 then
		-- AUTO
		temp_aft_pass_cab_tgt = 28
	else
		-- MANUAL
		temp_aft_pass_cab_tgt = B738_rescale(0.0, 18, 1, 30, B738DR_aft_cab_temp_ctrl_rheo)
	end
	-- PASS CAB OFF
	if B738DR_cont_cab_temp_ctrl_rheo == 0 then
		temp_l_pack_tgt = 24	--75F / 24 C
	end
	if B738DR_fwd_cab_temp_ctrl_rheo == 0 and B738DR_aft_cab_temp_ctrl_rheo == 0 then
		temp_fwd_pass_cab_tgt = 18	-- 65 F / 18 C
		temp_aft_pass_cab_tgt = 18	-- 65 F / 18 C
		temp_r_pack_tgt = 18	-- 65 F / 18 C
	else
		temp_r_pack_tgt = math.max(temp_fwd_pass_cab_tgt, temp_aft_pass_cab_tgt)
	end
	
	if B738DR_trim_air_pos == 1 then
		if B738DR_cont_cab_temp_ctrl_rheo ~= 0 and temp_cont_cab_tgt > temp_cont_cab then
			rate_speed1 = rate_speed1 - 10
		end
		if B738DR_fwd_cab_temp_ctrl_rheo ~= 0 and temp_fwd_pass_cab_tgt > temp_fwd_pass_cab then
			rate_speed2 = rate_speed2 - 10
		end
		if B738DR_aft_cab_temp_ctrl_rheo ~= 0 and temp_aft_pass_cab_tgt > temp_aft_pass_cab then
			rate_speed3 = rate_speed3 - 10
		end
	end
	if B738DR_l_recirc_fan_pos == 1 or B738DR_l_recirc_fan_pos == 1 then
		rate_speed2 = rate_speed2 - 5
		rate_speed3 = rate_speed3 - 5
	end
	
	if simDR_TAT ~= nil then
		--tat = (simDR_TAT * 9 / 5) + 32	-- Celsius to Fahrenheit
		tat = simDR_TAT
	end
	
	if B738DR_duct_pressure_L > 5 and B738DR_l_pack_pos ~= 0 then
		temp_cont_cab = B738_set_animation_rate(temp_cont_cab, temp_cont_cab_tgt, -30, 200, rate_speed1)
		temp_fwd = B738_set_animation_rate(temp_fwd, (temp_cont_cab_tgt - 2), -30, 200, rate_speed1)
		temp_aft = B738_set_animation_rate(temp_aft, (temp_cont_cab_tgt + 2), -30, 200, rate_speed1)
		temp_l_pack = B738_set_animation_rate(temp_l_pack, temp_l_pack_tgt, -30, 2000, 3)
	else
		temp_cont_cab = B738_set_animation_rate(temp_cont_cab, tat, -30, 200, 35)
		temp_fwd = B738_set_animation_rate(temp_fwd, tat, -30, 200, 35)
		temp_aft = B738_set_animation_rate(temp_aft, tat, -30, 200, 35)
		temp_l_pack = B738_set_animation_rate(temp_l_pack, tat, -30, 200, 18)
	end
	
	if B738DR_duct_pressure_R > 5 and B738DR_r_pack_pos ~= 0 then
		temp_fwd_pass_cab = B738_set_animation_rate(temp_fwd_pass_cab, temp_fwd_pass_cab_tgt, -30, 200, rate_speed2)
		temp_aft_pass_cab = B738_set_animation_rate(temp_aft_pass_cab, temp_aft_pass_cab_tgt, -30, 200, rate_speed3)
		temp_r_pack = B738_set_animation_rate(temp_r_pack, temp_r_pack_tgt, -30, 200, 3)
	else
		temp_fwd_pass_cab = B738_set_animation_rate(temp_fwd_pass_cab, tat, -30, 200, 35)
		temp_aft_pass_cab = B738_set_animation_rate(temp_aft_pass_cab, tat, -30, 200, 35)
		temp_r_pack = B738_set_animation_rate(temp_r_pack, tat, -30, 200, 18)
	end
	
	-- Temperature instrument
	if B738DR_air_temp_source == 0 then
		temp_zone = temp_cont_cab
	elseif B738DR_air_temp_source == 1 then
		temp_zone = temp_fwd
	elseif B738DR_air_temp_source == 2 then
		temp_zone = temp_aft
	elseif B738DR_air_temp_source == 3 then
		temp_zone = temp_fwd_pass_cab
	elseif B738DR_air_temp_source == 4 then
		temp_zone = temp_aft_pass_cab
	elseif B738DR_air_temp_source == 5 then
		temp_zone = temp_r_pack
	elseif B738DR_air_temp_source == 6 then
		temp_zone = temp_l_pack
	end
	
	temp_zone = math.min(temp_zone, 100)
	temp_zone = math.max(temp_zone, 0)
	B738DR_zone_temp = B738_set_anim_value(B738DR_zone_temp, temp_zone, 0, 100, 5)
	
	--DR_sys_test = temp_cont_cab_tgt
	--DR_sys_test2 = temp_cont_cab
	
end

function speedbrake_aret_timer()
	simDR_speedbrake_ratio = 0
end

function B738_speedbrake_aret()
	if simDR_speedbrake_ratio > -0.4 and simDR_speedbrake_ratio < 0 then
		if is_timer_scheduled(speedbrake_aret_timer) == false then
			run_after_time(speedbrake_aret_timer, 2)	-- 2 seconds
		end
	else
		if is_timer_scheduled(speedbrake_aret_timer) == true then
			stop_timer(speedbrake_aret_timer)
		end
	end
end


function ff_used_timer_off()
	B738DR_fuel_flow_used_show = 0
end

function B738_ff_used_displ()

	if B738DR_fuel_flow_used_show ~= 0 then
		
		local fuel_tank = simDR_fuel_tank_weight_kg[0] + simDR_fuel_tank_weight_kg[1] + simDR_fuel_tank_weight_kg[2]
		
		fuel_tank = last_fuel_tank - fuel_tank
		if fuel_tank < 0 then
			fuel_tank = 0
		end
		
		B738DR_fuel_flow_used = fuel_tank
		
	end

end

function B738_generators()
	
	local gen1_available = 0
	
	local N2_ind1 = simDR_engine_N2_pct1
	local N2_ind2 = simDR_engine_N2_pct2
	
	if simDR_eng_N2_pct1_inop == 6 then
		N2_ind1 = 0
	end
	if simDR_eng_N2_pct2_inop == 6 then
		N2_ind2 = 0
	end
	
	if N2_ind1 < 50 or B738DR_drive_disconnect1_switch_position == 1 then
		if simDR_generator1_on == 1 then
			simDR_generator1_on = 0
		end
	end
	if B738DR_drive_disconnect1_switch_position == 0 
	and N2_ind1 > 50 
	and simDR_generator2_failure == 0 then
		gen1_available = 1
	end
	B738DR_gen1_available = gen1_available
	
	local gen2_available = 0
	if N2_ind2 < 50 or B738DR_drive_disconnect2_switch_position == 1 then
		if simDR_generator2_on == 1 then
			simDR_generator2_on = 0
		end
	end
	if B738DR_drive_disconnect2_switch_position == 0 
	and N2_ind2 > 50 
	and simDR_generator2_failure == 0 then
		gen2_available = 1
	end
	B738DR_gen2_available = gen2_available
	
	-- once after load plane
	if first_generators1 == 0 then
		if N2_ind1 > 50 then
			if simDR_generator1_failure == 0 then
				simDR_generator1_on = 1
			end
			first_generators1 = 1
			DR_sys_test = 1
		end
	end
	if first_generators2 == 0 then
		if N2_ind2 > 50 then
			if simDR_generator2_failure == 0 then
				simDR_generator2_on = 1
			end
			first_generators2 = 1
		end
	end
	
	
end

--function B738_bus_trans()

	-- need create command and dataref (position) for switch TRANSFER AUTO
	
	--simDR_bus_transfer_on = 1
	
--end


function B738_electric_bus()
	
	-- AC TRANSFER BUS 1/2
	local apu_gen1_off = 0
	local apu_gen2_off = 0
		--if simDR_apu_gen_amps < 1 then
		if simDR_apu_on == 0 then
		apu_gen1_off = 1
		apu_gen2_off = 1
		end
		if B738DR_apu_power_bus1 == 0 then
			apu_gen1_off = 1
		end
		if B738DR_apu_power_bus2 == 0 then
			apu_gen2_off = 1
		end
	
	local gpu_off = 0
		--if simDR_gpu_amps < 1 then
		if simDR_gpu_on == 0 then
		gpu_off = 1
		end
	
	local bus1_off = 1
	local bus2_off = 1
		if simDR_engine1_on == 1 and simDR_gen1_on == 1 then
			bus1_off = 0
		end
		if simDR_engine2_on == 1 and simDR_gen2_on == 1 then
			bus2_off = 0
		end
		
	local gen1_off = 0
		if simDR_generator1_on == 0 then
			gen1_off = 1
		end
	local gen2_off = 0
		if simDR_generator2_on == 0 then
			gen2_off = 1
		end
	--local ac_tnsbus1_status = 1 - (apu_gen1_off * simDR_gen_off_bus1 * gpu_off)
	--local ac_tnsbus2_status = 1 - (apu_gen2_off * simDR_gen_off_bus2 * gpu_off)
	
	local ac_tnsbus1_status = 1 - (apu_gen1_off * gen1_off * gpu_off)
	local ac_tnsbus2_status = 1 - (apu_gen2_off * gen2_off * gpu_off)
	
	-- transfer bus on
	if simDR_bus_transfer_on == 1 then
		if ac_tnsbus1_status == 0 and ac_tnsbus2_status == 1 then
			ac_tnsbus1_status = 1
		end
		if ac_tnsbus1_status == 1 and ac_tnsbus2_status == 0 then
			ac_tnsbus2_status = 1
		end
	end
	
	B738DR_ac_tnsbus1_status = ac_tnsbus1_status
	B738DR_ac_tnsbus2_status = ac_tnsbus2_status
	
	-- HOT BATTERY BUS
	local hot_battery_bus = 0
	if simDR_bus_battery1 > 12 or simDR_bus_battery2 > 12 then
		hot_battery_bus = 1
	end
	B738DR_hot_batbus_status = hot_battery_bus
	
	-- BATTERY BUS
	local battery_bus = 0
	if hot_battery_bus == 1 and simDR_bus_battery1_on == 1 then
		battery_bus = 1
	end
	if hot_battery_bus == 1 and simDR_bus_battery2_on == 1 then
		battery_bus = 1
	end
	if ac_tnsbus1_status == 1 or ac_tnsbus2_status == 1 then
		battery_bus = 1
	end
	B738DR_batbus_status = battery_bus
	
	-- DC BUS 1/2
	local dc_bus1 = 0
	if ac_tnsbus1_status == 1 then
		dc_bus1 = 1
	end
	local dc_bus2 = 0
	if ac_tnsbus2_status == 1 then
		dc_bus2 = 1
	end
	B738DR_dc_bus1_status = dc_bus1
	B738DR_dc_bus2_status = dc_bus2
	
	-- DC STANDBY BUS
	B738DR_dc_stdbus_status = dc_bus1
	
	-- AC STANDBY BUS
	if ac_tnsbus1_status == 1 or battery_bus == 1 then
		B738DR_ac_stdbus_status = 1
	else
		B738DR_ac_stdbus_status = 0
	end
	
	
	if B738DR_mach_test_enable == 0 then
		if B738DR_ac_tnsbus1_status == 1 or ac_tnsbus2_status == 1 then
			if is_timer_scheduled(mach_test) == false then
				run_after_time(mach_test, 240)	-- 4 minutes
			end
		else
			if is_timer_scheduled(mach_test) == true then
				stop_timer(mach_test)
			end
		end
	else
		if B738DR_ac_tnsbus1_status == 0 and ac_tnsbus2_status == 0 then
			if is_timer_scheduled(mach_test) == true then
				stop_timer(mach_test)
			end
			B738DR_mach_test_enable = 0
		end
	end

end

function mach_test()
	B738DR_mach_test_enable = 1
end

function lost_inertial_warn()
	lost_inertial = 1
end

function B738_brightness()

	-- Panels brightness lights
	if B738DR_ac_tnsbus2_status == 0 then
		simDR_panel_brightness[0] = B738DR_batbus_status
	else
		simDR_panel_brightness[0] = B738DR_panel_brightness[0] * B738DR_ac_stdbus_status * B738DR_batbus_status 		-- CPT Main panel
	end
	simDR_panel_brightness[1] = B738DR_panel_brightness[1] * B738DR_ac_tnsbus2_status		-- FO Main panel
	simDR_panel_brightness[2] = B738DR_panel_brightness[2] * B738DR_ac_tnsbus2_status	-- Overhead panel
	simDR_panel_brightness[3] = B738DR_panel_brightness[3] * B738DR_ac_tnsbus2_status	-- Padestal panel
	
	-- Instruments brightness lights
	simDR_instrument_brightness[0] = B738DR_instrument_brightness[0] * B738DR_ac_stdbus_status	-- CPT PFD
	simDR_instrument_brightness[1] = B738DR_instrument_brightness[1] * B738DR_ac_tnsbus2_status	-- FO PFD
	simDR_instrument_brightness[2] = B738DR_instrument_brightness[2] * B738DR_ac_stdbus_status	-- CPT ND
	simDR_instrument_brightness[3] = B738DR_instrument_brightness[3] * B738DR_ac_tnsbus2_status	-- FO ND
	simDR_instrument_brightness[4] = B738DR_instrument_brightness[4] * B738DR_ac_stdbus_status	-- EICAS
	simDR_instrument_brightness[5] = B738DR_instrument_brightness[5] * B738DR_ac_tnsbus2_status	-- Lower DU
	simDR_instrument_brightness[10] = B738DR_instrument_brightness[10] * B738DR_ac_stdbus_status	-- CPT FMC
	simDR_instrument_brightness[11] = B738DR_instrument_brightness[11] * B738DR_ac_tnsbus2_status	-- FO FMC
	
	-- radio, AP
	--simDR_instrument_brightness[9]
	
	--clock
	--simDR_instrument_brightness[8]
	
	--IRS
	--simDR_instrument_brightness[12]

	local lost_inertial_warn_on = 0
	if B738DR_batbus_status == 1 and B738DR_ac_tnsbus2_status == 0 then
		if B738DR_irs_left > 1 or B738DR_irs_right > 1 then
			lost_inertial_warn_on = 1
		end
	end
	
	if lost_inertial_warn_on == 0 then
		if is_timer_scheduled(lost_inertial_warn) == true then
			stop_timer(lost_inertial_warn)
		end
		lost_inertial = 0
	else
		if is_timer_scheduled(lost_inertial_warn) == false and lost_inertial == 0 then
			run_after_time(lost_inertial_warn, 20)			-- Delay 20 seconds
		end
	end
	
	B738DR_lost_fo_inertial = lost_inertial
	
end


function B738_fmc_source()
	if B738DR_fmc_source == - 1 then
		B738DR_nd_fmc_source = 1
		B738DR_nd_fmc_source_fo = 1
	elseif B738DR_fmc_source == 1 then
		B738DR_nd_fmc_source = 2
		B738DR_nd_fmc_source_fo = 2
	else
		B738DR_nd_fmc_source = 1
		B738DR_nd_fmc_source_fo = 2
	end
end
--*************************************************************************************--
--** 				               XLUA EVENT CALLBACKS       	        			 **--
--*************************************************************************************--

--function aircraft_load() end

--function aircraft_unload() end

function flight_start() 

B738_init_engineMGMT_fltStart()
 
	B738DR_cont_cab_temp_ctrl_rheo = 0.5
	B738DR_fwd_cab_temp_ctrl_rheo = 0.5
	B738DR_aft_cab_temp_ctrl_rheo = 0.5
	B738DR_probes_capt_switch_pos = 0
	B738DR_probes_fo_switch_pos = 0
	B738DR_l_pack_pos = 1
	B738DR_r_pack_pos = 1
	B738DR_isolation_valve_pos = 1
	apu_start_active = 0
--	B738DR_apu_damaged = 0
	simDR_apu_bleed_fail = 0
	eng1_starting = 0
	eng2_starting = 0
	B738DR_apu_gen1_pos = 0
	B738DR_apu_gen2_pos = 0
	B738DR_autobrake_pos = 1
	B738DR_autobrake_RTO_test = 0
	B738DR_autobrake_RTO_arm = 0
	B738DR_autobrake_arm = 0
	B738DR_autobrake_disarm = 0
	aircraft_was_on_air = 0
	autobrake_ratio = 0
	B738DR_brake_temp_l_out = 0.14
	B738DR_brake_temp_r_out = 0.14
	B738DR_brake_temp_l_in = 0.14
	B738DR_brake_temp_r_in = 0.14
	B738DR_brake_temp_left_out = 0.1
	B738DR_brake_temp_left_in = 0.1
	B738DR_brake_temp_right_out = 0.1
	B738DR_brake_temp_right_in = 0.1
	B738DR_air_temp_source = 1
--	B738DR_n1_set_adjust = 100
	B738DR_spd_ref_adjust = 100
	tcas_show1_19()
	B738DR_tcas_test2 = 1
	B738DR_apu_power_bus1 = 0
	B738DR_apu_power_bus2 = 0
	simCMD_apu_gen_off:once()
	B738DR_below_gs_disable = 0
	B738DR_alt_horn_cut_disable = 0
	brake_force = 0
	left_brake = 0
	right_brake = 0
	--parkbrake_force = 0
	B738DR_man_v1 = 100
	B738DR_man_vr = 100
	B738DR_man_vref = 100
	
	apu_fuel_pump_status = 0
	tank_imbal = 0
	tank_config = 0
	
	flap_cover_target = 0
	gear_cover_target = 0
	terr_cover_target = 0
	fdr_cover_target = 0
	B738DR_gpws_flap_pos = 0
	B738DR_gpws_gear_pos = 0
	B738DR_gpws_terr_pos = 0
	man_landgear_cover_target = 0
	man_landgear_target = 0
	flt_ctr_A_target = 0
	flt_ctr_B_target = 0
	spoiler_A_target = 0
	spoiler_B_target = 0
	alt_flaps_target = 0
	
	left_wiper_target = 0
	right_wiper_target = 0
	left_wiper_speed = 0
	right_wiper_speed = 0
	left_wiper_timer = 0
	right_wiper_timer = 0
	l_wiper_first = 0
	r_wiper_first = 0
	
	tcas_dis = 0
	gpws_test_timer = 0
	
	brake_compress = 0
	brake_decompress = 0
	B738DR_brake_press = 3120
	brake_press_target = 3120
	simDR_brake_old = B738DR_parking_brake_pos
	simDR_left_brake_old = simDR_left_brake
	simDR_right_brake_old = simDR_right_brake
	brake_inop = 0
	simDR_roll_brake = 0.8
	
	B738DR_zone_temp = 80
	
	B738DR_flt_ctr_A_pos = 1	-- HYD A RUD on/auto
	B738DR_flt_ctr_B_pos = 1	-- HYD B RUD on/auto
	
	hyd_A_pressure = 0
	hyd_B_pressure = 0
	hyd_stdby_pressure = 2700
	
	act_roll_ratio = 0
	act_roll_ratio_trg = 0
	act_pitch_ratio = 0
	act_pitch_ratio_trg = 0
	act_heading_ratio = 0
	act_heading_ratio_trg = 0
	
	B738_EFIS_tfc_show_fo = 0
	B738_EFIS_ta_only_show_fo = 0
	B738_EFIS_tcas_test_show_fo = 0
	B738_EFIS_tcas_off_show_fo = 0
	
	B738DR_fuel_flow_used_show = 0

	if simDR_gear_deploy_0 == 0 then
		landing_gear0_act = 0
		landing_gear1_act = 0
		landing_gear2_act = 0
		landing_gear_target = 0
	else
		landing_gear0_act = 1
		landing_gear1_act = 1
		landing_gear2_act = 1
		landing_gear_target = 1
	end
	
	-- APU fuel burn
	if is_timer_scheduled(B738_APU_fuel_burn) == false then
		run_at_interval(B738_APU_fuel_burn, 1)	-- every 1 sec
	end
	
	fuel_prev_0 = simDR_fuel_tank_weight_kg[0]
	fuel_prev_1 = simDR_fuel_tank_weight_kg[1]
	fuel_prev_2 = simDR_fuel_tank_weight_kg[2]
	
	if is_timer_scheduled(real_systems_update) == false then
		run_at_interval(real_systems_update, 0.5)	-- every 0.5 sec
	end

	
	first_time = 0
	alt_pressurize_auto = 0
	alt_pressurize_land = 0
	B738DR_outflow_valve = 0
	dump_all = 0
	
	init_sys()

	B738DR_tcas_test_test = 0
	
	B738DR_instrument_brightness[0] = 1
	B738DR_instrument_brightness[1] = 1
	B738DR_instrument_brightness[2] = 1
	B738DR_instrument_brightness[3] = 1
	B738DR_instrument_brightness[4] = 1
	B738DR_instrument_brightness[5] = 1
	B738DR_instrument_brightness[10] = 1
	B738DR_instrument_brightness[11] = 1
	
	lost_inertial = 0
	fmod_flap_sound = 0
	
end

--function flight_crash() end

function before_physics() 

	--drive_disconnect_reset()
	trip_oxy_on()
	
end

function after_physics() 

	if B738DR_kill_systems == 0 then
	
		read_axis()
		animate_covers()
		B738_ac_dc_power()
		B738_bleed_air_supply()
		B738_bleed_air_state()
		B738_bleed_air_duct_pressure()
		B738_bleed_air_valves()
		B738_bleed_air_valve_animation()
		B738_crossfeed_knob_animation()
		B738_prop_mode_sync()
	--	B738_idle_mode_logic()
	--	B738_ground_timer()
		B738_start_engine()
	--	B738_apu_bleed_starter()
		B738_fuel_pump()
		B738_fuel_tank_selection()
		B738_apu_system2()
		B738_autobrake()
		B738_brake_temp()
		B738_tcas_system()
		B738_hydropumps()
		B738_probes_antiice()
		B738_apu_gen()
		B738_yaw_damp()
		B738_slats()
		B738_alt_horn_cut()
		B738_gear_horn_cut()
		B738_below_gs_disable()
		B738_nose_steer()
		B738_manual_vspeed()
		B738_fuel_tank_status()
		B738_gpws()
		B738_gear_handle()
		B738_man_land_gear()
		B738_hydraulic_sys()
		B738_wipers()
		B738_brakes_press_system()
		B738_pressurization()
		B738_air_cond()
		turn_around_state()
		B738_speedbrake_aret()
		B738_ff_used_displ()
		B738_generators()
		B738_electric_bus()
		B738_brightness()
		B738_fmc_source()
		if fmod_flap_sound == 1 then
			fmod_flap_sound = 2
		elseif fmod_flap_sound == 2 then
			fmod_flap_sound = 0
		end
	end
	

	--B738_bus_trans()
	--DR_sys_test = first_generators1
	--B738DR_tcas_test_test = fuel_delta_0
	
end

--function after_replay() end




--*************************************************************************************--
--** 				               SUB-MODULE PROCESSING       	        			 **--
--*************************************************************************************--

-- dofile("")



