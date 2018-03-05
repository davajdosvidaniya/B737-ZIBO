--[[
*****************************************************************************************
* Program Script Name	:	B738.annunciators
*
* Author Name			:	Alex Unruh, Jim Gregory
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



--*************************************************************************************--
--** 					            GLOBAL VARIABLES                				 **--
--*************************************************************************************--

hyd_press_a_cur = 0.0
hyd_press_b_cur = 0.0
hyd_press_a_trg = 0.0
hyd_press_b_trg = 0.0
hyd_press_a_time = 0.0
hyd_press_b_time = 0.0

el_hyd_press_a_cur = 0.0
el_hyd_press_b_cur = 0.0
el_hyd_press_a_trg = 0.0
el_hyd_press_b_trg = 0.0
el_hyd_press_a_time = 0.0
el_hyd_press_b_time = 0.0

l1_pump_cur = 0.0
l1_pump_trg = 0.0
l1_pump_time = 0.0
l2_pump_cur = 0.0
l2_pump_trg = 0.0
l2_pump_time = 0.0
r1_pump_cur = 0.0
r1_pump_trg = 0.0
r1_pump_time = 0.0
r2_pump_cur = 0.0
r2_pump_trg = 0.0
r2_pump_time = 0.0
c1_pump_cur = 0.0
c1_pump_trg = 0.0
c1_pump_time = 0.0
c2_pump_cur = 0.0
c2_pump_trg = 0.0
c2_pump_time = 0.0

autobrake_disarm_status_cur = 0
autobrake_disarm_status_time = 0.0
autobrake_disarm_status_trg = 0.0

window_heat_l_side_cur = 0
window_heat_l_side_time = 0
window_heat_l_side_trg = 0
window_heat_l_fwd_cur = 0
window_heat_l_fwd_time = 0
window_heat_l_fwd_trg = 0
window_heat_r_side_cur = 0
window_heat_r_side_time = 0
window_heat_r_side_trg = 0
window_heat_r_fwd_cur = 0
window_heat_r_fwd_time = 0
window_heat_r_fwd_trg = 0

capt_pitot_status_cur = 0
capt_pitot_status_trg = 0
capt_pitot_status_time = 0
capt_aoa_status_cur = 0
capt_aoa_status_trg = 0
capt_aoa_status_time = 0
fo_pitot_status_cur = 0
fo_pitot_status_trg = 0
fo_pitot_status_time = 0
fo_aoa_status_cur = 0
fo_aoa_status_trg = 0
fo_aoa_status_time = 0

wing_ice_L_time = 0
wing_ice_R_time = 0
cowl_ice_0_time = 0
cowl_ice_1_time = 0

fuel_six_pack_old = 0
fuel_six_pack_ann = 0
apu_six_pack_old = 0
apu_six_pack_ann = 0
ovht_det_six_pack_old = 0
ovht_det_six_pack_ann = 0
irs_fail_old = 0
irs_fail_ann = 0
elec_fail_old = 0
elec_fail_ann = 0
six_pack_ice_status_old = 0
six_pack_ice_status_ann = 0
flt_cont_ann = 0
flt_cont_old = 0
six_pack_hydro_old = 0
six_pack_hydro_ann = 0
door_open_status_old = 0
door_open_status_ann = 0
six_pack_eng_old = 0
six_pack_eng_ann = 0
six_pack_ovhd_old = 0
six_pack_ovhd_ann = 0
six_pack_air_cond_old = 0
six_pack_air_cond_ann = 0

flt_cont_last = 0
irs_fail_last = 0
fuel_six_pack_last = 0
elec_fail_last = 0
apu_six_pack_last = 0
ovht_det_six_pack_last = 0

six_pack_ice_status_last = 0
six_pack_hydro_last = 0
door_open_status_last = 0
six_pack_eng_last = 0
six_pack_ovhd_last = 0
six_pack_air_cond_last = 0

off_sched_desc = 0
last_alt = 0
off_sched_desc_enable = 0

six_fuel_center = 0

dspl_lights_test = 0
dspl_lights_test_timer = 0

spar_valve_1_pos = 0
spar_valve_1_tgt = 0
spar_valve_2_pos = 0
spar_valve_2_tgt = 0

batt_discharge5 = 0
batt_discharge15 = 0
batt_discharge100 = 0

wing_body_ovht_test = 0
fdr_test = 0

--enable_cabin_lights = 0
cabin_lights_tim = 0
ac_tnsbus1_status_old = 0

--*************************************************************************************--
--** 					            LOCAL VARIABLES                 				 **--
--*************************************************************************************--


local batt_discharge = 0
--local extinguisher_circuit_annun2 = 0
--local cargo_fire_annuns = 0
local fire_fault_inop_annun = 0

local eng1_fire_annun = 0
local eng2_fire_annun = 0
local eng1_ovht = 0
local eng2_ovht = 0
--local apu_fire_annun = 0
--local wheel_well_fire = 0
local fire_panel_annuns_test = 0
local fire_bell_annun = 0
local fire_bell_annun_reset = 1
local ovht_det_six_pack = 0
local eng1_fire_old = 0
local eng2_fire_old = 0
local fire_bell_annun_old = 0
local cargo_fire_test = 0

--*************************************************************************************--
--** 				             FIND X-PLANE DATAREFS            			    	 **--
--*************************************************************************************--

simDR_parking_brake		= find_dataref("sim/cockpit2/controls/parking_brake_ratio")

simDR_reverser_fail_0	= find_dataref("sim/operation/failures/rel_revers0")
simDR_reverser_fail_1	= find_dataref("sim/operation/failures/rel_revers1")

-- ANTI ICE

simDR_window_heat		= find_dataref("sim/cockpit2/ice/ice_window_heat_on")

simDR_pitot_capt		= find_dataref("sim/cockpit2/ice/ice_pitot_heat_on_pilot")
simDR_pitot_fo			= find_dataref("sim/cockpit2/ice/ice_pitot_heat_on_copilot")
simDR_aoa_capt			= find_dataref("sim/cockpit2/ice/ice_AOA_heat_on")
simDR_aoa_fo			= find_dataref("sim/cockpit2/ice/ice_AOA_heat_on_copilot")

simDR_cowl_ice_detect_0 = find_dataref("sim/flightmodel/failures/inlet_ice_per_engine[0]")
simDR_cowl_ice_detect_1 = find_dataref("sim/flightmodel/failures/inlet_ice_per_engine[1]")

simDR_cowl_ice_0_on	= find_dataref("sim/cockpit2/ice/ice_inlet_heat_on_per_engine[0]")
simDR_cowl_ice_1_on	= find_dataref("sim/cockpit2/ice/ice_inlet_heat_on_per_engine[1]")

simDR_wing_ice_on = find_dataref("sim/cockpit2/ice/ice_surfce_heat_on")
simDR_wing_left_ice_on = find_dataref("sim/cockpit2/ice/ice_surfce_heat_left_on")
simDR_wing_right_ice_on = find_dataref("sim/cockpit2/ice/ice_surfce_heat_right_on")


simDR_wing_ice_detect_L = find_dataref("sim/flightmodel/failures/frm_ice")
simDR_wing_ice_detect_R = find_dataref("sim/flightmodel/failures/frm_ice2")

simDR_window_heat_fail = find_dataref("sim/operation/failures/rel_ice_window_heat")

-- FAIL heat engines and wings
simDR_ice_fail_eng1 = find_dataref("sim/operation/failures/rel_ice_inlet_heat")
simDR_ice_fail_eng2 = find_dataref("sim/operation/failures/rel_ice_inlet_heat2")
simDR_ice_fail_wingL = find_dataref("sim/operation/failures/rel_ice_surf_heat")
simDR_ice_fail_wingR = find_dataref("sim/operation/failures/rel_ice_surf_heat2")

-- APU FAULT

simDR_apu_fault	= find_dataref("sim/operation/failures/rel_APU_press")

-- ANNUN BRIGHTNESS

simDR_electrical_bus_volts0 = find_dataref("sim/cockpit2/electrical/bus_volts[0]")
simDR_electrical_bus_volts1 = find_dataref("sim/cockpit2/electrical/bus_volts[1]")
simDR_generic_brightness_ratio63 = find_dataref("sim/flightmodel2/lights/generic_lights_brightness_ratio[63]")
simDR_generic_brightness_ratio62 = find_dataref("sim/flightmodel2/lights/generic_lights_brightness_ratio[62]")
simDR_generic_brightness_switch63 = find_dataref("sim/cockpit2/switches/generic_lights_switch[63]")
simDR_generic_brightness_switch62 = find_dataref("sim/cockpit2/switches/generic_lights_switch[62]")

--GEAR LIGHTS

simDR_nose_gear_status	= find_dataref("sim/flightmodel2/gear/deploy_ratio[0]")
simDR_left_gear_status	= find_dataref("sim/flightmodel2/gear/deploy_ratio[1]")
simDR_right_gear_status	= find_dataref("sim/flightmodel2/gear/deploy_ratio[2]")

simDR_nose_gear_fail = find_dataref("sim/operation/failures/rel_collapse1")
simDR_left_gear_fail = find_dataref("sim/operation/failures/rel_collapse2")
simDR_right_gear_fail = find_dataref("sim/operation/failures/rel_collapse3")

-- LOW FUEL PRESSURE

simDR_fuel_quantity_l = find_dataref("sim/cockpit2/fuel/fuel_quantity[0]")
simDR_fuel_quantity_c = find_dataref("sim/cockpit2/fuel/fuel_quantity[1]")
simDR_fuel_quantity_r = find_dataref("sim/cockpit2/fuel/fuel_quantity[2]")

simDR_fuel_tank_l_on = find_dataref("sim/cockpit2/fuel/fuel_tank_pump_on[0]")
simDR_fuel_tank_c_on = find_dataref("sim/cockpit2/fuel/fuel_tank_pump_on[1]")
simDR_fuel_tank_r_on = find_dataref("sim/cockpit2/fuel/fuel_tank_pump_on[2]")

simDR_low_fuel = find_dataref("sim/cockpit2/annunciators/fuel_quantity")
simDR_low_fuel_press1 = find_dataref("sim/cockpit2/annunciators/fuel_pressure_low[0]")
simDR_low_fuel_press2 = find_dataref("sim/cockpit2/annunciators/fuel_pressure_low[1]")

-- FUEL VALVES

--simDR_mixture1 = find_dataref("sim/cockpit2/engine/actuators/mixture_ratio[0]")
--simDR_mixture2 = find_dataref("sim/cockpit2/engine/actuators/mixture_ratio[1]")
simDR_mixture1 = find_dataref("laminar/B738/engine/mixture_ratio1")
simDR_mixture2 = find_dataref("laminar/B738/engine/mixture_ratio2")

-- FADEC

simDR_fadec1 = find_dataref("sim/cockpit2/engine/actuators/fadec_on[0]")
simDR_fadec2 = find_dataref("sim/cockpit2/engine/actuators/fadec_on[1]")

simDR_fadec_fail_0		= find_dataref("sim/operation/failures/rel_fadec_0")
simDR_fadec_fail_1		= find_dataref("sim/operation/failures/rel_fadec_1")

-- GENERATOR FAILURE

simDR_generator1_fail = find_dataref("sim/operation/failures/rel_genera0")
simDR_generator2_fail = find_dataref("sim/operation/failures/rel_genera1")

--simDR_generator1_annun_off	= find_dataref("sim/cockpit2/annunciators/generator_off[0]")
--simDR_generator2_annun_off	= find_dataref("sim/cockpit2/annunciators/generator_off[1]")

B738DR_gen1_available		= find_dataref("laminar/B738/electric/gen1_available")
B738DR_gen2_available		= find_dataref("laminar/B738/electric/gen2_available")

-- ALT POWER ANNUN

simDR_battery2_status = find_dataref("sim/cockpit2/electrical/battery_on[1]")

-- BYPASS FILTER ANNUN

simDR_bypass_filter_1 = find_dataref("sim/operation/failures/failures[330]")
simDR_bypass_filter_2 = find_dataref("sim/operation/failures/failures[331]")

-- BATT DISCHARGE

simDR_battery_amps	= find_dataref("sim/cockpit2/electrical/battery_amps")

-- HYDRAULIC PRESSURE

simDR_hyd_press_a = find_dataref("sim/cockpit2/hydraulics/indicators/hydraulic_pressure_1")
simDR_hyd_press_b = find_dataref("sim/cockpit2/hydraulics/indicators/hydraulic_pressure_2")

-- PACK ANNUN

simDR_pack_annun = find_dataref("sim/operation/failures/failures[153]")

-- SMOKE ANNUN

simDR_smoke = find_dataref("sim/operation/failures/rel_smoke_cpit")

-- APU GEN OFF BUS

simDR_apu_gen_amps = find_dataref("sim/cockpit2/electrical/APU_generator_amps")
simDR_apu_status = find_dataref("sim/cockpit2/electrical/APU_N1_percent")

-- GEN OFF BUS

simDR_gen_off_bus1 = find_dataref("sim/cockpit2/annunciators/generator_off[0]")
simDR_gen_off_bus2 = find_dataref("sim/cockpit2/annunciators/generator_off[1]")

simDR_engine1_n1 = find_dataref("sim/cockpit2/engine/indicators/N1_percent[0]")
simDR_engine2_n1 = find_dataref("sim/cockpit2/engine/indicators/N1_percent[1]")

simDR_engine1_on = find_dataref("sim/flightmodel2/engines/engine_is_burning_fuel[0]")
simDR_engine2_on = find_dataref("sim/flightmodel2/engines/engine_is_burning_fuel[1]")

-- GPU

simDR_gpu_amps = find_dataref("sim/cockpit/electrical/gpu_amps")

-- BUS VOLTS

simDR_bus_amps1 = find_dataref("sim/cockpit2/electrical/bus_load_amps[0]")
simDR_bus_amps2 = find_dataref("sim/cockpit2/electrical/bus_load_amps[1]")

-- DOORS

simDR_fwd_entry_status = find_dataref("sim/flightmodel2/misc/door_open_ratio[0]")
simDR_left_fwd_overwing_status = find_dataref("sim/flightmodel2/misc/door_open_ratio[1]")
simDR_left_aft_overwing_status = find_dataref("sim/flightmodel2/misc/door_open_ratio[2]")
simDR_aft_entry_status = find_dataref("sim/flightmodel2/misc/door_open_ratio[3]")

simDR_fwd_service_status = find_dataref("sim/flightmodel2/misc/door_open_ratio[4]")
simDR_right_fwd_overwing_status = find_dataref("sim/flightmodel2/misc/door_open_ratio[5]")
simDR_right_aft_overwing_status = find_dataref("sim/flightmodel2/misc/door_open_ratio[6]")
simDR_aft_service_status = find_dataref("sim/flightmodel2/misc/door_open_ratio[7]")

simDR_fwd_cargo_status = find_dataref("sim/flightmodel2/misc/door_open_ratio[8]")
simDR_aft_cargo_status = find_dataref("sim/flightmodel2/misc/door_open_ratio[9]")

simDR_equipment_status = find_dataref("sim/flightmodel2/misc/custom_slider_ratio[21]")

-- PAX OXY

simDR_pax_oxy_status = find_dataref("sim/cockpit/warnings/annunciators/passenger_oxy_on")

-- BLEED TRIP OFF

simDR_bleed_trip_off1_annun = find_dataref("sim/cockpit/warnings/annunciators/bleed_air_fail[0]")
simDR_bleed_trip_off2_annun = find_dataref("sim/cockpit/warnings/annunciators/bleed_air_fail[1]")

simDR_wing_body_ovht_annun = find_dataref("sim/cockpit/warnings/annunciators/hvac")

-- YAW DAMPER

simDR_yaw_damper_annun			= find_dataref("sim/cockpit2/annunciators/yaw_damper")

-- DATAREFS FOR GROUND POWER AVAILABLE

simDR_aircraft_on_ground        = find_dataref("sim/flightmodel/failures/onground_all")
simDR_aircraft_groundspeed      = find_dataref("sim/flightmodel/position/groundspeed")

simDR_on_ground_0				= find_dataref("sim/flightmodel2/gear/on_ground[0]")
simDR_on_ground_1				= find_dataref("sim/flightmodel2/gear/on_ground[1]")
simDR_on_ground_2				= find_dataref("sim/flightmodel2/gear/on_ground[2]")


simDR_ext_pwr_1_on              = find_dataref("sim/cockpit/electrical/gpu_on")

simDR_axial_g_load				= find_dataref("sim/flightmodel/forces/g_axil")

simDR_N2_eng1_percent			= find_dataref("sim/cockpit2/engine/indicators/N2_percent[0]")
simDR_N2_eng2_percent			= find_dataref("sim/cockpit2/engine/indicators/N2_percent[1]")

-- CROSSFEED ANNUN

simDR_tank_selection			= find_dataref("sim/cockpit2/fuel/fuel_tank_selector")

-- FORWARD COCKPIT REFS

simDR_cabin_alt 				= find_dataref("sim/cockpit2/pressurization/indicators/cabin_altitude_ft")
simDR_speedbrake_status 		= find_dataref("sim/cockpit2/controls/speedbrake_ratio")
--simDR_GPWS						= find_dataref("sim/cockpit2/annunciators/GPWS")

simDR_flaps_ratio_physics		= find_dataref("sim/cockpit2/controls/flap_handle_deploy_ratio")

	-- TAKEOFF CONFIG
	
	simDR_elevator_trim			= find_dataref("sim/cockpit2/controls/elevator_trim")
	simDR_flap_ratio			= find_dataref("sim/cockpit2/controls/flap_ratio")
	simDR_throttle_ratio		= find_dataref("sim/cockpit2/engine/actuators/throttle_ratio_all")
	simDR_reverse_thrust1		= find_dataref("sim/cockpit2/engine/actuators/prop_mode[0]")
	simDR_reverse_thrust2		= find_dataref("sim/cockpit2/engine/actuators/prop_mode[1]")

--B738DR_glide_slope			= create_dataref("laminar/b738/fmodpack/msg_glide_slope", "number")
--B738DR_glide_slope			= find_dataref("laminar/B738/system/below_gs_warn")
B738DR_glide_slope_annun	= find_dataref("laminar/B738/system/below_gs_annun")
-- simDR_gs_flag					= find_dataref("sim/cockpit2/radios/indicators/nav1_flag_glideslope")
-- simDR_nav1_vdef_dots			= find_dataref("sim/cockpit2/radios/indicators/nav1_vdef_dots_pilot")
-- simDR_nav1_vert_signal			= find_dataref("sim/cockpit2/radios/indicators/nav1_display_vertical")
simDR_slat_1_deploy				= find_dataref("sim/flightmodel2/controls/slat1_deploy_ratio")
simDR_slat_2_deploy				= find_dataref("sim/flightmodel2/controls/slat2_deploy_ratio")
simDR_radio_height_pilot_ft		= find_dataref("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot")

simDR_engine1_fire				= find_dataref("sim/cockpit2/annunciators/engine_fires[0]")
simDR_engine2_fire				= find_dataref("sim/cockpit2/annunciators/engine_fires[1]")
simDR_engine1_egt				= find_dataref("sim/cockpit2/engine/indicators/EGT_deg_C[0]")
simDR_engine2_egt				= find_dataref("sim/cockpit2/engine/indicators/EGT_deg_C[1]")

simDR_eng1_fire 				= find_dataref("sim/operation/failures/rel_engfir0")
simDR_eng2_fire 				= find_dataref("sim/operation/failures/rel_engfir1")

	--EGT950°C for five minutes--

simDR_ap_disconnect				= find_dataref("sim/cockpit2/annunciators/autopilot_disconnect")

-- MASTER CAUTION

simDR_waster_caution_light		= find_dataref("sim/cockpit2/annunciators/master_caution")

-- SIX PACK EXTRAS

simDR_gps_fail					= find_dataref("sim/operation/failures/rel_gps")
simDR_gps2_fail					= find_dataref("sim/operation/failures/rel_gps2")

simDR_elec_trim_off				= find_dataref("sim/cockpit/warnings/annunciators/electric_trim_off")
simDR_general_ice_detect		= find_dataref("sim/cockpit2/annunciators/ice")
simDR_chip_detect1				= find_dataref("sim/cockpit2/annunciators/chip_detected[0]")
simDR_chip_detect2				= find_dataref("sim/cockpit2/annunciators/chip_detected[1]")


-- AUDIO PANEL AUDIO SELECTIONS

simDR_audio_selection_com1		= find_dataref("sim/cockpit2/radios/actuators/audio_selection_com1")
simDR_audio_selection_com2		= find_dataref("sim/cockpit2/radios/actuators/audio_selection_com2")
simDR_audio_selection_nav1		= find_dataref("sim/cockpit2/radios/actuators/audio_selection_nav1")
simDR_audio_selection_nav2		= find_dataref("sim/cockpit2/radios/actuators/audio_selection_nav2")
simDR_audio_selection_marker	= find_dataref("sim/cockpit2/radios/actuators/audio_marker_enabled")

-- AUDIO PANEL AVAILABLE LEDS

simDR_nav1h_active				= find_dataref("sim/cockpit2/radios/indicators/nav1_display_horizontal")
simDR_nav1v_active				= find_dataref("sim/cockpit2/radios/indicators/nav1_display_vertical")
simDR_nav1dme_active			= find_dataref("sim/cockpit2/radios/indicators/nav1_has_dme")

simDR_nav2h_active				= find_dataref("sim/cockpit2/radios/indicators/nav2_display_horizontal")
simDR_nav2v_active				= find_dataref("sim/cockpit2/radios/indicators/nav2_display_vertical")
simDR_nav2dme_active			= find_dataref("sim/cockpit2/radios/indicators/nav2_has_dme")

simDR_outer_marker_active		= find_dataref("sim/cockpit2/radios/indicators/over_outer_marker")
simDR_middle_marker_active		= find_dataref("sim/cockpit2/radios/indicators/over_middle_marker")
simDR_inner_marker_active		= find_dataref("sim/cockpit2/radios/indicators/over_inner_marker")

simDR_com1_active				= find_dataref("sim/cockpit2/radios/actuators/com1_power")
simDR_com2_active				= find_dataref("sim/cockpit2/radios/actuators/com2_power")

simDR_transponder_fail			= find_dataref("sim/operation/failures/rel_xpndr")

simDR_gen1_on					= find_dataref("sim/cockpit2/electrical/generator_on[0]")
simDR_gen2_on					= find_dataref("sim/cockpit2/electrical/generator_on[1]")

simDR_head_x 					= find_dataref("sim/aircraft/view/acf_peX")
simDR_head_y 					= find_dataref("sim/aircraft/view/acf_peY")
simDR_head_z 					= find_dataref("sim/aircraft/view/acf_peZ")

--*************************************************************************************--
--** 				               FIND X-PLANE COMMANDS                   	    	 **--
--*************************************************************************************--

--simCMD_test_fire_1_annun		= find_command("sim/annunciator/test_fire_1_annun")
--simCMD_test_fire_2_annun		= find_command("sim/annunciator/test_fire_2_annun")
simCMD_master_warning_accept	= find_command("sim/annunciator/clear_master_warning")
simCMD_master_caution_accept	= find_command("sim/annunciator/clear_master_caution")

--*************************************************************************************--
--** 				              FIND CUSTOM DATAREFS             			    	 **--
--*************************************************************************************--

B738DR_l_bottle_psi	= find_dataref("laminar/B738/fire/engine01_02L/ext_bottle/psi")
B738DR_r_bottle_psi	= find_dataref("laminar/B738/fire/engine01_02R/ext_bottle/psi")
B738DR_apu_bottle_psi	= find_dataref("laminar/B738/fire/apu/ext_bottle/psi")
B738DR_dual_bleed	= find_dataref("laminar/B738/annunciator/dual_bleed")

B738DR_fuel_tank_l1	= find_dataref("laminar/B738/fuel/fuel_tank_pos_lft1")
B738DR_fuel_tank_l2	= find_dataref("laminar/B738/fuel/fuel_tank_pos_lft2")
B738DR_fuel_tank_c1	= find_dataref("laminar/B738/fuel/fuel_tank_pos_ctr1")
B738DR_fuel_tank_c2	= find_dataref("laminar/B738/fuel/fuel_tank_pos_ctr2")
B738DR_fuel_tank_r1	= find_dataref("laminar/B738/fuel/fuel_tank_pos_rgt1")
B738DR_fuel_tank_r2	= find_dataref("laminar/B738/fuel/fuel_tank_pos_rgt2")

B738DR_hydro_pumps1_switch_position		= find_dataref("laminar/B738/toggle_switch/hydro_pumps1_pos")
B738DR_hydro_pumps2_switch_position		= find_dataref("laminar/B738/toggle_switch/hydro_pumps2_pos")
B738DR_el_hydro_pumps1_switch_position	= find_dataref("laminar/B738/toggle_switch/electric_hydro_pumps1_pos")
B738DR_el_hydro_pumps2_switch_position	= find_dataref("laminar/B738/toggle_switch/electric_hydro_pumps2_pos")

B738DR_apu_gen1_pos				= find_dataref("laminar/B738/electrical/apu_gen1_pos")
B738DR_apu_gen2_pos				= find_dataref("laminar/B738/electrical/apu_gen1_pos")

B738DR_window_heat_l_side_pos	= find_dataref("laminar/B738/ice/window_heat_l_side_pos")
B738DR_window_heat_l_fwd_pos	= find_dataref("laminar/B738/ice/window_heat_l_fwd_pos")
B738DR_window_heat_r_side_pos	= find_dataref("laminar/B738/ice/window_heat_r_side_pos")
B738DR_window_heat_r_fwd_pos	= find_dataref("laminar/B738/ice/window_heat_r_fwd_pos")

B738DR_fuel_tank_pos_lft1	= find_dataref("laminar/B738/fuel/fuel_tank_pos_lft1")
B738DR_fuel_tank_pos_lft2	= find_dataref("laminar/B738/fuel/fuel_tank_pos_lft2")
B738DR_fuel_tank_pos_ctr1	= find_dataref("laminar/B738/fuel/fuel_tank_pos_ctr1")
B738DR_fuel_tank_pos_ctr2	= find_dataref("laminar/B738/fuel/fuel_tank_pos_ctr2")
B738DR_fuel_tank_pos_rgt1	= find_dataref("laminar/B738/fuel/fuel_tank_pos_rgt1")
B738DR_fuel_tank_pos_rgt2	= find_dataref("laminar/B738/fuel/fuel_tank_pos_rgt2")

B738DR_autobrake_pos		= find_dataref("laminar/B738/autobrake/autobrake_pos")
B738DR_autobrake_RTO_test	= find_dataref("laminar/B738/autobrake/autobrake_RTO_test")
B738DR_autobrake_RTO_arm	= find_dataref("laminar/B738/autobrake/autobrake_RTO_arm")
B738DR_autobrake_arm		= find_dataref("laminar/B738/autobrake/autobrake_arm")
B738DR_autobrake_disarm		= find_dataref("laminar/B738/autobrake/autobrake_disarm")

-- new
B738DR_ap_disconnect		= find_dataref("laminar/B738/annunciator/ap_disconnect")
B738DR_at_disconnect		= find_dataref("laminar/B738/annunciator/at_disconnect")

B738DR_fmc_message_warn 	= find_dataref("laminar/B738/fmc/fmc_message_warn")

-- new

B738DR_window_ovht_test = 	find_dataref("laminar/B738/toggle_switch/window_ovht_test")

B738DR_irs_align_fail_right		= find_dataref("laminar/B738/annunciator/irs_align_fail_right")
B738DR_irs_align_fail_left		= find_dataref("laminar/B738/annunciator/irs_align_fail_left")
B738DR_irs_align_right			= find_dataref("laminar/B738/annunciator/irs_align_right")
B738DR_irs_align_left			= find_dataref("laminar/B738/annunciator/irs_align_left")
B738DR_irs_dc_fail_left			= find_dataref("laminar/B738/annunciator/irs_dc_fail_left")
B738DR_irs_on_dc_left			= find_dataref("laminar/B738/annunciator/irs_on_dc_left")
B738DR_irs_dc_fail_right		= find_dataref("laminar/B738/annunciator/irs_dc_fail_right")
B738DR_irs_on_dc_right			= find_dataref("laminar/B738/annunciator/irs_on_dc_right")

B738DR_irs_left_fail			= find_dataref("laminar/B738/annunciator/irs_left_fail")
B738DR_irs_right_fail			= find_dataref("laminar/B738/annunciator/irs_right_fail")

simDR_apu_power_bus1			= find_dataref("laminar/B738/electrical/apu_power_bus1")
simDR_apu_power_bus2			= find_dataref("laminar/B738/electrical/apu_power_bus2")
B738DR_apu_low_oil				= find_dataref("laminar/B738/electrical/apu_low_oil", "number")
--B738DR_apu_temp					= find_dataref("laminar/B738/electrical/apu_temp")
B738DR_apu_bus_enable			= find_dataref("laminar/B738/electrical/apu_bus_enable")

--B738DR_cross_feed_selector_knob = find_dataref("laminar/B738/knobs/cross_feed")
B738DR_cross_feed_valve			= find_dataref("laminar/B738/fuel/cross_feed_valve")

B738DR_gpu_available			= find_dataref("laminar/B738/gpu_available")
--- A/P, A/T light buttons
-- B738DR_ap_light_pilot		= find_dataref("laminar/B738/push_button/ap_light_pilot")
-- B738DR_at_light_pilot		= find_dataref("laminar/B738/push_button/ap_light_pilot")
-- B738DR_ap_light_fo			= find_dataref("laminar/B738/push_button/ap_light_fo")
-- B738DR_at_light_fo			= find_dataref("laminar/B738/push_button/ap_light_fo")

B738DR_hyd_A_status			= find_dataref("laminar/B738/hydraulic/A_status")
B738DR_hyd_B_status			= find_dataref("laminar/B738/hydraulic/B_status")
B738DR_hyd_stdby_status		= find_dataref("laminar/B738/hydraulic/standby_status")
B738DR_flt_ctr_A_pos		= find_dataref("laminar/B738/switches/flt_ctr_A_pos")
B738DR_flt_ctr_B_pos		= find_dataref("laminar/B738/switches/flt_ctr_B_pos")

B738DR_thrust1_leveler		= find_dataref("laminar/B738/engine/thrust1_leveler")
B738DR_thrust2_leveler		= find_dataref("laminar/B738/engine/thrust2_leveler")

B738DR_fmc_cruise_alt		= find_dataref("laminar/B738/autopilot/fmc_cruise_alt")

B738DR_air_valve_ctrl 		= find_dataref("laminar/B738/toggle_switch/air_valve_ctrl")
B738DR_flight_phase			= find_dataref("laminar/B738/FMS/flight_phase")

simDR_altitude_pilot		= find_dataref("sim/cockpit2/gauges/indicators/altitude_ft_pilot")
simDR_max_allowable_alt		= find_dataref("sim/cockpit2/pressurization/actuators/max_allowable_altitude_ft")
B738DR_pressurization_mode	= find_dataref("laminar/B738/pressurization_mode")
simDR_diff_press			= find_dataref("sim/cockpit/pressure/cabin_pressure_differential_psi")
simDR_vvi_press_act			= find_dataref("sim/cockpit/pressure/cabin_vvi_actual_m_msec")

l_side_temp 				= find_dataref("laminar/B738/ice/l_side_temp")
l_fwd_temp 					= find_dataref("laminar/B738/ice/l_fwd_temp")
r_side_temp 				= find_dataref("laminar/B738/ice/r_side_temp")
r_fwd_temp 					= find_dataref("laminar/B738/ice/r_fwd_temp")

DRblink						= find_dataref("laminar/B738/autopilot/blink")
B738DR_flt_dk_door 			= find_dataref("laminar/B738/toggle_switch/flt_dk_door")
B738DR_flt_dk_door_ratio	= find_dataref("laminar/B738/door/flt_dk_door_ratio")

B738DR_cabin_alt			= find_dataref("laminar/B738/cabin_alt")
B738DR_cabin_vvi			= find_dataref("laminar/B738/cabin_vvi")

B738DR_ac_tnsbus1_status	= find_dataref("laminar/B738/electric/ac_tnsbus1_status")
B738DR_ac_tnsbus2_status	= find_dataref("laminar/B738/electric/ac_tnsbus2_status")

B738DR_mixture_ratio1		= find_dataref("laminar/B738/engine/mixture_ratio1")
B738DR_mixture_ratio2		= find_dataref("laminar/B738/engine/mixture_ratio2")

B738DR_outflow_valve		= find_dataref("laminar/B738/outflow_valve")
B738DR_gear_handle_pos		= find_dataref("laminar/B738/controls/gear_handle_down")

B738DR_fire_ext_bottle_0102L_psi 	= find_dataref("laminar/B738/fire/engine01_02L/ext_bottle/psi")
B738DR_fire_ext_bottle_0102R_psi 	= find_dataref("laminar/B738/fire/engine01_02R/ext_bottle/psi")
B738DR_fire_ext_bottle_apu_psi 		= find_dataref("laminar/B738/fire/apu/ext_bottle/psi")

B738DR_engine01_fire_ext_switch_pos_arm 	= find_dataref("laminar/B738/fire/engine01/ext_switch/pos_arm")
B738DR_engine02_fire_ext_switch_pos_arm 	= find_dataref("laminar/B738/fire/engine02/ext_switch/pos_arm")


--- ANNUNCIATES PUSH

B738DR_below_gs_pilot	= find_dataref("laminar/B738/push_button/below_gs_pilot_pos")
B738DR_below_gs_copilot	= find_dataref("laminar/B738/push_button/below_gs_copilot_pos")

B738DR_fdr_pos				= find_dataref("laminar/B738/switches/fdr_pos")
B738DR_duct_ovht_test_pos	= find_dataref("laminar/B738/push_button/duct_ovht_test_pos")

B738DR_gpws_test_running	= find_dataref("laminar/B738/system/gpws_test_running")

B738DR_batbus_status		= find_dataref("laminar/B738/electric/batbus_status")


--*************************************************************************************--
--** 				              FIND CUSTOM COMMANDS              			     **--
--*************************************************************************************--


--*************************************************************************************--
--** 				        CREATE READ-ONLY CUSTOM DATAREFS               	         **--
--*************************************************************************************--
B738DR_annun_apu_low_oil		= create_dataref("laminar/B738/annunciator/apu_low_oil", "number")

B738DR_parking_brake_annun	= create_dataref("laminar/B738/annunciator/parking_brake", "number")

--B738DR_window_heat_annun	= create_dataref("laminar/B738/annunciator/window_heat", "number")

B738DR_window_heat_annun1	= create_dataref("laminar/B738/annunciator/window_heat_l_side", "number")
B738DR_window_heat_annun2	= create_dataref("laminar/B738/annunciator/window_heat_l_fwd", "number")
B738DR_window_heat_annun3	= create_dataref("laminar/B738/annunciator/window_heat_r_side", "number")
B738DR_window_heat_annun4	= create_dataref("laminar/B738/annunciator/window_heat_r_fwd", "number")


B738DR_fadec_fail_annun_0	= create_dataref("laminar/B738/annunciator/fadec_fail_0", "number")
B738DR_fadec_fail_annun_1	= create_dataref("laminar/B738/annunciator/fadec_fail_1", "number")

B738DR_reverser_fail_annun_0	= create_dataref("laminar/B738/annunciator/reverser_fail_0", "number")
B738DR_reverser_fail_annun_1	= create_dataref("laminar/B738/annunciator/reverser_fail_1", "number")

B738DR_capt_pitot_off		= create_dataref("laminar/B738/annunciator/capt_pitot_off", "number")
B738DR_fo_pitot_off			= create_dataref("laminar/B738/annunciator/fo_pitot_off", "number")
B738DR_capt_aoa_off			= create_dataref("laminar/B738/annunciator/capt_aoa_off", "number")
B738DR_fo_aoa_off			= create_dataref("laminar/B738/annunciator/fo_aoa_off", "number")

B738DR_window_heat_fail_rf		= create_dataref("laminar/B738/annunciator/window_heat_ovht_rf", "number")
B738DR_window_heat_fail_rs		= create_dataref("laminar/B738/annunciator/window_heat_ovht_rs", "number")
B738DR_window_heat_fail_lf		= create_dataref("laminar/B738/annunciator/window_heat_ovht_lf", "number")
B738DR_window_heat_fail_ls		= create_dataref("laminar/B738/annunciator/window_heat_ovht_ls", "number")

-- COWL ANTI ICE

B738DR_cowl_ice_0			= create_dataref("laminar/B738/annunciator/cowl_ice_0", "number")
B738DR_cowl_ice_1			= create_dataref("laminar/B738/annunciator/cowl_ice_1", "number")
B738DR_cowl_ice_0_on		= create_dataref("laminar/B738/annunciator/cowl_ice_on_0", "number")
B738DR_cowl_ice_1_on		= create_dataref("laminar/B738/annunciator/cowl_ice_on_1", "number")

-- WING ANTI ICE

B738DR_wing_ice_on_L		= create_dataref("laminar/B738/annunciator/wing_ice_on_L", "number")
B738DR_wing_ice_on_R		= create_dataref("laminar/B738/annunciator/wing_ice_on_R", "number")

B738DR_apu_fault_annun		= create_dataref("laminar/B738/annunciator/apu_fault", "number")

B738DR_parking_brake_spill 	= create_dataref("laminar/B738/light/spill/ratio/parking_brake", "array[9]")

-- GEAR LIGHTS

B738DR_nose_gear_transit_annun	= create_dataref("laminar/B738/annunciator/nose_gear_transit", "number")
B738DR_nose_gear_safe_annun		= create_dataref("laminar/B738/annunciator/nose_gear_safe", "number")

B738DR_left_gear_transit_annun	= create_dataref("laminar/B738/annunciator/left_gear_transit", "number")
B738DR_left_gear_safe_annun		= create_dataref("laminar/B738/annunciator/left_gear_safe", "number")

B738DR_right_gear_transit_annun	= create_dataref("laminar/B738/annunciator/right_gear_transit", "number")
B738DR_right_gear_safe_annun	= create_dataref("laminar/B738/annunciator/right_gear_safe", "number")

-- LOW FUEL PRESSURE ANNUNS

B738DR_low_fuel_press_l1_annun	= create_dataref("laminar/B738/annunciator/low_fuel_press_l1", "number")
B738DR_low_fuel_press_l2_annun	= create_dataref("laminar/B738/annunciator/low_fuel_press_l2", "number")

B738DR_low_fuel_press_c1_annun	= create_dataref("laminar/B738/annunciator/low_fuel_press_c1", "number")
B738DR_low_fuel_press_c2_annun	= create_dataref("laminar/B738/annunciator/low_fuel_press_c2", "number")

B738DR_low_fuel_press_r1_annun	= create_dataref("laminar/B738/annunciator/low_fuel_press_r1", "number")
B738DR_low_fuel_press_r2_annun	= create_dataref("laminar/B738/annunciator/low_fuel_press_r2", "number")

-- FUEL VALVES

B738DR_eng1_valve_closed_annun	= create_dataref("laminar/B738/annunciator/eng1_valve_closed", "number")
B738DR_eng2_valve_closed_annun	= create_dataref("laminar/B738/annunciator/eng2_valve_closed", "number")

B738DR_spar1_valve_closed_annun	= create_dataref("laminar/B738/annunciator/spar1_valve_closed", "number")
B738DR_spar2_valve_closed_annun	= create_dataref("laminar/B738/annunciator/spar2_valve_closed", "number")

-- FADEC OFF

B738DR_fadec1_off			= create_dataref("laminar/B738/annunciator/fadec1_off", "number")
B738DR_fadec2_off			= create_dataref("laminar/B738/annunciator/fadec2_off", "number")

-- GENERATOR FAIL

B738DR_drive1_annun			= create_dataref("laminar/B738/annunciator/drive1", "number")
B738DR_drive2_annun			= create_dataref("laminar/B738/annunciator/drive2", "number")

-- ALT POWER ANNUN

B738DR_standby_pwr_off		= create_dataref("laminar/B738/annunciator/standby_pwr_off", "number")

-- BYPASS FILTER ANNUN

B738DR_bypass_filter_1		= create_dataref("laminar/B738/annunciator/bypass_filter_1", "number")
B738DR_bypass_filter_2		= create_dataref("laminar/B738/annunciator/bypass_filter_2", "number")

-- BATT DISCHAGE ANNUN

B738DR_battery_disch_annun	= create_dataref("laminar/B738/annunciator/bat_discharge", "number")

-- HYD PRESSURE ANNUNS

B738DR_hyd_press_a			= create_dataref("laminar/B738/annunciator/hyd_press_a", "number")
B738DR_hyd_press_b			= create_dataref("laminar/B738/annunciator/hyd_press_b", "number")
B738DR_el_hyd_press_a			= create_dataref("laminar/B738/annunciator/hyd_el_press_a", "number")
B738DR_el_hyd_press_b			= create_dataref("laminar/B738/annunciator/hyd_el_press_b", "number")

-- PACK ANNUN

--B738DR_packs_annun			= create_dataref("laminar/B738/annunciator/pack", "number")
B738DR_packs_left_annun			= create_dataref("laminar/B738/annunciator/pack_left", "number")
B738DR_packs_right_annun		= create_dataref("laminar/B738/annunciator/pack_right", "number")

-- SMOKE ANNUN

B738DR_smoke				= create_dataref("laminar/B738/annunciator/smoke", "number")

-- APU GEN OFF BUS ANNUN

B738DR_apu_gen_off_bus		= create_dataref("laminar/B738/annunciator/apu_gen_off_bus", "number")

-- GEN OFF BUS ANNUN

B738DR_gen_off_bus1			= create_dataref("laminar/B738/annunciator/gen_off_bus1", "number")
B738DR_gen_off_bus2			= create_dataref("laminar/B738/annunciator/gen_off_bus2", "number")

-- SOURCE OFF ANNUN

B738DR_source_off_bus1		= create_dataref("laminar/B738/annunciator/source_off1", "number")
B738DR_source_off_bus2		= create_dataref("laminar/B738/annunciator/source_off2", "number")

-- TRANSFER BUS OFF ANNUN

B738DR_transfer_bus_off1		= create_dataref("laminar/B738/annunciator/trans_bus_off1", "number")
B738DR_transfer_bus_off2		= create_dataref("laminar/B738/annunciator/trans_bus_off2", "number")

-- DOOR ANNUNS

B738DR_fwd_entry			= create_dataref("laminar/B738/annunciator/fwd_entry", "number")
B738DR_left_fwd_overwing	= create_dataref("laminar/B738/annunciator/left_fwd_overwing", "number")
B738DR_left_aft_overwing	= create_dataref("laminar/B738/annunciator/left_aft_overwing", "number")
B738DR_aft_entry			= create_dataref("laminar/B738/annunciator/aft_entry", "number")

B738DR_fwd_service			= create_dataref("laminar/B738/annunciator/fwd_service", "number")
B738DR_right_fwd_overwing	= create_dataref("laminar/B738/annunciator/right_fwd_overwing", "number")
B738DR_right_aft_overwing	= create_dataref("laminar/B738/annunciator/right_aft_overwing", "number")
B738DR_aft_service			= create_dataref("laminar/B738/annunciator/aft_service", "number")

B738DR_fwd_cargo			= create_dataref("laminar/B738/annunciator/fwd_cargo", "number")
B738DR_aft_cargo			= create_dataref("laminar/B738/annunciator/aft_cargo", "number")

B738DR_equip_door			= create_dataref("laminar/B738/annunciator/equip_door", "number")

-- PAX OXY

B738DR_pax_oxy				= create_dataref("laminar/B738/annunciator/pax_oxy", "number")

-- BLEED TRIP OFF

B738DR_bleed_trip_off1		= create_dataref("laminar/B738/annunciator/bleed_trip_1", "number")
B738DR_bleed_trip_off2		= create_dataref("laminar/B738/annunciator/bleed_trip_2", "number")

-- WING-BODY OVERHEAT

--B738DR_wing_body_ovht		= create_dataref("laminar/B738/annunciator/wing_body_ovht", "number")
B738DR_wing_body_ovht_left		= create_dataref("laminar/B738/annunciator/wing_body_ovht_left", "number")
B738DR_wing_body_ovht_right		= create_dataref("laminar/B738/annunciator/wing_body_ovht_right", "number")

-- GROUND POWER AVAILABLE

B738DR_ground_power_avail_annun	= create_dataref("laminar/B738/annunciator/ground_power_avail", "number")

--B738DR_ground_power_switch_pos = create_dataref("laminar/B738/toggle_switch/gpu", "number")

B738DR_elt_switch_pos = create_dataref("laminar/B738/toggle_switch/elt", "number")

B738DR_elt_annun = create_dataref("laminar/B738/annunciator/elt", "number")

B738DR_fdr_off = create_dataref("laminar/B738/annunciator/fdr_off", "number")

-- YAW DAMPER

B738DR_yaw_damper = create_dataref("laminar/B738/annunciator/yaw_damp", "number")

-- CROSSFEED VALVE ANNUN

B738DR_crossfeed = create_dataref("laminar/B738/annunciator/crossfeed", "number")

-- GENERIC ANNUNS

B738DR_generic_annun = create_dataref("laminar/B738/annunciator/generic", "number")
B738DR_lights_test = create_dataref("laminar/B738/annunciator/test", "number")
B738DR_dspl_lights_test = create_dataref("laminar/B738/dspl_light_test", "number")

-- LIGHTS TEST / BRIGHTNESS SWITCH

B738DR_bright_test_switch_pos = create_dataref("laminar/B738/toggle_switch/bright_test", "number")

-- EMER EXIT LIGHTS

B738DR_emer_exit_lights_switch 	= create_dataref("laminar/B738/toggle_switch/emer_exit_lights", "number")
B738DR_emer_exit_annun			= create_dataref("laminar/B738/annunciator/emer_exit", "number")

-- FORWARD PANEL ANNUNS

B738DR_cabin_alt_annun			= create_dataref("laminar/B738/annunciator/cabin_alt", "number")
B738DR_speedbrake_armed			= create_dataref("laminar/B738/annunciator/speedbrake_armed", "number")
B738DR_speedbrake_extend		= create_dataref("laminar/B738/annunciator/speedbrake_extend", "number")
B738DR_GPWS_annun				= create_dataref("laminar/B738/annunciator/gpws", "number")
B738DR_takeoff_config_annun		= create_dataref("laminar/B738/annunciator/takeoff_config", "number")
B738DR_takeoff_config_warn		= create_dataref("laminar/B738/system/takeoff_config_warn", "number")
B738DR_below_gs					= create_dataref("laminar/B738/annunciator/below_gs", "number")
--B738DR_below_gs_warn			= create_dataref("laminar/B738/system/below_gs_warn", "number")

B738DR_slats_transit			= create_dataref("laminar/B738/annunciator/slats_transit", "number")
B738DR_slats_extended			= create_dataref("laminar/B738/annunciator/slats_extend", "number")


-- FIRE PANEL ANNUNS

--B738DR_extinguisher_circuit_spill1		= create_dataref("laminar/B738/light/spill/ratio/extinguisher_circuit_spill1", "array[9]")
B738DR_extinguisher_circuit_spill2		= create_dataref("laminar/B738/light/spill/ratio/extinguisher_circuit_spill2", "array[9]")
B738DR_extinguisher_circuit_spill_left		= create_dataref("laminar/B738/light/spill/ratio/extinguisher_circuit_spill_left", "array[9]")
B738DR_extinguisher_circuit_spill_right		= create_dataref("laminar/B738/light/spill/ratio/extinguisher_circuit_spill_right", "array[9]")
B738DR_extinguisher_circuit_spill_apu		= create_dataref("laminar/B738/light/spill/ratio/extinguisher_circuit_spill_apu", "array[9]")
B738DR_extinguisher_leveler_spill_eng1		= create_dataref("laminar/B738/light/spill/ratio/extinguisher_leveler_spill_eng1", "array[9]")
B738DR_extinguisher_leveler_spill_eng2		= create_dataref("laminar/B738/light/spill/ratio/extinguisher_leveler_spill_eng2", "array[9]")
B738DR_extinguisher_leveler_spill_apu		= create_dataref("laminar/B738/light/spill/ratio/extinguisher_leveler_spill_apu", "array[9]")

B738DR_master_caution_spill		= create_dataref("laminar/B738/light/spill/ratio/master_caution_spill", "array[9]")
B738DR_fire_warn_spill			= create_dataref("laminar/B738/light/spill/ratio/fire_warn_spill", "array[9]")

B738DR_cabin_lights				= create_dataref("laminar/B738/light/spill/ratio/cabin_lights_spill", "array[9]")
B738DR_cabin_emergency_lights	= create_dataref("laminar/B738/light/spill/ratio/cabin_emergency_lights_spill", "array[9]")

B738DR_l_wings_lights			= create_dataref("laminar/B738/light/spill/ratio/l_wings_lights_spill", "array[9]")
B738DR_r_wings_lights			= create_dataref("laminar/B738/light/spill/ratio/r_wings_lights_spill", "array[9]")
B738DR_eng1_wings_lights		= create_dataref("laminar/B738/light/spill/ratio/eng1_wings_lights_spill", "array[9]")
B738DR_eng2_wings_lights		= create_dataref("laminar/B738/light/spill/ratio/eng2_wings_lights_spill", "array[9]")

B738DR_gpu_avail_lights 		= create_dataref("laminar/B738/light/spill/ratio/gpu_avail_lights_spill", "array[9]")
B738DR_eng1_valve_lights 		= create_dataref("laminar/B738/light/spill/ratio/eng1_valve_lights_spill", "array[9]")
B738DR_eng2_valve_lights 		= create_dataref("laminar/B738/light/spill/ratio/eng2_valve_lights_spill", "array[9]")
B738DR_eng1_spar_lights 		= create_dataref("laminar/B738/light/spill/ratio/eng1_spar_lights_spill", "array[9]")
B738DR_eng2_spar_lights			= create_dataref("laminar/B738/light/spill/ratio/eng2_spar_lights_spill", "array[9]")
B738DR_ram1_full_lights 		= create_dataref("laminar/B738/light/spill/ratio/ram1_full_lights_spill", "array[9]")
B738DR_ram2_full_lights 		= create_dataref("laminar/B738/light/spill/ratio/ram2_full_lights_spill", "array[9]")

B738DR_crossfeed_lights 	= create_dataref("laminar/B738/light/spill/ratio/crossfeed_lights_spill", "array[9]")
B738DR_gen1_avail_lights 	= create_dataref("laminar/B738/light/spill/ratio/gen1_avail_lights_spill", "array[9]")
B738DR_gen2_avail_lights 	= create_dataref("laminar/B738/light/spill/ratio/gen2_avail_lights_spill", "array[9]")
B738DR_apu_avail_lights 	= create_dataref("laminar/B738/light/spill/ratio/apu_avail_lights_spill", "array[9]")


B738DR_extinguisher_circuit_test_pos	= create_dataref("laminar/B738/toggle_switch/extinguisher_circuit_test", "number")
--B738DR_extinguisher_circuit_annun1		= create_dataref("laminar/B738/annunciator/extinguisher_circuit_annun1", "number")
B738DR_extinguisher_circuit_annun_left		= create_dataref("laminar/B738/annunciator/extinguisher_circuit_annun_left", "number")
B738DR_extinguisher_circuit_annun_right		= create_dataref("laminar/B738/annunciator/extinguisher_circuit_annun_right", "number")
B738DR_extinguisher_circuit_annun_apu		= create_dataref("laminar/B738/annunciator/extinguisher_circuit_annun_apu", "number")
B738DR_extinguisher_circuit_annun2		= create_dataref("laminar/B738/annunciator/extinguisher_circuit_annun2", "number")
B738DR_cargo_fire_annuns				= create_dataref("laminar/B738/annunciator/cargo_fire", "number")

B738DR_cargo_fire_test_button_pos		= create_dataref("laminar/B738/push_botton/cargo_fire_test", "number")
B738DR_fire_test_switch_pos				= create_dataref("laminar/B738/toggle_switch/fire_test", "number")
B738DR_fire_fault_inop_annun			= create_dataref("laminar/B738/annunciator/fire_fault_inop", "number")
B738DR_cargo_fault_detector_annun		= create_dataref("laminar/B738/annunciator/cargo_fault_detector", "number")

B738DR_apu_fire							= create_dataref("laminar/B738/annunciator/apu_fire", "number")
B738DR_engine1_fire						= create_dataref("laminar/B738/annunciator/engine1_fire", "number")
B738DR_engine2_fire						= create_dataref("laminar/B738/annunciator/engine2_fire", "number")
B738DR_engine1_ovht						= create_dataref("laminar/B738/annunciator/engine1_ovht", "number")
B738DR_engine2_ovht						= create_dataref("laminar/B738/annunciator/engine2_ovht", "number")
B738DR_l_bottle_discharge				= create_dataref("laminar/B738/annunciator/l_bottle_discharge", "number")
B738DR_r_bottle_discharge				= create_dataref("laminar/B738/annunciator/r_bottle_discharge", "number")
B738DR_apu_bottle_discharge				= create_dataref("laminar/B738/annunciator/apu_bottle_discharge", "number")
B738DR_wheel_well_fire					= create_dataref("laminar/B738/annunciator/wheel_well_fire", "number")

B738DR_fire_bell_annun					= create_dataref("laminar/B738/annunciator/fire_bell_annun", "number")
B738DR_fire_bell_pos1					= create_dataref("laminar/B738/push_button/fire_bell_cutout1", "number")
B738DR_fire_bell_pos2					= create_dataref("laminar/B738/push_button/fire_bell_cutout2", "number")

B738DR_master_caution_light				= create_dataref("laminar/B738/annunciator/master_caution_light", "number")
B738DR_master_caution_pos1				= create_dataref("laminar/B738/push_button/master_caution_accept1", "number")
B738DR_master_caution_pos2				= create_dataref("laminar/B738/push_button/master_caution_accept2", "number")

-- AP DISCONNECT PANEL --

B738DR_ap_disconnect1_annun				= create_dataref("laminar/B738/annunciator/ap_disconnect1", "number")
B738DR_at_fms_disconnect1_annun			= create_dataref("laminar/B738/annunciator/at_fms_disconnect1", "number")
B738DR_ap_disconnect1_test_switch_pos	= create_dataref("laminar/B738/toggle_switch/ap_discon_test1", "number")
B738DR_at_disconnect1_annun				= create_dataref("laminar/B738/annunciator/at_disconnect1", "number")

B738DR_ap_disconnect2_annun				= create_dataref("laminar/B738/annunciator/ap_disconnect2", "number")
B738DR_at_fms_disconnect2_annun			= create_dataref("laminar/B738/annunciator/at_fms_disconnect2", "number")		
B738DR_ap_disconnect2_test_switch_pos	= create_dataref("laminar/B738/toggle_switch/ap_discon_test2", "number")
B738DR_at_disconnect2_annun				= create_dataref("laminar/B738/annunciator/at_disconnect2", "number")

B738DR_six_pack_fuel					= create_dataref("laminar/B738/annunciator/six_pack_fuel", "number")
B738DR_six_pack_fire					= create_dataref("laminar/B738/annunciator/six_pack_fire", "number")
B738DR_six_pack_apu						= create_dataref("laminar/B738/annunciator/six_pack_apu", "number")
B738DR_six_pack_flt_cont				= create_dataref("laminar/B738/annunciator/six_pack_flt_cont", "number")
B738DR_six_pack_elec					= create_dataref("laminar/B738/annunciator/six_pack_elec", "number")
B738DR_six_pack_irs						= create_dataref("laminar/B738/annunciator/six_pack_irs", "number")

B738DR_six_pack_ice						= create_dataref("laminar/B738/annunciator/six_pack_ice", "number")
B738DR_six_pack_doors					= create_dataref("laminar/B738/annunciator/six_pack_doors", "number")
B738DR_six_pack_eng						= create_dataref("laminar/B738/annunciator/six_pack_eng", "number")
B738DR_six_pack_hyd						= create_dataref("laminar/B738/annunciator/six_pack_hyd", "number")
B738DR_six_pack_air_cond				= create_dataref("laminar/B738/annunciator/six_pack_air_cond", "number")
B738DR_six_pack_overhead				= create_dataref("laminar/B738/annunciator/six_pack_overhead", "number")



-- AUDIO PANEL STATUS LIGHTS

B738DR_transponder_fail_light			= create_dataref("laminar/B738/transponder/indicators/xpond_fail", "number")

	-- SELECTED

B738DR_audio_panel_indicator_com1		= create_dataref("laminar/B738/audio/indicators/audio_selection_com1", "number")
B738DR_audio_panel_indicator_com2		= create_dataref("laminar/B738/audio/indicators/audio_selection_com2", "number")
B738DR_audio_panel_indicator_nav1		= create_dataref("laminar/B738/audio/indicators/audio_selection_nav1", "number")
B738DR_audio_panel_indicator_nav2		= create_dataref("laminar/B738/audio/indicators/audio_selection_nav2", "number")
B738DR_audio_panel_indicator_marker		= create_dataref("laminar/B738/audio/indicators/audio_marker_enabled", "number")
	
	-- AVAILABLE

B738DR_audio_panel_com1_avail			= create_dataref("laminar/B738/audio/indicators/com1_avail", "number")
B738DR_audio_panel_com2_avail			= create_dataref("laminar/B738/audio/indicators/com2_avail", "number")
B738DR_audio_panel_nav1_avail			= create_dataref("laminar/B738/audio/indicators/nav1_avail", "number")
B738DR_audio_panel_nav2_avail			= create_dataref("laminar/B738/audio/indicators/nav2_avail", "number")
B738DR_audio_panel_mark_avail			= create_dataref("laminar/B738/audio/indicators/mark_avail", "number")

--------------------------------

	-- CAPTAIN MIC SELECTOR POSITION
	
B738DR_audio_panel_capt_mic1_pos		= create_dataref("laminar/B738/audio/capt/mic_button1", "number")
B738DR_audio_panel_capt_mic2_pos		= create_dataref("laminar/B738/audio/capt/mic_button2", "number")
B738DR_audio_panel_capt_mic3_pos		= create_dataref("laminar/B738/audio/capt/mic_button3", "number")
B738DR_audio_panel_capt_mic4_pos		= create_dataref("laminar/B738/audio/capt/mic_button4", "number")
B738DR_audio_panel_capt_mic5_pos		= create_dataref("laminar/B738/audio/capt/mic_button5", "number")
B738DR_audio_panel_capt_mic6_pos		= create_dataref("laminar/B738/audio/capt/mic_button6", "number")

	-- CAPTAIN MIC LIGHTS
	
B738DR_audio_panel_capt_mic1_light		= create_dataref("laminar/B738/audio/capt/mic_indicator1", "number")
B738DR_audio_panel_capt_mic2_light		= create_dataref("laminar/B738/audio/capt/mic_indicator2", "number")
B738DR_audio_panel_capt_mic3_light		= create_dataref("laminar/B738/audio/capt/mic_indicator3", "number")
B738DR_audio_panel_capt_mic4_light		= create_dataref("laminar/B738/audio/capt/mic_indicator4", "number")
B738DR_audio_panel_capt_mic5_light		= create_dataref("laminar/B738/audio/capt/mic_indicator5", "number")
B738DR_audio_panel_capt_mic6_light		= create_dataref("laminar/B738/audio/capt/mic_indicator6", "number")

	-- FIRST OFFICER MIC SELECTOR POSITION
	
B738DR_audio_panel_fo_mic1_pos			= create_dataref("laminar/B738/audio/fo/mic_button1", "number")
B738DR_audio_panel_fo_mic2_pos			= create_dataref("laminar/B738/audio/fo/mic_button2", "number")
B738DR_audio_panel_fo_mic3_pos			= create_dataref("laminar/B738/audio/fo/mic_button3", "number")
B738DR_audio_panel_fo_mic4_pos			= create_dataref("laminar/B738/audio/fo/mic_button4", "number")
B738DR_audio_panel_fo_mic5_pos			= create_dataref("laminar/B738/audio/fo/mic_button5", "number")
B738DR_audio_panel_fo_mic6_pos			= create_dataref("laminar/B738/audio/fo/mic_button6", "number")

	-- FIRST OFFICER MIC LIGHTS
	
B738DR_audio_panel_fo_mic1_light		= create_dataref("laminar/B738/audio/fo/mic_indicator1", "number")
B738DR_audio_panel_fo_mic2_light		= create_dataref("laminar/B738/audio/fo/mic_indicator2", "number")
B738DR_audio_panel_fo_mic3_light		= create_dataref("laminar/B738/audio/fo/mic_indicator3", "number")
B738DR_audio_panel_fo_mic4_light		= create_dataref("laminar/B738/audio/fo/mic_indicator4", "number")
B738DR_audio_panel_fo_mic5_light		= create_dataref("laminar/B738/audio/fo/mic_indicator5", "number")
B738DR_audio_panel_fo_mic6_light		= create_dataref("laminar/B738/audio/fo/mic_indicator6", "number")

	-- OBSERVER MIC SELECTOR POSITION
	
B738DR_audio_panel_obs_mic1_pos			= create_dataref("laminar/B738/audio/obs/mic_button1", "number")
B738DR_audio_panel_obs_mic2_pos			= create_dataref("laminar/B738/audio/obs/mic_button2", "number")
B738DR_audio_panel_obs_mic3_pos			= create_dataref("laminar/B738/audio/obs/mic_button3", "number")
B738DR_audio_panel_obs_mic4_pos			= create_dataref("laminar/B738/audio/obs/mic_button4", "number")
B738DR_audio_panel_obs_mic5_pos			= create_dataref("laminar/B738/audio/obs/mic_button5", "number")
B738DR_audio_panel_obs_mic6_pos			= create_dataref("laminar/B738/audio/obs/mic_button6", "number")

	-- OBSERVER MIC LIGHTS
	
B738DR_audio_panel_obs_mic1_light		= create_dataref("laminar/B738/audio/obs/mic_indicator1", "number")
B738DR_audio_panel_obs_mic2_light		= create_dataref("laminar/B738/audio/obs/mic_indicator2", "number")
B738DR_audio_panel_obs_mic3_light		= create_dataref("laminar/B738/audio/obs/mic_indicator3", "number")
B738DR_audio_panel_obs_mic4_light		= create_dataref("laminar/B738/audio/obs/mic_indicator4", "number")
B738DR_audio_panel_obs_mic5_light		= create_dataref("laminar/B738/audio/obs/mic_indicator5", "number")
B738DR_audio_panel_obs_mic6_light		= create_dataref("laminar/B738/audio/obs/mic_indicator6", "number")


B738DR_brightness2_export				= create_dataref("laminar/B738/brightness_level2", "number")

	-- AUTOBRAKE
	
B738DR_auto_brake_disarm	= create_dataref("laminar/B738/annunciator/auto_brake_disarm", "number")

B738DR_gps_fail				= create_dataref("laminar/B738/annunciator/gps", "number")


B738DR_capt_6_pack_pos		= create_dataref("laminar/B738/buttons/capt_6_pack_pos", "number")
B738DR_fo_6_pack_pos		= create_dataref("laminar/B738/buttons/fo_6_pack_pos", "number")

-- STANDBY HYD
B738DR_hyd_A_rud_annun		= create_dataref("laminar/B738/annunciator/hyd_A_rud", "number")
B738DR_hyd_B_rud_annun		= create_dataref("laminar/B738/annunciator/hyd_B_rud", "number")
B738DR_std_rud_on_annun		= create_dataref("laminar/B738/annunciator/std_rud_on", "number")
B738DR_hyd_stdby_annun		= create_dataref("laminar/B738/annunciator/hyd_stdby_rud", "number")


B738DR_off_sched_desc		= create_dataref("laminar/B738/annunciator/off_sched_descent", "number")
B738DR_altn_press			= create_dataref("laminar/B738/annunciator/altn_press", "number")
B738DR_manual_press			= create_dataref("laminar/B738/annunciator/manual_press", "number")
B738DR_autofail				= create_dataref("laminar/B738/annunciator/autofail", "number")

B738DR_stab_out_of_trim_annun		= create_dataref("laminar/B738/annunciator/stab_out_of_trim", "number")
B738DR_spd_brk_not_arm_annun		= create_dataref("laminar/B738/annunciator/spd_brk_not_arm", "number")
B738DR_door_lock_fail_annun			= create_dataref("laminar/B738/annunciator/door_lock_fail", "number")
B738DR_door_auto_unlk_annun			= create_dataref("laminar/B738/annunciator/door_auto_unlk", "number")

B738DR_ram_door_open1		= create_dataref("laminar/B738/annunciator/ram_door_open1", "number")
B738DR_ram_door_open2		= create_dataref("laminar/B738/annunciator/ram_door_open2", "number")

--*************************************************************************************--
--** 				       READ-WRITE CUSTOM DATAREF HANDLERS     	        	     **--
--*************************************************************************************--

function B738DR_kill_annun_DRhandler()end

--*************************************************************************************--
--** 				       CREATE READ-WRITE CUSTOM DATAREFS                         **--
--*************************************************************************************--

B738DR_kill_annun	= create_dataref("laminar/B738/perf/kill_annun", "number", B738DR_kill_annun_DRhandler)

--*************************************************************************************--
--** 				             CUSTOM COMMAND HANDLERS            			     **--
--*************************************************************************************--

function test_timer()
	
	if dspl_lights_test == 1 then
		if dspl_lights_test_timer < 3 then
			B738DR_dspl_lights_test = 1
		else
			B738DR_dspl_lights_test = 2
		end
		
		dspl_lights_test_timer = dspl_lights_test_timer + SIM_PERIOD
		if dspl_lights_test_timer > 4 then
			dspl_lights_test_timer = 0
		end
	else
		B738DR_dspl_lights_test = 0
	end
	
end

function B738_elt_pos_on_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_elt_switch_pos == 0 then
		B738DR_elt_switch_pos = 1
		end
	end
end

function B738_elt_pos_arm_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_elt_switch_pos == 1 then
		B738DR_elt_switch_pos = 0
		end
	end
end

function B738_bright_test_switch_pos_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_bright_test_switch_pos == 1 then
			B738DR_bright_test_switch_pos = 0
			B738DR_lights_test = 0
			simDR_generic_brightness_switch63 = 1
			B738DR_dspl_lights_test = 0
			dspl_lights_test = 0
		elseif B738DR_bright_test_switch_pos == 0 then
			B738DR_bright_test_switch_pos = -1
			simDR_generic_brightness_switch63 = 0.5
		end
	end
end

function B738_bright_test_switch_pos_up_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_bright_test_switch_pos == -1 then
			B738DR_bright_test_switch_pos = 0
			simDR_generic_brightness_switch63 = 1
		elseif B738DR_bright_test_switch_pos == 0 then
			B738DR_bright_test_switch_pos = 1
			simDR_generic_brightness_switch63 = 1
			B738DR_lights_test = 1
			B738DR_dspl_lights_test = 1
			dspl_lights_test_timer = 0
			dspl_lights_test = 1
		end
	end
end

function B738_emer_exit_lights_switch_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_emer_exit_lights_switch == 0 then
		B738DR_emer_exit_lights_switch = 1
	elseif B738DR_emer_exit_lights_switch == 1 then
		B738DR_emer_exit_lights_switch = 2
		end
	end
end

function B738_emer_exit_lights_switch_up_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_emer_exit_lights_switch == 2 then
		B738DR_emer_exit_lights_switch = 1
	elseif B738DR_emer_exit_lights_switch == 1 then
		B738DR_emer_exit_lights_switch = 0
		end
	end
end	


function B738_ex_test_lft_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_extinguisher_circuit_test_pos == 1 then
			B738DR_extinguisher_circuit_test_pos = 0
		elseif B738DR_extinguisher_circuit_test_pos == 0 then
			B738DR_extinguisher_circuit_test_pos = -1
		end
	elseif phase == 2 then
		B738DR_extinguisher_circuit_test_pos = 0
	end
end

function B738_ex_test_rgt_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_extinguisher_circuit_test_pos == -1 then
			B738DR_extinguisher_circuit_test_pos = 0
		elseif B738DR_extinguisher_circuit_test_pos == 0 then
			B738DR_extinguisher_circuit_test_pos = 1
		end
	elseif phase == 2 then
		B738DR_extinguisher_circuit_test_pos = 0
	end
end
	
function B738_cargo_fire_test_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_cargo_fire_test_button_pos == 0 then
		B738DR_cargo_fire_test_button_pos = 1
		--extinguisher_circuit_annun2 = 1
		--cargo_fire_annuns = 1
		--fire_bell_annun_reset = 1
		end
	elseif phase == 1 then
		if duration > 1.5 then
			cargo_fire_test = 1
			fire_bell_annun_reset = 1
		end
	elseif phase == 2 then
		if B738DR_cargo_fire_test_button_pos == 1 then
			B738DR_cargo_fire_test_button_pos = 0
			cargo_fire_test = 0
		end
	end
end

function B738_fire_test_lft_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_fire_test_switch_pos == 1 then
			--apu_fire_annun = 0
			--wheel_well_fire = 0		
			B738DR_fire_test_switch_pos = 0
		elseif B738DR_fire_test_switch_pos == 0 then
			B738DR_fire_test_switch_pos = -1
		end
	elseif phase == 2 then
		B738DR_fire_test_switch_pos = 0
	end
end

function B738_fire_test_rgt_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_fire_test_switch_pos == -1 then
			B738DR_fire_test_switch_pos = 0
		elseif B738DR_fire_test_switch_pos == 0 then
			B738DR_fire_test_switch_pos = 1
			--fire_panel_annuns_test = 1
			--fire_bell_annun_reset = 1
			--simCMD_test_fire_1_annun:start()
			--simCMD_test_fire_2_annun:start()
		end
	elseif phase == 1 then
		if B738DR_fire_test_switch_pos == 1 and duration > 1.5 then
			fire_panel_annuns_test = 1
			fire_bell_annun_reset = 1
		end
	elseif phase == 2 then
		B738DR_fire_test_switch_pos = 0
		fire_panel_annuns_test = 0
		--cargo_fire_annuns = 0
		-- apu_fire_annun = 0
		-- wheel_well_fire = 0
		-- extinguisher_circuit_annun2 = 0
		
		-- fire_panel_annuns_test = 0
		-- fire_bell_annun_reset = 0
		-- apu_fire_annun = 0
		-- wheel_well_fire = 0
	end
end

function B738_ap_disconnect_test1_up_CMDhandler(phase, duration)
	if phase == 0 then
		-- if B738DR_ap_disconnect1_test_switch_pos == -1 then
			-- B738DR_ap_disconnect1_test_switch_pos = 0
		-- if B738DR_ap_disconnect1_test_switch_pos == 0 then
		B738DR_ap_disconnect1_test_switch_pos = 1
		-- end
	elseif phase == 2 then
		B738DR_ap_disconnect1_test_switch_pos = 0
	end
end

function B738_ap_disconnect_test1_dn_CMDhandler(phase, duration)
	if phase == 0 then
		-- if B738DR_ap_disconnect1_test_switch_pos == 1 then
			-- B738DR_ap_disconnect1_test_switch_pos = 0
		-- if B738DR_ap_disconnect1_test_switch_pos == 0 then
		B738DR_ap_disconnect1_test_switch_pos = -1
		-- end
	elseif phase == 2 then
		B738DR_ap_disconnect1_test_switch_pos = 0
	end
end

function B738_ap_disconnect_test2_up_CMDhandler(phase, duration)
	if phase == 0 then
		-- if B738DR_ap_disconnect2_test_switch_pos == -1 then
			-- B738DR_ap_disconnect2_test_switch_pos = 0
		-- elseif B738DR_ap_disconnect2_test_switch_pos == 0 then
		B738DR_ap_disconnect2_test_switch_pos = 1
		-- end
	elseif phase == 2 then
		B738DR_ap_disconnect2_test_switch_pos = 0
	end
end

function B738_ap_disconnect_test2_dn_CMDhandler(phase, duration)
	if phase == 0 then
		-- if B738DR_ap_disconnect2_test_switch_pos == 1 then
			-- B738DR_ap_disconnect2_test_switch_pos = 0
		-- elseif B738DR_ap_disconnect2_test_switch_pos == 0 then
		B738DR_ap_disconnect2_test_switch_pos = -1
		-- end
	elseif phase == 2 then
		B738DR_ap_disconnect2_test_switch_pos = 0
	end
end

function B738_fire_bell_light_button1_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_fire_bell_pos1 == 0 then
		B738DR_fire_bell_pos1 = 1
		--simCMD_test_fire_1_annun:stop()
		--simCMD_test_fire_2_annun:stop()
		simCMD_master_warning_accept:once()
		if simDR_eng1_fire == 6 or simDR_eng2_fire == 6 then
			fire_bell_annun_reset = 0
		end
		
		-- fire_panel_annuns_test = 0
		-- cargo_fire_annuns = 0
		-- apu_fire_annun = 0
		-- wheel_well_fire = 0
		-- extinguisher_circuit_annun2 = 0
		end
	elseif phase == 2 then
		B738DR_fire_bell_pos1 = 0
	end
end


function B738_fire_bell_light_button2_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_fire_bell_pos2 == 0 then
		B738DR_fire_bell_pos2 = 1
		--simCMD_test_fire_1_annun:stop()
		--simCMD_test_fire_2_annun:stop()
		simCMD_master_warning_accept:once()
		if simDR_eng1_fire == 6 or simDR_eng2_fire == 6 then
			fire_bell_annun_reset = 0
		end
		
		-- fire_panel_annuns_test = 0
		-- cargo_fire_annuns = 0
		-- apu_fire_annun = 0
		-- wheel_well_fire = 0
		-- extinguisher_circuit_annun2 = 0
		end
	elseif phase == 2 then
		B738DR_fire_bell_pos2 = 0	
	end
end

function B738_master_caution1_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_master_caution_pos1 == 0 then
		B738DR_master_caution_pos1 = 1
		-- fire_panel_annuns_test = 0
		-- cargo_fire_annuns = 0
		-- apu_fire_annun = 0
		-- wheel_well_fire = 0
		-- extinguisher_circuit_annun2 = 0
		-- fire_bell_annun_reset = 1
		ovht_det_six_pack = 0
		-----
		flt_cont_last = flt_cont_ann
		irs_fail_last = irs_fail_ann
		fuel_six_pack_last = fuel_six_pack_ann
		elec_fail_last = elec_fail_ann
		apu_six_pack_last = apu_six_pack_ann
		ovht_det_six_pack_last = ovht_det_six_pack_ann
		
		fuel_six_pack_ann = 0
		apu_six_pack_ann = 0
		ovht_det_six_pack_ann = 0
		irs_fail_ann = 0
		elec_fail_ann = 0
		flt_cont_ann = 0
		----
		six_pack_ice_status_last = six_pack_ice_status_ann
		six_pack_hydro_last = six_pack_hydro_ann
		door_open_status_last = door_open_status_ann
		six_pack_eng_last = six_pack_eng_ann
		six_pack_ovhd_last = six_pack_ovhd_ann
		six_pack_air_cond_last = six_pack_air_cond_ann
		
		six_pack_ice_status_ann = 0
		six_pack_hydro_ann = 0
		door_open_status_ann = 0
		six_pack_eng_ann = 0
		six_pack_ovhd_ann = 0
		six_pack_air_cond_ann = 0
		----
		simCMD_master_caution_accept:once()
		end
	elseif phase == 2 then
		B738DR_master_caution_pos1 = 0
	end
end

function B738_master_caution2_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_master_caution_pos2 == 0 then
		B738DR_master_caution_pos2 = 1
		-- fire_panel_annuns_test = 0
		-- cargo_fire_annuns = 0
		-- apu_fire_annun = 0
		-- wheel_well_fire = 0
		-- extinguisher_circuit_annun2 = 0
		-- fire_bell_annun_reset = 1
		ovht_det_six_pack = 0
		-----
		flt_cont_last = flt_cont_ann
		irs_fail_last = irs_fail_ann
		fuel_six_pack_last = fuel_six_pack_ann
		elec_fail_last = elec_fail_ann
		apu_six_pack_last = apu_six_pack_ann
		ovht_det_six_pack_last = ovht_det_six_pack_ann
		
		fuel_six_pack_ann = 0
		apu_six_pack_ann = 0
		ovht_det_six_pack_ann = 0
		irs_fail_ann = 0
		elec_fail_ann = 0
		flt_cont_ann = 0
		----
		six_pack_ice_status_last = six_pack_ice_status_ann
		six_pack_hydro_last = six_pack_hydro_ann
		door_open_status_last = door_open_status_ann
		six_pack_eng_last = six_pack_eng_ann
		six_pack_ovhd_last = six_pack_ovhd_ann
		six_pack_air_cond_last = six_pack_air_cond_ann
		
		six_pack_ice_status_ann = 0
		six_pack_hydro_ann = 0
		door_open_status_ann = 0
		six_pack_eng_ann = 0
		six_pack_ovhd_ann = 0
		six_pack_air_cond_ann = 0
		----
		simCMD_master_caution_accept:once()
		end
	elseif phase == 2 then
		B738DR_master_caution_pos2 = 0
	end
end

-----------------------------------------------------

-- CAPTAIN AUDIO PANEL MIC SELECTOR COMMAND HANDLERS

function B738_capt_push_mic1_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_audio_panel_capt_mic1_pos == 0 then
		B738DR_audio_panel_capt_mic1_pos = 1
		B738DR_audio_panel_capt_mic2_pos = 0
		B738DR_audio_panel_capt_mic3_pos = 0
		B738DR_audio_panel_capt_mic4_pos = 0
		B738DR_audio_panel_capt_mic5_pos = 0
		B738DR_audio_panel_capt_mic6_pos = 0
		end
	end
end

function B738_capt_push_mic2_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_audio_panel_capt_mic2_pos == 0 then
		B738DR_audio_panel_capt_mic1_pos = 0
		B738DR_audio_panel_capt_mic2_pos = 1
		B738DR_audio_panel_capt_mic3_pos = 0
		B738DR_audio_panel_capt_mic4_pos = 0
		B738DR_audio_panel_capt_mic5_pos = 0
		B738DR_audio_panel_capt_mic6_pos = 0
		end
	end
end

function B738_capt_push_mic3_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_audio_panel_capt_mic3_pos == 0 then
		B738DR_audio_panel_capt_mic1_pos = 0
		B738DR_audio_panel_capt_mic2_pos = 0
		B738DR_audio_panel_capt_mic3_pos = 1
		B738DR_audio_panel_capt_mic4_pos = 0
		B738DR_audio_panel_capt_mic5_pos = 0
		B738DR_audio_panel_capt_mic6_pos = 0
		end
	end
end

function B738_capt_push_mic4_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_audio_panel_capt_mic4_pos == 0 then
		B738DR_audio_panel_capt_mic1_pos = 0
		B738DR_audio_panel_capt_mic2_pos = 0
		B738DR_audio_panel_capt_mic3_pos = 0
		B738DR_audio_panel_capt_mic4_pos = 1
		B738DR_audio_panel_capt_mic5_pos = 0
		B738DR_audio_panel_capt_mic6_pos = 0
		end
	end
end

function B738_capt_push_mic5_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_audio_panel_capt_mic5_pos == 0 then
		B738DR_audio_panel_capt_mic1_pos = 0
		B738DR_audio_panel_capt_mic2_pos = 0
		B738DR_audio_panel_capt_mic3_pos = 0
		B738DR_audio_panel_capt_mic4_pos = 0
		B738DR_audio_panel_capt_mic5_pos = 1
		B738DR_audio_panel_capt_mic6_pos = 0
		end
	end
end
	
function B738_capt_push_mic6_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_audio_panel_capt_mic6_pos == 0 then
		B738DR_audio_panel_capt_mic1_pos = 0
		B738DR_audio_panel_capt_mic2_pos = 0
		B738DR_audio_panel_capt_mic3_pos = 0
		B738DR_audio_panel_capt_mic4_pos = 0
		B738DR_audio_panel_capt_mic5_pos = 0
		B738DR_audio_panel_capt_mic6_pos = 1
		end
	end
end

-- FIRST OFFICER AUDIO PANEL MIC SELECTOR COMMAND HANDLERS --------------

function B738_fo_push_mic1_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_audio_panel_fo_mic1_pos == 0 then
		B738DR_audio_panel_fo_mic1_pos = 1
		B738DR_audio_panel_fo_mic2_pos = 0
		B738DR_audio_panel_fo_mic3_pos = 0
		B738DR_audio_panel_fo_mic4_pos = 0
		B738DR_audio_panel_fo_mic5_pos = 0
		B738DR_audio_panel_fo_mic6_pos = 0
		end
	end
end

function B738_fo_push_mic2_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_audio_panel_fo_mic2_pos == 0 then
		B738DR_audio_panel_fo_mic1_pos = 0
		B738DR_audio_panel_fo_mic2_pos = 1
		B738DR_audio_panel_fo_mic3_pos = 0
		B738DR_audio_panel_fo_mic4_pos = 0
		B738DR_audio_panel_fo_mic5_pos = 0
		B738DR_audio_panel_fo_mic6_pos = 0
		end
	end
end

function B738_fo_push_mic3_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_audio_panel_fo_mic3_pos == 0 then
		B738DR_audio_panel_fo_mic1_pos = 0
		B738DR_audio_panel_fo_mic2_pos = 0
		B738DR_audio_panel_fo_mic3_pos = 1
		B738DR_audio_panel_fo_mic4_pos = 0
		B738DR_audio_panel_fo_mic5_pos = 0
		B738DR_audio_panel_fo_mic6_pos = 0
		end
	end
end

function B738_fo_push_mic4_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_audio_panel_fo_mic4_pos == 0 then
		B738DR_audio_panel_fo_mic1_pos = 0
		B738DR_audio_panel_fo_mic2_pos = 0
		B738DR_audio_panel_fo_mic3_pos = 0
		B738DR_audio_panel_fo_mic4_pos = 1
		B738DR_audio_panel_fo_mic5_pos = 0
		B738DR_audio_panel_fo_mic6_pos = 0
		end
	end
end

function B738_fo_push_mic5_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_audio_panel_fo_mic5_pos == 0 then
		B738DR_audio_panel_fo_mic1_pos = 0
		B738DR_audio_panel_fo_mic2_pos = 0
		B738DR_audio_panel_fo_mic3_pos = 0
		B738DR_audio_panel_fo_mic4_pos = 0
		B738DR_audio_panel_fo_mic5_pos = 1
		B738DR_audio_panel_fo_mic6_pos = 0
		end
	end
end

function B738_fo_push_mic6_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_audio_panel_fo_mic6_pos == 0 then
		B738DR_audio_panel_fo_mic1_pos = 0
		B738DR_audio_panel_fo_mic2_pos = 0
		B738DR_audio_panel_fo_mic3_pos = 0
		B738DR_audio_panel_fo_mic4_pos = 0
		B738DR_audio_panel_fo_mic5_pos = 0
		B738DR_audio_panel_fo_mic6_pos = 1
		end
	end
end

-- OBSERVER AUDIO PANEL MIC SELECTOR COMMAND HANDLERS --------------

function B738_obs_push_mic1_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_audio_panel_obs_mic1_pos == 0 then
		B738DR_audio_panel_obs_mic1_pos = 1
		B738DR_audio_panel_obs_mic2_pos = 0
		B738DR_audio_panel_obs_mic3_pos = 0
		B738DR_audio_panel_obs_mic4_pos = 0
		B738DR_audio_panel_obs_mic5_pos = 0
		B738DR_audio_panel_obs_mic6_pos = 0
		end
	end
end

function B738_obs_push_mic2_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_audio_panel_obs_mic2_pos == 0 then
		B738DR_audio_panel_obs_mic1_pos = 0
		B738DR_audio_panel_obs_mic2_pos = 1
		B738DR_audio_panel_obs_mic3_pos = 0
		B738DR_audio_panel_obs_mic4_pos = 0
		B738DR_audio_panel_obs_mic5_pos = 0
		B738DR_audio_panel_obs_mic6_pos = 0
		end
	end
end

function B738_obs_push_mic3_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_audio_panel_obs_mic3_pos == 0 then
		B738DR_audio_panel_obs_mic1_pos = 0
		B738DR_audio_panel_obs_mic2_pos = 0
		B738DR_audio_panel_obs_mic3_pos = 1
		B738DR_audio_panel_obs_mic4_pos = 0
		B738DR_audio_panel_obs_mic5_pos = 0
		B738DR_audio_panel_obs_mic6_pos = 0
		end
	end
end

function B738_obs_push_mic4_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_audio_panel_obs_mic4_pos == 0 then
		B738DR_audio_panel_obs_mic1_pos = 0
		B738DR_audio_panel_obs_mic2_pos = 0
		B738DR_audio_panel_obs_mic3_pos = 0
		B738DR_audio_panel_obs_mic4_pos = 1
		B738DR_audio_panel_obs_mic5_pos = 0
		B738DR_audio_panel_obs_mic6_pos = 0
		end
	end
end

function B738_obs_push_mic5_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_audio_panel_obs_mic5_pos == 0 then
		B738DR_audio_panel_obs_mic1_pos = 0
		B738DR_audio_panel_obs_mic2_pos = 0
		B738DR_audio_panel_obs_mic3_pos = 0
		B738DR_audio_panel_obs_mic4_pos = 0
		B738DR_audio_panel_obs_mic5_pos = 1
		B738DR_audio_panel_obs_mic6_pos = 0
		end
	end
end

function B738_obs_push_mic6_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_audio_panel_obs_mic6_pos == 0 then
		B738DR_audio_panel_obs_mic1_pos = 0
		B738DR_audio_panel_obs_mic2_pos = 0
		B738DR_audio_panel_obs_mic3_pos = 0
		B738DR_audio_panel_obs_mic4_pos = 0
		B738DR_audio_panel_obs_mic5_pos = 0
		B738DR_audio_panel_obs_mic6_pos = 1
		end
	end
end

function B738_capt_6_pack_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_capt_6_pack_pos = 1
	elseif phase == 2 then
		B738DR_capt_6_pack_pos = 0
		
		fuel_six_pack_old = 0
		apu_six_pack_old = 0
		ovht_det_six_pack_old = 0
		irs_fail_old = 0
		elec_fail_old = 0
		flt_cont_old = 0
		-----
		six_pack_ice_status_old = 0
		six_pack_hydro_old = 0
		door_open_status_old = 0
		six_pack_eng_old = 0
		six_pack_ovhd_old = 0
		six_pack_air_cond_old = 0
		
		fire_bell_annun_reset = 1
		-- flt_cont_ann = flt_cont_last
		-- irs_fail_ann = irs_fail_last
		-- fuel_six_pack_ann = fuel_six_pack_last
		-- elec_fail_ann = elec_fail_last
		-- apu_six_pack_ann = apu_six_pack_last
		-- ovht_det_six_pack_ann = ovht_det_six_pack_last
		
	end
end

function B738_fo_6_pack_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_fo_6_pack_pos = 1
	elseif phase == 2 then
		B738DR_fo_6_pack_pos = 0
		
		fuel_six_pack_old = 0
		apu_six_pack_old = 0
		ovht_det_six_pack_old = 0
		irs_fail_old = 0
		elec_fail_old = 0
		flt_cont_old = 0
		-----
		six_pack_ice_status_old = 0
		six_pack_hydro_old = 0
		door_open_status_old = 0
		six_pack_eng_old = 0
		six_pack_ovhd_old = 0
		six_pack_air_cond_old = 0
		
		fire_bell_annun_reset = 1
		-- six_pack_ice_status_ann = six_pack_ice_status_last
		-- six_pack_hydro_ann = six_pack_hydro_last
		-- door_open_status_ann = door_open_status_last
		-- six_pack_eng_ann = six_pack_eng_last
		-- six_pack_ovhd_ann = six_pack_ovhd_last
		-- six_pack_air_cond_ann = six_pack_air_cond_last
		
	end
end

----------------------------------------------------------------------------------------------------


--*************************************************************************************--
--** 				              CREATE CUSTOM COMMANDS              			     **--
--*************************************************************************************--


B738CMD_capt_6_pack		= create_command("laminar/B738/push_button/capt_six_pack", "Captain Master warn six pack", B738_capt_6_pack_CMDhandler)
B738CMD_fo_6_pack		= create_command("laminar/B738/push_button/fo_six_pack", "First officer Master warn six pack", B738_fo_6_pack_CMDhandler)

-- B738CMD_gpu_pos		= create_command("laminar/B738/toggle_switch/gpu_pos", "GPU On/Off", B738_gpu_switch_pos_CMDhandler)

B738CMD_elt_pos_on		= create_command("laminar/B738/toggle_switch/elt_on", "ELT on", B738_elt_pos_on_CMDhandler)
B738CMD_elt_pos_arm		= create_command("laminar/B738/toggle_switch/elt_arm", "ELT arm", B738_elt_pos_arm_CMDhandler)

B738CMD_bright_test_switch_dn	= create_command("laminar/B738/toggle_switch/bright_test_dn", "Lights Test / Brightness", B738_bright_test_switch_pos_dn_CMDhandler)
B738CMD_bright_test_switch_up	= create_command("laminar/B738/toggle_switch/bright_test_up", "Lights Test / Brightness", B738_bright_test_switch_pos_up_CMDhandler)

B738CMD_emer_exit_lights_switch_dn	= create_command("laminar/B738/toggle_switch/emer_exit_lights_dn", "Emergency Exit Lights Switch", B738_emer_exit_lights_switch_dn_CMDhandler)
B738CMD_emer_exit_lights_switch_up	= create_command("laminar/B738/toggle_switch/emer_exit_lights_up", "Emergency Exit Lights Switch", B738_emer_exit_lights_switch_up_CMDhandler)

B738CMD_extinguisher_circuit_test_lft	= create_command("laminar/B738/toggle_switch/exting_test_lft", "Extinguisher Test Switch", B738_ex_test_lft_CMDhandler)
B738CMD_extinguisher_circuit_test_rgt	= create_command("laminar/B738/toggle_switch/exting_test_rgt", "Extinguisher Test Switch", B738_ex_test_rgt_CMDhandler)

B738CMD_cargo_fire_test_button			= create_command("laminar/B738/push_button/cargo_fire_test_push", "Cargo Fire Test", B738_cargo_fire_test_CMDhandler)

B738CMD_fire_test_switch_lft	= create_command("laminar/B738/toggle_switch/fire_test_lft", "Fire Panel Test", B738_fire_test_lft_CMDhandler)
B738CMD_fire_test_switch_rgt	= create_command("laminar/B738/toggle_switch/fire_test_rgt", "Fire Panel Test", B738_fire_test_rgt_CMDhandler)

B738CMD_ap_disconnect_test1_up	= create_command("laminar/B738/toggle_switch/ap_disconnect_test1_up", "Captain AP Disconnect Test", B738_ap_disconnect_test1_up_CMDhandler)
B738CMD_ap_disconnect_test1_dn	= create_command("laminar/B738/toggle_switch/ap_disconnect_test1_dn", "Captain AP Disconnect Test", B738_ap_disconnect_test1_dn_CMDhandler)

B738CMD_ap_disconnect_test2_up	= create_command("laminar/B738/toggle_switch/ap_disconnect_test2_up", "First Officer AP Disconnect Test", B738_ap_disconnect_test2_up_CMDhandler)
B738CMD_ap_disconnect_test2_dn	= create_command("laminar/B738/toggle_switch/ap_disconnect_test2_dn", "First Officer AP Disconnect Test", B738_ap_disconnect_test2_dn_CMDhandler)

B738CMD_fire_bell_light_button1	= create_command("laminar/B738/push_button/fire_bell_light1", "Captain Fire Warn Bell Cutout", B738_fire_bell_light_button1_CMDhandler)
B738CMD_fire_bell_light_button2	= create_command("laminar/B738/push_button/fire_bell_light2", "First Officer Fire Warn Bell Cutout", B738_fire_bell_light_button2_CMDhandler)

B738CMD_master_caution_button1	= create_command("laminar/B738/push_button/master_caution1", "Captain Fire Master Caution", B738_master_caution1_CMDhandler)
B738CMD_master_caution_button2	= create_command("laminar/B738/push_button/master_caution2", "First Officer Master Caution", B738_master_caution2_CMDhandler)

-- AUDIO PANEL MIC SELECTOR COMMANDS
	-- CAPT
	
B738CMD_capt_push_mic1			= create_command("laminar/B738/audio/capt/mic_push1", "Captain VHF1 Mic", B738_capt_push_mic1_CMDhandler)
B738CMD_capt_push_mic2			= create_command("laminar/B738/audio/capt/mic_push2", "Captain VHF2 Mic", B738_capt_push_mic2_CMDhandler)
B738CMD_capt_push_mic3			= create_command("laminar/B738/audio/capt/mic_push3", "Captain VHF3 Mic", B738_capt_push_mic3_CMDhandler)
B738CMD_capt_push_mic4			= create_command("laminar/B738/audio/capt/mic_push4", "Captain Interphone Mic", B738_capt_push_mic4_CMDhandler)
B738CMD_capt_push_mic5			= create_command("laminar/B738/audio/capt/mic_push5", "Captain Cabin Mic", B738_capt_push_mic5_CMDhandler)
B738CMD_capt_push_mic6			= create_command("laminar/B738/audio/capt/mic_push6", "Captain PA Mic", B738_capt_push_mic6_CMDhandler)

	-- F/O

B738CMD_fo_push_mic1			= create_command("laminar/B738/audio/fo/mic_push1", "First Officer VHF1 Mic", B738_fo_push_mic1_CMDhandler)
B738CMD_fo_push_mic2			= create_command("laminar/B738/audio/fo/mic_push2", "First Officer VHF2 Mic", B738_fo_push_mic2_CMDhandler)
B738CMD_fo_push_mic3			= create_command("laminar/B738/audio/fo/mic_push3", "First Officer VHF3 Mic", B738_fo_push_mic3_CMDhandler)
B738CMD_fo_push_mic4			= create_command("laminar/B738/audio/fo/mic_push4", "First Officer Interphone Mic", B738_fo_push_mic4_CMDhandler)
B738CMD_fo_push_mic5			= create_command("laminar/B738/audio/fo/mic_push5", "First Officer Cabin Mic", B738_fo_push_mic5_CMDhandler)
B738CMD_fo_push_mic6			= create_command("laminar/B738/audio/fo/mic_push6", "First Officer PA Mic", B738_fo_push_mic6_CMDhandler)

	-- OBS
	
B738CMD_obs_push_mic1			= create_command("laminar/B738/audio/obs/mic_push1", "Observer VHF1 Mic", B738_obs_push_mic1_CMDhandler)
B738CMD_obs_push_mic2			= create_command("laminar/B738/audio/obs/mic_push2", "Observer VHF2 Mic", B738_obs_push_mic2_CMDhandler)
B738CMD_obs_push_mic3			= create_command("laminar/B738/audio/obs/mic_push3", "Observer VHF3 Mic", B738_obs_push_mic3_CMDhandler)
B738CMD_obs_push_mic4			= create_command("laminar/B738/audio/obs/mic_push4", "Observer Interphone Mic", B738_obs_push_mic4_CMDhandler)
B738CMD_obs_push_mic5			= create_command("laminar/B738/audio/obs/mic_push5", "Observer Cabin Mic", B738_obs_push_mic5_CMDhandler)
B738CMD_obs_push_mic6			= create_command("laminar/B738/audio/obs/mic_push6", "Observer PA Mic", B738_obs_push_mic6_CMDhandler)

--*************************************************************************************--
--** 				             X-PLANE COMMAND HANDLERS               	    	 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				             REPLACE X-PLANE COMMANDS                  	    	 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				              WRAP X-PLANE COMMANDS                  	    	 **--
--*************************************************************************************--



--*************************************************************************************--
--** 					           OBJECT CONSTRUCTORS         		        		 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				                  CREATE OBJECTS              	     			 **--
--*************************************************************************************--



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

-- B738_external_power()

-- function B738_external_power()

    -- if B738DR_ground_power_switch_pos == 1
        -- and simDR_aircraft_on_ground == 1
        -- and simDR_aircraft_groundspeed < 0.05
        -- and simDR_ext_pwr_1_on == 0
    -- then
        -- simDR_ext_pwr_1_on = 1
    -- elseif B738DR_ground_power_switch_pos == 0 then
        -- simDR_ext_pwr_1_on = 0
    -- end
    
    --if simDR_aircraft_groundspeed > 0.05 or simDR_parking_brake == 0 then
	
	
	-- if B738DR_gpu_available == 0 then
		-- simDR_ext_pwr_1_on = 0
    -- end
    
-- end


-- BATTERY DICHARGE

function B738_Amp5Exceed() 
	batt_discharge5 = 1
	--batt_discharge15 = 0
	--batt_discharge100 = 0
end	
	
function B738_Amp15Exceed() 
	batt_discharge15 = 1
	--batt_discharge5 = 0
	--batt_discharge100 = 0
end	

function B738_Amp100Exceed() 
	batt_discharge100 = 1
	--batt_discharge5 = 0
	--batt_discharge15 = 0
end	

function B738_battery_disch_annun()

	-- BATTERY DISHARGE IS LESS THAN 5.0 AMPS
	if simDR_battery_amps[0] > -5.0 then
		batt_discharge5 = 0
		batt_discharge15 = 0
		batt_discharge100 = 0
		if is_timer_scheduled(B738_Amp5Exceed) == true then stop_timer(B738_Amp5Exceed) end
		if is_timer_scheduled(B738_Amp15Exceed) == true then stop_timer(B738_Amp15Exceed) end			
		if is_timer_scheduled(B738_Amp100Exceed) == true then stop_timer(B738_Amp100Exceed) end			
	
	-- BATTERY DISCHARGE EXCEEDS 5.0 AMPS
	elseif simDR_battery_amps[0] <= -5.0 and simDR_battery_amps[0] > -15.0 then
		if is_timer_scheduled(B738_Amp5Exceed) == false then run_after_time(B738_Amp5Exceed, 95.0) end
		--if is_timer_scheduled(B738_Amp15Exceed) == true then stop_timer(B738_Amp15Exceed) end			
		--if is_timer_scheduled(B738_Amp100Exceed) == true then stop_timer(B738_Amp100Exceed) end
						

	-- BATTERY DISCHARGE EXCEEDS 15.0 AMPS
	elseif simDR_battery_amps[0] <= -15.0 and simDR_battery_amps[0] > -100.0 then
		if is_timer_scheduled(B738_Amp15Exceed) == false then run_after_time(B738_Amp15Exceed, 3.5) end
		--if is_timer_scheduled(B738_Amp15Exceed) == false then run_after_time(B738_Amp15Exceed, 25.0) end
		--if is_timer_scheduled(B738_Amp5Exceed) == true then stop_timer(B738_Amp5Exceed) end			
		--if is_timer_scheduled(B738_Amp100Exceed) == true then stop_timer(B738_Amp100Exceed) end
	
	-- BATTERY DISCHARGE EXCEEDS 100.0 AMPS
	elseif simDR_battery_amps[0] <= -100.0 then
		if is_timer_scheduled(B738_Amp100Exceed) == false then run_after_time(B738_Amp100Exceed, 2.0) end
		--if is_timer_scheduled(B738_Amp100Exceed) == false then run_after_time(B738_Amp100Exceed, 1.2) end
		--if is_timer_scheduled(B738_Amp5Exceed) == true then stop_timer(B738_Amp5Exceed) end			
		--if is_timer_scheduled(B738_Amp15Exceed) == true then stop_timer(B738_Amp15Exceed) end		
	end	
	
	if simDR_battery_amps[0] > -15.0 then
		batt_discharge15 = 0
		batt_discharge100 = 0
	end
	if simDR_battery_amps[0] > -100.0 then
		batt_discharge100 = 0
	end
	
	if batt_discharge5 == 1 or batt_discharge15 == 1 or batt_discharge100 == 1 then
		batt_discharge = 1
	else
		batt_discharge = 0
	end
end

function wing_body_ovht_act()
	wing_body_ovht_test = 1
end

function fdr_test_timer()
	fdr_test = 2
end

----- ANNUNCIATORS -----------------------------------------------------------------------

function B738_annunciators()
	local bus1Power = B738_rescale(0.0, 0.0, 28.0, 1.0, simDR_electrical_bus_volts0)
	local bus2Power = B738_rescale(0.0, 0.0, 28.0, 1.0, simDR_electrical_bus_volts1)
	local busPower  = math.max(bus1Power, bus2Power)
	local brightness_level = simDR_generic_brightness_ratio63 * busPower
	local brightness_level2 = simDR_generic_brightness_ratio62 * busPower

	local parking_brake_annun_on = 0
		if simDR_parking_brake > 0.9 then
		parking_brake_annun_on = 1
		end

	B738DR_brightness2_export = brightness_level2

	B738DR_parking_brake_annun = parking_brake_annun_on * brightness_level2
	
	-- WINDOW HEAT
	-- Left side 
	if B738DR_ac_tnsbus2_status == 0 then
		window_heat_l_side_trg = 0
		window_heat_l_side_time = 0
	--end
	elseif B738DR_window_heat_l_side_pos == 0 then
		window_heat_l_side_trg = 0
		window_heat_l_side_time = 0
	--end
	--if B738DR_window_heat_l_side_pos == 1 then
	else
		window_heat_l_side_trg = 1
	end
	
	window_heat_l_side_time = B738_set_anim_value(window_heat_l_side_time, window_heat_l_side_trg, 0.0, 1.0, 5.0)
	if window_heat_l_side_time > 0.95 then
		window_heat_l_side_cur = 1
	elseif window_heat_l_side_time < 0.05 then
		window_heat_l_side_cur = 0
	end
	
	local window_l_side_annun = 0
	if window_heat_l_side_cur == 1 and l_side_temp < 43 then
		window_l_side_annun = 1
	end
	
	-- Left forward
	if B738DR_ac_tnsbus1_status == 0 then
		window_heat_l_fwd_trg = 0
		window_heat_l_fwd_time = 0
	--end
	elseif B738DR_window_heat_l_fwd_pos == 0 then
		window_heat_l_fwd_trg = 0
		window_heat_l_fwd_time = 0
	--end
	--if B738DR_window_heat_l_fwd_pos == 1 then
	else
		window_heat_l_fwd_trg = 1
	end
	
	window_heat_l_fwd_time = B738_set_anim_value(window_heat_l_fwd_time, window_heat_l_fwd_trg, 0.0, 1.0, 5.0)
	if window_heat_l_fwd_time > 0.95 then
		window_heat_l_fwd_cur = 1
	elseif window_heat_l_fwd_time < 0.05 then
		window_heat_l_fwd_cur = 0
	end
	
	local window_l_fwd_annun = 0
	if window_heat_l_fwd_cur == 1 and l_fwd_temp < 43 then
		window_l_fwd_annun = 1
	end
	
	-- Right side 
	if B738DR_ac_tnsbus1_status == 0 then
		window_heat_r_side_trg = 0
		window_heat_r_side_time = 0
	--end
	elseif B738DR_window_heat_r_side_pos == 0 then
		window_heat_r_side_trg = 0
		window_heat_r_side_time = 0
	--end
	--if B738DR_window_heat_r_side_pos == 1 then
	else
		window_heat_r_side_trg = 1
	end
	
	window_heat_r_side_time = B738_set_anim_value(window_heat_r_side_time, window_heat_r_side_trg, 0.0, 1.0, 5.0)
	if window_heat_r_side_time > 0.95 then
		window_heat_r_side_cur = 1
	elseif window_heat_r_side_time < 0.05 then
		window_heat_r_side_cur = 0
	end
	
	local window_r_side_annun = 0
	if window_heat_r_side_cur == 1 and r_side_temp < 43 then
		window_r_side_annun = 1
	end
	
	-- Right forward
	if B738DR_ac_tnsbus2_status == 0 then
		window_heat_r_fwd_trg = 0
		window_heat_r_fwd_time = 0
	--end
	elseif B738DR_window_heat_r_fwd_pos == 0 then
		window_heat_r_fwd_trg = 0
		window_heat_r_fwd_time = 0
	--end
	--if B738DR_window_heat_r_fwd_pos == 1 then
	else
		window_heat_r_fwd_trg = 1
	end
	
	window_heat_r_fwd_time = B738_set_anim_value(window_heat_r_fwd_time, window_heat_r_fwd_trg, 0.0, 1.0, 5.0)
	if window_heat_r_fwd_time > 0.95 then
		window_heat_r_fwd_cur = 1
	elseif window_heat_r_fwd_time < 0.05 then
		window_heat_r_fwd_cur = 0
	end
	
	local window_r_fwd_annun = 0
	if window_heat_r_fwd_cur == 1 and r_fwd_temp < 43 then
		window_r_fwd_annun = 1
	end
	
	-- Window heat failed
	if B738DR_window_heat_fail_rf == 1 then
		window_r_fwd_annun = 0
	end
	if B738DR_window_heat_fail_rs == 1 then
		window_r_side_annun = 0
	end
	if B738DR_window_heat_fail_lf == 1 then
		window_l_fwd_annun = 0
	end
	if B738DR_window_heat_fail_ls == 1 then
		window_l_side_annun = 0
	end
	
	B738DR_window_heat_annun1 = window_l_side_annun * simDR_window_heat * brightness_level
	B738DR_window_heat_annun2 = window_l_fwd_annun * simDR_window_heat * brightness_level
	B738DR_window_heat_annun3 = window_r_side_annun * simDR_window_heat * brightness_level
	B738DR_window_heat_annun4 = window_r_fwd_annun * simDR_window_heat * brightness_level

	-- B738DR_window_heat_annun1 = B738DR_window_heat_l_side_pos * simDR_window_heat * brightness_level
	-- B738DR_window_heat_annun2 = B738DR_window_heat_l_fwd_pos * simDR_window_heat * brightness_level
	-- B738DR_window_heat_annun3 = B738DR_window_heat_r_side_pos * simDR_window_heat * brightness_level
	-- B738DR_window_heat_annun4 = B738DR_window_heat_r_fwd_pos * simDR_window_heat * brightness_level

--	B738DR_window_heat_annun = simDR_window_heat * brightness_level
	
	--------------



	local fadec_fail_0 = 0
		if simDR_fadec_fail_0 > 5.5 then
		fadec_fail_0 = 1
		end
	local fadec_fail_1 = 0
		if simDR_fadec_fail_1 > 5.5 then
		fadec_fail_1 = 1
		end
	
	-- REVERSER
	local reverser_active_0 = 0
	if simDR_reverse_thrust1 == 3 and B738DR_hyd_A_status == 1 then
		reverser_active_0 = 1
	end
	
	local reverser_active_1 = 0
	if simDR_reverse_thrust2 == 3 and B738DR_hyd_B_status == 1 then
		reverser_active_1 = 1
	end
	
	-- local reverser_fail_0 = 0
		-- if simDR_reverser_fail_0 > 5.5 then
		-- reverser_fail_0 = 1
		-- end
	-- local reverser_fail_1 = 0
		-- if simDR_reverser_fail_1 > 5.5 then
		-- reverser_fail_1 = 1
		-- end


	B738DR_fadec_fail_annun_0 = fadec_fail_0 * brightness_level
	B738DR_fadec_fail_annun_1 = fadec_fail_1 * brightness_level
	-- B738DR_reverser_fail_annun_0 = reverser_fail_0 * brightness_level
	-- B738DR_reverser_fail_annun_1 = reverser_fail_1 * brightness_level
	
	B738DR_reverser_fail_annun_0 = reverser_active_0 * brightness_level
	B738DR_reverser_fail_annun_1 = reverser_active_1 * brightness_level
	
	local apu_fault = 0
		if simDR_apu_fault > 5.5 then
		apu_fault = 1
		end
	
	B738DR_apu_fault_annun = apu_fault * brightness_level

	B738DR_pax_oxy = simDR_pax_oxy_status * brightness_level
	
	--B738DR_wing_body_ovht = simDR_wing_body_ovht_annun * brightness_level
	
	if B738DR_duct_ovht_test_pos == 0 then
		if is_timer_scheduled(wing_body_ovht_act) == true then
			stop_timer(wing_body_ovht_act)
		end
		wing_body_ovht_test = 0
	else
		if is_timer_scheduled(wing_body_ovht_act) == false and wing_body_ovht_test == 0 then
			run_after_time(wing_body_ovht_act, 3)
		end
	end
	
	local wing_body_ovht = 0
	if simDR_wing_body_ovht_annun == 1 or wing_body_ovht_test == 1 then
		wing_body_ovht = 1
	end
	
	B738DR_wing_body_ovht_left =  wing_body_ovht * brightness_level
	B738DR_wing_body_ovht_right =  wing_body_ovht * brightness_level

	B738DR_bleed_trip_off1 = simDR_bleed_trip_off1_annun * brightness_level

	B738DR_bleed_trip_off2 = simDR_bleed_trip_off2_annun * brightness_level

	B738DR_battery_disch_annun = batt_discharge * brightness_level


	local transponder_fail = 0
		if simDR_transponder_fail == 6 then
		transponder_fail = 1
		end
		
	B738DR_transponder_fail_light = transponder_fail * brightness_level2
	

-- AUDIO PANEL

	B738DR_audio_panel_indicator_com1 = simDR_audio_selection_com1 * brightness_level
	B738DR_audio_panel_indicator_com2 = simDR_audio_selection_com2 * brightness_level
	B738DR_audio_panel_indicator_nav1 = simDR_audio_selection_nav1 * brightness_level
	B738DR_audio_panel_indicator_nav2 = simDR_audio_selection_nav2 * brightness_level
	B738DR_audio_panel_indicator_marker = simDR_audio_selection_marker * brightness_level


	B738DR_audio_panel_com1_avail = simDR_com1_active * brightness_level2
	B738DR_audio_panel_com2_avail = simDR_com2_active * brightness_level2
	
	local marker_indicator = 0
		if simDR_outer_marker_active == 1
		or simDR_middle_marker_active == 1
		or simDR_inner_marker_active == 1 then
		marker_indicator = 1
		end
		
	B738DR_audio_panel_mark_avail = marker_indicator * brightness_level2
	
	local nav1_indicator = 0
		if simDR_nav1h_active == 1
		or simDR_nav1v_active == 1
		or simDR_nav1dme_active == 1 then
		nav1_indicator = 1
		end
		
	B738DR_audio_panel_nav1_avail = nav1_indicator * brightness_level2
	
	local nav2_indicator = 0
		if simDR_nav2h_active == 1
		or simDR_nav2v_active == 1
		or simDR_nav2dme_active == 1 then
		nav2_indicator = 1
		end
		
	B738DR_audio_panel_nav2_avail = nav2_indicator * brightness_level2


-- AUDIO PANEL MIC LIGHTS

B738DR_audio_panel_capt_mic1_light = B738DR_audio_panel_capt_mic1_pos * brightness_level
B738DR_audio_panel_capt_mic2_light = B738DR_audio_panel_capt_mic2_pos * brightness_level
B738DR_audio_panel_capt_mic3_light = B738DR_audio_panel_capt_mic3_pos * brightness_level
B738DR_audio_panel_capt_mic4_light = B738DR_audio_panel_capt_mic4_pos * brightness_level
B738DR_audio_panel_capt_mic5_light = B738DR_audio_panel_capt_mic5_pos * brightness_level
B738DR_audio_panel_capt_mic6_light = B738DR_audio_panel_capt_mic6_pos * brightness_level

B738DR_audio_panel_fo_mic1_light = B738DR_audio_panel_fo_mic1_pos * brightness_level
B738DR_audio_panel_fo_mic2_light = B738DR_audio_panel_fo_mic2_pos * brightness_level
B738DR_audio_panel_fo_mic3_light = B738DR_audio_panel_fo_mic3_pos * brightness_level
B738DR_audio_panel_fo_mic4_light = B738DR_audio_panel_fo_mic4_pos * brightness_level
B738DR_audio_panel_fo_mic5_light = B738DR_audio_panel_fo_mic5_pos * brightness_level
B738DR_audio_panel_fo_mic6_light = B738DR_audio_panel_fo_mic6_pos * brightness_level

B738DR_audio_panel_obs_mic1_light = B738DR_audio_panel_obs_mic1_pos * brightness_level
B738DR_audio_panel_obs_mic2_light = B738DR_audio_panel_obs_mic2_pos * brightness_level
B738DR_audio_panel_obs_mic3_light = B738DR_audio_panel_obs_mic3_pos * brightness_level
B738DR_audio_panel_obs_mic4_light = B738DR_audio_panel_obs_mic4_pos * brightness_level
B738DR_audio_panel_obs_mic5_light = B738DR_audio_panel_obs_mic5_pos * brightness_level
B738DR_audio_panel_obs_mic6_light = B738DR_audio_panel_obs_mic6_pos * brightness_level


----- DOORS -------------------------------------------------------

	local fwd_entry = 0
		if simDR_fwd_entry_status > 0.01 then
		fwd_entry = 1
		end
		
	local aft_entry = 0
		if simDR_aft_entry_status > 0.01 then
		aft_entry = 1
		end	

	local fwd_service = 0
		if simDR_fwd_service_status > 0.01 then
		fwd_service = 1
		end
		
	local aft_service = 0
		if simDR_aft_service_status > 0.01 then
		aft_service = 1
		end	

	local fwd_cargo = 0
		if simDR_fwd_cargo_status > 0.01 then
		fwd_cargo = 1
		end
		
	local aft_cargo = 0
		if simDR_aft_cargo_status > 0.01 then
		aft_cargo = 1
		end	

	local left_fwd_overwing = 0
		if simDR_left_fwd_overwing_status > 0.01 then
		left_fwd_overwing = 1
		end
		
	local left_aft_overwing = 0
		if simDR_left_aft_overwing_status > 0.01 then
		left_aft_overwing = 1
		end

	local right_fwd_overwing = 0
		if simDR_right_fwd_overwing_status > 0.01 then
		right_fwd_overwing = 1
		end
		
	local right_aft_overwing = 0
		if simDR_right_aft_overwing_status > 0.01 then
		right_aft_overwing = 1
		end

	local equipment = 0
		if simDR_equipment_status > 0.01 then
		equipment = 1
		end

	B738DR_fwd_entry = fwd_entry * brightness_level
	B738DR_aft_entry = aft_entry * brightness_level
	B738DR_fwd_service = fwd_service * brightness_level
	B738DR_aft_service = aft_service * brightness_level
	B738DR_fwd_cargo = fwd_cargo * brightness_level
	B738DR_aft_cargo = aft_cargo * brightness_level
	B738DR_left_fwd_overwing = left_fwd_overwing * brightness_level
	B738DR_left_aft_overwing = left_aft_overwing * brightness_level
	B738DR_right_fwd_overwing = right_fwd_overwing * brightness_level
	B738DR_right_aft_overwing = right_aft_overwing * brightness_level

	B738DR_equip_door = equipment * brightness_level

-- YAW DAMPER

	local yaw_damper_off = 1
	if simDR_yaw_damper_annun == 1 then
	yaw_damper_off = 0
	end

	B738DR_yaw_damper = yaw_damper_off * brightness_level

-- FDR OFF

	local fdr_off = 0
		
		if B738DR_fdr_pos == 1 then
			-- if is_timer_scheduled(fdr_test_timer) == false and fdr_test == 0 then
				fdr_test = 1
				-- run_after_time(fdr_test_timer, 10)
			-- end
		else
			-- if is_timer_scheduled(fdr_test_timer) == true then
				-- stop_timer(fdr_test_timer)
			-- end
			fdr_test = 0
		end
		
		if simDR_aircraft_on_ground == 1 and simDR_N2_eng1_percent < 50 and simDR_N2_eng2_percent < 50 then
			fdr_off = 1
		
		elseif simDR_aircraft_on_ground == 1 and simDR_bus_amps1 < 0.3 then
			fdr_off = 1
		
		elseif simDR_aircraft_on_ground == 0 and simDR_bus_amps1 < 0.3 then
			fdr_off = 1
		end
		
		-- test running
		if simDR_aircraft_on_ground == 1 and fdr_test == 1 then
			fdr_off = 0
		end
		
		
	B738DR_fdr_off = fdr_off * brightness_level


-- AP DISCONNECT


	local ap_disconnect1_test = 0
		if B738DR_ap_disconnect1_test_switch_pos == 1
		or B738DR_ap_disconnect1_test_switch_pos == -1
		then
		ap_disconnect1_test = 1
	end

	local ap_disconnect2_test = 0	
		if B738DR_ap_disconnect2_test_switch_pos == 1
		or B738DR_ap_disconnect2_test_switch_pos == -1
		then
		ap_disconnect2_test = 1
	end

	local ap_discon_annun1 = 0
		if ap_disconnect1_test == 1
		or B738DR_ap_disconnect == 1
		then
		ap_discon_annun1 = 1
	end

	local ap_discon_annun2 = 0
		if ap_disconnect2_test == 1
		or B738DR_ap_disconnect == 1
		then
		ap_discon_annun2 = 1
	end
	
	local at_discon_annun1 = 0
		if ap_disconnect1_test == 1
		or B738DR_at_disconnect == 1
		then
		at_discon_annun1 = 1
	end

	local at_discon_annun2 = 0
		if ap_disconnect2_test == 1
		or B738DR_at_disconnect == 1
		then
		at_discon_annun2 = 1
	end

	local at_fms_discon_annun1 = 0
		if ap_disconnect1_test == 1
		then
		at_fms_discon_annun1 = 1
	end

	local at_fms_discon_annun2 = 0
		if ap_disconnect2_test == 1
		then
		at_fms_discon_annun2 = 1
	end
	
	if B738DR_fmc_message_warn == 1 then
		at_fms_discon_annun1 = 1
		at_fms_discon_annun2 = 1
	end

	B738DR_ap_disconnect1_annun = ap_discon_annun1 * brightness_level
	B738DR_ap_disconnect2_annun = ap_discon_annun2 * brightness_level	
	B738DR_at_fms_disconnect1_annun = at_fms_discon_annun1 * brightness_level
	B738DR_at_fms_disconnect2_annun = at_fms_discon_annun2 * brightness_level
	
	B738DR_at_disconnect1_annun = at_discon_annun1 * brightness_level
	B738DR_at_disconnect2_annun = at_discon_annun2 * brightness_level

--	B738DR_at_fms_disconnect1_annun = ap_disconnect1_test * brightness_level
--	B738DR_at_fms_disconnect2_annun = ap_disconnect2_test * brightness_level


----------- FIRE PANEL -----------------------------------------------------


----- FIRE HANDLES -----

	if simDR_eng1_fire ~= eng1_fire_old then
		if B738DR_fire_bell_annun == 0 and simDR_eng1_fire == 6 then
			fire_bell_annun_reset = 1
		end
	end
	if simDR_eng2_fire ~= eng2_fire_old then
		if B738DR_fire_bell_annun == 0 and simDR_eng2_fire == 6 then
			fire_bell_annun_reset = 1
		end
	end
	eng1_fire_old = simDR_eng1_fire
	eng2_fire_old = simDR_eng2_fire
	
	eng1_fire_annun = 0
		--if simDR_engine1_fire == 1 
		if simDR_eng1_fire == 6 then
		--or B738DR_fire_test_switch_pos == 1 then
		eng1_fire_annun = 1
		end
	
	eng2_fire_annun = 0
		--if simDR_engine2_fire == 1
		if simDR_eng2_fire == 6 then
		--or B738DR_fire_test_switch_pos == 1 then
		eng2_fire_annun = 1
		end	

	eng1_ovht = 0
		if simDR_engine1_egt > 950 then
		--or B738DR_fire_test_switch_pos == 1 then
		eng1_ovht = 1
		end

	eng2_ovht = 0
		if simDR_engine2_egt > 950 then
		--or B738DR_fire_test_switch_pos == 1 then
		eng2_ovht = 1
		end

	-- FIRE BELL LOGIC

	fire_bell_annun = 0
	local apu_fire_annun = 0
	local wheel_well_fire = 0
	if eng1_fire_annun == 1
		or eng2_fire_annun == 1
		--or cargo_fire_annuns == 1
		or cargo_fire_test == 1
		or B738DR_fire_test_switch_pos == 1 then
		--or fire_panel_annuns_test == 1 then
		fire_bell_annun = 1
	end
	
	if B738DR_fire_test_switch_pos == 1 then
		wheel_well_fire = 1
	end

	-- if fire_panel_annuns_test == 1
	-- then
	--if B738DR_fire_test_switch_pos == 1 then
	if fire_panel_annuns_test == 1 then
		apu_fire_annun = 1
		eng1_fire_annun = 1
		eng2_fire_annun = 1
		--wheel_well_fire = 1
		eng1_ovht = 1
		eng2_ovht = 1
	end
	
	local cargo_fire_annuns = 0
	local extinguisher_circuit_annun2 = 0
	if B738DR_cargo_fire_test_button_pos == 1 then
		--cargo_fire_annuns = 1
		extinguisher_circuit_annun2 = 1
	end
	if cargo_fire_test == 1 then
		cargo_fire_annuns = 1
	end

	local l_bottle_discharge = 0
		if B738DR_l_bottle_psi == 0 then
		l_bottle_discharge = 1
		end
	
	local r_bottle_discharge = 0
		if B738DR_r_bottle_psi == 0 then
		r_bottle_discharge = 1
		end

	local apu_bottle_discharge = 0
		if B738DR_apu_bottle_psi == 0 then
		apu_bottle_discharge = 1
		end

-- FIRE ANNUNS

	B738DR_apu_fire = apu_fire_annun * brightness_level2
	B738DR_engine1_fire = eng1_fire_annun * brightness_level2
	B738DR_engine2_fire = eng2_fire_annun * brightness_level2
	B738DR_wheel_well_fire = wheel_well_fire * brightness_level
	B738DR_engine1_ovht	= eng1_ovht * brightness_level
	B738DR_engine2_ovht	= eng2_ovht * brightness_level	

	B738DR_l_bottle_discharge = l_bottle_discharge * brightness_level
	B738DR_r_bottle_discharge = r_bottle_discharge * brightness_level
	B738DR_apu_bottle_discharge = apu_bottle_discharge * brightness_level





----- TEST SWITCHES -----

	-- local exting_circ_test = 0									-- EXTINGUISHER CIRCUIT TEST 1
	-- if B738DR_extinguisher_circuit_test_pos == 1
		-- or B738DR_extinguisher_circuit_test_pos == -1 then
		-- exting_circ_test = 1
		-- end
	
	-- if B738DR_extinguisher_circuit_test_pos == 0 then
		-- exting_circ_test = 0
		-- end

	local exting_circ_test_left = 0									-- EXTINGUISHER CIRCUIT TEST 1
	if B738DR_extinguisher_circuit_test_pos == 1
		or B738DR_extinguisher_circuit_test_pos == -1 then
		exting_circ_test_left = 1
		end
	
	if B738DR_extinguisher_circuit_test_pos == 0 then
		exting_circ_test_left = 0
		end
		
	if B738DR_fire_ext_bottle_0102L_psi < 599.9 then
		exting_circ_test_left = 1
	end
	
	local exting_circ_test_right = 0									-- EXTINGUISHER CIRCUIT TEST 1
	if B738DR_extinguisher_circuit_test_pos == 1
		or B738DR_extinguisher_circuit_test_pos == -1 then
		exting_circ_test_right = 1
		end
	
	if B738DR_extinguisher_circuit_test_pos == 0 then
		exting_circ_test_right = 0
		end
		
	if B738DR_fire_ext_bottle_0102R_psi < 599.9 then
		exting_circ_test_right = 1
	end
	
	local exting_circ_test_apu = 0									-- EXTINGUISHER CIRCUIT TEST 1
	if B738DR_extinguisher_circuit_test_pos == 1
		or B738DR_extinguisher_circuit_test_pos == -1 then
		exting_circ_test_apu = 1
		end
	
	if B738DR_extinguisher_circuit_test_pos == 0 then
		exting_circ_test_apu = 0
		end
	
	if B738DR_fire_ext_bottle_apu_psi < 599.9 then
		exting_circ_test_apu = 1
	end
	
	--B738DR_extinguisher_circuit_annun1 = exting_circ_test * brightness_level
	B738DR_extinguisher_circuit_annun_left = exting_circ_test_left * brightness_level
	B738DR_extinguisher_circuit_annun_right = exting_circ_test_right * brightness_level
	B738DR_extinguisher_circuit_annun_apu =  exting_circ_test_apu * brightness_level

-- CARGO FIRE ANNUNS

	B738DR_extinguisher_circuit_annun2 = extinguisher_circuit_annun2 * brightness_level
	B738DR_cargo_fire_annuns = cargo_fire_annuns * brightness_level	
	
	fire_fault_inop_annun = 0									-- CARGO FIRE TEST BUTTON
	if B738DR_fire_test_switch_pos == -1 then
	fire_fault_inop_annun = 1
	end
	
	B738DR_fire_fault_inop_annun = fire_fault_inop_annun * brightness_level
	
	B738DR_cargo_fault_detector_annun = 0

-- FIRE BELL ANNUNCIATOR

	B738DR_fire_bell_annun = fire_bell_annun * fire_bell_annun_reset * brightness_level2

	-- if B738DR_fire_bell_annun ~= fire_bell_annun_old and B738DR_fire_bell_annun == 1 then
		-- ovht_det_six_pack_old = 0
	-- end
	-- fire_bell_annun_old = B738DR_fire_bell_annun
	
-- MASTER CAUTION SIX PACK PILOT

-- FLT CONTROLS

	local flt_cont = 0
		if yaw_damper_off == 1
		or simDR_elec_trim_off == 1 then
		flt_cont = 1
		end
	
	--B738DR_six_pack_flt_cont = flt_cont * brightness_level

-- IRS

	local irs_fail = 0
		if simDR_gps_fail == 6 or simDR_gps2_fail == 6 then
		irs_fail = 1
		end
		if B738DR_irs_left_fail == 1 or B738DR_irs_right_fail == 1 then
		irs_fail = 1
		end
		
	--B738DR_six_pack_irs	= irs_fail * brightness_level
	

-- FUEL

	local fuel_six_pack = 0
		if simDR_low_fuel == 1
		or simDR_low_fuel_press1 == 1
		or simDR_low_fuel_press2 == 1 
		or six_fuel_center == 1 then
		fuel_six_pack = 1
		end
		if simDR_low_fuel == 0
		and simDR_low_fuel_press1 == 0
		and simDR_low_fuel_press2 == 1 then
		fuel_six_pack = 1
		end
	--B738DR_six_pack_fuel = fuel_six_pack * brightness_level

-- ELEC

	local elec_fail = 0
		if B738DR_source_off_bus1 > 0.1
		or B738DR_source_off_bus2 > 0.1
		or B738DR_transfer_bus_off1 > 0.1
		or B738DR_transfer_bus_off2 > 0.1
		or B738DR_battery_disch_annun > 0.1
		or B738DR_drive1_annun > 0.1
		or B738DR_drive2_annun > 0.1 then
		elec_fail = 1
		end
	
	--B738DR_six_pack_elec = elec_fail * brightness_level
	

-- APU

	local apu_six_pack = 0
		if simDR_apu_fault > 0 then
		apu_six_pack = 1
		end
		
	--B738DR_six_pack_apu = apu_six_pack * brightness_level

-- SIX PACK ANNUN

	ovht_det_six_pack = 0
	if eng1_fire_annun == 1
		or eng2_fire_annun == 1
		or eng1_ovht == 1
		or eng2_ovht == 1
		--or cargo_fire_annuns == 1
		or B738DR_cargo_fire_test_button_pos == 1 
		or B738DR_fire_test_switch_pos == 1 then
		--or fire_panel_annuns_test == 1 then
		ovht_det_six_pack = 1
	end
	
	B738DR_six_pack_fire = ovht_det_six_pack * brightness_level


-- GPS
	
	local gps_fail = 0
		if simDR_gps_fail == 6 or simDR_gps2_fail == 6 then
		gps_fail = 1
		end
	if B738DR_lights_test == 1 then
		gps_fail = 1
	end
		
	B738DR_gps_fail	= gps_fail * brightness_level
	

	
-- ICE

	local six_pack_ice_status = 0
		-- if simDR_general_ice_detect == 1
		-- then six_pack_ice_status = 1
		-- end
	
		-- if simDR_cowl_ice_detect_0 > 0.95 or simDR_cowl_ice_detect_1 > 0.95 then
			-- six_pack_ice_status = 1
		-- end
		-- if simDR_wing_ice_detect_L > 0.95 or simDR_wing_ice_detect_R > 0.95 then
			-- six_pack_ice_status = 1
		-- end
		if simDR_ice_fail_eng1 == 6 or simDR_ice_fail_eng2 == 6 then
			six_pack_ice_status = 1
		end
		if simDR_ice_fail_wingL == 6 or simDR_ice_fail_wingR == 6 then
			six_pack_ice_status = 1
		end
		
		if capt_pitot_status_cur == 1 or capt_aoa_status_cur == 1
		or fo_pitot_status_cur == 1 or fo_aoa_status_cur == 1 then
			six_pack_ice_status = 1
		end
	--B738DR_six_pack_ice = six_pack_ice_status * brightness_level
	

-- HYDRAULICS

	local six_pack_hydro = 0
		--if simDR_hyd_press_a < 1900			--1300
		--or simDR_hyd_press_b < 1900 then	--1300 then
		if B738DR_hyd_A_status == 0 or B738DR_hyd_B_status == 0 then
		six_pack_hydro = 1
		end
	
	--B738DR_six_pack_hyd = six_pack_hydro * brightness_level
	

-- DOORS

	local door_open_status = 0
		if fwd_entry == 1
		or aft_entry == 1
		or fwd_service == 1
		or aft_service == 1
		or fwd_cargo == 1
		or aft_cargo == 1
		or left_fwd_overwing == 1
		or left_aft_overwing == 1
		or right_fwd_overwing == 1
		or right_aft_overwing == 1
		or equipment == 1 then
		door_open_status = 1
		end

	--B738DR_six_pack_doors = door_open_status * brightness_level

-- ENGINES

	local six_pack_eng = 0
		if simDR_fadec_fail_0 == 6
		or simDR_fadec_fail_1 == 6
		or simDR_chip_detect1 == 1
		or simDR_chip_detect2 == 1
		or simDR_reverser_fail_0 == 6
		or simDR_reverser_fail_1 == 6 then
		six_pack_eng = 1
		end

	--B738DR_six_pack_eng = six_pack_eng * brightness_level

-- OVERHEAD

	local six_pack_ovhd = 0
		if simDR_pax_oxy_status == 6
		or fdr_off == 1
		or simDR_smoke == 6 then
		six_pack_ovhd = 1
		end
	
	--B738DR_six_pack_overhead = six_pack_ovhd * brightness_level

-- AIR COND

	local dual_bleed = 0
		if B738DR_dual_bleed > 0 then
		dual_bleed = 1
		end

	local six_pack_air_cond = 0
		if simDR_wing_body_ovht_annun == 1
		or dual_bleed == 1
		or simDR_bleed_trip_off1_annun == 1
		or simDR_bleed_trip_off2_annun == 1
		or simDR_pack_annun == 6 then
		six_pack_air_cond = 1
		end
	
	--B738DR_six_pack_air_cond = six_pack_air_cond * brightness_level
	
	
	-- SIX PACK LOGIC
	-- if B738DR_master_caution_pos1 == 1 then
		-- fuel_six_pack_ann = 0
		-- apu_six_pack_ann = 0
		-- ovht_det_six_pack_ann = 0
		-- irs_fail_ann = 0
		-- elec_fail_ann = 0
		-- flt_cont_ann = 0
	-- end
	
	if fuel_six_pack ~= fuel_six_pack_old then
		if fuel_six_pack == 1 then
			fuel_six_pack_ann = 1
		else
			fuel_six_pack_ann = 0
		end
	end
	if apu_six_pack ~= apu_six_pack_old then
		if apu_six_pack == 1 then
			apu_six_pack_ann = 1
		else
			apu_six_pack_ann = 0
		end
	end
	if ovht_det_six_pack ~= ovht_det_six_pack_old then
		if ovht_det_six_pack == 1 then
			ovht_det_six_pack_ann = 1
		else
			ovht_det_six_pack_ann = 0
		end
	end
	if irs_fail ~= irs_fail_old then
		if irs_fail == 1 then
			irs_fail_ann = 1
		else
			irs_fail_ann = 0
		end
	end
	if elec_fail ~= elec_fail_old then
		if elec_fail == 1 then
			elec_fail_ann = 1
		else
			elec_fail_ann = 0
		end
	end
	if flt_cont ~= flt_cont_old then
		if flt_cont == 1 then
			flt_cont_ann = 1
		else
			flt_cont_ann = 0
		end
	end
	
	fuel_six_pack_old = fuel_six_pack
	apu_six_pack_old = apu_six_pack
	ovht_det_six_pack_old = ovht_det_six_pack
	irs_fail_old = irs_fail
	elec_fail_old = elec_fail
	flt_cont_old = flt_cont
	
	if six_pack_ice_status ~= six_pack_ice_status_old then
		if six_pack_ice_status == 1 then
			six_pack_ice_status_ann = 1
		else
			six_pack_ice_status_ann = 0
		end
	end
	if six_pack_hydro ~= six_pack_hydro_old then
		if six_pack_hydro == 1 then
			six_pack_hydro_ann = 1
		else
			six_pack_hydro_ann = 0
		end
	end
	if door_open_status ~= door_open_status_old then
		if door_open_status == 1 then
			door_open_status_ann = 1
		else
			door_open_status_ann = 0
		end
	end
	if six_pack_eng ~= six_pack_eng_old then
		if six_pack_eng == 1 then
			six_pack_eng_ann = 1
		else
			six_pack_eng_ann = 0
		end
	end
	if six_pack_ovhd ~= six_pack_ovhd_old then
		if six_pack_ovhd == 1 then
			six_pack_ovhd_ann = 1
		else
			six_pack_ovhd_ann = 0
		end
	end
	if six_pack_air_cond ~= six_pack_air_cond_old then
		if six_pack_air_cond == 1 then
			six_pack_air_cond_ann = 1
		else
			six_pack_air_cond_ann = 0
		end
	end
	
	six_pack_ice_status_old = six_pack_ice_status
	six_pack_hydro_old = six_pack_hydro
	door_open_status_old = door_open_status
	six_pack_eng_old = six_pack_eng
	six_pack_ovhd_old = six_pack_ovhd
	six_pack_air_cond_old = six_pack_air_cond
	
	if B738DR_capt_6_pack_pos == 1 or B738DR_fo_6_pack_pos == 1 then
		B738DR_six_pack_fuel = 1 * brightness_level
		B738DR_six_pack_apu = 1 * brightness_level
		B738DR_six_pack_fire = 1 * brightness_level
		B738DR_six_pack_irs	= 1 * brightness_level
		B738DR_six_pack_elec = 1 * brightness_level
		B738DR_six_pack_flt_cont = 1 * brightness_level
		---
		B738DR_six_pack_ice = 1 * brightness_level
		B738DR_six_pack_hyd = 1 * brightness_level
		B738DR_six_pack_doors = 1 * brightness_level
		B738DR_six_pack_eng = 1 * brightness_level
		B738DR_six_pack_overhead = 1 * brightness_level
		B738DR_six_pack_air_cond = 1 * brightness_level
	else
		B738DR_six_pack_fuel = fuel_six_pack_ann * brightness_level
		B738DR_six_pack_apu = apu_six_pack_ann * brightness_level
		B738DR_six_pack_fire = ovht_det_six_pack_ann * brightness_level
		B738DR_six_pack_irs	= irs_fail_ann * brightness_level
		B738DR_six_pack_elec = elec_fail_ann * brightness_level
		B738DR_six_pack_flt_cont = flt_cont_ann * brightness_level
		---
		B738DR_six_pack_ice = six_pack_ice_status_ann * brightness_level
		B738DR_six_pack_hyd = six_pack_hydro_ann * brightness_level
		B738DR_six_pack_doors = door_open_status_ann * brightness_level
		B738DR_six_pack_eng = six_pack_eng_ann * brightness_level
		B738DR_six_pack_overhead = six_pack_ovhd_ann * brightness_level
		B738DR_six_pack_air_cond = six_pack_air_cond_ann * brightness_level
	end

	-- if B738DR_fo_6_pack_pos == 1 then
		-- B738DR_six_pack_fuel = 1 * brightness_level
		-- B738DR_six_pack_apu = 1 * brightness_level
		-- B738DR_six_pack_fire = 1 * brightness_level
		-- B738DR_six_pack_irs	= 1 * brightness_level
		-- B738DR_six_pack_elec = 1 * brightness_level
		-- B738DR_six_pack_flt_cont = 1 * brightness_level
		-- ---
		-- B738DR_six_pack_ice = 1 * brightness_level
		-- B738DR_six_pack_hyd = 1 * brightness_level
		-- B738DR_six_pack_doors = 1 * brightness_level
		-- B738DR_six_pack_eng = 1 * brightness_level
		-- B738DR_six_pack_overhead = 1 * brightness_level
		-- B738DR_six_pack_air_cond = 1 * brightness_level
	-- else
		-- B738DR_six_pack_fuel = fuel_six_pack_ann * brightness_level
		-- B738DR_six_pack_apu = apu_six_pack_ann * brightness_level
		-- B738DR_six_pack_fire = ovht_det_six_pack_ann * brightness_level
		-- B738DR_six_pack_irs	= irs_fail_ann * brightness_level
		-- B738DR_six_pack_elec = elec_fail_ann * brightness_level
		-- B738DR_six_pack_flt_cont = flt_cont_ann * brightness_level
		-- ---
		-- B738DR_six_pack_ice = six_pack_ice_status_ann * brightness_level
		-- B738DR_six_pack_hyd = six_pack_hydro_ann * brightness_level
		-- B738DR_six_pack_doors = door_open_status_ann * brightness_level
		-- B738DR_six_pack_eng = six_pack_eng_ann * brightness_level
		-- B738DR_six_pack_overhead = six_pack_ovhd_ann * brightness_level
		-- B738DR_six_pack_air_cond = six_pack_air_cond_ann * brightness_level
	-- end

----- END MASTER CAUTION / SIX PACK ANNUNS ----------------------------------------

	if B738DR_fire_bell_annun ~= fire_bell_annun_old and B738DR_fire_bell_annun == 1 then
		ovht_det_six_pack_old = 0
	end
	fire_bell_annun_old = B738DR_fire_bell_annun

---- MASTER CAUTION ----------------------------------------------------------------------

	local master_caution_light = 0
		
		if fuel_six_pack_ann == 1
		or apu_six_pack_ann == 1
		or ovht_det_six_pack_ann == 1
		or irs_fail_ann == 1
		or elec_fail_ann == 1
		or flt_cont_ann == 1
		or six_pack_ice_status_ann == 1
		or six_pack_hydro_ann == 1
		or door_open_status_ann == 1
		or six_pack_eng_ann == 1
		or six_pack_ovhd_ann == 1
		or six_pack_air_cond_ann == 1 
		or B738DR_capt_6_pack_pos == 1 
		or B738DR_fo_6_pack_pos == 1 then
			master_caution_light = 1
		end
		
		-- if fire_panel_annuns_test == 1
		-- or cargo_fire_annuns == 1
		-- or simDR_waster_caution_light == 1 then
			-- master_caution_light = 1
		-- end
		
		-- if simDR_waster_caution_light == 1 then
			-- master_caution_light = 1
		-- end
	
	
	B738DR_master_caution_light = master_caution_light * brightness_level2
 
	
----- STANDBY HYDRAULIC

	local hyd_A_low_press = 0
	if B738DR_flt_ctr_A_pos >= 0 then
		if B738DR_hyd_A_status == 0 then
			hyd_A_low_press = 1
		end
	end

	local hyd_B_low_press = 0
	if B738DR_flt_ctr_B_pos >= 0 then
		if B738DR_hyd_B_status == 0 then
			hyd_B_low_press = 1
		end
	end
	

	local hyd_stdby_low_press = 0
	if B738DR_flt_ctr_A_pos == -1 then
		if B738DR_hyd_stdby_status == 0 then
			hyd_stdby_low_press = 1
		end
	end
	if B738DR_flt_ctr_B_pos == -1 then
		if B738DR_hyd_stdby_status == 0 then
			hyd_stdby_low_press = 1
		end
	end

	local stndby_rud_on = 0
	if B738DR_flt_ctr_A_pos == -1 or B738DR_flt_ctr_B_pos == -1 then
		stndby_rud_on = 1
	end
	
	B738DR_hyd_A_rud_annun = hyd_A_low_press * brightness_level
	B738DR_hyd_B_rud_annun = hyd_B_low_press * brightness_level
	B738DR_hyd_stdby_annun = hyd_stdby_low_press * brightness_level
	B738DR_std_rud_on_annun = stndby_rud_on * brightness_level

----- BELOW GS --------------------------------------------------------------------

	local on_the_ground = 0
	if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1 or simDR_on_ground_2 == 1 then
		on_the_ground = 1
	end
	
	local below_gs = 0
		
		--below_gs = B738DR_glide_slope
		below_gs = B738DR_glide_slope_annun
		--B738DR_below_gs_warn = below_gs
		
		if B738DR_below_gs_pilot == 1 then
			below_gs = 1
		end
		if B738DR_below_gs_copilot == 1 then
			below_gs = 1
		end
		
	B738DR_below_gs = below_gs * brightness_level


-- SLATS


	local slats_extended = 0
		if simDR_slat_1_deploy == 1
		and simDR_slat_2_deploy == 0.5 then
		slats_extended = 1
		elseif
		simDR_slat_1_deploy == 1
		and simDR_slat_2_deploy == 1 then
		slats_extended = 1
		end
	
	local slats_transit = 0
		if simDR_slat_1_deploy ~= 1
		and simDR_slat_1_deploy ~= 0 then
		slats_transit = 1
		elseif simDR_slat_2_deploy ~= 1
		and simDR_slat_2_deploy ~= 0.5
		and	simDR_slat_2_deploy ~= 0 then
		slats_transit = 1
		end
	
	B738DR_slats_extended = slats_extended * brightness_level
	B738DR_slats_transit = slats_transit * brightness_level	

-- TAKEOFF CONFIG

--[[  WE WANT TO NORMALIZE EVERY VARIABLE SO TRIGGER CONDITIONS ARE TURNED TO 0, SAFE CONDITIONS ARE 1

		simDR_aircraft_on_ground
		simDR_throttle_ratio
		simDR_elevator_trim
		simDR_parking_brake
		simDR_speedbrake_status
		simDR_flap_ratio
		simDR_reverse_thrust
		simDR_reverse_thrust1		
		simDR_reverse_thrust2		
]]--		

local takeoff_config_warn = 0

	local throttle_50 = 0
	if B738DR_thrust1_leveler > 0.5 or B738DR_thrust2_leveler > 0.5 then
		throttle_50 = 1
	end
	
	local elev_trim_safe = 1
		if simDR_elevator_trim > 0.075
		or simDR_elevator_trim < -0.65 then
		elev_trim_safe = 0
		end

	local park_brake_safe = 0
		if simDR_parking_brake <= 0.5 then
		park_brake_safe = 1
		end

	local speedbrake_safe = 0
		if simDR_speedbrake_status == 0 then
		speedbrake_safe = 1
		end
		
	local flap_safe = 1
		if simDR_flap_ratio < 0.125
		or simDR_flap_ratio > 0.75 then
		flap_safe = 0
		end

	local is_reverse = 0
		if simDR_reverse_thrust1 == 3
		or simDR_reverse_thrust2 == 3 then
		is_reverse = 1
		end

	local takeoff_config_safe = park_brake_safe * speedbrake_safe * flap_safe * elev_trim_safe
	
	if takeoff_config_safe == 0
		and throttle_50 == 1
		and on_the_ground == 1 then
		takeoff_config_warn = 1
		end
		
	if takeoff_config_safe == 1 then
		takeoff_config_warn = 0
		end

	if is_reverse == 1 then
	takeoff_config_warn = 0
	end

	B738DR_takeoff_config_annun = takeoff_config_warn * brightness_level
	B738DR_takeoff_config_warn = takeoff_config_warn

-- GPWS

	local gpws_annun = 0
	if B738DR_gpws_test_running == 1 then
		gpws_annun = 1
	end
	
	--B738DR_GPWS_annun = simDR_GPWS * brightness_level
	B738DR_GPWS_annun = gpws_annun * brightness_level

-- SPEEDBRAKE ANNUNS

	local spdbrk_armed = 0
		if simDR_speedbrake_status == -0.5 then
		spdbrk_armed = 1
		end
		
	B738DR_speedbrake_armed = spdbrk_armed * brightness_level

	local spdbrk_extend = 0
	if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1 or simDR_on_ground_2 == 1 then
		if simDR_speedbrake_status > 0 then
			spdbrk_extend = 1
		end
	else
		if simDR_flaps_ratio_physics > 0.5 or simDR_radio_height_pilot_ft < 800 then
			if simDR_speedbrake_status > 0 then
				spdbrk_extend = 1
			end
		end
	end

	B738DR_speedbrake_extend = spdbrk_extend * brightness_level

-- CABIN ALT

	local cabin_alt_warn = 0
		--if simDR_cabin_alt > 10000 then
		if B738DR_cabin_alt > 10000 then
		cabin_alt_warn = 1
		end
		
	B738DR_cabin_alt_annun = cabin_alt_warn * brightness_level

-- EMER EXIT NOT ARMED ANNUN

	local emer_exit_not_armed = 0
		if B738DR_emer_exit_lights_switch == 0 then
		emer_exit_not_armed = 1
		elseif B738DR_emer_exit_lights_switch == 2 then
		emer_exit_not_armed = 1
		end
	
	B738DR_emer_exit_annun = emer_exit_not_armed * brightness_level

-- FUEL CROSSFEED ANNUN

	local tank_select_status = 0
		-- if simDR_tank_selection == 4 then
		-- tank_select_status = 1
		-- end
		if B738DR_cross_feed_valve == 1 then
			tank_select_status = 0.5
		elseif B738DR_cross_feed_valve > 0.01 then
			tank_select_status = 1
		end

	B738DR_crossfeed = tank_select_status * brightness_level

-- GENERIC ANNUNCIATOR ---- FOR THOSE THAT WONT BE CODED

	B738DR_generic_annun = brightness_level * B738DR_lights_test
	
-- IRS SYSTEM

	-- local irs_on_dc_right = 0
	-- if B738DR_irs_on_dc_right == 1 then
		-- irs_on_dc_right = 1
	-- end
	-- local irs_on_dc_left = 0
	-- if B738DR_irs_on_dc_left == 1 then
		-- irs_on_dc_left = 1
	-- end

		local light_test = 0
		if B738DR_lights_test == 1 then
			light_test = 1
		end
	
	-- B738DR_irs_align_fail_right = brightness_level * B738DR_lights_test
	-- B738DR_irs_align_fail_left = brightness_level * B738DR_lights_test
	-- B738DR_irs_align_right = brightness_level * B738DR_lights_test
	-- B738DR_irs_align_left = brightness_level * B738DR_lights_test
	-- B738DR_irs_dc_fail_left = brightness_level * B738DR_lights_test
	-- B738DR_irs_on_dc_left = brightness_level * irs_on_dc_left
	-- B738DR_irs_dc_fail_right = brightness_level * B738DR_lights_test
	-- B738DR_irs_on_dc_right = brightness_level * irs_on_dc_right
	

-- ELT

	local elt_annun = 0
		if B738DR_elt_switch_pos == 1 then
		elt_annun = 1
		end
		
		if simDR_axial_g_load > 2.5 then
		B738CMD_elt_pos_on:once()
		end
		
	B738DR_elt_annun = elt_annun * brightness_level


-- EXTERNAL POWER

	local ext_power_annun = 0
		-- if simDR_aircraft_on_ground == 1
		-- and simDR_aircraft_groundspeed < 0.05 
		-- and simDR_parking_brake == 1 then
		--if B738DR_gpu_available == 1 and simDR_ext_pwr_1_on == 0 then
		
		
		-- if B738DR_gpu_available == 1 then
			-- if simDR_ext_pwr_1_on == 0 then
				-- ext_power_annun = 1
			-- else
				-- ext_power_annun = 0.5
			-- end
		-- end
		
		-- if brightness_level < 0.5 then
			-- B738DR_ground_power_avail_annun = ext_power_annun
		-- else
			-- B738DR_ground_power_avail_annun = ext_power_annun * brightness_level
		-- end
		
		if B738DR_gpu_available == 1 then
			ext_power_annun = 1
		end
		B738DR_ground_power_avail_annun = ext_power_annun

-- TRANSFER BUS ANNUN

	local trans_bus1 = 0
		if simDR_bus_amps1 < 0.3 then
		trans_bus1 = 1
		end
		
	local trans_bus2 = 0
		if simDR_bus_amps2 < 0.3 then
		trans_bus2 = 1
		end
		
	B738DR_transfer_bus_off1 = trans_bus1 * brightness_level
	B738DR_transfer_bus_off2 = trans_bus2 * brightness_level


-- APU GEN OFF BUS

	local apu_gen_off_bus = 0
		--if simDR_apu_status > 95 then
		--if B738DR_apu_temp > 95 then
		--if simDR_apu_status > 95 and B738DR_apu_temp > 51 then
		if B738DR_apu_bus_enable == 1 then
			apu_gen_off_bus = 1
		end
		
		if simDR_apu_gen_amps > 0 then
		apu_gen_off_bus = 0
		end
		

	B738DR_apu_gen_off_bus = apu_gen_off_bus * brightness_level

-- GENS OFF BUS

	-- B738DR_gen_off_bus1 = B738DR_gen1_available * brightness_level
	-- B738DR_gen_off_bus2 = B738DR_gen2_available * brightness_level
	B738DR_gen_off_bus1 = B738DR_gen1_available * simDR_gen_off_bus1 * simDR_engine1_on * brightness_level
	B738DR_gen_off_bus2 = B738DR_gen2_available * simDR_gen_off_bus2 * simDR_engine2_on * brightness_level

-- SOURCE OFF

	local apu_gen1_off = 0
	local apu_gen2_off = 0
		if simDR_apu_gen_amps < 1 then
		apu_gen1_off = 1
		apu_gen2_off = 1
		end
		if simDR_apu_power_bus1 == 0 then
			apu_gen1_off = 1
		end
		if simDR_apu_power_bus2 == 0 then
			apu_gen2_off = 1
		end
	
	local gpu_off = 0
		if simDR_gpu_amps < 1 then
		gpu_off = 1
		end
	
	local bus1_off = 1
	local bus2_off = 1
		-- if simDR_apu_status > 95 then
			-- if B738DR_apu_gen1_pos == 1 then
				-- bus1_off = 0
			-- end
			-- if B738DR_apu_gen2_pos == 1 then
				-- bus2_off = 0
			-- end
			-- TO DO by APU GEN on/off
			-- if simDR_apu_gen_amps > 0 then
				-- bus1_off = 0
				-- bus2_off = 0
			-- end
		-- end
		if simDR_engine1_on == 1 and simDR_gen1_on == 1 then
			bus1_off = 0
		end
		if simDR_engine2_on == 1 and simDR_gen2_on == 1 then
			bus2_off = 0
		end
		
		-- B738DR_source_off_bus1 = bus1_off * gpu_off * brightness_level
		-- B738DR_source_off_bus2 = bus2_off * brightness_level
		
		B738DR_source_off_bus1 = apu_gen1_off * simDR_gen_off_bus1 * gpu_off * brightness_level
		B738DR_source_off_bus2 = apu_gen2_off * simDR_gen_off_bus2 * gpu_off * brightness_level


-- SMOKE

	local smoke_status = 0
		if simDR_smoke >= 1 then
		smoke_status = 1
		end
		
	B738DR_smoke = smoke_status * brightness_level


-- PACKS

	local l_pack_status = 0
		if simDR_pack_annun == 6 or B738DR_ac_tnsbus2_status == 0 then
			l_pack_status = 1
		end
		
	B738DR_packs_left_annun = l_pack_status * brightness_level
	
	local r_pack_status = 0
		if simDR_pack_annun == 6 or B738DR_ac_tnsbus1_status == 0 then
			r_pack_status = 1
		end
	
	B738DR_packs_right_annun = r_pack_status * brightness_level
	
	--B738DR_packs_annun = pack_status * brightness_level


-- HYD PRESSURE

	-- hydro pumps
	local hyd_press_a = 0
	local hyd_press_a_trg = 0
		if simDR_engine1_on == 0
		or B738DR_hydro_pumps1_switch_position == 0 
		or B738DR_engine01_fire_ext_switch_pos_arm == 1 then
			hyd_press_a_trg = 1
		end

	local hyd_press_b = 0
	local hyd_press_b_trg = 0
		if simDR_engine2_on == 0
		or B738DR_hydro_pumps2_switch_position == 0 
		or B738DR_engine02_fire_ext_switch_pos_arm == 1 then
			hyd_press_b_trg = 1
		end

	hyd_press_a_time = B738_set_anim_value(hyd_press_a_time, hyd_press_a_trg, 0.0, 1.0, 2.0)
	hyd_press_b_time = B738_set_anim_value(hyd_press_b_time, hyd_press_b_trg, 0.0, 1.0, 2.0)
	if hyd_press_a_time > 0.95 then
		hyd_press_a_cur = 1
	elseif hyd_press_a_time < 0.05 then
		hyd_press_a_cur = 0
	end
	if hyd_press_b_time > 0.95 then
		hyd_press_b_cur = 1
	elseif hyd_press_b_time < 0.05 then
		hyd_press_b_cur = 0
	end
	hyd_press_a = hyd_press_a_cur
	hyd_press_b = hyd_press_b_cur

	B738DR_hyd_press_a = hyd_press_a * brightness_level		
	B738DR_hyd_press_b = hyd_press_b * brightness_level


	-- electric hydro pumps
	local el_hyd_press_a = 0
	local el_hyd_press_a_trg = 0
	--if B738DR_source_off_bus1 > 0 then
	if B738DR_ac_tnsbus2_status == 0 then
		el_hyd_press_a_trg = 1
	end
	if B738DR_el_hydro_pumps1_switch_position == 0 then
		el_hyd_press_a_trg = 1
	end

	local el_hyd_press_b = 0
	local el_hyd_press_b_trg = 0
	--if B738DR_source_off_bus2 > 0 then
	if B738DR_ac_tnsbus1_status == 0 then
		el_hyd_press_b_trg = 1
	end
	if B738DR_el_hydro_pumps2_switch_position == 0 then
		el_hyd_press_b_trg = 1
	end
		
	el_hyd_press_a_time = B738_set_anim_value(el_hyd_press_a_time, el_hyd_press_a_trg, 0.0, 1.0, 2.0)
	el_hyd_press_b_time = B738_set_anim_value(el_hyd_press_b_time, el_hyd_press_b_trg, 0.0, 1.0, 2.0)
	if el_hyd_press_a_time > 0.95 then
		el_hyd_press_a_cur = 1
	elseif el_hyd_press_a_time < 0.05 then
		el_hyd_press_a_cur = 0
	end
	if el_hyd_press_b_time > 0.95 then
		el_hyd_press_b_cur = 1
	elseif el_hyd_press_b_time < 0.05 then
		el_hyd_press_b_cur = 0
	end
	el_hyd_press_a = el_hyd_press_a_cur
	el_hyd_press_b = el_hyd_press_b_cur
	
	B738DR_el_hyd_press_a = el_hyd_press_a * brightness_level		
	B738DR_el_hyd_press_b = el_hyd_press_b * brightness_level




-- BYPASS FILTER ANNUN

	local bypass_1 = 0
		if simDR_bypass_filter_1 == 6 then
		bypass_1 = 1
		end
		
	local bypass_2 = 0
		if simDR_bypass_filter_2 == 6 then
		bypass_2 = 1
		end	

	B738DR_bypass_filter_1 = bypass_1 * brightness_level
	B738DR_bypass_filter_2 = bypass_2 * brightness_level


-- FADEC OFF

	local fadec1_status = 0
		if simDR_fadec1 == 0 then
		fadec1_status = 1
		end
		
	B738DR_fadec1_off = fadec1_status * brightness_level
	
	local fadec2_status = 0
		if simDR_fadec2 == 0 then
		fadec2_status = 1
		end
		
	B738DR_fadec2_off = fadec2_status * brightness_level

-- STANDBY BATT ANNUN

	local standby_bat_status = 0
		if simDR_battery2_status == 0 then
		standby_bat_status = 1
		end
		
	B738DR_standby_pwr_off = standby_bat_status * brightness_level	

 
-- IDG FAIL

	local drive1_status = 0
		if simDR_generator1_fail == 6 or B738DR_gen1_available == 0 then
		drive1_status = 1
		end
		
	local drive2_status = 0
		if simDR_generator2_fail == 6 or B738DR_gen2_available == 0 then
		drive2_status = 1
		end

	B738DR_drive1_annun	= drive1_status * brightness_level
	B738DR_drive2_annun	= drive2_status * brightness_level
		
		
-- ANTI ICE

	local capt_pitot_status = 1
		if simDR_pitot_capt == 1 then
		capt_pitot_status = 0
		end
	
	if capt_pitot_status == 0 then
		capt_pitot_status_trg = 0
	end
	if capt_pitot_status == 1 then
		capt_pitot_status_trg = 1
		capt_pitot_status_time = 1
	end
	capt_pitot_status_time = B738_set_anim_value(capt_pitot_status_time, capt_pitot_status_trg, 0.0, 1.0, 8.0)
	if capt_pitot_status_time > 0.95 then
		capt_pitot_status_cur = 1
	elseif capt_pitot_status_time < 0.05 then
		capt_pitot_status_cur = 0
	end
	
	B738DR_capt_pitot_off = capt_pitot_status_cur * brightness_level	
--	B738DR_capt_pitot_off = capt_pitot_status * brightness_level	

	local fo_pitot_status = 1
		if simDR_pitot_fo == 1 then
		fo_pitot_status = 0
		end
	
	if fo_pitot_status == 0 then
		fo_pitot_status_trg = 0
	end
	if fo_pitot_status == 1 then
		fo_pitot_status_trg = 1
		fo_pitot_status_time = 1
	end
	fo_pitot_status_time = B738_set_anim_value(fo_pitot_status_time, fo_pitot_status_trg, 0.0, 1.0, 8.0)
	if fo_pitot_status_time > 0.95 then
		fo_pitot_status_cur = 1
	elseif fo_pitot_status_time < 0.05 then
		fo_pitot_status_cur = 0
	end
	
	B738DR_fo_pitot_off = fo_pitot_status_cur * brightness_level
--	B738DR_fo_pitot_off = fo_pitot_status * brightness_level

	local capt_aoa_status = 1
		if simDR_aoa_capt == 1 then
		capt_aoa_status = 0
		end

	if capt_aoa_status == 0 then
		capt_aoa_status_trg = 0
	end
	if capt_aoa_status == 1 then
		capt_aoa_status_trg = 1
		capt_aoa_status_time = 1
	end
	capt_aoa_status_time = B738_set_anim_value(capt_aoa_status_time, capt_aoa_status_trg, 0.0, 1.0, 7.0)
	if capt_aoa_status_time > 0.95 then
		capt_aoa_status_cur = 1
	elseif capt_aoa_status_time < 0.05 then
		capt_aoa_status_cur = 0
	end
	
	B738DR_capt_aoa_off = capt_aoa_status_cur * brightness_level
--	B738DR_capt_aoa_off = capt_aoa_status * brightness_level

	local fo_aoa_status = 1
		if simDR_aoa_fo == 1 then
		fo_aoa_status = 0
		end

	if fo_aoa_status == 0 then
		fo_aoa_status_trg = 0
	end
	if fo_aoa_status == 1 then
		fo_aoa_status_trg = 1
		fo_aoa_status_time = 1
	end
	fo_aoa_status_time = B738_set_anim_value(fo_aoa_status_time, fo_aoa_status_trg, 0.0, 1.0, 7.0)
	if fo_aoa_status_time > 0.95 then
		fo_aoa_status_cur = 1
	elseif fo_aoa_status_time < 0.05 then
		fo_aoa_status_cur = 0
	end
	
	B738DR_fo_aoa_off = fo_aoa_status_cur * brightness_level
--	B738DR_fo_aoa_off = fo_aoa_status * brightness_level
	
	
	-- Engines and Wings Anti-Ice
	local cowl_ice_0 = 0
		--if simDR_cowl_ice_detect_0 > 0.005 then
		if simDR_cowl_ice_detect_0 > 0.55 and simDR_cowl_ice_0_on == 1 then
		cowl_ice_0 = 1
		end
	local cowl_ice_1 = 0
		--if simDR_cowl_ice_detect_1 > 0.005 then
		if simDR_cowl_ice_detect_1 > 0.55 and simDR_cowl_ice_1_on == 1 then
		cowl_ice_1 = 1
		end
		
	local cowl_ice_status_0 = 0.5
		if simDR_cowl_ice_detect_0 > 0 then
		cowl_ice_status_0 = 1
		end
	local cowl_ice_status_1 = 0.5
		if simDR_cowl_ice_detect_1 > 0 then
		cowl_ice_status_1 = 1
		end
	local wing_ice_status_L = 0.5
		if simDR_wing_ice_detect_L > 0 then
		wing_ice_status_L = 1
		end
	local wing_ice_status_R = 0.5
		if simDR_wing_ice_detect_R > 0 then
		wing_ice_status_R = 1
		end

	wing_ice_L_time = B738_set_anim_value(wing_ice_L_time, simDR_wing_left_ice_on, 0.0, 1.0, 3.0)
	if wing_ice_L_time < 0.95 then
		wing_ice_status_L = 1
	end
	wing_ice_R_time = B738_set_anim_value(wing_ice_R_time, simDR_wing_right_ice_on, 0.0, 1.0, 3.0)
	if wing_ice_R_time < 0.95 then
		wing_ice_status_R = 1
	end
	cowl_ice_0_time = B738_set_anim_value(cowl_ice_0_time, simDR_cowl_ice_0_on, 0.0, 1.0, 3.0)
	if cowl_ice_0_time < 0.95 then
		cowl_ice_status_0 = 1
	end
	cowl_ice_1_time = B738_set_anim_value(cowl_ice_1_time, simDR_cowl_ice_1_on, 0.0, 1.0, 3.0)
	if cowl_ice_1_time < 0.95 then
		cowl_ice_status_1 = 1
	end

		
	B738DR_cowl_ice_0 = cowl_ice_0 * brightness_level
	B738DR_cowl_ice_1 = cowl_ice_1 * brightness_level
	
	B738DR_cowl_ice_0_on = simDR_cowl_ice_0_on * brightness_level * cowl_ice_status_0
	B738DR_cowl_ice_1_on = simDR_cowl_ice_1_on * brightness_level * cowl_ice_status_1
	
	B738DR_wing_ice_on_L = simDR_wing_left_ice_on * brightness_level * wing_ice_status_L
	B738DR_wing_ice_on_R = simDR_wing_right_ice_on * brightness_level * wing_ice_status_R

--	B738DR_wing_ice_on_L = simDR_wing_ice_on * brightness_level * wing_ice_status_L
--	B738DR_wing_ice_on_R = simDR_wing_ice_on * brightness_level * wing_ice_status_R

	local window_heat_fail_rf = 0
	local window_heat_fail_rs = 0
	local window_heat_fail_lf = 0
	local window_heat_fail_ls = 0
		if simDR_window_heat_fail == 6 then
		window_heat_fail_rf = 1
		window_heat_fail_rs = 1
		window_heat_fail_lf = 1
		window_heat_fail_ls = 1
		end
	
	if B738DR_ac_tnsbus1_status == 0 then
		window_heat_fail_lf = 1
		window_heat_fail_rs = 1
	end
	if B738DR_ac_tnsbus2_status == 0 then
		window_heat_fail_ls = 1
		window_heat_fail_rf = 1
	end
			
--	B738DR_window_heat_fail = window_heat_fail * brightness_level
	B738DR_window_heat_fail_rf = window_heat_fail_rf * B738DR_window_heat_r_fwd_pos * brightness_level
	B738DR_window_heat_fail_rs = window_heat_fail_rs * B738DR_window_heat_r_side_pos * brightness_level
	B738DR_window_heat_fail_lf = window_heat_fail_lf * B738DR_window_heat_l_fwd_pos * brightness_level
	B738DR_window_heat_fail_ls = window_heat_fail_ls * B738DR_window_heat_l_side_pos * brightness_level



-- GEAR LIGHT ANNUNCIATORS

	local nose_gear_safe_status = 0
	 	if simDR_nose_gear_status == 1 then
	 	nose_gear_safe_status = 1
	 end
	 
	local left_gear_safe_status = 0
	 	if simDR_left_gear_status == 1 then
	 	left_gear_safe_status = 1
	 end
	 
	local right_gear_safe_status = 0
	 	if simDR_right_gear_status == 1 then
	 	right_gear_safe_status = 1
	 end	

	local nose_gear_fail = 1
		if simDR_nose_gear_fail == 6 then
		nose_gear_fail = 0
	end
	
	local left_gear_fail = 1
		if simDR_left_gear_fail == 6 then
		left_gear_fail = 0
	end
	
	local right_gear_fail = 1
		if simDR_right_gear_fail == 6 then
		right_gear_fail = 0
	end
	


-- NOSE GEAR TRANSIT ANNUNCIATIOR

	local nose_gear_transit = 0
	local nose_gear_down = 1
	
	if simDR_nose_gear_status > 0 then
		nose_gear_transit = 1
	end
	
	-- if simDR_nose_gear_fail == 6 then
		-- nose_gear_down = 1
	-- end
	
	if simDR_nose_gear_status == 1 then
		nose_gear_down = 0
	end
	
	if simDR_nose_gear_fail == 6 then
		nose_gear_down = 1
	end
	
	if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1 or simDR_on_ground_2 == 1 then
		if B738DR_gear_handle_pos < 1 then
			nose_gear_down = 1
		end
	end
	
-- LEFT GEAR TRANSIT ANNUNCIATIOR

	local left_gear_transit = 0
	local left_gear_down = 1
		if simDR_left_gear_status > 0 then
		left_gear_transit = 1
		end
		-- if simDR_left_gear_fail == 6 then
		-- left_gear_down = 1
	-- end
	
		if simDR_left_gear_status == 1 then
		left_gear_down = 0
		end
		if simDR_left_gear_fail == 6 then
		left_gear_down = 1
	end
	if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1 or simDR_on_ground_2 == 1 then
		if B738DR_gear_handle_pos < 1 then
			left_gear_down = 1
		end
	end

	
-- RIGHT GEAR TRANSIT ANNUNCIATIOR

	local right_gear_transit = 0
	local right_gear_down = 1
		if simDR_right_gear_status > 0 then
		right_gear_transit = 1
		end
		-- if simDR_right_gear_fail == 6 then
		-- right_gear_down = 1
	-- end
	
		if simDR_right_gear_status == 1 then
		right_gear_down = 0
		end
		if simDR_right_gear_fail == 6 then
		right_gear_down = 1
	end
	if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1 or simDR_on_ground_2 == 1 then
		if B738DR_gear_handle_pos < 1 then
			right_gear_down = 1
		end
	end
	
	-- warning landing gear
	if simDR_radio_height_pilot_ft < 800 then
		if B738DR_thrust1_leveler == 0 or B738DR_thrust2_leveler == 0 then
			if B738DR_gear_handle_pos < 1 then
				--if simDR_nose_gear_status < 1 or simDR_left_gear_status < 1 or simDR_right_gear_status < 1 then
					nose_gear_transit = 1
					left_gear_transit = 1
					right_gear_transit = 1
				--end
			end
		end
	end
	
	B738DR_nose_gear_transit_annun = nose_gear_transit * nose_gear_down * brightness_level
	B738DR_left_gear_transit_annun = left_gear_transit * left_gear_down * brightness_level
	B738DR_right_gear_transit_annun = right_gear_transit * right_gear_down * brightness_level
	
	B738DR_nose_gear_safe_annun = nose_gear_safe_status * brightness_level * nose_gear_fail
	B738DR_left_gear_safe_annun = left_gear_safe_status * brightness_level * left_gear_fail
	B738DR_right_gear_safe_annun = right_gear_safe_status * brightness_level * right_gear_fail
	
-- LOW FUEL PRESSURE ANNUNCIATORS TANK L

	local fuel_press_low_left1 = 0
	--if B738DR_fuel_tank_l1 == 1 then
		if simDR_fuel_quantity_l < 200 then
			fuel_press_low_left1 = 1
		end
		
	--end

	l1_pump_trg = 1
	--if B738DR_fuel_tank_pos_lft1 == 1 and B738DR_source_off_bus1 == 0 then
	if B738DR_fuel_tank_pos_lft1 == 1 and B738DR_ac_tnsbus2_status == 1 then
		l1_pump_trg = 0
	end

	l1_pump_time = B738_set_anim_value(l1_pump_time, l1_pump_trg, 0.0, 1.0, 2.0)
	
	if l1_pump_time > 0.95 then
		l1_pump_cur = 1
	elseif l1_pump_time < 0.05 then
		l1_pump_cur = 0
	end
	
	
	if fuel_press_low_left1 == 1 or l1_pump_cur == 1 then
	--or B738DR_fuel_tank_pos_lft1 == 0 then
		fuel_press_low_left1 = 1
	end
	if fuel_press_low_left1 == 0 and l1_pump_cur == 0 then
		fuel_press_low_left1 = 0
	end

	B738DR_low_fuel_press_l1_annun = fuel_press_low_left1 * brightness_level


	local fuel_press_low_left2 = 0
	--if B738DR_fuel_tank_l2 == 1 then
		if simDR_fuel_quantity_l < 175 then
			fuel_press_low_left2 = 1
		end
	--end

	l2_pump_trg = 1
	--if B738DR_fuel_tank_pos_lft2 == 1 and B738DR_source_off_bus1 == 0 then
	if B738DR_fuel_tank_pos_lft2 == 1 and B738DR_ac_tnsbus1_status == 1 then
		l2_pump_trg = 0
	end

	l2_pump_time = B738_set_anim_value(l2_pump_time, l2_pump_trg, 0.0, 1.0, 2.0)
	
	if l2_pump_time > 0.95 then
		l2_pump_cur = 1
	elseif l2_pump_time < 0.05 then
		l2_pump_cur = 0
	end
	
	if fuel_press_low_left2 == 1 or l2_pump_cur == 1 then
	--or B738DR_fuel_tank_pos_lft2 == 0 then
		fuel_press_low_left2 = 1
	end
	if fuel_press_low_left2 == 0 and l2_pump_cur == 0 then
		fuel_press_low_left2 = 0
	end

	B738DR_low_fuel_press_l2_annun = fuel_press_low_left2 * brightness_level


-- LOW FUEL PRESSURE ANNUNCIATORS TANK C

	local fuel_press_low_center1 = 0
	--if B738DR_fuel_tank_c1 == 1 then
		if simDR_fuel_quantity_c < 625 then
			fuel_press_low_center1 = 1
		end
	--end

	c1_pump_trg = 1
	--if B738DR_fuel_tank_pos_ctr1 == 1 and B738DR_source_off_bus1 == 0 then
	if B738DR_fuel_tank_pos_ctr1 == 1 and B738DR_ac_tnsbus2_status == 1 then
		c1_pump_trg = 0
	end

	c1_pump_time = B738_set_anim_value(c1_pump_time, c1_pump_trg, 0.0, 1.0, 2.0)
	
	if c1_pump_time > 0.95 then
		c1_pump_cur = 1
	elseif c1_pump_time < 0.05 then
		c1_pump_cur = 0
	end
	
	
	if c1_pump_cur == 1 or fuel_press_low_center1 == 1 then
		if B738DR_fuel_tank_pos_ctr1 == 1 then
			fuel_press_low_center1 = 1
		end
	end
	if (c1_pump_cur == 0 and fuel_press_low_center1 == 0)
	or B738DR_fuel_tank_pos_ctr1 == 0 then
		fuel_press_low_center1 = 0
	end
	

	B738DR_low_fuel_press_c1_annun = fuel_press_low_center1 * brightness_level
	


	local fuel_press_low_center2 = 0
	--if B738DR_fuel_tank_c2 == 1 then
		if simDR_fuel_quantity_c < 625 then
			fuel_press_low_center2 = 1
		end
	--end

	c2_pump_trg = 1
	--if B738DR_fuel_tank_pos_ctr2 == 1 and B738DR_source_off_bus2 == 0 then
	if B738DR_fuel_tank_pos_ctr2 == 1 and B738DR_ac_tnsbus1_status == 1 then
		c2_pump_trg = 0
	end

	c2_pump_time = B738_set_anim_value(c2_pump_time, c2_pump_trg, 0.0, 1.0, 2.0)
	
	if c2_pump_time > 0.95 then
		c2_pump_cur = 1
	elseif c2_pump_time < 0.05 then
		c2_pump_cur = 0
	end
	
	if c2_pump_cur == 1 or fuel_press_low_center2 == 1 then
		if B738DR_fuel_tank_pos_ctr2 == 1 then
			fuel_press_low_center2 = 1
		end
	end
	if (c2_pump_cur == 0 and fuel_press_low_center2 == 0)
	or B738DR_fuel_tank_pos_ctr2 == 0 then
		fuel_press_low_center2 = 0
	end

	B738DR_low_fuel_press_c2_annun = fuel_press_low_center2 * brightness_level


	-- SIX FUEL CENTER
	six_fuel_center = 0
	if B738DR_fuel_tank_pos_ctr1 == 1 or B738DR_fuel_tank_pos_ctr2 == 1 then
		if fuel_press_low_center1 == 1 or fuel_press_low_center2 == 1 then
			six_fuel_center = 1
		end
	end
	
	-- LOW FUEL PRESSURE ANNUNCIATORS TANK R

	local fuel_press_low_right1 = 0
	--if B738DR_fuel_tank_r1 == 1 then
		if simDR_fuel_quantity_r < 190 then
			fuel_press_low_right1 = 1
		end
	--end

	r1_pump_trg = 1
	--if B738DR_fuel_tank_pos_rgt1 == 1 and B738DR_source_off_bus2 == 0 then
	if B738DR_fuel_tank_pos_rgt1 == 1 and B738DR_ac_tnsbus1_status == 1 then
		r1_pump_trg = 0
	end

	r1_pump_time = B738_set_anim_value(r1_pump_time, r1_pump_trg, 0.0, 1.0, 2.0)
	
	if r1_pump_time > 0.95 then
		r1_pump_cur = 1
	elseif r1_pump_time < 0.05 then
		r1_pump_cur = 0
	end
	
	if fuel_press_low_right1 == 1 or r1_pump_cur == 1 then
	--or B738DR_fuel_tank_pos_rgt1 == 0 then
		fuel_press_low_right1 = 1
	end
	if fuel_press_low_right1 == 0 and r1_pump_cur == 0 then
		fuel_press_low_right1 = 0
	end

	B738DR_low_fuel_press_r1_annun = fuel_press_low_right1 * brightness_level
	
	local fuel_press_low_right2 = 0
	--if B738DR_fuel_tank_r2 == 1 then
		if simDR_fuel_quantity_r < 160 then
			fuel_press_low_right2 = 1
		end
	--end

	r2_pump_trg = 1
	--if B738DR_fuel_tank_pos_rgt2 == 1 and B738DR_source_off_bus2 == 0 then
	if B738DR_fuel_tank_pos_rgt2 == 1 and B738DR_ac_tnsbus2_status == 1 then
		r2_pump_trg = 0
	end

	r2_pump_time = B738_set_anim_value(r2_pump_time, r2_pump_trg, 0.0, 1.0, 2.0)
	
	if r2_pump_time > 0.95 then
		r2_pump_cur = 1
	elseif r2_pump_time < 0.05 then
		r2_pump_cur = 0
	end
	
	if fuel_press_low_right2 == 1 or r2_pump_cur == 1 then
	--or B738DR_fuel_tank_pos_rgt2 == 0 then
		fuel_press_low_right2 = 1
	end
	if fuel_press_low_right2 == 0 and r2_pump_cur == 0 then
		fuel_press_low_right2 = 0
	end

	B738DR_low_fuel_press_r2_annun = fuel_press_low_right2 * brightness_level	

-- SPAR VALVE ANNUNS
	if B738DR_mixture_ratio1 > 0.05 then
		spar_valve_1_tgt = 1
	else
		spar_valve_1_tgt = 0
	end
		
	if B738DR_engine01_fire_ext_switch_pos_arm == 1 then
		spar_valve_1_tgt = 0
	end
	
	spar_valve_1_pos = B738_set_anim_value(spar_valve_1_pos, spar_valve_1_tgt, 0.0, 1.0, 2.0)
	
	local spar_valve_1_status = 0
	if spar_valve_1_pos < 0.05 then
		spar_valve_1_status = 0.5		-- close
	elseif spar_valve_1_pos > 0.95 then
		spar_valve_1_status = 0		-- open
	else
		spar_valve_1_status = 1	-- transit
	end
	
	B738DR_spar1_valve_closed_annun = spar_valve_1_status * brightness_level
	
	if B738DR_mixture_ratio2 > 0.05 then
		spar_valve_2_tgt = 1
	else
		spar_valve_2_tgt = 0
	end
		
	if B738DR_engine02_fire_ext_switch_pos_arm == 1 then
		spar_valve_2_tgt = 0
	end
	
	spar_valve_2_pos = B738_set_anim_value(spar_valve_2_pos, spar_valve_2_tgt, 0.0, 1.0, 2.0)
	
	local spar_valve_2_status = 0
	if spar_valve_2_pos < 0.05 then
		spar_valve_2_status = 0.5		-- close
	elseif spar_valve_2_pos > 0.95 then
		spar_valve_2_status = 0		-- open
	else
		spar_valve_2_status = 1	-- transit
	end
	
	B738DR_spar2_valve_closed_annun = spar_valve_2_status * brightness_level
	
--ENG VALVE ANNUNS

	local eng_valve_1_status = 0.5
		if B738DR_mixture_ratio1 > 0.05 then
			eng_valve_1_status = 1
		end
		if simDR_mixture1 == 1 and simDR_engine1_n1 > 1 then
			eng_valve_1_status = 0
		end

	B738DR_eng1_valve_closed_annun = eng_valve_1_status * brightness_level
	
	local eng_valve_2_status = 0.5
		if B738DR_mixture_ratio2 > 0.05 then
			eng_valve_2_status = 1
		end
		if simDR_mixture2 == 1 and simDR_engine2_n1 > 1 then
			eng_valve_2_status = 0
		end

	B738DR_eng2_valve_closed_annun = eng_valve_2_status * brightness_level


-- AUTOBRAKE DISARM
	
	local autobrake_disarm_status = 0
	if B738DR_autobrake_RTO_test == 1 then
		autobrake_disarm_status_cur = 1
		autobrake_disarm_status_time = 0
		autobrake_disarm_status_trg = 1
		B738DR_autobrake_RTO_test = 0
	end
	if B738DR_autobrake_RTO_arm == 0 then
		autobrake_disarm_status_cur = 0
	end
	
	autobrake_disarm_status_time = B738_set_anim_value(autobrake_disarm_status_time, autobrake_disarm_status_trg, 0.0, 1.0, 2.0)


	if autobrake_disarm_status_time > 0.95 then
		autobrake_disarm_status_cur = 0
	end
	
	if autobrake_disarm_status_cur == 1 or B738DR_autobrake_disarm == 1 then
		autobrake_disarm_status = 1
	end
	
	B738DR_auto_brake_disarm = autobrake_disarm_status * brightness_level
	
-- APU LOW OIL
	B738DR_annun_apu_low_oil = B738DR_apu_low_oil * brightness_level
	
	
	-- OFF SCHED DESC
	local off_sched_desc_ann = 0
	local alt_500 = 0
	
	if B738DR_flight_phase == 0 then
		off_sched_desc_enable = 1
		off_sched_desc = 0
		last_alt = simDR_altitude_pilot
	end
	
	alt_500 = simDR_altitude_pilot + 1500
	if last_alt > alt_500 and simDR_radio_height_pilot_ft < 10000 then
		off_sched_desc_enable = 0
	end
	
	if off_sched_desc_enable == 1 then
		alt_500 = simDR_altitude_pilot + 490
		if alt_500 >= simDR_max_allowable_alt then
			off_sched_desc = 1
		end
		alt_500 = simDR_altitude_pilot + 1500
		if last_alt > alt_500 and off_sched_desc == 0 then
			off_sched_desc_ann = 1
		end
	end
	if last_alt < simDR_altitude_pilot then
		last_alt = simDR_altitude_pilot
	end
	
	B738DR_off_sched_desc				= off_sched_desc_ann * brightness_level
	
	-- ALTERNATE PRESSURIZATION
	local altn_press = 0
--	if B738DR_air_valve_ctrl == 0 then
		if B738DR_pressurization_mode == 2 then
			altn_press = 1
		end
--	elseif B738DR_air_valve_ctrl == 1 then
--		altn_press = 1
--	end
	B738DR_altn_press = altn_press * brightness_level

	-- MANUAL PRESSURIZATION
	local manual_press = 0
	if B738DR_air_valve_ctrl == 2 then
		manual_press = 1
	end
	B738DR_manual_press = manual_press * brightness_level
	
	-- AUTO FAIL
	local autofail = 0
	--if simDR_radio_height_pilot_ft > 50 and B738DR_air_valve_ctrl < 2 then
		if B738DR_air_valve_ctrl == 0 then
			if B738DR_pressurization_mode ~= 1 then
				autofail = 1
			end
		elseif B738DR_air_valve_ctrl == 1 then
			if B738DR_pressurization_mode ~= 2 then
				autofail = 1
			end
		end
		if B738DR_pressurization_mode == 0 then
			autofail = 1
		end
		if simDR_diff_press > 8.75 and simDR_altitude_pilot > 15800 then
			autofail = 1
		end
		-- if simDR_vvi_press_act < -2000 or simDR_vvi_press_act > 2000 then
			-- autofail = 1
		-- end
		if B738DR_cabin_vvi < -2000 or B738DR_cabin_vvi > 2000 then
			autofail = 1
		end
	--end
	B738DR_autofail = autofail * brightness_level

	-- STAB OUT OF TRIM
	local stab_out_of_trim = 0
	if simDR_elevator_trim < -0.9 or simDR_elevator_trim > 0.9 then
		stab_out_of_trim = 1
	end
	B738DR_stab_out_of_trim_annun = stab_out_of_trim * brightness_level
	
	-- SPEED BRAKE NOT ARMED
	local spd_brk_not_arm = 0
	B738DR_spd_brk_not_arm_annun = spd_brk_not_arm * brightness_level
	
	-- DOOR LOCK FAIL
	local door_lock_fail = 0
	local fdas = 1	-- Flight Deck Acces System (Guarded switch)
	if fdas == 0 then
		door_lock_fail = 1
	end
	if B738DR_flt_dk_door_ratio ~= 0 and B738DR_flt_dk_door == 0 then
		door_lock_fail = 1
	end
	B738DR_door_lock_fail_annun = door_lock_fail * brightness_level
	
	-- DOOR AUTO UNLOCK
	local door_auto_unlk = 0
	local corr_emer_acces = 0 	-- Correct Emergency Acces Code enterd in keypad
	local blink_out = 0
	if corr_emer_acces == 1 then
		if DRblink == 1 then
			if blink_out == 0 then
				blink_out = 1
			else
				blink_out = 0
			end
		end
		door_auto_unlk = blink_out
	end
	if B738DR_flt_dk_door == 1 then
		door_auto_unlk = 0
	end
	B738DR_door_auto_unlk_annun = door_auto_unlk * brightness_level
	
	-- RAM DOOR OPEN FULL
	local ram_door_open = 0
	if B738DR_outflow_valve < 0.05 then
		ram_door_open = 0		-- close
	elseif B738DR_outflow_valve > 0.95 then
		ram_door_open = 0.5		-- open
	else
		ram_door_open = 1		-- transit
	end
	
	B738DR_ram_door_open1				= ram_door_open * brightness_level
	B738DR_ram_door_open2				= ram_door_open * brightness_level
	
	
	
-- TEST

	if B738DR_window_ovht_test == -1 then
		B738DR_window_heat_fail_rf			= 1 * brightness_level
		B738DR_window_heat_fail_rs			= 1 * brightness_level
		B738DR_window_heat_fail_lf			= 1 * brightness_level
		B738DR_window_heat_fail_ls			= 1 * brightness_level
	elseif B738DR_window_ovht_test == 1 then
		B738DR_window_heat_annun1			= 1 * brightness_level
		B738DR_window_heat_annun2			= 1 * brightness_level
		B738DR_window_heat_annun3			= 1 * brightness_level
		B738DR_window_heat_annun4			= 1 * brightness_level
	end


	if B738DR_lights_test == 1 then
		B738DR_parking_brake_annun			= 1 * brightness_level2
--		B738DR_window_heat_annun			= 1 * brightness_level
--		B738DR_window_heat_annun1			= 1 * brightness_level
--		B738DR_window_heat_annun2			= 1 * brightness_level
--		B738DR_window_heat_annun3			= 1 * brightness_level
--		B738DR_window_heat_annun4			= 1 * brightness_level
		B738DR_fadec_fail_annun_0			= 1 * brightness_level
		B738DR_fadec_fail_annun_1			= 1 * brightness_level
		B738DR_reverser_fail_annun_0		= 1 * brightness_level
		B738DR_reverser_fail_annun_1		= 1 * brightness_level
		B738DR_capt_pitot_off				= 1 * brightness_level
		B738DR_fo_pitot_off					= 1 * brightness_level
		B738DR_capt_aoa_off					= 1 * brightness_level
		B738DR_fo_aoa_off					= 1 * brightness_level
--		B738DR_window_heat_fail				= 1 * brightness_level
--		B738DR_window_heat_fail_rf			= 1 * brightness_level
--		B738DR_window_heat_fail_rs			= 1 * brightness_level
--		B738DR_window_heat_fail_lf			= 1 * brightness_level
--		B738DR_window_heat_fail_ls			= 1 * brightness_level
		B738DR_cowl_ice_0					= 1 * brightness_level
		B738DR_cowl_ice_1					= 1 * brightness_level
		B738DR_cowl_ice_0_on				= 1 * brightness_level
		B738DR_cowl_ice_1_on				= 1 * brightness_level
		B738DR_wing_ice_on_L				= 1 * brightness_level
		B738DR_wing_ice_on_R				= 1 * brightness_level
		B738DR_apu_fault_annun				= 1 * brightness_level
		B738DR_nose_gear_transit_annun		= 1 * brightness_level
		B738DR_nose_gear_safe_annun			= 1 * brightness_level
		B738DR_left_gear_transit_annun		= 1 * brightness_level
		B738DR_left_gear_safe_annun			= 1 * brightness_level
		B738DR_right_gear_transit_annun		= 1 * brightness_level
		B738DR_right_gear_safe_annun		= 1 * brightness_level
		B738DR_low_fuel_press_l1_annun		= 1 * brightness_level
		B738DR_low_fuel_press_l2_annun		= 1 * brightness_level
		B738DR_low_fuel_press_c1_annun		= 1 * brightness_level
		B738DR_low_fuel_press_c2_annun		= 1 * brightness_level
		B738DR_low_fuel_press_r1_annun		= 1 * brightness_level
		B738DR_low_fuel_press_r2_annun		= 1 * brightness_level
		B738DR_eng1_valve_closed_annun		= 1 * brightness_level
		B738DR_eng2_valve_closed_annun		= 1 * brightness_level
		B738DR_spar1_valve_closed_annun		= 1 * brightness_level
		B738DR_spar2_valve_closed_annun		= 1 * brightness_level
		B738DR_fadec1_off					= 1 * brightness_level
		B738DR_fadec2_off					= 1 * brightness_level
		B738DR_drive1_annun					= 1 * brightness_level
		B738DR_drive2_annun					= 1 * brightness_level
		B738DR_standby_pwr_off				= 1 * brightness_level
		B738DR_bypass_filter_1				= 1 * brightness_level
		B738DR_bypass_filter_2				= 1 * brightness_level
		B738DR_hyd_press_a					= 1 * brightness_level
		B738DR_hyd_press_b					= 1 * brightness_level
		--B738DR_packs_annun					= 1 * brightness_level
		B738DR_packs_left_annun				= 1 * brightness_level
		B738DR_packs_right_annun			= 1 * brightness_level
		B738DR_smoke						= 1 * brightness_level
		B738DR_annun_apu_low_oil			= 1 * brightness_level
		B738DR_apu_gen_off_bus				= 1 * brightness_level
		B738DR_gen_off_bus1					= 1 * brightness_level
		B738DR_gen_off_bus2					= 1 * brightness_level
		B738DR_source_off_bus1				= 1 * brightness_level
		B738DR_source_off_bus2				= 1 * brightness_level
		B738DR_transfer_bus_off1			= 1 * brightness_level
		B738DR_transfer_bus_off2			= 1 * brightness_level
		B738DR_fwd_entry					= 1 * brightness_level
		B738DR_left_fwd_overwing			= 1 * brightness_level
		B738DR_left_aft_overwing			= 1 * brightness_level
		B738DR_aft_entry					= 1 * brightness_level
		B738DR_fwd_service					= 1 * brightness_level
		B738DR_right_fwd_overwing			= 1 * brightness_level
		B738DR_right_aft_overwing			= 1 * brightness_level
		B738DR_aft_service					= 1 * brightness_level
		B738DR_fwd_cargo					= 1 * brightness_level
		B738DR_aft_cargo					= 1 * brightness_level
		B738DR_equip_door					= 1 * brightness_level
		B738DR_pax_oxy						= 1 * brightness_level
		B738DR_bleed_trip_off1				= 1 * brightness_level
		B738DR_bleed_trip_off2				= 1 * brightness_level
		--B738DR_wing_body_ovht				= 1 * brightness_level
		B738DR_wing_body_ovht_left			= 1 * brightness_level
		B738DR_wing_body_ovht_right			= 1 * brightness_level
		B738DR_ground_power_avail_annun		= 1 * brightness_level
		B738DR_elt_annun 					= 1 * brightness_level
		B738DR_fdr_off 						= 1 * brightness_level
		B738DR_yaw_damper 					= 1 * brightness_level
		B738DR_crossfeed					= 1 * brightness_level
		B738DR_emer_exit_annun				= 1 * brightness_level
		B738DR_cabin_alt_annun				= 1 * brightness_level
		B738DR_speedbrake_armed				= 1 * brightness_level
		B738DR_speedbrake_extend			= 1 * brightness_level
		B738DR_battery_disch_annun			= 1 * brightness_level
		B738DR_GPWS_annun					= 1 * brightness_level
		B738DR_takeoff_config_annun			= 1 * brightness_level
		B738DR_below_gs						= 1 * brightness_level
		B738DR_slats_extended				= 1 * brightness_level
		B738DR_slats_transit				= 1 * brightness_level
		--B738DR_extinguisher_circuit_annun1	= 1 * brightness_level
		B738DR_extinguisher_circuit_annun_left 	= 1 * brightness_level
		B738DR_extinguisher_circuit_annun_right = 1 * brightness_level
		B738DR_extinguisher_circuit_annun_apu 	= 1 * brightness_level
		B738DR_extinguisher_circuit_annun2	= 1 * brightness_level
		B738DR_cargo_fire_annuns			= 1 * brightness_level
		B738DR_cargo_fault_detector_annun	= 1 * brightness_level
		B738DR_fire_fault_inop_annun		= 1 * brightness_level
		B738DR_engine1_ovht					= 1 * brightness_level
		B738DR_engine2_ovht					= 1 * brightness_level
		B738DR_wheel_well_fire				= 1 * brightness_level
		B738DR_l_bottle_discharge			= 1 * brightness_level
		B738DR_r_bottle_discharge			= 1 * brightness_level
		B738DR_apu_bottle_discharge			= 1 * brightness_level
		B738DR_auto_brake_disarm			= 1 * brightness_level
		B738DR_hyd_A_rud_annun 				= 1 * brightness_level
		B738DR_hyd_B_rud_annun 				= 1 * brightness_level
		B738DR_std_rud_on_annun 			= 1 * brightness_level
		B738DR_hyd_stdby_annun				= 1 * brightness_level
		B738DR_ram_door_open1				= 1 * brightness_level
		B738DR_ram_door_open2				= 1 * brightness_level

-- SIX PACK

		B738DR_six_pack_fuel				= 1 * brightness_level
		B738DR_six_pack_fire				= 1 * brightness_level
		B738DR_six_pack_apu					= 1 * brightness_level
		B738DR_six_pack_flt_cont			= 1 * brightness_level
		B738DR_six_pack_elec				= 1 * brightness_level
		B738DR_six_pack_irs					= 1 * brightness_level

		B738DR_six_pack_ice					= 1 * brightness_level
		B738DR_six_pack_doors				= 1 * brightness_level
		B738DR_six_pack_eng					= 1 * brightness_level
		B738DR_six_pack_hyd					= 1 * brightness_level
		B738DR_six_pack_air_cond			= 1 * brightness_level
		B738DR_six_pack_overhead			= 1 * brightness_level
		
		B738DR_master_caution_light			= 1 * brightness_level2
		
		B738DR_off_sched_desc				= 1 * brightness_level
		B738DR_altn_press					= 1 * brightness_level
		B738DR_manual_press					= 1 * brightness_level
		B738DR_autofail						= 1 * brightness_level
		
		B738DR_stab_out_of_trim_annun		= 1 * brightness_level
		B738DR_spd_brk_not_arm_annun		= 1 * brightness_level
		B738DR_door_lock_fail_annun			= 1 * brightness_level
		B738DR_door_auto_unlk_annun			= 1 * brightness_level
		

	end
end


----- INITIALIZE LIGHTING ---------------------------------------------------------------
function B738_init_lighting()

    --[[   SPILL LIGHTS   
    
    NOTE: FOR SPILL LIGHTS...
    THE ORDER OF ARRAY DATA FOR THE OBJ FILE IS DIFFERENT THAN WHAT WE NEED TO USE TO SET THE DATAREF IN CODE.

    OBJ IS AS FOLLOWS:
    X	Y	Z	R	G	B	A	SIZE	Dx	Dy	Dz	SEMI	DATAREF

    SET DATAREF WITH CODE AS FOLLOWS:
    X	Y	Z	R	G	B	A	SIZE	SEMI	Dx	Dy	Dz
    
    --]]
 
	local extinguisher_circuit_spill2 = {0.19, 1, 0.5, 0.0, 0.07, 1, 0, 0, 0} 
	local extinguisher_circuit_spill_left = {0.19, 1, 0.5, 0.0, 0.07, 1, 0, 0, 0} 
	local extinguisher_circuit_spill_right = {0.19, 1, 0.5, 0.0, 0.07, 1, 0, 0, 0} 
	local extinguisher_circuit_spill_apu = {0.19, 1, 0.5, 0.0, 0.07, 1, 0, 0, 0} 
	local parking_brake_spill = {1.0, 0, 0, 0.0, 0.15, 1, 0, 0, 0}
	
	local extinguisher_leveler_spill_eng1 = {1.0, 0.0, 0.0, 0.0, 0.15, 1, 0, 0, 0}
	local extinguisher_leveler_spill_eng2 = {1.0, 0.0, 0.0, 0.0, 0.15, 1, 0, 0, 0}
	local extinguisher_leveler_spill_apu = {1.0, 0.0, 0.0, 0.0, 0.15, 1, 0, 0, 0}
	
	local master_caution_spill 		= {1.0, 1.0, 0.0, 0.0, 0.15, 1, 0, 0, 0}
	local fire_warn_spill 			= {1.0, 0.0, 0.0, 0.0, 0.15, 1, 0, 0, 0}
	
	local cabin_lights				= {1.0, 1.0, 0.8, 0.0, 3.0, 1, 0, 0, 0}
	local cabin_emergency_lights	= {1.0, 0.0, 0.0, 0.0, 2.2, 1, 0, 0, 0}
	
	local l_wings_lights			= {0.53, 0.86, 0.92, 0.0, 0.03, 1, 0, 0, 0}
	local r_wings_lights			= {0.53, 0.86, 0.92, 0.0, 0.03, 1, 0, 0, 0}
	local eng1_wings_lights			= {0.53, 0.86, 0.92, 0.0, 0.03, 1, 0, 0, 0}
	local eng2_wings_lights			= {0.53, 0.86, 0.92, 0.0, 0.03, 1, 0, 0, 0}
	local gpu_avail_lights			= {0.53, 0.86, 0.92, 0.0, 0.03, 1, 0, 0, 0}
	local eng1_valve_lights			= {0.53, 0.86, 0.92, 0.0, 0.03, 1, 0, 0, 0}
	local eng2_valve_lights			= {0.53, 0.86, 0.92, 0.0, 0.03, 1, 0, 0, 0}
	local eng1_spar_lights			= {0.53, 0.86, 0.92, 0.0, 0.03, 1, 0, 0, 0}
	local eng2_spar_lights			= {0.53, 0.86, 0.92, 0.0, 0.03, 1, 0, 0, 0}
	local ram1_full_lights			= {0.53, 0.86, 0.92, 0.0, 0.03, 1, 0, 0, 0}
	local ram2_full_lights			= {0.53, 0.86, 0.92, 0.0, 0.03, 1, 0, 0, 0}
	local crossfeed_lights			= {0.53, 0.86, 0.92, 0.0, 0.03, 1, 0, 0, 0}
	local gen1_avail_lights			= {0.53, 0.86, 0.92, 0.0, 0.03, 1, 0, 0, 0}
	local gen2_avail_lights			= {0.53, 0.86, 0.92, 0.0, 0.03, 1, 0, 0, 0}
	local apu_avail_lights			= {0.53, 0.86, 0.92, 0.0, 0.03, 1, 0, 0, 0}
	
	local i = 0
    
    for i = 0, 8 do
		B738DR_parking_brake_spill[i] = parking_brake_spill[i+1]
		B738DR_extinguisher_circuit_spill2[i] = extinguisher_circuit_spill2[i+1]
		B738DR_extinguisher_circuit_spill_left[i] = extinguisher_circuit_spill_left[i+1]
		B738DR_extinguisher_circuit_spill_right[i] = extinguisher_circuit_spill_right[i+1]
		B738DR_extinguisher_circuit_spill_apu[i] = extinguisher_circuit_spill_apu[i+1]

		B738DR_extinguisher_leveler_spill_eng1[i] = extinguisher_leveler_spill_eng1[i+1]
		B738DR_extinguisher_leveler_spill_eng2[i] = extinguisher_leveler_spill_eng2[i+1]
		B738DR_extinguisher_leveler_spill_apu[i] = extinguisher_leveler_spill_apu[i+1]
		B738DR_master_caution_spill[i] = master_caution_spill[i+1]
		B738DR_fire_warn_spill[i] = fire_warn_spill[i+1]
		
		B738DR_cabin_lights[i] = cabin_lights[i+1]
		B738DR_cabin_emergency_lights[i] = cabin_emergency_lights[i+1]
		
		B738DR_l_wings_lights[i] = l_wings_lights[i+1]
		B738DR_r_wings_lights[i] = r_wings_lights[i+1]
		B738DR_eng1_wings_lights[i] = eng1_wings_lights[i+1]
		B738DR_eng2_wings_lights[i] = eng2_wings_lights[i+1]
		
		B738DR_gpu_avail_lights[i] = gpu_avail_lights[i+1]
		B738DR_eng1_valve_lights[i] = eng1_valve_lights[i+1]
		B738DR_eng2_valve_lights[i] = eng2_valve_lights[i+1]
		B738DR_eng1_spar_lights[i] = eng1_spar_lights[i+1]
		B738DR_eng2_spar_lights[i] = eng2_spar_lights[i+1]
		B738DR_ram1_full_lights[i] = ram1_full_lights[i+1]
		B738DR_ram2_full_lights[i] = ram2_full_lights[i+1]
		
		B738DR_crossfeed_lights[i] = crossfeed_lights[i+1]
		B738DR_gen1_avail_lights[i] = gen1_avail_lights[i+1]
		B738DR_gen2_avail_lights[i] = gen2_avail_lights[i+1]
		B738DR_apu_avail_lights[i] = apu_avail_lights[i+1]
	end	
    
end    


----- SPILL LIGHTS ----------------------------------------------------------------------
function B738_spill_lights()
	
	B738DR_parking_brake_spill[3] = B738DR_parking_brake_annun
	B738DR_extinguisher_circuit_spill2[3] = B738DR_extinguisher_circuit_annun2
	B738DR_extinguisher_circuit_spill_left[3] = B738DR_extinguisher_circuit_annun_left
	B738DR_extinguisher_circuit_spill_right[3] = B738DR_extinguisher_circuit_annun_right
	B738DR_extinguisher_circuit_spill_apu[3] = B738DR_extinguisher_circuit_annun_apu
	
	B738DR_extinguisher_leveler_spill_eng1[3] = B738DR_engine1_fire
	B738DR_extinguisher_leveler_spill_eng2[3] = B738DR_engine2_fire
	B738DR_extinguisher_leveler_spill_apu[3] = B738DR_apu_fire
	
	B738DR_master_caution_spill[3] = B738DR_master_caution_light
	B738DR_fire_warn_spill[3] = B738DR_fire_bell_annun
	
	local ratio_lights = 1
	if simDR_head_z < -14.50 then
		ratio_lights = B738DR_flt_dk_door_ratio
	end
	
	local enable_cabin_lights = 1
	
	if B738DR_ac_tnsbus1_status == 0 then
		if ac_tnsbus1_status_old ~= B738DR_ac_tnsbus1_status then
			cabin_lights_tim = 0
		end
		if cabin_lights_tim < 0.3 then
			enable_cabin_lights = 0
		elseif cabin_lights_tim < 0.5 then
			enable_cabin_lights = 1
		elseif cabin_lights_tim < 0.6 then
			enable_cabin_lights = 0
		elseif cabin_lights_tim < 0.8 then
			enable_cabin_lights = 1
		elseif cabin_lights_tim < 0.9 then
			enable_cabin_lights = 0
		end
		B738DR_cabin_lights[4] = 1.85 * enable_cabin_lights
		B738DR_cabin_emergency_lights[3] = B738DR_batbus_status * ratio_lights
		if cabin_lights_tim < 0.9 then
			cabin_lights_tim = cabin_lights_tim + SIM_PERIOD
		end
	else
		cabin_lights_tim = 1
		B738DR_cabin_lights[4] = 3.0
		B738DR_cabin_emergency_lights[3] = 0
	end
	B738DR_cabin_lights[3] = B738DR_batbus_status * ratio_lights
	ac_tnsbus1_status_old = B738DR_ac_tnsbus1_status
	
	local dimmed = 0.35
	if B738DR_wing_ice_on_L == 1 then
		dimmed = 1
	end
	B738DR_l_wings_lights[3] = B738DR_wing_ice_on_L * dimmed
	dimmed = 0.35
	if B738DR_wing_ice_on_R == 1 then
		dimmed = 1
	end
	B738DR_r_wings_lights[3] = B738DR_wing_ice_on_R * dimmed
	dimmed = 0.35
	if B738DR_cowl_ice_0_on == 1 then
		dimmed = 1
	end
	B738DR_eng1_wings_lights[3] = B738DR_cowl_ice_0_on * dimmed
	dimmed = 0.35
	if B738DR_cowl_ice_1_on == 1 then
		dimmed = 1
	end
	B738DR_eng2_wings_lights[3] = B738DR_cowl_ice_1_on * dimmed
	dimmed = 0.35
	if B738DR_ground_power_avail_annun == 1 then
		dimmed = 1
	end
	B738DR_gpu_avail_lights[3] = B738DR_ground_power_avail_annun * dimmed
	dimmed = 0.35
	if B738DR_eng1_valve_closed_annun == 1 then
		dimmed = 1
	end
	B738DR_eng1_valve_lights[3] = B738DR_eng1_valve_closed_annun * dimmed
	dimmed = 0.35
	if B738DR_eng2_valve_closed_annun == 1 then
		dimmed = 1
	end
	B738DR_eng2_valve_lights[3] = B738DR_eng2_valve_closed_annun * dimmed
	dimmed = 0.35
	if B738DR_spar1_valve_closed_annun == 1 then
		dimmed = 1
	end
	B738DR_eng1_spar_lights[3] = B738DR_spar1_valve_closed_annun * dimmed
	dimmed = 0.35
	if B738DR_spar2_valve_closed_annun == 1 then
		dimmed = 1
	end
	B738DR_eng2_spar_lights[3] = B738DR_spar2_valve_closed_annun * dimmed
	dimmed = 0.35
	if B738DR_ram_door_open1 == 1 then
		dimmed = 1
	end
	B738DR_ram1_full_lights[3] = B738DR_ram_door_open1 * dimmed
	dimmed = 0.35
	if B738DR_ram_door_open2 == 1 then
		dimmed = 1
	end
	B738DR_ram2_full_lights[3] = B738DR_ram_door_open2 * dimmed
	dimmed = 0.35
	if B738DR_crossfeed == 1 then
		dimmed = 1
	end
	B738DR_crossfeed_lights[3] = B738DR_crossfeed * dimmed
	
	B738DR_gen1_avail_lights[3] = B738DR_gen_off_bus1
	B738DR_gen2_avail_lights[3] = B738DR_gen_off_bus2
	B738DR_apu_avail_lights[3] = B738DR_apu_gen_off_bus
	
end


--*************************************************************************************--
--** 				               XLUA EVENT CALLBACKS       	        			 **--
--*************************************************************************************--

function aircraft_load()

B738_init_lighting()

end


--function aircraft_unload() end

function flight_start()

simDR_generic_brightness_switch63 = 1
simDR_generic_brightness_switch62 = 1
B738DR_elt_switch_pos = 0
--B738DR_emer_exit_lights_switch = 1
B738DR_audio_panel_capt_mic1_pos = 1
B738DR_audio_panel_fo_mic3_pos = 1
B738DR_audio_panel_obs_mic6_pos = 1

fuel_six_pack_old = 0
fuel_six_pack_ann = 0
apu_six_pack_old = 0
apu_six_pack_ann = 0
ovht_det_six_pack_old = 0
ovht_det_six_pack_ann = 0
irs_fail_old = 0
irs_fail_ann = 0
elec_fail_old = 0
elec_fail_ann = 0
six_pack_ice_status_old = 0
flt_cont_ann = 0
flt_cont_old = 0
six_pack_ice_status_ann = 0
six_pack_hydro_old = 0
six_pack_hydro_ann = 0
door_open_status_old = 0
door_open_status_ann = 0
six_pack_eng_old = 0
six_pack_eng_ann = 0
six_pack_ovhd_old = 0
six_pack_ovhd_ann = 0
six_pack_air_cond_old = 0
six_pack_air_cond_ann = 0

flt_cont_last = 0
irs_fail_last = 0
fuel_six_pack_last = 0
elec_fail_last = 0
apu_six_pack_last = 0
ovht_det_six_pack_last = 0

six_pack_ice_status_last = 0
six_pack_hydro_last = 0
door_open_status_last = 0
six_pack_eng_last = 0
six_pack_ovhd_last = 0
six_pack_air_cond_last = 0

off_sched_desc = 0
last_alt = 0
off_sched_desc_enable = 0

spar_valve_1_pos = 0
spar_valve_1_tgt = 0
spar_valve_2_pos = 0
spar_valve_2_tgt = 0
wing_body_ovht_test = 0
fdr_test = 0

end

--function flight_crash() end

--function before_physics() end

function after_physics()

	if B738DR_kill_annun == 0 then
		B738_annunciators()
		B738_spill_lights()
		--B738_external_power()
		B738_battery_disch_annun()
		test_timer()
	end

end

--function after_replay() end




--*************************************************************************************--
--** 				               SUB-MODULE PROCESSING       	        			 **--
--*************************************************************************************--

-- dofile("")



