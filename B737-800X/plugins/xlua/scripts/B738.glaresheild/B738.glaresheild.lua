--[[
*****************************************************************************************
* Program Script Name	:	B738.glaresheild
*
* Author Name			:	Alex Unruh
*
*   Revisions:
*   -- DATE --	--- REV NO ---		--- DESCRIPTION ---
*   2016-08-26	0.01a				Start of Dev
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

-- PFD SPEED MODES
PFD_SPD_ARM = 1
PFD_SPD_N1 = 2
PFD_SPD_MCP_SPD = 3
PFD_SPD_FMC_SPD = 4
PFD_SPD_GA = 5
PFD_SPD_THR_HLD = 6
PFD_SPD_RETARD = 7

-- PFD ROLL MODES
PFD_HDG_HDG_SEL = 1
PFD_HDG_VOR_LOC = 2
PFD_HDG_LNAV = 3
PFD_HDG_ROLLOUT = 4
PFD_HDG_FAC = 5

-- PFD PITCH MODES
PFD_ALT_VS = 1
PFD_ALT_MCP_SPD = 2
PFD_ALT_ALT_ACQ = 3
PFD_ALT_ALT_HOLD = 4
PFD_ALT_GS = 5
PFD_ALT_FLARE = 6
PFD_ALT_GP = 7
PFD_ALT_VNAV_SPD = 8
PFD_ALT_VNAV_PTH = 9
PFD_ALT_VNAV_ALT = 10
PFD_ALT_TO_GA = 11

-- PFD ROLL MODES ARM
PFD_HDG_VOR_LOC_ARM = 1
PFD_HDG_ROLLOUT_ARM = 2
PFD_HDG_LNAV_ARM = 3
PFD_HDG_FAC_ARM = 4

-- PFD PITCH MODES ARM
PFD_ALT_GS_ARM = 1
PFD_ALT_VS_ARM = 2
PFD_ALT_FLARE_ARM = 3
PFD_ALT_GP_ARM = 4
PFD_ALT_VNAV_ARM = 5
 
-- -- 5,7
-- n1_correct = 
	-- {
	-- [0]     = {  3,  3},
	-- [5000]  = { 19, 10},
	-- [10000] = { 23, 18},
	-- [15000] = { 27, 20.5},
	-- [20000] = { 32, 25},
	-- [25000] = { 38, 30},
	-- [30000] = { 44, 35},
	-- [35000] = { 45, 40},
	-- [40000] = { 50, 44}
	-- }

n1_correct = 
	{
	[0]     = {  3,  4},
	[5000]  = { 19, 16},
	[10000] = { 23, 18},
	[15000] = { 27, 20.5},
	[20000] = { 32, 25},
	[25000] = { 38, 30},
	[30000] = { 44, 35},
	[35000] = { 45, 40},
	[40000] = { 50, 44}
	}


n1_flt = 
	{
	[0]     = { [60] = 0.441, [70] = 0.592, [80] = 0.740, [90] = 0.884, [100] = 1.026 },
	[10000] = { [60] = 0.450, [70] = 0.601, [80] = 0.749, [90] = 0.895, [100] = 1.037 },
	[20000] = { [60] = 0.510, [70] = 0.647, [80] = 0.782, [90] = 0.913, [100] = 1.040 },
	[30000] = { [60] = 0.468, [70] = 0.622, [80] = 0.774, [90] = 0.918, [100] = 1.040 },
	[40000] = { [60] = 0.480, [70] = 0.629, [80] = 0.778, [90] = 0.924, [100] = 1.040 }
	}
	
n1_flt_max = { [0] = 100, [10000] = 100, [20000] = 99.9, [30000] = 98.6, [40000] = 98.1 }

n1_app = {
	[0]     = { [60] = 0.377, [70] = 0.545, [80] = 0.710, [90] = 0.871, [100] = 1.030 },
	[10000] = { [60] = 0.388, [70] = 0.556, [80] = 0.721, [90] = 0.883, [100] = 1.040 },
	[20000] = { [60] = 0.398, [70] = 0.568, [80] = 0.731, [90] = 0.893, [100] = 1.040 },
	[30000] = { [60] = 0.404, [70] = 0.578, [80] = 0.748, [90] = 0.908, [100] = 1.040 },
	[40000] = { [60] = 0.418, [70] = 0.588, [80] = 0.752, [90] = 0.915, [100] = 1.040 }
	}

n1_app_max = { [0] = 100, [10000] = 99.9, [20000] = 99.4, [30000] = 98.3, [40000] = 97.9 }


eng1_N1_thrust = 0.97				-- engine 1 N1 THRUST = 97%
eng2_N1_thrust = 0.97			-- engine 2 N1 THRUST = 97%
N1_takeoff_thrust = 1.00		-- N1 TAKEOFF THRUST = 100%
N1_goaround_thrust = 1.00		-- N1 GOAROUND THRUST = 100%

fmc_speed_cur = 145.0

blink_rec_thr_status = 0
blink_rec_thr2_status = 0
blink_rec_hdg_status = 0
blink_rec_alt_status = 0
blink_rec_cmd_status1 = 0
blink_rec_cmd_status2 = 0
blink_rec_sch_status = 0
blink_rec_alt_alert_status = 0
blink_to_ga = 0
blink_out = 0

pfd_spd_old = 0
pfd_hdg_old = 0
pfd_alt_old = 0


autothrottle_pfd_old = 0
autothrottle_status_old = 0
retard_status_old = 0
n1_status_old = 0
fmc_spd_status_old = 0
alt_mode_status_old = 0
vnav_alt_status_old = 0
vnav_pth_status_old = 0
vnav_spd_status_old = 0
flare_status_old = 0
hdg_mode_status_old = 0
ga_pfd_old = 0
thr_hld_pfd_old = 0
to_ga_pfd_old = 0
alt_acq_pfd_old = 0
cmd_old1 = 0
cmd_old2 = 0
single_ch_status_old = 0

vvi_rate = 0

null_vvi = 0

ap_speed_mode = 0
ap_pitch_mode = 0
ap_roll_mode = 0
ap_roll_mode_old2 = 0
ap_pitch_mode_eng = 0
ap_roll_mode_eng = 0
ap_on = 0
ap_on_first = 0
at_on_first = 0
cws_on = 0
cws_on_first = 0
ap_disco_first = 0
ap_dis_time = 0
at_dis_time = 0
mem_airspeed_dial = 100
mem_speed_mode = 0
at_mode = 0
at_mode_eng = 0
ap_pitch_mode_old = 0
ap_roll_mode_old = 0
approach_status_old = 0
glideslope_status_old = 0
takeoff_n1 = 0
-- ap_goaround = 0
-- fd_goaround = 0
cmd_first = 0
--simDR_ap_vvi_dial_cur = 0
simDR_ap_altitude_dial_ft_old = 0
ap_app_block = 0
ap_app_block_800 = 0
ils_test_enable = 0
ils_test_on = 0
ils_test_ok = 0
fd_cur = 0
--fd_target = 0
fd_target_rate = 0
flare_vvi_old = 0
ap_vnav_status = 0
vnav_descent = 0
vnav_active = 0
--vnav_active2 = 0
vnav_cruise = 0
vnav_altitude_dial = 0
--vnav_speed_dial = 200
--vnav_speed_dial2 = 0
vnav_thrust = 0
--vnav_block_thrust = 0
course_pilot = 0
to_after_80kts = 0
lift_off_150 = 0
on_ground_30 = 1
ap_goaround_block = 0
to_thrust_set = 0
ias_disagree = 0
alt_disagree = 0
vnav_speed_cur = 0
vnav_alt = 0
--vnav_speed = 0
vnav_speed_delta = 0
vnav_speed_trg_old = 0

eng1_N1_man = 0.984
eng2_N1_man = 0.984

eng1_N1_thrust_trg = 0
eng2_N1_thrust_trg = 0
eng1_N1_thrust_cur = 0
eng2_N1_thrust_cur = 0

at_throttle_hold = 0
init_climb = 0

baro_sel_old = 0
baro_sel_co_old = 0

lnav_app = 0
lnav_vorloc = 0
dme_dist = 0
dme_dist_old = 100

fmc_vvi_cur = 0
vvi_trg = 0
lvl_vvi_trg = 0

thrust1 = 0
thrust2 = 0
--ed_alt = 0
airspeed_pilot_old = 0
v_speed_pilot_old = 0
vdot_ratio_old = 0
radio_height_old = 0
radio_height_ratio = 0
altitude_pilot_old = 0
air_on_acf_old = 0
eng1_N1 = 0
eng1_N1_old = 0
eng2_N1 = 0
eng2_N1_old = 0

nav_id_old = "*"
vnav_vs = 0
lvl_chg_vs = 0
vnav_alt_hld = 0
altitude_dial_ft_old = 0

reverse_max_enable1 = 0
reverse_max_on1 = 0
reverse_max_enable2 = 0
reverse_max_on2 = 0

radio_dh_pilot = 0
baro_dh_pilot = 0
baro_dh_pilot_disable = 0
radio_dh_copilot = 0
baro_dh_copilot = 0
baro_dh_copilot_disable = 0
--vnav_descent_disable = 0
--mcp_intv_speed = 0
dh_minimum_pilot = 0
dh_minimum_copilot = 0
dh_min_enable_pilot = 0
dh_min_enable_copilot = 0
dh_min_block_pilot = 0
dh_min_block_copilot = 0

vnav_init = 0
vnav_init2 = 0

vs_first = 0
vnav_alt_hold = 0
vnav_alt_hold_act = 0
mcp_alt_hold = 0
rest_wpt_alt_old = 0
vnav_engaged = 0
--lnav_engaged = 0	-- dataref

--vnav_alt_mode = 0

thr1_target = 0
thr2_target = 0

roll_mode_old = 0
pitch_mode_old = 0
at_on_old = 0
ap_disco_do = 0

vnav_desc_spd = 0
vnav_desc_protect_spd = 0

--fac_engaged = 0
--loc_gp_engaged = 0
rest_wpt_alt_idx_old = 0

dh_timer = 0
DH_STEP = 0.1	-- step 0.1 sec
dh_timer2 = 0
DH_STEP2 = 2.0	-- step 2.0 sec

axis_throttle_old = 0
axis_throttle1_old = 0
axis_throttle2_old = 0
--lock_throttle = 0
ap_disco2 = 0

mcp_hdg_timer = 0
turn_corr = 0
turn_active = 0
intdir_act = 0

thr1_anim = 0
thr2_anim = 0
--ap_wca_tgt = 0
ap_wca = 0
fd_go_disable = 0

vert_spd_timer = 0
vert_spd_timer2 = 0
at_status = 0
lvl_chg_co_status = 0

at_left_press = 0
at_right_press = 0

master_light_block_act = 0

cpt_tcas_enable = 1
fo_tcas_enable = 1
cpt_terr_enable = 0
fo_terr_enable = 0
cpt_pos_enable = 0
fo_pos_enable = 0

autothr_arm_pos = 0
autopilot_side = 0

mcp_hdg_dial_old = 0
hide_hdg_line = 0
hide_hdg_line_fo = 0
	
measure = 0
airspeed_dial_kts_old = 0

alt_acq_disable = 0

yoke_servo = 0

spd_ratio = 0
spd_ratio_old = 0
spd_ratio_sum = 0
spd_ratio_num = 0
time_spd_ratio = 0

gnd_spd_ratio = 0
gnd_spd_ratio_old = 0

dspl_ctrl_pnl_old = 0
in_hpa_cnt = 0

--*************************************************************************************--
--** 					               CONSTANTS                    				 **--
--*************************************************************************************--

local autopilot_cmd_a_status = 0
local autopilot_cmd_b_status = 0
local autopilot_cws_a_status = 0
local autopilot_cws_b_status = 0

local autopilot_fms_nav_status = 0
-- = 0 in vorloc mode and 1 in lnav mode, buttons swap. Use this to determine NAV 1,2, FMS Selection logic

--*************************************************************************************--
--** 					            GLOBAL VARIABLES                				 **--
--*************************************************************************************--

local alt_timer = 0
local alt_up_active = 0
local alt_dn_active = 0
local crs1_timer = 0
local crs1_up_active = 0
local crs1_dn_active = 0
local crs2_timer = 0
local crs2_up_active = 0
local crs2_dn_active = 0
local baro_pilot_timer = 0
local baro_pilot_up_active = 0
local baro_pilot_dn_active = 0
local baro_copilot_timer = 0
local baro_copilot_up_active = 0
local baro_copilot_dn_active = 0
local aircraft_was_on_air = 0
local bellow_400ft = 0

--*************************************************************************************--
--** 					            LOCAL VARIABLES                 				 **--
--*************************************************************************************--

local altitude_dial_ft = 0
local yoke_pitch = 0
local yoke_pitch2 = 0
local vorloc_only = 0
local throttle = 0

SPD_act2 = 0
spd_ratio2 = 0
lock_at = 0
at_lock_time = 0
at_lock_num = 0
at_spd_ratio = 0
at_lock_time2 = 0
at_spd = 0

SPD_err_old = 0
SPD_p = 0
SPD_i = 0
SPD_d = 0
SPD_out = 0
pid_time = 0
thr1_target_pid = 0
thr2_target_pid = 0
mcp_dial_old = 0
wind_acf_old = 0

ghust_spd = 0
ghust_detect = 0
ghust_detect2 = 0
block_ghust = 0
ghust_detect_block = 0
--SPD_ratio2 = 0
wind_hdg_old = 0
wind_spd_old = 0
wind_hdg_rel_old = 0

altitude_mode_old = 0

capt_exp_map_mode = 0
fo_exp_map_mode = 0
capt_vsd_map_mode = 0
fo_vsd_map_mode = 0
capt_exp_vor_app_mode = 0
fo_exp_vor_app_mode = 0

rudder_out = 0
rudder_target = 0
hdg_ratio_old = 0
hdg_ratio = 0

-- AP_airspeed = 0
-- AP_airspeed_mach = 0

--*************************************************************************************--
--** 				             FIND X-PLANE DATAREFS            			    	 **--
--*************************************************************************************--
--B738DR_data_test			= find_dataref("laminar/B738/data_test")

simDR_barometer_setting_capt 	= find_dataref("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot")
simDR_barometer_setting_fo		= find_dataref("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_copilot")

--simDR_decision_height_capt		= find_dataref("sim/cockpit2/gauges/actuators/radio_altimeter_bug_ft_pilot")
--simDR_decision_height_fo		= find_dataref("sim/cockpit2/gauges/actuators/radio_altimeter_bug_ft_copilot")

simDR_map_mode_is_HSI			= find_dataref("sim/cockpit2/EFIS/map_mode_is_HSI")

simDR_vor1_capt					= find_dataref("sim/cockpit2/EFIS/EFIS_1_selection_pilot")
simDR_vor2_capt					= find_dataref("sim/cockpit2/EFIS/EFIS_2_selection_pilot")
simDR_vor1_fo					= find_dataref("sim/cockpit2/EFIS/EFIS_1_selection_copilot")
simDR_vor2_fo					= find_dataref("sim/cockpit2/EFIS/EFIS_2_selection_copilot")

simDR_efis_ndb					= find_dataref("sim/cockpit2/EFIS/EFIS_ndb_on")


----- AUTOPILOT DATAREFS

simDR_autothrottle_status		= find_dataref("sim/cockpit2/autopilot/autothrottle_on")
simDR_autopilot_altitude_mode	= find_dataref("sim/cockpit2/autopilot/altitude_mode")
simDR_autopilot_heading_mode	= find_dataref("sim/cockpit2/autopilot/heading_mode")

simDR_autopilot_approach		= find_dataref("sim/cockpit2/autopilot/approach_status")

simDR_servos_on					= find_dataref("sim/cockpit2/autopilot/servos_on")
simDR_bank_angle				= find_dataref("sim/cockpit2/autopilot/bank_angle_mode")
simDR_flight_dir_mode			= find_dataref("sim/cockpit2/autopilot/flight_director_mode")

simDR_approach_status			= find_dataref("sim/cockpit2/autopilot/approach_status")
simDR_glideslope_status			= find_dataref("sim/cockpit2/autopilot/glideslope_status")
simDR_roll_status				= find_dataref("sim/cockpit2/autopilot/roll_status")
simDR_alt_hold_status			= find_dataref("sim/cockpit2/autopilot/altitude_hold_status")
simDR_vvi_status				= find_dataref("sim/cockpit2/autopilot/vvi_status")

simDR_autopilot_source			= find_dataref("sim/cockpit2/radios/actuators/HSI_source_select_pilot")
simDR_autopilot_fo_source		= find_dataref("sim/cockpit2/radios/actuators/HSI_source_select_copilot")

simDR_autopilot_side			= find_dataref("sim/cockpit2/autopilot/autopilot_source")

simDR_nav_status				= find_dataref("sim/cockpit2/autopilot/nav_status")

simDR_autopilot_on				= find_dataref("sim/cockpit2/autopilot/autopilot_on")

simDR_ap_capt_heading			= find_dataref("sim/cockpit2/autopilot/heading_dial_deg_mag_pilot")
simDR_ap_fo_heading				= find_dataref("sim/cockpit2/autopilot/heading_dial_deg_mag_copilot")

simDR_airspeed_dial				= find_dataref("sim/cockpit2/autopilot/airspeed_dial_kts_mach")
simDR_airspeed_dial_kts			= find_dataref("sim/cockpit2/autopilot/airspeed_dial_kts")

-- 0 for NAV1, 1 for NAV2, 2 for FMS/GPS

simDR_EFIS_mode					= find_dataref("sim/cockpit2/EFIS/map_mode")
--simDR_EFIS_WX					= find_dataref("sim/cockpit2/EFIS/EFIS_weather_on")
simDR_EFIS_TCAS					= find_dataref("sim/cockpit2/EFIS/EFIS_tcas_on")

simDR_ap_altitude_dial_ft		= find_dataref("sim/cockpit2/autopilot/altitude_dial_ft")
simDR_ap_vvi_dial				= find_dataref("sim/cockpit2/autopilot/vvi_dial_fpm")

---- CUSTOM
simDR_radio_height_pilot_ft		= find_dataref("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot")
simDR_radio_height_copilot_ft	= find_dataref("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_copilot")
simDR_throttle_all				= find_dataref("sim/cockpit2/engine/actuators/throttle_ratio_all")
simDR_yoke_pitch				= find_dataref("sim/cockpit2/controls/yoke_pitch_ratio")
simDR_aircraft_on_ground		= find_dataref("sim/flightmodel/failures/onground_all")
simDR_on_ground_0				= find_dataref("sim/flightmodel2/gear/on_ground[0]")
simDR_on_ground_1				= find_dataref("sim/flightmodel2/gear/on_ground[1]")
simDR_on_ground_2				= find_dataref("sim/flightmodel2/gear/on_ground[2]")
simDR_vvi_fpm_pilot				= find_dataref("sim/cockpit2/gauges/indicators/vvi_fpm_pilot")
simDR_vvi_fpm_copilot			= find_dataref("sim/cockpit2/gauges/indicators/vvi_fpm_copilot")
simDR_elevator_trim				= find_dataref("sim/cockpit2/controls/elevator_trim")

simDR_hsi_crs1					= find_dataref("sim/cockpit2/radios/actuators/hsi_obs_deg_mag_pilot")
simDR_hsi_crs2					= find_dataref("sim/cockpit2/radios/actuators/hsi_obs_deg_mag_copilot")
simDR_brake						= find_dataref("sim/cockpit2/controls/parking_brake_ratio")
simDR_autobrake_level			= find_dataref("sim/cockpit2/switches/auto_brake_level")
simDR_airspeed_pilot			= find_dataref("sim/cockpit2/gauges/indicators/airspeed_kts_pilot")
simDR_airspeed_mach_pilot		= find_dataref("sim/cockpit2/gauges/indicators/mach_pilot")
simDR_airspeed_accel_pilot		= find_dataref("sim/cockpit2/gauges/indicators/airspeed_acceleration_kts_sec_pilot")
simDR_altitude_pilot			= find_dataref("sim/cockpit2/gauges/indicators/altitude_ft_pilot")
simDR_airspeed_copilot			= find_dataref("sim/cockpit2/gauges/indicators/airspeed_kts_copilot")
simDR_airspeed_mach_copilot		= find_dataref("sim/cockpit2/gauges/indicators/mach_copilot")
simDR_altitude_copilot			= find_dataref("sim/cockpit2/gauges/indicators/altitude_ft_copilot")

simDR_airspeed_is_mach			= find_dataref("sim/cockpit2/autopilot/airspeed_is_mach")
simDR_mach_no					= find_dataref("sim/flightmodel/misc/machno")


simDR_engine_N1_pct1			= find_dataref("sim/cockpit2/engine/indicators/N1_percent[0]")
simDR_engine_N1_pct2			= find_dataref("sim/cockpit2/engine/indicators/N1_percent[1]")

simDR_throttle_1				= find_dataref("sim/cockpit2/engine/actuators/throttle_ratio[0]")
simDR_throttle_2				= find_dataref("sim/cockpit2/engine/actuators/throttle_ratio[1]")
simDR_throttle_override			= find_dataref("sim/operation/override/override_throttles")
simDR_throttle1_use				= find_dataref("sim/flightmodel/engine/ENGN_thro_use[0]")
simDR_throttle2_use				= find_dataref("sim/flightmodel/engine/ENGN_thro_use[1]")
simDR_throttle1_in				= find_dataref("sim/flightmodel/engine/ENGN_thro[0]")
simDR_throttle2_in 				= find_dataref("sim/flightmodel/engine/ENGN_thro[1]")

simDR_joy_pitch_override		= find_dataref("sim/operation/override/override_joystick_pitch")

simDR_autothrottle_enable		= find_dataref("sim/cockpit2/autopilot/autothrottle_enabled")

simDR_heading_pilot				= find_dataref("sim/cockpit2/gauges/indicators/heading_AHARS_deg_mag_pilot")
simDR_flaps_ratio				= find_dataref("sim/cockpit2/controls/flap_handle_deploy_ratio")
--simDR_flaps_ratio				= find_dataref("sim/flightmodel2/controls/flap1_deploy_ratio")

simDR_fdir_pitch_ovr			= find_dataref("sim/operation/override/override_flightdir_ptch")
simDR_fdir_roll_ovr				= find_dataref("sim/operation/override/override_flightdir_roll")
simDR_fdir_pitch				= find_dataref("sim/cockpit/autopilot/flight_director_pitch")
simDR_fdir_roll					= find_dataref("sim/cockpit/autopilot/flight_director_roll")
simDR_ahars_pitch_deg_pilot		= find_dataref("sim/cockpit2/gauges/indicators/pitch_AHARS_deg_pilot")
simDR_ahars_pitch_deg_copilot	= find_dataref("sim/cockpit2/gauges/indicators/pitch_AHARS_deg_copilot")

simDR_total_weight				= find_dataref("sim/flightmodel/weight/m_total")

--simDR_eng1_reverser_on			= find_dataref("sim/cockpit2/annunciators/reverser_on[0]")
--simDR_eng2_reverser_on			= find_dataref("sim/cockpit2/annunciators/reverser_on[1]")

simDR_vnav_status				= find_dataref("sim/cockpit2/autopilot/fms_vnav")
simDR_vnav_tod_nm				= find_dataref("sim/cockpit2/radios/indicators/fms_distance_to_tod_pilot")
simDR_fms_fpta					= find_dataref("sim/cockpit2/radios/indicators/fms_fpta_pilot")
simDR_fms_vtk					= find_dataref("sim/cockpit2/radios/indicators/fms_vtk_pilot")
simDR_tod_before				= find_dataref("sim/cockpit2/radios/indicators/fms_tod_before_distance_pilot")
simDR_fms_override 				= find_dataref("sim/operation/override/override_fms_advance")

simDR_elevation_m				= find_dataref("sim/flightmodel/position/elevation")

simDR_efis_map_range			= find_dataref("sim/cockpit2/EFIS/map_range")
simDR_ground_spd				= find_dataref("sim/flightmodel/position/groundspeed")

simDR_reverse1_deploy			= find_dataref("sim/flightmodel2/engines/thrust_reverser_deploy_ratio[0]")
simDR_reverse2_deploy			= find_dataref("sim/flightmodel2/engines/thrust_reverser_deploy_ratio[1]")
simDR_engine_mixture1			= find_dataref("sim/cockpit2/engine/actuators/mixture_ratio[0]")
simDR_engine_mixture2			= find_dataref("sim/cockpit2/engine/actuators/mixture_ratio[1]")

simDR_vdot_nav1_pilot			= find_dataref("sim/cockpit2/radios/indicators/hsi_vdef_dots_pilot")
--simDR_vdot_nav1_pilot			= 999

--simDR_dme_dist				= find_dataref("sim/cockpit2/radios/indicators/gps_dme_distance_nm")
simDR_dme_dist					= find_dataref("laminar/B738/fms/lnav_dist_next")



simDR_glideslope_armed			= find_dataref("sim/cockpit2/autopilot/glideslope_armed")
simDR_gps_nav_id				= find_dataref("sim/cockpit2/radios/indicators/gps_nav_id")

simDR_reverse1_act				= find_dataref("sim/cockpit2/engine/actuators/prop_mode[0]")
simDR_reverse2_act				= find_dataref("sim/cockpit2/engine/actuators/prop_mode[1]")

simDR_mag_hdg					= find_dataref("sim/cockpit2/gauges/indicators/ground_track_mag_pilot")

simDR_dh_pilot					= find_dataref("sim/cockpit2/gauges/actuators/radio_altimeter_bug_ft_pilot")
simDR_dh_copilot				= find_dataref("sim/cockpit2/gauges/actuators/radio_altimeter_bug_ft_copilot")

simDR_ahars_mag_hdg		= find_dataref("sim/cockpit2/gauges/indicators/heading_AHARS_deg_mag_pilot")
simDR_mag_variation		= find_dataref("sim/flightmodel/position/magnetic_variation")


simDR_efis_map_mode		= find_dataref("sim/cockpit/switches/EFIS_map_mode")
simDR_efis_sub_mode		= find_dataref("sim/cockpit/switches/EFIS_map_submode")

simDR_efis_vor_on		= find_dataref("sim/cockpit2/EFIS/EFIS_vor_on")
simDR_efis_apt_on		= find_dataref("sim/cockpit2/EFIS/EFIS_airport_on")
simDR_efis_fix_on		= find_dataref("sim/cockpit2/EFIS/EFIS_fix_on")
simDR_efis_wxr_on		= find_dataref("sim/cockpit2/EFIS/EFIS_weather_on")

simDR_servo_pitch_ratio		= find_dataref("sim/joystick/servo_pitch_ratio")
simDR_servo_roll_ratio		= find_dataref("sim/joystick/servo_roll_ratio")
simDR_servo_heading_ratio	= find_dataref("sim/joystick/servo_heading_ratio")

simDR_heading_ratio			= find_dataref("sim/joystick/yoke_heading_ratio")
simDR_pitch_ratio			= find_dataref("sim/joystick/yoke_pitch_ratio")
simDR_roll_ratio			= find_dataref("sim/joystick/yoke_roll_ratio")

simDR_heading_ratio2		= find_dataref("sim/cockpit2/controls/yoke_heading_ratio")
simDR_pitch_ratio2			= find_dataref("sim/cockpit2/controls/yoke_pitch_ratio")
simDR_roll_ratio2			= find_dataref("sim/cockpit2/controls/yoke_roll_ratio")

--- VNAV
--td_dist						= find_dataref("laminar/B738/fms/td_dist")
B738DR_vnav_td_dist 		= find_dataref("laminar/B738/fms/vnav_td_dist")
B738DR_vnav_pth_alt			= find_dataref("laminar/B738/fms/vnav_pth_alt")
B738DR_vnav_alt_err			= find_dataref("laminar/B738/fms/vnav_alt_err")
B738DR_vnav_vvi				= find_dataref("laminar/B738/fms/vnav_vvi")
B738DR_vnav_vvi_corr		= find_dataref("laminar/B738/fms/vnav_vvi_corr")
B738DR_vnav_err_pfd			= find_dataref("laminar/B738/fms/vnav_err_pfd")

B738DR_gp_vvi			= find_dataref("laminar/B738/fms/gp_vvi")
B738DR_gp_vvi_corr		= find_dataref("laminar/B738/fms/gp_vvi_corr")
B738DR_gp_err_pfd		= find_dataref("laminar/B738/fms/gp_err_pfd")
B738DR_gp_alt_err 		= find_dataref("laminar/B738/fms/gp_alt_err")
B738DR_gp_pth_alt 		= find_dataref("laminar/B738/fms/gp_pth_alt")
B738DR_fac_xtrack		= find_dataref("laminar/B738/fms/fac_xtrack")
B738DR_fac_trk			= find_dataref("laminar/B738/fms/fac_trk")
B738DR_pfd_gp_path		= find_dataref("laminar/B738/fms/pfd_gp_path")

td_fix_dist 				= find_dataref("laminar/B738/fms/vnav_td_fix_dist")

B738DR_rnav_enable			= find_dataref("laminar/B738/fms/rnav_enable")
B738DR_gp_active			= find_dataref("laminar/B738/fms/vnav_gp_active")
B738DR_vnav_app_active		= find_dataref("laminar/B738/fms/vnav_app_active")

B738DR_end_route			= find_dataref("laminar/B738/fms/end_route")
B738DR_no_perf				= find_dataref("laminar/B738/fms/no_perf")

B738DR_vnav_desc_spd_disable = find_dataref("laminar/B738/fms/vnav_desc_spd_disable")


simDR_wind_hdg				= find_dataref("sim/cockpit2/gauges/indicators/wind_heading_deg_mag")
simDR_wind_spd				= find_dataref("sim/cockpit2/gauges/indicators/wind_speed_kts")

simDR_airspeed_accel		= find_dataref("sim/cockpit2/gauges/indicators/airspeed_acceleration_kts_sec_pilot")

simDR_fmc_crs				= find_dataref("laminar/B738/fms/gps_course_degtm")
simDR_fmc_trk				= find_dataref("laminar/B738/fms/gps_track_degtm")
simDR_fmc_trk2				= find_dataref("laminar/B738/fms/gps_track2_degtm")
simDR_TAS					= find_dataref("sim/flightmodel/position/true_airspeed")
simDR_fmc_trk_turn			= find_dataref("laminar/B738/fms/gps_track_turn")
simDR_fmc_trk_turn2			= find_dataref("laminar/B738/fms/gps_track_turn2")
B738DR_hold_phase			= find_dataref("laminar/B738/fms/hold_phase")
legs_intdir_act				= find_dataref("laminar/B738/fms/intdir_act")
nav_mode					= find_dataref("laminar/B738/fms/nav_mode")

B738DR_track_up				= find_dataref("laminar/B738/fms/track_up")

B738DR_afs_spd_limit_max 	= find_dataref("laminar/B738/FMS/afs_spd_limit_max")
B738DR_pfd_min_speed		= find_dataref("laminar/B738/pfd/min_speed")

B738DR_dspl_ctrl_pnl 		= find_dataref("laminar/B738/toggle_switch/dspl_ctrl_pnl")

simDR_override_heading		= find_dataref("sim/operation/override/override_joystick_heading")
simDR_rudder_trim			= find_dataref("sim/cockpit2/controls/rudder_trim")
simDR_control_hdg_ratio		= find_dataref("sim/flightmodel2/controls/heading_ratio")
simDR_nav1_hdef_pilot		= find_dataref("sim/cockpit2/radios/indicators/nav1_hdef_dots_pilot")

--*************************************************************************************--
--** 				               FIND X-PLANE COMMANDS                   	    	 **--
--*************************************************************************************--

simCMD_efis_wxr = find_command("sim/instruments/EFIS_wxr")
simCMD_efis_sta = find_command("sim/instruments/EFIS_vor")
simCMD_efis_wpt = find_command("sim/instruments/EFIS_fix")
simCMD_efis_arpt = find_command("sim/instruments/EFIS_apt")
simCMD_efis_tfc = find_command("sim/instruments/EFIS_tcas")

---- AUTOPILOT COMMANDS

simCMD_autothrottle			= find_command("sim/autopilot/autothrottle_toggle")
simCMD_autothrottle_on		= find_command("sim/autopilot/autothrottle_on")
simCMD_autothrottle_off		= find_command("sim/autopilot/autothrottle_off")

simCMD_autopilot_vnav		= find_command("sim/autopilot/FMS")
simCMD_autopilot_lvl_chg	= find_command("sim/autopilot/level_change")
simCMD_autopilot_hdg		= find_command("sim/autopilot/heading")
simCMD_autopilot_lnav		= find_command("sim/autopilot/NAV")
simCMD_autopilot_app		= find_command("sim/autopilot/approach")
simCMD_autopilot_alt_hold	= find_command("sim/autopilot/altitude_hold")
simCMD_autopilot_vs			= find_command("sim/autopilot/vertical_speed")
simCMD_autopilot_vs_sel		= find_command("sim/autopilot/vertical_speed_pre_sel")

simCMD_autopilot_fd			= find_command("sim/autopilot/fdir_toggle")
simCMD_autopilot_servos		= find_command("sim/autopilot/servos_toggle")
simCMD_autopilot_cws		= find_command("sim/autopilot/control_wheel_steer")

simCMD_disconnect			= find_command("sim/autopilot/servos_fdir_off")

simCMD_autopilot_co			= find_command("sim/autopilot/knots_mach_toggle")
simCMD_flight_director		= find_command("sim/autopilot/fdir_on")
simCMD_autothrottle_discon	= find_command("sim/autopilot/autothrottle_off")

simCMD_source_nav1			= find_command("sim/autopilot/hsi_select_nav_1")
simCMD_source_nav2			= find_command("sim/autopilot/hsi_select_nav_2")
simCDM_source_FMS			= find_command("sim/autopilot/hsi_select_gps")

simCMD_source_fo_nav1		= find_command("sim/autopilot/hsi_select_copilot_nav_1")
simCMD_source_fo_nav2		= find_command("sim/autopilot/hsi_select_copilot_nav_2")
simCDM_source_fo_FMS		= find_command("sim/autopilot/hsi_select_copilot_gps")

simCMD_servos_on			= find_command("sim/autopilot/servos_on")
--simCMD_take_off_go_around	= find_command("sim/autopilot/take_off_go_around")
--simCMD_autopilot_up			= find_command("sim/autopilot/override_up")
--simCMD_autopilot_dn			= find_command("sim/autopilot/override_down")

simCMD_fdir_up				= find_command("sim/autopilot/fdir_servos_up_one")
simCMD_fdir_dn				= find_command("sim/autopilot/fdir_servos_down_one")

--simCMD_nosmoking_toggle		= find_command("sim/systems/no_smoking_toggle")

simCMD_FMS_key_1L		= find_command("sim/FMS/ls_1l")
simCMD_FMS_key_2L		= find_command("sim/FMS/ls_2l")
simCMD_FMS_key_dir_intc	= find_command("sim/FMS/dir_intc")
simCMD_FMS_key_legs		= find_command("sim/FMS/legs")
simCMD_FMS_key_fpln		= find_command("sim/FMS/fpln")
simCMD_FMS_key_clear	= find_command("sim/FMS/key_clear")
simCMD_FMS_key_delete	= find_command("sim/FMS/key_delete")
simCMD_FMS_key_exec		= find_command("sim/FMS/exec")

simDR_startup_running 	= find_dataref("sim/operation/prefs/startup_running")

simDR_air_on_acf				= find_dataref("sim/flightmodel/forces/vx_air_on_acf")

--simDR_wind_hdg					= find_dataref("sim/cockpit2/gauges/indicators/wind_heading_deg_mag")
--simDR_wind_spd					= find_dataref("sim/cockpit2/gauges/indicators/wind_speed_kts")
simDR_position_mag_psi 			= find_dataref("sim/flightmodel/position/mag_psi")


--*************************************************************************************--
--** 				              FIND CUSTOM DATAREFS             			    	 **--
--*************************************************************************************--

B738DR_autobrake_RTO_arm	= find_dataref("laminar/B738/autobrake/autobrake_RTO_arm")
B738DR_autobrake_pos		= find_dataref("laminar/B738/autobrake/autobrake_pos")
B738DR_autobrake_RTO_test	= find_dataref("laminar/B738/autobrake/autobrake_RTO_test")

B738DR_fms_v2_15			= find_dataref("laminar/B738/FMS/v2_15")
--B738DR_pfd_flaps_bug		= find_dataref("laminar/B738/pfd/flaps_bug")

B738DR_fms_vref				= find_dataref("laminar/B738/FMS/vref")
B738DR_fms_vref_15			= find_dataref("laminar/B738/FMS/vref_15")
B738DR_fms_vref_25			= find_dataref("laminar/B738/FMS/vref_25")
B738DR_fms_vref_30			= find_dataref("laminar/B738/FMS/vref_30")
B738DR_fms_vref_40			= find_dataref("laminar/B738/FMS/vref_40")

B738DR_fms_N1_mode			= find_dataref("laminar/B738/FMS/N1_mode")
B738DR_fms_N1_thrust		= find_dataref("laminar/B738/FMS/N1_mode_thrust")
B738DR_fmc_oat_temp			= find_dataref("laminar/B738/FMS/fmc_oat_temp")
B738DR_fmc_gw				= find_dataref("laminar/B738/FMS/fmc_gw")

B738DR_flight_phase			= find_dataref("laminar/B738/FMS/flight_phase")

--B738DR_idle_thrust 			= find_dataref("laminar/B738/engine/idle_thrust")

B738DR_trans_alt			= find_dataref("laminar/B738/FMS/fmc_trans_alt")
B738DR_trans_lvl			= find_dataref("laminar/B738/FMS/fmc_trans_lvl")

B738DR_fms_descent_now		= find_dataref("laminar/B738/FMS/descent_now")
B738DR_thr_red_alt			= find_dataref("laminar/B738/FMS/throttle_red_alt")
B738DR_accel_alt			= find_dataref("laminar/B738/FMS/accel_height")

B738DR_fms_ils_disable		= find_dataref("laminar/B738/FMS/ils_disable")

B738DR_rest_wpt_spd_id 		= find_dataref("laminar/B738/fms/rest_wpt_spd_id")
B738DR_rest_wpt_spd 		= find_dataref("laminar/B738/fms/rest_wpt_spd")
B738DR_rest_wpt_spd_idx		= find_dataref("laminar/B738/fms/rest_wpt_spd_idx")
B738DR_rest_wpt_alt_id 		= find_dataref("laminar/B738/fms/rest_wpt_alt_id")
B738DR_rest_wpt_alt 		= find_dataref("laminar/B738/fms/rest_wpt_alt")
B738DR_rest_wpt_alt_t 		= find_dataref("laminar/B738/fms/rest_wpt_alt_t")
B738DR_calc_wpt_spd 		= find_dataref("laminar/B738/fms/calc_wpt_spd")
B738DR_calc_wpt_alt 		= find_dataref("laminar/B738/fms/calc_wpt_alt")

offset						= find_dataref("laminar/B738/fms/vnav_idx")

--ed_alt_fms					= find_dataref("laminar/B738/fms/ed_alt")

vnav_idx					= find_dataref("laminar/B738/fms/vnav_idx")
td_idx 						= find_dataref("laminar/B738/fms/vnav_td_idx")
ed_alt						= find_dataref("laminar/B738/fms/ed_alt")
B738DR_missed_app_act		= find_dataref("laminar/B738/fms/missed_app_act")

B738DR_irs_left_mode		= find_dataref("laminar/B738/irs/irs_mode")
B738DR_irs_right_mode		= find_dataref("laminar/B738/irs/irs2_mode")

-- B738DR_minim_fo = 			find_dataref("laminar/B738/EFIS_control/fo/minimums")
-- B738DR_minim_capt = 		find_dataref("laminar/B738/EFIS_control/cpt/minimums")

B738DR_lock_idle_thrust		= find_dataref("laminar/B738/fms/lock_idle_thrust")

B738DR_pfd_flaps_up			= find_dataref("laminar/B738/pfd/flaps_up")
B738DR_pfd_flaps_1			= find_dataref("laminar/B738/pfd/flaps_1")
B738DR_pfd_flaps_2			= find_dataref("laminar/B738/pfd/flaps_2")
B738DR_pfd_flaps_5			= find_dataref("laminar/B738/pfd/flaps_5")
B738DR_pfd_flaps_10			= find_dataref("laminar/B738/pfd/flaps_10")
B738DR_pfd_flaps_15			= find_dataref("laminar/B738/pfd/flaps_15")

B738DR_vnav_disconnect		= find_dataref("laminar/B738/fms/vnav_disconnect")
B738DR_lnav_disconnect		= find_dataref("laminar/B738/fms/lnav_disconnect")
--decel_idx					= find_dataref("laminar/B738/fms/vnav_decel_idx")
decel_dist					= find_dataref("laminar/B738/fms/vnav_decel_dist")
--decel_before_idx			= find_dataref("laminar/B738/fms/vnav_decel_before_idx")

--B738DR_autopilot_pfd_mode		= find_dataref("laminar/B738/autopilot/pfd_mode")
--B738DR_autopilot_pfd_mode_fo	= find_dataref("laminar/B738/autopilot/pfd_mode_fo")

B738DR_pfd_vert_path		= find_dataref("laminar/B738/pfd/pfd_vert_path")
B738DR_pfd_vert_path_fo		= find_dataref("laminar/B738/pfd/pfd_vert_path_fo")
B738DR_nd_vert_path			= find_dataref("laminar/B738/pfd/nd_vert_path")

B738DR_rest_wpt_alt_idx		= find_dataref("laminar/B738/fms/rest_wpt_alt_idx")

B738DR_hyd_A_status			= find_dataref("laminar/B738/hydraulic/A_status")
B738DR_hyd_B_status			= find_dataref("laminar/B738/hydraulic/B_status")

B738DR_throttle_noise		= find_dataref("laminar/B738/fms/throttle_noise")

B738DR_joy_axis_throttle	= find_dataref("laminar/B738/axis/throttle")
B738DR_joy_axis_throttle1	= find_dataref("laminar/B738/axis/throttle1")
B738DR_joy_axis_throttle2	= find_dataref("laminar/B738/axis/throttle2")

B738DR_xtrack				= find_dataref("laminar/B738/fms/xtrack")
B738DR_wpt_path				= find_dataref("laminar/B738/fms/gps_wpt_path")
B738DR_pfd_max_speed		= find_dataref("laminar/B738/pfd/max_speed")

B738DR_baro_in_hpa			= find_dataref("laminar/B738/fms/baro_in_hpa")
B738DR_min_baro_radio		= find_dataref("laminar/B738/fms/min_baro_radio")

B738DR_fms_approach_speed	= find_dataref("laminar/B738/FMS/approach_speed")
B738DR_approach_flaps_set	= find_dataref("laminar/B738/FMS/approach_flaps_set")
simDR_fmc_dist				= find_dataref("laminar/B738/fms/lnav_dist_next")
B738DR_rnp					= find_dataref("laminar/B738/fms/rnp")
B738DR_fmc_bank_angle		= find_dataref("laminar/B738/fms/bank_angle")

B738DR_nd_fac_horizontal	= find_dataref("laminar/B738/fms/pfd_fac_horizontal")
B738DR_nd_fac_horizontal_fo	= find_dataref("laminar/B738/fms/pfd_fac_horizontal_fo")

B738DR_radii_turn_act		= find_dataref("laminar/B738/fms/radii_turn_act")
B738DR_radii_correct		= find_dataref("laminar/B738/fms/radii_correct")

B738DR_fms_approach_wind_corr	= find_dataref("laminar/B738/FMS/approach_wind_corr")

B738DR_enable_gpwstest_long		= find_dataref("laminar/b738/fmodpack/fmod_gpwstest_long_on")
B738DR_enable_gpwstest_short	= find_dataref("laminar/b738/fmodpack/fmod_gpwstest_short_on")
B738DR_windshear				= find_dataref("laminar/b738/fmodpack/msg_windshear")

cross_wind						= find_dataref("laminar/B738/fms/cross_wind")

B738DR_nd_rings					= find_dataref("laminar/B738/effect/nd_rings")

ed_found				= find_dataref("laminar/B738/fms/ed_idx")
B738_legs_num			= find_dataref("laminar/B738/vnav/legs_num")
B738DR_act_wpt_gp		= find_dataref("laminar/B738/fms/act_wpt_gp")
--*************************************************************************************--
--** 				              FIND CUSTOM COMMANDS              			     **--
--*************************************************************************************--


function B738DR_baro_sel_in_hg_pilot_hdlr()
	if B738DR_baro_sel_in_hg_pilot > 40 then
		B738DR_baro_sel_in_hg_pilot = 40
	elseif B738DR_baro_sel_in_hg_pilot < 0 then
		B738DR_baro_sel_in_hg_pilot = 0
	end
end

function B738DR_baro_sel_in_hg_copilot_hdlr()
	if B738DR_baro_sel_in_hg_copilot > 40 then
		B738DR_baro_sel_in_hg_copilot = 40
	elseif B738DR_baro_sel_in_hg_copilot < 0 then
		B738DR_baro_sel_in_hg_copilot = 0
	end
end

--*************************************************************************************--
--** 				        CREATE READ-ONLY CUSTOM DATAREFS               	         **--
--*************************************************************************************--

-- CAPT EFIS DATAREFS

B738DR_efis_wxr_capt	= create_dataref("laminar/B738/EFIS_control/capt/push_button/wxr", "number")
B738DR_efis_sta_capt	= create_dataref("laminar/B738/EFIS_control/capt/push_button/sta", "number")
B738DR_efis_wpt_capt	= create_dataref("laminar/B738/EFIS_control/capt/push_button/wpt", "number")
B738DR_efis_arpt_capt	= create_dataref("laminar/B738/EFIS_control/capt/push_button/arpt", "number")
B738DR_efis_data_capt	= create_dataref("laminar/B738/EFIS_control/capt/push_button/data", "number")
B738DR_efis_pos_capt	= create_dataref("laminar/B738/EFIS_control/capt/push_button/pos", "number")
B738DR_efis_terr_capt	= create_dataref("laminar/B738/EFIS_control/capt/push_button/terr", "number")

--B738DR_efis_map_range_capt 		= create_dataref("laminar/B738/EFIS/capt/map_range", "number")
--B738DR_map_mode_capt			= create_dataref("laminar/B738/EFIS_control/capt/map_mode_pos", "number")

B738DR_efis_data_capt_status	= create_dataref("laminar/B738/EFIS/capt/data_status", "number")


B738DR_efis_rst_capt	= create_dataref("laminar/B738/EFIS_control/capt/push_button/rst", "number")
B738DR_efis_ctr_capt	= create_dataref("laminar/B738/EFIS_control/capt/push_button/ctr", "number")
B738DR_efis_tfc_capt	= create_dataref("laminar/B738/EFIS_control/capt/push_button/tfc", "number")
B738DR_efis_std_capt	= create_dataref("laminar/B738/EFIS_control/capt/push_button/std", "number")

B738DR_efis_vor_on		= create_dataref("laminar/B738/EFIS/EFIS_vor_on", "number")
B738DR_efis_apt_on		= create_dataref("laminar/B738/EFIS/EFIS_airport_on", "number")
B738DR_efis_fix_on		= create_dataref("laminar/B738/EFIS/EFIS_fix_on", "number")
B738DR_efis_wxr_on		= create_dataref("laminar/B738/EFIS/EFIS_wx_on", "number")

---
B738DR_baro_set_std_pilot		= create_dataref("laminar/B738/EFIS/baro_set_std_pilot", "number")
B738DR_baro_sel_in_hg_pilot		= create_dataref("laminar/B738/EFIS/baro_sel_in_hg_pilot", "number", B738DR_baro_sel_in_hg_pilot_hdlr)
B738DR_baro_sel_pilot_show		= create_dataref("laminar/B738/EFIS/baro_sel_pilot_show", "number")
B738DR_baro_box_pilot_show		= create_dataref("laminar/B738/EFIS/baro_box_pilot_show", "number")
B738DR_baro_std_box_pilot_show	= create_dataref("laminar/B738/EFIS/baro_std_box_pilot_show", "number")
---

B738DR_efis_mtrs_capt	= create_dataref("laminar/B738/EFIS_control/capt/push_button/mtrs", "number")
B738DR_efis_fpv_capt	= create_dataref("laminar/B738/EFIS_control/capt/push_button/fpv", "number")

B738DR_efis_baro_mode_capt		= create_dataref("laminar/B738/EFIS_control/capt/baro_in_hpa", "number")
B738DR_efis_baro_mode_capt_pfd	= create_dataref("laminar/B738/EFIS_control/capt/baro_in_hpa_pfd", "number")

B738DR_efis_vor1_capt_pos	= create_dataref("laminar/B738/EFIS_control/capt/vor1_off_pos", "number")
B738DR_efis_vor2_capt_pos	= create_dataref("laminar/B738/EFIS_control/capt/vor2_off_pos", "number")

B738DR_efis_vor1_capt_pfd	= create_dataref("laminar/B738/EFIS_control/capt/vor1_off_pfd", "number")
B738DR_efis_vor2_capt_pfd	= create_dataref("laminar/B738/EFIS_control/capt/vor2_off_pfd", "number")

B738DR_capt_alt_mode_meters		= create_dataref("laminar/B738/PFD/capt/alt_mode_is_meters", "number")
B738DR_capt_fpv_on				= create_dataref("laminar/B738/PFD/capt/fpv_on", "number")


-- FO EFIS DATAREFS

B738DR_efis_wxr_fo	= create_dataref("laminar/B738/EFIS_control/fo/push_button/wxr", "number")
B738DR_efis_sta_fo	= create_dataref("laminar/B738/EFIS_control/fo/push_button/sta", "number")
B738DR_efis_wpt_fo	= create_dataref("laminar/B738/EFIS_control/fo/push_button/wpt", "number")
B738DR_efis_arpt_fo	= create_dataref("laminar/B738/EFIS_control/fo/push_button/arpt", "number")
B738DR_efis_data_fo	= create_dataref("laminar/B738/EFIS_control/fo/push_button/data", "number")
B738DR_efis_pos_fo	= create_dataref("laminar/B738/EFIS_control/fo/push_button/pos", "number")
B738DR_efis_terr_fo	= create_dataref("laminar/B738/EFIS_control/fo/push_button/terr", "number")

B738DR_efis_data_fo_status	= create_dataref("laminar/B738/EFIS/fo/data_status", "number")

B738DR_efis_rst_fo	= create_dataref("laminar/B738/EFIS_control/fo/push_button/rst", "number")
B738DR_efis_ctr_fo	= create_dataref("laminar/B738/EFIS_control/fo/push_button/ctr", "number")
B738DR_efis_tfc_fo	= create_dataref("laminar/B738/EFIS_control/fo/push_button/tfc", "number")
B738DR_efis_std_fo	= create_dataref("laminar/B738/EFIS_control/fo/push_button/std", "number")

B738DR_efis_fo_vor_on		= create_dataref("laminar/B738/EFIS/fo/EFIS_vor_on", "number")
B738DR_efis_fo_apt_on		= create_dataref("laminar/B738/EFIS/fo/EFIS_airport_on", "number")
B738DR_efis_fo_fix_on		= create_dataref("laminar/B738/EFIS/fo/EFIS_fix_on", "number")
B738DR_efis_fo_wxr_on		= create_dataref("laminar/B738/EFIS/fo/EFIS_wx_on", "number")
---
B738DR_baro_set_std_copilot			= create_dataref("laminar/B738/EFIS/baro_set_std_copilot", "number")
B738DR_baro_sel_in_hg_copilot		= create_dataref("laminar/B738/EFIS/baro_sel_in_hg_copilot", "number", B738DR_baro_sel_in_hg_copilot_hdlr)
B738DR_baro_sel_copilot_show		= create_dataref("laminar/B738/EFIS/baro_sel_copilot_show", "number")
B738DR_baro_box_copilot_show		= create_dataref("laminar/B738/EFIS/baro_box_copilot_show", "number")
B738DR_baro_std_box_copilot_show	= create_dataref("laminar/B738/EFIS/baro_std_box_copilot_show", "number")
---

B738DR_efis_mtrs_fo	= create_dataref("laminar/B738/EFIS_control/fo/push_button/mtrs", "number")
B738DR_efis_fpv_fo	= create_dataref("laminar/B738/EFIS_control/fo/push_button/fpv", "number")

B738DR_efis_baro_mode_fo		= create_dataref("laminar/B738/EFIS_control/fo/baro_in_hpa", "number")
B738DR_efis_baro_mode_fo_pfd 	= create_dataref("laminar/B738/EFIS_control/fo/baro_in_hpa_fo", "number")

B738DR_efis_vor1_fo_pos		= create_dataref("laminar/B738/EFIS_control/fo/vor1_off_pos", "number")
B738DR_efis_vor2_fo_pos		= create_dataref("laminar/B738/EFIS_control/fo/vor2_off_pos", "number")

B738DR_efis_vor1_fo_pfd		= create_dataref("laminar/B738/EFIS_control/fo/vor1_off_pfd", "number")
B738DR_efis_vor2_fo_pfd		= create_dataref("laminar/B738/EFIS_control/fo/vor2_off_pfd", "number")

--B738DR_efis_map_range_fo 		= create_dataref("laminar/B738/EFIS/fo/map_range", "number")

B738DR_fo_alt_mode_meters		= create_dataref("laminar/B738/PFD/fo/alt_mode_is_meters", "number")
B738DR_fo_fpv_on				= create_dataref("laminar/B738/PFD/fo/fpv_on", "number")

--B738DR_map_mode_fo			= create_dataref("laminar/B738/EFIS_control/fo/map_mode_pos", "number")

B738DR_efis_rings				= create_dataref("laminar/B738/EFIS_control/capt/rings", "number")
B738DR_efis_terr_on				= create_dataref("laminar/B738/EFIS_control/capt/terr_on", "number")

B738DR_efis_fo_rings			= create_dataref("laminar/B738/EFIS_control/fo/rings", "number")
B738DR_efis_fo_terr_on			= create_dataref("laminar/B738/EFIS_control/fo/terr_on", "number")

-- AP BUTTON / SWITCH POSITION DRS

B738DR_autopilot_n1_pos				= create_dataref("laminar/B738/autopilot/n1_pos", "number")
B738DR_autopilot_speed_pos			= create_dataref("laminar/B738/autopilot/speed_pos", "number")
B738DR_autopilot_lvl_chg_pos		= create_dataref("laminar/B738/autopilot/lvl_chg_pos", "number")
B738DR_autopilot_vnav_pos			= create_dataref("laminar/B738/autopilot/vnav_pos", "number")
B738DR_autopilot_co_pos				= create_dataref("laminar/B738/autopilot/change_over_pos", "number")
	
B738DR_autopilot_lnav_pos			= create_dataref("laminar/B738/autopilot/lnav_pos", "number")
B738DR_autopilot_vorloc_pos			= create_dataref("laminar/B738/autopilot/vorloc_pos", "number")
B738DR_autopilot_app_pos			= create_dataref("laminar/B738/autopilot/app_pos", "number")
B738DR_autopilot_hdg_sel_pos		= create_dataref("laminar/B738/autopilot/hdg_sel_pos", "number")

B738DR_autopilot_alt_hld_pos		= create_dataref("laminar/B738/autopilot/alt_hld_pos", "number")
B738DR_autopilot_vs_pos				= create_dataref("laminar/B738/autopilot/vs_pos", "number")

B738DR_autopilot_cmd_a_pos			= create_dataref("laminar/B738/autopilot/cmd_a_pos", "number")
B738DR_autopilot_cmd_b_pos			= create_dataref("laminar/B738/autopilot/cmd_b_pos", "number")
B738DR_autopilot_cws_a_pos			= create_dataref("laminar/B738/autopilot/cws_a_pos", "number")
B738DR_autopilot_cws_b_pos			= create_dataref("laminar/B738/autopilot/cws_b_pos", "number")
B738DR_autopilot_disconnect_pos		= create_dataref("laminar/B738/autopilot/disconnect_pos", "number")
B738DR_autopilot_disco2				= create_dataref("laminar/B738/autopilot/disconnect_button", "number")

B738DR_autopilot_fd_pos				= create_dataref("laminar/B738/autopilot/flight_director_pos", "number")
B738DR_autopilot_fd_fo_pos			= create_dataref("laminar/B738/autopilot/flight_director_fo_pos", "number")
B738DR_autopilot_bank_angle_pos		= create_dataref("laminar/B738/autopilot/bank_angle_pos", "number")
B738DR_autopilot_autothr_arm_pos	= create_dataref("laminar/B738/autopilot/autothrottle_arm_pos", "number")


-- AP STATUS LIGHT DRS

B738DR_autopilot_n1_status				= create_dataref("laminar/B738/autopilot/n1_status", "number")
B738DR_autopilot_speed_status			= create_dataref("laminar/B738/autopilot/speed_status1", "number")
B738DR_autopilot_lvl_chg_status			= create_dataref("laminar/B738/autopilot/lvl_chg_status", "number")
B738DR_autopilot_vnav_status			= create_dataref("laminar/B738/autopilot/vnav_status1", "number")
	
B738DR_autopilot_lnav_status			= create_dataref("laminar/B738/autopilot/lnav_status", "number")
B738DR_autopilot_vorloc_status			= create_dataref("laminar/B738/autopilot/vorloc_status", "number")
B738DR_autopilot_app_status				= create_dataref("laminar/B738/autopilot/app_status", "number")
B738DR_autopilot_hdg_sel_status			= create_dataref("laminar/B738/autopilot/hdg_sel_status", "number")

B738DR_autopilot_alt_hld_status			= create_dataref("laminar/B738/autopilot/alt_hld_status", "number")
B738DR_autopilot_vs_status				= create_dataref("laminar/B738/autopilot/vs_status", "number")

B738DR_autopilot_cmd_a_status			= create_dataref("laminar/B738/autopilot/cmd_a_status", "number")
B738DR_autopilot_cmd_b_status			= create_dataref("laminar/B738/autopilot/cmd_b_status", "number")
B738DR_autopilot_cws_a_status			= create_dataref("laminar/B738/autopilot/cws_a_status", "number")
B738DR_autopilot_cws_b_status			= create_dataref("laminar/B738/autopilot/cws_b_status", "number")

B738DR_autopilot_autothrottle_status	= create_dataref("laminar/B738/autopilot/autothrottle_status", "number")
B738DR_autopilot_master_capt_status		= create_dataref("laminar/B738/autopilot/master_capt_status", "number")
B738DR_autopilot_master_fo_status		= create_dataref("laminar/B738/autopilot/master_fo_status", "number")

B738DR_autopilot_vhf_source_pos			= create_dataref("laminar/B738/toggle_switch/vhf_nav_source", "number")

B738DR_flare_status						= create_dataref("laminar/B738/autopilot/flare_status", "number")
B738DR_rollout_status					= create_dataref("laminar/B738/autopilot/rollout_status", "number")
B738DR_autoland_status					= create_dataref("laminar/B738/autopilot/autoland_status", "number")
B738DR_retard_status					= create_dataref("laminar/B738/autopilot/retard_status", "number")
B738DR_single_ch_status					= create_dataref("laminar/B738/autopilot/single_ch_status", "number")
B738DR_ils_pointer_disable				= create_dataref("laminar/B738/autopilot/ils_pointer_disable", "number")
--



B738DR_autopilot_autothrottle_on		= create_dataref("laminar/B738/autopilot/autothrottle_on_pfd", "number")
B738DR_autopilot_autothrottle_pfd		= create_dataref("laminar/B738/autopilot/autothrottle_pfd", "number")
B738DR_autopilot_n1_pfd					= create_dataref("laminar/B738/autopilot/n1_pfd", "number")
B738DR_autopilot_ga_pfd					= create_dataref("laminar/B738/autopilot/ga_pfd", "number")
B738DR_autopilot_thr_hld_pfd			= create_dataref("laminar/B738/autopilot/thr_hld_pfd", "number")
B738DR_autopilot_to_ga_pfd				= create_dataref("laminar/B738/autopilot/to_ga_pfd", "number")
B738DR_autopilot_alt_acq_pfd			= create_dataref("laminar/B738/autopilot/alt_acq_pfd", "number")

B738DR_autopilot_fmc_spd_pfd			= create_dataref("laminar/B738/autopilot/fmc_spd_pfd", "number")
B738DR_autopilot_vnav_alt_pfd			= create_dataref("laminar/B738/autopilot/vnav_alt_pfd", "number")
B738DR_autopilot_vnav_pth_pfd			= create_dataref("laminar/B738/autopilot/vnav_pth_pfd", "number")
B738DR_autopilot_vnav_spd_pfd			= create_dataref("laminar/B738/autopilot/vnav_spd_pfd", "number")
B738DR_autopilot_hnav_armed				= create_dataref("laminar/B738/autopilot/hnav_armed", "number")
B738DR_autopilot_alt_mode_pfd			= create_dataref("laminar/B738/autopilot/alt_mode_pfd", "number")
B738DR_autopilot_hdg_mode_pfd			= create_dataref("laminar/B738/autopilot/hdg_mode_pfd", "number")
B738DR_autopilot_vnav_arm_pfd			= create_dataref("laminar/B738/autopilot/vnav_arm_pfd", "number")

B738DR_autopilot_gs_armed				= create_dataref("laminar/B738/autopilot/gs_armed_pfd", "number")

-- AUTOPILOT PFD ANNUNCIATES --
B738DR_pfd_spd_mode						= create_dataref("laminar/B738/autopilot/pfd_spd_mode", "number")
B738DR_pfd_hdg_mode						= create_dataref("laminar/B738/autopilot/pfd_hdg_mode", "number")
B738DR_pfd_alt_mode						= create_dataref("laminar/B738/autopilot/pfd_alt_mode", "number")
B738DR_pfd_hdg_mode_arm					= create_dataref("laminar/B738/autopilot/pfd_hdg_mode_arm", "number")
B738DR_pfd_alt_mode_arm					= create_dataref("laminar/B738/autopilot/pfd_alt_mode_arm", "number")


B738DR_rec_thr_modes					= create_dataref("laminar/B738/autopilot/rec_thr_modes", "number")
B738DR_rec_thr2_modes					= create_dataref("laminar/B738/autopilot/rec_thr2_modes", "number")
B738DR_rec_hdg_modes					= create_dataref("laminar/B738/autopilot/rec_hdg_modes", "number")
B738DR_rec_alt_modes					= create_dataref("laminar/B738/autopilot/rec_alt_modes", "number")
B738DR_rec_cmd_modes1					= create_dataref("laminar/B738/autopilot/rec_cmd_modes", "number")
B738DR_rec_cmd_modes2					= create_dataref("laminar/B738/autopilot/rec_cmd_modes_fo", "number")
B738DR_rec_sch_modes					= create_dataref("laminar/B738/autopilot/rec_sch_modes", "number")
B738DR_rec_alt_alert					= create_dataref("laminar/B738/autopilot/rec_alt_alert", "number")

B738DR_ap_warning						= create_dataref("laminar/B738/autopilot/ap_warn", "number")

AP_airspeed 							= create_dataref("laminar/B738/autopilot/airspeed", "number")
AP_airspeed_mach 						= create_dataref("laminar/B738/autopilot/airspeed_mach", "number")
AP_altitude 							= create_dataref("laminar/B738/autopilot/altitude", "number")

------------------------------

B738DR_lvl_chg_mode						= create_dataref("laminar/B738/autopilot/lvl_chg_mode", "number")
B738DR_show_ias							= create_dataref("laminar/B738/autopilot/show_ias", "number")


DRblink									= create_dataref("laminar/B738/autopilot/blink", "number")


B738DR_kts_disable						= create_dataref("laminar/B738/autopilot/kts_disable", "number")
B738DR_mach_disable						= create_dataref("laminar/B738/autopilot/mach_disable", "number")

B738DR_autopilot_vvi_status_pfd			= create_dataref("laminar/B738/autopilot/vvi_status_pfd", "number")


B738DR_pfd_h_dots_pilot					= create_dataref("laminar/B738/PFD/h_dots_pilot", "number")
B738DR_pfd_v_dots_pilot					= create_dataref("laminar/B738/PFD/v_dots_pilot", "number")
B738DR_pfd_h_dots_pilot_show			= create_dataref("laminar/B738/PFD/h_dots_pilot_show", "number")
B738DR_pfd_v_dots_pilot_show			= create_dataref("laminar/B738/PFD/v_dots_pilot_show", "number")
B738DR_pfd_ils_pilot_show				= create_dataref("laminar/B738/PFD/ils_pilot_show", "number")


B738DR_lowerDU_page						= create_dataref("laminar/B738/systems/lowerDU_page", "number")
B738DR_EICAS_page						= create_dataref("laminar/B738/systems/EICAS_page", "number")

B738DR_mfd_sys_pos						= create_dataref("laminar/B738/buttons/mfd_sys_pos", "number")
B738DR_mfd_eng_pos						= create_dataref("laminar/B738/buttons/mfd_eng_pos", "number")


B738DR_autopilot_side					= create_dataref("laminar/B738/autopilot/autopilot_source", "number")

--B738DR_impuls							= create_dataref("laminar/B738/autopilot/impuls", "number")
B738DR_fd_on							= create_dataref("laminar/B738/autopilot/flight_direct_on", "number")

B738DR_pfd_fd_cmd						= create_dataref("laminar/B738/autopilot/pfd_fd_cmd", "number")
B738DR_pfd_fd_cmd_fo					= create_dataref("laminar/B738/autopilot/pfd_fd_cmd_fo", "number")

B738DR_altitude_mode					= create_dataref("laminar/B738/autopilot/altitude_mode", "number")
B738DR_altitude_mode2					= create_dataref("laminar/B738/autopilot/altitude_mode2", "number")
B738DR_heading_mode						= create_dataref("laminar/B738/autopilot/heading_mode", "number")
B738DR_speed_mode						= create_dataref("laminar/B738/autopilot/speed_mode", "number")
ap_goaround 							= create_dataref("laminar/B738/autopilot/ap_goaround", "number")
fd_goaround 							= create_dataref("laminar/B738/autopilot/fd_goaround", "number")

B738DR_ap_disconnect					= create_dataref("laminar/B738/annunciator/ap_disconnect", "number")
B738DR_at_disconnect					= create_dataref("laminar/B738/annunciator/at_disconnect", "number")
B738DR_snd_ap_disconnect				= create_dataref("laminar/b738/fmodpack/fmod_ap_disconnect", "number")

B738DR_source_pilot						= create_dataref("laminar/B738/autopilot/source_pilot", "number")
B738DR_source_arm_pilot					= create_dataref("laminar/B738/autopilot/source_arm_pilot", "number")

B738DR_vvi_dial_show					= create_dataref("laminar/B738/autopilot/vvi_dial_show", "number")

fd_target								= create_dataref("laminar/B738/flare/fd_target", "number")
vvi_trend								= create_dataref("laminar/B738/flare/vvi_trend", "number")

B738DR_pfd_vorloc_lnav					= create_dataref("laminar/B738/autopilot/pfd_vorloc_lnav", "number")
B738DR_fd_pilot_show					= create_dataref("laminar/B738/autopilot/fd_pilot_show", "number")
B738DR_fd_copilot_show					= create_dataref("laminar/B738/autopilot/fd_copilot_show", "number")

B738DR_ias_disagree						= create_dataref("laminar/B738/autopilot/ias_disagree", "number")
B738DR_alt_disagree						= create_dataref("laminar/B738/autopilot/alt_disagree", "number")

B738_vnav_active						= create_dataref("laminar/B738/autopilot/vnav_active", "number")

B738DR_eng1_N1_bug		= create_dataref("laminar/B738/engine/eng1_N1_bug", "number")
B738DR_eng2_N1_bug		= create_dataref("laminar/B738/engine/eng2_N1_bug", "number")
B738DR_eng1_N1_bug_dig		= create_dataref("laminar/B738/engine/eng1_N1_bug_dig", "number")
B738DR_eng2_N1_bug_dig		= create_dataref("laminar/B738/engine/eng2_N1_bug_dig", "number")
B738DR_N1_mode_man			= create_dataref("laminar/B738/engine/N1_mode_man", "number")
B738DR_assum_temp_show		= create_dataref("laminar/B738/eicas/assum_temp_show", "number")

B738DR_thrust1_leveler		= create_dataref("laminar/B738/engine/thrust1_leveler", "number")
B738DR_thrust2_leveler		= create_dataref("laminar/B738/engine/thrust2_leveler", "number")

vnav_speed_trg				= create_dataref("laminar/B738/autopilot/vnav_speed_trg", "number")
lnav_engaged				= create_dataref("laminar/B738/autopilot/lnav_engaged", "number")

--B738DR_mcp_alt_dial			= create_dataref("laminar/B738/autopilot/mcp_alt_dial", "number")
B738DR_course_pilot			= create_dataref("laminar/B738/autopilot/course_pilot", "number")
B738DR_course_copilot		= create_dataref("laminar/B738/autopilot/course_copilot", "number")

B738DR_autopilot_spd_interv_pos	= create_dataref("laminar/B738/autopilot/spd_interv_pos", "number")
B738DR_ap_spd_interv_status	= create_dataref("laminar/B738/autopilot/spd_interv_status", "number")

B738DR_EFIS_TCAS_on			= create_dataref("laminar/B738/EFIS/tcas_on", "number")
B738DR_EFIS_TCAS_on_fo		= create_dataref("laminar/B738/EFIS/tcas_on_fo", "number")

B738DR_speed_ratio			= create_dataref("laminar/B738/FMS/speed_ratio", "number")
B738DR_v_speed_ratio		= create_dataref("laminar/B738/FMS/v_speed_ratio", "number")
B738DR_vdot_ratio			= create_dataref("laminar/B738/FMS/vdot_ratio", "number")
B738DR_radio_height_ratio	= create_dataref("laminar/B738/FMS/radio_height_ratio", "number")
B738DR_altitude_pilot_ratio	= create_dataref("laminar/B738/FMS/altitude_pilot_ratio", "number")
B738DR_air_on_acf_ratio		= create_dataref("laminar/B738/FMS/air_on_acf_ratio", "number")
B738DR_eng1_N1_ratio		= create_dataref("laminar/B738/FMS/eng1_N1_ratio", "number")
B738DR_eng2_N1_ratio		= create_dataref("laminar/B738/FMS/eng2_N1_ratio", "number")

B738DR_eng_out				= create_dataref("laminar/B738/FMS/eng_out", "number")

flaps_speed					= create_dataref("laminar/B738/FMS/flaps_speed", "number")
vnav_speed					= create_dataref("laminar/B738/FMS/vnav_speed", "number")

B738DR_agl_pilot			= create_dataref("laminar/B738/PFD/agl_pilot", "number")
B738DR_agl_copilot			= create_dataref("laminar/B738/PFD/agl_copilot", "number")

B738DR_pfd_nav1_pilot		= create_dataref("laminar/B738/PFD/nav1_pilot", "number")
B738DR_pfd_nav2_pilot		= create_dataref("laminar/B738/PFD/nav2_pilot", "number")
B738DR_pfd_nav1_copilot		= create_dataref("laminar/B738/PFD/nav1_copilot", "number")
B738DR_pfd_nav2_copilot		= create_dataref("laminar/B738/PFD/nav2_copilot", "number")

B738DR_green_arc	 		= create_dataref("laminar/B738/EFIS/green_arc", "number")
B738DR_green_arc_show		= create_dataref("laminar/B738/EFIS/green_arc_show", "number")
B738DR_green_arc_fo	 		= create_dataref("laminar/B738/EFIS/green_arc_fo", "number")
B738DR_green_arc_fo_show	= create_dataref("laminar/B738/EFIS/green_arc_fo_show", "number")

B738DR_vor1_sel_rotate	 	= create_dataref("laminar/B738/pfd/vor1_sel_rotate", "number")
B738DR_vor1_sel_x	 		= create_dataref("laminar/B738/pfd/vor1_sel_x", "number")
B738DR_vor1_sel_y	 		= create_dataref("laminar/B738/pfd/vor1_sel_y", "number")
B738DR_vor1_sel_id	 		= create_dataref("laminar/B738/pfd/vor1_sel_id", "string")
B738DR_vor1_sel_crs	 		= create_dataref("laminar/B738/pfd/vor1_sel_crs", "string")
B738DR_vor1_sel_bcrs 		= create_dataref("laminar/B738/pfd/vor1_sel_bcrs", "string")
B738DR_vor1_show	 		= create_dataref("laminar/B738/pfd/vor1_show", "number")
B738DR_vor1_line_show		= create_dataref("laminar/B738/pfd/vor1_line_show", "number")
B738DR_vor1_sel_pos_show 	= create_dataref("laminar/B738/pfd/vor1_sel_pos_show", "number")
B738DR_vor1_sel_pos 		= create_dataref("laminar/B738/pfd/vor1_sel_pos", "number")
B738DR_vor1_sel_pos_dist	= create_dataref("laminar/B738/pfd/vor1_sel_pos_dist", "number")
B738DR_vor1_sel_pos_brg 	= create_dataref("laminar/B738/pfd/vor1_sel_pos_brg", "string")

B738DR_vor2_sel_rotate	 	= create_dataref("laminar/B738/pfd/vor2_sel_rotate", "number")
B738DR_vor2_sel_x	 		= create_dataref("laminar/B738/pfd/vor2_sel_x", "number")
B738DR_vor2_sel_y	 		= create_dataref("laminar/B738/pfd/vor2_sel_y", "number")
B738DR_vor2_sel_id	 		= create_dataref("laminar/B738/pfd/vor2_sel_id", "string")
B738DR_vor2_sel_crs	 		= create_dataref("laminar/B738/pfd/vor2_sel_crs", "string")
B738DR_vor2_sel_bcrs 		= create_dataref("laminar/B738/pfd/vor2_sel_bcrs", "string")
B738DR_vor2_show	 		= create_dataref("laminar/B738/pfd/vor2_show", "number")
B738DR_vor2_line_show		= create_dataref("laminar/B738/pfd/vor2_line_show", "number")
B738DR_vor2_sel_pos_show 	= create_dataref("laminar/B738/pfd/vor2_sel_pos_show", "number")
B738DR_vor2_sel_pos 		= create_dataref("laminar/B738/pfd/vor2_sel_pos", "number")
B738DR_vor2_sel_pos_dist	= create_dataref("laminar/B738/pfd/vor2_sel_pos_dist", "number")
B738DR_vor2_sel_pos_brg 	= create_dataref("laminar/B738/pfd/vor2_sel_pos_brg", "string")

B738DR_vor1_sel_rotate_fo 	= create_dataref("laminar/B738/pfd/vor1_sel_rotate_fo", "number")
B738DR_vor1_sel_x_fo 		= create_dataref("laminar/B738/pfd/vor1_sel_x_fo", "number")
B738DR_vor1_sel_y_fo 		= create_dataref("laminar/B738/pfd/vor1_sel_y_fo", "number")
B738DR_vor1_sel_id_fo 		= create_dataref("laminar/B738/pfd/vor1_sel_id_fo", "string")
B738DR_vor1_sel_crs_fo 		= create_dataref("laminar/B738/pfd/vor1_sel_crs_fo", "string")
B738DR_vor1_sel_bcrs_fo		= create_dataref("laminar/B738/pfd/vor1_sel_bcrs_fo", "string")
B738DR_vor1_copilot_show	= create_dataref("laminar/B738/pfd/vor1_copilot_show", "number")
B738DR_vor1_line_copilot_show	= create_dataref("laminar/B738/pfd/vor1_line_copilot_show", "number")
B738DR_vor1_sel_pos_show_fo 	= create_dataref("laminar/B738/pfd/vor1_sel_pos_show_fo", "number")
B738DR_vor1_sel_pos_fo 			= create_dataref("laminar/B738/pfd/vor1_sel_pos_fo", "number")
B738DR_vor1_sel_pos_dist_fo		= create_dataref("laminar/B738/pfd/vor1_sel_pos_dist_fo", "number")
B738DR_vor1_sel_pos_brg_fo	 	= create_dataref("laminar/B738/pfd/vor1_sel_pos_brg_fo", "string")

B738DR_vor2_sel_rotate_fo		= create_dataref("laminar/B738/pfd/vor2_sel_rotate_fo", "number")
B738DR_vor2_sel_x_fo	 		= create_dataref("laminar/B738/pfd/vor2_sel_x_fo", "number")
B738DR_vor2_sel_y_fo	 		= create_dataref("laminar/B738/pfd/vor2_sel_y_fo", "number")
B738DR_vor2_sel_id_fo	 		= create_dataref("laminar/B738/pfd/vor2_sel_id_fo", "string")
B738DR_vor2_sel_crs_fo	 		= create_dataref("laminar/B738/pfd/vor2_sel_crs_fo", "string")
B738DR_vor2_sel_bcrs_fo 		= create_dataref("laminar/B738/pfd/vor2_sel_bcrs_fo", "string")
B738DR_vor2_copilot_show		= create_dataref("laminar/B738/pfd/vor2_copilot_show", "number")
B738DR_vor2_line_copilot_show 	= create_dataref("laminar/B738/pfd/vor2_line_copilot_show", "number")
B738DR_vor2_sel_pos_show_fo 	= create_dataref("laminar/B738/pfd/vor2_sel_pos_show_fo", "number")
B738DR_vor2_sel_pos_fo 			= create_dataref("laminar/B738/pfd/vor2_sel_pos_fo", "number")
B738DR_vor2_sel_pos_dist_fo		= create_dataref("laminar/B738/pfd/vor2_sel_pos_dist_fo", "number")
B738DR_vor2_sel_pos_brg_fo	 	= create_dataref("laminar/B738/pfd/vor2_sel_pos_brg_fo", "string")

B738DR_vor1_arrow 				= create_dataref("laminar/B738/pfd/vor1_arrow", "number")
B738DR_vor2_arrow 				= create_dataref("laminar/B738/pfd/vor2_arrow", "number")
B738DR_vor1_arrow_fo 			= create_dataref("laminar/B738/pfd/vor1_arrow_fo", "number")
B738DR_vor2_arrow_fo 			= create_dataref("laminar/B738/pfd/vor2_arrow_fo", "number")

B738DR_adf1_arrow 				= create_dataref("laminar/B738/pfd/adf1_arrow", "number")
B738DR_adf2_arrow 				= create_dataref("laminar/B738/pfd/adf2_arrow", "number")
B738DR_adf1_arrow_fo 			= create_dataref("laminar/B738/pfd/adf1_arrow_fo", "number")
B738DR_adf2_arrow_fo 			= create_dataref("laminar/B738/pfd/adf2_arrow_fo", "number")

B738DR_dh_pilot				= create_dataref("laminar/B738/pfd/dh_pilot", "number")
B738DR_dh_copilot			= create_dataref("laminar/B738/pfd/dh_copilot", "number")

vnav_descent_disable		= create_dataref("laminar/B738/FMS/vnav_disable", "number")
B738DR_mcp_speed_dial_kts	= create_dataref("laminar/B738/autopilot/mcp_speed_dial_kts", "number")
B738DR_mcp_speed_dial		= create_dataref("laminar/B738/autopilot/mcp_speed_dial_kts_mach", "number")

B738DR_efis_disagree	 	= create_dataref("laminar/B738/nd/capt/efis_disagree", "number")
B738DR_efis_disagree_fo	 	= create_dataref("laminar/B738/nd/fo/efis_disagree", "number")


-- FMOD SOUNDS DATAREFS
-- B738DR_dh_minimum_pilot			= create_dataref("laminar/B738/fmod/dh_minimum_pilot", "number")
-- B738DR_dh_minimum_copilot		= create_dataref("laminar/B738/fmod/dh_minimum_copilot", "number")
B738DR_dh_minimum_pilot2		= create_dataref("laminar/B738/fmod/dh_minimum_pilot2", "number")
B738DR_dh_minimum_copilot2		= create_dataref("laminar/B738/fmod/dh_minimum_copilot2", "number")

B738DR_ap_ils_active		= create_dataref("laminar/B738/ap/ils_active", "number")
fac_engaged					= create_dataref("laminar/B738/ap/fac_engaged", "number")
loc_gp_engaged				= create_dataref("laminar/B738/ap/loc_gp_engaged", "number")

B738DR_gp_status			= create_dataref("laminar/B738/pfd/gp_status", "number")

--- A/P, A/T light buttons
B738DR_ap_light_pilot		= create_dataref("laminar/B738/push_button/ap_light_pilot", "number")
B738DR_at_light_pilot		= create_dataref("laminar/B738/push_button/at_light_pilot", "number")
B738DR_ap_light_fo			= create_dataref("laminar/B738/push_button/ap_light_fo", "number")
B738DR_at_light_fo			= create_dataref("laminar/B738/push_button/at_light_fo", "number")


B738DR_fdir_pitch_pilot		= create_dataref("laminar/B738/pfd/flight_director_pitch_pilot", "number")
B738DR_fdir_pitch_copilot	= create_dataref("laminar/B738/pfd/flight_director_pitch_copilot", "number")

-- TO/GA BUTTONS
B738DR_autopilot_left_toga_pos	= create_dataref("laminar/B738/autopilot/left_toga_pos", "number")
B738DR_autopilot_right_toga_pos	= create_dataref("laminar/B738/autopilot/right_toga_pos", "number")

-- A/T DISENGAGE BUTTONS
B738DR_autopilot_left_at_diseng_pos	= create_dataref("laminar/B738/autopilot/left_at_diseng_pos", "number")
B738DR_autopilot_right_at_diseng_pos	= create_dataref("laminar/B738/autopilot/right_at_diseng_pos", "number")

-- OTHERS
B738DR_mic_pos				= create_dataref("laminar/B738/push_button/mic_pos", "number")


B738DR_mcp_hdg_dial_nd			= create_dataref("laminar/B738/nd/mcp_hdg_dial", "number")
B738DR_mcp_hdg_dial_nd_show		= create_dataref("laminar/B738/nd/mcp_hdg_dial_show", "number")
B738DR_nd_crs					= create_dataref("laminar/B738/nd/crs_mag", "number")

B738DR_hdg_mag_nd				= create_dataref("laminar/B738/nd/hdg_mag", "number")
--B738DR_hdg_mag_nd_show			= create_dataref("laminar/B738/nd/hdg_mag_show", "number")
B738DR_track_nd					= create_dataref("laminar/B738/nd/track_nd", "number")
B738DR_hdg_bug_nd				= create_dataref("laminar/B738/nd/hdg_bug_nd", "number")

B738DR_mcp_hdg_dial_nd_fo			= create_dataref("laminar/B738/nd/mcp_hdg_dial_fo", "number")
B738DR_mcp_hdg_dial_nd_fo_show		= create_dataref("laminar/B738/nd/mcp_hdg_dial_fo_show", "number")
B738DR_nd_crs_fo					= create_dataref("laminar/B738/nd/crs_mag_fo", "number")

B738DR_hdg_mag_nd_fo				= create_dataref("laminar/B738/nd/hdg_mag_fo", "number")
-- B738DR_hdg_mag_nd_fo_show			= create_dataref("laminar/B738/nd/hdg_mag_fo_show", "number")
B738DR_track_nd_fo					= create_dataref("laminar/B738/nd/track_nd_fo", "number")
B738DR_hdg_bug_nd_fo				= create_dataref("laminar/B738/nd/hdg_bug_nd_fo", "number")

B7378DR_hdg_line_enable				= create_dataref("laminar/B738/nd/hdg_bug_line", "number")
B7378DR_hdg_line_fo_enable			= create_dataref("laminar/B738/nd/hdg_bug_line_fo", "number")
B738DR_track_pfd					= create_dataref("laminar/B738/pfd/track_line", "number")

B738DR_gps_horizont			= create_dataref("laminar/B738/autopilot/gps_horizont", "number")
B738DR_fac_horizont			= create_dataref("laminar/B738/autopilot/fac_horizont", "number")

lock_throttle				= create_dataref("laminar/B738/autopilot/lock_throttle", "number")

B738DR_track_up_active		= create_dataref("laminar/B738/fms/track_up_active", "number")


-- RADIOS
-- NAV1
simDR_nav1_flag_gs			= find_dataref("sim/cockpit2/radios/indicators/nav1_flag_glideslope")
simDR_nav1_vert_dsp			= find_dataref("sim/cockpit2/radios/indicators/nav1_display_vertical")
simDR_nav1_horz_dsp			= find_dataref("sim/cockpit2/radios/indicators/nav1_display_horizontal")
simDR_nav1_flag_ft			= find_dataref("sim/cockpit2/radios/indicators/nav1_flag_from_to_pilot")
simDR_nav1_nav_id			= find_dataref("sim/cockpit2/radios/indicators/nav1_nav_id")
simDR_nav1_dme				= find_dataref("sim/cockpit2/radios/indicators/nav1_dme_distance_nm")
simDR_nav1_has_dme			= find_dataref("sim/cockpit2/radios/indicators/nav1_has_dme")
simDR_nav1_obs_pilot		= find_dataref("sim/cockpit2/radios/actuators/nav1_obs_deg_mag_pilot")
simDR_nav1_obs_copilot		= find_dataref("sim/cockpit2/radios/actuators/nav1_obs_deg_mag_copilot")

simDR_nav1_bearing			= find_dataref("sim/cockpit2/radios/indicators/nav1_bearing_deg_mag")
simDR_nav1_course_pilot		= find_dataref("sim/cockpit2/radios/actuators/nav1_course_deg_mag_pilot")
simDR_nav1_course_copilot	= find_dataref("sim/cockpit2/radios/actuators/nav1_course_deg_mag_copilot")
simDR_nav1_type				= find_dataref("sim/cockpit2/radios/indicators/nav1_type")
simDR_nav1_freq				= find_dataref("sim/cockpit2/radios/actuators/nav1_frequency_hz")

-- NAV2
simDR_nav2_flag_gs			= find_dataref("sim/cockpit2/radios/indicators/nav2_flag_glideslope")
simDR_nav2_vert_dsp			= find_dataref("sim/cockpit2/radios/indicators/nav2_display_vertical")
simDR_nav2_horz_dsp			= find_dataref("sim/cockpit2/radios/indicators/nav2_display_horizontal")
simDR_nav2_flag_ft			= find_dataref("sim/cockpit2/radios/indicators/nav2_flag_from_to_pilot")
simDR_nav2_nav_id			= find_dataref("sim/cockpit2/radios/indicators/nav2_nav_id")
simDR_nav2_dme				= find_dataref("sim/cockpit2/radios/indicators/nav2_dme_distance_nm")
simDR_nav2_has_dme			= find_dataref("sim/cockpit2/radios/indicators/nav2_has_dme")
simDR_nav2_obs_pilot		= find_dataref("sim/cockpit2/radios/actuators/nav2_obs_deg_mag_pilot")
simDR_nav2_obs_copilot		= find_dataref("sim/cockpit2/radios/actuators/nav2_obs_deg_mag_copilot")

simDR_nav2_bearing			= find_dataref("sim/cockpit2/radios/indicators/nav2_bearing_deg_mag")
simDR_nav2_course_pilot		= find_dataref("sim/cockpit2/radios/actuators/nav2_course_deg_mag_pilot")
simDR_nav2_course_copilot	= find_dataref("sim/cockpit2/radios/actuators/nav2_course_deg_mag_copilot")
simDR_nav2_type				= find_dataref("sim/cockpit2/radios/indicators/nav2_type")
simDR_nav2_freq				= find_dataref("sim/cockpit2/radios/actuators/nav2_frequency_hz")

-- ADF
simDR_adf1_bearing			= find_dataref("sim/cockpit2/radios/indicators/adf1_bearing_deg_mag")
simDR_adf2_bearing			= find_dataref("sim/cockpit2/radios/indicators/adf2_bearing_deg_mag")


-- PILOT
B738DR_nav_flag_gs			= create_dataref("laminar/radios/pilot/nav_flag_gs", "number")
B738DR_nav_vert_dsp			= create_dataref("laminar/radios/pilot/nav_vert_dsp", "number")
B738DR_nav_horz_dsp			= create_dataref("laminar/radios/pilot/nav_horz_dsp", "number")
B738DR_nav_flag_ft			= create_dataref("laminar/radios/pilot/nav_flag_ft", "number")
B738DR_nav_nav_id			= create_dataref("laminar/radios/pilot/nav_nav_id", "string")
B738DR_nav_dme				= create_dataref("laminar/radios/pilot/nav_dme", "number")
B738DR_nav_has_dme			= create_dataref("laminar/radios/pilot/nav_has_dme", "number")
B738DR_nav_obs				= create_dataref("laminar/radios/pilot/nav_obs", "number")
B738DR_nav_bearing			= create_dataref("laminar/radios/pilot/nav_bearing", "number")
B738DR_nav_course			= create_dataref("laminar/radios/pilot/nav_course", "number")
B738DR_nav_type				= create_dataref("laminar/radios/pilot/nav_type", "number")

-- COPILOT
B738DR_nav_flag_gs_fo		= create_dataref("laminar/radios/copilot/nav_flag_gs", "number")
B738DR_nav_vert_dsp_fo		= create_dataref("laminar/radios/copilot/nav_vert_dsp", "number")
B738DR_nav_horz_dsp_fo		= create_dataref("laminar/radios/copilot/nav_horz_dsp", "number")
B738DR_nav_flag_ft_fo		= create_dataref("laminar/radios/copilot/nav_flag_ft", "number")
B738DR_nav_nav_id_fo		= create_dataref("laminar/radios/copilot/nav_nav_id", "string")
B738DR_nav_dme_fo			= create_dataref("laminar/radios/copilot/nav_dme", "number")
B738DR_nav_has_dme_fo		= create_dataref("laminar/radios/copilot/nav_has_dme", "number")
B738DR_nav_obs_fo			= create_dataref("laminar/radios/copilot/nav_obs", "number")
B738DR_nav_bearing_fo		= create_dataref("laminar/radios/copilot/nav_bearing", "number")
B738DR_nav_course_fo		= create_dataref("laminar/radios/copilot/nav_course", "number")
B738DR_nav_type_fo			= create_dataref("laminar/radios/copilot/nav_type", "number")

B738DR_alt_hold_mem 		= create_dataref("laminar/autopilot/alt_hold_mem", "number")


--*************************************************************************************--
--** 				       READ-WRITE CUSTOM DATAREF HANDLERS     	        	     **--
--*************************************************************************************--

function B738DR_fmc_speed_DRhandler()end
function B738DR_fmc_mode_DRhandler()end
function B738DR_fmc_descent_now_DRhandler()end
function B738DR_was_on_cruise_DRhandler()end

function B738DR_fmc_climb_speed_DRhandler()end
function B738DR_fmc_climb_speed_l_DRhandler()end
function B738DR_fmc_climb_speed_mach_DRhandler()end
function B738DR_fmc_climb_r_speed1_DRhandler()end
function B738DR_fmc_climb_r_alt1_DRhandler()end
function B738DR_fmc_climb_r_speed2_DRhandler()end
function B738DR_fmc_climb_r_alt2_DRhandler()end

function B738DR_fmc_cruise_speed_DRhandler()end
function B738DR_fmc_cruise_speed_mach_DRhandler()end
function B738DR_fmc_cruise_alt_DRhandler()end

function B738DR_fmc_descent_speed_DRhandler()end
function B738DR_fmc_descent_speed_mach_DRhandler()end
function B738DR_fmc_descent_alt_DRhandler()end
function B738DR_fmc_descent_r_speed1_DRhandler()end
function B738DR_fmc_descent_r_alt1_DRhandler()end
function B738DR_fmc_descent_r_speed2_DRhandler()end
function B738DR_fmc_descent_r_alt2_DRhandler()end
function B738DR_fmc_approach_alt_DRhandler()end

function B738DR_thrust_vvi_1_DRhandler()end
function B738DR_thrust_vvi_2_DRhandler()end
function B738DR_thrust_ratio_1_DRhandler()end
function B738DR_thrust_ratio_2_DRhandler()end
function B738DR_flare_ratio_DRhandler()end
function B738DR_pitch_last_DRhandler()end
function B738DR_pitch_ratio_DRhandler()end
function B738DR_pitch_offset_DRhandler()end
function B738DR_vvi_last_DRhandler()end
function B738DR_flare_offset_DRhandler()end

function B738DR_capt_map_mode_DRhandler()end
function B738DR_fo_map_mode_DRhandler()end

function B738DR_capt_exp_map_mode_DRhandler()end
function B738DR_fo_exp_map_mode_DRhandler()end

function B738DR_efis_map_range_capt_DRhandler()end
function B738DR_efis_map_range_fo_DRhandler()end

function B738DR_n1_set_source_DRhandler() end
function B738DR_n1_set_adjust_DRhandler() end

function B738DR_minim_fo_DRhandler() end
function B738DR_minim_capt_DRhandler() end
function B738DR_minim_dh_fo_DRhandler() end
function B738DR_minim_dh_capt_DRhandler() end

function B738DR_mcp_alt_dial_DRhandler() end
function B738DR_vnav_alt_mode_DRhandler() end
function B738DR_mcp_hdg_dial_DRhandler() end

function B738DR_test_glare_DRhandler() end
--function B738DR_changed_flight_phase_DRhandler() end

function B738DR_test_test_DRhandler() end
function B738DR_test_test2_DRhandler() end

function B738DR_kill_glareshield_DRhandler() end

function B738DR_yoke_roll_DRhandler() end
function B738DR_yoke_pitch_DRhandler() end

function B738DR_kp_DRhandler() end
function B738DR_ki_DRhandler() end
function B738DR_kd_DRhandler() end
function B738DR_kf_DRhandler() end
function B738DR_bias_DRhandler() end



function B738DR_reverse_both_DRhandler()
	
	if simDR_reverse1_act == 1 and simDR_reverse2_act == 1 then
		if simDR_throttle_1 == 0 and simDR_throttle_2 == 0 then
			if B738DR_reverse_both < 0.02 then
				B738DR_reverse_both = 0
			elseif B738DR_reverse_both > 0.04 and B738DR_reverse_both < 0.06 then
				B738DR_reverse_both = 0.05
				simDR_reverse1_act = 3
				simDR_reverse2_act = 3
			end
		else
			B738DR_reverse_both = 0
		end
	elseif simDR_reverse1_act == 3 and simDR_reverse2_act == 3 then
		if B738DR_reverse_both < 0.02 then
			B738DR_reverse_both = 0
			simDR_reverse1_act = 1
			simDR_reverse2_act = 1
		elseif B738DR_reverse_both > 0.04 and B738DR_reverse_both < 0.06 then
			B738DR_reverse_both = 0.05
		end
		if B738DR_reverse_both < 0.06 then
			simDR_throttle_1 = 0
			simDR_throttle_2 = 0
		else
			simDR_throttle_1 = B738_rescale(0.06, 0, 1.0, 1.0, B738DR_reverse_both)
			simDR_throttle_2 = B738_rescale(0.06, 0, 1.0, 1.0, B738DR_reverse_both)
		end
	end
	
end

--*************************************************************************************--
--** 				       CREATE READ-WRITE CUSTOM DATAREFS                         **--
--*************************************************************************************--

B738DR_kp					= create_dataref("laminar/pid/kp", "number", B738DR_kp_DRhandler)
B738DR_ki					= create_dataref("laminar/pid/ki", "number", B738DR_ki_DRhandler)
B738DR_kd					= create_dataref("laminar/pid/kd", "number", B738DR_kd_DRhandler)
B738DR_kf					= create_dataref("laminar/pid/kf", "number", B738DR_kf_DRhandler)
B738DR_bias					= create_dataref("laminar/pid/bias", "number", B738DR_bias_DRhandler)

B738DR_pid_p				= create_dataref("laminar/pid/p", "number")
B738DR_pid_i				= create_dataref("laminar/pid/i", "number")
B738DR_pid_d				= create_dataref("laminar/pid/d", "number")
B738DR_pid_out				= create_dataref("laminar/pid/out", "number")

B738DR_reverse_both			= create_dataref("laminar/B738/engine/reverse_both", "number", B738DR_reverse_both_DRhandler)

B738DR_yoke_roll			= create_dataref("laminar/yoke/roll", "number", B738DR_yoke_roll_DRhandler)
B738DR_yoke_pitch			= create_dataref("laminar/yoke/pitch", "number", B738DR_yoke_pitch_DRhandler)


B738DR_kill_glareshield	= create_dataref("laminar/B738/perf/kill_glareshield", "number", B738DR_kill_glareshield_DRhandler)


B738DR_test_test			= create_dataref("laminar/B738/test_test", "number", B738DR_test_test_DRhandler)
B738DR_test_test2			= create_dataref("laminar/B738/test_test2", "number", B738DR_test_test2_DRhandler)

-----
--B738DR_changed_flight_phase = create_dataref("laminar/B738/changed_flight_phase", "number", B738DR_changed_flight_phase_DRhandler)

B738DR_test_glare			= create_dataref("laminar/B738/test_glare", "number", B738DR_test_glare_DRhandler)

B738DR_mcp_hdg_dial			= create_dataref("laminar/B738/autopilot/mcp_hdg_dial", "number", B738DR_mcp_hdg_dial_DRhandler)
B738DR_mcp_alt_dial			= create_dataref("laminar/B738/autopilot/mcp_alt_dial", "number", B738DR_mcp_alt_dial_DRhandler)
vnav_alt_mode				= create_dataref("laminar/B738/autopilot/vnav_alt_mode", "number", B738DR_vnav_alt_mode_DRhandler)

B738DR_capt_map_mode		= create_dataref("laminar/B738/EFIS_control/capt/map_mode_pos", "number", B738DR_capt_map_mode_DRhandler)
B738DR_fo_map_mode			= create_dataref("laminar/B738/EFIS_control/fo/map_mode_pos", "number", B738DR_fo_map_mode_DRhandler)
B738DR_capt_exp_map_mode	= create_dataref("laminar/B738/EFIS_control/capt/exp_map", "number", B738DR_capt_exp_map_mode_DRhandler)
B738DR_fo_exp_map_mode		= create_dataref("laminar/B738/EFIS_control/fo/exp_map", "number", B738DR_fo_exp_map_mode_DRhandler)

B738DR_capt_vsd_map_mode	= create_dataref("laminar/B738/EFIS_control/capt/vsd_map", "number")
B738DR_fo_vsd_map_mode		= create_dataref("laminar/B738/EFIS_control/fo/vsd_map", "number")

B738DR_efis_map_range_capt 		= create_dataref("laminar/B738/EFIS/capt/map_range", "number", B738DR_efis_map_range_capt_DRhandler)
B738DR_efis_map_range_fo 		= create_dataref("laminar/B738/EFIS/fo/map_range", "number", B738DR_efis_map_range_fo_DRhandler)

B738DR_fmc_speed			= create_dataref("laminar/B738/autopilot/fmc_speed", "number", B738DR_fmc_speed_DRhandler)
B738DR_fmc_mode				= create_dataref("laminar/B738/autopilot/fmc_mode", "number", B738DR_fmc_mode_DRhandler)
B738DR_fmc_descent_now		= create_dataref("laminar/B738/autopilot/fmc_descent_now", "number", B738DR_fmc_descent_now_DRhandler)
B738DR_was_on_cruise		= create_dataref("laminar/B738/autopilot/fmc_was_on_cruise", "number", B738DR_was_on_cruise_DRhandler)

-- CLIMB
B738DR_fmc_climb_speed			= create_dataref("laminar/B738/autopilot/fmc_climb_speed", "number", B738DR_fmc_climb_speed_DRhandler)
B738DR_fmc_climb_speed_l		= create_dataref("laminar/B738/autopilot/fmc_climb_speed_l", "number", B738DR_fmc_climb_speed_l_DRhandler)
B738DR_fmc_climb_speed_mach		= create_dataref("laminar/B738/autopilot/fmc_climb_speed_mach", "number", B738DR_fmc_climb_speed_mach_DRhandler)
B738DR_fmc_climb_r_speed1		= create_dataref("laminar/B738/autopilot/fmc_climb_r_speed1", "number", B738DR_fmc_climb_r_speed1_DRhandler)
B738DR_fmc_climb_r_alt1			= create_dataref("laminar/B738/autopilot/fmc_climb_r_alt1", "number", B738DR_fmc_climb_r_alt1_DRhandler)
B738DR_fmc_climb_r_speed2		= create_dataref("laminar/B738/autopilot/fmc_climb_r_speed2", "number", B738DR_fmc_climb_r_speed2_DRhandler)
B738DR_fmc_climb_r_alt2			= create_dataref("laminar/B738/autopilot/fmc_climb_r_alt2", "number", B738DR_fmc_climb_r_alt2_DRhandler)

-- CRUISE
B738DR_fmc_cruise_speed			= create_dataref("laminar/B738/autopilot/fmc_cruise_speed", "number", B738DR_fmc_cruise_speed_DRhandler)
B738DR_fmc_cruise_speed_mach	= create_dataref("laminar/B738/autopilot/fmc_cruise_speed_mach", "number", B738DR_fmc_cruise_speed_mach_DRhandler)
B738DR_fmc_cruise_alt			= create_dataref("laminar/B738/autopilot/fmc_cruise_alt", "number", B738DR_fmc_cruise_alt_DRhandler)

-- DESCENT
B738DR_fmc_descent_speed		= create_dataref("laminar/B738/autopilot/fmc_descent_speed", "number", B738DR_fmc_descent_speed_DRhandler)
B738DR_fmc_descent_speed_mach	= create_dataref("laminar/B738/autopilot/fmc_descent_speed_mach", "number", B738DR_fmc_descent_speed_mach_DRhandler)
B738DR_fmc_descent_alt			= create_dataref("laminar/B738/autopilot/fmc_descent_alt", "number", B738DR_fmc_descent_alt_DRhandler)
B738DR_fmc_descent_r_speed1		= create_dataref("laminar/B738/autopilot/fmc_descent_r_speed1", "number", B738DR_fmc_descent_r_speed1_DRhandler)
B738DR_fmc_descent_r_alt1		= create_dataref("laminar/B738/autopilot/fmc_descent_r_alt1", "number", B738DR_fmc_descent_r_alt1_DRhandler)
B738DR_fmc_descent_r_speed2		= create_dataref("laminar/B738/autopilot/fmc_descent_r_speed2", "number", B738DR_fmc_descent_r_speed2_DRhandler)
B738DR_fmc_descent_r_alt2		= create_dataref("laminar/B738/autopilot/fmc_descent_r_alt2", "number", B738DR_fmc_descent_r_alt2_DRhandler)
-- APPROACH
B738DR_fmc_approach_alt			= create_dataref("laminar/B738/autopilot/fmc_approach_alt", "number", B738DR_fmc_approach_alt_DRhandler)


-- FLARE
B738DR_thrust_vvi_1				= create_dataref("laminar/B738/flare/thrust_vvi_1", "number", B738DR_thrust_vvi_1_DRhandler)
B738DR_thrust_vvi_2				= create_dataref("laminar/B738/flare/thrust_vvi_2", "number", B738DR_thrust_vvi_2_DRhandler)
B738DR_thrust_ratio_1			= create_dataref("laminar/B738/flare/thrust_ratio_1", "number", B738DR_thrust_ratio_1_DRhandler)
B738DR_thrust_ratio_2			= create_dataref("laminar/B738/flare/thrust_ratio_2", "number", B738DR_thrust_ratio_2_DRhandler)
B738DR_flare_ratio				= create_dataref("laminar/B738/flare/flare_ratio", "number", B738DR_flare_ratio_DRhandler)
B738DR_pitch_last				= create_dataref("laminar/B738/flare/pitch_last", "number", B738DR_pitch_last_DRhandler)
B738DR_pitch_ratio				= create_dataref("laminar/B738/flare/pitch_ratio", "number", B738DR_pitch_ratio_DRhandler)
B738DR_pitch_offset				= create_dataref("laminar/B738/flare/pitch_offset", "number", B738DR_pitch_offset_DRhandler)
B738DR_vvi_last					= create_dataref("laminar/B738/flare/vvi_last", "number", B738DR_vvi_last_DRhandler)
B738DR_flare_offset				= create_dataref("laminar/B738/flare/flare_offset", "number", B738DR_flare_offset_DRhandler)

B738DR_n1_set_source = 			create_dataref("laminar/B738/toggle_switch/n1_set_source", "number", B738DR_n1_set_source_DRhandler)
B738DR_n1_set_adjust = 			create_dataref("laminar/B738/toggle_switch/n1_set_adjust", "number", B738DR_n1_set_adjust_DRhandler)

B738DR_minim_fo = 				create_dataref("laminar/B738/EFIS_control/fo/minimums", "number", B738DR_minim_fo_DRhandler)
B738DR_minim_capt = 			create_dataref("laminar/B738/EFIS_control/cpt/minimums", "number", B738DR_minim_capt_DRhandler)

B738DR_minim_dh_fo = 				create_dataref("laminar/B738/EFIS_control/fo/minimums_dh", "number", B738DR_minim_dh_fo_DRhandler)
B738DR_minim_dh_capt = 				create_dataref("laminar/B738/EFIS_control/capt/minimums_dh", "number", B738DR_minim_dh_capt_DRhandler)

B738DR_minim_fo_pfd = 				create_dataref("laminar/B738/EFIS_control/fo/minimums_pfd", "number", B738DR_minim_fo_DRhandler)
B738DR_minim_capt_pfd = 			create_dataref("laminar/B738/EFIS_control/cpt/minimums_pfd", "number", B738DR_minim_capt_DRhandler)
B738DR_minim_dh_fo_pfd = 			create_dataref("laminar/B738/EFIS_control/fo/minimums_dh_pfd", "number", B738DR_minim_dh_fo_DRhandler)
B738DR_minim_dh_capt_pfd = 			create_dataref("laminar/B738/EFIS_control/capt/minimums_dh_pfd", "number", B738DR_minim_dh_capt_DRhandler)

--*************************************************************************************--
--** 				             CUSTOM COMMAND HANDLERS            			     **--
--*************************************************************************************--

-- First Officer MINIMUMS SET SWITCH
function B738_fo_minimums_up_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_minim_fo == 1 then
			B738DR_minim_fo = 0
			if B738DR_dspl_ctrl_pnl > -1 then
				B738DR_dh_copilot = radio_dh_copilot
				simDR_dh_copilot = B738DR_dh_copilot
			end
		end
		if B738DR_dspl_ctrl_pnl == 0 then
			B738DR_minim_fo_pfd = B738DR_minim_fo
		elseif B738DR_dspl_ctrl_pnl == 1 then
			B738DR_minim_capt_pfd = B738DR_minim_fo
			B738DR_minim_fo_pfd = B738DR_minim_fo
			simDR_dh_pilot = simDR_dh_copilot
			B738DR_dh_pilot = B738DR_dh_copilot
			baro_dh_pilot_disable = baro_dh_copilot_disable
		end
	end
end

function B738_fo_minimums_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_minim_fo == 0 then
			B738DR_minim_fo = 1
			if B738DR_dspl_ctrl_pnl > -1 then
				B738DR_dh_copilot = baro_dh_copilot
				simDR_dh_copilot = 0
				if simDR_altitude_copilot < baro_dh_copilot then
					baro_dh_copilot_disable = 1
				end
			end
		end
		if B738DR_dspl_ctrl_pnl == 0 then
			B738DR_minim_fo_pfd = B738DR_minim_fo
		elseif B738DR_dspl_ctrl_pnl == 1 then
			B738DR_minim_capt_pfd = B738DR_minim_fo
			B738DR_minim_fo_pfd = B738DR_minim_fo
			simDR_dh_pilot = simDR_dh_copilot
			B738DR_dh_pilot = B738DR_dh_copilot
			baro_dh_pilot_disable = baro_dh_copilot_disable
		end
	end
end

-- Captain MINIMUMS SET SWITCH
function B738_cpt_minimums_up_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_minim_capt == 1 then
			B738DR_minim_capt = 0
			if B738DR_dspl_ctrl_pnl < 1 then
				B738DR_dh_pilot = radio_dh_pilot
				simDR_dh_pilot = B738DR_dh_pilot
			end
		end
		if B738DR_dspl_ctrl_pnl == 0 then
			B738DR_minim_capt_pfd = B738DR_minim_capt
		elseif B738DR_dspl_ctrl_pnl == -1 then
			B738DR_minim_capt_pfd = B738DR_minim_capt
			B738DR_minim_fo_pfd = B738DR_minim_capt
			simDR_dh_copilot = simDR_dh_pilot
			B738DR_dh_copilot = B738DR_dh_pilot
			baro_dh_copilot_disable = baro_dh_pilot_disable
		end
	end
end

function B738_cpt_minimums_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_minim_capt == 0 then
			B738DR_minim_capt = 1
			if B738DR_dspl_ctrl_pnl < 1 then
				B738DR_dh_pilot = baro_dh_pilot
				simDR_dh_pilot = 0
				if simDR_altitude_pilot < baro_dh_pilot then
					baro_dh_pilot_disable = 1
				end
			end
		end
		if B738DR_dspl_ctrl_pnl == 0 then
			B738DR_minim_capt_pfd = B738DR_minim_capt
		elseif B738DR_dspl_ctrl_pnl == -1 then
			B738DR_minim_capt_pfd = B738DR_minim_capt
			B738DR_minim_fo_pfd = B738DR_minim_capt
			simDR_dh_copilot = simDR_dh_pilot
			B738DR_dh_copilot = B738DR_dh_pilot
			baro_dh_copilot_disable = baro_dh_pilot_disable
		end
	end
end


function B738_ctrl_panel()
	
	if in_hpa_cnt == 0 then
		in_hpa_cnt = 1
	elseif in_hpa_cnt == 1 then
		in_hpa_cnt = 2
		B738DR_efis_baro_mode_capt = B738DR_baro_in_hpa
		B738DR_efis_baro_mode_capt_pfd = B738DR_baro_in_hpa
		B738DR_efis_baro_mode_fo = B738DR_baro_in_hpa
		B738DR_efis_baro_mode_fo_pfd = B738DR_baro_in_hpa
		
		B738DR_minim_capt = B738DR_min_baro_radio
		B738DR_minim_capt_pfd = B738DR_min_baro_radio
		B738DR_minim_fo = B738DR_min_baro_radio
		B738DR_minim_fo_pfd = B738DR_min_baro_radio
		
		B738DR_efis_vor1_capt_pfd = B738DR_efis_vor1_capt_pos
		B738DR_efis_vor2_capt_pfd = B738DR_efis_vor2_capt_pos
		B738DR_efis_vor1_fo_pfd = B738DR_efis_vor1_fo_pos
		B738DR_efis_vor2_fo_pfd = B738DR_efis_vor2_fo_pos
	end
	
	
	if B738DR_dspl_ctrl_pnl ~= dspl_ctrl_pnl_old then
		if B738DR_dspl_ctrl_pnl == -1 then
			-- CTRL PNL both Captain
			B738DR_minim_fo_pfd = B738DR_minim_capt
			baro_dh_copilot = baro_dh_pilot
			radio_dh_copilot = radio_dh_pilot
			if B738DR_minim_fo_pfd == 0 then
				B738DR_minim_fo_pfd = 1
				B738DR_dh_copilot = baro_dh_copilot
				simDR_dh_copilot = simDR_dh_pilot
				if simDR_altitude_copilot < baro_dh_copilot then
					baro_dh_copilot_disable = 1
				end
			else
				B738DR_minim_fo_pfd = 0
				B738DR_dh_copilot = radio_dh_copilot
				simDR_dh_copilot = B738DR_dh_copilot
			end
			
			B738DR_efis_fo_wxr_on = 0
			B738DR_efis_fo_vor_on = B738DR_efis_vor_on
			B738DR_efis_fo_fix_on = B738DR_efis_fix_on
			B738DR_efis_fo_apt_on = B738DR_efis_apt_on
			B738DR_efis_data_fo_status = B738DR_efis_data_capt_status
			
			B738DR_baro_sel_copilot_show = B738DR_baro_sel_pilot_show
			simDR_barometer_setting_fo = simDR_barometer_setting_capt
			B738DR_baro_set_std_copilot = B738DR_baro_set_std_pilot
			B738DR_baro_sel_in_hg_copilot = B738DR_baro_sel_in_hg_pilot
			baro_sel_co_old = baro_sel_old
			
			B738DR_efis_baro_mode_fo_pfd = B738DR_efis_baro_mode_capt_pfd
			
			B738DR_efis_vor1_fo_pfd = B738DR_efis_vor1_capt_pfd
			B738DR_efis_vor2_fo_pfd = B738DR_efis_vor2_capt_pfd
			simDR_vor1_fo = simDR_vor1_capt
			simDR_vor2_fo = simDR_vor2_capt
			
		elseif B738DR_dspl_ctrl_pnl == 1 then
			-- CTRL PNL both First Officer
			B738DR_minim_capt_pfd = B738DR_minim_fo
			baro_dh_pilot = baro_dh_copilot
			radio_dh_pilot = radio_dh_copilot
			if B738DR_minim_capt_pfd == 0 then
				B738DR_minim_capt_pfd = 1
				B738DR_dh_pilot = baro_dh_pilot
				simDR_dh_pilot = simDR_dh_copilot
				if simDR_altitude_pilot < baro_dh_pilot then
					baro_dh_pilot_disable = 1
				end
			else
				B738DR_minim_capt_pfd = 0
				B738DR_dh_pilot = radio_dh_pilot
				simDR_dh_pilot = B738DR_dh_pilot
			end
			
			B738DR_efis_wxr_on = 0
			B738DR_efis_vor_on = B738DR_efis_fo_vor_on
			B738DR_efis_fix_on = B738DR_efis_fo_fix_on
			B738DR_efis_apt_on = B738DR_efis_fo_apt_on
			B738DR_efis_data_capt_status = B738DR_efis_data_fo_status
			
			B738DR_baro_sel_pilot_show = B738DR_baro_sel_copilot_show
			simDR_barometer_setting_capt = simDR_barometer_setting_fo
			B738DR_baro_set_std_pilot = B738DR_baro_set_std_copilot
			B738DR_baro_sel_in_hg_pilot = B738DR_baro_sel_in_hg_copilot
			baro_sel_old = baro_sel_co_old
			
			B738DR_efis_baro_mode_capt_pfd = B738DR_efis_baro_mode_fo_pfd
			
			B738DR_efis_vor1_capt_pfd = B738DR_efis_vor1_fo_pfd
			B738DR_efis_vor2_capt_pfd = B738DR_efis_vor2_fo_pfd
			simDR_vor1_capt = simDR_vor1_fo
			simDR_vor2_capt = simDR_vor2_fo
			
		else
			--CTRL PNL Captain and First Officer
			B738DR_minim_fo_pfd = B738DR_minim_fo
			B738DR_minim_capt_pfd = B738DR_minim_capt
			B738DR_efis_baro_mode_capt_pfd = B738DR_efis_baro_mode_capt
			B738DR_efis_baro_mode_fo_pfd = B738DR_efis_baro_mode_fo
			B738DR_baro_sel_in_hg_pilot = B738DR_baro_sel_in_hg_copilot
			B738DR_baro_sel_in_hg_copilot = B738DR_baro_sel_in_hg_pilot
			
			B738DR_efis_vor1_capt_pfd = B738DR_efis_vor1_capt_pos
			B738DR_efis_vor2_capt_pfd = B738DR_efis_vor2_capt_pos
			B738DR_efis_vor1_fo_pfd = B738DR_efis_vor1_fo_pos
			B738DR_efis_vor2_fo_pfd = B738DR_efis_vor2_fo_pos
			
			if B738DR_efis_vor1_capt_pfd == 1 then
				simDR_vor1_capt = 2
			else
				simDR_vor1_capt = 1
			end
			if B738DR_efis_vor2_capt_pfd == 1 then
				simDR_vor2_capt = 2
			else
				simDR_vor2_capt = 1
			end
			if B738DR_efis_vor1_fo_pfd == 1 then
				simDR_vor1_fo = 2
			else
				simDR_vor1_fo = 1
			end
			if B738DR_efis_vor2_fo_pfd == 1 then
				simDR_vor2_fo = 2
			else
				simDR_vor2_fo = 1
			end
		end
	end
	dspl_ctrl_pnl_old = B738DR_dspl_ctrl_pnl
	
end

-- CAPTAIN EFIS CONTROLS

function B738_dh_pilot_up_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl < 1 then
		if phase == 0 then
			B738DR_minim_dh_capt = 1
			if B738DR_minim_capt == 0 then	--radio DH
				if B738DR_dh_pilot <= 2499 then
					B738DR_dh_pilot = B738DR_dh_pilot + 1
					radio_dh_pilot = B738DR_dh_pilot
				end
			else	-- baro DH
				if B738DR_dh_pilot <= 14999 then
					B738DR_dh_pilot = B738DR_dh_pilot + 1
					baro_dh_pilot = B738DR_dh_pilot
				end
			end
		elseif phase == 1 and duration > 1 then
			B738DR_minim_dh_capt = 2
			dh_timer = dh_timer + SIM_PERIOD
			dh_timer2 = dh_timer2 + SIM_PERIOD
			if dh_timer2 > DH_STEP2 then
				if B738DR_minim_capt == 0 then	--radio DH
					if B738DR_dh_pilot <= 2490 then
						B738DR_dh_pilot = B738DR_dh_pilot + 10
						radio_dh_pilot = B738DR_dh_pilot
					else
						B738DR_dh_pilot = 2500
						radio_dh_pilot = B738DR_dh_pilot
					end
				else	-- baro DH
					if B738DR_dh_pilot <= 14990 then
						B738DR_dh_pilot = B738DR_dh_pilot + 10
						baro_dh_pilot = B738DR_dh_pilot
					else
						B738DR_dh_pilot = 15000
						baro_dh_pilot = B738DR_dh_pilot
					end
				end
				dh_timer = 0
				dh_timer2 = DH_STEP2
			else
				if dh_timer > DH_STEP then
					if B738DR_minim_capt == 0 then	--radio DH
						if B738DR_dh_pilot <= 2490 then
							B738DR_dh_pilot = B738DR_dh_pilot + 10
							radio_dh_pilot = B738DR_dh_pilot
						else
							B738DR_dh_pilot = 2500
							radio_dh_pilot = B738DR_dh_pilot
						end
					else	-- baro DH
						if B738DR_dh_pilot <= 14990 then
							B738DR_dh_pilot = B738DR_dh_pilot + 10
							baro_dh_pilot = B738DR_dh_pilot
						else
							B738DR_dh_pilot = 15000
							baro_dh_pilot = B738DR_dh_pilot
						end
					end
					dh_timer = 0
				end
			end
		elseif phase == 2 then
			B738DR_minim_dh_capt = 0
			dh_timer = 0
			dh_timer2 = 0
		end
		if B738DR_dspl_ctrl_pnl == -1 then
			B738DR_dh_copilot = B738DR_dh_pilot
			radio_dh_copilot = radio_dh_pilot
			baro_dh_copilot = baro_dh_pilot
		end
	else
		if phase == 0 then
			B738DR_minim_dh_capt = 1
		elseif phase == 1 and duration > 1 then
			B738DR_minim_dh_capt = 2
		elseif phase == 2 then
			B738DR_minim_dh_capt = 0
		end
	end
end

function B738_dh_pilot_dn_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl < 1 then
		if phase == 0 then
			B738DR_minim_dh_capt = -1
			if B738DR_dh_pilot >= 1 then
				B738DR_dh_pilot = B738DR_dh_pilot - 1
			end
			if B738DR_minim_capt == 0 then	--radio DH
				radio_dh_pilot = B738DR_dh_pilot
			else	-- baro DH
				baro_dh_pilot = B738DR_dh_pilot
			end
		elseif phase == 1 and duration > 1 then
			B738DR_minim_dh_capt = -2
			dh_timer = dh_timer + SIM_PERIOD
			dh_timer2 = dh_timer2 + SIM_PERIOD
			if dh_timer2 > DH_STEP2 then
				if B738DR_dh_pilot >= 10 then
					B738DR_dh_pilot = B738DR_dh_pilot - 10
				else
					B738DR_dh_pilot = 0
				end
				if B738DR_minim_capt == 0 then	--radio DH
					radio_dh_pilot = B738DR_dh_pilot
				else	-- baro DH
					baro_dh_pilot = B738DR_dh_pilot
				end
				dh_timer = 0
				dh_timer2 = DH_STEP2
			else
				if dh_timer > DH_STEP then
					if B738DR_dh_pilot >= 10 then
						B738DR_dh_pilot = B738DR_dh_pilot - 10
					else
						B738DR_dh_pilot = 0
					end
					if B738DR_minim_capt == 0 then	--radio DH
						radio_dh_pilot = B738DR_dh_pilot
					else	-- baro DH
						baro_dh_pilot = B738DR_dh_pilot
					end
					dh_timer = 0
				end
			end
		elseif phase == 2 then
			B738DR_minim_dh_capt = 0
			dh_timer = 0
			dh_timer2 = 0
		end
		if B738DR_dspl_ctrl_pnl == -1 then
			B738DR_dh_copilot = B738DR_dh_pilot
			radio_dh_copilot = radio_dh_pilot
			baro_dh_copilot = baro_dh_pilot
		end
	else
		if phase == 0 then
			B738DR_minim_dh_capt = 1
		elseif phase == 1 and duration > 1 then
			B738DR_minim_dh_capt = 2
		elseif phase == 2 then
			B738DR_minim_dh_capt = 0
		end
	end
end

function B738_dh_pilot_up1_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl < 1 then
		if phase < 2 then
			B738DR_minim_dh_capt = 1
			dh_timer = dh_timer + SIM_PERIOD
			dh_timer2 = dh_timer2 + SIM_PERIOD
			if dh_timer2 > DH_STEP2 then
				if B738DR_minim_capt == 0 then	--radio DH
					if B738DR_dh_pilot <= 2499 then
						B738DR_dh_pilot = B738DR_dh_pilot + 1
						radio_dh_pilot = B738DR_dh_pilot
					end
				else	-- baro DH
					if B738DR_dh_pilot <= 14999 then
						B738DR_dh_pilot = B738DR_dh_pilot + 1
						baro_dh_pilot = B738DR_dh_pilot
					end
				end
				dh_timer = 0
				dh_timer2 = DH_STEP2
			else
				if dh_timer > DH_STEP then
					if B738DR_minim_capt == 0 then	--radio DH
						if B738DR_dh_pilot <= 2499 then
							B738DR_dh_pilot = B738DR_dh_pilot + 1
							radio_dh_pilot = B738DR_dh_pilot
						end
					else	-- baro DH
						if B738DR_dh_pilot <= 14999 then
							B738DR_dh_pilot = B738DR_dh_pilot + 1
							baro_dh_pilot = B738DR_dh_pilot
						end
					end
					dh_timer = 0
				end
			end
		elseif phase == 2 then
			B738DR_minim_dh_capt = 0
			dh_timer = 0
			dh_timer2 = 0
		end
		if B738DR_dspl_ctrl_pnl == -1 then
			B738DR_dh_copilot = B738DR_dh_pilot
			radio_dh_copilot = radio_dh_pilot
			baro_dh_copilot = baro_dh_pilot
		end
	else
		if phase < 2 then
			B738DR_minim_dh_capt = 1
		elseif phase == 2 then
			B738DR_minim_dh_capt = 0
		end
	end
end

function B738_dh_pilot_up2_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl < 1 then
		if phase < 2 then
			B738DR_minim_dh_capt = 2
			dh_timer = dh_timer + SIM_PERIOD
			dh_timer2 = dh_timer2 + SIM_PERIOD
			if dh_timer2 > DH_STEP2 then
				if B738DR_minim_capt == 0 then	--radio DH
					if B738DR_dh_pilot <= 2490 then
						B738DR_dh_pilot = B738DR_dh_pilot + 10
						radio_dh_pilot = B738DR_dh_pilot
					else
						B738DR_dh_pilot = 2500
						radio_dh_pilot = B738DR_dh_pilot
					end
				else	-- baro DH
					if B738DR_dh_pilot <= 14990 then
						B738DR_dh_pilot = B738DR_dh_pilot + 10
						baro_dh_pilot = B738DR_dh_pilot
					else
						B738DR_dh_pilot = 15000
						baro_dh_pilot = B738DR_dh_pilot
					end
				end
				dh_timer = 0
				dh_timer2 = DH_STEP2
			else
				if dh_timer > DH_STEP then
					if B738DR_minim_capt == 0 then	--radio DH
						if B738DR_dh_pilot <= 2490 then
							B738DR_dh_pilot = B738DR_dh_pilot + 10
							radio_dh_pilot = B738DR_dh_pilot
						else
							B738DR_dh_pilot = 2500
							radio_dh_pilot = B738DR_dh_pilot
						end
					else	-- baro DH
						if B738DR_dh_pilot <= 14990 then
							B738DR_dh_pilot = B738DR_dh_pilot + 10
							baro_dh_pilot = B738DR_dh_pilot
						else
							B738DR_dh_pilot = 15000
							baro_dh_pilot = B738DR_dh_pilot
						end
					end
					dh_timer = 0
				end
			end
		elseif phase == 2 then
			B738DR_minim_dh_capt = 0
			dh_timer = 0
			dh_timer2 = 0
		end
		if B738DR_dspl_ctrl_pnl == -1 then
			B738DR_dh_copilot = B738DR_dh_pilot
			radio_dh_copilot = radio_dh_pilot
			baro_dh_copilot = baro_dh_pilot
		end
	else
		if phase < 2 then
			B738DR_minim_dh_capt = 1
		elseif phase == 2 then
			B738DR_minim_dh_capt = 0
		end
	end
end

function B738_dh_pilot_dn1_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl < 1 then
		if phase < 2 then
			B738DR_minim_dh_capt = -1
			dh_timer = dh_timer + SIM_PERIOD
			dh_timer2 = dh_timer2 + SIM_PERIOD
			if dh_timer2 > DH_STEP2 then
				if B738DR_dh_pilot >= 1 then
					B738DR_dh_pilot = B738DR_dh_pilot - 1
				end
				if B738DR_minim_capt == 0 then	--radio DH
					radio_dh_pilot = B738DR_dh_pilot
				else	-- baro DH
					baro_dh_pilot = B738DR_dh_pilot
				end
				dh_timer = 0
				dh_timer2 = DH_STEP2
			else
				if dh_timer > DH_STEP then
					if B738DR_dh_pilot >= 1 then
						B738DR_dh_pilot = B738DR_dh_pilot - 1
					end
					if B738DR_minim_capt == 0 then	--radio DH
						radio_dh_pilot = B738DR_dh_pilot
					else	-- baro DH
						baro_dh_pilot = B738DR_dh_pilot
					end
					dh_timer = 0
				end
			end
		elseif phase == 2 then
			B738DR_minim_dh_capt = 0
			dh_timer = 0
			dh_timer2 = 0
		end
		if B738DR_dspl_ctrl_pnl == -1 then
			B738DR_dh_copilot = B738DR_dh_pilot
			radio_dh_copilot = radio_dh_pilot
			baro_dh_copilot = baro_dh_pilot
		end
	else
		if phase < 2 then
			B738DR_minim_dh_capt = 1
		elseif phase == 2 then
			B738DR_minim_dh_capt = 0
		end
	end
end

function B738_dh_pilot_dn2_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl < 1 then
		if phase < 2 then
			B738DR_minim_dh_capt = -2
			dh_timer = dh_timer + SIM_PERIOD
			dh_timer2 = dh_timer2 + SIM_PERIOD
			if dh_timer2 > DH_STEP2 then
				if B738DR_dh_pilot >= 10 then
					B738DR_dh_pilot = B738DR_dh_pilot - 10
				else
					B738DR_dh_pilot = 0
				end
				if B738DR_minim_capt == 0 then	--radio DH
					radio_dh_pilot = B738DR_dh_pilot
				else	-- baro DH
					baro_dh_pilot = B738DR_dh_pilot
				end
				dh_timer = 0
				dh_timer2 = DH_STEP2
			else
				if dh_timer > DH_STEP then
					if B738DR_dh_pilot >= 10 then
						B738DR_dh_pilot = B738DR_dh_pilot - 10
					else
						B738DR_dh_pilot = 0
					end
					if B738DR_minim_capt == 0 then	--radio DH
						radio_dh_pilot = B738DR_dh_pilot
					else	-- baro DH
						baro_dh_pilot = B738DR_dh_pilot
					end
					dh_timer = 0
				end
			end
		elseif phase == 2 then
			B738DR_minim_dh_capt = 0
			dh_timer = 0
			dh_timer2 = 0
		end
		if B738DR_dspl_ctrl_pnl == -1 then
			B738DR_dh_copilot = B738DR_dh_pilot
			radio_dh_copilot = radio_dh_pilot
			baro_dh_copilot = baro_dh_pilot
		end
	else
		if phase < 2 then
			B738DR_minim_dh_capt = 1
		elseif phase == 2 then
			B738DR_minim_dh_capt = 0
		end
	end
end



function B738_efis_wxr_capt_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl < 1 then
		if phase == 0 then
			B738DR_efis_wxr_capt = 1
			if B738DR_efis_wxr_on == 0 then
				B738DR_efis_wxr_on = 1
			else
				B738DR_efis_wxr_on = 0
			end
			B738DR_efis_fo_wxr_on = 0
			--simCMD_efis_wxr:once()
		elseif phase == 2 then
			B738DR_efis_wxr_capt = 0
		end
		if B738DR_dspl_ctrl_pnl == -1 then
			if B738DR_efis_wxr_on == 0 then
				B738DR_efis_fo_wxr_on = 0
			elseif B738DR_efis_wxr_on == 1 then
				B738DR_efis_fo_wxr_on = 0
			end
		end
	else
		if phase == 0 then
			B738DR_efis_wxr_capt = 1
		elseif phase == 2 then
			B738DR_efis_wxr_capt = 0
		end
	end
end

function B738_efis_sta_capt_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl < 1 then
		if phase == 0 then
			B738DR_efis_sta_capt = 1
			--simCMD_efis_sta:once()
			if B738DR_efis_vor_on == 0 then
				B738DR_efis_vor_on = 1
			else
				B738DR_efis_vor_on = 0
			end
		elseif phase == 2 then
			B738DR_efis_sta_capt = 0
		end
		if B738DR_dspl_ctrl_pnl == -1 then
			B738DR_efis_fo_vor_on = B738DR_efis_vor_on
		end
	else
		if phase == 0 then
			B738DR_efis_sta_capt = 1
		elseif phase == 2 then
			B738DR_efis_sta_capt = 0
		end
	end
end

function B738_efis_wpt_capt_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl < 1 then
		if phase == 0 then
			B738DR_efis_wpt_capt = 1
			if B738DR_efis_fix_on == 0 then
				B738DR_efis_fix_on = 1
			else
				B738DR_efis_fix_on = 0
			end
			--simCMD_efis_wpt:once()
		elseif phase == 2 then
			B738DR_efis_wpt_capt = 0
		end
		if B738DR_dspl_ctrl_pnl == -1 then
			B738DR_efis_fo_fix_on = B738DR_efis_fix_on
		end
	else
		if phase == 0 then
			B738DR_efis_wpt_capt = 1
		elseif phase == 2 then
			B738DR_efis_wpt_capt = 0
		end
	end
end

function B738_efis_arpt_capt_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl < 1 then
		if phase == 0 then
			B738DR_efis_arpt_capt = 1
	--		simCMD_efis_arpt:once()
			if B738DR_efis_apt_on == 0 then
				B738DR_efis_apt_on = 1
			else
				B738DR_efis_apt_on = 0
			end
		elseif phase == 2 then
			B738DR_efis_arpt_capt = 0
		end
		if B738DR_dspl_ctrl_pnl == -1 then
			B738DR_efis_fo_apt_on = B738DR_efis_apt_on
		end
	else
		if phase == 0 then
			B738DR_efis_arpt_capt = 1
		elseif phase == 2 then
			B738DR_efis_arpt_capt = 0
		end
	end
end

function B738_efis_data_capt_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl < 1 then
		if phase == 0 then
			B738DR_efis_data_capt = 1
			B738DR_efis_data_capt_status = 1 - B738DR_efis_data_capt_status
		elseif phase == 2 then
			B738DR_efis_data_capt = 0
		end
		if B738DR_dspl_ctrl_pnl == -1 then
			B738DR_efis_data_fo_status = B738DR_efis_data_capt_status
		end
	else
		if phase == 0 then
			B738DR_efis_data_capt = 1
		elseif phase == 2 then
			B738DR_efis_data_capt = 0
		end
	end
end

function B738_efis_pos_capt_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_efis_pos_capt = 1
		if cpt_pos_enable == 0 then
			cpt_pos_enable = 1
		else
			cpt_pos_enable = 0
		end
	elseif phase == 2 then
		B738DR_efis_pos_capt = 0
	end
	
end

function B738_efis_terr_capt_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_efis_terr_capt = 1
		if cpt_terr_enable == 0 then
			cpt_terr_enable = 1
		else
			cpt_terr_enable = 0
		end
	elseif phase == 2 then
		B738DR_efis_terr_capt = 0
	end
end

function B738_efis_rst_capt_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl < 1 then
		if phase == 0 then
			B738DR_efis_rst_capt = 1
			B738DR_dh_pilot = 0
			dh_min_block_pilot = 1
			if B738DR_minim_capt == 0 then	--radio DH
				radio_dh_pilot = 0
				simDR_dh_pilot = 0
			else	-- baro DH
				baro_dh_pilot = 0
			end
		elseif phase == 2 then
			B738DR_efis_rst_capt = 0
		end
		if B738DR_dspl_ctrl_pnl == -1 then
			baro_dh_copilot = baro_dh_pilot
			radio_dh_copilot = radio_dh_pilot
			B738DR_dh_copilot = B738DR_dh_pilot
			dh_min_block_copilot = dh_min_block_pilot
			simDR_dh_copilot = simDR_dh_pilot
		end
	else
		if phase == 0 then
			B738DR_efis_rst_capt = 1
		elseif phase == 2 then
			B738DR_efis_rst_capt = 0
		end
	end
end

function B738_efis_ctr_capt_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_efis_ctr_capt = 1
		-- if B738DR_capt_map_mode < 2 then
			-- if B738DR_capt_exp_map_mode == 0 then
				-- B738DR_capt_exp_map_mode = 1
			-- else
				-- B738DR_capt_exp_map_mode = 0
			-- end
		-- end
		if B738DR_capt_map_mode < 2 then
			-- APP/VOR mode
			if capt_exp_vor_app_mode == 0 then
				capt_exp_vor_app_mode = 1
			else
				capt_exp_vor_app_mode = 0
			end
			B738DR_capt_exp_map_mode = capt_exp_vor_app_mode
			B738DR_capt_vsd_map_mode = 0
		elseif B738DR_capt_map_mode == 2 then
			-- MAP mode
			if capt_vsd_map_mode == 1 then
				capt_vsd_map_mode = 0
				capt_exp_map_mode = 1
			elseif capt_exp_map_mode == 0 then
				capt_vsd_map_mode = 1
			else
				capt_exp_map_mode = 0
			end
			B738DR_capt_exp_map_mode = capt_exp_map_mode
			B738DR_capt_vsd_map_mode = capt_vsd_map_mode
		else
			-- PLN mode
			B738DR_capt_exp_map_mode = 1
			B738DR_capt_vsd_map_mode = 0
		end
		
	elseif phase == 2 then
		B738DR_efis_ctr_capt = 0
	end
end

function B738_efis_tfc_capt_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_efis_tfc_capt = 1
		if cpt_tcas_enable == 0 then
			cpt_tcas_enable = 1
		else
			cpt_tcas_enable = 0
		end
		
		-- if B738DR_EFIS_TCAS_on == 0 then
			-- B738DR_EFIS_TCAS_on = 1
		-- else
			-- B738DR_EFIS_TCAS_on = 0
		-- end
		
--		simCMD_efis_tfc:once()
	elseif phase == 2 then
		B738DR_efis_tfc_capt = 0
	end
end

function B738_efis_std_capt_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl < 1 then
		if phase == 0 then
			B738DR_efis_std_capt = 1
			if B738DR_baro_set_std_pilot == 0 then
				B738DR_baro_set_std_pilot = 1
	--			B738DR_baro_sel_pilot_show = 1
				baro_sel_old = B738DR_baro_sel_in_hg_pilot
				simDR_barometer_setting_capt = 29.92
			else
				B738DR_baro_set_std_pilot = 0
	--			B738DR_baro_sel_pilot_show = 0
				simDR_barometer_setting_capt = B738DR_baro_sel_in_hg_pilot
			end
			B738DR_baro_sel_pilot_show = 0
		elseif phase == 2 then
			B738DR_efis_std_capt = 0
		end
		if B738DR_dspl_ctrl_pnl == -1 then
			B738DR_baro_sel_copilot_show = B738DR_baro_sel_pilot_show
			simDR_barometer_setting_fo = simDR_barometer_setting_capt
			B738DR_baro_set_std_copilot = B738DR_baro_set_std_pilot
			B738DR_baro_sel_in_hg_copilot = B738DR_baro_sel_in_hg_pilot
			baro_sel_co_old = baro_sel_old
		end
	else
		if phase == 0 then
			B738DR_efis_std_capt = 1
		elseif phase == 2 then
			B738DR_efis_std_capt = 0
		end
	end
end

function B738_efis_mtrs_capt_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl < 1 then
		if phase == 0 then
			B738DR_efis_mtrs_capt = 1
			if B738DR_capt_alt_mode_meters == 0 then
				B738DR_capt_alt_mode_meters = 1
			elseif B738DR_capt_alt_mode_meters == 1 then
				B738DR_capt_alt_mode_meters = 0
			end
		elseif phase == 2 then
			B738DR_efis_mtrs_capt = 0
		end
		if B738DR_dspl_ctrl_pnl == -1 then
			B738DR_fo_alt_mode_meters = B738DR_capt_alt_mode_meters
		end
	else
		if phase == 0 then
			B738DR_efis_mtrs_capt = 1
		elseif phase == 2 then
			B738DR_efis_mtrs_capt = 0
		end
	end
end

function B738_efis_fpv_capt_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl < 1 then
		if phase == 0 then
			B738DR_efis_fpv_capt = 1
			if B738DR_capt_fpv_on == 0 then
				B738DR_capt_fpv_on = 1
			elseif B738DR_capt_fpv_on == 1 then
				B738DR_capt_fpv_on = 0
			end
		elseif phase == 2 then
			B738DR_efis_fpv_capt = 0
		end
		if B738DR_dspl_ctrl_pnl == -1 then
			B738DR_fo_fpv_on = B738DR_capt_fpv_on
		end
	else
		if phase == 0 then
			B738DR_efis_fpv_capt = 1
		elseif phase == 2 then
			B738DR_efis_fpv_capt = 0
		end
	end
end

function B738_efis_baro_mode_capt_up_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl < 1 then
		if phase == 0 then
			if B738DR_efis_baro_mode_capt == 0 then
				B738DR_efis_baro_mode_capt = 1
			end
			B738DR_efis_baro_mode_capt_pfd = B738DR_efis_baro_mode_capt
			if B738DR_dspl_ctrl_pnl == -1 then
				B738DR_efis_baro_mode_fo_pfd = B738DR_efis_baro_mode_capt_pfd
			end
		end
	else
		if phase == 0 then
			if B738DR_efis_baro_mode_capt == 0 then
				B738DR_efis_baro_mode_capt = 1
			end
		end
	end
end

function B738_efis_baro_mode_capt_dn_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl < 1 then
		if phase == 0 then
			if B738DR_efis_baro_mode_capt == 1 then
				B738DR_efis_baro_mode_capt = 0
			end
			B738DR_efis_baro_mode_capt_pfd = B738DR_efis_baro_mode_capt
			if B738DR_dspl_ctrl_pnl == -1 then
				B738DR_efis_baro_mode_fo_pfd = B738DR_efis_baro_mode_capt_pfd
			end
		end
	else
		if phase == 0 then
			if B738DR_efis_baro_mode_capt == 1 then
				B738DR_efis_baro_mode_capt = 0
			end
		end
	end
end

function B738_efis_vor1_capt_up_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl < 1 then
		if phase == 0 then
			if B738DR_efis_vor1_capt_pos == -1 then
				B738DR_efis_vor1_capt_pos = 0
				simDR_vor1_capt = 1
			elseif B738DR_efis_vor1_capt_pos == 0 then
				B738DR_efis_vor1_capt_pos = 1
				simDR_vor1_capt = 2
			end
			B738DR_efis_vor1_capt_pfd = B738DR_efis_vor1_capt_pos
			if B738DR_dspl_ctrl_pnl == -1 then
				simDR_vor1_fo = simDR_vor1_capt
				B738DR_efis_vor1_fo_pfd = B738DR_efis_vor1_capt_pfd
			end
		end
	else
		if phase == 0 then
			if B738DR_efis_vor1_capt_pos == -1 then
				B738DR_efis_vor1_capt_pos = 0
			elseif B738DR_efis_vor1_capt_pos == 0 then
				B738DR_efis_vor1_capt_pos = 1
			end
		end
	end
end

function B738_efis_vor1_capt_dn_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl < 1 then
		if phase == 0 then
			if B738DR_efis_vor1_capt_pos == 1 then
				B738DR_efis_vor1_capt_pos = 0
				simDR_vor1_capt = 1
			elseif B738DR_efis_vor1_capt_pos == 0 then
				B738DR_efis_vor1_capt_pos = -1
				simDR_vor1_capt = 1
			end
			B738DR_efis_vor1_capt_pfd = B738DR_efis_vor1_capt_pos
			if B738DR_dspl_ctrl_pnl == -1 then
				simDR_vor1_fo = simDR_vor1_capt
				B738DR_efis_vor1_fo_pfd = B738DR_efis_vor1_capt_pfd
			end
		end
	else
		if phase == 0 then
			if B738DR_efis_vor1_capt_pos == 1 then
				B738DR_efis_vor1_capt_pos = 0
			elseif B738DR_efis_vor1_capt_pos == 0 then
				B738DR_efis_vor1_capt_pos = -1
			end
		end
	end
end

function B738_efis_vor2_capt_up_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl < 1 then
		if phase == 0 then
			if B738DR_efis_vor2_capt_pos == -1 then
				B738DR_efis_vor2_capt_pos = 0
				simDR_vor2_capt = 1
			elseif B738DR_efis_vor2_capt_pos == 0 then
				B738DR_efis_vor2_capt_pos = 1
				simDR_vor2_capt = 2
			end
			B738DR_efis_vor2_capt_pfd = B738DR_efis_vor2_capt_pos
			if B738DR_dspl_ctrl_pnl == -1 then
				simDR_vor2_fo = simDR_vor2_capt
				B738DR_efis_vor2_fo_pfd = B738DR_efis_vor2_capt_pfd
			end
		end
	else
			if B738DR_efis_vor2_capt_pos == -1 then
				B738DR_efis_vor2_capt_pos = 0
			elseif B738DR_efis_vor2_capt_pos == 0 then
				B738DR_efis_vor2_capt_pos = 1
			end
	end
end
			
function B738_efis_vor2_capt_dn_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl < 1 then
		if phase == 0 then
			if B738DR_efis_vor2_capt_pos == 1 then
				B738DR_efis_vor2_capt_pos = 0
				simDR_vor2_capt = 1
			elseif B738DR_efis_vor2_capt_pos == 0 then
				B738DR_efis_vor2_capt_pos = -1
				simDR_vor2_capt = 1
			end
			B738DR_efis_vor2_capt_pfd = B738DR_efis_vor2_capt_pos
			if B738DR_dspl_ctrl_pnl == -1 then
				simDR_vor2_fo = simDR_vor2_capt
				B738DR_efis_vor2_fo_pfd = B738DR_efis_vor2_capt_pfd
			end
		end
	else
		if phase == 0 then
			if B738DR_efis_vor2_capt_pos == 1 then
				B738DR_efis_vor2_capt_pos = 0
			elseif B738DR_efis_vor2_capt_pos == 0 then
				B738DR_efis_vor2_capt_pos = -1
			end
		end
	end
end


function B738_efis_map_range_capt_up_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_efis_map_range_capt == 0 then
			B738DR_efis_map_range_capt = 1
		elseif B738DR_efis_map_range_capt == 1 then
			B738DR_efis_map_range_capt = 2
		elseif B738DR_efis_map_range_capt == 2 then
			B738DR_efis_map_range_capt = 3
		elseif B738DR_efis_map_range_capt == 3 then
			B738DR_efis_map_range_capt = 4
		elseif B738DR_efis_map_range_capt == 4 then
			B738DR_efis_map_range_capt = 5
		elseif B738DR_efis_map_range_capt == 5 then
			B738DR_efis_map_range_capt = 6
		elseif B738DR_efis_map_range_capt == 6 then
			B738DR_efis_map_range_capt = 7
		end
	end
end

function B738_efis_map_range_capt_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_efis_map_range_capt == 1 then
			B738DR_efis_map_range_capt = 0
		elseif B738DR_efis_map_range_capt == 2 then
			B738DR_efis_map_range_capt = 1
		elseif B738DR_efis_map_range_capt == 3 then
			B738DR_efis_map_range_capt = 2
		elseif B738DR_efis_map_range_capt == 4 then
			B738DR_efis_map_range_capt = 3
		elseif B738DR_efis_map_range_capt == 5 then
			B738DR_efis_map_range_capt = 4
		elseif B738DR_efis_map_range_capt == 6 then
			B738DR_efis_map_range_capt = 5
		elseif B738DR_efis_map_range_capt == 7 then
			B738DR_efis_map_range_capt = 6
		end
	end
end

-- FIRST OFFICER EFIS CONTROLS

function B738_dh_copilot_up_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl > -1 then
		if phase == 0 then
			B738DR_minim_dh_fo = 1
			if B738DR_minim_fo == 0 then	--radio DH
				if B738DR_dh_copilot <= 2499 then
					B738DR_dh_copilot = B738DR_dh_copilot + 1
					radio_dh_copilot = B738DR_dh_copilot
				end
			else	-- baro DH
				if B738DR_dh_copilot <= 14999 then
					B738DR_dh_copilot = B738DR_dh_copilot + 1
					baro_dh_copilot = B738DR_dh_copilot
				end
			end
		elseif phase == 1 and duration > 1 then
			B738DR_minim_dh_fo = 2
			dh_timer = dh_timer + SIM_PERIOD
			dh_timer2 = dh_timer2 + SIM_PERIOD
			if dh_timer2 > DH_STEP2 then
				if B738DR_minim_fo == 0 then	--radio DH
					if B738DR_dh_copilot <= 2490 then
						B738DR_dh_copilot = B738DR_dh_copilot + 10
						radio_dh_copilot = B738DR_dh_copilot
					else
						B738DR_dh_copilot = 2500
						radio_dh_copilot = B738DR_dh_copilot
					end
				else	-- baro DH
					if B738DR_dh_copilot <= 14990 then
						B738DR_dh_copilot = B738DR_dh_copilot + 10
						baro_dh_copilot = B738DR_dh_copilot
					else
						B738DR_dh_copilot = 15000
						baro_dh_copilot = B738DR_dh_copilot
					end
				end
				dh_timer = 0
				dh_timer2 = DH_STEP2
			else
				if dh_timer > DH_STEP then
					if B738DR_minim_fo == 0 then	--radio DH
						if B738DR_dh_copilot <= 2490 then
							B738DR_dh_copilot = B738DR_dh_copilot + 10
							radio_dh_copilot = B738DR_dh_copilot
						else
							B738DR_dh_copilot = 2500
							radio_dh_copilot = B738DR_dh_copilot
						end
					else	-- baro DH
						if B738DR_dh_copilot <= 14990 then
							B738DR_dh_copilot = B738DR_dh_copilot + 10
							baro_dh_copilot = B738DR_dh_copilot
						else
							B738DR_dh_copilot = 15000
							baro_dh_copilot = B738DR_dh_copilot
						end
					end
					dh_timer = 0
				end
			end
		elseif phase == 2 then
			B738DR_minim_dh_fo = 0
			dh_timer = 0
			dh_timer2 = 0
		end
		if B738DR_dspl_ctrl_pnl == 1 then
			B738DR_dh_pilot = B738DR_dh_copilot
			radio_dh_pilot = radio_dh_copilot
			baro_dh_pilot = baro_dh_copilot
		end
	else
		if phase == 0 then
			B738DR_minim_dh_fo = 1
		elseif phase == 1 and duration > 1 then
			B738DR_minim_dh_fo = 2
		elseif phase == 2 then
			B738DR_minim_dh_fo = 0
		end
	end
end

function B738_dh_copilot_dn_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl > -1 then
		if phase == 0 then
			B738DR_minim_dh_fo = -1
			if B738DR_dh_copilot >= 1 then
				B738DR_dh_copilot = B738DR_dh_copilot - 1
			end
			if B738DR_minim_fo == 0 then	--radio DH
				radio_dh_copilot = B738DR_dh_copilot
			else	-- baro DH
				baro_dh_copilot = B738DR_dh_copilot
			end
		elseif phase == 1 and duration > 1 then
			B738DR_minim_dh_fo = -2
			dh_timer = dh_timer + SIM_PERIOD
			dh_timer2 = dh_timer2 + SIM_PERIOD
			if dh_timer2 > DH_STEP2 then
				if B738DR_dh_copilot >= 10 then
					B738DR_dh_copilot = B738DR_dh_copilot - 10
				else
					B738DR_dh_copilot = 0
				end
				if B738DR_minim_fo == 0 then	--radio DH
					radio_dh_copilot = B738DR_dh_copilot
				else	-- baro DH
					baro_dh_copilot = B738DR_dh_copilot
				end
				dh_timer = 0
				dh_timer2 = DH_STEP2
			else
				if dh_timer > DH_STEP then
					if B738DR_dh_copilot >= 10 then
						B738DR_dh_copilot = B738DR_dh_copilot - 10
					else
						B738DR_dh_copilot = 0
					end
					if B738DR_minim_fo == 0 then	--radio DH
						radio_dh_copilot = B738DR_dh_copilot
					else	-- baro DH
						baro_dh_copilot = B738DR_dh_copilot
					end
					dh_timer = 0
				end
			end
		elseif phase == 2 then
			B738DR_minim_dh_fo = 0
			dh_timer = 0
			dh_timer2 = 0
		end
		if B738DR_dspl_ctrl_pnl == 1 then
			B738DR_dh_pilot = B738DR_dh_copilot
			radio_dh_pilot = radio_dh_copilot
			baro_dh_pilot = baro_dh_copilot
		end
	else
		if phase == 0 then
			B738DR_minim_dh_fo = 1
		elseif phase == 1 and duration > 1 then
			B738DR_minim_dh_fo = 2
		elseif phase == 2 then
			B738DR_minim_dh_fo = 0
		end
	end
end

function B738_dh_copilot_up1_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl > -1 then
		if phase < 2 then
			B738DR_minim_dh_fo = 1
			dh_timer = dh_timer + SIM_PERIOD
			dh_timer2 = dh_timer2 + SIM_PERIOD
			if dh_timer2 > DH_STEP2 then
				if B738DR_minim_fo == 0 then	--radio DH
					if B738DR_dh_copilot <= 2499 then
						B738DR_dh_copilot = B738DR_dh_copilot + 1
						radio_dh_copilot = B738DR_dh_copilot
					end
				else	-- baro DH
					if B738DR_dh_copilot <= 14999 then
						B738DR_dh_copilot = B738DR_dh_copilot + 1
						baro_dh_copilot = B738DR_dh_copilot
					end
				end
				dh_timer = 0
				dh_timer2 = DH_STEP2
			else
				if dh_timer > DH_STEP then
					if B738DR_minim_fo == 0 then	--radio DH
						if B738DR_dh_copilot <= 2499 then
							B738DR_dh_copilot = B738DR_dh_copilot + 1
							radio_dh_copilot = B738DR_dh_copilot
						end
					else	-- baro DH
						if B738DR_dh_copilot <= 14999 then
							B738DR_dh_copilot = B738DR_dh_copilot + 1
							baro_dh_copilot = B738DR_dh_copilot
						end
					end
					dh_timer = 0
				end
			end
		elseif phase == 2 then
			B738DR_minim_dh_fo = 0
			dh_timer = 0
			dh_timer2 = 0
		end
		if B738DR_dspl_ctrl_pnl == 1 then
			B738DR_dh_pilot = B738DR_dh_copilot
			radio_dh_pilot = radio_dh_copilot
			baro_dh_pilot = baro_dh_copilot
		end
	else
		if phase < 2 then
			B738DR_minim_dh_fo = 1
		elseif phase == 2 then
			B738DR_minim_dh_fo = 0
		end
	end
end

function B738_dh_copilot_up2_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl > -1 then
		if phase < 2 then
			B738DR_minim_dh_fo = 2
			dh_timer = dh_timer + SIM_PERIOD
			dh_timer2 = dh_timer2 + SIM_PERIOD
			if dh_timer2 > DH_STEP2 then
				if B738DR_minim_fo == 0 then	--radio DH
					if B738DR_dh_copilot <= 2490 then
						B738DR_dh_copilot = B738DR_dh_copilot + 10
						radio_dh_copilot = B738DR_dh_copilot
					else
						B738DR_dh_copilot = 2500
						radio_dh_copilot = B738DR_dh_copilot
					end
				else	-- baro DH
					if B738DR_dh_copilot <= 14990 then
						B738DR_dh_copilot = B738DR_dh_copilot + 10
						baro_dh_copilot = B738DR_dh_copilot
					else
						B738DR_dh_copilot = 15000
						baro_dh_copilot = B738DR_dh_copilot
					end
				end
				dh_timer = 0
				dh_timer2 = DH_STEP2
			else
				if dh_timer > DH_STEP then
					if B738DR_minim_fo == 0 then	--radio DH
						if B738DR_dh_copilot <= 2490 then
							B738DR_dh_copilot = B738DR_dh_copilot + 10
							radio_dh_copilot = B738DR_dh_copilot
						else
							B738DR_dh_copilot = 2500
							radio_dh_copilot = B738DR_dh_copilot
						end
					else	-- baro DH
						if B738DR_dh_copilot <= 14990 then
							B738DR_dh_copilot = B738DR_dh_copilot + 10
							baro_dh_copilot = B738DR_dh_copilot
						else
							B738DR_dh_copilot = 15000
							baro_dh_copilot = B738DR_dh_copilot
						end
					end
					dh_timer = 0
				end
			end
		elseif phase == 2 then
			B738DR_minim_dh_fo = 0
			dh_timer = 0
			dh_timer2 = 0
		end
		if B738DR_dspl_ctrl_pnl == 1 then
			B738DR_dh_pilot = B738DR_dh_copilot
			radio_dh_pilot = radio_dh_copilot
			baro_dh_pilot = baro_dh_copilot
		end
	else
		if phase < 2 then
			B738DR_minim_dh_fo = 1
		elseif phase == 2 then
			B738DR_minim_dh_fo = 0
		end
	end
end

function B738_dh_copilot_dn1_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl > -1 then
		if phase < 2 then
			B738DR_minim_dh_fo = -1
			dh_timer = dh_timer + SIM_PERIOD
			dh_timer2 = dh_timer2 + SIM_PERIOD
			if dh_timer2 > DH_STEP2 then
				if B738DR_dh_copilot >= 1 then
					B738DR_dh_copilot = B738DR_dh_copilot - 1
				end
				if B738DR_minim_fo == 0 then	--radio DH
					radio_dh_copilot = B738DR_dh_copilot
				else	-- baro DH
					baro_dh_copilot = B738DR_dh_copilot
				end
				dh_timer = 0
				dh_timer2 = DH_STEP2
			else
				if dh_timer > DH_STEP then
					if B738DR_dh_copilot >= 1 then
						B738DR_dh_copilot = B738DR_dh_copilot - 1
					end
					if B738DR_minim_fo == 0 then	--radio DH
						radio_dh_copilot = B738DR_dh_copilot
					else	-- baro DH
						baro_dh_copilot = B738DR_dh_copilot
					end
					dh_timer = 0
				end
			end
		elseif phase == 2 then
			B738DR_minim_dh_fo = 0
			dh_timer = 0
			dh_timer2 = 0
		end
		if B738DR_dspl_ctrl_pnl == 1 then
			B738DR_dh_pilot = B738DR_dh_copilot
			radio_dh_pilot = radio_dh_copilot
			baro_dh_pilot = baro_dh_copilot
		end
	else
		if phase < 2 then
			B738DR_minim_dh_fo = 1
		elseif phase == 2 then
			B738DR_minim_dh_fo = 0
		end
	end
end

function B738_dh_copilot_dn2_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl > -1 then
		if phase < 2 then
			B738DR_minim_dh_fo = -2
			dh_timer = dh_timer + SIM_PERIOD
			dh_timer2 = dh_timer2 + SIM_PERIOD
			if dh_timer2 > DH_STEP2 then
				if B738DR_dh_copilot >= 10 then
					B738DR_dh_copilot = B738DR_dh_copilot - 10
				else
					B738DR_dh_copilot = 0
				end
				if B738DR_minim_fo == 0 then	--radio DH
					radio_dh_copilot = B738DR_dh_copilot
				else	-- baro DH
					baro_dh_copilot = B738DR_dh_copilot
				end
				dh_timer = 0
				dh_timer2 = DH_STEP2
			else
				if dh_timer > DH_STEP then
					if B738DR_dh_copilot >= 10 then
						B738DR_dh_copilot = B738DR_dh_copilot - 10
					else
						B738DR_dh_copilot = 0
					end
					if B738DR_minim_fo == 0 then	--radio DH
						radio_dh_copilot = B738DR_dh_copilot
					else	-- baro DH
						baro_dh_copilot = B738DR_dh_copilot
					end
					dh_timer = 0
				end
			end
		elseif phase == 2 then
			B738DR_minim_dh_fo = 0
			dh_timer = 0
			dh_timer2 = 0
		end
		if B738DR_dspl_ctrl_pnl == 1 then
			B738DR_dh_pilot = B738DR_dh_copilot
			radio_dh_pilot = radio_dh_copilot
			baro_dh_pilot = baro_dh_copilot
		end
	else
		if phase < 2 then
			B738DR_minim_dh_fo = 1
		elseif phase == 2 then
			B738DR_minim_dh_fo = 0
		end
	end
end

function B738_efis_wxr_fo_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl > -1 then
		if phase == 0 then
			B738DR_efis_wxr_fo = 1
			if B738DR_efis_fo_wxr_on == 0 then
				B738DR_efis_fo_wxr_on = 1
			else
				B738DR_efis_fo_wxr_on = 0
			end
			B738DR_efis_wxr_on = 0
			--simCMD_efis_wxr:once()
		elseif phase == 2 then
			B738DR_efis_wxr_fo = 0
		end
		if B738DR_dspl_ctrl_pnl == 1 then
			if B738DR_efis_fo_wxr_on == 0 then
				B738DR_efis_wxr_on = 0
			elseif B738DR_efis_fo_wxr_on == 1 then
				B738DR_efis_wxr_on = 0
			end
		end
	else
		if phase == 0 then
			B738DR_efis_wxr_fo = 1
		elseif phase == 2 then
			B738DR_efis_wxr_fo = 0
		end
	end
end

function B738_efis_sta_fo_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl > -1 then
		if phase == 0 then
			B738DR_efis_sta_fo = 1
			if B738DR_efis_fo_vor_on == 0 then
				B738DR_efis_fo_vor_on = 1
			else
				B738DR_efis_fo_vor_on = 0
			end
			--simCMD_efis_sta:once()
		elseif phase == 2 then
			B738DR_efis_sta_fo = 0
		end
		if B738DR_dspl_ctrl_pnl == 1 then
			B738DR_efis_vor_on = B738DR_efis_fo_vor_on
		end
	else
		if phase == 0 then
			B738DR_efis_sta_fo = 1
		elseif phase == 2 then
			B738DR_efis_sta_fo = 0
		end
	end
end

function B738_efis_wpt_fo_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl > -1 then
		if phase == 0 then
			B738DR_efis_wpt_fo = 1
			if B738DR_efis_fo_fix_on == 0 then
				B738DR_efis_fo_fix_on = 1
			else
				B738DR_efis_fo_fix_on = 0
			end
			--simCMD_efis_wpt:once()
		elseif phase == 2 then
			B738DR_efis_wpt_fo = 0
		end
		if B738DR_dspl_ctrl_pnl == 1 then
			B738DR_efis_fix_on = B738DR_efis_fo_fix_on
		end
	else
		if phase == 0 then
			B738DR_efis_wpt_fo = 1
		elseif phase == 2 then
			B738DR_efis_wpt_fo = 0
		end
	end
end

function B738_efis_arpt_fo_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl > -1 then
		if phase == 0 then
			B738DR_efis_arpt_fo = 1
			if B738DR_efis_fo_apt_on == 0 then
				B738DR_efis_fo_apt_on = 1
			else
				B738DR_efis_fo_apt_on = 0
			end
			--simCMD_efis_arpt:once()
		elseif phase == 2 then
			B738DR_efis_arpt_fo = 0
		end
		if B738DR_dspl_ctrl_pnl == 1 then
			B738DR_efis_apt_on = B738DR_efis_fo_apt_on
		end
	else
		if phase == 0 then
			B738DR_efis_arpt_fo = 1
		elseif phase == 2 then
			B738DR_efis_arpt_fo = 0
		end
	end
end

function B738_efis_data_fo_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl > -1 then
		if phase == 0 then
			B738DR_efis_data_fo = 1
			B738DR_efis_data_fo_status = 1 - B738DR_efis_data_fo_status
		elseif phase == 2 then
			B738DR_efis_data_fo = 0
		end
		if B738DR_dspl_ctrl_pnl == 1 then
			B738DR_efis_data_capt_status = B738DR_efis_data_fo_status
		end
	else
		if phase == 0 then
			B738DR_efis_data_fo = 1
		elseif phase == 2 then
			B738DR_efis_data_fo = 0
		end
	end
end

function B738_efis_pos_fo_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_efis_pos_fo = 1
		if cpt_pos_enable == 0 then
			cpt_pos_enable = 1
		else
			cpt_pos_enable = 0
		end
	elseif phase == 2 then
		B738DR_efis_pos_fo = 0
	end
end

function B738_efis_terr_fo_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_efis_terr_fo = 1
		if fo_terr_enable == 0 then
			fo_terr_enable = 1
		else
			fo_terr_enable = 0
		end
	elseif phase == 2 then
		B738DR_efis_terr_fo = 0
	end
end
function B738_efis_rst_fo_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl > -1 then
		if phase == 0 then
			B738DR_efis_rst_fo = 1
			B738DR_dh_copilot = 0
			dh_min_block_copilot = 1
			if B738DR_minim_fo == 0 then	--radio DH
				radio_dh_copilot = 0
				simDR_dh_copilot = 0
			else	-- baro DH
				baro_dh_copilot = 0
			end
		elseif phase == 2 then
			B738DR_efis_rst_fo = 0
		end
		if B738DR_dspl_ctrl_pnl == 1 then
			baro_dh_pilot = baro_dh_copilot
			radio_dh_pilot = radio_dh_copilot
			B738DR_dh_pilot = B738DR_dh_copilot
			dh_min_block_pilot = dh_min_block_copilot
			simDR_dh_pilot = simDR_dh_copilot
		end
	else
		if phase == 0 then
			B738DR_efis_rst_fo = 1
		elseif phase == 2 then
			B738DR_efis_rst_fo = 0
		end
	end
end

function B738_efis_ctr_fo_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_efis_ctr_fo = 1
		-- if B738DR_fo_map_mode < 2 then
			-- if B738DR_fo_exp_map_mode == 0 then
				-- B738DR_fo_exp_map_mode = 1
			-- else
				-- B738DR_fo_exp_map_mode = 0
			-- end
		-- end
		
		if B738DR_fo_map_mode < 2 then
			-- APP/VOR mode
			if fo_exp_vor_app_mode == 0 then
				fo_exp_vor_app_mode = 1
			else
				fo_exp_vor_app_mode = 0
			end
			B738DR_fo_exp_map_mode = fo_exp_vor_app_mode
			B738DR_fo_vsd_map_mode = 0
		elseif B738DR_fo_map_mode == 2 then
			-- MAP mode
			if fo_vsd_map_mode == 1 then
				fo_vsd_map_mode = 0
				fo_exp_map_mode = 1
			elseif fo_exp_map_mode == 0 then
				fo_vsd_map_mode = 1
			else
				fo_exp_map_mode = 0
			end
			B738DR_fo_exp_map_mode = fo_exp_map_mode
			B738DR_fo_vsd_map_mode = fo_vsd_map_mode
		else
			-- PLN mode
			B738DR_fo_exp_map_mode = 1
			B738DR_fo_vsd_map_mode = 0
		end
		
	elseif phase == 2 then
		B738DR_efis_ctr_fo = 0
	end
end

function B738_efis_tfc_fo_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_efis_tfc_fo = 1
		if fo_tcas_enable == 0 then
			fo_tcas_enable = 1
		else
			fo_tcas_enable = 0
		end
		-- if B738DR_EFIS_TCAS_on == 0 then
			-- B738DR_EFIS_TCAS_on = 1
		-- else
			-- B738DR_EFIS_TCAS_on = 0
		-- end
--		simCMD_efis_tfc:once()
	elseif phase == 2 then
		B738DR_efis_tfc_fo = 0
	end
end

function B738_efis_std_fo_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl > -1 then
		if phase == 0 then
			B738DR_efis_std_fo = 1
			if B738DR_baro_set_std_copilot == 0 then
				B738DR_baro_set_std_copilot = 1
				baro_sel_co_old = B738DR_baro_sel_in_hg_copilot
				simDR_barometer_setting_fo = 29.92
	--			B738DR_baro_sel_copilot_show = 1
			else
				B738DR_baro_set_std_copilot = 0
	--			B738DR_baro_sel_copilot_show = 0
				simDR_barometer_setting_fo = B738DR_baro_sel_in_hg_copilot
			end
			B738DR_baro_sel_copilot_show = 0
		elseif phase == 2 then
			B738DR_efis_std_fo = 0
		end
		if B738DR_dspl_ctrl_pnl == 1 then
			B738DR_baro_sel_pilot_show = B738DR_baro_sel_copilot_show
			simDR_barometer_setting_capt = simDR_barometer_setting_fo
			B738DR_baro_set_std_pilot = B738DR_baro_set_std_copilot
			B738DR_baro_sel_in_hg_pilot = B738DR_baro_sel_in_hg_copilot
			baro_sel_old = baro_sel_co_old
		end
	else
		if phase == 0 then
			B738DR_efis_std_fo = 1
		elseif phase == 2 then
			B738DR_efis_std_fo = 0
		end
	end
end

function B738_efis_mtrs_fo_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl > -1 then
		if phase == 0 then
			B738DR_efis_mtrs_fo = 1
			if B738DR_fo_alt_mode_meters == 0 then
				B738DR_fo_alt_mode_meters = 1
			elseif B738DR_fo_alt_mode_meters == 1 then
				B738DR_fo_alt_mode_meters = 0
			end
		elseif phase == 2 then
			B738DR_efis_mtrs_fo = 0
		end
		if B738DR_dspl_ctrl_pnl == 1 then
			B738DR_capt_alt_mode_meters = B738DR_fo_alt_mode_meters
		end
	else
		if phase == 0 then
			B738DR_efis_mtrs_fo = 1
		elseif phase == 2 then
			B738DR_efis_mtrs_fo = 0
		end
	end
end

function B738_efis_fpv_fo_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl > -1 then
		if phase == 0 then
			B738DR_efis_fpv_fo = 1
			if B738DR_fo_fpv_on == 0 then
				B738DR_fo_fpv_on = 1
			elseif B738DR_fo_fpv_on == 1 then
				B738DR_fo_fpv_on = 0
			end
		elseif phase == 2 then
			B738DR_efis_fpv_fo = 0
		end
		if B738DR_dspl_ctrl_pnl == 1 then
			B738DR_capt_fpv_on = B738DR_fo_fpv_on
		end
	else
		if phase == 0 then
			B738DR_efis_fpv_fo = 1
		elseif phase == 2 then
			B738DR_efis_fpv_fo = 0
		end
	end
end

function B738_efis_baro_mode_fo_up_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl > -1 then
		if phase == 0 then
			if B738DR_efis_baro_mode_fo == 0 then
				B738DR_efis_baro_mode_fo = 1
			end
			B738DR_efis_baro_mode_fo_pfd = B738DR_efis_baro_mode_fo
			if B738DR_dspl_ctrl_pnl == 1 then
				B738DR_efis_baro_mode_capt_pfd = B738DR_efis_baro_mode_fo_pfd
			end
		end
	else
		if phase == 0 then
			if B738DR_efis_baro_mode_fo == 0 then
				B738DR_efis_baro_mode_fo = 1
			end
		end
	end
end

function B738_efis_baro_mode_fo_dn_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl > -1 then
		if phase == 0 then
			if B738DR_efis_baro_mode_fo == 1 then
				B738DR_efis_baro_mode_fo = 0
			end
			B738DR_efis_baro_mode_fo_pfd = B738DR_efis_baro_mode_fo
			if B738DR_dspl_ctrl_pnl == 1 then
				B738DR_efis_baro_mode_capt_pfd = B738DR_efis_baro_mode_fo_pfd
			end
		end
	else
		if phase == 0 then
			if B738DR_efis_baro_mode_fo == 1 then
				B738DR_efis_baro_mode_fo = 0
			end
		end
	end
end

function B738_efis_vor1_fo_up_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl > -1 then
		if phase == 0 then
			if B738DR_efis_vor1_fo_pos == -1 then
				B738DR_efis_vor1_fo_pos = 0
				simDR_vor1_fo = 1
			elseif B738DR_efis_vor1_fo_pos == 0 then
				B738DR_efis_vor1_fo_pos = 1
				simDR_vor1_fo = 2
			end
			B738DR_efis_vor1_fo_pfd = B738DR_efis_vor1_fo_pos
			if B738DR_dspl_ctrl_pnl == 1 then
				simDR_vor1_capt = simDR_vor1_fo
				B738DR_efis_vor1_capt_pfd = B738DR_efis_vor1_fo_pfd
			end
		end
	else
		if phase == 0 then
			if B738DR_efis_vor1_fo_pos == -1 then
				B738DR_efis_vor1_fo_pos = 0
			elseif B738DR_efis_vor1_fo_pos == 0 then
				B738DR_efis_vor1_fo_pos = 1
			end
		end
	end
end

function B738_efis_vor1_fo_dn_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl > -1 then
		if phase == 0 then
			if B738DR_efis_vor1_fo_pos == 1 then
				B738DR_efis_vor1_fo_pos = 0
				simDR_vor1_fo = 1
			elseif B738DR_efis_vor1_fo_pos == 0 then
				B738DR_efis_vor1_fo_pos = -1
				simDR_vor1_fo = 1
			end
			B738DR_efis_vor1_fo_pfd = B738DR_efis_vor1_fo_pos
			if B738DR_dspl_ctrl_pnl == 1 then
				simDR_vor1_capt = simDR_vor1_fo
				B738DR_efis_vor1_capt_pfd = B738DR_efis_vor1_fo_pfd
			end
		end
	else
		if phase == 0 then
			if B738DR_efis_vor1_fo_pos == 1 then
				B738DR_efis_vor1_fo_pos = 0
			elseif B738DR_efis_vor1_fo_pos == 0 then
				B738DR_efis_vor1_fo_pos = -1
			end
		end
	end
end

function B738_efis_vor2_fo_up_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl > -1 then
		if phase == 0 then
			if B738DR_efis_vor2_fo_pos == -1 then
				B738DR_efis_vor2_fo_pos = 0
				simDR_vor2_fo = 1
			elseif B738DR_efis_vor2_fo_pos == 0 then
				B738DR_efis_vor2_fo_pos = 1
				simDR_vor2_fo = 2
			end
			B738DR_efis_vor2_fo_pfd = B738DR_efis_vor2_fo_pos
			if B738DR_dspl_ctrl_pnl == 1 then
				simDR_vor2_capt = simDR_vor2_fo
				B738DR_efis_vor2_capt_pfd = B738DR_efis_vor2_fo_pfd
			end
		end
	else
		if phase == 0 then
			if B738DR_efis_vor2_fo_pos == -1 then
				B738DR_efis_vor2_fo_pos = 0
			elseif B738DR_efis_vor2_fo_pos == 0 then
				B738DR_efis_vor2_fo_pos = 1
			end
		end
	end
end
			
function B738_efis_vor2_fo_dn_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl > -1 then
		if phase == 0 then
			if B738DR_efis_vor2_fo_pos == 1 then
				B738DR_efis_vor2_fo_pos = 0
				simDR_vor2_fo = 1
			elseif B738DR_efis_vor2_fo_pos == 0 then
				B738DR_efis_vor2_fo_pos = -1
				simDR_vor2_fo = 1
			end
			B738DR_efis_vor2_fo_pfd = B738DR_efis_vor2_fo_pos
			if B738DR_dspl_ctrl_pnl == 1 then
				simDR_vor2_capt = simDR_vor2_fo
				B738DR_efis_vor2_capt_pfd = B738DR_efis_vor2_fo_pfd
			end
		end
	else
		if phase == 0 then
			if B738DR_efis_vor2_fo_pos == 1 then
				B738DR_efis_vor2_fo_pos = 0
			elseif B738DR_efis_vor2_fo_pos == 0 then
				B738DR_efis_vor2_fo_pos = -1
			end
		end
	end
end



function B738_efis_map_mode_capt_up_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_capt_map_mode == 0 then
			B738DR_capt_map_mode = 1
			--B738DR_fo_map_mode = 1
			--simDR_EFIS_mode = 1
		elseif B738DR_capt_map_mode == 1 then
			B738DR_capt_map_mode = 2
			--B738DR_fo_map_mode = 2
			--simDR_EFIS_mode = 2
		elseif B738DR_capt_map_mode == 2 then
			B738DR_capt_map_mode = 3
			--B738DR_fo_map_mode = 3
			--simDR_EFIS_mode = 4
		end
	end
end

function B738_efis_map_mode_capt_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_capt_map_mode == 1 then
			B738DR_capt_map_mode = 0
			--B738DR_fo_map_mode = 0
			--simDR_EFIS_mode = 0
		elseif B738DR_capt_map_mode == 2 then
			B738DR_capt_map_mode = 1
			--B738DR_fo_map_mode = 1
			--simDR_EFIS_mode = 1
		elseif B738DR_capt_map_mode == 3 then
			B738DR_capt_map_mode = 2
			--B738DR_fo_map_mode = 2
			--simDR_EFIS_mode = 2
		end
	end
end

function B738_efis_map_mode_fo_up_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_fo_map_mode == 0 then
			--B738DR_capt_map_mode = 1
			B738DR_fo_map_mode = 1
			--simDR_EFIS_mode = 1
		elseif B738DR_fo_map_mode == 1 then
			--B738DR_capt_map_mode = 2
			B738DR_fo_map_mode = 2
			--simDR_EFIS_mode = 2
		elseif B738DR_fo_map_mode == 2 then
			--B738DR_capt_map_mode = 3
			B738DR_fo_map_mode = 3
			--simDR_EFIS_mode = 4
		end
	end
end

function B738_efis_map_mode_fo_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_fo_map_mode == 1 then
			--B738DR_capt_map_mode = 0
			B738DR_fo_map_mode = 0
			--simDR_EFIS_mode = 0
		elseif B738DR_fo_map_mode == 2 then
			--B738DR_capt_map_mode = 1
			B738DR_fo_map_mode = 1
			--simDR_EFIS_mode = 1
		elseif B738DR_fo_map_mode == 3 then
			--B738DR_capt_map_mode = 2
			B738DR_fo_map_mode = 2
			--simDR_EFIS_mode = 2
		end
	end
end

function B738_efis_map_range_fo_up_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_efis_map_range_fo == 0 then
			B738DR_efis_map_range_fo = 1
		elseif B738DR_efis_map_range_fo == 1 then
			B738DR_efis_map_range_fo = 2
		elseif B738DR_efis_map_range_fo == 2 then
			B738DR_efis_map_range_fo = 3
		elseif B738DR_efis_map_range_fo == 3 then
			B738DR_efis_map_range_fo = 4
		elseif B738DR_efis_map_range_fo == 4 then
			B738DR_efis_map_range_fo = 5
		elseif B738DR_efis_map_range_fo == 5 then
			B738DR_efis_map_range_fo = 6
		elseif B738DR_efis_map_range_fo == 6 then
			B738DR_efis_map_range_fo = 7
		end
	end
end

function B738_efis_map_range_fo_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_efis_map_range_fo == 1 then
			B738DR_efis_map_range_fo = 0
		elseif B738DR_efis_map_range_fo == 2 then
			B738DR_efis_map_range_fo = 1
		elseif B738DR_efis_map_range_fo == 3 then
			B738DR_efis_map_range_fo = 2
		elseif B738DR_efis_map_range_fo == 4 then
			B738DR_efis_map_range_fo = 3
		elseif B738DR_efis_map_range_fo == 5 then
			B738DR_efis_map_range_fo = 4
		elseif B738DR_efis_map_range_fo == 6 then
			B738DR_efis_map_range_fo = 5
		elseif B738DR_efis_map_range_fo == 7 then
			B738DR_efis_map_range_fo = 6
		end
	end
end


------------ AUTOPILOT ------------------------------------------------------------------

function B738_autopilot_n1_press_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_autopilot_n1_pos = 1
		if B738DR_autopilot_autothr_arm_pos == 1 
		and (simDR_engine_N1_pct1 > 19 or simDR_engine_N1_pct2 > 19) then	-- A/T on
			if B738DR_autopilot_n1_status == 0 then
				if at_mode_eng == 3 and simDR_radio_height_pilot_ft > 800 then
					takeoff_n1 = 1
				else
					if ap_pitch_mode_eng == 5 and ap_pitch_mode == 5 and B738DR_pfd_alt_mode_arm ~= PFD_ALT_VNAV_ARM then
						B738DR_autopilot_vnav_alt_pfd = 0	-- PFD: VNAV ALT
						B738DR_autopilot_vnav_pth_pfd = 0	-- PFD: VNAV PTH
						B738DR_autopilot_vnav_spd_pfd = 0	-- PFD: VNAV SPD
						B738DR_ap_spd_interv_status = 0
						vnav_engaged = 0
						vnav_desc_spd = 0
						vnav_desc_protect_spd = 0
						ap_pitch_mode = 0
						ap_pitch_mode_eng = 0
					end
					at_mode = 1
					takeoff_n1 = 0
				end
			else
				if ap_pitch_mode_eng == 5 and ap_pitch_mode == 5 and B738DR_pfd_alt_mode_arm ~= PFD_ALT_VNAV_ARM then
					B738DR_autopilot_vnav_alt_pfd = 0	-- PFD: VNAV ALT
					B738DR_autopilot_vnav_pth_pfd = 0	-- PFD: VNAV PTH
					B738DR_autopilot_vnav_spd_pfd = 0	-- PFD: VNAV SPD
					B738DR_ap_spd_interv_status = 0
					vnav_engaged = 0
					vnav_desc_spd = 0
					vnav_desc_protect_spd = 0
					ap_pitch_mode = 0
					ap_pitch_mode_eng = 0
				elseif ap_pitch_mode == 2 then -- LVL CHG
					ap_pitch_mode = 0
				end
				at_mode = 0
			end
		end
	elseif phase == 2 then
		B738DR_autopilot_n1_pos = 0
	end
end

function B738_autopilot_speed_press_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_autopilot_speed_pos = 1
		if B738DR_autopilot_autothr_arm_pos == 1 
		and (simDR_engine_N1_pct1 > 19 or simDR_engine_N1_pct2 > 19) then
			--if simDR_autothrottle_status == 0 then
			if B738DR_autopilot_speed_status == 0 then
				if ap_pitch_mode == 5 then --and ap_pitch_mode_eng == 5 and B738DR_pfd_alt_mode_arm ~= PFD_ALT_VNAV_ARM then
					B738DR_autopilot_vnav_alt_pfd = 0	-- PFD: VNAV ALT
					B738DR_autopilot_vnav_pth_pfd = 0	-- PFD: VNAV PTH
					B738DR_autopilot_vnav_spd_pfd = 0	-- PFD: VNAV SPD
					B738DR_ap_spd_interv_status = 0
					vnav_engaged = 0
					vnav_desc_spd = 0
					vnav_desc_protect_spd = 0
					ap_pitch_mode = 0
					ap_pitch_mode_eng = 0
				elseif ap_pitch_mode == 2 then -- LVL CHG
					ap_pitch_mode = 0
				end
				at_mode = 2
			else
				at_mode = 0
			end
		end
	elseif phase == 2 then
		B738DR_autopilot_speed_pos = 0
	end
end

function B738_autopilot_lvl_chg_press_CMDhandler(phase, duration)
	if phase == 0 then
		
		local ap_disable = 0
		if simDR_radio_height_pilot_ft < 400 == 0 and ap_on == 0 then
			if simDR_on_ground_0 == 0 and simDR_on_ground_1 == 0 and simDR_on_ground_2 == 0 then		-- if aircraft in air
				ap_disable = 1
			end
		end
		
		B738DR_autopilot_lvl_chg_pos = 1 
		--if B738DR_autoland_status == 0 and bellow_400ft == 0 and B738DR_fd_on == 1
		if B738DR_autoland_status == 0 and ap_disable == 0 and B738DR_fd_on == 1
		and ap_app_block == 0 then		-- APP LOC and G/S captured  
			if B738DR_autopilot_lvl_chg_status == 0 then
				ap_pitch_mode = 2
			else
				ap_pitch_mode = 0
				at_mode = 0
			end
		end
	elseif phase == 2 then
		B738DR_autopilot_lvl_chg_pos = 0
	end
end

function B738_autopilot_vnav_press_CMDhandler(phase, duration)
	
	local vnav_enable2 = 0
	if simDR_on_ground_0 == 1 and simDR_on_ground_1 ==1 and simDR_on_ground_2 == 1 then
		if B738DR_autoland_status == 0 --and bellow_400ft == 0 
		and B738DR_autopilot_fd_pos == 1 and B738DR_autopilot_fd_fo_pos == 1
		and B738DR_end_route == 0 and B738DR_no_perf == 0
		and ap_app_block == 0 then
			vnav_enable2 = 1
		end
	end
	if bellow_400ft == 0  and B738DR_fd_on == 1 then
		if B738DR_autoland_status == 0 --and bellow_400ft == 0 
		--and B738DR_autopilot_fd_pos == 1 and B738DR_autopilot_fd_fo_pos == 1
		and B738DR_end_route == 0 and B738DR_no_perf == 0
		and ap_app_block == 0 then 
			vnav_enable2 = 1
		end
	end
	if phase == 0 then
		B738DR_autopilot_vnav_pos = 1
		-- if B738DR_autoland_status == 0 --and bellow_400ft == 0 
		-- and B738DR_autopilot_fd_pos == 1 and B738DR_autopilot_fd_fo_pos == 1
		-- and simDR_on_ground_0 == 1 and simDR_on_ground_1 ==1 and simDR_on_ground_2 == 1
		-- and B738DR_end_route == 0 and B738DR_no_perf == 0
		-- and ap_app_block == 0 then --ap_roll_mode == 4 and bellow_400ft == 0 then			-- LNAV on 
		if vnav_enable2 == 1 then
			if B738DR_autopilot_vnav_status == 0 then
				-- VNAV ALT
				if ap_pitch_mode == 3 then		-- ALT HLD
					if B738DR_flight_phase ~= 2 then
						vnav_alt_mode = 1
						vnav_alt_hld = 1
					else
						vnav_alt_mode = 0
					end
				else
					vnav_alt_mode = 0
				end
				ap_pitch_mode = 5
			else
				ap_pitch_mode = 0
			end
		else
			if B738DR_autopilot_vnav_status == 1 then
				ap_pitch_mode = 0
				simDR_ap_vvi_dial = roundDownToIncrement(simDR_ap_vvi_dial, 100 )
			end
		end
	elseif phase == 2 then
		B738DR_autopilot_vnav_pos = 0
	end

end

function B738_autopilot_co_press_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_autopilot_co_pos = 1
		--if B738DR_autopilot_vnav_status == 0 then --and bellow_400ft == 0 then	-- VNAV off
		if B738DR_show_ias == 1 then
			simCMD_autopilot_co:once()
		end
	elseif phase == 2 then
		B738DR_autopilot_co_pos = 0
	end
end

--------

function B738_nav_source_swap()

	if autopilot_fms_nav_status == 0 then
		B738DR_pfd_vorloc_lnav = 0
		if B738DR_autopilot_vhf_source_pos == -1 then
			simDR_autopilot_source = 0		-- NAV 1
			simDR_autopilot_fo_source = 0	-- NAV 1
		elseif B738DR_autopilot_vhf_source_pos == 0 then
		 	simDR_autopilot_source = 0		-- NAV 1
			simDR_autopilot_fo_source = 1	-- NAV 2
		elseif B738DR_autopilot_vhf_source_pos == 1 then
		 	simDR_autopilot_source = 1		-- NAV 2
			simDR_autopilot_fo_source = 1	-- NAV 2
		end
	elseif autopilot_fms_nav_status == 1 then
		simDR_autopilot_source = 2			-- LNAV
		simDR_autopilot_fo_source = 2		-- LNAV
--		simDR_autopilot_fo_source = 0		-- LNAV
		B738DR_pfd_vorloc_lnav = 1
	end

end

function B738_nav1_nav2_source()
	if B738DR_autopilot_vhf_source_pos == -1 then
		-- pilot
		B738DR_nav_flag_gs = simDR_nav1_flag_gs
		B738DR_nav_vert_dsp = simDR_nav1_vert_dsp
		B738DR_nav_horz_dsp = simDR_nav1_horz_dsp
		B738DR_nav_flag_ft = simDR_nav1_flag_ft
		B738DR_nav_nav_id = simDR_nav1_nav_id
		B738DR_nav_dme = simDR_nav1_dme
		B738DR_nav_has_dme = simDR_nav1_has_dme
		B738DR_nav_obs = simDR_nav1_obs_pilot
		B738DR_nav_bearing = simDR_nav1_bearing
		B738DR_nav_course = simDR_nav1_course_pilot
		B738DR_nav_type = simDR_nav1_type
		-- copilot
		B738DR_nav_flag_gs_fo = simDR_nav1_flag_gs
		B738DR_nav_vert_dsp_fo = simDR_nav1_vert_dsp
		B738DR_nav_horz_dsp_fo = simDR_nav1_horz_dsp
		B738DR_nav_flag_ft_fo = simDR_nav1_flag_ft
		B738DR_nav_nav_id_fo = simDR_nav1_nav_id
		B738DR_nav_dme_fo = simDR_nav1_dme
		B738DR_nav_has_dme_fo = simDR_nav1_has_dme
		B738DR_nav_obs_fo = simDR_nav1_obs_pilot
		B738DR_nav_bearing_fo = simDR_nav1_bearing
		B738DR_nav_course_fo = simDR_nav1_course_copilot
		B738DR_nav_type_fo = simDR_nav1_type
	elseif B738DR_autopilot_vhf_source_pos == 0 then
		-- pilot
		B738DR_nav_flag_gs = simDR_nav1_flag_gs
		B738DR_nav_vert_dsp = simDR_nav1_vert_dsp
		B738DR_nav_horz_dsp = simDR_nav1_horz_dsp
		B738DR_nav_flag_ft = simDR_nav1_flag_ft
		B738DR_nav_nav_id = simDR_nav1_nav_id
		B738DR_nav_dme = simDR_nav1_dme
		B738DR_nav_has_dme = simDR_nav1_has_dme
		B738DR_nav_obs = simDR_nav1_obs_pilot
		B738DR_nav_bearing = simDR_nav1_bearing
		B738DR_nav_course = simDR_nav1_course_pilot
		B738DR_nav_type = simDR_nav1_type
		-- copilot
		B738DR_nav_flag_gs_fo = simDR_nav2_flag_gs
		B738DR_nav_vert_dsp_fo = simDR_nav2_vert_dsp
		B738DR_nav_horz_dsp_fo = simDR_nav2_horz_dsp
		B738DR_nav_flag_ft_fo = simDR_nav2_flag_ft
		B738DR_nav_nav_id_fo = simDR_nav2_nav_id
		B738DR_nav_dme_fo = simDR_nav2_dme
		B738DR_nav_has_dme_fo = simDR_nav2_has_dme
		B738DR_nav_obs_fo = simDR_nav2_obs_copilot
		B738DR_nav_bearing_fo = simDR_nav2_bearing
		B738DR_nav_course_fo = simDR_nav2_course_copilot
		B738DR_nav_type_fo = simDR_nav2_type
	elseif B738DR_autopilot_vhf_source_pos == 1 then
		-- pilot
		B738DR_nav_flag_gs = simDR_nav2_flag_gs
		B738DR_nav_vert_dsp = simDR_nav2_vert_dsp
		B738DR_nav_horz_dsp = simDR_nav2_horz_dsp
		B738DR_nav_flag_ft = simDR_nav2_flag_ft
		B738DR_nav_nav_id = simDR_nav2_nav_id
		B738DR_nav_dme = simDR_nav2_dme
		B738DR_nav_has_dme = simDR_nav2_has_dme
		B738DR_nav_obs = simDR_nav2_obs_pilot
		B738DR_nav_bearing = simDR_nav2_bearing
		B738DR_nav_course = simDR_nav2_course_pilot
		B738DR_nav_type = simDR_nav2_type
		-- copilot
		B738DR_nav_flag_gs_fo = simDR_nav2_flag_gs
		B738DR_nav_vert_dsp_fo = simDR_nav2_vert_dsp
		B738DR_nav_horz_dsp_fo = simDR_nav2_horz_dsp
		B738DR_nav_flag_ft_fo = simDR_nav2_flag_ft
		B738DR_nav_nav_id_fo = simDR_nav2_nav_id
		B738DR_nav_dme_fo = simDR_nav2_dme
		B738DR_nav_has_dme_fo = simDR_nav2_has_dme
		B738DR_nav_obs_fo = simDR_nav2_obs_copilot
		B738DR_nav_bearing_fo = simDR_nav2_bearing
		B738DR_nav_course_fo = simDR_nav2_course_copilot
		B738DR_nav_type_fo = simDR_nav2_type
	end
end

function B738_autopilot_lnav_press_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_autopilot_lnav_pos = 1
		if B738DR_autoland_status == 0 and B738DR_end_route == 0  and B738DR_fd_on == 1
		and ap_app_block == 0 then		-- APP LOC and G/S captured  
			if B738DR_autopilot_lnav_status == 0 then
				-- if ap_roll_mode == 1 then
					--ap_roll_mode_old2 = ap_roll_mode
					--ap_roll_mode = 10	-- HDG / LNAV arm
				-- else
					ap_roll_mode = 4
				-- end
			else
				ap_roll_mode = 0
			end
		end
	elseif phase == 2 then
		B738DR_autopilot_lnav_pos = 0
	end
end



function B738_autopilot_vorloc_press_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_autopilot_vorloc_pos = 1
		if B738DR_autoland_status == 0 and bellow_400ft == 0  and B738DR_fd_on == 1
		and ap_app_block == 0 then		-- APP LOC and G/S captured  
			if B738DR_autopilot_vorloc_status == 0 then
				ap_roll_mode = 2
			else
				ap_roll_mode = 0
			end
		end
	elseif phase == 2 then
		B738DR_autopilot_vorloc_pos = 0
	end
end

function B738_autopilot_app_press_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_autopilot_app_pos = 1
		if B738DR_autoland_status == 0 and bellow_400ft == 0  and B738DR_fd_on == 1
		and ap_app_block == 0 then	-- APP LOC and G/S captured  
			if B738DR_autopilot_app_status == 0 then
				ap_roll_mode = 3
			else
				ap_roll_mode = 0
			end
		end
	elseif phase == 2 then
		B738DR_autopilot_app_pos = 0
	end
end

function B738_autopilot_hdg_sel_press_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_autopilot_hdg_sel_pos = 1
		if B738DR_autoland_status == 0  and B738DR_fd_on == 1
		and ap_app_block == 0 then		-- APP LOC and G/S captured  
			if B738DR_autopilot_hdg_sel_status == 0 then
				ap_roll_mode = 1
			else
				ap_roll_mode = 0
			end
		end
	elseif phase == 2 then
		B738DR_autopilot_hdg_sel_pos = 0
	end
end


function B738_autopilot_alt_hld_press_CMDhandler(phase, duration)
	if phase == 0 then
		
		local ap_disable = 0
		if simDR_radio_height_pilot_ft < 400 and ap_on == 0 then
			if simDR_on_ground_0 == 0 and simDR_on_ground_1 == 0 and simDR_on_ground_2 == 0 then		-- if aircraft in air
				ap_disable = 1
			end
		end
		
		B738DR_autopilot_alt_hld_pos = 1
		--if B738DR_autoland_status == 0 and bellow_400ft == 0  and B738DR_fd_on == 1
		if B738DR_autoland_status == 0 and ap_disable == 0  and B738DR_fd_on == 1
		and simDR_glideslope_status < 2 then
			if B738DR_autopilot_alt_hld_status == 0 then
				ap_pitch_mode = 3
			else
				ap_pitch_mode = 0
			end
		end
	elseif phase == 2 then
		B738DR_autopilot_alt_hld_pos = 0
	end
end


function B738_autopilot_vs_press_CMDhandler(phase, duration)
	if phase == 0 then
		
		local ap_disable = 0
		if simDR_radio_height_pilot_ft < 400 and ap_on == 0 then
			if simDR_on_ground_0 == 0 and simDR_on_ground_1 == 0 and simDR_on_ground_2 == 0 then		-- if aircraft in air
				ap_disable = 1
			end
		end
		
		B738DR_autopilot_vs_pos = 1
		--if B738DR_autoland_status == 0 and bellow_400ft == 0  and B738DR_fd_on == 1
		if B738DR_autoland_status == 0 and ap_disable == 0  and B738DR_fd_on == 1
		and ap_app_block == 0 then	-- APP LOC and G/S captured  
			if B738DR_autopilot_vs_status == 0 then
				ap_pitch_mode = 1
			else
				ap_pitch_mode = 0
				simDR_ap_vvi_dial = 0
			end
		else
			simDR_ap_vvi_dial = 0
		end
	elseif phase == 2 then
		B738DR_autopilot_vs_pos = 0
	end
end

function B738_autopilot_disconnect_toggle_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_autopilot_disconnect_pos == 0 then
			
			B738DR_autopilot_disconnect_pos = 1
		
			--B738DR_autopilot_fd_pos = 0
			--B738DR_autopilot_fd_fo_pos = 0
--			simCMD_disconnect:start()
			simDR_flight_dir_mode = 1

			simCMD_autopilot_cws:stop()
			autopilot_cws_a_status = 0
			autopilot_cws_b_status = 0
			autopilot_cmd_b_status = 0
			autopilot_cmd_a_status = 0
			B738DR_flare_status = 0
			B738DR_rollout_status = 0
			B738DR_autoland_status = 0
			B738DR_retard_status = 0
			B738DR_single_ch_status = 0
--			B738DR_autopilot_vnav_status = 0
			B738DR_fmc_descent_now = 0
			B738DR_fmc_mode = 0
			B738DR_autopilot_n1_pfd = 0
			--B738DR_autopilot_n1_status = 0
			B738DR_autopilot_vnav_alt_pfd = 0
			B738DR_autopilot_vnav_pth_pfd = 0
			B738DR_autopilot_vnav_spd_pfd = 0
			B738DR_autopilot_fmc_spd_pfd = 0
			B738DR_autopilot_to_ga_pfd = 0
			B738DR_autopilot_thr_hld_pfd = 0
			B738DR_autopilot_ga_pfd = 0
			B738DR_autopilot_alt_acq_pfd = 0
			----simDR_throttle_override = 0
			simDR_joy_pitch_override = 0
			
			-- if ap_roll_mode ~= 3 then -- APP off
				-- ap_roll_mode_eng = 0
				-- ap_pitch_mode_eng = 0
			-- end
			-- ap_roll_mode = 0
			-- ap_pitch_mode = 0
			
			B738DR_ap_spd_interv_status = 0
			
			if B738DR_autopilot_n1_status == 1 then
				at_mode = 1
			elseif simDR_autothrottle_enable == 1 then	-- speed on
				at_mode = 2
			else
				at_mode = 0
			end
			B738DR_autopilot_n1_status = 0
			ils_test_enable = 0
			if ap_on == 1 then
				ap_disco_do = 1
			end
			
		elseif B738DR_autopilot_disconnect_pos == 1 then
			B738DR_autopilot_disconnect_pos = 0
			--ap_disco_do = 0
			--at_dis_time = 0
--			simCMD_disconnect:stop()
		end
	end
end

function B738_autopilot_autothr_arm_toggle_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_autopilot_autothr_arm_pos == 0 then
			B738DR_autopilot_autothr_arm_pos = 1
			B738DR_autopilot_autothrottle_status = 1
			at_dis_time = 0
			at_status = 1
		elseif B738DR_autopilot_autothr_arm_pos == 1 then
			B738DR_autopilot_autothr_arm_pos = 0
			B738DR_autopilot_autothrottle_status = 0
--			B738DR_autopilot_n1_status = 0
--			----simDR_throttle_override = 0
--			at_mode_eng = 0
			at_mode = 0
			simCMD_autothrottle_discon:once()	-- disconnect autothrotle
			at_status = 0
		end
		autothr_arm_pos = 1
	elseif phase == 2 then
		if B738DR_autopilot_autothr_arm_pos == 1 then
			at_status = 2
		end
		autothr_arm_pos = 0
	end
end

---- FLIGHT DIRECTORS ------------------------------------------

function B738_autopilot_flight_dir_toggle_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_autopilot_fd_pos == 0 then
			B738DR_autopilot_fd_pos = 1
			if B738DR_autopilot_fd_fo_pos == 0 then
				--B738DR_autopilot_side = 0
				autopilot_side = 0
			end
		elseif B738DR_autopilot_fd_pos == 1 then
			B738DR_autopilot_fd_pos = 0
			if B738DR_autopilot_fd_fo_pos == 1 then
				--B738DR_autopilot_side = 1
				autopilot_side = 1
			else
				--B738DR_autopilot_side = 0
				autopilot_side = 0
			end
		end
	end
end

function B738_autopilot_flight_dir_fo_toggle_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_autopilot_fd_fo_pos == 0 then
			B738DR_autopilot_fd_fo_pos = 1
			if B738DR_autopilot_fd_pos == 0 then
				--B738DR_autopilot_side = 1
				autopilot_side = 1
			end
		elseif B738DR_autopilot_fd_fo_pos == 1 then
			B738DR_autopilot_fd_fo_pos = 0
			--B738DR_autopilot_side = 0
			autopilot_side = 0
		end
	end
end

---- BANK ANGLE ---------------------------------------------

function B738_autopilot_bank_angle_up_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_autopilot_bank_angle_pos == 0 then
			B738DR_autopilot_bank_angle_pos = 1
--			simDR_bank_angle = 3
		elseif B738DR_autopilot_bank_angle_pos == 1 then
			B738DR_autopilot_bank_angle_pos = 2
--			simDR_bank_angle = 4
		elseif B738DR_autopilot_bank_angle_pos == 2 then
			B738DR_autopilot_bank_angle_pos = 3
--			simDR_bank_angle = 5
		elseif B738DR_autopilot_bank_angle_pos == 3 then
			B738DR_autopilot_bank_angle_pos = 4
--			simDR_bank_angle = 6
		end
	end
end
		
function B738_autopilot_bank_angle_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_autopilot_bank_angle_pos == 4 then
			B738DR_autopilot_bank_angle_pos = 3
--			simDR_bank_angle = 5
		elseif B738DR_autopilot_bank_angle_pos == 3 then
			B738DR_autopilot_bank_angle_pos = 2
--			simDR_bank_angle = 4
		elseif B738DR_autopilot_bank_angle_pos == 2 then
			B738DR_autopilot_bank_angle_pos = 1
--			simDR_bank_angle = 3
		elseif B738DR_autopilot_bank_angle_pos == 1 then
			B738DR_autopilot_bank_angle_pos = 0
--			simDR_bank_angle = 2
		end
	end
end	




-- COMMAND A&B

---B738DR_fmc_gw

function B738_autopilot_cmd_a_press_CMDhandler(phase, duration)
	if phase == 0 then
		
		local ap_disable = 0
		if simDR_radio_height_pilot_ft < 400 then
			if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1 or simDR_on_ground_2 == 1 then		-- if aircraft on the ground
				if B738DR_fmc_gw == 0 then
					ap_disable = 1
				end
			else
				ap_disable = 1
			end
		end
		
		B738DR_autopilot_cmd_a_pos = 1
		--if B738DR_fd_on == 1 then
		if B738DR_autopilot_fd_pos == 1 then
			if autopilot_cmd_a_status == 0 and B738DR_autopilot_disconnect_pos == 0 and ap_app_block_800 == 0 then
				-- if simDR_radio_height_pilot_ft < 400 then
					-- if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1 or simDR_on_ground_2 == 1 then		-- if aircraft on the ground
						-- if B738DR_fmc_gw == 0 then
							-- simCMD_autopilot_servos:once()
							-- simCMD_disconnect:once()
						-- end
					-- else
						-- simCMD_autopilot_servos:once()
						-- simCMD_disconnect:once()
					-- end
				-- else
				if ap_disable == 1 then
					simCMD_autopilot_servos:once()
					simCMD_disconnect:once()
				else
					autopilot_cmd_a_status = 1
					ap_dis_time = 0
					if autopilot_cmd_b_status == 1
					and simDR_approach_status == 2
					and B738DR_autopilot_vhf_source_pos == 0 
					and simDR_radio_height_pilot_ft > 800 	--then		-- AUTOLAND on
					and simDR_glideslope_status == 2
					and B738DR_autopilot_fd_fo_pos == 1 then		-- if both F/D on, AUTOLAND on
						B738DR_autoland_status = 1
						cmd_first = 1	-- CMD B first
						ils_test_enable = 1
						-- if is_timer_scheduled(master_light_block) == true then
							-- stop_timer(master_light_block)
						-- end
						-- master_light_block_act = 1
						-- run_after_time(master_light_block, 1.5)
					else									-- CMD A on
						--autopilot_cmd_b_status = 0
						simCMD_autopilot_cws:stop()
						ap_on = 1
						--B738DR_autopilot_side = 0
						autopilot_side = 0
						if is_timer_scheduled(master_light_block) == true then
							stop_timer(master_light_block)
						end
						master_light_block_act = 0
						if B738DR_autopilot_master_fo_status == 1 then
							master_light_block_act = 1
							run_after_time(master_light_block, 1.5)
						end
						if at_mode_eng == 3 then	-- TAKEOFF mode
							if ap_pitch_mode == 0 then
								ap_pitch_mode = 2	-- LVL CHG
								--at_mode = 6		-- N1
								B738DR_lvl_chg_mode = 1
								if simDR_radio_height_pilot_ft <= B738DR_accel_alt then
									if B738DR_fms_v2_15 == 0 then
										simDR_airspeed_dial = 180
									else
										simDR_airspeed_dial = B738DR_fms_v2_15
									end
								end
							else
								--if ap_vnav_status == 2 then
								if B738DR_autopilot_vnav_status == 1 then
									at_mode = 7
								else
									at_mode = 2			-- SPEED mode
								end
							end
							if ap_roll_mode == 0 then
								ap_roll_mode = 1	-- HDG SEL
							end
							-- if B738DR_fms_v2_15 == 0 then
								-- simDR_airspeed_dial = 180
							-- else
								-- simDR_airspeed_dial = B738DR_fms_v2_15
							-- end
						elseif at_mode_eng == 5 then	-- F/D GA
							ap_roll_mode = 1	-- HDG SEL
							ap_pitch_mode = 2	-- LVL CHG
							fd_goaround = 3		-- F/D GA with CMD
							at_mode = 0
							at_mode_eng = 0
						elseif at_mode == 1 and ap_pitch_mode_eng == 0 and B738DR_flight_phase < 2 then	-- no pitch mode during climb
							if simDR_airspeed_pilot > B738DR_mcp_speed_dial then
								ap_pitch_mode = 1	-- VS mode
								ap_pitch_mode_eng = 1
								simCMD_autopilot_vs:once()
								--simDR_ap_vvi_dial = roundDownToIncrement(simDR_ap_vvi_dial, 100)
								vert_spd_corr()
								at_mode = 2		-- SPEED mode
								simDR_airspeed_dial = simDR_airspeed_pilot
							else
								ap_pitch_mode = 1	-- VS mode
								ap_pitch_mode_eng = 1
								simCMD_autopilot_vs:once()
								--simDR_ap_vvi_dial = roundDownToIncrement(simDR_ap_vvi_dial, 100)
								vert_spd_corr()
								simDR_airspeed_dial = B738DR_mcp_speed_dial
							end
						--elseif ap_pitch_mode_eng == 2 and B738DR_flight_phase < 2 then	-- LVL CHG mode during climb
								-- ap_pitch_mode = 1	-- VS mode
								-- ap_pitch_mode_eng = 1
								-- simCMD_autopilot_vs:once()
								-- simDR_ap_vvi_dial = roundDownToIncrement(simDR_ap_vvi_dial, 100)
							--simDR_airspeed_dial = simDR_airspeed_pilot
								--at_mode = 6		-- N1 LVL CHG
						end
						if autopilot_cws_a_status == 1 or autopilot_cws_b_status == 1 then
							simCMD_autopilot_cws:stop()
							autopilot_cws_a_status = 0
							autopilot_cws_b_status = 0
							ap_roll_mode_eng = 6
							ap_pitch_mode_eng = 6
						else
							simCMD_servos_on:once()
						end
						--simDR_autopilot_side = 0
						if B738DR_autopilot_lnav_status == 0 then
							autopilot_fms_nav_status = 0
	--						simDR_autopilot_side = 0
	--					else
	--						simDR_autopilot_side = 1
						end
					end
				end
			elseif autopilot_cmd_a_status == 1
			and B738DR_autoland_status == 0 and ap_app_block == 0 then		-- CMD A off
				simCMD_disconnect:once()
				simDR_flight_dir_mode = 1

				autopilot_cmd_a_status = 0
--				ap_roll_mode_eng = 0
--				ap_pitch_mode_eng = 0
			end
		end
	elseif phase == 2 then
		B738DR_autopilot_cmd_a_pos = 0
	end
end

function B738_autopilot_cmd_b_press_CMDhandler(phase, duration)
	if phase == 0 then
		
		local ap_disable = 0
		if simDR_radio_height_pilot_ft < 400 then
			if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1 or simDR_on_ground_2 == 1 then		-- if aircraft on the ground
				if B738DR_fmc_gw == 0 then
					ap_disable = 1
				end
			else
				ap_disable = 1
			end
		end
		
		B738DR_autopilot_cmd_b_pos = 1
		--if B738DR_fd_on == 1 then
		if B738DR_autopilot_fd_fo_pos == 1 then
			if autopilot_cmd_b_status == 0 and B738DR_autopilot_disconnect_pos == 0 and ap_app_block_800 == 0 then
				-- if simDR_radio_height_pilot_ft < 400 then
					-- simCMD_autopilot_servos:once()
					-- simCMD_disconnect:once()
				-- else
				if ap_disable == 1 then
					simCMD_autopilot_servos:once()
					simCMD_disconnect:once()
				else
					autopilot_cmd_b_status = 1
					ap_dis_time = 0
					if autopilot_cmd_a_status == 1
					and simDR_approach_status == 2
					and B738DR_autopilot_vhf_source_pos == 0 
					and simDR_radio_height_pilot_ft > 800 --then		-- AUTOLAND on
					and simDR_glideslope_status == 2
					and B738DR_autopilot_fd_fo_pos == 1 then		-- if both F/D on, AUTOLAND on
						B738DR_autoland_status = 1
						ils_test_enable = 1
						-- cmd_first = 0	-- CMD A first
						-- if is_timer_scheduled(master_light_block) == true then
							-- stop_timer(master_light_block)
						-- end
						-- master_light_block_act = 1
						-- run_after_time(master_light_block, 1.5)
					else									-- CMD B on
						--autopilot_cmd_a_status = 0
						ap_on = 1
						--B738DR_autopilot_side = 1
						autopilot_side = 1
						if is_timer_scheduled(master_light_block) == true then
							stop_timer(master_light_block)
						end
						master_light_block_act = 0
						if B738DR_autopilot_master_capt_status == 1 then
							master_light_block_act = 1
							run_after_time(master_light_block, 1.5)
						end
						if at_mode_eng == 3 then	-- TAKEOFF mode
							if ap_pitch_mode == 0 then
								ap_pitch_mode = 2	-- LVL CHG
								--at_mode = 6		-- N1
								B738DR_lvl_chg_mode = 1
								if simDR_radio_height_pilot_ft <= B738DR_accel_alt then
									if B738DR_fms_v2_15 == 0 then
										simDR_airspeed_dial = 180
									else
										simDR_airspeed_dial = B738DR_fms_v2_15
									end
								end
							else
								--if ap_vnav_status == 2 then
								if B738DR_autopilot_vnav_status == 1 then
									at_mode = 7
								else
									at_mode = 2			-- SPEED mode
								end
							end
							if ap_roll_mode == 0 then
								ap_roll_mode = 1	-- HDG SEL
							end
							-- if B738DR_fms_v2_15 == 0 then
								-- simDR_airspeed_dial = 180
							-- else
								-- simDR_airspeed_dial = B738DR_fms_v2_15
							-- end
						elseif at_mode_eng == 5 then	-- F/D GA
							ap_roll_mode = 1	-- HDG SEL
							ap_pitch_mode = 2	-- LVL CHG
							fd_goaround = 3		-- F/D GA with CMD
							at_mode = 0
							at_mode_eng = 0
						elseif at_mode == 1 and ap_pitch_mode_eng == 0 and B738DR_flight_phase < 2 then	-- no pitch mode during climb
							if simDR_airspeed_copilot > B738DR_mcp_speed_dial then
								ap_pitch_mode = 1	-- VS mode
								ap_pitch_mode_eng = 1
								simCMD_autopilot_vs:once()
								--simDR_ap_vvi_dial = roundDownToIncrement(simDR_ap_vvi_dial, 100)
								vert_spd_corr()
								at_mode = 2		-- SPEED mode
								simDR_airspeed_dial = simDR_airspeed_copilot
							else
								ap_pitch_mode = 1	-- VS mode
								ap_pitch_mode_eng = 1
								simCMD_autopilot_vs:once()
								--simDR_ap_vvi_dial = roundDownToIncrement(simDR_ap_vvi_dial, 100)
								vert_spd_corr()
								simDR_airspeed_dial = B738DR_mcp_speed_dial
							end
						--elseif ap_pitch_mode_eng == 2 and B738DR_flight_phase < 2 then	-- LVL CHG mode during climb
								-- ap_pitch_mode = 1	-- VS mode
								-- ap_pitch_mode_eng = 1
								-- simCMD_autopilot_vs:once()
								-- simDR_ap_vvi_dial = roundDownToIncrement(simDR_ap_vvi_dial, 100)
							--simDR_airspeed_dial = simDR_airspeed_pilot
								--at_mode = 6		-- N1 LVL CHG
						end
						if autopilot_cws_a_status == 1 or autopilot_cws_b_status == 1 then
							simCMD_autopilot_cws:stop()
							autopilot_cws_a_status = 0
							autopilot_cws_b_status = 0
							ap_roll_mode_eng = 0
							ap_pitch_mode_eng = 0
						else
							simCMD_servos_on:once()
						end
	--					simDR_autopilot_side = 1
						if B738DR_autopilot_lnav_status == 0 then
							autopilot_fms_nav_status = 0
							--simDR_autopilot_side = 1
						--else
							--simDR_autopilot_side = 0
						end
					end
				end
			elseif autopilot_cmd_b_status == 1
			and B738DR_autoland_status == 0 and ap_app_block == 0 then		-- CMD B off
				simCMD_disconnect:once()
				simDR_flight_dir_mode = 1

				autopilot_cmd_b_status = 0
--				ap_roll_mode_eng = 0
--				ap_pitch_mode_eng = 0
			end
		end
	elseif phase == 2 then
		B738DR_autopilot_cmd_b_pos = 0
	end
end

-- CWS A&B

function B738_autopilot_cws_a_press_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_autopilot_cws_a_pos = 1
		if autopilot_cws_a_status == 0 and B738DR_fd_on == 1
		and B738DR_autoland_status == 0
		and B738DR_autopilot_disconnect_pos == 0 
		and ap_app_block_800 == 0 and ap_app_block == 0 then
			autopilot_cmd_b_status = 0
			autopilot_cmd_a_status = 0
			autopilot_cws_b_status = 0
			autopilot_cws_a_status = 1
			simCMD_autopilot_cws:start()
			simDR_autopilot_side = 0
			autopilot_side = 0
			if B738DR_autopilot_lnav_status == 0 then
				autopilot_fms_nav_status = 0
			end
		elseif autopilot_cws_a_status == 1  and B738DR_fd_on == 1 and ap_app_block == 0 then
			simCMD_autopilot_cws:stop()
			autopilot_cws_a_status = 0
--			simCMD_servos_on:once()
			simDR_flight_dir_mode = 1

			ap_roll_mode_eng = 0
			ap_pitch_mode_eng = 0
		end
	elseif phase == 2 then
		B738DR_autopilot_cws_a_pos = 0
	end
end

function B738_autopilot_cws_b_press_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_autopilot_cws_b_pos = 1
		if autopilot_cws_b_status == 0 and B738DR_fd_on == 1
		and B738DR_autoland_status == 0 
		and B738DR_autopilot_disconnect_pos == 0 
		and ap_app_block_800 == 0 and ap_app_block == 0 then
			autopilot_cmd_b_status = 0
			autopilot_cmd_a_status = 0
			autopilot_cws_a_status = 0
			autopilot_cws_b_status = 1
			simCMD_autopilot_cws:start()
--			simDR_autopilot_side = 1
			if B738DR_autopilot_lnav_status == 0 then
				autopilot_fms_nav_status = 0
				--simDR_autopilot_side = 1
				autopilot_side = 1
			else
				--simDR_autopilot_side = 0
				autopilot_side = 0
			end
		elseif autopilot_cws_b_status == 1  and B738DR_fd_on == 1 and ap_app_block == 0 then
			simCMD_autopilot_cws:stop()
			autopilot_cws_b_status = 0
			simDR_flight_dir_mode = 1

--			simCMD_servos_on:once()
			ap_roll_mode_eng = 0
			ap_pitch_mode_eng = 0
		end
	elseif phase == 2 then
		B738DR_autopilot_cws_b_pos = 0
	end
end


function B738_autopilot_disconect_button_CMDhandler(phase, duration)
	
	if phase == 0 then
		B738DR_autopilot_disco2 = 1
		if autopilot_cmd_a_status == 1 then
			simDR_flight_dir_mode = 1
			autopilot_cmd_a_status = 0
			ap_disco2 = 1
		end
		if autopilot_cmd_b_status == 1 then
			simDR_flight_dir_mode = 1
			autopilot_cmd_b_status = 0
			ap_disco2 = 1
		end
		if autopilot_cws_a_status == 1 then
			simCMD_autopilot_cws:stop()
			autopilot_cws_a_status = 0
			simDR_flight_dir_mode = 1
			ap_roll_mode_eng = 0
			ap_pitch_mode_eng = 0
			ap_disco2 = 1
		end
		if autopilot_cws_b_status == 1 then
			simCMD_autopilot_cws:stop()
			autopilot_cws_b_status = 0
			simDR_flight_dir_mode = 1
			ap_roll_mode_eng = 0
			ap_pitch_mode_eng = 0
			ap_disco2 = 1
		end
	elseif phase == 2 then
		B738DR_autopilot_disco2 = 0
		ap_disco2 = 0
	end
end

function B738_vhf_nav_source_switch_rgt_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_autopilot_vhf_source_pos == -1 then
			B738DR_autopilot_vhf_source_pos = 0
		elseif B738DR_autopilot_vhf_source_pos == 0 then
			B738DR_autopilot_vhf_source_pos = 1
		end
	end
end

function B738_vhf_nav_source_switch_lft_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_autopilot_vhf_source_pos == 1 then
			B738DR_autopilot_vhf_source_pos = 0
		elseif B738DR_autopilot_vhf_source_pos == 0 then
			B738DR_autopilot_vhf_source_pos = -1
		end
	end
end

---- Custom altitude dial up / down

function alt_up(dial)
	altitude_dial_ft = B738DR_mcp_alt_dial - B738DR_mcp_alt_dial % 100
	altitude_dial_ft = altitude_dial_ft + dial
	if altitude_dial_ft > 41000 then
		altitude_dial_ft = 41000
	end
	B738DR_mcp_alt_dial = altitude_dial_ft
end

function alt_dn(dial)
	altitude_dial_ft = B738DR_mcp_alt_dial - B738DR_mcp_alt_dial % 100
	if altitude_dial_ft > 0 then
		altitude_dial_ft = altitude_dial_ft - dial
		if altitude_dial_ft < 0 then
			altitude_dial_ft = 0
		end
		B738DR_mcp_alt_dial = altitude_dial_ft
	end
end


-- alt_up_active / alt_dn_active => 0-no repeat, 1-repeat start, 2-repeat continue
function alt_updn_timer()
	if alt_up_active ~= 0 then
		alt_timer = alt_timer + SIM_PERIOD
		if (alt_up_active == 1) and (alt_timer > 0.8) then
			alt_up_active = 2
			alt_timer = 0
			alt_up(1000)
		end
		if (alt_up_active == 2) and (alt_timer > 0.1) then
			alt_timer = 0
			alt_up(1000)
		end
	end
	if alt_dn_active ~= 0 then
		alt_timer = alt_timer + SIM_PERIOD
		if (alt_dn_active == 1) and (alt_timer > 0.8) then
			alt_dn_active = 2
			alt_timer = 0
			alt_dn(1000)
		end
		if (alt_dn_active == 2) and (alt_timer > 0.1) then
			alt_timer = 0
			alt_dn(1000)
		end
	end
end

function B738_ap_altitude_up_CMDhandler(phase, duration)
	if phase == 0  then
		alt_up(100)
	end
	if phase == 1 then
		if alt_up_active == 0 then
			alt_up_active = 1
		end
	end
	if phase == 2  then
		alt_up_active = 0
		alt_timer = 0
	end
end

function B738_ap_altitude_dn_CMDhandler(phase, duration)
	if phase == 0  then
		alt_dn(100)
	end
	if phase == 1 then
		if alt_dn_active == 0 then
			alt_dn_active = 1
		end
	end
	if phase == 2  then
		alt_dn_active = 0
		alt_timer = 0
	end
end

---- MFD: ENG and SYS

function B738_mfd_sys_CMDhandler(phase, duration)
	if phase == 0 then
		-- if B738DR_lowerDU_page == 0 then
			-- B738DR_lowerDU_page = 1
		-- elseif B738DR_lowerDU_page == 1 then
			-- B738DR_lowerDU_page = 2
		-- elseif B738DR_lowerDU_page == 2 then
			-- B738DR_lowerDU_page = 0
		-- end
		B738DR_mfd_sys_pos = 1
		if B738DR_lowerDU_page == 2 then
			B738DR_lowerDU_page = 0
		else
			B738DR_lowerDU_page = 2
		end
	elseif phase == 2 then
		B738DR_mfd_sys_pos = 0
	end
end

function B738_mfd_eng_CMDhandler(phase, duration)

	if phase == 0 then
		-- if B738DR_EICAS_page == 0 then
			-- B738DR_EICAS_page = 1
		-- else
			-- B738DR_EICAS_page = 0
		-- end
		B738DR_mfd_eng_pos = 1
		if B738DR_lowerDU_page == 1 then
			B738DR_lowerDU_page = 0
		else
			B738DR_lowerDU_page = 1
		end
	elseif phase == 2 then
		B738DR_mfd_eng_pos = 0
	end

end

--- A/P, A/T light buttons

function B738_ap_light_pilot_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_ap_light_pilot = 1
	elseif phase == 2 then
		B738DR_ap_light_pilot = 0
	end
end

function B738_at_light_pilot_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_at_light_pilot = 1
	elseif phase == 2 then
		B738DR_at_light_pilot = 0
	end
end

function B738_ap_light_fo_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_ap_light_fo = 1
	elseif phase == 2 then
		B738DR_ap_light_fo = 0
	end
end

function B738_at_light_fo_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_at_light_fo = 1
	elseif phase == 2 then
		B738DR_at_light_fo = 0
	end
end

-- TO/GA button
function B738_to_ga_CMDhandler(phase, duration)
	local ap_ga = 0
	local fd_ga = 0
	local one_ap = 0
	local fd_ga_enable = 0
	
	if phase == 0 then
		
		ap_app_block = 0
		
		--Takeoff mode
--		to_after_80kts = 0
		if B738DR_autopilot_autothr_arm_pos == 1 
		and B738DR_autobrake_RTO_arm < 2 then
			-- Takeoff without F/D on
			if simDR_airspeed_pilot > 80
			and simDR_radio_height_pilot_ft < 2000 
			and lift_off_150 == 0 
			and on_ground_30 == 1 then
				at_mode = 3				-- TAKEOFF mode
				to_after_80kts = 1
				B738DR_fd_pilot_show = 1
				B738DR_fd_copilot_show = 1
				if is_timer_scheduled(master_light_block) == true then
					stop_timer(master_light_block)
				end
				master_light_block_act = 1
				run_after_time(master_light_block, 1.5)
			end
			-- Takeoff with both F/D on
			if B738DR_autopilot_fd_pos == 1
			and B738DR_autopilot_fd_fo_pos == 1
			and simDR_airspeed_pilot < 60 then
				at_mode = 3				-- TAKEOFF mode
				if is_timer_scheduled(master_light_block) == true then
					stop_timer(master_light_block)
				end
				master_light_block_act = 1
				run_after_time(master_light_block, 1.5)
			end
		end
		
		--AP GoAround mode
		--if B738DR_autopilot_autothr_arm_pos == 1 then
			if ap_goaround == 1 then
				ap_goaround = 2			-- second push
			end
			if B738DR_flare_status > 0 then
				if ap_goaround == 0 then
					if simDR_on_ground_0 == 0 and simDR_on_ground_1 == 0 
					and simDR_on_ground_2 == 0 then		-- if aircraft in flight
						if simDR_radio_height_pilot_ft < 2000 then
							ap_ga = 1
						else	--if simDR_radio_height_pilot_ft > 2000 then
							if simDR_flaps_ratio > 0
							or simDR_glideslope_status == 2 then
								ap_ga = 1
							end
						end
					end
					if ap_ga == 1 then
						ap_goaround = 1		-- first push
						--at_mode = 4			-- AP GA
						ap_ga2_activate()
						if simDR_approach_status > 0 then
							simCMD_autopilot_app:once()
						end
						if simDR_nav_status > 0 then
							simCMD_autopilot_lnav:once()
						end
					end
				end
			else
				-- AP GoAround after touchdown
				if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1 
				or simDR_on_ground_2 == 1 then		-- if aircraft on ground
					if ap_goaround_block == 0 then
						-- A/T automatic off disengage
						if is_timer_scheduled(ap_at_off) == true then
							stop_timer(ap_at_off)
						end
						-- A/P off
						simCMD_disconnect:once()
						simDR_flight_dir_mode = 1
						autopilot_cmd_a_status = 0
						autopilot_cmd_b_status = 0
						ap_roll_mode = 0
						ap_pitch_mode = 0
						--at_mode = 8
						ap_ga1_acivate()
					end
				end
			end
			--F/D GoAround mode
			if ap_on == 1 then
				if autopilot_cmd_a_status == 0 or autopilot_cmd_b_status == 0 then
					one_ap = 1	-- only one A/P engaged
				end
			end
			if B738DR_fd_on == 1 and at_mode ~= 3 then
				if one_ap == 1 or ap_on == 0 then
					fd_ga_enable = 1
				end
			end
			-- if one_ap == 1 and B738DR_fd_on == 1 and at_mode ~= 3 then
			if fd_ga_enable == 1 then
				if fd_goaround == 0 then
					if simDR_radio_height_pilot_ft < 2000 
					and ap_goaround_block == 0 then
						fd_ga = 1
						if is_timer_scheduled(ap_at_off) == true then
							stop_timer(ap_at_off)
						end
					end
					if simDR_radio_height_pilot_ft > 2000 then
						if simDR_flaps_ratio > 0
						or simDR_glideslope_status == 2 then
							fd_ga = 1
						end
					end
					if fd_ga == 1 then
						fd_goaround = 1		-- first push
						--at_mode = 5			-- FD GA
						fd_ga_activate()
						-- disconnect A/P
						simCMD_disconnect:once()
						simDR_flight_dir_mode = 1
						autopilot_cmd_a_status = 0
						autopilot_cmd_b_status = 0
						ap_on = 0
					end
				elseif fd_goaround == 1 then
					fd_goaround  = 2
				end
			end
		--end
	end
end

function B738_to_ga2_CMDhandler(phase, duration)
	local ap_ga = 0
	local fd_ga = 0
	if phase == 0 then
		
		ap_app_block = 0
		
		--Takeoff mode
--		to_after_80kts = 0
		if B738DR_autopilot_autothr_arm_pos == 1 
		and B738DR_autobrake_RTO_arm < 2 then
			-- Takeoff without F/D on
			if simDR_airspeed_pilot > 80
			and simDR_radio_height_pilot_ft < 2000 
			and lift_off_150 == 0 
			and on_ground_30 == 1 then
				at_mode = 3				-- TAKEOFF mode
				to_after_80kts = 1
				B738DR_fd_pilot_show = 1
				B738DR_fd_copilot_show = 1
			end
			-- Takeoff with both F/D on
			if B738DR_autopilot_fd_pos == 1
			and B738DR_autopilot_fd_fo_pos == 1
			and simDR_airspeed_pilot < 60 then
				at_mode = 3				-- TAKEOFF mode
			end
		end
		
		--AP GoAround mode
		--if B738DR_autopilot_autothr_arm_pos == 1 then
			if ap_goaround == 1 then
				ap_goaround = 2			-- second push
			end
			if B738DR_flare_status > 0 then
				if ap_goaround == 0 then
					if simDR_on_ground_0 == 0 and simDR_on_ground_1 == 0 
					and simDR_on_ground_2 == 0 then		-- if aircraft in flight
						if simDR_radio_height_pilot_ft < 2000 then
							ap_ga = 1
						else	--if simDR_radio_height_pilot_ft > 2000 then
							if simDR_flaps_ratio > 0
							or simDR_glideslope_status == 2 then
								ap_ga = 1
							end
						end
					end
					if ap_ga == 1 then
						ap_goaround = 1		-- first push
						--at_mode = 4			-- AP GA
						ap_ga2_activate()
						if simDR_approach_status > 0 then
							simCMD_autopilot_app:once()
						end
						if simDR_nav_status > 0 then
							simCMD_autopilot_lnav:once()
						end
					end
				end
			else
				-- AP GoAround after touchdown
				if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1 
				or simDR_on_ground_2 == 1 then		-- if aircraft on ground
					if ap_goaround_block == 0 then
						-- A/T automatic off disengage
						if is_timer_scheduled(ap_at_off) == true then
							stop_timer(ap_at_off)
						end
						-- A/P off
						simCMD_disconnect:once()
						simDR_flight_dir_mode = 1
						autopilot_cmd_a_status = 0
						autopilot_cmd_b_status = 0
						ap_roll_mode = 0
						ap_pitch_mode = 0
						--at_mode = 8
						ap_ga1_acivate()
					end
				end
			end
			--F/D GoAround mode
			if ap_on == 0 and B738DR_fd_on == 1 and at_mode ~= 3 then
				if fd_goaround == 0 then
					if simDR_radio_height_pilot_ft < 2000 
					-- and simDR_on_ground_0 == 0 and simDR_on_ground_1 == 0 
					-- and simDR_on_ground_2 == 0 then
					and ap_goaround_block == 0 then
						fd_ga = 1
						if is_timer_scheduled(ap_at_off) == true then
							stop_timer(ap_at_off)
						end
					end
					if simDR_radio_height_pilot_ft > 2000 then
						if simDR_flaps_ratio > 0
						or simDR_glideslope_status == 2 then
							fd_ga = 1
						end
					end
					if fd_ga == 1 then
						fd_goaround = 1		-- first push
						--at_mode = 5			-- FD GA
						fd_ga_activate()
					end
				elseif fd_goaround == 1 then
					fd_goaround  = 2
				end
			end
		--end
	end
end


-- N1 SET SWITCH
function B738_n1_set_source_left_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_n1_set_source == -1 then
			B738DR_n1_set_source = -2
			B738DR_n1_set_adjust = eng2_N1_man
			B738DR_eng1_N1_bug = eng1_N1_man
		elseif B738DR_n1_set_source == 0 then
			B738DR_n1_set_source = -1
			B738DR_n1_set_adjust = eng1_N1_man
			B738DR_eng2_N1_bug = eng2_N1_man
		elseif B738DR_n1_set_source == 1 then
			B738DR_n1_set_source = 0
			B738DR_eng1_N1_bug = eng1_N1_man
			B738DR_eng2_N1_bug = eng2_N1_man
		end
	end
end

function B738_n1_set_source_right_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_n1_set_source == -2 then
			B738DR_n1_set_source = -1
			B738DR_n1_set_adjust = eng1_N1_man
		elseif B738DR_n1_set_source == -1 then
			B738DR_n1_set_source = 0
		elseif B738DR_n1_set_source == 0 then
			B738DR_n1_set_source = 1
			B738DR_n1_set_adjust = eng1_N1_man
		end
	end
end

---- Custom course pilot dial up / down
function crs1_up(dial)
	local crs1_dial = 0
	crs1_dial = simDR_nav1_obs_pilot + dial
	if crs1_dial > 359 then
		crs1_dial = crs1_dial - 360
	end
	simDR_nav1_obs_pilot = math.floor(crs1_dial + 0.5)
	simDR_nav2_obs_pilot = simDR_nav1_obs_pilot
	B738DR_course_pilot = simDR_nav1_obs_pilot
end

function crs1_dn(dial)
	local crs1_dial = 0
	crs1_dial = simDR_nav1_obs_pilot - dial
	if crs1_dial < 0 then
		crs1_dial = 360 + crs1_dial
	end
	simDR_nav1_obs_pilot = math.floor(crs1_dial + 0.5)
	simDR_nav2_obs_pilot = simDR_nav1_obs_pilot
	B738DR_course_pilot = simDR_nav1_obs_pilot
end

-- crs1_up_active / crs2_dn_active => 0-no repeat, 1-repeat start, 2-repeat continue
function crs1_updn_timer()
	if crs1_up_active ~= 0 then
		crs1_timer = crs1_timer + SIM_PERIOD
		if (crs1_up_active == 1) and (crs1_timer > 0.6) then
			crs1_up_active = 2
			crs1_timer = 0
			crs1_up(1)
		end
		if (crs1_up_active == 2) and (crs1_timer > 0.02) then
			crs1_timer = 0
			crs1_up(3)
		end
	end
	if crs1_dn_active ~= 0 then
		crs1_timer = crs1_timer + SIM_PERIOD
		if (crs1_dn_active == 1) and (crs1_timer > 0.6) then
			crs1_dn_active = 2
			crs1_timer = 0
			crs1_dn(1)
		end
		if (crs1_dn_active == 2) and (crs1_timer > 0.02) then
			crs1_timer = 0
			crs1_dn(3)
		end
	end
end

function B738_course_pilot_up_CMDhandler(phase, duration)
	if phase == 0 then
		crs1_up(1)
	end
	if phase == 1 then
		if crs1_up_active == 0 then
			crs1_up_active = 1
		end
	end
	if phase == 2 then
		crs1_up_active = 0
		crs1_timer = 0
	end
end

function B738_course_pilot_dn_CMDhandler(phase, duration)
	if phase == 0 then
		crs1_dn(1)
	end
	if phase == 1 then
		if crs1_dn_active == 0 then
			crs1_dn_active = 1
		end
	end
	if phase == 2 then
		crs1_dn_active = 0
		crs1_timer = 0
	end
end

-- Custom course copilot dial up / down

function crs2_up(dial)
	local crs2_dial = 0
	crs2_dial = simDR_nav1_obs_copilot + dial
	if crs2_dial > 359 then
		crs2_dial = crs2_dial - 360
	end
	simDR_nav1_obs_copilot = math.floor(crs2_dial + 0.5)
	simDR_nav2_obs_copilot = simDR_nav1_obs_copilot
	B738DR_course_copilot = simDR_nav1_obs_copilot
end

function crs2_dn(dial)
	local crs2_dial = 0
	crs2_dial = simDR_nav1_obs_copilot - dial
	if crs2_dial < 0 then
		crs2_dial = 360 + crs2_dial
	end
	simDR_nav1_obs_copilot = math.floor(crs2_dial + 0.5)
	simDR_nav2_obs_copilot = simDR_nav1_obs_copilot
	B738DR_course_copilot = simDR_nav1_obs_copilot
end


-- crs2_up_active / crs2_dn_active => 0-no repeat, 1-repeat start, 2-repeat continue
function crs2_updn_timer()
	if crs2_up_active ~= 0 then
		crs2_timer = crs2_timer + SIM_PERIOD
		if (crs2_up_active == 1) and (crs2_timer > 0.6) then
			crs2_up_active = 2
			crs2_timer = 0
			crs2_up(1)
		end
		if (crs2_up_active == 2) and (crs2_timer > 0.02) then
			crs2_timer = 0
			crs2_up(3)
		end
	end
	if crs2_dn_active ~= 0 then
		crs2_timer = crs2_timer + SIM_PERIOD
		if (crs2_dn_active == 1) and (crs2_timer > 0.6) then
			crs2_dn_active = 2
			crs2_timer = 0
			crs2_dn(1)
		end
		if (crs2_dn_active == 2) and (crs2_timer > 0.02) then
			crs2_timer = 0
			crs2_dn(3)
		end
	end
end

function B738_course_copilot_up_CMDhandler(phase, duration)
	if phase == 0 then
		crs2_up(1)
	end
	if phase == 1 then
		if crs2_up_active == 0 then
			crs2_up_active = 1
		end
	end
	if phase == 2 then
		crs2_up_active = 0
		crs2_timer = 0
	end
end

function B738_course_copilot_dn_CMDhandler(phase, duration)
	if phase == 0 then
		crs2_dn(1)
	end
	if phase == 1 then
		if crs2_dn_active == 0 then
			crs2_dn_active = 1
		end
	end
	if phase == 2 then
		crs2_dn_active = 0
		crs2_timer = 0
	end
end


-- baro_pilot_up_active / baro_pilot_dn_active => 0-no repeat, 1-repeat start, 2-repeat continue
function baro_pilot_updn_timer()
	if B738DR_dspl_ctrl_pnl < 1 then
		if baro_pilot_up_active ~= 0 then
			baro_pilot_timer = baro_pilot_timer + SIM_PERIOD
			if (baro_pilot_up_active == 1) and (baro_pilot_timer > 0.3) then
				baro_pilot_timer = 0.5
				if B738DR_baro_sel_in_hg_pilot < 40 then
					B738DR_baro_sel_in_hg_pilot = B738DR_baro_sel_in_hg_pilot + 0.01
				end
				if B738DR_dspl_ctrl_pnl == -1 then
					B738DR_baro_sel_in_hg_copilot = B738DR_baro_sel_in_hg_pilot
				end
			end
		end
		if baro_pilot_dn_active ~= 0 then
			baro_pilot_timer = baro_pilot_timer + SIM_PERIOD
			if (baro_pilot_dn_active == 1) and (baro_pilot_timer > 0.3) then
				baro_pilot_timer = 0.5
				if B738DR_baro_sel_in_hg_pilot > 0 then
					B738DR_baro_sel_in_hg_pilot = B738DR_baro_sel_in_hg_pilot - 0.01
				end
				if B738DR_dspl_ctrl_pnl == -1 then
					B738DR_baro_sel_in_hg_copilot = B738DR_baro_sel_in_hg_pilot
				end
			end
		end
	end
end

function B738CMD_baro_pilot_up_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl < 1 then
		if phase == 0  then
			if B738DR_baro_sel_in_hg_pilot < 40 then
				B738DR_baro_sel_in_hg_pilot = B738DR_baro_sel_in_hg_pilot + 0.01
			end
			if B738DR_dspl_ctrl_pnl == -1 then
				B738DR_baro_sel_in_hg_copilot = B738DR_baro_sel_in_hg_pilot
			end
		elseif phase == 1 then
			if baro_pilot_up_active == 0 then
				baro_pilot_up_active = 1
			end
		elseif phase == 2  then
			baro_pilot_up_active = 0
			baro_pilot_timer = 0
		end
	end
end

function B738CMD_baro_pilot_dn_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl < 1 then
		if phase == 0  then
			if B738DR_baro_sel_in_hg_pilot > 0 then
				B738DR_baro_sel_in_hg_pilot = B738DR_baro_sel_in_hg_pilot - 0.01
			end
			if B738DR_dspl_ctrl_pnl == -1 then
				B738DR_baro_sel_in_hg_copilot = B738DR_baro_sel_in_hg_pilot
			end
		elseif phase == 1 then
			if baro_pilot_dn_active == 0 then
				baro_pilot_dn_active = 1
			end
		elseif phase == 2  then
			baro_pilot_dn_active = 0
			baro_pilot_timer = 0
		end
	end
end

-- baro_copilot_up_active / baro_copilot_dn_active => 0-no repeat, 1-repeat start, 2-repeat continue
function baro_copilot_updn_timer()
	if B738DR_dspl_ctrl_pnl > -1 then
		if baro_copilot_up_active ~= 0 then
			baro_copilot_timer = baro_copilot_timer + SIM_PERIOD
			if (baro_copilot_up_active == 1) and (baro_copilot_timer > 0.3) then
				baro_copilot_timer = 0.5
				if B738DR_baro_sel_in_hg_copilot < 40 then
					B738DR_baro_sel_in_hg_copilot = B738DR_baro_sel_in_hg_copilot + 0.01
				end
				if B738DR_dspl_ctrl_pnl == 1 then
					B738DR_baro_sel_in_hg_pilot = B738DR_baro_sel_in_hg_copilot
				end
			end
		end
		if baro_copilot_dn_active ~= 0 then
			baro_copilot_timer = baro_copilot_timer + SIM_PERIOD
			if (baro_copilot_dn_active == 1) and (baro_copilot_timer > 0.3) then
				baro_copilot_timer = 0.5
				if B738DR_baro_sel_in_hg_copilot > 0 then
					B738DR_baro_sel_in_hg_copilot = B738DR_baro_sel_in_hg_copilot - 0.01
				end
				if B738DR_dspl_ctrl_pnl == 1 then
					B738DR_baro_sel_in_hg_pilot = B738DR_baro_sel_in_hg_copilot
				end
			end
		end
	end
end

function B738CMD_baro_copilot_up_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl > -1 then
		if phase == 0  then
			if B738DR_baro_sel_in_hg_copilot < 40 then
				B738DR_baro_sel_in_hg_copilot = B738DR_baro_sel_in_hg_copilot + 0.01
			end
			if B738DR_dspl_ctrl_pnl == 1 then
				B738DR_baro_sel_in_hg_pilot = B738DR_baro_sel_in_hg_copilot
			end
		elseif phase == 1 then
			if baro_copilot_up_active == 0 then
				baro_copilot_up_active = 1
			end
		elseif phase == 2  then
			baro_copilot_up_active = 0
			baro_copilot_timer = 0
		end
	end
end

function B738CMD_baro_copilot_dn_CMDhandler(phase, duration)
	if B738DR_dspl_ctrl_pnl > -1 then
		if phase == 0  then
			if B738DR_baro_sel_in_hg_copilot > 0 then
				B738DR_baro_sel_in_hg_copilot = B738DR_baro_sel_in_hg_copilot - 0.01
			end
			if B738DR_dspl_ctrl_pnl == 1 then
				B738DR_baro_sel_in_hg_pilot = B738DR_baro_sel_in_hg_copilot
			end
		elseif phase == 1 then
			if baro_copilot_dn_active == 0 then
				baro_copilot_dn_active = 1
			end
		elseif phase == 2  then
			baro_copilot_dn_active = 0
			baro_copilot_timer = 0
		end
	end
end


function B738_ap_heading_up_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_mcp_hdg_dial = (B738DR_mcp_hdg_dial + 1) % 360
		mcp_hdg_timer = 0
	elseif phase == 1 then
		mcp_hdg_timer = mcp_hdg_timer + SIM_PERIOD
		if mcp_hdg_timer > 0.5 then
			B738DR_mcp_hdg_dial = (B738DR_mcp_hdg_dial + 3) % 360
			mcp_hdg_timer = 0.6
		end
	elseif phase == 2  then
		mcp_hdg_timer = 0
	end
end

function B738_ap_heading_dn_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_mcp_hdg_dial = B738DR_mcp_hdg_dial - 1
		if B738DR_mcp_hdg_dial < 0 then
			B738DR_mcp_hdg_dial = 360 + B738DR_mcp_hdg_dial
		end
		mcp_hdg_timer = 0
	elseif phase == 1 then
		mcp_hdg_timer = mcp_hdg_timer + SIM_PERIOD
		if mcp_hdg_timer > 0.5 then
			B738DR_mcp_hdg_dial = B738DR_mcp_hdg_dial - 3
			if B738DR_mcp_hdg_dial < 0 then
				B738DR_mcp_hdg_dial = 360 + B738DR_mcp_hdg_dial
			end
			mcp_hdg_timer = 0.6
		end
	elseif phase == 2  then
		mcp_hdg_timer = 0
	end
end


--- SPD INTV ---
function B738_autopilot_spd_interv_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_autopilot_spd_interv_pos = 1
		if B738DR_autopilot_vnav_status == 1 and vnav_engaged == 1 then
			if B738DR_ap_spd_interv_status == 0 then
				B738DR_ap_spd_interv_status = 1
				if B738DR_flight_phase > 4 then
					-- if B738DR_vnav_desc_spd_disable == 0 and vnav_desc_spd == 0 then	--and B738DR_pfd_spd_mode == PFD_SPD_ARM then
						vnav_desc_spd = 1
						vnav_desc_protect_spd = 0
					-- else
						-- vnav_desc_spd = 0
						-- vnav_desc_protect_spd = 0
					-- end
				end
				simDR_airspeed_dial_kts = AP_airspeed	--simDR_airspeed_pilot
			else
				B738DR_ap_spd_interv_status = 0
				-- if B738DR_thrust1_leveler ~= 0 and B738DR_thrust2_leveler ~= 0 then 
					--vnav_desc_spd = 0
				-- end
				--vnav_desc_protect_spd = 0
			end
		end
	elseif phase == 2 then
		B738DR_autopilot_spd_interv_pos = 0
	end
end

function B738_ap_alt_up_CMDhandler(phase, duration)
	if phase == 0 then
		B738CMD_ap_altitude_up:once()
	end
end

function B738_ap_alt_dn_CMDhandler(phase, duration)
	if phase == 0 then
		B738CMD_ap_altitude_dn:once()
	end
end

function B738_ap_crs_pilot_up_CMDhandler(phase, duration)
	if phase == 0 then
		B738_course_pilot_up:once()
	end
end

function B738_ap_crs_pilot_dn_CMDhandler(phase, duration)
	if phase == 0 then
		B738_course_pilot_dn:once()
	end
end

function B738_ap_crs_copilot_up_CMDhandler(phase, duration)
	if phase == 0 then
		B738_course_copilot_up:once()
	end
end

function B738_ap_crs_copilot_dn_CMDhandler(phase, duration)
	if phase == 0 then
		B738_course_copilot_dn:once()
	end
end

function B738_ap_left_toga_press_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_autopilot_left_toga_pos = 1
		simCMD_take_off_go_around:once()
	elseif phase == 2 then
		B738DR_autopilot_left_toga_pos = 0
	end
end

function B738_ap_right_toga_press_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_autopilot_right_toga_pos = 1
		simCMD_take_off_go_around:once()
	elseif phase == 2 then
		B738DR_autopilot_right_toga_pos = 0
	end
end

function B738_ap_left_atds_press_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_autopilot_left_at_diseng_pos = 1
		if B738DR_autopilot_autothr_arm_pos == 1 then
			B738DR_autopilot_autothr_arm_pos = 0
			B738DR_autopilot_autothrottle_status = 0
			at_mode = 0
			simCMD_autothrottle_discon:once()	-- disconnect autothrotle
		end
		at_left_press = 1
	elseif phase == 2 then
		B738DR_autopilot_left_at_diseng_pos = 0
	end
end

function B738_ap_right_atds_press_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_autopilot_right_at_diseng_pos = 1
		if B738DR_autopilot_autothr_arm_pos == 1 then
			B738DR_autopilot_autothr_arm_pos = 0
			B738DR_autopilot_autothrottle_status = 0
			at_mode = 0
			simCMD_autothrottle_discon:once()	-- disconnect autothrotle
		end
		at_right_press = 1
	elseif phase == 2 then
		B738DR_autopilot_right_at_diseng_pos = 0
	end
end


function B738_mic_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_mic_pos = 1
		simCMD_take_off_go_around:once()
	elseif phase == 2 then
		B738DR_mic_pos = 0
	end
end

--*************************************************************************************--
--** 				              CREATE CUSTOM COMMANDS              			     **--
--*************************************************************************************--

B738CMD_mic					= create_command("laminar/B738/push_button/mic", "MIC (TO/GA button)", B738_mic_CMDhandler)

B738CMD_autopilot_left_toga_press	= create_command("laminar/B738/autopilot/left_toga_press", "Left TO/GA", B738_ap_left_toga_press_CMDhandler)
B738CMD_autopilot_right_toga_press	= create_command("laminar/B738/autopilot/right_toga_press", "Right TO/GA", B738_ap_right_toga_press_CMDhandler)

B738CMD_autopilot_left_atds_press	= create_command("laminar/B738/autopilot/left_at_dis_press", "Left A/T disengage", B738_ap_left_atds_press_CMDhandler)
B738CMD_autopilot_right_atds_press	= create_command("laminar/B738/autopilot/right_at_dis_press", "Right A/T disengage", B738_ap_right_atds_press_CMDhandler)

-- CAPT and F/O minimums
B738CMD_fo_minimums_up = create_command("laminar/B738/EFIS_control/fo/minimums_up", "FO Minimums select up", B738_fo_minimums_up_CMDhandler)
B738CMD_fo_minimums_dn = create_command("laminar/B738/EFIS_control/fo/minimums_dn", "FO Minimums select down", B738_fo_minimums_dn_CMDhandler)
B738CMD_cpt_minimums_up = create_command("laminar/B738/EFIS_control/cpt/minimums_up", "CAPT Minimums select up", B738_cpt_minimums_up_CMDhandler)
B738CMD_cpt_minimums_dn = create_command("laminar/B738/EFIS_control/cpt/minimums_dn", "CAPT Minimums select down", B738_cpt_minimums_dn_CMDhandler)

-- CAPT EFIS COMMANDS
B738CMD_dh_pilot_up			= create_command("laminar/B738/pfd/dh_pilot_up", "Captain DH up", B738_dh_pilot_up_CMDhandler)
B738CMD_dh_pilot_dn			= create_command("laminar/B738/pfd/dh_pilot_dn", "Captain DH down", B738_dh_pilot_dn_CMDhandler)
B738CMD_dh_pilot_up1		= create_command("laminar/B738/pfd/dh_pilot_up1", "Captain DH up 1 detend", B738_dh_pilot_up1_CMDhandler)
B738CMD_dh_pilot_up2		= create_command("laminar/B738/pfd/dh_pilot_up2", "Captain DH up 2 detend", B738_dh_pilot_up2_CMDhandler)
B738CMD_dh_pilot_dn1		= create_command("laminar/B738/pfd/dh_pilot_dn1", "Captain DH down 1 detend", B738_dh_pilot_dn1_CMDhandler)
B738CMD_dh_pilot_dn2		= create_command("laminar/B738/pfd/dh_pilot_dn2", "Captain DH down 2 detend", B738_dh_pilot_dn2_CMDhandler)

B738CMD_efis_wxr_capt 		= create_command("laminar/B738/EFIS_control/capt/push_button/wxr_press", "CAPT EFIS Weather", B738_efis_wxr_capt_CMDhandler)
B738CMD_efis_sta_capt 		= create_command("laminar/B738/EFIS_control/capt/push_button/sta_press", "CAPT EFIS Station", B738_efis_sta_capt_CMDhandler)
B738CMD_efis_wpt_capt 		= create_command("laminar/B738/EFIS_control/capt/push_button/wpt_press", "CAPT EFIS Waypoint", B738_efis_wpt_capt_CMDhandler)
B738CMD_efis_arpt_capt 		= create_command("laminar/B738/EFIS_control/capt/push_button/arpt_press", "CAPT EFIS Airport", B738_efis_arpt_capt_CMDhandler)
B738CMD_efis_data_capt 		= create_command("laminar/B738/EFIS_control/capt/push_button/data_press", "CAPT EFIS DATA", B738_efis_data_capt_CMDhandler)
B738CMD_efis_pos_capt 		= create_command("laminar/B738/EFIS_control/capt/push_button/pos_press", "CAPT EFIS Position", B738_efis_pos_capt_CMDhandler)
B738CMD_efis_terr_capt 		= create_command("laminar/B738/EFIS_control/capt/push_button/terr_press", "CAPT EFIS Terrain", B738_efis_terr_capt_CMDhandler)

B738CMD_efis_rst_capt 		= create_command("laminar/B738/EFIS_control/capt/push_button/rst_press", "CAPT EFIS Reset", B738_efis_rst_capt_CMDhandler)
B738CMD_efis_ctr_capt 		= create_command("laminar/B738/EFIS_control/capt/push_button/ctr_press", "CAPT EFIS Center", B738_efis_ctr_capt_CMDhandler)
B738CMD_efis_tfc_capt 		= create_command("laminar/B738/EFIS_control/capt/push_button/tfc_press", "CAPT EFIS Traffic", B738_efis_tfc_capt_CMDhandler)
B738CMD_efis_std_capt 		= create_command("laminar/B738/EFIS_control/capt/push_button/std_press", "CAPT EFIS Standard", B738_efis_std_capt_CMDhandler)

B738CMD_efis_mtrs_capt 		= create_command("laminar/B738/EFIS_control/capt/push_button/mtrs_press", "CAPT ALT in Meters", B738_efis_mtrs_capt_CMDhandler)
B738CMD_efis_fpv_capt 		= create_command("laminar/B738/EFIS_control/capt/push_button/fpv_press", "CAPT Flight Path Vector", B738_efis_fpv_capt_CMDhandler)

B738CMD_efis_baro_mode_capt_up 	= create_command("laminar/B738/EFIS_control/capt/baro_in_hpa_up", "CAPT Baro Mode HPA", B738_efis_baro_mode_capt_up_CMDhandler)
B738CMD_efis_baro_mode_capt_dn 	= create_command("laminar/B738/EFIS_control/capt/baro_in_hpa_dn", "CAPT Baro Mode IN", B738_efis_baro_mode_capt_dn_CMDhandler)

B738CMD_efis_vor1_capt_up 		= create_command("laminar/B738/EFIS_control/capt/vor1_off_up", "CAPT VOR1 Up", B738_efis_vor1_capt_up_CMDhandler)
B738CMD_efis_vor1_capt_dn 		= create_command("laminar/B738/EFIS_control/capt/vor1_off_dn", "CAPT VOR1 Down", B738_efis_vor1_capt_dn_CMDhandler)
B738CMD_efis_vor2_capt_up 		= create_command("laminar/B738/EFIS_control/capt/vor2_off_up", "CAPT VOR1 Up", B738_efis_vor2_capt_up_CMDhandler)
B738CMD_efis_vor2_capt_dn 		= create_command("laminar/B738/EFIS_control/capt/vor2_off_dn", "CAPT VOR1 Down", B738_efis_vor2_capt_dn_CMDhandler)

B738CMD_efis_map_range_capt_up	= create_command("laminar/B738/EFIS_control/capt/map_range_up", "CAPT EFIS Map range Up", B738_efis_map_range_capt_up_CMDhandler)
B738CMD_efis_map_range_capt_dn	= create_command("laminar/B738/EFIS_control/capt/map_range_dn", "CAPT EFIS Map range Down", B738_efis_map_range_capt_dn_CMDhandler)

B738CMD_efis_map_mode_capt_up 	= create_command("laminar/B738/EFIS_control/capt/map_mode_up", "CAPT MAP mode Up", B738_efis_map_mode_capt_up_CMDhandler)
B738CMD_efis_map_mode_capt_dn 	= create_command("laminar/B738/EFIS_control/capt/map_mode_dn", "CAPT MAP mode Down", B738_efis_map_mode_capt_dn_CMDhandler)


-- FO EFIS COMMANDS
B738CMD_dh_copilot_up		= create_command("laminar/B738/pfd/dh_copilot_up", "First Officer DH up", B738_dh_copilot_up_CMDhandler)
B738CMD_dh_copilot_dn		= create_command("laminar/B738/pfd/dh_copilot_dn", "First Officer DH down", B738_dh_copilot_dn_CMDhandler)
B738CMD_dh_copilot_up1		= create_command("laminar/B738/pfd/dh_copilot_up1", "First Officer DH up 1 detend", B738_dh_copilot_up1_CMDhandler)
B738CMD_dh_copilot_up2		= create_command("laminar/B738/pfd/dh_copilot_up2", "First Officer DH up 2 detend", B738_dh_copilot_up2_CMDhandler)
B738CMD_dh_copilot_dn1		= create_command("laminar/B738/pfd/dh_copilot_dn1", "First Officer DH down 1 detend", B738_dh_copilot_dn1_CMDhandler)
B738CMD_dh_copilot_dn2		= create_command("laminar/B738/pfd/dh_copilot_dn2", "First Officer DH down 2 detend", B738_dh_copilot_dn2_CMDhandler)


B738CMD_efis_wxr_fo 		= create_command("laminar/B738/EFIS_control/fo/push_button/wxr_press", "fo EFIS Weather", B738_efis_wxr_fo_CMDhandler)
B738CMD_efis_sta_fo 		= create_command("laminar/B738/EFIS_control/fo/push_button/sta_press", "fo EFIS Station", B738_efis_sta_fo_CMDhandler)
B738CMD_efis_wpt_fo 		= create_command("laminar/B738/EFIS_control/fo/push_button/wpt_press", "fo EFIS Waypoint", B738_efis_wpt_fo_CMDhandler)
B738CMD_efis_arpt_fo 		= create_command("laminar/B738/EFIS_control/fo/push_button/arpt_press", "fo EFIS Airport", B738_efis_arpt_fo_CMDhandler)
B738CMD_efis_data_fo 		= create_command("laminar/B738/EFIS_control/fo/push_button/data_press", "fo EFIS DATA", B738_efis_data_fo_CMDhandler)
B738CMD_efis_pos_fo 		= create_command("laminar/B738/EFIS_control/fo/push_button/pos_press", "fo EFIS Position", B738_efis_pos_fo_CMDhandler)
B738CMD_efis_terr_fo 		= create_command("laminar/B738/EFIS_control/fo/push_button/terr_press", "fo EFIS Terrain", B738_efis_terr_fo_CMDhandler)

B738CMD_efis_rst_fo 		= create_command("laminar/B738/EFIS_control/fo/push_button/rst_press", "fo EFIS Reset", B738_efis_rst_fo_CMDhandler)
B738CMD_efis_ctr_fo 		= create_command("laminar/B738/EFIS_control/fo/push_button/ctr_press", "fo EFIS Center", B738_efis_ctr_fo_CMDhandler)
B738CMD_efis_tfc_fo 		= create_command("laminar/B738/EFIS_control/fo/push_button/tfc_press", "fo EFIS Traffic", B738_efis_tfc_fo_CMDhandler)
B738CMD_efis_std_fo 		= create_command("laminar/B738/EFIS_control/fo/push_button/std_press", "fo EFIS Standard", B738_efis_std_fo_CMDhandler)

B738CMD_efis_mtrs_fo 		= create_command("laminar/B738/EFIS_control/fo/push_button/mtrs_press", "fo ALT in Meters", B738_efis_mtrs_fo_CMDhandler)
B738CMD_efis_fpv_fo 		= create_command("laminar/B738/EFIS_control/fo/push_button/fpv_press", "fo Flight Path Vector", B738_efis_fpv_fo_CMDhandler)

B738CMD_efis_baro_mode_fo_up 	= create_command("laminar/B738/EFIS_control/fo/baro_in_hpa_up", "fo Baro Mode HPA", B738_efis_baro_mode_fo_up_CMDhandler)
B738CMD_efis_baro_mode_fo_dn 	= create_command("laminar/B738/EFIS_control/fo/baro_in_hpa_dn", "fo Baro Mode IN", B738_efis_baro_mode_fo_dn_CMDhandler)

B738CMD_efis_vor1_fo_up 		= create_command("laminar/B738/EFIS_control/fo/vor1_off_up", "fo VOR1 Up", B738_efis_vor1_fo_up_CMDhandler)
B738CMD_efis_vor1_fo_dn 		= create_command("laminar/B738/EFIS_control/fo/vor1_off_dn", "fo VOR1 Down", B738_efis_vor1_fo_dn_CMDhandler)

B738CMD_efis_vor2_fo_up 		= create_command("laminar/B738/EFIS_control/fo/vor2_off_up", "fo VOR1 Up", B738_efis_vor2_fo_up_CMDhandler)
B738CMD_efis_vor2_fo_dn 		= create_command("laminar/B738/EFIS_control/fo/vor2_off_dn", "fo VOR1 Down", B738_efis_vor2_fo_dn_CMDhandler)

B738CMD_efis_map_mode_fo_up 	= create_command("laminar/B738/EFIS_control/fo/map_mode_up", "FO MAP mode Up", B738_efis_map_mode_fo_up_CMDhandler)
B738CMD_efis_map_mode_fo_dn 	= create_command("laminar/B738/EFIS_control/fo/map_mode_dn", "FO MAP mode Down", B738_efis_map_mode_fo_dn_CMDhandler)

B738CMD_efis_map_range_fo_up	= create_command("laminar/B738/EFIS_control/fo/map_range_up", "FO EFIS Map range Up", B738_efis_map_range_fo_up_CMDhandler)
B738CMD_efis_map_range_fo_dn	= create_command("laminar/B738/EFIS_control/fo/map_range_dn", "FO EFIS Map range Down", B738_efis_map_range_fo_dn_CMDhandler)


----- AP COMMANDS

B738CMD_autopilot_n1_press				= create_command("laminar/B738/autopilot/n1_press", "N1 Mode", B738_autopilot_n1_press_CMDhandler)
B738CMD_autopilot_speed_press			= create_command("laminar/B738/autopilot/speed_press", "Speed Mode", B738_autopilot_speed_press_CMDhandler)
B738CMD_autopilot_lvl_chg_press			= create_command("laminar/B738/autopilot/lvl_chg_press", "Level Change Mode", B738_autopilot_lvl_chg_press_CMDhandler)
B738CMD_autopilot_vnav_press			= create_command("laminar/B738/autopilot/vnav_press", "Vertical NAV Mode", B738_autopilot_vnav_press_CMDhandler)
B738CMD_autopilot_co_press				= create_command("laminar/B738/autopilot/change_over_press", "IAS MACH Change Over", B738_autopilot_co_press_CMDhandler)

B738CMD_autopilot_lnav_press			= create_command("laminar/B738/autopilot/lnav_press", "FMS Lateral NAV Mode", B738_autopilot_lnav_press_CMDhandler)
B738CMD_autopilot_vorloc_press			= create_command("laminar/B738/autopilot/vorloc_press", "VOR Localizer Mode", B738_autopilot_vorloc_press_CMDhandler)
B738CMD_autopilot_app_press				= create_command("laminar/B738/autopilot/app_press", "Approach Mode", B738_autopilot_app_press_CMDhandler)
B738CMD_autopilot_hdg_sel_press			= create_command("laminar/B738/autopilot/hdg_sel_press", "Heading Select Mode", B738_autopilot_hdg_sel_press_CMDhandler)

B738CMD_autopilot_alt_hld_press			= create_command("laminar/B738/autopilot/alt_hld_press", "Altitude Hold Mode", B738_autopilot_alt_hld_press_CMDhandler)
B738CMD_autopilot_vs_press				= create_command("laminar/B738/autopilot/vs_press", "Vertical Speed Mode", B738_autopilot_vs_press_CMDhandler)

B738CMD_autopilot_disconnect_toggle		= create_command("laminar/B738/autopilot/disconnect_toggle", "AP Disconnect", B738_autopilot_disconnect_toggle_CMDhandler)
B738CMD_autopilot_autothr_arm_toggle	= create_command("laminar/B738/autopilot/autothrottle_arm_toggle", "Autothrottle ARM", B738_autopilot_autothr_arm_toggle_CMDhandler)
B738CMD_autopilot_flight_dir_toggle		= create_command("laminar/B738/autopilot/flight_director_toggle", "Flight Director", B738_autopilot_flight_dir_toggle_CMDhandler)
B738CMD_autopilot_flight_dir_fo_toggle	= create_command("laminar/B738/autopilot/flight_director_fo_toggle", "First Officer Flight Director", B738_autopilot_flight_dir_fo_toggle_CMDhandler)
B738CMD_autopilot_bank_angle_up			= create_command("laminar/B738/autopilot/bank_angle_up", "Bank Angle Increase", B738_autopilot_bank_angle_up_CMDhandler)
B738CMD_autopilot_bank_angle_dn			= create_command("laminar/B738/autopilot/bank_angle_dn", "Bank Angle Decrease", B738_autopilot_bank_angle_dn_CMDhandler)

B738CMD_autopilot_cmd_a_press			= create_command("laminar/B738/autopilot/cmd_a_press", "Command A", B738_autopilot_cmd_a_press_CMDhandler)
B738CMD_autopilot_cmd_b_press			= create_command("laminar/B738/autopilot/cmd_b_press", "Command B", B738_autopilot_cmd_b_press_CMDhandler)
B738CMD_autopilot_disconect_button		= create_command("laminar/B738/autopilot/disconnect_button", "AP Disconnect button", B738_autopilot_disconect_button_CMDhandler)

B738CMD_autopilot_cws_a_press			= create_command("laminar/B738/autopilot/cws_a_press", "Control Wheel Steering A", B738_autopilot_cws_a_press_CMDhandler)
B738CMD_autopilot_cws_b_press			= create_command("laminar/B738/autopilot/cws_b_press", "Control Wheel Steering B", B738_autopilot_cws_b_press_CMDhandler)

B738CMD_vhf_nav_source_switch_lft		= create_command("laminar/B738/toggle_switch/vhf_nav_source_lft", "VHF SOURCE LEFT", B738_vhf_nav_source_switch_lft_CMDhandler)
B738CMD_vhf_nav_source_switch_rgt		= create_command("laminar/B738/toggle_switch/vhf_nav_source_rgt", "VHF SOURCE RIGHT", B738_vhf_nav_source_switch_rgt_CMDhandler)


--- AP altitude dial ft
B738CMD_ap_altitude_up 		= create_command("laminar/B738/autopilot/altitude_up", "AP altitude Up", B738_ap_altitude_up_CMDhandler)
B738CMD_ap_altitude_dn 		= create_command("laminar/B738/autopilot/altitude_dn", "AP altitude Down", B738_ap_altitude_dn_CMDhandler)


B738CMD_ap_heading_up 		= create_command("laminar/B738/autopilot/heading_up", "AP heading Up", B738_ap_heading_up_CMDhandler)
B738CMD_ap_heading_dn 		= create_command("laminar/B738/autopilot/heading_dn", "AP heading Down", B738_ap_heading_dn_CMDhandler)



B738_course_pilot_up		= create_command("laminar/B738/autopilot/course_pilot_up", "CRS Pilot Up", B738_course_pilot_up_CMDhandler)
B738_course_pilot_dn		= create_command("laminar/B738/autopilot/course_pilot_dn", "CRS Pilot Down", B738_course_pilot_dn_CMDhandler)
B738_course_copilot_up		= create_command("laminar/B738/autopilot/course_copilot_up", "CRS Copilot Up", B738_course_copilot_up_CMDhandler)
B738_course_copilot_dn		= create_command("laminar/B738/autopilot/course_copilot_dn", "CRS Copilot Down", B738_course_copilot_dn_CMDhandler)

B738CMD_mfd_sys		 		= create_command("laminar/B738/LDU_control/push_button/MFD_SYS", "MFD SYS", B738_mfd_sys_CMDhandler)
B738CMD_mfd_eng		 		= create_command("laminar/B738/LDU_control/push_button/MFD_ENG", "MFD ENG", B738_mfd_eng_CMDhandler)

-- TEMORARY TO/GA BUTTON
--B738CMD_mfd_eng		 		= create_command("laminar/B738/LDU_control/push_button/MFD_ENG", "Temporary TO/GA button", B738_to_ga_CMDhandler)


-- A/P, A/T light buttons
B738CMD_ap_light_pilot		 	= create_command("laminar/B738/push_button/ap_light_pilot", "A/P light captain button", B738_ap_light_pilot_CMDhandler)
B738CMD_at_light_pilot		 	= create_command("laminar/B738/push_button/at_light_pilot", "A/T light captain button", B738_at_light_pilot_CMDhandler)
B738CMD_ap_light_fo		 		= create_command("laminar/B738/push_button/ap_light_fo", "A/P light FO button", B738_ap_light_fo_CMDhandler)
B738CMD_at_light_fo		 		= create_command("laminar/B738/push_button/at_light_fo", "A/T light FO button", B738_at_light_fo_CMDhandler)


B738CMD_n1_set_source_left = create_command("laminar/B738/toggle_switch/n1_set_source_left", "N1 set select left", B738_n1_set_source_left_CMDhandler)
B738CMD_n1_set_source_right = create_command("laminar/B738/toggle_switch/n1_set_source_right", "N1 set select right", B738_n1_set_source_right_CMDhandler)
--B738CMD_n1_set_adj_left = create_command("laminar/B738/toggle_switch/n1_set_adjust_left", "N1 set adjust left", B738_n1_set_adj_left_CMDhandler)
--B738CMD_n1_set_adj_right = create_command("laminar/B738/toggle_switch/n1_set_adjust_right", "N1 set adjust right", B738_n1_set_adj_right_CMDhandler)


B738CMD_baro_pilot_up 		= create_command("laminar/B738/pilot/barometer_up", "Captain Barometer Up", B738CMD_baro_pilot_up_CMDhandler)
B738CMD_baro_pilot_dn 		= create_command("laminar/B738/pilot/barometer_down", "Captain Barometer Down", B738CMD_baro_pilot_dn_CMDhandler)

B738CMD_baro_copilot_up 		= create_command("laminar/B738/copilot/barometer_up", "First Officer Barometer Up", B738CMD_baro_copilot_up_CMDhandler)
B738CMD_baro_copilot_dn 		= create_command("laminar/B738/copilot/barometer_down", "First Officer Barometer Down", B738CMD_baro_copilot_dn_CMDhandler)

B738CMD_autopilot_spd_interv		= create_command("laminar/B738/autopilot/spd_interv", "SPD intervention", B738_autopilot_spd_interv_CMDhandler)


--*************************************************************************************--
--** 				             X-PLANE COMMAND HANDLERS               	    	 **--
--*************************************************************************************--


function B738_reverse_toggle_CMDhandler(phase, duration)
	
	local deploy_reverse1 = simDR_reverse1_act
	local deploy_reverse2 = simDR_reverse2_act
	
	if phase == 0 then
		if B738DR_thrust1_leveler < 0.05 and B738DR_hyd_A_status == 1 then
			if simDR_reverse1_act == 1 and simDR_radio_height_pilot_ft < 10 then
				if simDR_reverse2_act ~= 3 or B738DR_hyd_B_status == 0 then
					deploy_reverse1 = 3
				end
			else
				deploy_reverse1 = 1
				reverse_max_enable1 = 0
			end
		end
 		if B738DR_thrust2_leveler < 0.05 and B738DR_hyd_B_status == 1 then
			if simDR_reverse2_act == 1 and simDR_radio_height_pilot_ft < 10 then
				if simDR_reverse1_act ~= 3 or B738DR_hyd_A_status == 0 then
					deploy_reverse2 = 3
				end
			else
				deploy_reverse2 = 1
				reverse_max_enable2 = 0
			end
		end
		simDR_reverse1_act = deploy_reverse1
		simDR_reverse2_act = deploy_reverse2
	end
	
end

function B738_reverse_hold_CMDhandler(phase, duration)
	
	local deploy_reverse1 = simDR_reverse1_act
	local deploy_reverse2 = simDR_reverse2_act
	
	if phase == 0 then
		if B738DR_hyd_A_status == 1 then
			if eng1_N1_thrust_cur < 0.05 or simDR_reverse1_act == 3 then	--simDR_throttle_1
				if simDR_radio_height_pilot_ft < 10 then
					if simDR_reverse1_act == 1 then
						if simDR_reverse2_act ~= 3 or B738DR_hyd_B_status == 0 then
							deploy_reverse1 = 3
						end
					end
					reverse_max_enable1 = 1
					reverse_max_on1 = 1
				end
			end
		end
		if B738DR_hyd_B_status == 1 then
			if eng2_N1_thrust_cur < 0.05 or simDR_reverse2_act == 3 then	--simDR_throttle_2
				if simDR_radio_height_pilot_ft < 10 then
					if simDR_reverse2_act == 1 then
						if simDR_reverse1_act ~= 3 or B738DR_hyd_A_status == 0 then
							deploy_reverse2 = 3
						end
					end
					reverse_max_enable2 = 1
					reverse_max_on2 = 1
				end
			end
		end
		simDR_reverse1_act = deploy_reverse1
		simDR_reverse2_act = deploy_reverse2
	elseif phase == 2 then
		if B738DR_hyd_A_status == 1 then
			reverse_max_on1 = 0
		end
		if B738DR_hyd_B_status == 1 then
			reverse_max_on2 = 0
		end
	end
end


function vert_spd_down()
	if simDR_ap_vvi_dial > -7900 then
		if simDR_ap_vvi_dial >= -950 and simDR_ap_vvi_dial < 1100 then
			simDR_ap_vvi_dial = simDR_ap_vvi_dial - 50
			simDR_ap_vvi_dial = roundDownToIncrement(simDR_ap_vvi_dial, 50)
		else
			simDR_ap_vvi_dial = simDR_ap_vvi_dial - 100
			simDR_ap_vvi_dial = roundDownToIncrement(simDR_ap_vvi_dial, 100)
		end
	end
	if simDR_ap_vvi_dial < -7900 then
		simDR_ap_vvi_dial = -7900
	end
end

function vert_spd_up()
	if simDR_ap_vvi_dial < 6000 then
		if simDR_ap_vvi_dial > -1100 and simDR_ap_vvi_dial <= 950 then
			simDR_ap_vvi_dial = simDR_ap_vvi_dial + 50
			simDR_ap_vvi_dial = roundDownToIncrement(simDR_ap_vvi_dial, 50)
		else
			simDR_ap_vvi_dial = simDR_ap_vvi_dial + 100
			simDR_ap_vvi_dial = roundDownToIncrement(simDR_ap_vvi_dial, 100)
		end
	end
	if simDR_ap_vvi_dial > 6000 then
		simDR_ap_vvi_dial = 6000
	end
end

function B738_vert_spd_down_CMDhandler(phase, duration)
	if phase == 0 then
		vert_spd_down()
		vert_spd_timer = 0
		vert_spd_timer2 = 0
	elseif phase == 1 then
		if vert_spd_timer > 0.8 then
			vert_spd_timer2 = vert_spd_timer2 + SIM_PERIOD
			if vert_spd_timer2 > 0.05 then
				vert_spd_timer2 = 0
				vert_spd_down()
			end
		else
			vert_spd_timer = vert_spd_timer + SIM_PERIOD
		end
	else
		vert_spd_timer = 0
		vert_spd_timer2 = 0
	end
end

function B738_vert_spd_up_CMDhandler(phase, duration)
	if phase == 0 then
		vert_spd_up()
		vert_spd_timer = 0
		vert_spd_timer2 = 0
	elseif phase == 1 then
		if vert_spd_timer > 0.8 then
			vert_spd_timer2 = vert_spd_timer2 + SIM_PERIOD
			if vert_spd_timer2 > 0.05 then
				vert_spd_timer2 = 0
				vert_spd_up()
			end
		else
			vert_spd_timer = vert_spd_timer + SIM_PERIOD
		end
	else
		vert_spd_timer = 0
		vert_spd_timer2 = 0
	end
end

function B738_heading_sync_CMDhandler(phase, duration)
	--hdgsk
	if phase == 0 then
		B738DR_mcp_hdg_dial = simDR_ahars_mag_hdg
	end
end

--*************************************************************************************--
--** 				             REPLACE X-PLANE COMMANDS                  	    	 **--
--*************************************************************************************--

simCMD_take_off_go_around	= replace_command("sim/autopilot/take_off_go_around", B738_to_ga_CMDhandler)
simCMD_take_off_go_around2	= replace_command("sim/engines/TOGA_power", B738_to_ga2_CMDhandler)

simCMD_ap_alt_up			= replace_command("sim/autopilot/altitude_up", B738_ap_alt_up_CMDhandler)
simCMD_ap_alt_dn			= replace_command("sim/autopilot/altitude_down", B738_ap_alt_dn_CMDhandler)
simCMD_ap_crs_pilot_up		= replace_command("sim/radios/obs_HSI_up", B738_ap_crs_pilot_up_CMDhandler)
simCMD_ap_crs_pilot_dn		= replace_command("sim/radios/obs_HSI_down", B738_ap_crs_pilot_dn_CMDhandler)
simCMD_ap_crs_copilot_up	= replace_command("sim/radios/copilot_obs_HSI_up", B738_ap_crs_copilot_up_CMDhandler)
simCMD_ap_crs_copilot_dn	= replace_command("sim/radios/copilot_obs_HSI_down", B738_ap_crs_copilot_dn_CMDhandler)

simCMD_reverse_toggle		= replace_command("sim/engines/thrust_reverse_toggle", B738_reverse_toggle_CMDhandler)
simCMD_reverse_hold			= replace_command("sim/engines/thrust_reverse_hold", B738_reverse_hold_CMDhandler)

simCMD_vert_spd_down		= replace_command("sim/autopilot/vertical_speed_down", B738_vert_spd_down_CMDhandler)
simCMD_vert_spd_up			= replace_command("sim/autopilot/vertical_speed_up", B738_vert_spd_up_CMDhandler)

simCMD_heading_sync			= replace_command("sim/autopilot/heading_sync", B738_heading_sync_CMDhandler)

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

function B738_set_animation_rate_sec(current_value3, target3, min, max, speed)
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
		calc_result = current_value3 + (SIM_PERIOD * calc_speed)
		if calc_result > target3 then
			calc_result = target3
		end
		return calc_result
	else
		calc_result = current_value3 - (SIM_PERIOD * calc_speed)
		if calc_result < target3 then
			calc_result = target3
		end
        return calc_result
    end
end

----- RESCALE FLOAT AND CLAMP TO OUTER LIMITS -------------------------------------------
function B738_rescale(in1, out1, in2, out2, x)

    if x < in1 then return out1 end
    if x > in2 then return out2 end
    if in2 - in1 == 0 then return out1 + (out2 - out1) * (x - in1) end
    return out1 + (out2 - out1) * (x - in1) / (in2 - in1)

end

function roundUp(x)
    return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
end

-- ROUNDING ---
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


function vert_spd_corr()
	if simDR_ap_vvi_dial >= -950 and simDR_ap_vvi_dial < 1000 then
		simDR_ap_vvi_dial = roundDownToIncrement(simDR_ap_vvi_dial, 50)
	else
		simDR_ap_vvi_dial = roundDownToIncrement(simDR_ap_vvi_dial, 100)
	end
end


---- BLINK TIMER ----------------

function blink_timer()

	if DRblink == 1 then
		if blink_out == 0 then
			blink_out = 1
		else
			blink_out = 0
		end
		DRblink = 0
	else
		DRblink = 1
	end
	if ap_dis_time > 0 then
		B738DR_ap_disconnect = blink_out
		B738DR_snd_ap_disconnect = 1
	else
		B738DR_ap_disconnect = 0
		B738DR_snd_ap_disconnect = 0
	end
	if at_dis_time > 0 then
		B738DR_at_disconnect = blink_out
	else
		B738DR_at_disconnect = 0
	end
	
	if ap_on == 1 and simDR_radio_height_pilot_ft < 100 then
		--if ap_roll_mode == 11 and B738DR_gp_status == 2 then
		if fac_engaged == 1 and B738DR_gp_status == 2 then
			B738DR_ap_warning = blink_out
		else
			B738DR_ap_warning = 0
		end
	else
		B738DR_ap_warning = 0
	end
	
end

function rec_thr_timer()
	blink_rec_thr_status = 0
end

function rec_thr2_timer()
	blink_rec_thr2_status = 0
end


function rec_hdg_timer()
	blink_rec_hdg_status = 0
end

function rec_alt_timer()
	blink_rec_alt_status = 0
end

function rec_alt_alert_timer()
	blink_rec_alt_alert_status = 0
end

function rec_cmd_timer1()
	blink_rec_cmd_status1 = 0
end

function rec_cmd_timer2()
	blink_rec_cmd_status2 = 0
end

function rec_sch_timer()
	blink_rec_sch_status = 0
end


function B738_PFD_flash2()

	if is_timer_scheduled(blink_timer) == false then
		run_at_interval(blink_timer, 0.2)
	end

	-- SPEED modes
	if pfd_spd_old ~= B738DR_pfd_spd_mode
	and B738DR_pfd_spd_mode > 1 then
		if is_timer_scheduled(rec_thr2_timer) == true then
			stop_timer(rec_thr2_timer)
		end
		blink_rec_thr2_status = 0
		if is_timer_scheduled(rec_thr_timer) == true then
			stop_timer(rec_thr_timer)
		end
		run_after_time(rec_thr_timer, 10.0)
		blink_rec_thr_status = 1
	end
	if pfd_spd_old ~= B738DR_pfd_spd_mode
	and B738DR_pfd_spd_mode == 1 then
		if is_timer_scheduled(rec_thr_timer) == true then
			stop_timer(rec_thr_timer)
		end
		blink_rec_thr_status = 0
		if is_timer_scheduled(rec_thr2_timer) == true then
			stop_timer(rec_thr2_timer)
		end
		run_after_time(rec_thr2_timer, 10.0)
		blink_rec_thr2_status = 1
	end
	
	if B738DR_pfd_spd_mode == 0 or B738DR_autopilot_autothr_arm_pos == 0 then
		if is_timer_scheduled(rec_thr_timer) == true then
			stop_timer(rec_thr_timer)
		end
		blink_rec_thr_status = 0
		if is_timer_scheduled(rec_thr2_timer) == true then
			stop_timer(rec_thr2_timer)
		end
		blink_rec_thr2_status = 0
	end
	pfd_spd_old = B738DR_pfd_spd_mode

	if blink_rec_thr_status == 0 then
		B738DR_rec_thr_modes = 0
	end
	if blink_rec_thr2_status == 0 then
		B738DR_rec_thr2_modes = 0
	end
	
	-- ROLL modes
	if pfd_hdg_old ~= B738DR_pfd_hdg_mode
	and B738DR_pfd_hdg_mode > 0 then
		if is_timer_scheduled(rec_hdg_timer) == true then
			stop_timer(rec_hdg_timer)
		end
		run_after_time(rec_hdg_timer, 10.0)
		blink_rec_hdg_status = 1
	end
	
	if B738DR_pfd_hdg_mode == 0 then
		if is_timer_scheduled(rec_hdg_timer) == true then
			stop_timer(rec_hdg_timer)
		end
		blink_rec_hdg_status = 0
	end
	pfd_hdg_old = B738DR_pfd_hdg_mode

	if blink_rec_hdg_status == 0 then
		B738DR_rec_hdg_modes = 0
	end
	
	
	-- PITCH modes
	if pfd_alt_old ~= B738DR_pfd_alt_mode
	and B738DR_pfd_alt_mode > 0 then
		if is_timer_scheduled(rec_alt_timer) == true then
			stop_timer(rec_alt_timer)
		end
		run_after_time(rec_alt_timer, 10.0)
		blink_rec_alt_status = 1
	end
	
	if B738DR_pfd_alt_mode == 0 then
		if is_timer_scheduled(rec_alt_timer) == true then
			stop_timer(rec_alt_timer)
		end
		blink_rec_alt_status = 0
	end
	pfd_alt_old = B738DR_pfd_alt_mode

	if blink_rec_alt_status == 0 then
		B738DR_rec_alt_modes = 0
	end
	
	
	-- CMD MODES
	local cmd_status1 = 0	-- 0-Off,  1-FD, 2-CMD, 3-LAND 3
	if B738DR_single_ch_status == 0 then
		if B738DR_autopilot_fd_pos == 0 and simDR_flight_dir_mode < 2 then
			cmd_status1 = 0
		else
			cmd_status1 = simDR_flight_dir_mode
		end
		if B738DR_flare_status == 1 then
			cmd_status1 = 3
		end
	end
	if cmd_old1 ~= cmd_status1
	and cmd_status1 > 0 then
		if is_timer_scheduled(rec_cmd_timer1) == true then	-- 10 seconds
			stop_timer(rec_cmd_timer1)
		end
		run_after_time(rec_cmd_timer1, 10.0)
		blink_rec_cmd_status1 = 1
	end
	if cmd_status1 == 0 then
		if is_timer_scheduled(rec_cmd_timer1) == true then
			stop_timer(rec_cmd_timer1)
		end
		blink_rec_cmd_status1 = 0
	end
	cmd_old1 = cmd_status1
	if blink_rec_cmd_status1== 0 then
		B738DR_rec_cmd_modes1 = 0
	end
	
	local cmd_status2 = 0	-- 0-Off,  1-FD, 2-CMD, 3-LAND 3
	if B738DR_single_ch_status == 0 then
		if B738DR_autopilot_fd_fo_pos == 0 and simDR_flight_dir_mode < 2 then
			cmd_status2 = 0
		else
			cmd_status2 = simDR_flight_dir_mode
		end
		if B738DR_flare_status == 1 then
			cmd_status2 = 3
		end
	end
	if cmd_old2 ~= cmd_status2
	and cmd_status2 > 0 then
		if is_timer_scheduled(rec_cmd_timer2) == true then	-- 10 seconds
			stop_timer(rec_cmd_timer2)
		end
		run_after_time(rec_cmd_timer2, 10.0)
		blink_rec_cmd_status2 = 1
	end
	if cmd_status2 == 0 then
		if is_timer_scheduled(rec_cmd_timer2) == true then
			stop_timer(rec_cmd_timer2)
		end
		blink_rec_cmd_status2 = 0
	end
	cmd_old2 = cmd_status2
	if blink_rec_cmd_status2== 0 then
		B738DR_rec_cmd_modes2 = 0
	end
	
	
	-- SINGLE CHANNEL
	if single_ch_status_old ~= B738DR_single_ch_status
	and B738DR_single_ch_status == 1 then
		if is_timer_scheduled(rec_sch_timer) == true then	-- 10 seconds
			stop_timer(rec_sch_timer)
		end
		run_after_time(rec_sch_timer, 10.0)
		blink_rec_sch_status = 1
	end
	if B738DR_single_ch_status == 0 then
		if is_timer_scheduled(rec_sch_timer) == true then
			stop_timer(rec_sch_timer)
		end
		blink_rec_sch_status = 0
	end
	single_ch_status_old = B738DR_single_ch_status
	if blink_rec_sch_status == 0 then
		B738DR_rec_sch_modes = 0
	end
	
	-- ALT ALERT
	local altx = 0
	local capt_fo = 0	-- 0-captain, 1- first officer
	local alt_alert_disable = 0
	
	-- if fac_engaged == 1 then
		-- alt_alert_disable = 1
	-- end
	if ap_pitch_mode_eng == 5 and ap_pitch_mode == 5 	-- VNAV
	and ap_roll_mode_eng == 4 and ap_roll_mode == 4		-- LNAV
	and B738DR_gp_active > 0 and B738DR_pfd_vert_path == 1 then	-- (G/P) -> LNAV/VNAV
		alt_alert_disable = 1
	end
	if ap_pitch_mode_eng == 7 and ap_pitch_mode == 7 then 	-- GP
		alt_alert_disable = 1
	end
	
	if alt_alert_disable == 0 then
		if simDR_autopilot_altitude_mode == 4 or simDR_autopilot_altitude_mode == 5 then
			
			if B738DR_autopilot_master_capt_status == 0 and B738DR_autopilot_master_fo_status == 0 then
				if autopilot_cmd_b_status == 1 then
					capt_fo = 1
				end
			elseif B738DR_autopilot_master_capt_status == 1 and B738DR_autopilot_master_fo_status == 1 then		-- autoland
				capt_fo = cmd_first
			elseif B738DR_autopilot_master_fo_status == 1 then
				capt_fo = 1
			end
			if capt_fo == 0 then
				altx = B738DR_mcp_alt_dial - simDR_altitude_pilot
				if altx < 0 and simDR_vvi_fpm_pilot < 0 then
					altx = -altx
				end
			else
				altx = B738DR_mcp_alt_dial - simDR_altitude_copilot
				if altx < 0 and simDR_vvi_fpm_copilot < 0 then
					altx = -altx
				end
			end
			
			if altx > 980 and altx < 1000 then
				if is_timer_scheduled(rec_alt_alert_timer) == true then	-- 10 seconds
					stop_timer(rec_alt_alert_timer)
				end
				run_after_time(rec_alt_alert_timer, 12.0)
				blink_rec_alt_alert_status = 1
			end
			if altx > 1000 then
				if is_timer_scheduled(rec_alt_alert_timer) == true then
					stop_timer(rec_alt_alert_timer)
				end
				blink_rec_alt_alert_status = 0
			end
		end
	else
		if is_timer_scheduled(rec_alt_alert_timer) == true then
			stop_timer(rec_alt_alert_timer)
		end
		blink_rec_alt_alert_status = 0
	end
	if blink_rec_alt_alert_status == 0 then
		B738DR_rec_alt_alert = 0
	end
	
	
	B738DR_rec_thr_modes = blink_rec_thr_status
	B738DR_rec_thr2_modes = blink_rec_thr2_status
	B738DR_rec_hdg_modes = blink_rec_hdg_status
	B738DR_rec_alt_modes = blink_rec_alt_status
	B738DR_rec_alt_alert = blink_rec_alt_alert_status
	B738DR_rec_cmd_modes1 = blink_rec_cmd_status1
	B738DR_rec_cmd_modes2 = blink_rec_cmd_status2
	B738DR_rec_sch_modes = blink_rec_sch_status

end








function B738_PFD_flash()

	if is_timer_scheduled(blink_timer) == false then
		run_at_interval(blink_timer, 0.2)
	end

	-- Thrust modes blink rectangle

--	blink_rec_thr_status = 0
	if autothrottle_pfd_old ~= B738DR_autopilot_autothrottle_pfd
	and B738DR_autopilot_autothrottle_pfd > 0 then
		if is_timer_scheduled(rec_thr_timer) == true then
			stop_timer(rec_thr_timer)
		end
		run_after_time(rec_thr_timer, 10.0)
		blink_rec_thr_status = 1
	end
	if autothrottle_status_old ~= B738DR_autopilot_autothrottle_on
	and B738DR_autopilot_autothrottle_on > 0 then
		if is_timer_scheduled(rec_thr_timer) == true then
			stop_timer(rec_thr_timer)
		end
		run_after_time(rec_thr_timer, 10.0)
		blink_rec_thr_status = 1
	end
	if n1_status_old ~= B738DR_autopilot_n1_pfd
	and B738DR_autopilot_n1_pfd == 1 then
		if is_timer_scheduled(rec_thr_timer) == true then
			stop_timer(rec_thr_timer)
		end
		run_after_time(rec_thr_timer, 10.0)
		blink_rec_thr_status = 1
	end
	if retard_status_old ~= B738DR_retard_status
	and B738DR_retard_status == 1 then
		if is_timer_scheduled(rec_thr_timer) == true then
			stop_timer(rec_thr_timer)
		end
		run_after_time(rec_thr_timer, 10.0)
		blink_rec_thr_status = 1
	end
	if ga_pfd_old ~= B738DR_autopilot_ga_pfd
	and B738DR_autopilot_ga_pfd == 1 then
		if is_timer_scheduled(rec_thr_timer) == true then
			stop_timer(rec_thr_timer)
		end
		run_after_time(rec_thr_timer, 10.0)
		blink_rec_thr_status = 1
	end
	if thr_hld_pfd_old ~= B738DR_autopilot_thr_hld_pfd
	and B738DR_autopilot_thr_hld_pfd == 1 then
		if is_timer_scheduled(rec_thr_timer) == true then
			stop_timer(rec_thr_timer)
		end
		run_after_time(rec_thr_timer, 10.0)
		blink_rec_thr_status = 1
	end
	if autopilot_cmd_a_status == 1 or autopilot_cmd_b_status == 1 then
		if fmc_spd_status_old ~= B738DR_autopilot_fmc_spd_pfd
		and B738DR_autopilot_fmc_spd_pfd == 1 then
			if is_timer_scheduled(rec_thr_timer) == true then
				stop_timer(rec_thr_timer)
			end
			run_after_time(rec_thr_timer, 10.0)
			blink_rec_thr_status = 1
		end
	end
	if B738DR_autopilot_autothrottle_pfd == 0
	and B738DR_autopilot_autothrottle_on == 0
	and B738DR_autopilot_n1_pfd == 0
	and B738DR_retard_status == 0
	and B738DR_autopilot_fmc_spd_pfd == 0
	and B738DR_autopilot_ga_pfd == 0
	and B738DR_autopilot_thr_hld_pfd == 0 then
		if is_timer_scheduled(rec_thr_timer) == true then
			stop_timer(rec_thr_timer)
		end
		blink_rec_thr_status = 0
	end
	autothrottle_pfd_old = B738DR_autopilot_autothrottle_pfd	-- ARM
	autothrottle_status_old = B738DR_autopilot_autothrottle_on	-- MCP SPD
	n1_status_old = B738DR_autopilot_n1_pfd 			-- N1
	retard_status_old = B738DR_retard_status			-- RETARD
	thr_hld_pfd_old = B738DR_autopilot_thr_hld_pfd
	ga_pfd_old = B738DR_autopilot_ga_pfd
	if autopilot_cmd_a_status == 1 or autopilot_cmd_b_status == 1 then
		fmc_spd_status_old = B738DR_autopilot_fmc_spd_pfd	-- FMC SPD
	else
		fmc_spd_status_old = 0
	end

	-- if blink_rec_thr_status == 1 then
		-- if is_timer_scheduled(rec_thr_timer) == false then	-- 10 seconds
			-- run_after_time(rec_thr_timer, 10.0)
		-- end
	-- else
	if blink_rec_thr_status == 0 then
		B738DR_rec_thr_modes = 0
	end

	-- Roll modes blink rectangle

--	blink_rec_hdg_status = 0
	if ap_on == 1 then
		if hdg_mode_status_old ~= B738DR_autopilot_hdg_mode_pfd
		and B738DR_autopilot_hdg_mode_pfd > 0 and B738DR_autoland_status == 0 then
			if is_timer_scheduled(rec_hdg_timer) == true then
				stop_timer(rec_hdg_timer)
			end
			run_after_time(rec_hdg_timer, 10.0)
			blink_rec_hdg_status = 1
		end
	else
		if is_timer_scheduled(rec_hdg_timer) == true then
			stop_timer(rec_hdg_timer)
		end
		blink_rec_hdg_status = 0
	end
	if B738DR_autopilot_hdg_mode_pfd == 0 then
		if is_timer_scheduled(rec_hdg_timer) == true then
			stop_timer(rec_hdg_timer)
		end
		blink_rec_hdg_status = 0
	end
	
	if ap_on == 1 then
		hdg_mode_status_old = B738DR_autopilot_hdg_mode_pfd 	-- HDG modes
	else
		hdg_mode_status_old = 0
	end
	
	-- if blink_rec_hdg_status == 1 then
		-- if is_timer_scheduled(rec_hdg_timer) == false then	-- 10 seconds
			-- run_after_time(rec_hdg_timer, 10.0)
		-- end
	-- else
	if blink_rec_hdg_status == 0 then
		B738DR_rec_hdg_modes = 0
	end

	-- Pitch modes blink rectangle
	if to_ga_pfd_old ~= B738DR_autopilot_to_ga_pfd
	and B738DR_autopilot_to_ga_pfd == 1 then
		if is_timer_scheduled(rec_alt_timer) == true then	-- 10 seconds
			stop_timer(rec_alt_timer)
		end
		run_after_time(rec_alt_timer, 10.0)
		blink_rec_alt_status = 1
		blink_to_ga = 1
	end
	if ap_on == 1 then
		if alt_mode_status_old ~= B738DR_autopilot_alt_mode_pfd
		and B738DR_autopilot_alt_mode_pfd >= 4 
		and B738DR_autopilot_alt_acq_pfd == 0 then
			if is_timer_scheduled(rec_alt_timer) == true then	-- 10 seconds
				stop_timer(rec_alt_timer)
			end
			run_after_time(rec_alt_timer, 10.0)
			blink_rec_alt_status = 1
		end
		if vnav_alt_status_old ~= B738DR_autopilot_vnav_alt_pfd
		and B738DR_autopilot_vnav_alt_pfd == 1 then
			if is_timer_scheduled(rec_alt_timer) == true then	-- 10 seconds
				stop_timer(rec_alt_timer)
			end
			run_after_time(rec_alt_timer, 10.0)
			blink_rec_alt_status = 1
		end
		if vnav_pth_status_old ~= B738DR_autopilot_vnav_pth_pfd
		and B738DR_autopilot_vnav_pth_pfd == 1 then
			if is_timer_scheduled(rec_alt_timer) == true then	-- 10 seconds
				stop_timer(rec_alt_timer)
			end
			run_after_time(rec_alt_timer, 10.0)
			blink_rec_alt_status = 1
		end
		if vnav_spd_status_old ~= B738DR_autopilot_vnav_spd_pfd
		and B738DR_autopilot_vnav_spd_pfd == 1 then
			if is_timer_scheduled(rec_alt_timer) == true then	-- 10 seconds
				stop_timer(rec_alt_timer)
			end
			run_after_time(rec_alt_timer, 10.0)
			blink_rec_alt_status = 1
		end
		if flare_status_old ~= B738DR_flare_status
		and B738DR_flare_status == 2 then
			if is_timer_scheduled(rec_alt_timer) == true then	-- 10 seconds
				stop_timer(rec_alt_timer)
			end
			run_after_time(rec_alt_timer, 10.0)
			blink_rec_alt_status = 1
		end
		if alt_acq_pfd_old ~= B738DR_autopilot_alt_acq_pfd
		and B738DR_autopilot_alt_acq_pfd == 1 then
			if is_timer_scheduled(rec_alt_timer) == true then	-- 10 seconds
				stop_timer(rec_alt_timer)
			end
			run_after_time(rec_alt_timer, 10.0)
			blink_rec_alt_status = 1
		end
	elseif blink_to_ga == 0 then
		if is_timer_scheduled(rec_alt_timer) == true 
		and blink_rec_alt_status == 0 then
			stop_timer(rec_alt_timer)
		end
		blink_rec_alt_status = 0
	end
	
	if B738DR_autopilot_alt_mode_pfd < 4
	and B738DR_autopilot_vnav_alt_pfd == 0
	and B738DR_autopilot_vnav_pth_pfd == 0
	and B738DR_autopilot_vnav_spd_pfd == 0
	and B738DR_flare_status == 0 
	and B738DR_autopilot_to_ga_pfd == 0
	and B738DR_autopilot_alt_acq_pfd == 0 then
		if is_timer_scheduled(rec_alt_timer) == true then
			stop_timer(rec_alt_timer)
		end
		blink_rec_alt_status = 0
		blink_to_ga = 0
	end

	to_ga_pfd_old = B738DR_autopilot_to_ga_pfd
	if ap_on == 1 then
		if ils_test_on == 0 then
			alt_mode_status_old = B738DR_autopilot_alt_mode_pfd	-- ALT modes
		end
		if B738DR_autopilot_alt_acq_pfd == 0 then
			vnav_alt_status_old = B738DR_autopilot_vnav_alt_pfd	-- VNAV ALT
		else
			vnav_alt_status_old = 10
		end
		vnav_pth_status_old = B738DR_autopilot_vnav_pth_pfd	-- VNAV PTH
		vnav_spd_status_old = B738DR_autopilot_vnav_spd_pfd	-- VNAV SPD
		flare_status_old = B738DR_flare_status				-- FLARE
		alt_acq_pfd_old = B738DR_autopilot_alt_acq_pfd
	else
		alt_mode_status_old = 0
		vnav_alt_status_old = 0
		vnav_pth_status_old = 0
		vnav_spd_status_old = 0
		flare_status_old = 0
--		to_ga_pfd_old = 0
		alt_acq_pfd_old = 0
	end
	
	-- if blink_rec_alt_status == 1 then
		-- if is_timer_scheduled(rec_alt_timer) == false then	-- 10 seconds
			-- run_after_time(rec_alt_timer, 10.0)
		-- end
	-- else
	if blink_rec_alt_status == 0 then
		B738DR_rec_alt_modes = 0
	end
	
	-- CMD MODES
	local cmd_status1 = 0	-- 0-Off,  1-FD, 2-CMD, 3-LAND 3
	if B738DR_single_ch_status == 0 then
		if B738DR_autopilot_fd_pos == 0 and simDR_flight_dir_mode < 2 then
			cmd_status1 = 0
		else
			cmd_status1 = simDR_flight_dir_mode
		end
		if B738DR_flare_status == 1 then
			cmd_status1 = 3
		end
	end
	if cmd_old1 ~= cmd_status1
	and cmd_status1 > 0 then
		if is_timer_scheduled(rec_cmd_timer1) == true then	-- 10 seconds
			stop_timer(rec_cmd_timer1)
		end
		run_after_time(rec_cmd_timer1, 10.0)
		blink_rec_cmd_status1 = 1
	end
	if cmd_status1 == 0 then
		if is_timer_scheduled(rec_cmd_timer1) == true then
			stop_timer(rec_cmd_timer1)
		end
		blink_rec_cmd_status1 = 0
	end
	cmd_old1 = cmd_status1
	if blink_rec_cmd_status1== 0 then
		B738DR_rec_cmd_modes1 = 0
	end
	
	local cmd_status2 = 0	-- 0-Off,  1-FD, 2-CMD, 3-LAND 3
	if B738DR_single_ch_status == 0 then
		if B738DR_autopilot_fd_fo_pos == 0 and simDR_flight_dir_mode < 2 then
			cmd_status2 = 0
		else
			cmd_status2 = simDR_flight_dir_mode
		end
		if B738DR_flare_status == 1 then
			cmd_status2 = 3
		end
	end
	if cmd_old2 ~= cmd_status2
	and cmd_status2 > 0 then
		if is_timer_scheduled(rec_cmd_timer2) == true then	-- 10 seconds
			stop_timer(rec_cmd_timer2)
		end
		run_after_time(rec_cmd_timer2, 10.0)
		blink_rec_cmd_status2 = 1
	end
	if cmd_status2 == 0 then
		if is_timer_scheduled(rec_cmd_timer2) == true then
			stop_timer(rec_cmd_timer2)
		end
		blink_rec_cmd_status2 = 0
	end
	cmd_old2 = cmd_status2
	if blink_rec_cmd_status2== 0 then
		B738DR_rec_cmd_modes2 = 0
	end
	
	
	-- SINGLE CHANNEL
	if single_ch_status_old ~= B738DR_single_ch_status
	and B738DR_single_ch_status == 1 then
		if is_timer_scheduled(rec_sch_timer) == true then	-- 10 seconds
			stop_timer(rec_sch_timer)
		end
		run_after_time(rec_sch_timer, 10.0)
		blink_rec_sch_status = 1
	end
	if B738DR_single_ch_status == 0 then
		if is_timer_scheduled(rec_sch_timer) == true then
			stop_timer(rec_sch_timer)
		end
		blink_rec_sch_status = 0
	end
	single_ch_status_old = B738DR_single_ch_status
	if blink_rec_sch_status == 0 then
		B738DR_rec_sch_modes = 0
	end
	
	-- ALT ALERT
	local altx = 0
	local capt_fo = 0	-- 0-captain, 1- first officer
	if simDR_autopilot_altitude_mode == 4 or simDR_autopilot_altitude_mode == 5 then
		
		if B738DR_autopilot_master_capt_status == 0 and B738DR_autopilot_master_fo_status == 0 then
			if autopilot_cmd_b_status == 1 then
				capt_fo = 1
			end
		elseif B738DR_autopilot_master_capt_status == 1 and B738DR_autopilot_master_fo_status == 1 then		-- autoland
			capt_fo = cmd_first
		elseif B738DR_autopilot_master_fo_status == 1 then
			capt_fo = 1
		end
		
		-- if capt_fo == 0 then
			-- altx = simDR_ap_altitude_dial_ft - simDR_altitude_pilot
		-- else
			-- altx = simDR_ap_altitude_dial_ft - simDR_altitude_copilot
		-- end
		if capt_fo == 0 then
			altx = B738DR_mcp_alt_dial - simDR_altitude_pilot
		else
			altx = B738DR_mcp_alt_dial - simDR_altitude_copilot
		end
		
		if altx < 0 then
			altx = -altx
		end
		if altx > 990 and altx < 1000 then
			if is_timer_scheduled(rec_alt_alert_timer) == true then	-- 10 seconds
				stop_timer(rec_alt_alert_timer)
			end
			run_after_time(rec_alt_alert_timer, 12.0)
			blink_rec_alt_alert_status = 1
		end
		if altx > 1000 then
			if is_timer_scheduled(rec_alt_alert_timer) == true then
				stop_timer(rec_alt_alert_timer)
			end
			blink_rec_alt_alert_status = 0
		end
	-- else
		-- if is_timer_scheduled(rec_alt_alert_timer) == true then
			-- stop_timer(rec_alt_alert_timer)
		-- end
		-- blink_rec_alt_alert_status = 0
	end
	if blink_rec_alt_alert_status == 0 then
		B738DR_rec_alt_alert = 0
	end
end


function master_light_block()
	master_light_block_act = 0
end


function autopilot_system_lights2()

	-- SPEED modes
	--if B738DR_autopilot_autothr_arm_pos == 0 then
	if B738DR_autopilot_autothrottle_status == 0 then
		-- none
		B738DR_pfd_spd_mode = 0
		B738DR_autopilot_speed_status = 0
	else
		if B738DR_autopilot_vnav_status == 1 and vnav_engaged == 1 then
			B738DR_autopilot_speed_status = 0
		else
			-- ARM
			if at_mode == 0 and at_mode_eng == 0 then
				B738DR_pfd_spd_mode = PFD_SPD_ARM
			end
			-- N1 mode
			if at_mode == 1 and at_mode_eng == 1 then
				B738DR_pfd_spd_mode = PFD_SPD_N1
			-- SPD mode
			end
			if at_mode == 2 and at_mode_eng == 2 then
				B738DR_autopilot_speed_status = 1
				B738DR_pfd_spd_mode = PFD_SPD_MCP_SPD
			else
				B738DR_autopilot_speed_status = 0
			end
		end
	end
	
	-- ROLL modes arm
	
	-- VOR LOC and APP
	
	if simDR_nav_status == 1 or simDR_approach_status == 1 then
		B738DR_pfd_hdg_mode_arm = PFD_HDG_VOR_LOC_ARM
	else
		if B738DR_pfd_hdg_mode_arm == PFD_HDG_VOR_LOC_ARM then
			B738DR_pfd_hdg_mode_arm = 0
		end
	end
	-- -- APP
	-- if simDR_approach_status == 1 then
		-- B738DR_pfd_hdg_mode_arm = PFD_HDG_VOR_LOC_ARM
	-- else
		-- if B738DR_pfd_hdg_mode_arm == PFD_HDG_VOR_LOC_ARM then
			-- B738DR_pfd_hdg_mode_arm = 0
		-- end
	-- end
	
	-- LNAV
	if ap_roll_mode == 4 and ap_roll_mode_eng == 4 then
		if lnav_engaged == 0 then
			B738DR_pfd_hdg_mode_arm = PFD_HDG_LNAV_ARM
		else
			if B738DR_pfd_hdg_mode_arm == PFD_HDG_LNAV_ARM then
				B738DR_pfd_hdg_mode_arm = 0
			end
		end
	elseif ap_roll_mode == 10 and ap_roll_mode_eng == 10 then
		B738DR_pfd_hdg_mode_arm = PFD_HDG_LNAV_ARM
	else
		if B738DR_pfd_hdg_mode_arm == PFD_HDG_LNAV_ARM then
			B738DR_pfd_hdg_mode_arm = 0
		end
	end
	-- FAC
	if ap_roll_mode == 11 and ap_roll_mode_eng == 11 then
		if fac_engaged == 0 then
			B738DR_pfd_hdg_mode_arm = PFD_HDG_FAC_ARM
		else
			if B738DR_pfd_hdg_mode_arm == PFD_HDG_FAC_ARM then
				B738DR_pfd_hdg_mode_arm = 0
			end
		end
	elseif ap_roll_mode == 7 and ap_roll_mode_eng == 7 then
		B738DR_pfd_hdg_mode_arm = PFD_HDG_FAC_ARM
	elseif ap_roll_mode == 8 and ap_roll_mode_eng == 8 then
		B738DR_pfd_hdg_mode_arm = PFD_HDG_FAC_ARM
	else
		if B738DR_pfd_hdg_mode_arm == PFD_HDG_FAC_ARM then
			B738DR_pfd_hdg_mode_arm = 0
		end
	end
	--if B738DR_flare_status == 1 then
	if B738DR_rollout_status == 1 then
		B738DR_pfd_hdg_mode_arm = PFD_HDG_ROLLOUT_ARM
	else
		if B738DR_pfd_hdg_mode_arm == PFD_HDG_ROLLOUT_ARM then
			B738DR_pfd_hdg_mode_arm = 0
		end
	end
	
	-- ROLL modes
	if ap_roll_mode == 0 and ap_roll_mode_eng == 0 then
		B738DR_pfd_hdg_mode = 0
		B738DR_pfd_hdg_mode_arm = 0
	-- HDG SEL
	elseif ap_roll_mode == 1 and ap_roll_mode_eng == 1 then
		B738DR_pfd_hdg_mode = PFD_HDG_HDG_SEL
	-- VOR LOC
	elseif ap_roll_mode == 2 and ap_roll_mode_eng == 2 then
		if simDR_nav_status == 2 then
			B738DR_pfd_hdg_mode = PFD_HDG_VOR_LOC
			if B738DR_pfd_hdg_mode_arm == PFD_HDG_VOR_LOC_ARM then
				B738DR_pfd_hdg_mode_arm = 0
			end
		end
	-- APP
	elseif ap_roll_mode == 3 and ap_roll_mode_eng == 3 then
		if simDR_approach_status == 2 then
			B738DR_pfd_hdg_mode = PFD_HDG_VOR_LOC
			if B738DR_pfd_hdg_mode_arm == PFD_HDG_VOR_LOC_ARM then
				B738DR_pfd_hdg_mode_arm = 0
			end
		end
	-- HDG / LNAV
	elseif ap_roll_mode == 10 and ap_roll_mode_eng == 10 then
		B738DR_pfd_hdg_mode = PFD_HDG_HDG_SEL
		B738DR_pfd_hdg_mode_arm = PFD_HDG_LNAV_ARM
	-- LNAV
	elseif ap_roll_mode == 4 and ap_roll_mode_eng == 4 and lnav_engaged > 0 then
		if lnav_engaged == 1 then
			B738DR_pfd_hdg_mode = PFD_HDG_LNAV
			if B738DR_pfd_hdg_mode_arm == PFD_HDG_LNAV_ARM then
				B738DR_pfd_hdg_mode_arm = 0
			end
		end
	-- LNAV / VOR LOC
	elseif ap_roll_mode == 5 and ap_roll_mode_eng == 5 then
		B738DR_pfd_hdg_mode = PFD_HDG_LNAV
		B738DR_pfd_hdg_mode_arm = PFD_HDG_VOR_LOC_ARM
	-- LNAV / APP
	elseif ap_roll_mode == 6 and ap_roll_mode_eng == 6 then
		B738DR_pfd_hdg_mode = PFD_HDG_LNAV
		B738DR_pfd_hdg_mode_arm = PFD_HDG_VOR_LOC_ARM
	-- HDG / FAC
	elseif ap_roll_mode == 7 and ap_roll_mode_eng == 7 then
		B738DR_pfd_hdg_mode = PFD_HDG_HDG_SEL
		B738DR_pfd_hdg_mode_arm = PFD_HDG_FAC_ARM
	-- LNAV / FAC
	elseif ap_roll_mode == 8 and ap_roll_mode_eng == 8 then
		B738DR_pfd_hdg_mode = PFD_HDG_LNAV
		B738DR_pfd_hdg_mode_arm = PFD_HDG_FAC_ARM
	-- FAC
	elseif ap_roll_mode == 11 and ap_roll_mode_eng == 11 then
		if fac_engaged == 1 then
			B738DR_pfd_hdg_mode = PFD_HDG_FAC
			if B738DR_pfd_hdg_mode_arm == PFD_HDG_FAC_ARM then
				B738DR_pfd_hdg_mode_arm = 0
			end
		end
	-- ROLLOUT
	elseif ap_roll_mode == 9 and ap_roll_mode_eng == 9 then
		--if B738DR_flare_status == 2 then
		if B738DR_rollout_status == 2 then
			B738DR_pfd_hdg_mode = PFD_HDG_ROLLOUT
			if B738DR_pfd_hdg_mode_arm == PFD_HDG_ROLLOUT_ARM then
				B738DR_pfd_hdg_mode_arm = 0
			end
		end
	-- LOC GP
	elseif ap_roll_mode == 14 and ap_roll_mode_eng == 14 then
		if simDR_nav_status == 2 then
			B738DR_pfd_hdg_mode = PFD_HDG_VOR_LOC
			if B738DR_pfd_hdg_mode_arm == PFD_HDG_VOR_LOC_ARM then
				B738DR_pfd_hdg_mode_arm = 0
			end
		end
	end
	
	-- PITCH modes arm
	if ap_pitch_mode ~= 3 then
		if B738DR_pfd_alt_mode_arm == PFD_ALT_VS_ARM then
			B738DR_pfd_alt_mode_arm = 0
		end
	end
	
	if simDR_glideslope_status == 0 then
		if B738DR_pfd_alt_mode_arm == PFD_ALT_GS_ARM then
			B738DR_pfd_alt_mode_arm = 0
		end
	elseif simDR_glideslope_status == 1 then
		B738DR_pfd_alt_mode_arm = PFD_ALT_GS_ARM
	elseif simDR_glideslope_status == 2 then
		if B738DR_pfd_alt_mode_arm == PFD_ALT_GS_ARM then
			B738DR_pfd_alt_mode_arm = 0
		end
	end
	
	if B738DR_gp_status == 0 then
		if B738DR_pfd_alt_mode_arm == PFD_ALT_GP_ARM then
			B738DR_pfd_alt_mode_arm = 0
		end
	elseif B738DR_gp_status == 1 then
		B738DR_pfd_alt_mode_arm = PFD_ALT_GP_ARM
	end
	
	if B738DR_flare_status == 0 then
		if B738DR_pfd_alt_mode_arm == PFD_ALT_FLARE_ARM then
			B738DR_pfd_alt_mode_arm = 0
		end
	elseif B738DR_flare_status == 1 then
		B738DR_pfd_alt_mode_arm = PFD_ALT_FLARE_ARM
	elseif B738DR_flare_status == 2 then
		if B738DR_pfd_alt_mode_arm == PFD_ALT_FLARE_ARM then
			B738DR_pfd_alt_mode_arm = 0
		end
	end
	if B738DR_autopilot_vnav_status == 1 then
		if vnav_engaged == 0 then
			B738DR_pfd_alt_mode_arm = PFD_ALT_VNAV_ARM
		else
			if B738DR_pfd_alt_mode_arm == PFD_ALT_VNAV_ARM then
				B738DR_pfd_alt_mode_arm = 0
			end
		end
	else
		if B738DR_pfd_alt_mode_arm == PFD_ALT_VNAV_ARM then
			B738DR_pfd_alt_mode_arm = 0
		end
	end
	
	--PITCH modes
	--if at_mode_eng ~= 3 and at_mode_eng ~= 4 and at_mode_eng ~= 5 and at_mode_eng ~= 8 then		-- TOGA
	if at_mode_eng ~= 3 and ap_goaround == 0 and fd_goaround == 0 then		--not TO/GA mode
		if ap_pitch_mode == 0 and ap_pitch_mode_eng == 0 then
			B738DR_pfd_alt_mode = 0
			if B738DR_pfd_alt_mode_arm ~= PFD_ALT_GS_ARM and B738DR_pfd_alt_mode_arm ~= PFD_ALT_GP_ARM then
				B738DR_pfd_alt_mode_arm = 0
			end
		-- V/S
		elseif ap_pitch_mode == 1 and ap_pitch_mode_eng == 1 then
			B738DR_pfd_alt_mode = PFD_ALT_VS
			if B738DR_pfd_alt_mode_arm == PFD_ALT_VS_ARM then
				B738DR_pfd_alt_mode_arm = 0
			end
		-- LVL CHG
		elseif ap_pitch_mode == 2 and ap_pitch_mode_eng == 2 then
			B738DR_pfd_alt_mode = PFD_ALT_MCP_SPD
		-- ALT HOLD
		elseif ap_pitch_mode == 3 and ap_pitch_mode_eng == 3 then
			B738DR_pfd_alt_mode = PFD_ALT_ALT_HOLD
		-- G/S
		elseif ap_pitch_mode == 4 and ap_pitch_mode_eng == 4 then
			B738DR_pfd_alt_mode = PFD_ALT_GS
			if B738DR_pfd_alt_mode_arm == PFD_ALT_GS_ARM then
				B738DR_pfd_alt_mode_arm = 0
			end
		-- VNAV
		-- elseif ap_pitch_mode == 5 and ap_pitch_mode_eng == 5 then
			-- if vnav_engaged == 0 then
				-- B738DR_pfd_alt_mode_arm = PFD_ALT_VNAV_ARM
			-- else
				-- if B738DR_pfd_alt_mode_arm == PFD_ALT_VNAV_ARM then
					-- B738DR_pfd_alt_mode_arm = 0
				-- end
			-- end
		-- ALT ACQ
		elseif ap_pitch_mode == 6 and ap_pitch_mode_eng == 6 then
			B738DR_pfd_alt_mode = PFD_ALT_ALT_ACQ
		end
		
		-- LNAV -> APP
		if ap_roll_mode == 6 and ap_roll_mode_eng == 6 then
			if B738DR_pfd_alt_mode ~= PFD_ALT_GS then
				B738DR_pfd_alt_mode_arm = PFD_ALT_GS_ARM
			end
		elseif ap_roll_mode == 3 and ap_roll_mode_eng == 3 then
			-- APP
			if B738DR_pfd_alt_mode ~= PFD_ALT_GS then
				B738DR_pfd_alt_mode_arm = PFD_ALT_GS_ARM
			end
		end
		if simDR_glideslope_status == 2 then
			B738DR_pfd_alt_mode = PFD_ALT_GS
			if B738DR_pfd_alt_mode_arm == PFD_ALT_GS_ARM then
				B738DR_pfd_alt_mode_arm = 0
			end
		end
		-- if ap_pitch_mode == 7 and ap_pitch_mode_eng == 7
			-- B738DR_pfd_alt_mode = PFD_ALT_GP
			-- if B738DR_pfd_alt_mode_arm == PFD_ALT_GP_ARM then
				-- B738DR_pfd_alt_mode_arm = 0
			-- end
		-- end
		if B738DR_gp_status == 0 then
			if B738DR_pfd_alt_mode == PFD_ALT_GP then
				B738DR_pfd_alt_mode = 0
			end
		elseif B738DR_gp_status == 2 then
			B738DR_pfd_alt_mode = PFD_ALT_GP
			if B738DR_pfd_alt_mode_arm == PFD_ALT_GP_ARM then
				B738DR_pfd_alt_mode_arm = 0
			end
		end
		if B738DR_flare_status == 2 then
			B738DR_pfd_alt_mode = PFD_ALT_FLARE
			if B738DR_pfd_alt_mode_arm == PFD_ALT_FLARE_ARM then
				B738DR_pfd_alt_mode_arm = 0
			end
		end
	end
	
	-- MASTER CAPT / FO
	if B738DR_autoland_status == 1
	and simDR_radio_height_pilot_ft < 1500
	and B738DR_autopilot_fd_pos == 1 
	and B738DR_autopilot_fd_fo_pos == 1 then
			if master_light_block_act == 0 then 
				B738DR_autopilot_master_capt_status = 1
				B738DR_autopilot_master_fo_status = 1
			end
			-- if is_timer_scheduled(master_light_block) == true then
				-- stop_timer(master_light_block)
				-- master_light_block_act = 0
			-- end
	elseif at_mode == 3 then	-- Takeoff mode
			if master_light_block_act == 0 then 
				B738DR_autopilot_master_capt_status = 1
				B738DR_autopilot_master_fo_status = 1
			end
			-- if is_timer_scheduled(master_light_block) == true then
				-- stop_timer(master_light_block)
				-- master_light_block_act = 0
			-- end
	else
		if B738DR_autopilot_fd_pos == 0
		and B738DR_autopilot_fd_fo_pos == 0 then
			B738DR_autopilot_master_capt_status = 0
			B738DR_autopilot_master_fo_status = 0
			if is_timer_scheduled(master_light_block) == true then
				stop_timer(master_light_block)
				master_light_block_act = 0
			end
		else
			if master_light_block_act == 0 then
				-- if B738DR_autopilot_side == 0 then
					-- B738DR_autopilot_master_capt_status = 1
					-- B738DR_autopilot_master_fo_status = 0
				-- elseif B738DR_autopilot_side == 1 then
					-- B738DR_autopilot_master_capt_status = 0
					-- B738DR_autopilot_master_fo_status = 1
				-- end
				if autopilot_side == 0 then
					B738DR_autopilot_master_capt_status = 1
					B738DR_autopilot_master_fo_status = 0
					if B738DR_autoland_status == 0 then
						autopilot_cmd_b_status = 0
					end
				elseif B738DR_autopilot_side == 1 then
					B738DR_autopilot_master_capt_status = 0
					B738DR_autopilot_master_fo_status = 1
					if B738DR_autoland_status == 0 then
						autopilot_cmd_a_status = 0
					end
				end
				B738DR_autopilot_side = autopilot_side
				simDR_autopilot_side = autopilot_side
			end
		end
	end

	local ap_off_auto = 0
	if B738DR_autopilot_master_capt_status == 1
	or B738DR_autopilot_master_fo_status == 1 then
		B738DR_fd_on = 1
	else
		B738DR_fd_on = 0
		ap_off_auto = 1
	end
	if autopilot_cmd_a_status == 1 and B738DR_autopilot_fd_pos == 0 then
		ap_off_auto = 1
	end
	if autopilot_cmd_b_status == 1 and B738DR_autopilot_fd_fo_pos == 0 then
		ap_off_auto = 1
	end
	if ap_off_auto == 1 and simDR_flight_dir_mode > 1 then
		-- turn off A/P
		simCMD_disconnect:once()
		simDR_flight_dir_mode = 1
		-- F/D on
		autopilot_cmd_a_status = 0
		autopilot_cmd_b_status = 0
		B738DR_autoland_status = 0
		B738DR_flare_status = 0
		B738DR_rollout_status = 0
		B738DR_retard_status = 0
		simDR_ap_vvi_dial = 0
		vorloc_only = 0
		ap_pitch_mode = 0
		ap_roll_mode = 0
	elseif ap_off_auto == 1 and B738DR_fd_on == 0 then
		if ap_roll_mode > 0 then
			ap_roll_mode = 0
		end
		if ap_pitch_mode > 0 then
			ap_pitch_mode = 0
			simDR_ap_vvi_dial = 0
			B738DR_retard_status = 0
		end
	elseif B738DR_autopilot_fd_pos == 0 or B738DR_autopilot_fd_fo_pos == 0 then
		if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1 
		or simDR_on_ground_2 == 1 then		-- if aircraft on ground
			if B738DR_autopilot_vnav_status == 1 and vnav_engaged == 0 then
				ap_pitch_mode = 0
			end
		end
	end



	-- PFD >> off-FD-CMD
	local fd_cmd = 0
	local fd_cmd_fo = 0
	if ap_on == 1 then
		fd_cmd = 1
		fd_cmd_fo = 1
	else
		if B738DR_autopilot_fd_pos == 1 then
			fd_cmd = 1
		end
		if B738DR_autopilot_fd_fo_pos == 1 then
			fd_cmd_fo = 1
		end
	end
	B738DR_pfd_fd_cmd = fd_cmd			-- show/hide: FD/CMD on captain PFD
	B738DR_pfd_fd_cmd_fo = fd_cmd_fo	-- show/hide: FD/CMD on first officer PFD


	-- -- VHF NAV SOURCE SWITCHING
	-- if autopilot_fms_nav_status == 0 then
		-- B738DR_pfd_vorloc_lnav = 0
		-- if B738DR_autopilot_vhf_source_pos == -1 then
			-- simDR_autopilot_source = 0
			-- simDR_autopilot_fo_source = 0
		-- elseif B738DR_autopilot_vhf_source_pos == 0 then
		 	-- simDR_autopilot_source = 0
			-- simDR_autopilot_fo_source = 1
		-- elseif B738DR_autopilot_vhf_source_pos == 1 then
		 	-- simDR_autopilot_source = 1
			-- simDR_autopilot_fo_source = 1
		-- end
	-- elseif autopilot_fms_nav_status == 1 then
		-- simDR_autopilot_source = 2
		-- simDR_autopilot_fo_source = 2
-- --		simDR_autopilot_fo_source = 0
		-- B738DR_pfd_vorloc_lnav = 1
	-- end

	-- CMD / CWS
	B738DR_autopilot_cmd_a_status = autopilot_cmd_a_status --* simDR_servos_on
	B738DR_autopilot_cmd_b_status = autopilot_cmd_b_status --* simDR_servos_on
	B738DR_autopilot_cws_a_status = autopilot_cws_a_status * simDR_autopilot_on
	B738DR_autopilot_cws_b_status = autopilot_cws_b_status * simDR_autopilot_on

	simDR_ap_fo_heading = simDR_ap_capt_heading

	-- EFIS mode
	-- if simDR_EFIS_mode == 4 then
		-- simDR_EFIS_WX = 0
		-- --simDR_EFIS_TCAS = 0
		-- B738DR_EFIS_TCAS_on = 0
	-- end
	
	-- ILS test - pointer blink
	if ils_test_on == 0 then
		B738DR_ils_pointer_disable = 0
	else
		B738DR_ils_pointer_disable = blink_out
	end
	
	-- SHOW/HIDE IAS
	--if ap_pitch_mode == 5 and ap_pitch_mode_eng == 5 and vnav_engaged == 1 then
	if vnav_engaged == 1 then
		-- VNAV on
		if B738DR_ap_spd_interv_status == 0 then
			B738DR_show_ias = 0
		else
			B738DR_show_ias = 1
		end
	else
		B738DR_show_ias = 1
	end

end


function B738_lnav2()

	local wca = 0
--	local ws = 0
	local wh = 0
	local tas = 0
	local awa = 0
	local relative_brg = 0
	local relative_brg2 = 0
	local relative_brg3 = 0
	local relative_brg4 = 0
	local bearing_corr = 0
	local idx_corr = 0
	local idx_dist = 0
	local hdg_corr = 0
	local mag_hdg = 0
	local mag_trk = 0	-- temporary without mag variantion
	local ap_hdg = 0
	local rnp = 0
	local fix_bank_angle = 0
	local fac_capture = 0
	local idx_rnp = 0
	local scale_horizont = 0
	local pom1 = 0
	local gnd_spd = 0
	local target_hdg = 0
	
	--local tgt_heading = 0
	--local act_heading = 0

	if ap_roll_mode == 4 and ap_roll_mode_eng == 4 then	-- LNAV
		if lnav_engaged == 0 then
			if simDR_radio_height_pilot_ft > 50 and B738DR_xtrack > -3 and B738DR_xtrack < 3 then
				lnav_engaged = 1
				ap_roll_mode = 4	-- LNAV
				ap_roll_mode_eng = 4
			end
		end
	elseif ap_roll_mode == 10 and ap_roll_mode_eng == 10 then	-- HDG/LNAV arm
		if lnav_engaged == 0 then
			if simDR_radio_height_pilot_ft > 50 and B738DR_xtrack > -3 and B738DR_xtrack < 3 then
				lnav_engaged = 1
				ap_roll_mode = 4	-- LNAV
				ap_roll_mode_eng = 4
			end
		end
	elseif ap_roll_mode == 8 and ap_roll_mode_eng == 8 then		-- LNAV/FAC arm (G/P)
		if fac_engaged == 0 then
			mag_trk = (B738DR_fac_trk + simDR_mag_variation + 360) % 360
			relative_brg = (mag_trk - simDR_ahars_mag_hdg + 360) % 360
			if relative_brg > 180 then
				relative_brg = relative_brg - 360
			end
			if relative_brg > -90 and relative_brg < 90 then
				fac_capture = 1
			end
			-- engage FAC
			if B738DR_pfd_gp_path == 1 and B738DR_fac_xtrack > -2.0 and B738DR_fac_xtrack < 2.0 and fac_capture == 1 then
				fac_engaged = 1
				ap_roll_mode = 11	-- FAC
				ap_roll_mode_eng = 11
			end
			-- if ap_pitch_mode_eng ~= 7 then
				-- B738DR_gp_status = 1	-- G/P armed
			-- end
		end
	elseif ap_roll_mode == 5 and ap_roll_mode_eng == 5 then		-- LNAV/VOR LOC arm
		if simDR_nav_status > 1 then
			ap_roll_mode = 2	-- VOR LOC
			ap_roll_mode_eng = 2
			lnav_engaged = 0
		end
	elseif ap_roll_mode == 6 and ap_roll_mode_eng == 6 then		-- LNAV/APP arm (G/S)
		-- if simDR_approach_status > 1 then
			-- ap_roll_mode = 3	-- APP
			-- ap_roll_mode_eng = 3
			-- lnav_engaged = 0
		-- end
		if simDR_nav_status == 2 and simDR_approach_status == 0 then
			simCMD_autopilot_app:once()
			ap_roll_mode = 3
			ap_roll_mode_eng = 3
			lnav_engaged = 0
		end
		if simDR_approach_status == 2 then
			if ap_pitch_mode_eng ~= 4 and simDR_glideslope_status == 2 then 	-- G/S engaged
				ap_pitch_mode = 4
			end
		end
	elseif ap_roll_mode == 12 and ap_roll_mode_eng == 12 then		-- HDG/VOR LOC arm GP
		if simDR_nav_status > 1 then
			ap_roll_mode = 14	-- LOC GP
			ap_roll_mode_eng = 14
			lnav_engaged = 0
		end
	elseif ap_roll_mode == 13 and ap_roll_mode_eng == 13 then		-- LNAV/VOR LOC arm GP
		if simDR_nav_status > 1 then
			ap_roll_mode = 14	-- LOC GP
			ap_roll_mode_eng = 14
			lnav_engaged = 0
		end
	else
		lnav_engaged = 0
	end
	
	if lnav_engaged == 1 then
		if simDR_autopilot_heading_mode ~= 1 then
			simCMD_autopilot_hdg:once()
		end
		
		
		--if legs_intdir_act == 0 then
		if legs_intdir_act == 0 or B738DR_wpt_path == "DF" or B738DR_wpt_path == "VM" then
			intdir_act = 0
		else
			if intdir_act == 0 then
				intdir_act = 2
				turn_active = 0
			end
		end
		
		if intdir_act == 2 then
			if B738DR_xtrack > -2 and B738DR_xtrack < 2 then
				intdir_act = 1
			end
		
		elseif intdir_act < 2 then
		
			-- heading to track
			mag_trk = simDR_fmc_trk + simDR_mag_variation
			relative_brg = (simDR_fmc_trk - simDR_ahars_mag_hdg + 360) % 360
			if relative_brg > 180 then
				relative_brg = relative_brg - 360
			end
			--B738DR_test_test = relative_brg
			
			relative_brg2 = (simDR_fmc_crs - simDR_ahars_mag_hdg + 360) % 360
			if relative_brg2 > 180 then
				relative_brg2 = relative_brg2 - 360
			end
			
			relative_brg3 = (mag_trk - simDR_ahars_mag_hdg + 360) % 360
			if relative_brg3 > 180 then
				relative_brg3 = relative_brg3 - 360
			end
			
			relative_brg4 = (mag_trk - simDR_mag_hdg + 360) % 360
			if relative_brg4 > 180 then
				relative_brg4 = relative_brg4 - 360
			end
			relative_brg4 = -relative_brg4
			
			if turn_active < 2 then
				if simDR_fmc_trk_turn == 2 then
					-- left turn
					idx_corr = -100
					turn_active = 1
				elseif simDR_fmc_trk_turn == 3 then
					-- right turn
					idx_corr = 100
					turn_active = 1
				end
			end
			
			if simDR_fmc_trk_turn == 0 then
				-- left turn
				idx_corr = -100
				turn_active = 1
			elseif simDR_fmc_trk_turn == 1 then
				-- right turn
				idx_corr = 100
				turn_active = 1
			elseif simDR_fmc_trk_turn == -1 then
				turn_active = 0
			end
			
			if turn_active == 1 then
				ap_hdg = (simDR_ahars_mag_hdg + idx_corr + 360) % 360
				if simDR_fmc_trk_turn < 2 then
					fix_bank_angle = 1
					if B738DR_hold_phase == 6 then
						if simDR_fmc_trk_turn == 1 and relative_brg2 > -90 and relative_brg2 < -45 then
							turn_active = 2
							B738DR_hold_phase = 7
						end
						if simDR_fmc_trk_turn == 0 and relative_brg2 < 90 and relative_brg2 > 45 then
							turn_active = 2
							B738DR_hold_phase = 7
						end
						simDR_bank_angle = 6
					else
						if simDR_fmc_trk_turn == 0 and relative_brg2 > -45 and relative_brg2 < 0 then
							turn_active = 2
							if B738DR_hold_phase == 1 then
								B738DR_hold_phase = 2
							elseif B738DR_hold_phase == 3 then
								B738DR_hold_phase = 0
							end
						end
						if simDR_fmc_trk_turn == 1 and relative_brg < 45 and relative_brg > 0 then
							turn_active = 2
							if B738DR_hold_phase == 1 then
								B738DR_hold_phase = 2
							elseif B738DR_hold_phase == 3 then
								B738DR_hold_phase = 0
							end
						end
						simDR_bank_angle = 5
					end
				else
					if simDR_fmc_trk_turn == 2 and relative_brg2 > -80 and relative_brg2 < 0 then
						turn_active = 2
						idx_corr = -45
					end
					if simDR_fmc_trk_turn == 3 and relative_brg2 < 80 and relative_brg2 > 0 then
						turn_active = 2
						idx_corr = 45
					end
					simDR_bank_angle = 6
				end
			else
				if B738DR_wpt_path == "DF" then
					-- Direct To Fix
					ap_hdg = simDR_fmc_crs
				elseif B738DR_wpt_path == "HA" or B738DR_wpt_path == "HF" or B738DR_wpt_path == "HM" then
					-- Hold
					if B738DR_hold_phase == 0 then
						ap_hdg = simDR_fmc_crs
					else
						ap_hdg = simDR_fmc_trk
					end
					simDR_bank_angle = 5
					fix_bank_angle = 1
				elseif B738DR_wpt_path == "VM" then
					ap_hdg = simDR_fmc_trk
				elseif B738DR_wpt_path == "AF" or B738DR_wpt_path == "RF" then
					gnd_spd = math.min(simDR_ground_spd, 236)
					gnd_spd = math.max(gnd_spd, 71)
					if simDR_fmc_trk_turn == -1 then
						if simDR_fmc_trk_turn2 == 2 then
							-- left
							idx_dist = B738DR_xtrack + B738_rescale(71, 0.40, 236, 0.47, gnd_spd)	--0.27 / 0.33 ** 0.33 / 0.39 ** 0.39/0.45
						else
							-- right
							idx_dist = B738DR_xtrack - B738_rescale(71, 0.40, 236, 0.47, gnd_spd)
						end
					elseif simDR_fmc_trk_turn == 2 then
						-- left
						idx_dist = B738DR_xtrack + B738_rescale(71, 0.40, 236, 0.47, gnd_spd)
					else
						-- right
						idx_dist = B738DR_xtrack - B738_rescale(71, 0.40, 236, 0.47, gnd_spd)
					end
					if idx_dist < 0 then
						if relative_brg > 15 and idx_dist < -1 then
							idx_corr = 45
						else
							idx_dist = -idx_dist
							if idx_dist > 1 then
								idx_dist = 1
							end
							idx_corr = B738_rescale(0, 0, 1, 45, idx_dist)
						end
					else
						if relative_brg < -15 and idx_dist > 1 then
							idx_corr = -45
						else
							if idx_dist > 1 then
								idx_dist = 1
							end
							idx_corr = -B738_rescale(0, 0, 1, 45, idx_dist)
						end
					end
					ap_hdg = (mag_trk + idx_corr + 360) % 360
				elseif nav_mode == 5 then
					-- radii turn
					gnd_spd = math.min(simDR_ground_spd, 236)
					gnd_spd = math.max(gnd_spd, 71)
					if simDR_fmc_trk_turn2 == 2 then
						-- left
						idx_dist = B738DR_xtrack + B738_rescale(71, 0.40, 236, 0.47, gnd_spd)
					else
						-- right
						idx_dist = B738DR_xtrack - B738_rescale(71, 0.40, 236, 0.47, gnd_spd)
					end
					if idx_dist < 0 then
						if relative_brg > 15 and idx_dist < -1 then
							idx_corr = 45
						else
							idx_dist = -idx_dist
							if idx_dist > 1 then
								idx_dist = 1
							end
							idx_corr = B738_rescale(0, 0, 1, 45, idx_dist)
						end
					else
						if relative_brg < -15 and idx_dist > 1 then
							idx_corr = -45
						else
							if idx_dist > 1 then
								idx_dist = 1
							end
							idx_corr = -B738_rescale(0, 0, 1, 45, idx_dist)
						end
					end
					ap_hdg = (mag_trk + idx_corr + 360) % 360
				else
					gnd_spd = math.min(simDR_ground_spd, 230)
					gnd_spd = math.max(gnd_spd, 70)
					idx_rnp = B738_rescale(70, 1.5, 230, 3.2, gnd_spd)
					if B738DR_xtrack < 0 then
						if relative_brg > 15 and idx_dist < -1 then
							idx_corr = 45
						else
							idx_dist = -B738DR_xtrack
							if idx_dist > idx_rnp then
								idx_dist = idx_rnp
							end
							idx_corr = B738_rescale(0, 0, idx_rnp, 45, idx_dist)
						end
					else
						if relative_brg < -15 and idx_dist > 1 then
							idx_corr = -45
						else
							idx_dist = B738DR_xtrack
							if idx_dist > idx_rnp then
								idx_dist = idx_rnp
							end
							idx_corr = -B738_rescale(0, 0, idx_rnp, 45, idx_dist)
						end
					end
					ap_hdg = (mag_trk + idx_corr + 360) % 360
				end
				--bank angle
				--if B738DR_fms_vref ~= 0 and simDR_airspeed_pilot < (B738DR_fms_vref - 3) and simDR_airspeed_pilot > 45 then
				if B738DR_fms_vref ~= 0 and AP_airspeed < (B738DR_fms_vref - 3) and AP_airspeed > 45 then
					simDR_bank_angle = 3	-- bank angle protection below Vref speed
				else
					if fix_bank_angle == 0 then
						simDR_bank_angle = B738DR_fmc_bank_angle
					end
				end
			end
			
			--B738DR_gps_horizont = idx_corr
			
			idx_corr = B738DR_xtrack
			if B738DR_radii_turn_act == 1 then
				if idx_corr < 0 then
					idx_corr = idx_corr + B738DR_radii_correct
				else
					idx_corr = idx_corr - B738DR_radii_correct
				end
			end
			if idx_corr < 0 then
				idx_corr = -idx_corr
				if idx_corr > B738DR_rnp then
					idx_corr = B738DR_rnp
				end
				scale_horizont = -B738_rescale(0, 0, B738DR_rnp, 2.5, idx_corr)
			else
				if idx_corr > B738DR_rnp then
					idx_corr = B738DR_rnp
				end
				scale_horizont = B738_rescale(0, 0, B738DR_rnp, 2.5, idx_corr)
			end
			B738DR_gps_horizont = scale_horizont
			
			-- if B738DR_xtrack < -2.5 then
				-- B738DR_gps_horizont = -2.5
			-- elseif B738DR_xtrack > 2.5 then
				-- B738DR_gps_horizont = 2.5
			-- else
				-- B738DR_gps_horizont = B738DR_xtrack
			-- end
			
			-- wind correction
			mag_hdg = simDR_ahars_mag_hdg --- simDR_mag_variation
			tas = simDR_ground_spd * 1.94384449244	-- m/s to knots
			wh = (simDR_wind_hdg + 180) % 360
			relative_brg = (wh - mag_hdg + 360) % 360
			if relative_brg > 180 then
				relative_brg = relative_brg - 360
			end
			if relative_brg < -90 then
				awa = math.rad(180 + relative_brg)
				wca = math.asin(simDR_wind_spd * ((math.sin(awa) / tas)))
				wca = math.deg(-wca)
			elseif relative_brg < 0 then
				awa = math.rad(-relative_brg)
				wca = math.asin(simDR_wind_spd * ((math.sin(awa) / tas)))
				wca = math.deg(-wca)
			elseif relative_brg < 90 then
				awa = math.rad(relative_brg)
				wca = math.asin(simDR_wind_spd * ((math.sin(awa) / tas)))
				wca = math.deg(wca)
			else
				awa = math.rad(180 - relative_brg)
				wca = math.asin(simDR_wind_spd * ((math.sin(awa) / tas)))
				wca = math.deg(wca)
			end
			
			ap_wca = B738_set_anim_value(ap_wca, wca, -360, 360, 1)
			
			simDR_ap_capt_heading = (ap_hdg - ap_wca) % 360
		end
		
	else
		simDR_ap_capt_heading = B738DR_mcp_hdg_dial
	end
	
end

function B738_bank_angle()
	
	if B738DR_heading_mode < 4 or B738DR_heading_mode > 6 then	-- LNAV mode
		if B738DR_autopilot_bank_angle_pos == 4 then
			simDR_bank_angle = 6
		elseif B738DR_autopilot_bank_angle_pos == 3 then
			simDR_bank_angle = 5
		elseif B738DR_autopilot_bank_angle_pos == 2 then
			simDR_bank_angle = 4
		elseif B738DR_autopilot_bank_angle_pos == 1 then
			simDR_bank_angle = 3
		elseif B738DR_autopilot_bank_angle_pos == 0 then
			simDR_bank_angle = 2
		end
	end

end

function B738_lnav3()

	local wca = 0
--	local ws = 0
	local wh = 0
	local tas = 0
	local awa = 0
	local relative_brg = 0
	local relative_brg2 = 0
	local relative_brg3 = 0
	local relative_brg4 = 0
	local bearing_corr = 0
	local idx_corr = 0
	local idx_dist = 0
	local hdg_corr = 0
	local mag_hdg = 0
	local mag_trk = 0	-- temporary without mag variantion
	local ap_hdg = 0
	local rnp = 0
	local fix_bank_angle = 0
	local fac_capture = 0
	local idx_rnp = 0
	local scale_horizont = 0
	local pom1 = 0
	local gnd_spd = 0
	local target_hdg = 0
	local max_idx_dist = 0
	
	--local tgt_heading = 0
	--local act_heading = 0

	if ap_roll_mode == 4 and ap_roll_mode_eng == 4 then	-- LNAV
		if lnav_engaged == 0 then
			if simDR_radio_height_pilot_ft > 50 and B738DR_xtrack > -3 and B738DR_xtrack < 3 then
				lnav_engaged = 1
				ap_roll_mode = 4	-- LNAV
				ap_roll_mode_eng = 4
			end
		end
	elseif ap_roll_mode == 10 and ap_roll_mode_eng == 10 then	-- HDG/LNAV arm
		if lnav_engaged == 0 then
			if simDR_radio_height_pilot_ft > 50 and B738DR_xtrack > -3 and B738DR_xtrack < 3 then
				lnav_engaged = 1
				ap_roll_mode = 4	-- LNAV
				ap_roll_mode_eng = 4
			end
		end
	elseif ap_roll_mode == 8 and ap_roll_mode_eng == 8 then		-- LNAV/FAC arm (G/P)
		if fac_engaged == 0 then
			mag_trk = (B738DR_fac_trk + simDR_mag_variation + 360) % 360
			relative_brg = (mag_trk - simDR_ahars_mag_hdg + 360) % 360
			if relative_brg > 180 then
				relative_brg = relative_brg - 360
			end
			if relative_brg > -90 and relative_brg < 90 then
				fac_capture = 1
			end
			-- engage FAC
			if B738DR_pfd_gp_path == 1 and B738DR_fac_xtrack > -2.0 and B738DR_fac_xtrack < 2.0 and fac_capture == 1 then
				fac_engaged = 1
				ap_roll_mode = 11	-- FAC
				ap_roll_mode_eng = 11
			end
			-- if ap_pitch_mode_eng ~= 7 then
				-- B738DR_gp_status = 1	-- G/P armed
			-- end
		end
	elseif ap_roll_mode == 5 and ap_roll_mode_eng == 5 then		-- LNAV/VOR LOC arm
		if simDR_nav_status > 1 then
			ap_roll_mode = 2	-- VOR LOC
			ap_roll_mode_eng = 2
			lnav_engaged = 0
		end
	elseif ap_roll_mode == 6 and ap_roll_mode_eng == 6 then		-- LNAV/APP arm (G/S)
		-- if simDR_approach_status > 1 then
			-- ap_roll_mode = 3	-- APP
			-- ap_roll_mode_eng = 3
			-- lnav_engaged = 0
		-- end
		if simDR_nav_status == 2 and simDR_approach_status == 0 then
			simCMD_autopilot_app:once()
			ap_roll_mode = 3
			ap_roll_mode_eng = 3
			lnav_engaged = 0
		end
		if simDR_approach_status == 2 then
			if ap_pitch_mode_eng ~= 4 and simDR_glideslope_status == 2 then 	-- G/S engaged
				ap_pitch_mode = 4
			end
		end
	elseif ap_roll_mode == 12 and ap_roll_mode_eng == 12 then		-- HDG/VOR LOC arm GP
		if simDR_nav_status > 1 then
			ap_roll_mode = 14	-- LOC GP
			ap_roll_mode_eng = 14
			lnav_engaged = 0
		end
	elseif ap_roll_mode == 13 and ap_roll_mode_eng == 13 then		-- LNAV/VOR LOC arm GP
		if simDR_nav_status > 1 then
			ap_roll_mode = 14	-- LOC GP
			ap_roll_mode_eng = 14
			lnav_engaged = 0
		end
	else
		lnav_engaged = 0
	end
	
	if lnav_engaged == 1 then
		if simDR_autopilot_heading_mode ~= 1 then
			simCMD_autopilot_hdg:once()
		end
		
		
		--if legs_intdir_act == 0 then
		if legs_intdir_act == 0 or B738DR_wpt_path == "DF" or B738DR_wpt_path == "VM" then
			intdir_act = 0
		else
			if intdir_act == 0 then
				intdir_act = 2
				turn_active = 0
			end
		end
		
		if intdir_act == 2 then
			if B738DR_xtrack > -2 and B738DR_xtrack < 2 then
				intdir_act = 1
			end
		
		elseif intdir_act < 2 then
		
			-- heading to track
			mag_trk = simDR_fmc_trk + simDR_mag_variation
			relative_brg = (simDR_fmc_trk - simDR_ahars_mag_hdg + 360) % 360
			if relative_brg > 180 then
				relative_brg = relative_brg - 360
			end
			--B738DR_test_test = relative_brg
			
			relative_brg2 = (simDR_fmc_crs - simDR_ahars_mag_hdg + 360) % 360
			if relative_brg2 > 180 then
				relative_brg2 = relative_brg2 - 360
			end
			
			relative_brg3 = (mag_trk - simDR_ahars_mag_hdg + 360) % 360
			if relative_brg3 > 180 then
				relative_brg3 = relative_brg3 - 360
			end
			
			relative_brg4 = (mag_trk - simDR_mag_hdg + 360) % 360
			if relative_brg4 > 180 then
				relative_brg4 = relative_brg4 - 360
			end
			relative_brg4 = -relative_brg4
			
			if turn_active < 2 then
				if simDR_fmc_trk_turn == 2 then
					-- left turn
					idx_corr = -100
					turn_active = 1
				elseif simDR_fmc_trk_turn == 3 then
					-- right turn
					idx_corr = 100
					turn_active = 1
				end
			end
			
			if simDR_fmc_trk_turn == 0 then
				-- left turn
				idx_corr = -100
				turn_active = 1
			elseif simDR_fmc_trk_turn == 1 then
				-- right turn
				idx_corr = 100
				turn_active = 1
			elseif simDR_fmc_trk_turn == -1 then
				turn_active = 0
			end
			
			if turn_active == 1 then
				ap_hdg = (simDR_ahars_mag_hdg + idx_corr + 360) % 360
				if simDR_fmc_trk_turn < 2 then
					fix_bank_angle = 1
					if B738DR_hold_phase == 6 then
						if simDR_fmc_trk_turn == 1 and relative_brg2 > -90 and relative_brg2 < -45 then
							turn_active = 2
							B738DR_hold_phase = 7
						end
						if simDR_fmc_trk_turn == 0 and relative_brg2 < 90 and relative_brg2 > 45 then
							turn_active = 2
							B738DR_hold_phase = 7
						end
						simDR_bank_angle = 6
					else
						if simDR_fmc_trk_turn == 0 and relative_brg2 > -45 and relative_brg2 < 0 then
							turn_active = 2
							if B738DR_hold_phase == 1 then
								B738DR_hold_phase = 2
							elseif B738DR_hold_phase == 3 then
								B738DR_hold_phase = 0
							end
						end
						if simDR_fmc_trk_turn == 1 and relative_brg < 45 and relative_brg > 0 then
							turn_active = 2
							if B738DR_hold_phase == 1 then
								B738DR_hold_phase = 2
							elseif B738DR_hold_phase == 3 then
								B738DR_hold_phase = 0
							end
						end
						simDR_bank_angle = 5
					end
				else
					if simDR_fmc_trk_turn == 2 and relative_brg2 > -80 and relative_brg2 < 0 then
						turn_active = 2
						idx_corr = -45
					end
					if simDR_fmc_trk_turn == 3 and relative_brg2 < 80 and relative_brg2 > 0 then
						turn_active = 2
						idx_corr = 45
					end
					simDR_bank_angle = 6
				end
			else
				if B738DR_wpt_path == "DF" then
					-- Direct To Fix
					ap_hdg = simDR_fmc_crs
				elseif B738DR_wpt_path == "HA" or B738DR_wpt_path == "HF" or B738DR_wpt_path == "HM" then
					-- Hold
					if B738DR_hold_phase == 0 then
						ap_hdg = simDR_fmc_crs
					else
						ap_hdg = simDR_fmc_trk
					end
					simDR_bank_angle = 5
					fix_bank_angle = 1
				elseif B738DR_wpt_path == "VM" then
					ap_hdg = (simDR_fmc_trk + simDR_mag_variation + 360) % 360
				elseif B738DR_wpt_path == "AF" or B738DR_wpt_path == "RF" then
					gnd_spd = math.min(simDR_ground_spd, 236)
					gnd_spd = math.max(gnd_spd, 71)
					if simDR_fmc_trk_turn == -1 then
						if simDR_fmc_trk_turn2 == 2 then
							-- left
							idx_dist = B738DR_xtrack + B738_rescale(71, 0.40, 236, 0.47, gnd_spd)	--0.27 / 0.33 ** 0.33 / 0.39 ** 0.39/0.45
						else
							-- right
							idx_dist = B738DR_xtrack - B738_rescale(71, 0.40, 236, 0.47, gnd_spd)
						end
					elseif simDR_fmc_trk_turn == 2 then
						-- left
						idx_dist = B738DR_xtrack + B738_rescale(71, 0.40, 236, 0.47, gnd_spd)
					else
						-- right
						idx_dist = B738DR_xtrack - B738_rescale(71, 0.40, 236, 0.47, gnd_spd)
					end
					
					
					if idx_dist < 0 then
						idx_dist = -idx_dist
						if idx_dist > 1 then
							idx_dist = 1
						end
						idx_corr = B738_rescale(0, 0, 1, 45, idx_dist)
					else
						if idx_dist > 1 then
							idx_dist = 1
						end
						idx_corr = -B738_rescale(0, 0, 1, 45, idx_dist)
					end
					ap_hdg = (simDR_fmc_trk2 + idx_corr + 360) % 360
					
					
					-- if idx_dist < 0 then
						-- if relative_brg > 15 and idx_dist < -1 then
							-- idx_corr = 45
						-- else
							-- idx_dist = -idx_dist
							-- if idx_dist > 1 then
								-- idx_dist = 1
							-- end
							-- idx_corr = B738_rescale(0, 0, 1, 45, idx_dist)
						-- end
					-- else
						-- if relative_brg < -15 and idx_dist > 1 then
							-- idx_corr = -45
						-- else
							-- if idx_dist > 1 then
								-- idx_dist = 1
							-- end
							-- idx_corr = -B738_rescale(0, 0, 1, 45, idx_dist)
						-- end
					-- end
					-- ap_hdg = (mag_trk + idx_corr + 360) % 360
				elseif nav_mode == 5 then
					-- radii turn
					gnd_spd = math.min(simDR_ground_spd, 236)
					gnd_spd = math.max(gnd_spd, 71)
					if simDR_fmc_trk_turn2 == 2 then
						-- left
						idx_dist = B738DR_xtrack + B738_rescale(71, 0.40, 236, 0.47, gnd_spd)
					else
						-- right
						idx_dist = B738DR_xtrack - B738_rescale(71, 0.40, 236, 0.47, gnd_spd)
					end
					
					max_idx_dist = B738_rescale(71, 1, 236, 2, gnd_spd)
					if idx_dist < 0 then
						idx_dist = -idx_dist
						if idx_dist > max_idx_dist then
							idx_dist = max_idx_dist
						end
						idx_corr = B738_rescale(0, 0, max_idx_dist, 45, idx_dist)
					else
						if idx_dist > max_idx_dist then
							idx_dist = max_idx_dist
						end
						idx_corr = -B738_rescale(0, 0, max_idx_dist, 45, idx_dist)
					end
					ap_hdg = (simDR_fmc_trk2 + idx_corr + 360) % 360
					
					
					-- if idx_dist < 0 then
						-- if relative_brg > 15 and idx_dist < -1 then
							-- idx_corr = 45
						-- else
							-- idx_dist = -idx_dist
							-- if idx_dist > 1 then
								-- idx_dist = 1
							-- end
							-- idx_corr = B738_rescale(0, 0, 1, 45, idx_dist)
						-- end
					-- else
						-- if relative_brg < -15 and idx_dist > 1 then
							-- idx_corr = -45
						-- else
							-- if idx_dist > 1 then
								-- idx_dist = 1
							-- end
							-- idx_corr = -B738_rescale(0, 0, 1, 45, idx_dist)
						-- end
					-- end
					-- ap_hdg = (mag_trk + idx_corr + 360) % 360
				else
					-----
					gnd_spd = math.min(simDR_ground_spd, 236)
					gnd_spd = math.max(gnd_spd, 71)
					-- idx_rnp = B738_rescale(70, 1.5, 230, 3.2, gnd_spd)
					
					max_idx_dist = B738_rescale(71, 1, 236, 2, gnd_spd)
					if B738DR_xtrack < 0 then
						idx_dist = -B738DR_xtrack
						-- if idx_dist > idx_rnp then
							-- idx_dist = idx_rnp
						-- end
						--idx_corr = B738_rescale(0, 0, idx_rnp, 45, idx_dist)
						idx_dist = idx_dist * idx_dist * 1.85
						if idx_dist > max_idx_dist then
							idx_dist = max_idx_dist
						end
						--idx_dist = idx_dist * idx_dist
						idx_corr = B738_rescale(0, 0, max_idx_dist, 35, idx_dist)
					else
						idx_dist = B738DR_xtrack
						-- if idx_dist > idx_rnp then
							-- idx_dist = idx_rnp
						-- end
						--idx_corr = -B738_rescale(0, 0, idx_rnp, 45, idx_dist)
						
						idx_dist = idx_dist * idx_dist * 1.85
						if idx_dist > max_idx_dist then
							idx_dist = max_idx_dist
						end
						--idx_dist = idx_dist * idx_dist
						idx_corr = -B738_rescale(0, 0, max_idx_dist, 35, idx_dist)
					end
					ap_hdg = (simDR_fmc_trk + simDR_mag_variation + idx_corr + 360) % 360
					--B738DR_test_test = idx_corr
					------
					-- if B738DR_xtrack < 0 then
						-- if relative_brg > 15 and idx_dist < -1 then
							-- idx_corr = 45
						-- else
							-- idx_dist = -B738DR_xtrack
							-- if idx_dist > idx_rnp then
								-- idx_dist = idx_rnp
							-- end
							-- idx_corr = B738_rescale(0, 0, idx_rnp, 45, idx_dist)
						-- end
					-- else
						-- if relative_brg < -15 and idx_dist > 1 then
							-- idx_corr = -45
						-- else
							-- idx_dist = B738DR_xtrack
							-- if idx_dist > idx_rnp then
								-- idx_dist = idx_rnp
							-- end
							-- idx_corr = -B738_rescale(0, 0, idx_rnp, 45, idx_dist)
						-- end
					-- end
					-- ap_hdg = (mag_trk + idx_corr + 360) % 360
				end
				--bank angle
				--if B738DR_fms_vref ~= 0 and simDR_airspeed_pilot < (B738DR_fms_vref - 3) and simDR_airspeed_pilot > 45 then
				if B738DR_fms_vref ~= 0 and AP_airspeed < (B738DR_fms_vref - 3) and AP_airspeed > 45 then
					simDR_bank_angle = 3	-- bank angle protection below Vref speed
				else
					if fix_bank_angle == 0 then
						simDR_bank_angle = B738DR_fmc_bank_angle
					end
				end
			end
			
			--B738DR_gps_horizont = idx_corr
			
			idx_corr = B738DR_xtrack
			if B738DR_radii_turn_act == 1 then
				if idx_corr < 0 then
					idx_corr = idx_corr + B738DR_radii_correct
				else
					idx_corr = idx_corr - B738DR_radii_correct
				end
			end
			if idx_corr < 0 then
				idx_corr = -idx_corr
				if idx_corr > B738DR_rnp then
					idx_corr = B738DR_rnp
				end
				scale_horizont = -B738_rescale(0, 0, B738DR_rnp, 2.5, idx_corr)
			else
				if idx_corr > B738DR_rnp then
					idx_corr = B738DR_rnp
				end
				scale_horizont = B738_rescale(0, 0, B738DR_rnp, 2.5, idx_corr)
			end
			B738DR_gps_horizont = scale_horizont
			
			-- if B738DR_xtrack < -2.5 then
				-- B738DR_gps_horizont = -2.5
			-- elseif B738DR_xtrack > 2.5 then
				-- B738DR_gps_horizont = 2.5
			-- else
				-- B738DR_gps_horizont = B738DR_xtrack
			-- end
			
			-- wind correction
			mag_hdg = simDR_ahars_mag_hdg --- simDR_mag_variation
			tas = simDR_ground_spd * 1.94384449244	-- m/s to knots
			wh = (simDR_wind_hdg + 180) % 360
			relative_brg = (wh - mag_hdg + 360) % 360
			if relative_brg > 180 then
				relative_brg = relative_brg - 360
			end
			if relative_brg < -90 then
				awa = math.rad(180 + relative_brg)
				wca = math.asin(simDR_wind_spd * ((math.sin(awa) / tas)))
				wca = math.deg(-wca)
			elseif relative_brg < 0 then
				awa = math.rad(-relative_brg)
				wca = math.asin(simDR_wind_spd * ((math.sin(awa) / tas)))
				wca = math.deg(-wca)
			elseif relative_brg < 90 then
				awa = math.rad(relative_brg)
				wca = math.asin(simDR_wind_spd * ((math.sin(awa) / tas)))
				wca = math.deg(wca)
			else
				awa = math.rad(180 - relative_brg)
				wca = math.asin(simDR_wind_spd * ((math.sin(awa) / tas)))
				wca = math.deg(wca)
			end
			
			ap_wca = B738_set_anim_value(ap_wca, wca, -360, 360, 1)
			
			simDR_ap_capt_heading = (ap_hdg - ap_wca) % 360
		end
		
	else
		simDR_ap_capt_heading = B738DR_mcp_hdg_dial
	end
	
end


-- function B738_gs()
	-- if ap_roll_mode_eng == 3 and ap_pitch_mode_eng ~= 4 then	-- APP
		-- if simDR_glideslope_status == 2 then --and ap_pitch_mode_eng ~= 4 then	-- if G/S engaged
			-- ap_pitch_mode = 4
			-- --ap_pitch_mode_eng = 4
		-- end
	-- end
-- end

--- VNAV autopilot ---

function B738_vnav6()

	local delta_vvi = 0
	local delta_alt_dial = 0
	local vnav_speed_delta2 = 0
	local speed_step = 0
	
	local flaps = simDR_flaps_ratio
	local v2_20_speed = B738DR_fms_v2_15
	local v2 = 0
	local vvi_act = simDR_vvi_fpm_pilot
	local cca_alt = 0.0
	local nav_id = "*"
	local alt_x = 0
	local spd_250_10000 = 0
	
	local at_mode_old = 0
	local lvl_chg_fpm = 0
	local lvl_chg_alt = 0
	local vnav_alt2 = 0
	local delta_alt_dial2 = 0
	
	--local hold_for_vpath = 0
	
	if ap_pitch_mode_eng == 5 and ap_pitch_mode == 5 and B738DR_autopilot_vnav_status == 1 then --ap_vnav_status == 2 then
		
		if ap_on == 0 then
			if B738DR_flight_phase < 2 then
				if simDR_radio_height_pilot_ft > 400 or B738DR_missed_app_act > 0 then
					vnav_engaged = 1
				else
					vnav_engaged = 0
				end
			else
				vnav_engaged = 1
			end
			-- if simDR_radio_height_pilot_ft > 400 and (B738DR_flight_phase < 2 or B738DR_missed_app_act == 1) then
				-- vnav_engaged = 1
			-- end
		else
			vnav_engaged = 1
		end
		
		--if ap_on == 1 or vnav_engaged == 1 then
		if vnav_engaged == 1 then
			
			if vnav_init == 0 then
				vnav_init2 = 0
				B738DR_vvi_dial_show = 0
				B738DR_autopilot_vvi_status_pfd = 0		-- no V/S arm
				rest_wpt_alt_old = 0
				
				if vnav_alt_mode == 0 then
					-- climb
					if B738DR_flight_phase < 2 or B738DR_missed_app_act > 0 then
						vnav_alt_hld = 0
						vnav_vs = 0
						delta_alt_dial = B738DR_mcp_alt_dial - simDR_altitude_pilot
						if delta_alt_dial > 500 then
							if B738DR_autopilot_autothr_arm_pos == 1 then
								at_mode = 7
							else
								alt_x = at_mode
							end
							if simDR_autopilot_altitude_mode ~= 5 then
								simCMD_autopilot_lvl_chg:once()
								if B738DR_autopilot_autothr_arm_pos == 0 then
									at_mode = alt_x
								end
							end
						else
							--ap_pitch_mode = 3
							vnav_alt_mode = 1
							vnav_alt_hld = 1
							--simCMD_autopilot_alt_hold:once()
						end
						
					-- cruise
					elseif B738DR_flight_phase == 2 then
						if B738DR_autopilot_autothr_arm_pos == 1 then
							at_mode = 9
						else
							alt_x = at_mode
						end
						if simDR_autopilot_altitude_mode ~= 6 then
							simCMD_autopilot_alt_hold:once()
							if B738DR_autopilot_autothr_arm_pos == 0 then
								at_mode = alt_x
							end
						end
					
					------------------------- NEW ---------------------
					-- cruise climb
					elseif B738DR_flight_phase == 3 then
						if B738DR_autopilot_autothr_arm_pos == 1 then
							at_mode = 9
						else
							alt_x = at_mode
						end
						if simDR_autopilot_altitude_mode ~= 6 then
							simCMD_autopilot_alt_hold:once()
							if B738DR_autopilot_autothr_arm_pos == 0 then
								at_mode = alt_x
							end
						end
						B738DR_flight_phase = 2
						--B738DR_changed_flight_phase = 2
					
					-- cruise descent
					elseif B738DR_flight_phase == 4 then
						if B738DR_autopilot_autothr_arm_pos == 1 then
							at_mode = 9
						else
							alt_x = at_mode
						end
						if simDR_autopilot_altitude_mode ~= 6 then
							simCMD_autopilot_alt_hold:once()
							if B738DR_autopilot_autothr_arm_pos == 0 then
								at_mode = alt_x
							end
						end
						B738DR_flight_phase = 2
						--B738DR_changed_flight_phase = 2
					------------------------- NEW ---------------------
					
					-- descent
					else
						delta_alt_dial = simDR_altitude_pilot - B738DR_mcp_alt_dial
						if delta_alt_dial > 500 then
							if B738DR_autopilot_autothr_arm_pos == 1 then
								at_mode = 2
							else
								alt_x = at_mode
							end
							if B738DR_vnav_err_pfd > 400 then
								vnav_alt_hold_act = 1
								if simDR_autopilot_altitude_mode ~= 6 then
									simCMD_autopilot_alt_hold:once()
								end
							else
								if simDR_autopilot_altitude_mode ~= 4 then
									simDR_ap_vvi_dial = B738DR_vnav_vvi
									simCMD_autopilot_vs_sel:once()
									if B738DR_autopilot_autothr_arm_pos == 0 then
										at_mode = alt_x
									end
								end
							end
						else
							--ap_pitch_mode = 3
							vnav_alt_mode = 1
							simCMD_autopilot_alt_hold:once()
						end
					end
					if at_mode == 3 then
						at_mode = 0
					end
				end
			end
			vnav_init = 1
			
			-- Restrict 250 kts / 10000 ft
			if B738DR_flight_phase < 5 then
				if B738DR_fmc_climb_r_speed1 == 0 then
						spd_250_10000 = 340
				else
					if B738DR_alt_hold_mem == 0 then
						if simDR_altitude_pilot < B738DR_fmc_climb_r_alt1 then
							spd_250_10000 = B738DR_fmc_climb_r_speed1
						else
							spd_250_10000 = 340
						end
					else
						if B738DR_alt_hold_mem <= B738DR_fmc_climb_r_alt1 then
							spd_250_10000 = B738DR_fmc_climb_r_speed1
						else
							spd_250_10000 = 340
						end
					end
				end
			elseif B738DR_flight_phase > 4 then
				if B738DR_fmc_descent_r_speed1 == 0 then
					spd_250_10000 = 340
				else
					if B738DR_alt_hold_mem == 0 then
						if B738DR_rest_wpt_alt < B738DR_fmc_descent_r_alt1 then 
							if simDR_altitude_pilot < (B738DR_fmc_descent_r_alt1 + 900) then
								spd_250_10000 = B738DR_fmc_descent_r_speed1 --- 10
							else
								spd_250_10000 = 340
							end
						else
							spd_250_10000 = 340
						end
					else
						if B738DR_alt_hold_mem <= B738DR_fmc_descent_r_alt1 then
							spd_250_10000 = B738DR_fmc_climb_r_speed1
						else
							spd_250_10000 = 340
						end
					end
				end
			end
			
			-- PHASE CLIMB
			if B738DR_flight_phase < 2 or B738DR_missed_app_act > 0 then --or B738DR_flight_phase > 6 then
				
				-- crossover altitude
				if simDR_mach_no >= B738DR_fmc_climb_speed_mach then
					if simDR_airspeed_is_mach == 0 then
						simCMD_autopilot_co:once()
					end
				end
				
				-- flaps limit speeds
				if flaps == 0 then
					flaps_speed = 340
				elseif flaps <= 0.25 then		-- flaps 1,2
					flaps_speed = 230
				elseif flaps <= 0.375 then		-- flaps 5
					flaps_speed = 230
				elseif flaps <= 0.5 then		-- flaps 10
					flaps_speed = 205
				elseif flaps <= 0.625 then		-- flaps 15
					flaps_speed = 195
				elseif flaps <= 0.75 then		-- flaps 25
					flaps_speed = 185
				else
					flaps_speed = 160
				end
				if flaps_speed == 0 then
					if flaps == 0 then
						flaps_speed = 340
					else
						flaps_speed = 230
					end
				end
				-- V2+20 limit speeds
				if v2_20_speed == 0 then
					v2_20_speed = 180
				end
				-- if simDR_radio_height_pilot_ft < B738DR_accel_alt then
					-- if B738DR_eng_out == 1 then
						-- v2 = v2_20_speed - 20
						-- if simDR_airspeed_pilot >= v2 and simDR_airspeed_pilot <= v2_20_speed then
							-- v2_20_speed = simDR_airspeed_pilot
						-- elseif simDR_airspeed_pilot < v2 then
							-- v2_20_speed = v2
						-- end
						-- -- v2 = v2_20_speed - 20
						-- -- if simDR_airspeed_pilot < v2 or simDR_airspeed_pilot > v2_20_speed then
							-- -- v2_20_speed = v2_20_speed + 5
						-- -- else
							-- -- v2_20_speed = simDR_airspeed_pilot
						-- -- end
					-- end
				-- else
					-- v2_20_speed = 340
					-- if B738DR_eng_out == 1 then
						-- if simDR_radio_height_pilot_ft < B738DR_thr_red_alt then
							-- v2 = v2_20_speed - 20
							-- if simDR_airspeed_pilot >= v2 and simDR_airspeed_pilot <= v2_20_speed then
								-- v2_20_speed = simDR_airspeed_pilot
							-- elseif simDR_airspeed_pilot < v2 then
								-- v2_20_speed = v2
							-- end
						-- end
					-- end
				-- end
				if simDR_radio_height_pilot_ft > B738DR_accel_alt then
					v2_20_speed = 340
				end
				if B738DR_eng_out == 1 then
					v2 = v2_20_speed - 20
					if AP_airspeed >= v2 and AP_airspeed <= v2_20_speed then
						v2_20_speed = AP_airspeed
					elseif AP_airspeed < v2 then
						v2_20_speed = v2
					end
				end
				if v2_20_speed < 340 then
					if flaps_speed < v2_20_speed then
						flaps_speed = v2_20_speed
					end
				end
				
				-- limited VNAV speed
				vnav_speed = B738DR_rest_wpt_spd
				if vnav_speed == 0 then
					vnav_speed = 340
				end
				
				-- B738DR_fmc_climb_speed_l = math.min (flaps_speed, v2_20_speed, vnav_speed, B738DR_fmc_speed)
				if B738DR_autopilot_autothr_arm_pos == 0 then
					B738DR_fmc_climb_speed_l = math.min (flaps_speed, v2_20_speed, vnav_speed, spd_250_10000)
				else
					if simDR_airspeed_is_mach == 0 then
						B738DR_fmc_climb_speed_l = math.min (flaps_speed, v2_20_speed, vnav_speed, spd_250_10000, B738DR_afs_spd_limit_max)
					else
						B738DR_fmc_climb_speed_l = math.min (flaps_speed, v2_20_speed, vnav_speed, spd_250_10000)
					end
				end
				
				if simDR_airspeed_is_mach == 0 then
					if B738DR_fmc_climb_speed_l < B738DR_fmc_climb_speed then
						vnav_speed_trg = B738DR_fmc_climb_speed_l
					else
						B738DR_fmc_climb_speed_l = 340
						vnav_speed_trg = B738DR_fmc_climb_speed
					end
				else
					B738DR_fmc_climb_speed_l = 340
					vnav_speed_trg = B738DR_fmc_climb_speed_mach
				end
				
				if B738DR_rest_wpt_alt == 0 or B738DR_rest_wpt_alt_t == 43 then
					vnav_alt = math.min(B738DR_fmc_cruise_alt, B738DR_mcp_alt_dial)
				else
					vnav_alt = math.min(B738DR_rest_wpt_alt, B738DR_fmc_cruise_alt, B738DR_mcp_alt_dial)
				end
				
				-- VNAV ALT
				if vnav_alt_mode == 0 then
				
					if vnav_alt_hld == 1 then
						if B738DR_autopilot_autothr_arm_pos == 1 then
							at_mode = 9		-- SPEED mode on with N1 limit
							B738DR_pfd_spd_mode = PFD_SPD_FMC_SPD
						end
						if simDR_autopilot_altitude_mode ~= 6 then
							simCMD_autopilot_alt_hold:once()
						end
						vnav_vs = 0
					end
					if vnav_vs == 1 and simDR_autopilot_altitude_mode == 5 then
						simDR_ap_vvi_dial = 850
						vvi_trg = simDR_ap_vvi_dial
						fmc_vvi_cur = simDR_vvi_fpm_pilot
						simCMD_autopilot_vs_sel:once()
					end
					
					if simDR_autopilot_altitude_mode == 5 then		-- LVL CHG
						delta_alt_dial = vnav_alt - simDR_altitude_pilot
						if B738DR_autopilot_autothr_arm_pos == 1 then
							at_mode = 7
							B738DR_autopilot_n1_status = 1
							--B738DR_autopilot_fmc_spd_pfd = 0 		-- FMC SPD on
							B738DR_pfd_spd_mode = PFD_SPD_N1
						end
							--B738DR_autopilot_vnav_alt_pfd = 0	-- PFD: no VNAV ALT
							--B738DR_autopilot_vnav_pth_pfd = 0	-- PFD: VNAV PTH
							--B738DR_autopilot_vnav_spd_pfd = 1	-- PFD: VNAV SPD
							B738DR_pfd_alt_mode = PFD_ALT_VNAV_SPD
						if delta_alt_dial > 700 then
							if B738DR_autopilot_autothr_arm_pos == 1 then
								eng1_N1_thrust_trg = eng1_N1_thrust	-- N1 THRUST
								eng2_N1_thrust_trg = eng2_N1_thrust	-- N1 THRUST
							end
							simDR_ap_altitude_dial_ft = B738DR_mcp_alt_dial
						else
							simDR_ap_altitude_dial_ft = vnav_alt
						end
						
					elseif simDR_autopilot_altitude_mode == 4 then
						if B738DR_autopilot_autothr_arm_pos == 1 then
							at_mode = 7
							B738DR_autopilot_n1_status = 1
							--B738DR_autopilot_fmc_spd_pfd = 0 		-- FMC SPD on
							B738DR_pfd_spd_mode = PFD_SPD_N1
						end
						--B738DR_autopilot_vnav_alt_pfd = 0	-- PFD: no VNAV ALT
						--B738DR_autopilot_vnav_pth_pfd = 0	-- PFD: VNAV PTH
						--B738DR_autopilot_vnav_spd_pfd = 1	-- PFD: VNAV SPD
						B738DR_pfd_alt_mode = PFD_ALT_VNAV_SPD
						delta_alt_dial = vnav_alt - simDR_altitude_pilot
						if delta_alt_dial > 700 then
							if B738DR_autopilot_autothr_arm_pos == 1 then
								eng1_N1_thrust_trg = eng1_N1_thrust	-- N1 THRUST
								eng2_N1_thrust_trg = eng2_N1_thrust	-- N1 THRUST
							end
							simDR_ap_altitude_dial_ft = B738DR_mcp_alt_dial
						else
							simDR_ap_altitude_dial_ft = vnav_alt
						end
					elseif simDR_autopilot_altitude_mode == 6 then
						if B738DR_autopilot_autothr_arm_pos == 1 then
							at_mode = 9		-- SPEED mode on with N1 limit
							--B738DR_autopilot_fmc_spd_pfd = 1 		-- FMC SPD on
							B738DR_autopilot_n1_status = 0
							B738DR_pfd_spd_mode = PFD_SPD_FMC_SPD
						end
						-- if vnav_alt_hld == 0 then
							-- mcp_alt_hold = B738DR_mcp_alt_dial
						-- end
						
						--delta_vvi = B738DR_mcp_alt_dial - simDR_altitude_pilot
						if simDR_ap_altitude_dial_ft == B738DR_fmc_cruise_alt and vnav_alt_hld == 0 then
							B738DR_flight_phase = 2
						
						--elseif simDR_ap_altitude_dial_ft == mcp_alt_hold and vnav_alt_hld == 0 and mcp_alt_hold < B738DR_rest_wpt_alt then
						elseif B738DR_alt_hold_mem == B738DR_mcp_alt_dial and vnav_alt_hld == 0 and B738DR_mcp_alt_dial < B738DR_rest_wpt_alt then
							vnav_alt_mode = 1
							simDR_ap_altitude_dial_ft = B738DR_mcp_alt_dial
							B738DR_pfd_alt_mode = PFD_ALT_VNAV_ALT
							B738DR_autopilot_n1_status = 0
							vnav_alt_hld = 1
							vnav_vs = 0
						
						else
							vnav_alt_hld = 1
							vnav_vs = 0
							simDR_ap_altitude_dial_ft = B738DR_mcp_alt_dial
							--simDR_ap_altitude_dial_ft = vnav_alt
							delta_vvi = B738DR_fmc_cruise_alt - simDR_altitude_pilot
							
							if delta_vvi > 400 then
								B738DR_pfd_alt_mode = PFD_ALT_VNAV_PTH
							end
							delta_vvi = simDR_vvi_fpm_pilot
							if delta_vvi < 0 then
								delta_vvi = -delta_vvi
							end
							if delta_vvi < 500 then		-- ALT HLD stabilized
								
								
								if B738DR_rest_wpt_alt == 0 or B738DR_rest_wpt_alt_t == 43 then
									vnav_alt2 = B738DR_fmc_cruise_alt
								else
									vnav_alt2 = math.min(B738DR_rest_wpt_alt, B738DR_fmc_cruise_alt)
								end
								delta_alt_dial = vnav_alt2 - simDR_altitude_pilot
								delta_alt_dial2 = B738DR_mcp_alt_dial - simDR_altitude_pilot
								
								-- delta_alt_dial = vnav_alt - simDR_altitude_pilot
								-- if delta_alt_dial > 500 then
								
								if delta_alt_dial > 500 then
									if delta_alt_dial2 > 500 then
										if B738DR_autopilot_autothr_arm_pos == 1 then
											--at_mode_old = at_mode
											simCMD_autopilot_lvl_chg:once()
											--at_mode = at_mode_old
											at_mode = 7
											B738DR_pfd_spd_mode = PFD_SPD_N1
										else
											at_mode_old = at_mode
											simCMD_autopilot_lvl_chg:once()
											at_mode = at_mode_old
										end
										vnav_alt_hld = 0
									else
										vnav_alt_mode = 1
										simDR_ap_altitude_dial_ft = B738DR_mcp_alt_dial
										B738DR_pfd_alt_mode = PFD_ALT_VNAV_ALT
										B738DR_autopilot_n1_status = 0
										vnav_alt_hld = 1
										vnav_vs = 0
									end
								end
							end
						end
					end
				else
					if B738DR_autopilot_autothr_arm_pos == 1 then
						at_mode = 9		-- SPEED mode on with N1 limit
						B738DR_pfd_spd_mode = PFD_SPD_FMC_SPD
					end
					if simDR_autopilot_altitude_mode ~= 6 then
						simCMD_autopilot_alt_hold:once()
					end
					simDR_ap_altitude_dial_ft = B738DR_mcp_alt_dial
					B738DR_pfd_alt_mode = PFD_ALT_VNAV_ALT
					B738DR_autopilot_n1_status = 0
					B738DR_pfd_spd_mode = PFD_SPD_FMC_SPD
					vnav_alt_hld = 0
					vnav_vs = 0
				end
				
			-- PHASE CRUISE
			elseif B738DR_flight_phase == 2 then
				
				B738DR_autopilot_n1_status = 0
				B738DR_pfd_spd_mode = PFD_SPD_FMC_SPD
				if simDR_autopilot_altitude_mode == 6 then
					B738DR_pfd_alt_mode = PFD_ALT_VNAV_PTH
					-- if at_mode == 9 then
						-- if B738DR_autopilot_autothr_arm_pos == 1 then
							-- if simDR_autothrottle_enable == 0 then
								-- simDR_autothrottle_enable = 1	-- speed on
							-- end
						-- end
					-- else
						
						if at_mode ~= 9 and B738DR_autopilot_autothr_arm_pos == 1 then
							at_mode = 9		-- SPEED mode on with N1 limit
						end
					-- end
				end
				
				vnav_alt_mode = 0
				
				if simDR_autopilot_altitude_mode ~= 6 then
					simCMD_autopilot_alt_hold:once()
					if B738DR_autopilot_autothr_arm_pos == 1 then
						at_mode = 9		-- SPEED mode on with N1 limit
						B738DR_pfd_spd_mode = PFD_SPD_FMC_SPD
					end
					vnav_alt_hld = 0
					vnav_vs = 0
				end
				
				-- crossover altitude
				if simDR_mach_no >= B738DR_fmc_cruise_speed_mach then
					if simDR_airspeed_is_mach == 0 then
						simCMD_autopilot_co:once()
					end
				end
				-- cruise speed
				if simDR_airspeed_is_mach == 0 then
					-- flaps limit speeds
					if flaps == 0 then
						flaps_speed = 340
					elseif flaps <= 0.25 then		-- flaps 1,2
						flaps_speed = 230
					elseif flaps <= 0.375 then		-- flaps 5
						flaps_speed = 230
					elseif flaps <= 0.5 then		-- flaps 10
						flaps_speed = 205
					elseif flaps <= 0.625 then		-- flaps 15
						flaps_speed = 195
					elseif flaps <= 0.75 then		-- flaps 25
						flaps_speed = 185
					else
						flaps_speed = 160
					end
					if flaps_speed == 0 then
						if flaps == 0 then
							flaps_speed = 340
						else
							flaps_speed = 230
						end
					end
					if B738DR_rest_wpt_spd > 0 then
						if B738DR_mcp_speed_dial < 100 then
							--vnav_speed_trg = B738DR_rest_wpt_spd
							vnav_speed_trg = math.min(spd_250_10000, B738DR_rest_wpt_spd, B738DR_fmc_cruise_speed, flaps_speed)
						else
							--if simDR_airspeed_dial ~= B738DR_rest_wpt_spd and simDR_dme_dist < decel_dist then
							if simDR_dme_dist < decel_dist then
								--vnav_speed_trg = B738DR_rest_wpt_spd
								vnav_speed_trg = math.min(spd_250_10000, B738DR_rest_wpt_spd, B738DR_fmc_cruise_speed, flaps_speed)
							else
								vnav_speed_trg = math.min(spd_250_10000, B738DR_fmc_cruise_speed, flaps_speed)
							end
						end
						-- 4NM before T/D
						if B738DR_vnav_td_dist > 0 and B738DR_vnav_td_dist < 4.5 then
							vnav_speed_trg = math.min(vnav_speed_trg, spd_250_10000, B738DR_fmc_descent_speed, flaps_speed)
						else
							vnav_speed_trg = math.min(vnav_speed_trg, spd_250_10000, B738DR_fmc_cruise_speed, flaps_speed)
						end
						--vnav_speed_trg = math.min(vnav_speed_trg, spd_250_10000, B738DR_fmc_cruise_speed)
					else
						-- 4NM before T/D
						if B738DR_vnav_td_dist > 0 and B738DR_vnav_td_dist < 4.5 then
							--vnav_speed_trg = B738DR_fmc_descent_speed
							vnav_speed_trg = math.min(spd_250_10000, B738DR_fmc_descent_speed, flaps_speed)
						else
							--vnav_speed_trg = B738DR_fmc_cruise_speed
							vnav_speed_trg = math.min(spd_250_10000, B738DR_fmc_cruise_speed, flaps_speed)
						end
					end
				else
					-- 4NM before T/D
					if B738DR_vnav_td_dist > 0 and B738DR_vnav_td_dist < 4.5 then
						vnav_speed_trg = B738DR_fmc_descent_speed_mach
					else
						vnav_speed_trg = B738DR_fmc_cruise_speed_mach
					end
				end
				
				if simDR_autopilot_altitude_mode ~= 6 then
					delta_alt_dial = B738DR_fmc_cruise_alt - simDR_altitude_pilot
					if delta_alt_dial < 500 then
						simDR_ap_altitude_dial_ft = B738DR_fmc_cruise_alt
					end
				else
					simDR_ap_altitude_dial_ft = B738DR_mcp_alt_dial
				end
				
				
				--------
				-- automatic descent
				if B738DR_missed_app_act == 0 then
					if B738DR_vnav_td_dist < 0.8 then
						if simDR_ap_altitude_dial_ft < B738DR_fmc_cruise_alt then
							-- vnav descent
							if ed_found <= B738_legs_num then
								if simDR_autopilot_altitude_mode ~= 4 then
									simDR_ap_vvi_dial = B738DR_vnav_vvi
									simCMD_autopilot_vs_sel:once()
								end
								at_mode = 2
								vnav_desc_spd = 0	-- change to VNAV PTH
							else
								if simDR_autopilot_altitude_mode ~= 5 then
									simCMD_autopilot_lvl_chg:once()
								end
								vnav_desc_spd = 1	-- change to VNAV SPD
								at_mode = 7
								eng1_N1_thrust_trg = 0.0
								eng2_N1_thrust_trg = 0.0
								B738DR_autopilot_n1_status = 0
								if B738DR_thrust1_leveler == 0 or B738DR_thrust2_leveler == 0 then
									at_mode = 0
									B738DR_pfd_spd_mode = PFD_SPD_ARM
								else
									B738DR_pfd_spd_mode = PFD_SPD_RETARD
								end
							end
						else
							vnav_alt_mode = 1
						end
						B738DR_fms_descent_now = 3
						B738DR_flight_phase = 5
						vnav_alt_hold_act = 0
						mcp_alt_hold = -1
						
					end
				end
				
			-- PHASE CRUISE CLIMB
			elseif B738DR_flight_phase == 3 then
				
				vnav_alt_mode = 0
				--B738DR_autopilot_fmc_spd_pfd = 1 		-- FMC SPD on
				B738DR_pfd_spd_mode = PFD_SPD_FMC_SPD
				-- crossover altitude
				if simDR_mach_no >= B738DR_fmc_cruise_speed_mach then
					if simDR_airspeed_is_mach == 0 then
						simCMD_autopilot_co:once()
					end
				end
				
				
				-- cruise speed
				if simDR_airspeed_is_mach == 0 then
				
					if B738DR_fmc_climb_r_speed1 == 0 then
							spd_250_10000 = 340
					else
						if B738DR_alt_hold_mem == 0 then
							if simDR_altitude_pilot < B738DR_fmc_climb_r_alt1 then
								spd_250_10000 = B738DR_fmc_climb_r_speed1
							else
								spd_250_10000 = 340
							end
						else
							if B738DR_alt_hold_mem <= B738DR_fmc_climb_r_alt1 then
								spd_250_10000 = B738DR_fmc_climb_r_speed1
							else
								spd_250_10000 = 340
							end
						end
					end
					vnav_speed_trg = math.min(B738DR_fmc_cruise_speed, spd_250_10000)
				else
					vnav_speed_trg = B738DR_fmc_cruise_speed_mach
				end
				
				vnav_alt = math.min(B738DR_fmc_cruise_alt, B738DR_mcp_alt_dial)
				if vnav_alt > (simDR_altitude_pilot + 450) then
					if simDR_autopilot_altitude_mode ~= 5 then		-- LVL CHG
						at_mode_old = at_mode
						simCMD_autopilot_lvl_chg:once()
						at_mode = at_mode_old
						vnav_cruise = 0
					end
					if B738DR_autopilot_autothr_arm_pos == 1 then
						at_mode = 7
						eng1_N1_thrust_trg = eng1_N1_thrust	-- N1 THRUST
						eng2_N1_thrust_trg = eng2_N1_thrust	-- N1 THRUST
						B738DR_pfd_spd_mode = PFD_SPD_N1
					end
					B738DR_pfd_alt_mode = PFD_ALT_VNAV_PTH
					simDR_ap_altitude_dial_ft = B738DR_mcp_alt_dial
				else
					if B738DR_autopilot_autothr_arm_pos == 1 then
						at_mode = 9		-- SPEED mode on with N1 limit
						B738DR_pfd_spd_mode = PFD_SPD_FMC_SPD
					end
					--B738DR_autopilot_vnav_alt_pfd = 1	-- PFD: VNAV ALT
					--B738DR_autopilot_vnav_pth_pfd = 0	-- PFD: no VNAV PTH
					--B738DR_autopilot_vnav_spd_pfd = 0
					B738DR_pfd_alt_mode = PFD_ALT_VNAV_PTH
					if simDR_autopilot_altitude_mode ~= 5 then		-- LVL CHG
						if simDR_autopilot_altitude_mode == 6 then
							B738DR_flight_phase = 2
							--B738DR_changed_flight_phase = 2
						end
						simDR_ap_altitude_dial_ft = B738DR_mcp_alt_dial
					else
						simDR_ap_altitude_dial_ft = vnav_alt
					end
				end
				
			-- PHASE CRUISE DESCENT
			elseif B738DR_flight_phase == 4 then
				
				vnav_alt_mode = 0
				--B738DR_autopilot_fmc_spd_pfd = 1 		-- FMC SPD on
				B738DR_pfd_spd_mode = PFD_SPD_FMC_SPD
				-- crossover altitude
				cca_alt = B738DR_fmc_cruise_speed_mach
				if AP_airspeed >= B738DR_fmc_cruise_speed
				and simDR_mach_no < cca_alt then
					if simDR_airspeed_is_mach == 1 then
						simCMD_autopilot_co:once()
					end
				end
				
				-- cruise speed
				if simDR_airspeed_is_mach == 0 then
					if B738DR_fmc_descent_r_speed1 == 0 then
						spd_250_10000 = 340
					else
						if B738DR_alt_hold_mem == 0 then
							if B738DR_rest_wpt_alt < B738DR_fmc_descent_r_alt1 then 
								if simDR_altitude_pilot < (B738DR_fmc_descent_r_alt1 + 900) then
									spd_250_10000 = B738DR_fmc_descent_r_speed1 --- 10
								else
									spd_250_10000 = 340
								end
							else
								spd_250_10000 = 340
							end
						else
							if B738DR_alt_hold_mem <= B738DR_fmc_descent_r_alt1 then
								spd_250_10000 = B738DR_fmc_climb_r_speed1
							else
								spd_250_10000 = 340
							end
						end
					end
					vnav_speed_trg = math.min(B738DR_fmc_cruise_speed, spd_250_10000)
				else
					vnav_speed_trg = B738DR_fmc_cruise_speed_mach
				end
				
				-- -- cruise speed
				-- if simDR_airspeed_is_mach == 0 then
					-- if B738DR_fmc_descent_r_speed1 == 0 then
						-- spd_250_10000 = 340
					-- else
						-- if simDR_altitude_pilot < (B738DR_fmc_descent_r_alt1 + 900) then
							-- spd_250_10000 = B738DR_fmc_descent_r_speed1
						-- else
							-- spd_250_10000 = 340
						-- end
					-- end
					-- vnav_speed_trg = math.min(B738DR_fmc_cruise_speed, spd_250_10000)
				-- else
					-- vnav_speed_trg = B738DR_fmc_cruise_speed_mach
				-- end
				
				if B738DR_autopilot_autothr_arm_pos == 1 then
					at_mode = 9		-- SPEED mode on with N1 limit
				end
				
				vnav_alt = math.max(B738DR_fmc_cruise_alt, B738DR_mcp_alt_dial)
				if (vnav_alt + 450) < simDR_altitude_pilot then
					simDR_ap_vvi_dial = -1000
					if simDR_autopilot_altitude_mode ~= 4 then		-- VS mode
						simCMD_autopilot_vs_sel:once()
						vnav_cruise = 0
					end
					simDR_ap_altitude_dial_ft = B738DR_mcp_alt_dial
				else
					if simDR_autopilot_altitude_mode ~= 4 then		-- VS mode
						if simDR_autopilot_altitude_mode == 6 then
							B738DR_flight_phase = 2
							--B738DR_changed_flight_phase = 2
						end
						simDR_ap_altitude_dial_ft = B738DR_mcp_alt_dial
					else
						simDR_ap_altitude_dial_ft = vnav_alt
					end
				end
				
			-- PHASE DESCENT
			elseif B738DR_flight_phase > 4 and B738DR_flight_phase < 8 then
				
				vnav_alt_hld = 0
				
				-- DESCENT NOW >>> 2
				if B738DR_fms_descent_now == 2 then
				
					-- if vnav_desc_spd == 1 then
						-- vnav_desc_spd = 0
						-- vnav_desc_protect_spd = 0
					-- end
					
					-- VNAV ALT
					if vnav_alt_mode == 0 then
					
						-- prevent overspeed
						--if simDR_airspeed_pilot > (B738DR_pfd_max_speed - 6) and B738DR_vnav_desc_spd_disable == 0 and vnav_desc_spd == 0 then
						delta_vvi = 0
						if B738DR_vnav_desc_spd_disable == 0 and vnav_desc_spd == 0 then
							if simDR_airspeed_is_mach == 0 then
								if AP_airspeed > 336 then 
									delta_vvi = 1
								end
							else
								if simDR_mach_no > 0.8 then
									delta_vvi = 1
								end
							end
						end
						if delta_vvi == 1 then
							-- switch to VNAV SPD
							vnav_desc_protect_spd = 1
							if simDR_autopilot_altitude_mode ~= 5 and simDR_glideslope_status == 0 then
								simCMD_autopilot_lvl_chg:once()
								--at_mode = 0
								at_mode = 7
							end
							
						else
							if vnav_desc_protect_spd == 1 then
								if B738DR_vnav_alt_err < -70 and B738DR_vnav_alt_err > -150 then
									simDR_ap_vvi_dial = B738DR_vnav_vvi
									simCMD_autopilot_vs_sel:once()
									vnav_desc_protect_spd = 0 -- change to VNAV PTH
								end
							end
						end
						if B738DR_vnav_desc_spd_disable == 1 and simDR_autopilot_altitude_mode ~= 4 then
							simDR_ap_vvi_dial = B738DR_vnav_vvi
							simCMD_autopilot_vs_sel:once()
							vnav_desc_spd = 0
							vnav_desc_protect_spd = 0 -- change to VNAV PTH
						end
						
						if B738DR_rest_wpt_alt == 0 or B738DR_rest_wpt_alt_t == 45 then		-- ignored Below alt restrict
							vnav_alt = B738DR_mcp_alt_dial
						else
							-- if B738DR_rest_wpt_alt ~= rest_wpt_alt_old and B738DR_vnav_vvi > 100 then
								-- vnav_alt = math.max(rest_wpt_alt_old, B738DR_mcp_alt_dial)
							-- else
								vnav_alt = math.max(B738DR_rest_wpt_alt, B738DR_mcp_alt_dial)
								rest_wpt_alt_old = B738DR_rest_wpt_alt
							-- end
						end
						
						if vnav_desc_spd == 0 then
						
							-- restrict altitude
							simDR_ap_altitude_dial_ft = vnav_alt
							if simDR_autopilot_altitude_mode == 6 then
								if vnav_alt_hold_act == 0 then
									vnav_alt_hold_act = 1
									vnav_alt_hold = vnav_alt
									mcp_alt_hold = B738DR_mcp_alt_dial
									at_mode = 2
								end
								delta_vvi = simDR_altitude_pilot - vnav_alt_hold
								if delta_vvi < 150 then -- HOLD stabilized
									rest_wpt_alt_old = B738DR_rest_wpt_alt
									if vnav_alt_hold == mcp_alt_hold then
										vnav_alt_mode = 1
										B738DR_pfd_alt_mode = PFD_ALT_VNAV_ALT
									else
										delta_alt_dial = simDR_altitude_pilot - vnav_alt
										if delta_alt_dial > 175 and B738DR_vnav_alt_err < 100 then
											if simDR_autopilot_altitude_mode ~= 4 and simDR_glideslope_status == 0 then
												simCMD_autopilot_vs_sel:once()
												at_mode = 2
												B738DR_fms_descent_now = 3
												simDR_ap_vvi_dial = B738DR_vnav_vvi
												vnav_alt_hold_act = 0
											end
										end
									end
								end
							else
								if vnav_desc_protect_spd == 0 then
									if simDR_autopilot_altitude_mode ~= 4 and simDR_glideslope_status == 0 then
										simCMD_autopilot_vs_sel:once()
										at_mode = 2
									end
									simDR_ap_vvi_dial = -1000
								else
									if simDR_autopilot_altitude_mode ~= 5 and simDR_glideslope_status == 0 then
										simCMD_autopilot_lvl_chg:once()
										--at_mode = 0
										at_mode = 7
									end
								end
							end
							
						else	-- VNAV SPD descent
							
							-- restrict altitude
							simDR_ap_altitude_dial_ft = vnav_alt
							if simDR_autopilot_altitude_mode == 6 then
								if vnav_alt_hold_act == 0 then
									vnav_alt_hold_act = 1
									vnav_alt_hold = vnav_alt
									mcp_alt_hold = B738DR_mcp_alt_dial
									at_mode = 2
								end
								delta_vvi = simDR_altitude_pilot - vnav_alt_hold
								if delta_vvi < 150 then -- HOLD stabilized
									rest_wpt_alt_old = B738DR_rest_wpt_alt
									if vnav_alt_hold == mcp_alt_hold then
										vnav_alt_mode = 1
										B738DR_pfd_alt_mode = PFD_ALT_VNAV_ALT
									else
										delta_alt_dial = simDR_altitude_pilot - vnav_alt
										if delta_alt_dial > 175 and B738DR_vnav_alt_err < 100 then
											if simDR_autopilot_altitude_mode ~= 4 and simDR_glideslope_status == 0 then
												simCMD_autopilot_vs_sel:once()
												at_mode = 2
												B738DR_fms_descent_now = 3
												simDR_ap_vvi_dial = B738DR_vnav_vvi
												vnav_alt_hold_act = 0
												vnav_desc_protect_spd = 0
												rest_wpt_alt_old = 0
											end
										end
									end
								end
							else
								if simDR_autopilot_altitude_mode ~= 5 and simDR_glideslope_status == 0 then
									simCMD_autopilot_lvl_chg:once()
									--at_mode = 0
									at_mode = 7
								end
							end
						
						end
					
						-- catch VNAV path
						if B738DR_fms_descent_now == 2 and B738DR_vnav_alt_err < 100 then
							if simDR_glideslope_status == 0 then
								if simDR_autopilot_altitude_mode ~= 4 then
									simCMD_autopilot_vs_sel:once()
								end
								at_mode = 2
								B738DR_fms_descent_now = 3
								simDR_ap_vvi_dial = B738DR_vnav_vvi
								vnav_alt_hold_act = 0
								vnav_desc_protect_spd = 0
								vnav_desc_spd = 0
								rest_wpt_alt_old = 0
								vnav_alt_hold = B738DR_alt_hold_mem
							end
						end
					else
						
						simDR_ap_altitude_dial_ft = B738DR_mcp_alt_dial
						
					end
					
					-- crossover altitude
					if AP_airspeed >= B738DR_fmc_descent_speed
					and simDR_mach_no < B738DR_fmc_descent_speed_mach then
						if simDR_airspeed_is_mach == 1 then
							simCMD_autopilot_co:once()
						end
					end
					
					-- descent speed
					
					-- flaps limit speeds
					flaps_speed = 340
					if flaps == 0 then
						flaps_speed = 340
					elseif flaps <= 0.25 then		-- flaps 1,2
						flaps_speed = B738DR_pfd_flaps_1
					elseif flaps <= 0.375 then		-- flaps 5
						flaps_speed = B738DR_pfd_flaps_5
					elseif flaps <= 0.5 then		-- flaps 10
						flaps_speed = B738DR_pfd_flaps_10
					elseif flaps <= 0.625 then		-- flaps 15
						if B738DR_fms_vref_15 == 0 then
							flaps_speed = B738DR_pfd_flaps_15
						else
							flaps_speed = B738DR_fms_vref_15
						end
					elseif flaps <= 0.75 then		-- flaps 25
						if B738DR_fms_vref_25 == 0 then
							flaps_speed = 175
						else
							flaps_speed = B738DR_fms_vref_25
						end
					elseif flaps <= 0.875 then		-- flaps 30
						if B738DR_fms_vref_30 == 0 then
							flaps_speed = 165
						else
							flaps_speed = B738DR_fms_vref_30
						end
					else		-- flaps 40
						if B738DR_fms_vref_40 == 0 then
							flaps_speed = 155
						else
							flaps_speed = B738DR_fms_vref_40
						end
					end
					
					if simDR_airspeed_is_mach == 0 then
						if B738DR_rest_wpt_spd > 0 then
							if B738DR_mcp_speed_dial < 100 then
								vnav_speed_trg = math.min(spd_250_10000, B738DR_rest_wpt_spd, B738DR_fmc_descent_speed)
							else
								if simDR_dme_dist < decel_dist then
									vnav_speed_trg = math.min(B738DR_fmc_descent_speed, spd_250_10000, B738DR_rest_wpt_spd)
								else
									vnav_speed_trg = math.min(B738DR_fmc_descent_speed, spd_250_10000)
								end
							end
							if flaps_speed == 340 then
								-- if B738DR_pfd_flaps_up == 340 then
									-- vnav_speed_trg = math.max(B738DR_rest_wpt_spd, 240)
								-- else
									-- vnav_speed_trg = math.max(B738DR_rest_wpt_spd, B738DR_pfd_flaps_up)
								-- end
								if B738DR_pfd_flaps_up == 340 then
									if vnav_speed_trg < 240 then
										vnav_speed_trg = 240
									end
								else
									if vnav_speed_trg < B738DR_pfd_flaps_up then
										vnav_speed_trg = B738DR_pfd_flaps_up
									end
								end
							end
							vnav_speed_trg = math.min(vnav_speed_trg, flaps_speed)
						else
							vnav_speed_trg = math.min(B738DR_fmc_descent_speed, spd_250_10000, flaps_speed)
						end
						if B738DR_fms_approach_speed > 0 and B738DR_approach_flaps_set == 1 then
							vnav_speed_trg = math.min(vnav_speed_trg, (B738DR_fms_approach_speed + B738DR_fms_approach_wind_corr))
						end
					else
						vnav_speed_trg = B738DR_fmc_descent_speed_mach
					end
				
				
				-- DESCENT NOW >>> 3
				else
					B738DR_fms_descent_now = 3
					
					delta_alt_dial = B738DR_fmc_cruise_alt - simDR_altitude_pilot
					if delta_alt_dial < 300 and simDR_autopilot_altitude_mode == 6 and B738DR_mcp_alt_dial >= B738DR_fmc_cruise_alt then
						-- crossover altitude
						if simDR_mach_no >= B738DR_fmc_descent_speed_mach then
							if simDR_airspeed_is_mach == 0 then
								simCMD_autopilot_co:once()
							end
						end
						-- cruise speed
						if simDR_airspeed_is_mach == 0 then
							--vnav_speed_trg = B738DR_fmc_descent_speed
							vnav_speed_trg = math.min(B738DR_fmc_descent_speed, spd_250_10000)
						else
							vnav_speed_trg = B738DR_fmc_descent_speed_mach
						end
						
						simDR_ap_altitude_dial_ft = B738DR_mcp_alt_dial
					
					else
					
						-- VNAV ALT
						if vnav_alt_mode == 0 then
						
							if B738DR_vnav_desc_spd_disable == 0 then
								-- if vnav_desc_spd == 0 then
									-- if B738DR_thrust1_leveler == 0 and B738DR_thrust2_leveler == 0 then
										-- if simDR_airspeed_is_mach == 0 then
											-- delta_alt_dial = AP_airspeed - vnav_speed_trg
										-- else
											-- delta_alt_dial = (AP_airspeed_mach - vnav_speed_trg) * 150
										-- end
										-- if delta_alt_dial < 0 then
											-- delta_alt_dial = -delta_alt_dial
										-- end
										-- if delta_alt_dial < 3 and B738DR_vnav_alt_err > -50 and B738DR_vnav_alt_err < 50 then
											-- if simDR_autopilot_altitude_mode ~= 5 and simDR_autopilot_altitude_mode ~= 6 and simDR_glideslope_status == 0 then
												-- simCMD_autopilot_lvl_chg:once()
												-- at_mode = 7
												-- vnav_desc_spd = 1	-- change to VNAV SPD
											-- end
										-- end
									-- end
								-- else
								
								if vnav_desc_spd == 1 then
									if B738DR_act_wpt_gp ~= 0 then
										if simDR_autopilot_altitude_mode ~= 6 then
											if simDR_autopilot_altitude_mode ~= 4 and simDR_glideslope_status == 0 then
												simDR_ap_vvi_dial = B738DR_vnav_vvi
												simCMD_autopilot_vs_sel:once()
												-- at_mode = 2
												-- vnav_desc_spd = 0 -- change to VNAV PTH
											end
										end
										at_mode = 2
										vnav_desc_spd = 0 -- change to VNAV PTH
									-- else
										-- if B738DR_ap_spd_interv_status == 0 then
											-- if simDR_autopilot_altitude_mode ~= 6 then
												-- if B738DR_vnav_alt_err < -350 or B738DR_vnav_alt_err > 350 then
													-- if simDR_autopilot_altitude_mode ~= 4 and simDR_glideslope_status == 0 then
														-- simDR_ap_vvi_dial = B738DR_vnav_vvi
														-- simCMD_autopilot_vs_sel:once()
														-- at_mode = 2
														-- vnav_desc_spd = 0 -- change to VNAV PTH
													-- end
												-- end
											-- end
										-- end
									end
								end
							end
							
							-- prevent overspeed
							--if simDR_airspeed_pilot > (B738DR_pfd_max_speed - 6) and B738DR_vnav_desc_spd_disable == 0 and vnav_desc_spd == 0 then
							delta_vvi = 0
							if B738DR_vnav_desc_spd_disable == 0 and vnav_desc_spd == 0 then
								if simDR_airspeed_is_mach == 0 then
									if AP_airspeed > 336 then
										delta_vvi = 1
									end
								else
									if simDR_mach_no > 0.80 then
										delta_vvi = 1
									end
								end
							end
							
							if delta_vvi == 1 then
								-- switch to VNAV SPD
								vnav_desc_protect_spd = 1
								if simDR_autopilot_altitude_mode ~= 5 and simDR_glideslope_status == 0 then
									simCMD_autopilot_lvl_chg:once()
									--at_mode = 0
									at_mode = 7
								end
								
							else
								if vnav_desc_protect_spd == 1 then
									if B738DR_vnav_alt_err < -70 and B738DR_vnav_alt_err > -150 then
										simDR_ap_vvi_dial = B738DR_vnav_vvi
										simCMD_autopilot_vs_sel:once()
										vnav_desc_protect_spd = 0 -- change to VNAV PTH
										at_mode = 2
									end
								end
							end
							if B738DR_vnav_desc_spd_disable == 1 then
								if simDR_autopilot_altitude_mode ~= 4 and simDR_autopilot_altitude_mode ~= 6 then
									simDR_ap_vvi_dial = B738DR_vnav_vvi
									simCMD_autopilot_vs_sel:once()
								end
								vnav_desc_spd = 0
								vnav_desc_protect_spd = 0 -- change to VNAV PTH
							end
							
							
							if B738DR_rest_wpt_alt == 0 or B738DR_rest_wpt_alt_t == 45 then		-- ignored Below alt restrict
								vnav_alt = B738DR_mcp_alt_dial
							else
								-- if B738DR_rest_wpt_alt ~= rest_wpt_alt_old and B738DR_vnav_vvi > 100 then
									-- vnav_alt = math.max(rest_wpt_alt_old, B738DR_mcp_alt_dial)
								-- else
									vnav_alt = math.max(B738DR_rest_wpt_alt, B738DR_mcp_alt_dial)
									rest_wpt_alt_old = B738DR_rest_wpt_alt
								-- end
							end
							
							if vnav_desc_spd == 0 then
							
								-- restrict altitude
								simDR_ap_altitude_dial_ft = vnav_alt
								if simDR_autopilot_altitude_mode == 6 then
									if vnav_alt_hold_act == 0 then
										vnav_alt_hold_act = 1
										vnav_alt_hold = vnav_alt
										mcp_alt_hold = B738DR_mcp_alt_dial
										at_mode = 2
									end
									delta_vvi = simDR_altitude_pilot - vnav_alt_hold
									if delta_vvi < 150 then -- HOLD stabilized
										rest_wpt_alt_old = B738DR_rest_wpt_alt
										if vnav_alt_hold == mcp_alt_hold then
											vnav_alt_mode = 1
											B738DR_pfd_alt_mode = PFD_ALT_VNAV_ALT
										else
											delta_alt_dial = simDR_altitude_pilot - vnav_alt
											if delta_alt_dial > 175 and B738DR_vnav_alt_err < 100 then
												if simDR_autopilot_altitude_mode ~= 4 and simDR_glideslope_status == 0 then
													simCMD_autopilot_vs_sel:once()
													simDR_ap_vvi_dial = B738DR_vnav_vvi
													vnav_alt_hold_act = 0
												end
											end
										end
									end
								else
									if vnav_desc_protect_spd == 0 then
										if simDR_autopilot_altitude_mode ~= 4 and simDR_glideslope_status == 0 then
											simCMD_autopilot_vs_sel:once()
											at_mode = 2
										end
										simDR_ap_vvi_dial = B738DR_vnav_vvi
									else
										if simDR_autopilot_altitude_mode ~= 5 and simDR_glideslope_status == 0 then
											simCMD_autopilot_lvl_chg:once()
											--at_mode = 0
											at_mode = 7
										end
									end
								end
								
							else	-- VNAV SPD descent
								
								-- restrict altitude
								simDR_ap_altitude_dial_ft = vnav_alt
								if simDR_autopilot_altitude_mode == 6 then
									if vnav_alt_hold_act == 0 then
										vnav_alt_hold_act = 1
										vnav_alt_hold = vnav_alt
										mcp_alt_hold = B738DR_mcp_alt_dial
										at_mode = 2
									end
									delta_vvi = simDR_altitude_pilot - vnav_alt_hold
									if delta_vvi < 150 then -- HOLD stabilized
										rest_wpt_alt_old = B738DR_rest_wpt_alt
										if vnav_alt_hold == mcp_alt_hold then
											vnav_alt_mode = 1
											B738DR_pfd_alt_mode = PFD_ALT_VNAV_ALT
										else
											delta_alt_dial = simDR_altitude_pilot - vnav_alt
											if delta_alt_dial > 100 and B738DR_vnav_alt_err < 100 then
												if simDR_autopilot_altitude_mode ~= 5 and simDR_glideslope_status == 0 then
													simCMD_autopilot_lvl_chg:once()
													--at_mode = 0
													at_mode = 7
													vnav_alt_hold_act = 0
												end
											end
										end
									end
								else
									if simDR_autopilot_altitude_mode ~= 5 and simDR_glideslope_status == 0 then
										simCMD_autopilot_lvl_chg:once()
										--at_mode = 0
										at_mode = 7
									end
								end
							
							end
						
						else
							simDR_ap_altitude_dial_ft = B738DR_mcp_alt_dial
						end
						
						-- crossover altitude
						delta_vvi = B738DR_fmc_descent_speed_mach
						if AP_airspeed >= B738DR_fmc_descent_speed
						and simDR_mach_no < delta_vvi then
							if simDR_airspeed_is_mach == 1 then
								simCMD_autopilot_co:once()
							end
						end
						
						-- descent speed
						
						-- flaps limit speeds
						flaps_speed = 340
						if flaps == 0 then
							flaps_speed = 340
						elseif flaps <= 0.25 then		-- flaps 1,2
							flaps_speed = B738DR_pfd_flaps_1
						elseif flaps <= 0.375 then		-- flaps 5
							flaps_speed = B738DR_pfd_flaps_5
						elseif flaps <= 0.5 then		-- flaps 10
							flaps_speed = B738DR_pfd_flaps_10
						elseif flaps <= 0.625 then		-- flaps 15
							if B738DR_fms_vref_15 == 0 then
								flaps_speed = B738DR_pfd_flaps_15
							else
								flaps_speed = B738DR_fms_vref_15
							end
						elseif flaps <= 0.75 then		-- flaps 25
							if B738DR_fms_vref_25 == 0 then
								flaps_speed = 175
							else
								flaps_speed = B738DR_fms_vref_25
							end
						elseif flaps <= 0.875 then		-- flaps 30
							if B738DR_fms_vref_30 == 0 then
								flaps_speed = 165
							else
								flaps_speed = B738DR_fms_vref_30
							end
						else		-- flaps 40
							if B738DR_fms_vref_40 == 0 then
								flaps_speed = 155
							else
								flaps_speed = B738DR_fms_vref_40
							end
						end
						
						
						
						if simDR_airspeed_is_mach == 0 then
							if B738DR_rest_wpt_spd > 0 then
								if B738DR_mcp_speed_dial < 100 then
									vnav_speed_trg = math.min(spd_250_10000, B738DR_rest_wpt_spd, B738DR_fmc_descent_speed)
								else
									if simDR_dme_dist < decel_dist then
										vnav_speed_trg = math.min(B738DR_fmc_descent_speed, spd_250_10000, B738DR_rest_wpt_spd)
									else
										vnav_speed_trg = math.min(B738DR_fmc_descent_speed, spd_250_10000)
									end
								end
								if flaps_speed == 340 then
									-- if B738DR_pfd_flaps_up == 340 then
										-- vnav_speed_trg = math.max(B738DR_rest_wpt_spd, 240)
									-- else
										-- vnav_speed_trg = math.max(B738DR_rest_wpt_spd, B738DR_pfd_flaps_up)
									-- end
									if B738DR_pfd_flaps_up == 340 then
										if vnav_speed_trg < 240 then
											vnav_speed_trg = 240
										end
									else
										if vnav_speed_trg < B738DR_pfd_flaps_up then
											vnav_speed_trg = B738DR_pfd_flaps_up
										end
									end
								end
								vnav_speed_trg = math.min(vnav_speed_trg, flaps_speed)
							else
								vnav_speed_trg = math.min(B738DR_fmc_descent_speed, spd_250_10000, flaps_speed)
							end
							if B738DR_fms_approach_speed > 0 and B738DR_approach_flaps_set == 1 then
								vnav_speed_trg = math.min(vnav_speed_trg, (B738DR_fms_approach_speed + B738DR_fms_approach_wind_corr))
							end
						else
							vnav_speed_trg = B738DR_fmc_descent_speed_mach
						end
						
					end
				end
				
				-- VNAV ALT
				if vnav_alt_mode == 0 then
					if B738DR_lock_idle_thrust == 0 then
						if vnav_desc_spd == 0 and vnav_desc_protect_spd == 0 then
							if simDR_airspeed_is_mach == 0 then
								alt_x = vnav_speed_trg - 5
								if flaps_speed < 340 then
									alt_x = math.max(alt_x, flaps_speed + 5)
								end
								if AP_airspeed < alt_x then
									if B738DR_autopilot_autothr_arm_pos == 1 then
										at_mode = 2
									end
								else
									if at_mode == 7 then
										eng1_N1_thrust_trg = 0.0
										eng2_N1_thrust_trg = 0.0
										B738DR_autopilot_n1_status = 0
										if B738DR_thrust1_leveler == 0 or B738DR_thrust2_leveler == 0 then
											at_mode = 0
										else
											B738DR_pfd_spd_mode = PFD_SPD_RETARD
										end
									elseif at_mode ~= 0 then
										if B738DR_thrust1_leveler == 0 or B738DR_thrust2_leveler == 0 then 
											at_mode = 0
										end
									end
								end
							else
								if simDR_mach_no < (vnav_speed_trg - 0.02) then
									if B738DR_autopilot_autothr_arm_pos == 1 then
										at_mode = 2
									end
								else
									if at_mode == 7 then
										eng1_N1_thrust_trg = 0.0
										eng2_N1_thrust_trg = 0.0
										B738DR_autopilot_n1_status = 0
										if B738DR_thrust1_leveler == 0 or B738DR_thrust2_leveler == 0 then
											at_mode = 0
										else
											B738DR_pfd_spd_mode = PFD_SPD_RETARD
										end
									elseif at_mode ~= 0 then
										if B738DR_thrust1_leveler == 0 or B738DR_thrust2_leveler == 0 then 
											at_mode = 0
										end
									end
								end
							end
						else
							if B738DR_autopilot_autothr_arm_pos == 1 then
								if simDR_autopilot_altitude_mode == 5 then
									eng1_N1_thrust_trg = 0.0
									eng2_N1_thrust_trg = 0.0
									B738DR_autopilot_n1_status = 0
									if B738DR_thrust1_leveler == 0 or B738DR_thrust2_leveler == 0 then
										at_mode = 0
									else
										B738DR_pfd_spd_mode = PFD_SPD_RETARD
									end
								end
							end
						end
					else
						if B738DR_autopilot_autothr_arm_pos == 1 then
							if vnav_desc_spd == 0 then
								at_mode = 2
							else
								eng1_N1_thrust_trg = 0.0
								eng2_N1_thrust_trg = 0.0
								B738DR_autopilot_n1_status = 0
								--B738DR_autopilot_n1_pfd = 0				-- PFD: no N1
								at_mode = 7
								--if B738DR_thrust1_leveler < 0.05 or B738DR_thrust2_leveler < 0.05 then
								if B738DR_thrust1_leveler == 0 or B738DR_thrust2_leveler == 0 then
									--B738DR_retard_status = 0				-- PFD: RETARD
									B738DR_pfd_spd_mode = PFD_SPD_FMC_SPD
								else
									--B738DR_retard_status = 1				-- PFD: RETARD
									B738DR_pfd_spd_mode = PFD_SPD_RETARD
								end
							end
						end
					end
					
					B738DR_autopilot_vnav_alt_pfd = 0	-- PFD: no VNAV ALT
					if vnav_desc_spd == 0 then
						if vnav_desc_protect_spd == 0 then
							B738DR_pfd_alt_mode = PFD_ALT_VNAV_PTH
						else
							B738DR_pfd_alt_mode = PFD_ALT_VNAV_SPD
						end
					else
						B738DR_pfd_alt_mode = PFD_ALT_VNAV_SPD
					end
				else
					if B738DR_autopilot_autothr_arm_pos == 1 then
						at_mode = 2
						B738DR_pfd_spd_mode = PFD_SPD_FMC_SPD
					end
					B738DR_pfd_alt_mode = PFD_ALT_VNAV_ALT
				end
				
				if at_mode == 0 then
					B738DR_pfd_spd_mode = PFD_SPD_ARM
				elseif at_mode == 7 then
						if B738DR_thrust1_leveler == 0 or B738DR_thrust2_leveler == 0 then
							B738DR_pfd_spd_mode = PFD_SPD_FMC_SPD
						else
							B738DR_pfd_spd_mode = PFD_SPD_RETARD
						end
				else
					B738DR_pfd_spd_mode = PFD_SPD_FMC_SPD
				end
				-- else
					-- if vnav_desc_spd == 0 and vnav_desc_protect_spd == 0 then
						-- B738DR_pfd_spd_mode = PFD_SPD_FMC_SPD
					-- else
						-- if B738DR_thrust1_leveler == 0 or B738DR_thrust2_leveler == 0 then
							-- B738DR_pfd_spd_mode = PFD_SPD_FMC_SPD
						-- else
							-- B738DR_pfd_spd_mode = PFD_SPD_RETARD
						-- end
					-- end
				-- end
			end
			
			if B738DR_ap_spd_interv_status == 0 then
				
				simDR_airspeed_dial = vnav_speed_trg
				
				if simDR_autopilot_altitude_mode ~= 6 and (B738DR_flight_phase < 2 or B738DR_missed_app_act > 0) then
					if init_climb == 0 and (B738DR_flight_phase < 2 or B738DR_missed_app_act > 0) then
						speed_step = AP_airspeed + (B738DR_speed_ratio * 5) + 5	--12.5, 11, 9.5, 8, 10
						if speed_step > vnav_speed_trg and (B738DR_flight_phase < 2 or B738DR_missed_app_act > 0) then
							if simDR_autopilot_altitude_mode ~= 5 then
								at_mode_old = at_mode
								simCMD_autopilot_lvl_chg:once()
								at_mode = at_mode_old
							end
							vnav_vs = 0
							if B738DR_autopilot_autothr_arm_pos == 1 then
								at_mode = 7		-- N1 thrust
							end
							simDR_ap_vvi_dial = 0
						else
							--if simDR_altitude_pilot > 25000 then
								speed_step = AP_airspeed + 10
								--if vnav_speed_trg > speed_step and B738DR_speed_ratio < 2 then
								lvl_chg_alt = math.max(simDR_altitude_pilot, 15000)
								lvl_chg_alt = math.min(lvl_chg_alt, 41000)
								lvl_chg_fpm = B738_rescale(15000, 1100, 41000, 50, lvl_chg_alt)
								if vnav_speed_trg > speed_step or simDR_vvi_fpm_pilot < (lvl_chg_fpm - 100) then
									-- turn climb vvi 900 ft
									if simDR_autopilot_altitude_mode ~= 4 then
										-- simDR_ap_vvi_dial = 1500	--850
										-- vvi_trg = simDR_ap_vvi_dial
										-- fmc_vvi_cur = simDR_vvi_fpm_pilot
										-- simCMD_autopilot_vs_sel:once()
										--simDR_ap_vvi_dial = lvl_chg_fpm
										vvi_trg = lvl_chg_fpm
										fmc_vvi_cur = simDR_vvi_fpm_pilot
										simCMD_autopilot_vs_sel:once()
									end
									vnav_vs = 1
								end
							--end
							
							if simDR_autopilot_altitude_mode == 4 then
								fmc_vvi_cur = B738_set_anim_value(fmc_vvi_cur, vvi_trg, 50, 8000, 0.15)
								simDR_ap_vvi_dial = fmc_vvi_cur
								if B738DR_autopilot_autothr_arm_pos == 1 then
									at_mode = 7		-- N1 thrust
								end
							end
						end
						if simDR_airspeed_is_mach == 0 then
							if AP_airspeed >= B738DR_fmc_climb_speed then
								init_climb = 1
								vnav_vs = 0
							end
						else
							init_climb = 1
							vnav_vs = 0
						end
					else
						init_climb = 1
						vnav_vs = 0
					end
				else
					vnav_vs = 0
					init_climb = 0
				end
			else
				if B738DR_flight_phase < 2 or B738DR_missed_app_act > 0 then
					if vnav_vs == 1 then
						if simDR_autopilot_altitude_mode ~= 5 then
							at_mode_old = at_mode
							simCMD_autopilot_lvl_chg:once()
							at_mode = at_mode_old
						end
						vnav_vs = 0
					end
					if simDR_autopilot_altitude_mode == 6 then
						B738DR_pfd_spd_mode = PFD_SPD_MCP_SPD
					else
						B738DR_pfd_spd_mode = PFD_SPD_N1
					end
				else
					B738DR_pfd_spd_mode = PFD_SPD_MCP_SPD
				end
			end
		
		end
	else
		vnav_engaged = 0
	end

end


-- LVL CHG and VNAV - LVL CHG, ALT HLD
function B738_lvl_chg()

	local delta_alt = 0
	local airspeed_dial = 0
	local speed_step = 0
	local at_mode_old = 0
	local lvl_chg_fpm = 0
	local lvl_chg_alt = 0
	--local lvl_vvi_trg = 0
	--local fmc_vvi_cur = 0

	--if ap_on == 1 and B738DR_autopilot_vnav_status == 0 then
	if B738DR_autopilot_vnav_status == 0 then
		if ap_pitch_mode_eng == 2 and ap_pitch_mode == 2 then --or ap_pitch_mode_eng == 5 then 		-- LVL CHG and VNAV custom
			
			if simDR_autopilot_altitude_mode ~= 5 then	-- not LVL CHG
				if simDR_ap_altitude_dial_ft < simDR_altitude_pilot then
					delta_alt = simDR_altitude_pilot - simDR_ap_altitude_dial_ft
					if delta_alt > 200 then
						B738DR_lvl_chg_mode = 0		-- descent
						simCMD_autopilot_lvl_chg:once()
					end
				end
				if simDR_ap_altitude_dial_ft > simDR_altitude_pilot and lvl_chg_vs == 0 then
					delta_alt = simDR_ap_altitude_dial_ft - simDR_altitude_pilot
					if delta_alt > 200 then
						B738DR_lvl_chg_mode = 1		-- climb
						airspeed_dial = simDR_airspeed_dial
						simCMD_autopilot_lvl_chg:once()
						if simDR_on_ground_0 == 0 and simDR_on_ground_1 == 0 and simDR_on_ground_2 == 0 then
							simDR_airspeed_dial = airspeed_dial
						end
					end
				end
			end
			if simDR_autopilot_altitude_mode == 5 or lvl_chg_vs == 1 then	-- LVL CHG
				
				if pitch_mode_old ~= ap_pitch_mode_eng or at_on_old ~= B738DR_autopilot_autothr_arm_pos then
					if B738DR_autopilot_autothr_arm_pos == 1 then
						at_mode = 6		-- SPEED LVL CHG
					end
				end
				
				if B738DR_lvl_chg_mode == 0 then	-- descent mode
					if at_mode == 6 then
						eng1_N1_thrust_trg = 0.0
						eng2_N1_thrust_trg = 0.0
						B738DR_autopilot_n1_status = 0
						--if B738DR_thrust1_leveler < 0.05 or B738DR_thrust2_leveler < 0.05 then
						if B738DR_thrust1_leveler == 0 or B738DR_thrust2_leveler == 0 then
							B738DR_pfd_spd_mode = PFD_SPD_ARM
							if B738DR_lock_idle_thrust == 0 then
								at_mode = 0
							end
						else
							B738DR_pfd_spd_mode = PFD_SPD_RETARD
						end
						B738DR_autopilot_n1_pfd = 0				-- PFD: no N1
					end
					if simDR_altitude_pilot < 26000 and lvl_chg_co_status == 0 and simDR_airspeed_is_mach == 1 then
						simCMD_autopilot_co:once()
						lvl_chg_co_status = 1
					end
					
				else	-- climb mode
					if B738DR_autopilot_autothr_arm_pos == 1 then
						B738DR_autopilot_n1_status = 1
						eng1_N1_thrust_trg = eng1_N1_thrust	-- N1 THRUST
						eng2_N1_thrust_trg = eng2_N1_thrust	-- N1 THRUST
						B738DR_pfd_spd_mode = PFD_SPD_N1
					end
					if simDR_altitude_pilot > 26000 and lvl_chg_co_status == 0 and simDR_airspeed_is_mach == 0 then
						simCMD_autopilot_co:once()
						lvl_chg_co_status = 1
					end
					
					if simDR_airspeed_is_mach == 0 then
						if simDR_autopilot_altitude_mode ~= 6 then
							--speed_step = simDR_airspeed_pilot + (B738DR_speed_ratio * 5) + 5
							speed_step = AP_airspeed + (B738DR_speed_ratio * 3.2) + 5
							if speed_step > simDR_airspeed_dial then
								if simDR_autopilot_altitude_mode ~= 5 then
									at_mode_old = at_mode
									airspeed_dial = simDR_airspeed_dial
									simCMD_autopilot_lvl_chg:once()
									if simDR_on_ground_0 == 0 and simDR_on_ground_1 == 0 and simDR_on_ground_2 == 0 then
										simDR_airspeed_dial = airspeed_dial
									end
									at_mode = at_mode_old
								end
								lvl_chg_vs = 0
								if B738DR_autopilot_autothr_arm_pos == 1 then
									at_mode = 6		-- N1 thrust
								end
								simDR_ap_vvi_dial = 0
							else
								speed_step = AP_airspeed + 10
								--if simDR_airspeed_dial > speed_step and B738DR_speed_ratio < 2 then
								lvl_chg_alt = math.max(simDR_altitude_pilot, 15000)
								lvl_chg_alt = math.min(lvl_chg_alt, 41000)
								lvl_chg_fpm = B738_rescale(15000, 1000, 41000, 50, lvl_chg_alt)
								if simDR_airspeed_dial > speed_step or simDR_vvi_fpm_pilot < (lvl_chg_fpm - 100) then
									if simDR_autopilot_altitude_mode ~= 4 then
										lvl_vvi_trg = lvl_chg_fpm
										fmc_vvi_cur = simDR_vvi_fpm_pilot
										simCMD_autopilot_vs_sel:once()
									end
									lvl_chg_vs = 1
								end
								if simDR_autopilot_altitude_mode == 4 then
									fmc_vvi_cur = B738_set_anim_value(fmc_vvi_cur, lvl_vvi_trg, 50, 8000, 0.15)
									simDR_ap_vvi_dial = fmc_vvi_cur
									if B738DR_autopilot_autothr_arm_pos == 1 then
										at_mode = 6		-- N1 thrust
									end
								end
							end
						else
							lvl_chg_vs = 0
							if simDR_autopilot_altitude_mode ~= 5 then
								at_mode_old = at_mode
								airspeed_dial = simDR_airspeed_dial
								simCMD_autopilot_lvl_chg:once()
								if simDR_on_ground_0 == 0 and simDR_on_ground_1 == 0 and simDR_on_ground_2 == 0 then
									simDR_airspeed_dial = airspeed_dial
								end
								at_mode = at_mode_old
							end
						end
					else
						lvl_chg_vs = 0
						if simDR_autopilot_altitude_mode ~= 5 and simDR_autopilot_altitude_mode ~= 6 then
							at_mode_old = at_mode
							airspeed_dial = simDR_airspeed_dial
							simCMD_autopilot_lvl_chg:once()
							if simDR_on_ground_0 == 0 and simDR_on_ground_1 == 0 and simDR_on_ground_2 == 0 then
								simDR_airspeed_dial = airspeed_dial
							end
							at_mode = at_mode_old
						end
					end
				end
			end
		end
	end

end



function B738_alt_hld()

	local alt_x = 0
	
	if B738DR_autopilot_vnav_status == 0 then
		if ap_pitch_mode_eng == 3 and ap_pitch_mode == 3 then
			if simDR_autopilot_altitude_mode == 6 then	-- ALT HLD
				if B738DR_gp_status == 0 then
					if null_vvi == 1 then
						simDR_ap_vvi_dial = 0
						null_vvi = 0
					end
					alt_x = simDR_altitude_pilot - simDR_ap_altitude_dial_ft
					if alt_x < 0 then
						alt_x = -alt_x
					end
					if alt_x >= 300 and simDR_glideslope_status == 0 
					and altitude_dial_ft_old ~= simDR_ap_altitude_dial_ft then
						B738DR_pfd_alt_mode_arm = PFD_ALT_VS_ARM
						if simDR_ap_vvi_dial ~= 0 then
							simCMD_autopilot_vs_sel:once()
							ap_pitch_mode = 1
							ap_pitch_mode_eng = 1
							if pitch_mode_old ~= ap_pitch_mode_eng or at_on_old ~= B738DR_autopilot_autothr_arm_pos then
								if B738DR_autopilot_autothr_arm_pos == 1 then
									at_mode = 2		-- SPEED on
								end
							end
						end
					else
						if B738DR_pfd_alt_mode_arm == PFD_ALT_VS_ARM then
							B738DR_pfd_alt_mode_arm = 0
						end
					end
				else
					if B738DR_pfd_alt_mode_arm == PFD_ALT_VS_ARM then
						B738DR_pfd_alt_mode_arm = 0
					end
				end
			else
				if simDR_vvi_fpm_pilot > -200 and simDR_vvi_fpm_pilot < 200 then
					simCMD_autopilot_alt_hold:once()
				else
					if simDR_autopilot_altitude_mode ~= 4 then
						simCMD_autopilot_vs:once()
					end
					simDR_ap_vvi_dial = 0
					null_vvi = 0
				end
			end
			if at_on_old ~= B738DR_autopilot_autothr_arm_pos and B738DR_autopilot_autothr_arm_pos == 1 then
				at_mode = 2
			end
		else
			--B738DR_autopilot_vvi_status_pfd = 0		-- no V/S arm
			--B738DR_pfd_alt_mode_arm = 0
			null_vvi = 1
		end
	end
	
end


function B738_alt_acq()	--ALT ACQ mode

	local alt_x = 0
	local alt_y = 0
	--local alt_acq_disable = 0
	local climb_descent = 0
	
	alt_acq_disable = 0
	
		if B738DR_autopilot_vnav_status == 1 and ap_pitch_mode == 5 and ap_pitch_mode_eng == 5 then
			alt_acq_disable = 1
			if B738DR_flight_phase > 4 and B738DR_flight_phase < 8 then
				alt_x = simDR_altitude_pilot - ed_alt
				--if B738DR_rest_wpt_alt == ed_alt and B738DR_mcp_alt_dial >= ed_alt and alt_x < 700 and ed_alt > 0 then	-- stop VNAV on E/D
				if B738DR_mcp_alt_dial >= ed_alt and alt_x < 700 and alt_x > -300 then	-- stop VNAV on E/D
					alt_acq_disable = 0
				end
			end
			
			-- if ap_roll_mode_eng == 4 and ap_roll_mode == 4		-- LNAV
			-- and ap_pitch_mode_eng == 5 and ap_pitch_mode == 5 	-- VNAV
			-- and B738DR_gp_active > 0 and B738DR_pfd_vert_path == 1 then	-- (G/P) -> LNAV/VNAV
				-- alt_acq_disable = 1
			-- end
			
			-- if ap_roll_mode_eng == 2 and ap_roll_mode == 2		-- VOR LOC
			-- and ap_pitch_mode_eng == 5 and ap_pitch_mode == 5 	-- VNAV
			-- and B738DR_gp_active > 0 and B738DR_pfd_vert_path == 1 then	-- (G/P) -> LOC/VNAV
				-- alt_acq_disable = 1
			-- end
			
			if vnav_init2 == 0 then
				vnav_init2 = 1
				alt_acq_disable = 1
			end
		end
		if ap_pitch_mode_eng == 7 then		--G/P
			alt_acq_disable = 1
		elseif B738DR_autoland_status == 1 then
			alt_acq_disable = 1
		elseif simDR_glideslope_status > 1 then
			alt_acq_disable = 1
		end
		if alt_acq_disable == 0 then
			if ap_pitch_mode ~= 6 and ap_pitch_mode ~= 3 then
				if simDR_autopilot_altitude_mode == 4 or simDR_autopilot_altitude_mode == 5 then	-- V/S or LVL CHG
					alt_x = simDR_altitude_pilot + (simDR_vvi_fpm_pilot / 3.5)	-- 17 seconds to MCP ALT
					alt_y = simDR_ap_altitude_dial_ft - simDR_altitude_pilot
					if alt_y < 0 then
						alt_y = -alt_y
						climb_descent = 1	-- descent
					end
					-- CLIMB
					if climb_descent == 0 then --simDR_vvi_fpm_pilot > 0 then
						if alt_x >= simDR_ap_altitude_dial_ft and alt_y < 1500 then
							ap_pitch_mode = 6
							ap_pitch_mode_eng = 6
							if simDR_glideslope_status < 2 then
								if simDR_autopilot_altitude_mode ~= 4 then
									simCMD_autopilot_vs:once()
									simDR_ap_vvi_dial = roundUpToIncrement(simDR_ap_vvi_dial, 100 )
								end
							end
							if B738DR_autopilot_autothr_arm_pos == 1 then
								at_mode = 2		-- SPEED on
								at_mode_eng = 0
							end
							altitude_dial_ft_old = simDR_ap_altitude_dial_ft
							vnav_stop()
						end
					-- DESCENT
					else
						if alt_x <= simDR_ap_altitude_dial_ft and alt_y < 1500 then
							ap_pitch_mode = 6
							ap_pitch_mode_eng = 6
							if simDR_glideslope_status < 2 then
								if simDR_autopilot_altitude_mode ~= 4 then
									simCMD_autopilot_vs:once()
									vert_spd_corr()
								end
							end
							if B738DR_autopilot_autothr_arm_pos == 1 then
								at_mode = 2		-- SPEED on
								at_mode_eng = 0
							end
							altitude_dial_ft_old = simDR_ap_altitude_dial_ft
							vnav_stop()
						end
					end
				end
			end
			if ap_pitch_mode_eng == 6 and ap_pitch_mode == 6 and altitude_dial_ft_old ~= simDR_ap_altitude_dial_ft then
				alt_x = simDR_altitude_pilot - simDR_ap_altitude_dial_ft
				if alt_x < 0 then
					alt_x = -alt_x
				end
				if alt_x > 200 and simDR_glideslope_status < 2 then
					if simDR_autopilot_altitude_mode ~= 4 then
						simCMD_autopilot_vs:once()
						vert_spd_corr()
					end
					ap_pitch_mode = 1
					ap_pitch_mode_eng = 1
					if pitch_mode_old ~= ap_pitch_mode_eng or at_on_old ~= B738DR_autopilot_autothr_arm_pos then
						if B738DR_autopilot_autothr_arm_pos == 1 then
							at_mode = 2		-- SPEED on
						end
					end
				end
			end
			if ap_pitch_mode_eng == 6 and ap_pitch_mode == 6 then
				if simDR_autopilot_altitude_mode == 6 then
					simDR_ap_vvi_dial = 0
					vnav_stop()
					ap_pitch_mode = 3
					ap_pitch_mode_eng = 3
					if pitch_mode_old ~= ap_pitch_mode_eng or at_on_old ~= B738DR_autopilot_autothr_arm_pos then
						if B738DR_autopilot_autothr_arm_pos == 1 then
							at_mode = 2
						end
					end
				end
			end
			if ap_pitch_mode_eng == 3 and ap_pitch_mode == 3 then
				if simDR_autopilot_altitude_mode == 6 then
					ap_pitch_mode = 3
					ap_pitch_mode_eng = 3
					--only once
					if ap_pitch_mode_eng ~= pitch_mode_old or at_on_old ~= B738DR_autopilot_autothr_arm_pos then
						if B738DR_autopilot_autothr_arm_pos == 1 then
							at_mode = 2		-- SPEED on
						end
					end
				end
			end
			
		end
end


function B738_vs()

	if B738DR_autopilot_vnav_status == 0 then
		if ap_pitch_mode_eng == 1 and ap_pitch_mode == 1 then
			if simDR_autopilot_altitude_mode ~= 4 then
				if simDR_ap_vvi_dial == 0 then
					simCMD_autopilot_vs:once()
				else
					simCMD_autopilot_vs_sel:once()
				end
			end
			if vs_first == 0 then
				vs_first = 1
				if at_mode ~= 2 then
					if B738DR_autopilot_autothr_arm_pos == 1 then
						at_mode = 2		-- SPEED on
					end
				end
			end
		else
			vs_first = 0
		end
	else
		vs_first = 0
	end

end

function B738_app()
	
	if simDR_approach_status > 1 
	and simDR_glideslope_status > 1 
	and ap_on == 1 then
		ap_app_block = 1
		if simDR_radio_height_pilot_ft < 800 then
			ap_app_block_800 = 1
		else
			ap_app_block_800 = 0
		end
	else
		ap_app_block = 0
		ap_app_block_800 = 0
	end
	
	if B738DR_autoland_status == 0 then
		if ap_roll_mode == 3 and ap_roll_mode_eng == 3 then --and B738DR_autoland_status == 0 then
			if simDR_nav_status == 0 then
				B738DR_ap_ils_active = 0
				if ap_pitch_mode == 4 then
					simCMD_disconnect:once()
					autopilot_cmd_a_status = 0
					autopilot_cmd_b_status = 0
					ap_pitch_mode = 0
				end
				ap_roll_mode = 0
			elseif ap_pitch_mode == 4 and simDR_glideslope_status == 0 then
				B738DR_ap_ils_active = 0
				simCMD_disconnect:once()
				autopilot_cmd_a_status = 0
				autopilot_cmd_b_status = 0
				ap_roll_mode = 0
				ap_pitch_mode = 0
			else
				B738DR_ap_ils_active = 1
				
				if simDR_nav_status == 2 and simDR_approach_status == 0 then
					simCMD_autopilot_app:once()
					-- ap_roll_mode = 3
					-- ap_roll_mode_eng = 3
					lnav_engaged = 0
				end
				if simDR_approach_status == 2 then
					if ap_pitch_mode_eng ~= 4 and simDR_glideslope_status == 2 then 	-- G/S engaged
						ap_pitch_mode = 4
					end
				end
				if simDR_glideslope_status == 2 and glideslope_status_old ~= simDR_glideslope_status then
					if B738DR_autopilot_autothr_arm_pos == 1 then
						at_mode = 2
					end
				end
			end
		else
			B738DR_ap_ils_active = 0
		end
	else
		B738DR_ap_ils_active = 1
	end
	
end

function B738_hdg()

	if ap_roll_mode == 1 and ap_roll_mode_eng == 1 then
		if simDR_autopilot_heading_mode ~= 1 then
			simCMD_autopilot_hdg:once()
		end
	end

end


function B738_vorloc()

	if ap_roll_mode == 2 and ap_roll_mode_eng == 2 then
		if simDR_nav_status == 0 then
			ap_roll_mode = 0
		-- if simDR_nav_status == 0 then
			-- simCMD_autopilot_lnav:once()			-- VOR LOC on
		end
	end

end


function B738_fac()
	
	local wca = 0
	local wh = 0
	local tas = 0
	local awa = 0
	local relative_brg = 0
	local mag_hdg = 0
	local mag_trk = 0	-- temporary without mag variantion
	local ap_hdg = 0
	local rnp_deg = 0
	local bearing_corr = 0
	local idx_corr = 0
	local idx_dist = 0
	local relative_brg2 = 0
	local relative_brg3 = 0
	local fix_bank_angle = 0
	local fac_capture = 0
	local idx_rnp = 0
	local pom1 = 0
	local gnd_spd = 0
	
	if ap_roll_mode == 11 and ap_roll_mode_eng == 11 then		-- FAC
		if fac_engaged == 0 then
			mag_trk = (B738DR_fac_trk + simDR_mag_variation + 360) % 360
			relative_brg = (mag_trk - simDR_ahars_mag_hdg + 360) % 360
			if relative_brg > 180 then
				relative_brg = relative_brg - 360
			end
			if relative_brg > -90 and relative_brg < 90 then
				fac_capture = 1
			end
			-- engage FAC
			if B738DR_pfd_gp_path == 1 and B738DR_fac_xtrack > -2.0 and B738DR_fac_xtrack < 2.0 and fac_capture == 1 then
				fac_engaged = 1
			end
		end
	elseif ap_roll_mode == 7 and ap_roll_mode_eng == 7 then		-- HDG/FAC arm
		if fac_engaged == 0 then
			mag_trk = (B738DR_fac_trk + simDR_mag_variation + 360) % 360
			relative_brg = (mag_trk - simDR_ahars_mag_hdg + 360) % 360
			if relative_brg > 180 then
				relative_brg = relative_brg - 360
			end
			if relative_brg > -90 and relative_brg < 90 then
				fac_capture = 1
			end
			-- engage FAC
			if B738DR_pfd_gp_path == 1 and B738DR_fac_xtrack > -2.0 and B738DR_fac_xtrack < 2.0 and fac_capture == 1 then
				fac_engaged = 1
				ap_roll_mode = 11	-- FAC
				ap_roll_mode_eng = 11
			end
		end
	else
		fac_engaged = 0
	end
		
	if fac_engaged == 1 then
		
		if simDR_autopilot_heading_mode ~= 1 then
			simCMD_autopilot_hdg:once()
		end
		
		if ap_roll_mode_old ~= ap_roll_mode_eng or at_on_old ~= B738DR_autopilot_autothr_arm_pos then
			if B738DR_autopilot_autothr_arm_pos == 1 then
				at_mode = 2		-- SPEED on
			end
		end
		
		mag_trk = (B738DR_fac_trk + simDR_mag_variation + 360) % 360
		
		gnd_spd = math.min(simDR_ground_spd, 230)
		gnd_spd = math.max(gnd_spd, 70)
		idx_rnp = math.min(idx_rnp, 2.0)
		idx_rnp = math.max(idx_rnp, 0.1)
		idx_rnp = B738_rescale( 0.1, B738_rescale(70, 1.5, 230, 1.9, gnd_spd), 2.0, B738_rescale(70, 1.9, 230, 2.3, gnd_spd), idx_rnp)
		
		
		if B738DR_fac_xtrack < 0 then
			if relative_brg > 15  and B738DR_fac_xtrack < -1 then
				idx_corr = 45
			else
				idx_dist = -B738DR_fac_xtrack
				if idx_dist > idx_rnp then
					idx_dist = idx_rnp
				end
				pom1 = idx_rnp / 4
				if idx_dist < pom1 then
					idx_corr = B738_rescale(0, 0, pom1, 15, idx_dist)
				else
					idx_corr = B738_rescale(pom1, 15, idx_rnp, 35, idx_dist)
				end
			end
			ap_hdg = (mag_trk + idx_corr + 360) % 360
		else
			if relative_brg < -15 and B738DR_fac_xtrack > 1 then
				idx_corr = 45
			else
				idx_dist = B738DR_fac_xtrack
				if idx_dist > idx_rnp then
					idx_dist = idx_rnp
				end
				pom1 = idx_rnp / 4
				if idx_dist < pom1 then
					idx_corr = B738_rescale(0, 0, pom1, 19, idx_dist)
				else
					idx_corr = B738_rescale(pom1, 19, idx_rnp, 35, idx_dist)
				end
			end
			ap_hdg = (mag_trk - idx_corr + 360) % 360
		end
		--bank angle
		if B738DR_fms_vref ~= 0 and AP_airspeed < B738DR_fms_vref and AP_airspeed > 45 then
			simDR_bank_angle = 3	-- bank angle protection below Vref speed
		else
			simDR_bank_angle = 4
		end
		
		-- wind correction
		mag_hdg = simDR_ahars_mag_hdg --- simDR_mag_variation
		tas = simDR_ground_spd * 1.94384449244	-- m/s to knots
		wh = (simDR_wind_hdg + 180) % 360
		relative_brg = (wh - mag_hdg + 360) % 360
		if relative_brg > 180 then
			relative_brg = relative_brg - 360
		end
		if relative_brg < -90 then
			awa = math.rad(180 + relative_brg)
			wca = math.asin(simDR_wind_spd * ((math.sin(awa) / tas)))
			wca = math.deg(-wca)
		elseif relative_brg < 0 then
			awa = math.rad(-relative_brg)
			wca = math.asin(simDR_wind_spd * ((math.sin(awa) / tas)))
			wca = math.deg(-wca)
		elseif relative_brg < 90 then
			awa = math.rad(relative_brg)
			wca = math.asin(simDR_wind_spd * ((math.sin(awa) / tas)))
			wca = math.deg(wca)
		else
			awa = math.rad(180 - relative_brg)
			wca = math.asin(simDR_wind_spd * ((math.sin(awa) / tas)))
			wca = math.deg(wca)
		end
		
		ap_wca = B738_set_anim_value(ap_wca, wca, -360, 360, 1)
		simDR_ap_capt_heading = (ap_hdg - ap_wca) % 360
		-- tgt_heading = (ap_hdg - ap_wca) % 360
		-- act_heading = B738_set_animation_rate(simDR_ap_capt_heading, tgt_heading, -720, 720, 0.25)
		-- if act_heading < 360 then
			-- act_heading = 360 + act_heading
		-- elseif act_heading > 360 then
			-- act_heading = act_heading - 360
		-- end
		-- simDR_ap_capt_heading = act_heading
	
	end
	
	-- show FAC dots and pointer
	if B738DR_pfd_gp_path == 1 then
		if B738DR_fac_xtrack < -2.5 then
			B738DR_fac_horizont = -2.5
		elseif B738DR_fac_xtrack > 2.5 then
			B738DR_fac_horizont = 2.5
		else
			B738DR_fac_horizont = B738DR_fac_xtrack
		end
	end
	
	-- FAC disengage
	if ap_roll_mode == 11 and B738DR_pfd_gp_path == 0 and fac_engaged == 1 then
		ap_roll_mode = 0
	end
	if ap_pitch_mode == 7 and B738DR_pfd_gp_path == 0 and fac_engaged == 1 then
		ap_pitch_mode = 0
	end

end

function B738_gp()
	local r_delta_alt = 0
	
	if ap_pitch_mode_eng == 7 and ap_pitch_mode == 7 then	-- G/P -> LOC/VNAV
		if pitch_mode_old ~= ap_pitch_mode_eng or at_on_old ~= B738DR_autopilot_autothr_arm_pos then
			if B738DR_autopilot_autothr_arm_pos == 1 then
				at_mode = 2
			end
		end
		r_delta_alt = simDR_altitude_pilot + 700
		if B738DR_mcp_alt_dial > r_delta_alt then
			simDR_ap_altitude_dial_ft = B738DR_mcp_alt_dial
		else
			simDR_ap_altitude_dial_ft = 0	-- ignored MCP alt dial
		end
		simDR_ap_vvi_dial = B738DR_gp_vvi
		if simDR_autopilot_altitude_mode ~= 4 then
			simCMD_autopilot_vs_sel:once()
		end
	end
end

function B738_lnav_vnav()
	
	local r_delta_alt = 0
	
	if ap_pitch_mode_eng == 5 and ap_pitch_mode == 5 	-- VNAV
	and lnav_engaged == 1 and B738DR_pfd_vert_path == 1 and B738DR_vnav_app_active == 1 and alt_acq_disable == 1 and vnav_alt_mode == 0 then	-- LNAV/VNAV
		if pitch_mode_old ~= ap_pitch_mode_eng or at_on_old ~= B738DR_autopilot_autothr_arm_pos then
			if B738DR_autopilot_autothr_arm_pos == 1 then
				at_mode = 2
			end
		end
		r_delta_alt = simDR_altitude_pilot + 650
		if B738DR_mcp_alt_dial > r_delta_alt then
			simDR_ap_altitude_dial_ft = B738DR_mcp_alt_dial
		else
			simDR_ap_altitude_dial_ft = 0	-- ignored MCP alt dial
		end
		simDR_ap_vvi_dial = B738DR_vnav_vvi
		if simDR_autopilot_altitude_mode ~= 4 then
			simCMD_autopilot_vs_sel:once()
		end
	end
	
end

function B738_loc_gp()
	
	local r_delta_alt = 0
	
	-- LOC GP
	if ap_roll_mode == 14 and ap_roll_mode_eng == 14 then		-- LOC GP
		if simDR_nav_status == 0 then
			ap_roll_mode = 0
			loc_gp_engaged = 0
		else
			loc_gp_engaged = 1
		end
	else
		loc_gp_engaged = 0
	end
	
	if loc_gp_engaged == 1 then
		if ap_roll_mode_old ~= ap_roll_mode_eng or at_on_old ~= B738DR_autopilot_autothr_arm_pos then
			if B738DR_autopilot_autothr_arm_pos == 1 then
				at_mode = 2		-- SPEED on
			end
		end
	end
	
	-- LOC GP disengage
	if ap_roll_mode == 14 and B738DR_pfd_gp_path == 0 and loc_gp_engaged == 1 then
		ap_roll_mode = 0
	end
	if ap_pitch_mode == 7 and B738DR_pfd_gp_path == 0 and loc_gp_engaged == 1 then
		ap_pitch_mode = 0
	end
	
end

function B738_loc_vnav()
	
	local r_delta_alt = 0
	if ap_pitch_mode_eng == 5 and ap_pitch_mode == 5 	-- VNAV
	and ap_roll_mode_eng == 2 and ap_roll_mode == 2		-- VOR LOC
	and B738DR_nd_vert_path == 1 and alt_acq_disable == 1 and vnav_alt_mode == 0 then	-- LOC/VNAV
		if simDR_nav_status == 0 then
			ap_roll_mode = 0
			ap_pitch_mode = 0
		else
			if pitch_mode_old ~= ap_pitch_mode_eng or at_on_old ~= B738DR_autopilot_autothr_arm_pos then
				if B738DR_autopilot_autothr_arm_pos == 1 then
					at_mode = 2
				end
			end
			r_delta_alt = simDR_altitude_pilot + 650
			if B738DR_mcp_alt_dial > r_delta_alt then
				simDR_ap_altitude_dial_ft = B738DR_mcp_alt_dial
			else
				simDR_ap_altitude_dial_ft = 0	-- ignored MCP alt dial
			end
			simDR_ap_vvi_dial = B738DR_vnav_vvi
			if simDR_autopilot_altitude_mode ~= 4 then
				simCMD_autopilot_vs_sel:once()
			end
		end
	end
	
end


function B738_bellow_400ft()
	if simDR_radio_height_pilot_ft > 410 then
		bellow_400ft = 0
	end
	if simDR_radio_height_pilot_ft < 390 then
		bellow_400ft = 1
	end
end


--- CUSTOM AUTOLAND

function annun_flare()
	B738DR_single_ch_status = 0		-- SINGLE CH off
	B738DR_flare_status = 1			-- FLARE armed
	B738DR_rollout_status = 1
	ap_roll_mode = 9
end

function ils_test_off()
	ils_test_on = 0
	ils_test_ok = 1
end

function ap_at_off()

	simCMD_autothrottle_discon:once()	-- disconnect autothrotle
	B738DR_autopilot_autothrottle_status = 0
	B738DR_autopilot_autothr_arm_pos = 0
	at_mode = 0
	at_on_first = 0
	--at_mode_eng = 0
	--at_on_first = 0

end



function B738_adjust_flare()

	local flare_vvi = simDR_vvi_fpm_pilot
	local flare_delta_vvi = flare_vvi - flare_vvi_old
	
	vvi_trend = flare_vvi + (6.5 * flare_delta_vvi)	--2 secs
	if flare_vvi > -580 and vvi_trend > -400 then
		fd_target = 2.2
	end
	flare_vvi_old = flare_vvi

end

function B738_ap_autoland()
	local delta_vvi = 0.0
	local vvi_dial_act = 0
	local vvi_dial_trg = 0
	local ra_thrshld = 0
	local ra_fdpitch = 0
	
	if B738DR_flare_status == 1 then		-- if FLARE armed
		
		if at_on_old ~= B738DR_autopilot_autothr_arm_pos then
			if B738DR_autopilot_autothr_arm_pos == 1 then
				at_mode = 2
			end
		end
		
		if simDR_radio_height_pilot_ft < 250 then	-- at 250/  500 /100 ft stabilized
			
			if vorloc_only == 0 then
				simCMD_autopilot_lnav:once()	-- A/P mode VOR/LOC
				simCMD_autopilot_lnav:once()	-- A/P mode VOR/LOC
				fd_cur = simDR_fdir_pitch
				simDR_fdir_pitch_ovr = 1
				B738DR_autopilot_alt_mode_pfd = 8	-- PFD ALT mode: G/S
				vorloc_only = 1
				simDR_fdir_pitch = fd_cur
			end
			if simDR_radio_height_pilot_ft > 100 then	--120 90 120 150
				simDR_fdir_pitch_ovr = 0
				if simDR_autopilot_altitude_mode ~= 4 then
					simDR_ap_vvi_dial = simDR_vvi_fpm_pilot
					simCMD_autopilot_vs_sel:once()
				end
				vvi_dial_trg = -800		--850, 800 780
				vvi_dial_act = simDR_ap_vvi_dial
				simDR_ap_vvi_dial = B738_set_anim_value(vvi_dial_act, vvi_dial_trg, -1000, -550, 0.5)
				fd_cur = simDR_fdir_pitch
			else
				if simDR_autopilot_altitude_mode == 4 and (simDR_vvi_fpm_pilot < -900 or simDR_vvi_fpm_pilot > -700) then
					vvi_dial_trg = -800		--850, 800 780
					vvi_dial_act = simDR_ap_vvi_dial
					simDR_ap_vvi_dial = B738_set_anim_value(vvi_dial_act, vvi_dial_trg, -1000, -550, 0.5)
					fd_cur = simDR_fdir_pitch
				else
					if simDR_autopilot_altitude_mode == 4 then
						simCMD_autopilot_vs_sel:once()
						simDR_ap_vvi_dial = 0
					end
					simDR_fdir_pitch_ovr = 1
					simDR_fdir_pitch = fd_cur
				end
			end
		end
		
		B738DR_pitch_last = simDR_fdir_pitch
		B738DR_vvi_last = simDR_vvi_fpm_pilot	-- touch down vvi
		
		-- rate of descent in fpm = tan(glideslope) * (speed in knots * 6076 / 60)
		ra_fdpitch = math.min(2.5, simDR_fdir_pitch)
		ra_fdpitch = math.max(0, simDR_fdir_pitch)
		--ra_thrshld = B738_rescale(0, 78, 2.5, 68, ra_fdpitch)
		ra_thrshld = B738_rescale(0, 78, 2.5, 68, ra_fdpitch)	--72/62
		if simDR_airspeed_pilot > 134 then		--134
			ra_thrshld = ra_thrshld - (1.5 * (simDR_airspeed_pilot - 134))		--1.5 / 135
		end
		if ra_thrshld < 50 then
			ra_thrshld = 50
		end
		if ra_thrshld > 68 then
			ra_thrshld = 68
		end
		--ra_thrshld = B738_rescale(0, 78, 2.5, 68, ra_fdpitch)
		if simDR_radio_height_pilot_ft < ra_thrshld then -- 63, 43 -- at 50 ft FLARE
			simDR_fdir_pitch_ovr = 1
			B738DR_flare_status = 2			-- FLARE engaged
			B738DR_rollout_status = 2		-- ROLLOUT engaged
			rudder_out = simDR_control_hdg_ratio
			fd_cur = simDR_fdir_pitch
			--vvi = simDR_vvi_fpm_pilot
			throttle = eng1_N1_thrust_cur
			if B738DR_autopilot_autothr_arm_pos == 1 and at_mode ~= 0 then
				simDR_autothrottle_enable = 0
				at_mode = 6
				at_mode_eng = 6
				eng1_N1_thrust_trg = throttle
				eng2_N1_thrust_trg = throttle
			end

			delta_vvi = -B738DR_vvi_last
			delta_vvi = math.max(580, delta_vvi)
			delta_vvi = math.min(1000, delta_vvi)
			
			--fd_target = fd_cur + B738_rescale(580, 2.8, 1000, 6.5, delta_vvi)	-- 3.0 / 6.5
			--fd_target = fd_cur + B738_rescale(580, 3.0, 1000, 6.5, delta_vvi)	-- 3.0 / 6.5
			fd_target = fd_cur + B738_rescale(580, 3.2, 1000, 6.1, delta_vvi)	-- 3.0 / 6.5
			
			if fd_target < 2 then
				fd_target = 2			-- minimum FLARE pitch
			end
			if fd_target < fd_cur then		-- minimum nose up
				fd_target = fd_cur + 2
			end
			if fd_target > 7 then		-- maximum nose up
				fd_target = 7
			end
			flare_vvi_old = simDR_vvi_fpm_pilot
			if is_timer_scheduled(B738_adjust_flare) == false then
				run_at_interval(B738_adjust_flare, 0.5)	--0.3)
			end
			--B738DR_flare_ratio = B738_rescale(580, 3.4, 1000, 5.9, delta_vvi)		-- 3.2 / 5.9
			--B738DR_flare_ratio = B738_rescale(0, 5.9, 2.5, 3.4, ra_fdpitch)
			B738DR_flare_ratio = B738_rescale(0, 6.1, 2.5, 4.2, ra_fdpitch)		--6.1 / 3.8
		end
-----------------------------------------------------------------------
		
		
	end
	
	if B738DR_flare_status == 2 then		-- if FLARE engaged
	
		B738DR_autopilot_alt_mode_pfd = 0	-- PFD ALT mode: blank
		if fd_target < 2 then
			fd_target = 2
		end
		if fd_target > 7 then
			fd_target = 7
		end
		
		if simDR_radio_height_pilot_ft < 10 then
			fd_target = 0
			fd_cur = B738_set_anim_value(fd_cur, fd_target, -20, 20, 0.5)		-- 4
		else
			fd_cur = B738_set_anim_value(fd_cur, fd_target, -20, 20, B738DR_flare_ratio)	--rate 0.5, 0.33 0.43
		end
		
		if simDR_radio_height_pilot_ft < 23 or simDR_vvi_fpm_pilot > -40 then	--23
			throttle = throttle - (0.8 * SIM_PERIOD)	--B738DR_thrust_ratio_1
		end
		if throttle <= 0 or simDR_radio_height_pilot_ft < 15 then		--15
			throttle = 0
		end
		simDR_fdir_pitch = fd_cur
		B738DR_pfd_spd_mode = PFD_SPD_RETARD
		
		B738DR_vvi_last = simDR_vvi_fpm_pilot	-- touch down vvi

		if at_mode ~= 0 then
			if B738DR_autopilot_autothr_arm_pos == 1 then
				eng1_N1_thrust_trg = throttle
				eng2_N1_thrust_trg = throttle
			end
		end
		
	end
-----------------------------------------------------------------------
	local hdg_target = 0
	local relative_brg = 0
	local relative_brg2 = 0
	local hdg_err = 0
	local hdg_spd = 0
	
	if B738DR_rollout_status == 2 then
		if simDR_nav1_hdef_pilot ~= nil then
			if simDR_nav1_hdef_pilot < -0.20 then
				relative_brg2 = -0.20
			elseif simDR_nav1_hdef_pilot > 0.20 then
				relative_brg2 = 0.20
			else
				relative_brg2 = simDR_nav1_hdef_pilot
			end
			relative_brg2 = relative_brg2 * 19	--60
			hdg_target = (simDR_nav1_course_pilot + relative_brg2 + 360) % 360
			B738DR_test_test = hdg_ratio
			-------
			relative_brg = (hdg_target - simDR_ahars_mag_hdg + 360) % 360
			if relative_brg > 180 then
				relative_brg = relative_brg - 360
			end
			if relative_brg < -5 then
				hdg_err = -5
			elseif relative_brg > 5 then
				hdg_err = 5
			else
				hdg_err = relative_brg
			end
			hdg_err = hdg_err * 0.5
			rudder_target = hdg_err - hdg_ratio
			rudder_target = rudder_target * SIM_PERIOD * 0.5
			-------
			rudder_target = rudder_out + rudder_target
			if rudder_target < -1 then
				rudder_target = -1
			elseif rudder_target > 1 then
				rudder_target = 1
			end
			hdg_spd = math.min(simDR_airspeed_pilot, 150)
			hdg_spd = math.max(simDR_airspeed_pilot, 120)
			hdg_spd = B738_rescale(120, 5.2, 150, 4.5, hdg_spd)
			rudder_out = B738_set_anim_value(rudder_out * 100, rudder_target * 100, -100, 100, hdg_spd) / 100
			simDR_control_hdg_ratio = rudder_out
		else
			B738DR_rollout_status = 0
		end
	end
-----------------------------------------------------------------------
	if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1 
	or simDR_on_ground_2 == 1 then		-- if aircraft on ground
		if B738DR_autoland_status == 1 then 	-- autoland active
			if B738DR_rollout_status == 1 then
				B738DR_rollout_status = 2
				rudder_out = simDR_control_hdg_ratio
			end
			if B738DR_flare_status ~= 0 then
				if cmd_first == 0 then
					autopilot_cmd_b_status = 0
				else
					autopilot_cmd_a_status = 0
				end
				-- B738DR_autoland_status = 0
				simDR_ap_vvi_dial = 0
				ils_test_enable = 0
				ils_test_on = 0
				B738DR_flare_status = 0
				B738DR_pfd_spd_mode = PFD_SPD_ARM
				vorloc_only = 0
				--ap_roll_mode = 0
				ap_pitch_mode = 0
				if is_timer_scheduled(B738_adjust_flare) == true then
					stop_timer(B738_adjust_flare)
				end
				if at_mode ~= 0 then
					if B738DR_autopilot_autothr_arm_pos == 1 then
						eng1_N1_thrust_trg = 0
						eng2_N1_thrust_trg = 0
					end
				end
			end
			if simDR_airspeed_pilot < 112 then
				B738DR_rollout_status = 0
				ap_roll_mode = 0
				B738DR_autoland_status = 0
			end
			
			-- if cmd_first == 0 then
				-- autopilot_cmd_b_status = 0
			-- else
				-- autopilot_cmd_a_status = 0
			-- end
			-- B738DR_autoland_status = 0
			-- simDR_ap_vvi_dial = 0
			-- ils_test_enable = 0
			-- ils_test_on = 0
			-- B738DR_flare_status = 0
			-- B738DR_pfd_spd_mode = PFD_SPD_ARM
			-- --at_mode = 0
			-- --at_mode_eng = 0
			-- vorloc_only = 0
			-- --ap_roll_mode = 2
			-- ap_roll_mode = 0
			-- ap_pitch_mode = 0
			-- if is_timer_scheduled(B738_adjust_flare) == true then
				-- stop_timer(B738_adjust_flare)
			-- end
			-- if at_mode ~= 0 then
				-- if B738DR_autopilot_autothr_arm_pos == 1 then
					-- eng1_N1_thrust_trg = 0
					-- eng2_N1_thrust_trg = 0
				-- end
			-- end
		end
		if aircraft_was_on_air == 1 then
			aircraft_was_on_air = 0
			if at_mode ~= 4 and at_mode ~= 5 then		-- if aircraft touch down
				if is_timer_scheduled(ap_at_off) == false then
					run_after_time(ap_at_off, 3.0)
				end
			end
		end
	end
--	end
end

function B738_ap_system()
	
	local crs1 = math.floor(simDR_nav1_obs_pilot + 0.5)
	local crs2 = math.floor(simDR_nav1_obs_copilot + 0.5)

	if B738DR_autoland_status == 0 then
		if is_timer_scheduled(B738_adjust_flare) == true then
			stop_timer(B738_adjust_flare)
		end
	elseif B738DR_autoland_status == 1 then
		if at_mode ~= 0 then
			if B738DR_autopilot_autothr_arm_pos == 1 then
				eng1_N1_thrust_trg = throttle
				eng2_N1_thrust_trg = throttle
			end
		end
		if ap_on == 0 or B738DR_autopilot_fd_pos == 0 or B738DR_autopilot_fd_fo_pos == 0 then
			simCMD_disconnect:once()
			simDR_flight_dir_mode = 1
		-- F/D on
			ap_roll_mode_eng = 0
			ap_pitch_mode_eng = 0
			B738DR_ap_spd_interv_status = 0
			autopilot_cmd_a_status = 0
			autopilot_cmd_b_status = 0
			B738DR_autoland_status = 0
			B738DR_flare_status = 0
			B738DR_rollout_status = 0
			B738DR_retard_status = 0
			simDR_ap_vvi_dial = 0
			at_mode = 0
			--at_mode_eng = 0
			vorloc_only = 0
			ils_test_enable = 0
			ils_test_on = 0
		end
	end

	-- automatically disengaged below 350 ft -- NOT CORRECT --
	-- if simDR_radio_height_pilot_ft < 350
	-- and simDR_radio_height_pilot_ft > 250
	-- and B738DR_flare_status == 0 
	-- and ap_on == 1 
	-- and at_mode ~= 4 
	-- and at_mode ~= 5 
	-- and B738DR_flight_phase > 0 then
		-- simDR_flight_dir_mode = 1
			-- -- F/D on only
		-- autopilot_cws_a_status = 0
		-- autopilot_cws_b_status = 0
		-- autopilot_cmd_b_status = 0
		-- autopilot_cmd_a_status = 0
		-- B738DR_single_ch_status = 0
	-- end
	
	if B738DR_autoland_status == 1 
	and simDR_glideslope_status == 2
	and simDR_radio_height_pilot_ft < 1480 	-- 1300 ft
	and ils_test_ok == 1 then
		if B738DR_flare_status == 0 then
			if is_timer_scheduled(annun_flare) == false then
				run_after_time(annun_flare, 1.5)
			end
			--B738DR_flare_status = 1		-- FLARE armed
		end
	end
	
	if simDR_radio_height_pilot_ft > 100 
	and aircraft_was_on_air ==  0 then		-- aircraft above 100 ft RA
		aircraft_was_on_air = 1
	end
	
	if simDR_approach_status == 2
	and ap_on == 1 then
		if simDR_radio_height_pilot_ft < 1500
		and B738DR_autoland_status == 1 then
			if simDR_nav1_freq == simDR_nav2_freq
			and crs1 == crs2 
			and B738DR_autopilot_vhf_source_pos == 0 then
				--if ils_test_ok == 1 then
					--if B738DR_single_ch_status == 1 then
						--if is_timer_scheduled(annun_single_ch) == false then
						--	run_after_time(annun_single_ch, 1.0)
						--end
					--end
					--B738DR_single_ch_status = 0			-- SINGLE CH off
				--end
			else		-- AUTOLAND off
				B738DR_autoland_status = 0
				simDR_ap_vvi_dial = 0
				ils_test_enable = 0
				ils_test_on = 0
				if B738DR_autopilot_side == 0 then
					autopilot_cmd_b_status = 0			-- CMD B light off
				else
					autopilot_cmd_a_status = 0			-- CMD A light off
				end
				B738DR_autopilot_app_status = 1		-- APP light on
				B738DR_flare_status = 0				-- FLARE status off
				B738DR_rollout_status = 0
				B738DR_single_ch_status = 1			-- SINGLE CH on
			end
		else
			if simDR_radio_height_pilot_ft < 1500 and simDR_glideslope_status == 2 then		--ils_test_ok == 0 and 
				B738DR_single_ch_status = 1			-- SINGLE CH on
			end
		end
	else
		if ap_roll_mode == 11 and ap_roll_mode_eng == 11 
		and ap_pitch_mode == 7 and ap_pitch_mode_eng == 7 and ap_on == 1 then
			B738DR_single_ch_status = 1			-- SINGLE CH on
		else
			B738DR_single_ch_status = 0			-- SINGLE CH off
		end
	end
	
	
	if ils_test_enable == 1 and simDR_glideslope_status == 2 
	and simDR_radio_height_pilot_ft < 1480 then
		ils_test_on = 1
		if is_timer_scheduled(ils_test_off) == false then
			run_after_time(ils_test_off, 7.0)
		end
		ils_test_enable = 0
	end
	
	-- flight director to O
	if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1 
	or simDR_on_ground_2 == 1 then		-- if aircraft on ground
		if ap_pitch_mode == 0 or B738DR_autopilot_vnav_arm_pfd == 1 then
			if at_mode < 3 or at_mode > 5 then
				if simDR_fdir_pitch_ovr ~= 1 then 
					simDR_fdir_pitch_ovr = 1
				end
				fd_target = 0
				fd_cur = B738_set_anim_value(fd_cur, fd_target, -20, 20, 3)
				simDR_fdir_pitch = fd_cur
			end
		end
	else
		if simDR_radio_height_pilot_ft < 20 then
			if at_mode < 3 or at_mode > 5 then
				if simDR_fdir_pitch_ovr ~= 0 then
					simDR_fdir_pitch_ovr = 0
				end
			end
		end
	end
	
	-- if autopilot_cmd_b_status == 1 and autopilot_cmd_a_status == 0 then
		-- AP_airspeed = simDR_airspeed_copilot
		-- AP_airspeed_mach = simDR_airspeed_mach_copilot
		-- AP_altitude = simDR_altitude_copilot
	-- else
		-- AP_airspeed = simDR_airspeed_pilot
		-- AP_airspeed_mach = simDR_airspeed_mach_pilot
		-- AP_altitude = simDR_altitude_pilot
	-- end
	if simDR_autopilot_side == 0 or ap_on == 0 then
		AP_airspeed = simDR_airspeed_pilot
		AP_airspeed_mach = simDR_airspeed_mach_pilot
		AP_altitude = simDR_altitude_pilot
	else
		AP_airspeed = simDR_airspeed_copilot
		AP_airspeed_mach = simDR_airspeed_mach_copilot
		AP_altitude = simDR_altitude_copilot
	end
	
end

function vnav_stop()
	
	B738DR_autopilot_vnav_alt_pfd = 0	-- PFD: VNAV ALT
	B738DR_autopilot_vnav_pth_pfd = 0	-- PFD: VNAV PTH
	B738DR_autopilot_vnav_spd_pfd = 0	-- PFD: VNAV SPD
	
	B738DR_ap_spd_interv_status = 0
	vnav_engaged = 0
	vnav_desc_spd = 0
	vnav_desc_protect_spd = 0
	
	if B738DR_autopilot_autothr_arm_pos == 1 then
		-- if B738DR_autopilot_n1_status == 0 then
			-- if at_mode ~= 0 then
				-- at_mode = 2
			-- end
		-- else
			-- at_mode = 1
		-- end
		if at_mode ~= 2 then --or at_mode_eng ~= 2 then
			if B738DR_autopilot_n1_status == 1 then
				at_mode = 1
			elseif simDR_autothrottle_enable == 1 then	-- speed off
				at_mode = 2
			else
				at_mode = 0
			end
		end
	end

	
end


function B738_ap_logic()

	local delta_alt = 0
	local altitude_dial = 0
	local airspeed_dial = 0
	local alt_x = 0
	local thrust = 0
	local allign_ok = 0

	if simDR_flight_dir_mode == 0 then
		autopilot_cmd_a_status = 0
		autopilot_cmd_b_status = 0
		B738DR_autopilot_cws_a_status = 0
		B738DR_autopilot_cws_b_status = 0
		ap_roll_mode_eng = 0
		ap_pitch_mode_eng = 0
		simDR_flight_dir_mode = 1
		simDR_airspeed_dial = mem_airspeed_dial
		-- if mem_speed_mode == 1 
		-- and B738DR_autopilot_autothr_arm_pos == 1 then
			-- simDR_autothrottle_enable = 1
		-- end
	end
	mem_airspeed_dial = simDR_airspeed_dial
	mem_speed_mode = simDR_autothrottle_status
	if B738DR_autoland_status == 1 			-- AUTOLAND
	or ap_pitch_mode == 5 					-- VNAV
	or ap_pitch_mode == 2					-- LVL CHG
	or ap_pitch_mode == 6 					-- ALT ACQ
	or ap_pitch_mode == 7 then				-- G/P
		B738DR_vvi_dial_show = 0
	else
		if simDR_ap_vvi_dial == 0 then
			B738DR_vvi_dial_show = 0
		else
			B738DR_vvi_dial_show = 1
		end
	end
	
	
	if autopilot_cmd_a_status == 1 or autopilot_cmd_b_status == 1 then
		ap_on = 1
	else
		ap_on = 0
		cmd_first = 0
		ap_app_block = 0
		ils_test_enable = 0
		ils_test_on = 0
		ils_test_ok = 0
	end
	
	if ap_on == 0 then
		simDR_ap_altitude_dial_ft = B738DR_mcp_alt_dial
	else
		if B738DR_autopilot_vnav_status ~= 1 and ap_pitch_mode_eng ~= 7 then 
			simDR_ap_altitude_dial_ft = B738DR_mcp_alt_dial
		end
	end
	
	B738DR_mcp_speed_dial = simDR_airspeed_dial
	B738DR_mcp_speed_dial_kts = simDR_airspeed_dial_kts
	
	if simDR_autopilot_altitude_mode == 6 then
		if simDR_autopilot_altitude_mode ~= altitude_mode_old then
			B738DR_alt_hold_mem = simDR_ap_altitude_dial_ft
		end
	else
		B738DR_alt_hold_mem = 0
	end
	-- altitude_mode_old = simDR_autopilot_altitude_mode
	
	-- IRS allign
	if B738DR_irs_left_mode > 1 or B738DR_irs_right_mode > 1 then
		allign_ok = 1
	end
	if allign_ok == 0 then
		ap_roll_mode = 0
	end
	
	if B738DR_vnav_disconnect == 1 then
		B738DR_vnav_disconnect = 0
		if ap_pitch_mode == 5 then
			ap_pitch_mode = 0
		end
	end
	if B738DR_lnav_disconnect == 1 then
		B738DR_lnav_disconnect = 0
		if (ap_roll_mode > 3 and ap_roll_mode < 7) or ap_roll_mode == 8 or ap_roll_mode == 13 then
			ap_roll_mode = 0
		end
	end
	
	roll_mode_old = ap_roll_mode_eng
	pitch_mode_old = ap_pitch_mode_eng
	
	
	if ap_roll_mode ~= ap_roll_mode_eng then
		
		-- ROLL MODES: 0-off, 1-HDG SEL, 2-VOR/LOC, 3-APP, 4-LNAV
		if ap_roll_mode == 0 then
			ap_roll_mode_eng = 0
			if simDR_approach_status > 0 then
				simCMD_autopilot_app:once()
				if ap_pitch_mode == 4 then
					ap_pitch_mode = 0
				end
			end
			if simDR_nav_status > 0 then
				simCMD_autopilot_lnav:once()
				if autopilot_fms_nav_status == 1 and ap_pitch_mode == 7 then
					ap_pitch_mode = 0
				end
			end
			if simDR_autopilot_heading_mode == 1 then
				simCMD_autopilot_hdg:once()		-- HDG off
			end
			autopilot_fms_nav_status = 0
			B738DR_gp_status = 0
			ap_roll_mode_old2 = 0
			-- simDR_nav1_obs_pilot = B738DR_course_pilot
			-- simDR_nav1_obs_copilot = B738DR_course_copilot
			--vnav_stop()
		
		-- HDG mode
		elseif ap_roll_mode == 1 then
			ap_roll_mode_eng = 1
			if simDR_approach_status > 0 then
				simCMD_autopilot_app:once()
				if ap_pitch_mode == 4 then
					ap_pitch_mode = 0
				end
			end
			if simDR_nav_status > 0 then			-- if VOR LOC or LNAV
				simCMD_autopilot_lnav:once()			-- VOR LOC, LNAV off
				simDR_autopilot_source = 0
				simDR_autopilot_fo_source = 0
			end
			--vnav_stop()
			if simDR_autopilot_heading_mode ~= 1 then
				simCMD_autopilot_hdg:once()
			end
			autopilot_fms_nav_status = 0
			-- simDR_nav1_obs_pilot = B738DR_course_pilot
			-- simDR_nav1_obs_copilot = B738DR_course_copilot
		
		-- VOR/LOC mode
		elseif ap_roll_mode == 2 then
			
			if simDR_approach_status > 0 then
				simCMD_autopilot_app:once()
				if ap_pitch_mode == 4 then
					ap_pitch_mode = 0
				end
			end
			if simDR_nav_status == 0 then
				simCMD_autopilot_lnav:once()			-- VOR LOC on
			end
			
			if ap_roll_mode_eng == 4 then
				ap_roll_mode = 5
				ap_roll_mode_eng = 5
			else
				ap_roll_mode_eng = 2
				if at_mode ~= 2 then
					if B738DR_autopilot_autothr_arm_pos == 1 then
						at_mode = 2		-- SPEED on
						--at_mode_eng = 20
					end
				end
			end
			
		
		-- APP mode
		elseif ap_roll_mode == 3 then
			
			if B738DR_fms_ils_disable == 0 then
				-- if simDR_approach_status == 0 then
					-- simCMD_autopilot_app:once()
				-- end
				if simDR_approach_status > 0 then
					simCMD_autopilot_app:once()
				end
				if simDR_nav_status == 0 then
					simCMD_autopilot_lnav:once()			-- VOR LOC on
				end
				if ap_roll_mode_eng == 4 then
					ap_roll_mode = 6
					ap_roll_mode_eng = 6
				else
					ap_roll_mode_eng = 3	-- APP
					if at_mode ~= 2 then
						if B738DR_autopilot_autothr_arm_pos == 1 then
							at_mode = 2		-- SPEED on
						end
					end
				end
			else
				if simDR_approach_status > 0 then
					simCMD_autopilot_app:once()
				end
				if simDR_nav_status > 0 then
					simCMD_autopilot_lnav:once()
				end
				
				local fac_enable = 0
				if autopilot_cmd_a_status == 1 then
					if B738DR_nd_fac_horizontal == 1 then
						fac_enable = 1
					end
				elseif autopilot_cmd_b_status == 1 then
					if B738DR_nd_fac_horizontal_fo == 1 then
						fac_enable = 1
					end
				else
					if B738DR_nd_fac_horizontal == 1 then
						fac_enable = 1
					end
				end
				
				if ap_roll_mode_eng == 1 then
					if fac_enable == 0 then
						ap_roll_mode = 12	-- HDG/LOC arm GP
						ap_roll_mode_eng = 12
						simCMD_autopilot_lnav:once()
						if simDR_nav_status == 0 then
							ap_roll_mode = 0
						end
					else
						ap_roll_mode = 7	-- HDG/FAC arm
						ap_roll_mode_eng = 7
					end
				elseif ap_roll_mode_eng == 4 then
					if fac_enable == 0 then
						ap_roll_mode = 13	-- LNAV/LOC arm GP
						ap_roll_mode_eng = 13
						simCMD_autopilot_lnav:once()
						if simDR_nav_status == 0 then
							ap_roll_mode = 0
						end
					else
						ap_roll_mode = 8	-- LNAV/FAC arm
						ap_roll_mode_eng = 8
					end
				else
					if fac_enable == 0 then
						ap_roll_mode = 14	-- LOC GP
						ap_roll_mode_eng = 14
						simCMD_autopilot_lnav:once()
					else
						ap_roll_mode = 11	-- FAC
						ap_roll_mode_eng = 11
					end
					if B738DR_autopilot_autothr_arm_pos == 1 then
						at_mode = 2		-- SPEED on
					end
				end
			end
			
		-- LNAV mode
		elseif ap_roll_mode == 4 then
			if simDR_approach_status > 0 then
				simCMD_autopilot_app:once()
				simCMD_autopilot_app:once()
				if ap_pitch_mode == 4 then
					ap_pitch_mode = 0
				end
			end
			if simDR_nav_status > 0 then
				simCMD_autopilot_lnav:once()
			end
			if ap_roll_mode_eng == 1 then
				ap_roll_mode = 10		-- HDG/LNAV
				ap_roll_mode_eng = 10
			else
				ap_roll_mode_eng = 4	-- LNAV
			end
		
		-- ROLLOUT
		elseif ap_roll_mode == 9 then
			ap_roll_mode_eng = 9
		end
	
	end

	if fac_engaged == 1 then
		if B738DR_pfd_gp_path == 0 then
			--B738DR_gp_status = 0
			B738DR_gp_status = 1
			if ap_pitch_mode == 7 then
				ap_pitch_mode = 0
			end
		else
			if B738DR_gp_err_pfd < 100 and B738DR_gp_err_pfd > -200 then
				ap_pitch_mode = 7	-- FAC G/P
				B738DR_gp_status = 2
			else
				B738DR_gp_status = 1
			end
		end
	elseif loc_gp_engaged == 1 then
		if B738DR_pfd_gp_path == 0 then
			--B738DR_gp_status = 0
			B738DR_gp_status = 1
			if ap_pitch_mode == 7 then
				ap_pitch_mode = 0
			end
		else
			if B738DR_gp_err_pfd < 100 and B738DR_gp_err_pfd > -200 then
				ap_pitch_mode = 7	-- LOC G/P
				B738DR_gp_status = 2
			else
				B738DR_gp_status = 1
			end
		end
	elseif ap_roll_mode == 7 and ap_roll_mode_eng == 7 then	-- HDG/FAC
		B738DR_gp_status = 1
	elseif ap_roll_mode == 8 and ap_roll_mode_eng == 8 then	-- LNAV/FAC
		B738DR_gp_status = 1
	elseif ap_roll_mode == 12 and ap_roll_mode_eng == 12 then	-- HDG/LOC GP
		B738DR_gp_status = 1
	elseif ap_roll_mode == 13 and ap_roll_mode_eng == 13 then	-- LNAV/LOC GP
		B738DR_gp_status = 1
	else
		B738DR_gp_status = 0
		if ap_pitch_mode_eng == 7 then
			ap_pitch_mode = 0
		end
	end
	
	if B738DR_autoland_status == 0 then
		-- --if ap_roll_mode_eng == 3 then	-- APP
		-- if simDR_approach_status == 2 then
			-- if ap_pitch_mode_eng ~= 4 and simDR_glideslope_status == 2 then 	-- G/S engaged
				-- ap_roll_mode = 3
				-- ap_roll_mode_eng = 3
				-- ap_pitch_mode = 4
				-- lnav_engaged = 0
			-- end
		-- -- else
			-- -- if ap_roll_mode_eng ~= 6 and simDR_glideslope_status > 0 then	-- LNAV/APP
				-- -- ap_pitch_mode = 0
			-- -- end
		-- end
		
		if ap_roll_mode_eng == 3 or ap_roll_mode_eng == 6 then
			if simDR_nav_status == 2 and simDR_approach_status == 0 then
				simCMD_autopilot_app:once()
				ap_roll_mode = 3
				ap_roll_mode_eng = 3
				lnav_engaged = 0
			end
		end
		if simDR_approach_status == 2 then
			if ap_pitch_mode_eng ~= 4 and simDR_glideslope_status == 2 then 	-- G/S engaged
				ap_pitch_mode = 4
			end
		end
		
	end
	
	if ap_pitch_mode ~= ap_pitch_mode_eng then
		
		-- PITCH MODES: 0-off, 1-V/S, 2-LVL CHG, 3-ALT HLD, 4-G/S, 5-VNAV, 6-ALT ACQ, 7-RNAV G/P
		if ap_pitch_mode == 0 then --and ap_pitch_mode_eng ~= 0 then
			ap_pitch_mode_eng = 0
			-- if ap_on == 1 then
				-- ----simDR_throttle_override = 0
			-- end
			if simDR_autopilot_altitude_mode == 6 then
				simCMD_autopilot_alt_hold:once()	-- ALT HLD , ALT ACQ off
			elseif simDR_autopilot_altitude_mode == 5 then
				simCMD_autopilot_lvl_chg:once()		-- LVL CHG off
			elseif simDR_autopilot_altitude_mode == 4 then
				simCMD_autopilot_vs:once()			-- V/S off
			end
			vnav_stop()
			--B738DR_gp_status = 0
		
		elseif ap_pitch_mode == 1 then --and ap_pitch_mode_eng ~= 1 then		-- V/S
			ap_pitch_mode_eng = 1
			fd_goaround = 0
			vnav_stop()
			if B738DR_gp_status == 2 and ap_roll_mode == 11 then
				ap_roll_mode = 0
			end
			if simDR_autopilot_altitude_mode ~= 4 then
				if simDR_ap_vvi_dial ~= 0 then
					simCMD_autopilot_vs_sel:once()
					vert_spd_corr()
				else
					simCMD_autopilot_vs:once()
					vert_spd_corr()
				end
			else
				--simDR_ap_vvi_dial = roundDownToIncrement(simDR_ap_vvi_dial, 100 )
				vert_spd_corr()
			end
			if B738DR_autopilot_autothr_arm_pos == 1 then
				----simDR_throttle_override = 0
				at_mode = 2		-- SPEED on
				--at_mode_eng = 20
			end
		
		elseif ap_pitch_mode == 2 then --and ap_pitch_mode_eng~= 2 then	-- LVL CHG
			ap_pitch_mode_eng = 2
			vnav_stop()
			if B738DR_gp_status == 2 and ap_roll_mode == 11 then
				ap_roll_mode = 0
			end
			vnav_vs = 0
			init_climb = 0
			lvl_chg_co_status = 0
			lvl_chg_vs = 0
				airspeed_dial = simDR_airspeed_dial
				if simDR_ap_altitude_dial_ft < simDR_altitude_pilot then
					delta_alt = simDR_altitude_pilot - simDR_ap_altitude_dial_ft
					if delta_alt > 200 then
						delta_alt = at_mode
						B738DR_lvl_chg_mode = 0		-- descent
						if simDR_autopilot_altitude_mode ~= 5 then
							simCMD_autopilot_lvl_chg:once()
							if simDR_on_ground_0 == 0 and simDR_on_ground_1 == 0 and simDR_on_ground_2 == 0 then
								simDR_airspeed_dial = airspeed_dial
							end
						end
						
						if B738DR_fd_on == 0 then
						
							if B738DR_autopilot_autothr_arm_pos == 1 then
								at_mode = delta_alt
								at_mode_eng = 20
							end
	--								----simDR_throttle_override = 0
							-- if ----simDR_throttle_override == 0 then
								-- --simDR_throttle_all = thrust
							-- else
								-- eng1_N1_thrust_trg = thrust
								-- eng2_N1_thrust_trg = thrust
							-- end
	--								eng1_N1_thrust_trg = 0.0
	--								eng2_N1_thrust_trg = 0.0
							
						else
							if B738DR_autopilot_autothr_arm_pos == 0 then
								at_mode = delta_alt
								at_mode_eng = 20
							else
								at_mode = 6
							end
						end
						
					else
						ap_pitch_mode = 3
					end
				end
				if simDR_ap_altitude_dial_ft > simDR_altitude_pilot then
					delta_alt = simDR_ap_altitude_dial_ft - simDR_altitude_pilot
					if delta_alt > 200 then
						delta_alt = at_mode
						B738DR_lvl_chg_mode = 1		-- climb
						if simDR_autopilot_altitude_mode ~= 5 then
							simCMD_autopilot_lvl_chg:once()
							if simDR_on_ground_0 == 0 and simDR_on_ground_1 == 0 and simDR_on_ground_2 == 0 then
								simDR_airspeed_dial = airspeed_dial
							end
						end
						
						if B738DR_fd_on == 0 then
							if B738DR_autopilot_autothr_arm_pos == 1 then
								at_mode = delta_alt
								at_mode_eng = 20
							end
--							----simDR_throttle_override = 0
							-- if ----simDR_throttle_override == 0 then
								-- --simDR_throttle_all = thrust
							-- else
								-- eng1_N1_thrust_trg = thrust
								-- eng2_N1_thrust_trg = thrust
							-- end
	--								eng1_N1_thrust_trg = 0.0
	--								eng2_N1_thrust_trg = 0.0
						else
							if B738DR_autopilot_autothr_arm_pos == 0 then
								at_mode = delta_alt
								at_mode_eng = 20
							else
								at_mode = 6
							end
						end
						
					else
						ap_pitch_mode = 3
					end
				end
			--end
		
		elseif ap_pitch_mode == 3 then --and ap_pitch_mode_eng ~= 3 then	-- ALT HLD
			ap_pitch_mode_eng = 3
			fd_goaround = 0
			vnav_stop()
			if B738DR_gp_status == 2 and ap_roll_mode == 11 then
				ap_roll_mode = 0
			end
			-- if simDR_autopilot_altitude_mode ~= 6 then
				-- simCMD_autopilot_alt_hold:once()
			-- end
			-- simDR_ap_altitude_dial_ft = roundUpToIncrement(simDR_altitude_pilot, 100 )
			-- B738DR_mcp_alt_dial = simDR_ap_altitude_dial_ft
			altitude_dial_ft_old = simDR_ap_altitude_dial_ft
			simDR_ap_vvi_dial = 0
			if B738DR_autopilot_autothr_arm_pos == 1 then
				at_mode = 2		-- SPEED on
			end
		
		elseif ap_pitch_mode == 4 then --and ap_pitch_mode_eng ~= 4 then	-- G/S (APP)
			ap_pitch_mode_eng = 4
			fd_goaround = 0
			vnav_stop()
			simDR_ap_vvi_dial = 0
			B738DR_retard_status = 0				-- PFD: no RETARD
			B738DR_autopilot_n1_pfd = 0				-- PFD: no N1
			if B738DR_autopilot_autothr_arm_pos == 1 then
				at_mode = 2		-- SPEED on
			end
		
		elseif ap_pitch_mode == 5 then --and ap_pitch_mode_eng ~= 5 then	-- VNAV
			ap_pitch_mode_eng = 5
			if B738DR_gp_status == 2 and ap_roll_mode == 11 then
				ap_roll_mode = 0
			end
			fd_goaround = 0
			vnav_descent = 0
			vnav_cruise = 0
			init_climb = 0
			vnav_descent_disable = 0
			vnav_init = 0
			vnav_init2 = 1
			vnav_alt_hold = 0
			vnav_alt_hold_act = 0
			vnav_engaged = 0
			rest_wpt_alt_idx_old = 0
			mcp_alt_hold = 99999
			
			-- if B738DR_flight_phase > 4 and B738DR_flight_phase < 8 and simDR_autopilot_altitude_mode == 6 then
				-- if B738DR_rest_wpt_alt == simDR_altitude_pilot then
					-- mcp_alt_hold = 0
					-- vnav_alt_hold = simDR_altitude_pilot
				-- end
			-- end
			
			if simDR_altitude_pilot < 26000 then
				if simDR_airspeed_is_mach == 1 then
					simCMD_autopilot_co:once()
				end
			end
			
		elseif ap_pitch_mode == 6 then --and ap_pitch_mode_eng ~= 6 then	-- ALT ACQ
			ap_pitch_mode_eng = 6
			fd_goaround = 0
			vnav_stop()
			if B738DR_gp_status == 2 and ap_roll_mode == 11 then
				ap_roll_mode = 0
			end
			if B738DR_fd_on == 1 then
				if simDR_autopilot_altitude_mode ~= 6 then
					altitude_dial = simDR_altitude_pilot 
					simCMD_autopilot_alt_hold:once()
					simDR_ap_altitude_dial_ft = altitude_dial
				end
				----simDR_throttle_override = 0
				B738DR_retard_status = 0				-- PFD: no RETARD
				B738DR_autopilot_n1_pfd = 0				-- PFD: no N1
			-- else
				-- if simDR_autopilot_altitude_mode ~= 6 then
					-- simCMD_autopilot_alt_hold:once()
				-- end
			else
				ap_pitch_mode = 0
			end
			if B738DR_autopilot_autothr_arm_pos == 1 then
				at_mode = 2		-- SPEED on
				--at_mode_eng = 20
			end
		elseif ap_pitch_mode == 7 then --and ap_pitch_mode_eng ~= 7 then		-- G/P
			ap_pitch_mode_eng = 7
			fd_goaround = 0
			vnav_stop()
			--B738DR_gp_status = 2	-- G/P armed
			--if ap_on == 1 then
			if B738DR_autopilot_autothr_arm_pos == 1 then
				----simDR_throttle_override = 0
				at_mode = 2		-- SPEED on
				--at_mode_eng = 20
			end
			-- if simDR_autopilot_altitude_mode ~= 4 then
				-- simCMD_autopilot_vs_sel:once()
				-- if ap_on == 1 then
					-- at_mode = 2		-- SPEED on
				-- end
			-- end
		end
		
		
	
	end
	


	-- AUTOPILOT BUTTONS LIGHTS
	if ap_roll_mode == 0 then
		B738DR_autopilot_hdg_sel_status = 0
		B738DR_autopilot_vorloc_status = 0
		B738DR_autopilot_app_status = 0
		B738DR_autopilot_lnav_status = 0
		autopilot_fms_nav_status = 0
	elseif ap_roll_mode == 1 then	-- HDG
		B738DR_autopilot_hdg_sel_status = 1
		B738DR_autopilot_vorloc_status = 0
		B738DR_autopilot_app_status = 0
		B738DR_autopilot_lnav_status = 0
		autopilot_fms_nav_status = 0
	elseif ap_roll_mode == 2 then	-- VOR/LOC
		if simDR_nav_status == 2 then
			B738DR_autopilot_hdg_sel_status = 0
		end
		B738DR_autopilot_vorloc_status = 1
		B738DR_autopilot_app_status = 0
		B738DR_autopilot_lnav_status = 0
		autopilot_fms_nav_status = 0
	elseif ap_roll_mode == 3 then	-- APP
		if B738DR_autoland_status == 1 then
			if simDR_glideslope_status == 2 
			or vorloc_only == 1 then
				B738DR_autopilot_app_status = 0		-- turn off APP light status
			end
		elseif ap_pitch_mode == 4 and ap_on == 1 then
			B738DR_autopilot_app_status = 0		-- turn off APP light status
		else
			B738DR_autopilot_app_status = 1
		end
		if simDR_approach_status == 2 then
			B738DR_autopilot_hdg_sel_status = 0
		end
		B738DR_autopilot_vorloc_status = 0
		B738DR_autopilot_lnav_status = 0
		autopilot_fms_nav_status = 0
	elseif ap_roll_mode == 4 then	-- LNAV
		B738DR_autopilot_hdg_sel_status = 0
		B738DR_autopilot_vorloc_status = 0
		B738DR_autopilot_app_status = 0
		B738DR_autopilot_lnav_status = 1
		--autopilot_fms_nav_status = 1
	elseif ap_roll_mode == 5 then	-- LNAV / VOR LOC
		B738DR_autopilot_hdg_sel_status = 0
		B738DR_autopilot_vorloc_status = 1
		B738DR_autopilot_app_status = 0
		B738DR_autopilot_lnav_status = 1
		--autopilot_fms_nav_status = 1
	elseif ap_roll_mode == 6 then	-- LNAV / APP
		B738DR_autopilot_hdg_sel_status = 0
		B738DR_autopilot_vorloc_status = 0
		B738DR_autopilot_app_status = 1
		B738DR_autopilot_lnav_status = 1
		--autopilot_fms_nav_status = 1
	elseif ap_roll_mode == 7 then	-- HDG / FAC
		B738DR_autopilot_hdg_sel_status = 1
		B738DR_autopilot_vorloc_status = 0
		B738DR_autopilot_app_status = 1
		B738DR_autopilot_lnav_status = 0
		--autopilot_fms_nav_status = 1
	elseif ap_roll_mode == 8 then	-- LNAV / FAC
		B738DR_autopilot_hdg_sel_status = 0
		B738DR_autopilot_vorloc_status = 0
		B738DR_autopilot_app_status = 1
		B738DR_autopilot_lnav_status = 1
	elseif ap_roll_mode == 10 then	-- HDG / LNAV arm
		B738DR_autopilot_hdg_sel_status = 1
		B738DR_autopilot_vorloc_status = 0
		B738DR_autopilot_app_status = 0
		B738DR_autopilot_lnav_status = 1
	elseif ap_roll_mode == 11 then	-- FAC
		B738DR_autopilot_hdg_sel_status = 0
		B738DR_autopilot_vorloc_status = 0
		B738DR_autopilot_app_status = 1
		B738DR_autopilot_lnav_status = 0
	elseif ap_roll_mode == 12 then	-- HDG / LOC arm GP
		B738DR_autopilot_hdg_sel_status = 1
		B738DR_autopilot_vorloc_status = 0
		B738DR_autopilot_app_status = 1
		B738DR_autopilot_lnav_status = 0
	elseif ap_roll_mode == 13 then	-- LNAV / LOC arm GP
		B738DR_autopilot_hdg_sel_status = 0
		B738DR_autopilot_vorloc_status = 0
		B738DR_autopilot_app_status = 1
		B738DR_autopilot_lnav_status = 1
	elseif ap_roll_mode == 14 then	-- LOC GP
		B738DR_autopilot_hdg_sel_status = 0
		B738DR_autopilot_vorloc_status = 0
		B738DR_autopilot_app_status = 1
		B738DR_autopilot_lnav_status = 0
	end

	if ap_pitch_mode == 0 then
		B738DR_autopilot_vs_status = 0
		B738DR_autopilot_lvl_chg_status = 0
		B738DR_autopilot_alt_hld_status = 0
		B738DR_autopilot_vnav_status = 0
		ap_vnav_status = 0
--		vnav_active = 0
		elseif ap_pitch_mode == 1 then		-- V/S
		B738DR_autopilot_vs_status = 1
		B738DR_autopilot_lvl_chg_status = 0
		B738DR_autopilot_alt_hld_status = 0
		B738DR_autopilot_vnav_status = 0
		ap_vnav_status = 0
--		vnav_active = 0
	elseif ap_pitch_mode == 2 then	-- LVL CHG
		B738DR_autopilot_vs_status = 0
		B738DR_autopilot_lvl_chg_status = 1
		B738DR_autopilot_alt_hld_status = 0
		B738DR_autopilot_vnav_status = 0
		ap_vnav_status = 0
--		vnav_active = 0
	elseif ap_pitch_mode == 3 then	-- ALT HLD
		B738DR_autopilot_alt_hld_status = 1
		B738DR_autopilot_vs_status = 0
		B738DR_autopilot_lvl_chg_status = 0
		B738DR_autopilot_vnav_status = 0
		ap_vnav_status = 0
	elseif ap_pitch_mode == 4 then	-- G/S
		B738DR_autopilot_vs_status = 0
		B738DR_autopilot_lvl_chg_status = 0
		if simDR_glideslope_status == 2 then
			B738DR_autopilot_alt_hld_status = 0
		end
		B738DR_autopilot_vnav_status = 0
		ap_vnav_status = 0
	elseif ap_pitch_mode == 5 then	-- VNAV
		B738DR_autopilot_vnav_status = 1
		if B738DR_autopilot_vnav_status == 1 then
			ap_vnav_status = 2
		else
			ap_vnav_status = 0
		end
		B738DR_autopilot_vs_status = 0
		B738DR_autopilot_lvl_chg_status = 0
		B738DR_autopilot_alt_hld_status = 0
	elseif ap_pitch_mode == 6 then		-- ALT ACQ
		B738DR_autopilot_vs_status = 0
		B738DR_autopilot_lvl_chg_status = 0
		B738DR_autopilot_alt_hld_status = 0
		B738DR_autopilot_vnav_status = 0
		ap_vnav_status = 0
	elseif ap_pitch_mode == 7 then	-- RNAV G/P or LOC G/P
		B738DR_autopilot_vs_status = 0
		B738DR_autopilot_lvl_chg_status = 0
		B738DR_autopilot_alt_hld_status = 0
		B738DR_autopilot_vnav_status = 0
		ap_vnav_status = 0
	end
	
	-- if B738DR_autopilot_lnav_status == 1 then
		-- simDR_autopilot_side = 0
	-- else
		-- if autopilot_cmd_a_status == 1 then
			-- simDR_autopilot_side = 0
		-- elseif autopilot_cmd_b_status == 1 then
			-- simDR_autopilot_side = 1
		-- else
			-- simDR_autopilot_side = 0
		-- end
	-- end
	
	B738DR_altitude_mode = ap_pitch_mode
	B738DR_altitude_mode2 = ap_pitch_mode_eng
	B738DR_heading_mode = ap_roll_mode
	approach_status_old = simDR_approach_status
	glideslope_status_old = simDR_glideslope_status
	ap_pitch_mode_old = ap_pitch_mode_eng
	ap_roll_mode_old = ap_roll_mode_eng
	
	
	
end


function B738_ap_at_disconnect()

	if autopilot_cws_a_status == 1 or autopilot_cws_b_status == 1 then
		cws_on = 1
	else
		cws_on = 0
	end

	local ap_dis_enable = 0
	if ap_on ~= ap_on_first or cws_on ~= cws_on_first then
		if ap_on == 0 and cws_on == 0 then
			-- AP disconect
			ap_dis_enable = 1
		end
	end
	ap_on_first = ap_on
	cws_on_first = cws_on
	
	if B738DR_autopilot_disconnect_pos ~= ap_disco_first then
		if B738DR_autopilot_disconnect_pos == 1 and ap_disco_do == 1 then
			-- AP disconect
			ap_dis_enable = 1
		end
		if B738DR_autopilot_disconnect_pos == 0 then
			ap_disco_do = 0
			ap_dis_enable = 0
			ap_dis_time = 0
		end
	end
	ap_disco_first = B738DR_autopilot_disconnect_pos
	
	local at_dis_enable = 0
	--if B738DR_autopilot_left_at_diseng_pos == 1 or B738DR_autopilot_right_at_diseng_pos == 1 then
	if at_left_press == 1 or at_right_press == 1 then
		at_left_press = 0
		at_right_press = 0
		at_dis_enable = 0
		at_dis_time = 0
	end
	if B738DR_autopilot_autothr_arm_pos ~= at_on_first then
		if B738DR_autopilot_autothr_arm_pos == 0 then
			-- AT disconect
			at_dis_enable = 1
		end
	end
	at_on_first = B738DR_autopilot_autothr_arm_pos
	
	if B738DR_autopilot_disco2 == 1 and ap_disco2 == 0 then
		ap_dis_enable = 0
		ap_dis_time = 0
	end
	if B738DR_ap_light_pilot == 1 or B738DR_ap_light_fo == 1 then
		ap_dis_enable = 0
		ap_dis_time = 0
	end
	if B738DR_at_light_pilot == 1 or B738DR_at_light_fo == 1 then
		at_dis_enable = 0
		at_dis_time = 0
	end
	
	if ap_dis_enable == 1 then
		ap_dis_time = 40	-- 40 * 0.5sec = 20 seconds
	end
	if at_dis_enable == 1 then
		at_dis_time = 40	-- 40 * 0.5sec = 20 seconds
	end

end

function B738_at_logic()
	
	--local airspeed_dial = 0
	local ap_thrust = 0.0
	
	-- AT MODES: 0-off, 1-N1, 2-MCP SPD, 3-Takeoff, 4-A/P GA, 5-F/D GA, 6-LVL CHG speed, 7-VNAV speed, 8-A/P GA after touchdown, 9 - MCP SPD with N1 limit
	
	
	ap_thrust = B738DR_thrust1_leveler - B738DR_thrust2_leveler
	if ap_thrust < 0 then
		ap_thrust = -ap_thrust
	end
	if ap_thrust > 0.1 then
		if B738DR_autopilot_autothr_arm_pos == 1 and autothr_arm_pos == 0 then
			if B738DR_autopilot_autothrottle_status == 1 then
				simCMD_autothrottle_discon:once()	-- disconnect autothrotle
				B738DR_autopilot_autothrottle_status = 0
			end
			B738DR_autopilot_autothr_arm_pos = 0
			at_mode = 0
			at_status = 0
		end
	end
	ap_thrust = 0
	
	if B738DR_autopilot_autothr_arm_pos == 0 then
		at_mode = 0
		B738DR_autopilot_n1_status = 0
	end
	
	if at_mode ~= 0 then
		if B738DR_autopilot_autothr_arm_pos == 1 
		and (simDR_engine_N1_pct1 < 19 or simDR_engine_N1_pct2 < 19) then	-- A/T not working
			at_mode = 0
		end
	end
	
	if at_mode == 0 and at_mode_eng ~= 0 then
		at_mode_eng = 0
		B738DR_autopilot_n1_status = 0
		simDR_autothrottle_enable = 0	-- speed off
		B738DR_autopilot_to_ga_pfd = 0
		B738DR_autopilot_thr_hld_pfd = 0
		B738DR_autopilot_ga_pfd = 0
		at_throttle_hold = 0	-- mode throttle HLD off
		--ap_goaround = 0
		--fd_goaround = 0
		to_after_80kts = 0
		simDR_fdir_pitch_ovr = 0
		fd_go_disable = 0
	-- N1 mode
	elseif at_mode == 1 and at_mode_eng ~= 1 then
		at_mode_eng = 1
		at_throttle_hold = 0	-- mode throttle HLD off
		to_after_80kts = 0
		B738DR_retard_status = 0				-- PFD: no RETARD
		if ap_pitch_mode == 2 
		and simDR_autopilot_altitude_mode == 5 
		and B738DR_fd_on == 1 then
			simCMD_autopilot_lvl_chg:once()		-- LVL CHG off
			ap_pitch_mode = 0
			ap_pitch_mode_eng = 0
		end
			
		ap_goaround = 0
		simDR_fdir_pitch_ovr = 0
		if fd_goaround < 3 then
			fd_goaround = 0
		end
		if B738DR_autopilot_speed_status == 1 then
			simDR_autothrottle_enable = 0	-- speed off
		end
		B738DR_autopilot_n1_status = 1
		eng1_N1_thrust_trg = eng1_N1_thrust	-- N1 THRUST
		eng2_N1_thrust_trg = eng2_N1_thrust	-- N1 THRUST
		B738DR_retard_status = 0
	
		fd_go_disable = 0
	
	-- SPD speed with N1 limit
	elseif at_mode == 2 and at_mode_eng ~= 2 then
		at_mode_eng = 2
		at_throttle_hold = 0	-- mode throttle HLD off
		ap_goaround = 0
		to_after_80kts = 0
		B738DR_retard_status = 0				-- PFD: no RETARD
		B738DR_autopilot_n1_pfd = 0				-- PFD: no N1
		B738DR_autopilot_n1_status = 0
		simDR_fdir_pitch_ovr = 0
		if ap_pitch_mode == 2 
		and simDR_autopilot_altitude_mode == 5 then
			simCMD_autopilot_lvl_chg:once()		-- LVL CHG off
			ap_pitch_mode = 0
			ap_pitch_mode_eng = 0
		end
		if fd_goaround < 3 then
			fd_goaround = 0
		end
		--simDR_autothrottle_enable = 1	-- speed on
		simDR_autothrottle_enable = 0
		fd_go_disable = 0
	
	-- TAKEOFF mode
	elseif at_mode == 3 and at_mode_eng ~= 3 then
		at_mode_eng = 3
		at_throttle_hold = 0	-- mode throttle HLD off
		ap_goaround = 0
		fd_goaround = 0
		ap_pitch_mode_old = ap_pitch_mode_eng
		B738DR_autopilot_n1_status = 0
		simDR_autothrottle_enable = 0	-- speed off
		if ap_roll_mode ~= 1  and ap_roll_mode ~= 10 and ap_roll_mode ~= 4 then
			ap_roll_mode = 1	-- ROLL> HDG mode
		end
		to_thrust_set = 0
		fd_cur = simDR_fdir_pitch
		simDR_fdir_pitch_ovr = 1
		fd_go_disable = 0
	
	-- AP GoAround mode
	elseif at_mode == 4 and at_mode_eng ~= 4 then
		at_mode_eng = 4
		-- at_throttle_hold = 0	-- mode throttle HLD off
		-- fd_goaround = 0
		-- to_after_80kts = 0
		-- simDR_fdir_pitch_ovr = 0
		-- B738DR_autoland_status = 0
		-- B738DR_flare_status = 0
		-- B738DR_rollout_status = 0
		-- B738DR_retard_status = 0
		-- vorloc_only = 0
		-- B738DR_autopilot_n1_status = 0
		-- ap_pitch_mode = 0
		-- ap_pitch_mode_eng = 0
		-- B738DR_pfd_spd_mode = PFD_SPD_GA
		-- B738DR_pfd_alt_mode = PFD_ALT_TO_GA
		-- if simDR_autopilot_altitude_mode ~= 4 then
			-- simCMD_autopilot_vs:once()			-- VS on
			-- vert_spd_corr()
		-- end
		-- simDR_ap_vvi_dial = 1300
		-- simDR_ap_capt_heading = simDR_heading_pilot
		-- if simDR_autopilot_heading_mode == 0 then
			-- simCMD_autopilot_hdg:once()			-- HDG on
		-- end
		-- fd_cur = simDR_fdir_pitch
		-- simDR_fdir_pitch_ovr = 1
		-- if ap_roll_mode ~= 1  and ap_roll_mode ~= 10 and ap_roll_mode ~= 4 then
			-- ap_roll_mode = 1
		-- end
		-- ap_pitch_mode_old = ap_pitch_mode_eng
		-- ap_roll_mode_old = ap_roll_mode_eng
		-- fd_go_disable = 0
	
	-- FD GoAround mode
	elseif at_mode == 5 and at_mode_eng ~= 5 then
		at_mode_eng = 5
		-- at_throttle_hold = 0	-- mode throttle HLD off
		-- ap_pitch_mode = 0
		-- ap_pitch_mode_eng = 0
		-- ap_goaround = 0
		-- to_after_80kts = 0
		-- airspeed_dial = simDR_airspeed_dial
		-- B738DR_retard_status = 0
		-- B738DR_autopilot_n1_pfd = 0
		-- B738DR_autopilot_n1_status = 0
		-- B738DR_pfd_spd_mode = PFD_SPD_GA
		-- B738DR_pfd_alt_mode = PFD_ALT_TO_GA
		-- fd_cur = simDR_fdir_pitch
		-- simDR_fdir_pitch_ovr = 1
		-- if ap_roll_mode ~= 1  and ap_roll_mode ~= 10 and ap_roll_mode ~= 4 then
			-- ap_roll_mode = 1
		-- end
		-- ap_pitch_mode_old = ap_pitch_mode_eng
		-- ap_roll_mode_old = ap_roll_mode_eng
		-- fd_go_disable = 0
	
	-- LVL CHG mode
	elseif at_mode == 6 and at_mode_eng ~= 6 then
		at_mode_eng = 6
		
		at_throttle_hold = 0	-- mode throttle HLD off
		ap_goaround = 0
		to_after_80kts = 0
		simDR_fdir_pitch_ovr = 0
		if fd_goaround < 3 then
			fd_goaround = 0
		end
		simDR_autothrottle_enable = 0	-- speed off
		fd_go_disable = 0
	
	-- VNAV speed
	elseif at_mode == 7 and at_mode_eng ~= 7 then
		at_mode_eng = 7
		at_throttle_hold = 0	-- mode throttle HLD off
		ap_goaround = 0
		to_after_80kts = 0
		simDR_fdir_pitch_ovr = 0
		if fd_goaround < 3 then
			fd_goaround = 0
		end
		simDR_autothrottle_enable = 0	-- speed off
		fd_go_disable = 0
	
	-- AP GoAround mode after touchdown
	elseif at_mode == 8 and at_mode_eng ~= 8 then
		at_mode_eng = 8
		-- at_throttle_hold = 0	-- mode throttle HLD off
		-- fd_goaround = 0
		-- to_after_80kts = 0
		-- ap_pitch_mode = 0
		-- ap_pitch_mode_eng = 0
		-- simDR_fdir_pitch_ovr = 0
		-- B738DR_autoland_status = 0
		-- B738DR_flare_status = 0
		-- B738DR_rollout_status = 0
		-- B738DR_retard_status = 0
		-- vorloc_only = 0
		-- B738DR_autopilot_n1_status = 0
		-- B738DR_pfd_spd_mode = PFD_SPD_GA
		-- B738DR_pfd_alt_mode = PFD_ALT_TO_GA
		-- simDR_autothrottle_enable = 0
		-- fd_cur = simDR_fdir_pitch
		-- simDR_fdir_pitch_ovr = 1
		-- --ap_goaround = 2
		-- ap_goaround = 3
		-- if ap_roll_mode ~= 1  and ap_roll_mode ~= 10 and ap_roll_mode ~= 4 then
			-- ap_roll_mode = 1
		-- end
		-- fd_go_disable = 0
		
	-- SPD speed with N1 limit
	elseif at_mode == 9 and at_mode_eng ~= 9 then
		at_mode_eng = 9
		at_throttle_hold = 0	-- mode throttle HLD off
		ap_goaround = 0
		to_after_80kts = 0
		simDR_fdir_pitch_ovr = 0
		if fd_goaround < 3 then
			fd_goaround = 0
		end
		--simDR_autothrottle_enable = 1	-- speed on
		simDR_autothrottle_enable = 0
		fd_go_disable = 0
	end
	B738DR_speed_mode = at_mode
	
end

function ap_ga1_acivate()
	
	if B738DR_autopilot_autothr_arm_pos == 1 then
		at_mode = 8
		B738DR_pfd_spd_mode = PFD_SPD_GA
	end
	at_throttle_hold = 0	-- mode throttle HLD off
	fd_goaround = 0
	to_after_80kts = 0
	ap_pitch_mode = 0
	ap_pitch_mode_eng = 0
	simDR_fdir_pitch_ovr = 0
	B738DR_autoland_status = 0
	B738DR_flare_status = 0
	B738DR_rollout_status = 0
	B738DR_retard_status = 0
	vorloc_only = 0
	B738DR_autopilot_n1_status = 0
	B738DR_pfd_alt_mode = PFD_ALT_TO_GA
	simDR_autothrottle_enable = 0
	fd_cur = simDR_fdir_pitch
	simDR_fdir_pitch_ovr = 1
	--ap_goaround = 2
	ap_goaround = 3
	if ap_roll_mode ~= 1  and ap_roll_mode ~= 10 and ap_roll_mode ~= 4 then
		ap_roll_mode = 1
	end
	fd_go_disable = 0
	
end

function ap_ga2_activate()
	
	if B738DR_autopilot_autothr_arm_pos == 1 then
		at_mode = 4
		B738DR_pfd_spd_mode = PFD_SPD_GA
	end
	at_throttle_hold = 0	-- mode throttle HLD off
	fd_goaround = 0
	to_after_80kts = 0
	simDR_fdir_pitch_ovr = 0
	B738DR_autoland_status = 0
	B738DR_flare_status = 0
	B738DR_rollout_status = 0
	B738DR_retard_status = 0
	vorloc_only = 0
	ap_pitch_mode = 0
	ap_pitch_mode_eng = 0
	B738DR_autopilot_n1_status = 0
	B738DR_pfd_alt_mode = PFD_ALT_TO_GA
	if simDR_autopilot_altitude_mode ~= 4 then
		simCMD_autopilot_vs:once()			-- VS on
		vert_spd_corr()
	end
	simDR_ap_vvi_dial = 1300
	simDR_ap_capt_heading = simDR_heading_pilot
	if simDR_autopilot_heading_mode == 0 then
		simCMD_autopilot_hdg:once()			-- HDG on
	end
	fd_cur = simDR_fdir_pitch
	simDR_fdir_pitch_ovr = 1
	if ap_roll_mode ~= 1  and ap_roll_mode ~= 10 and ap_roll_mode ~= 4 then
		ap_roll_mode = 1
	end
	ap_pitch_mode_old = ap_pitch_mode_eng
	ap_roll_mode_old = ap_roll_mode_eng
	fd_go_disable = 0
end

function fd_ga_activate()
	
	if B738DR_autopilot_autothr_arm_pos == 1 then
		at_mode = 5
		B738DR_pfd_spd_mode = PFD_SPD_GA
	end
	at_throttle_hold = 0	-- mode throttle HLD off
	ap_pitch_mode = 0
	ap_pitch_mode_eng = 0
	ap_goaround = 0
	to_after_80kts = 0
	--airspeed_dial = simDR_airspeed_dial
	B738DR_retard_status = 0
	B738DR_autopilot_n1_pfd = 0
	B738DR_autopilot_n1_status = 0
	B738DR_pfd_alt_mode = PFD_ALT_TO_GA
	fd_cur = simDR_fdir_pitch
	simDR_fdir_pitch_ovr = 1
	if ap_roll_mode ~= 1  and ap_roll_mode ~= 10 and ap_roll_mode ~= 4 then
		ap_roll_mode = 1
	end
	ap_pitch_mode_old = ap_pitch_mode_eng
	ap_roll_mode_old = ap_roll_mode_eng
	fd_go_disable = 0
	
end


function B738_n1()
	
	if at_mode == 1 and at_mode_eng == 1 then
		B738DR_autopilot_n1_status = 1
		----simDR_throttle_override = 1
		eng1_N1_thrust_trg = eng1_N1_thrust	-- N1 THRUST
		eng2_N1_thrust_trg = eng2_N1_thrust	-- N1 THRUST
--		--simDR_throttle_all = eng1_N1_thrust	-- N1 THRUST
		--B738DR_retard_status = 0
	end
	
end


function lift_off()

	lift_off_150 = 1	-- 150 seconds after lift off

end

function B738_lift_off()

	local lo_timer_enable = 1
	
	if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1 
	or simDR_on_ground_2 == 1 then
		lo_timer_enable = 0
		lift_off_150 = 0
	end
	
	if lo_timer_enable == 1 and lift_off_150 == 0 then
		if is_timer_scheduled(lift_off) == false then
			run_after_time(lift_off, 150)
		end
	end

end

function on_ground()

	on_ground_30 = 1	-- 50 seconds on the ground

end

function B738_on_ground()

	local og_timer_enable = 0
	
	if simDR_on_ground_0 == 1 and simDR_on_ground_1 == 1 
	and simDR_on_ground_2 == 1 then
		og_timer_enable = 1
	end
	if simDR_airspeed_pilot < 20 then
		on_ground_30 = 1
	end
	
	if simDR_radio_height_pilot_ft > 500 then
		on_ground_30 = 0
	end
	
	if og_timer_enable == 1 and on_ground_30 == 0 then
		if is_timer_scheduled(on_ground) == false then
			run_after_time(on_ground, 50)
		end
	end

end

function B738_goaround_block()
 
	if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1 
	or simDR_on_ground_2 == 1 then
		if B738DR_autopilot_autothr_arm_pos == 0 then
			ap_goaround_block = 1
		end
	end
	if simDR_radio_height_pilot_ft > 500 then
		ap_goaround_block = 0
	end

end



function B738_ap_takeoff()

	local delta_thr = 0
	local airspeed_dial = 0
	local v2 = 0
	
	if at_mode == 3 and at_mode_eng == 3 then
		if simDR_radio_height_pilot_ft > 400
		and ap_pitch_mode_eng ~= ap_pitch_mode_old then		-- terminate TAKEOFF mode
			at_mode = 0
		end
		if simDR_radio_height_pilot_ft < 400
		and B738DR_fd_on == 0 
		and to_after_80kts == 0 then					-- terminate TAKEOFF mode
			at_mode = 0
--			ap_pitch_mode_eng = 0
--			simDR_fdir_pitch_ovr = 0
		end
		if B738DR_autobrake_RTO_arm == 2 then			-- terminate TAKEOFF mode
			at_mode = 0
--			simDR_fdir_pitch_ovr = 0
		end
		
		if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1 
		or simDR_on_ground_2 == 1 then		-- if aircraft on ground
			if simDR_airspeed_pilot < 60 then
				-- N1 TAKEOFF thrust
				--B738DR_autopilot_n1_pfd = 1			-- PFD speed> N1
				--B738DR_autopilot_to_ga_pfd = 1		-- PFD pitch> TO/GA
				B738DR_autopilot_n1_status = 1
				B738DR_pfd_spd_mode = PFD_SPD_N1
				B738DR_pfd_alt_mode = PFD_ALT_TO_GA
				if B738DR_autopilot_speed_status == 1 then
					simDR_autothrottle_enable = 0	-- speed off
				end
				----simDR_throttle_override = 1
				at_throttle_hold = 0	-- mode throttle HLD off
				
				--eng1_N1_thrust_trg = B738DR_fms_N1_thrust
				--eng2_N1_thrust_trg = B738DR_fms_N1_thrust
				
				eng1_N1_thrust_trg = eng1_N1_thrust	-- N1 THRUST
				eng2_N1_thrust_trg = eng2_N1_thrust	-- N1 THRUST

--				--simDR_throttle_all = eng1_N1_thrust		-- N1 TAKEOFF THRUST
				if simDR_fdir_pitch_ovr == 0 then
					fd_cur = simDR_fdir_pitch
					simDR_fdir_pitch_ovr = 1
				end
				fd_target = -10
				fd_cur = B738_set_anim_value(fd_cur, fd_target, -20, 20, 0.5)
				simDR_fdir_pitch = fd_cur
			elseif simDR_airspeed_pilot < 80 then	-- < 84 kts
				--B738DR_autopilot_n1_pfd = 1					-- PFD speed> N1
				--B738DR_autopilot_to_ga_pfd = 1				-- PFD pitch> TO/GA
				B738DR_autopilot_n1_status = 1
				B738DR_pfd_spd_mode = PFD_SPD_N1
				B738DR_pfd_alt_mode = PFD_ALT_TO_GA
				at_throttle_hold = 0	-- mode throttle HLD off
				
				--eng1_N1_thrust_trg = B738DR_fms_N1_thrust
				--eng2_N1_thrust_trg = B738DR_fms_N1_thrust
				
				eng1_N1_thrust_trg = eng1_N1_thrust	-- N1 THRUST
				eng2_N1_thrust_trg = eng2_N1_thrust	-- N1 THRUST
				
				if simDR_fdir_pitch_ovr == 0 then
					fd_cur = simDR_fdir_pitch
					simDR_fdir_pitch_ovr = 1
				end
				fd_target = 15
				fd_cur = B738_set_anim_value(fd_cur, fd_target, -20, 20, 0.5)
				simDR_fdir_pitch = fd_cur
			else	-- simDR_airspeed_pilot > 84 kts
				
				-- THR HLD thrust
				if simDR_fdir_pitch_ovr == 0 then
					fd_cur = simDR_fdir_pitch
					simDR_fdir_pitch_ovr = 1
				end
				fd_target = 15
				fd_cur = B738_set_anim_value(fd_cur, fd_target, -20, 20, 0.5)
				simDR_fdir_pitch = fd_cur
				--B738DR_autopilot_n1_pfd = 0
				B738DR_autopilot_n1_status = 0
				--B738DR_autopilot_thr_hld_pfd = 1			-- PFD speed> THR HLD
				--B738DR_autopilot_to_ga_pfd = 1				-- PFD pitch> TO/GA
				B738DR_pfd_spd_mode = PFD_SPD_THR_HLD
				B738DR_pfd_alt_mode = PFD_ALT_TO_GA
--				at_throttle_hold = 1	-- mode throttle HLD
				if to_thrust_set == 0 then
					
					--eng1_N1_thrust_trg = B738DR_fms_N1_thrust
					--eng2_N1_thrust_trg = B738DR_fms_N1_thrust
					eng1_N1_thrust_trg = eng1_N1_thrust	-- N1 THRUST
					eng2_N1_thrust_trg = eng2_N1_thrust	-- N1 THRUST
					
					
					delta_thr = eng1_N1_thrust_trg - eng1_N1_thrust_cur
					if delta_thr < 0.02 then
						at_throttle_hold = 1	-- mode throttle HLD
						to_thrust_set = 1
					end
				else
					at_throttle_hold = 1	-- mode throttle HLD
				end
			end
		--elseif simDR_radio_height_pilot_ft < B738DR_thr_red_alt then 	--800 then
		--elseif simDR_radio_height_pilot_ft > B738DR_accel_alt then 	--800 then
			
		elseif simDR_radio_height_pilot_ft < 800 and simDR_radio_height_pilot_ft < B738DR_accel_alt then	-- below 800 ft RA and accel height
			
			if simDR_autopilot_altitude_mode ~= 5 then
				
				if simDR_fdir_pitch_ovr == 1 then
					simDR_fdir_pitch_ovr = 0
				end
				
				
			
				-- if simDR_fdir_pitch_ovr == 0 then
					-- fd_cur = simDR_fdir_pitch
					-- simDR_fdir_pitch_ovr = 1
				-- end
				-- fd_target = 15
				-- fd_cur = B738_set_anim_value(fd_cur, fd_target, -20, 20, 0.5)
				-- simDR_fdir_pitch = fd_cur
				--B738DR_autopilot_n1_pfd = 0
				--B738DR_autopilot_thr_hld_pfd = 1			-- PFD speed> THR HLD
				--B738DR_autopilot_to_ga_pfd = 1				-- PFD pitch> TO/GA
				B738DR_autopilot_n1_status = 0
				B738DR_pfd_spd_mode = PFD_SPD_THR_HLD
				B738DR_pfd_alt_mode = PFD_ALT_TO_GA
				if to_thrust_set == 0 then
					
					--eng1_N1_thrust_trg = B738DR_fms_N1_thrust
					--eng2_N1_thrust_trg = B738DR_fms_N1_thrust
					eng1_N1_thrust_trg = eng1_N1_thrust	-- N1 THRUST
					eng2_N1_thrust_trg = eng2_N1_thrust	-- N1 THRUST
					
					delta_thr = eng1_N1_thrust_trg - eng1_N1_thrust_cur
					if delta_thr < 0.02 then
						at_throttle_hold = 1	-- mode throttle HLD
						to_thrust_set = 1
					end
				else
					at_throttle_hold = 1	-- mode throttle HLD
				end
				if at_throttle_hold == 1 and fd_cur > 14.5 and simDR_vvi_fpm_pilot > 500 then
					simDR_fdir_pitch_ovr = 0
					airspeed_dial = simDR_airspeed_dial
					simCMD_autopilot_lvl_chg:once()
					simDR_airspeed_dial = airspeed_dial
					if B738DR_fms_v2_15 == 0 then
						simDR_airspeed_dial = 165
					else
						simDR_airspeed_dial = B738DR_fms_v2_15
						if B738DR_eng_out == 1 then
							v2 = B738DR_fms_v2_15 - 20
							if simDR_airspeed_pilot >= v2 and simDR_airspeed_pilot <= B738DR_fms_v2_15 then
								simDR_airspeed_dial = simDR_airspeed_pilot
							elseif simDR_airspeed_pilot < v2 then
								simDR_airspeed_dial = v2
							end
						end
					end
				end
			end
		else --- simDR_radio_height_pilot_ft > accel height
			
			if simDR_fdir_pitch_ovr == 1 then
				simDR_fdir_pitch_ovr = 0
			end
			if simDR_autopilot_altitude_mode ~= 5 then
				airspeed_dial = simDR_airspeed_dial
				simCMD_autopilot_lvl_chg:once()
				simDR_airspeed_dial = airspeed_dial
			end
			
			-- engaged N1 thrust
			B738DR_autopilot_n1_status = 1
			B738DR_pfd_spd_mode = PFD_SPD_N1
			B738DR_pfd_alt_mode = PFD_ALT_TO_GA
			at_throttle_hold = 0	-- mode throttle HLD off
			
			--eng1_N1_thrust_trg = B738DR_fms_N1_thrust
			--eng2_N1_thrust_trg = B738DR_fms_N1_thrust
			
			eng1_N1_thrust_trg = eng1_N1_thrust	-- N1 THRUST
			eng2_N1_thrust_trg = eng2_N1_thrust	-- N1 THRUST
				
			
		end
	end
	ap_pitch_mode_old = ap_pitch_mode_eng
	
end

function B738_ap_goaround()

	local flaps_speed = 0
	local flaps = simDR_flaps_ratio
	local airspeed_dial = 0
	
	-- A/P GoAround
	--if at_mode == 4 and at_mode_eng == 4 then
	if ap_goaround > 0 and ap_goaround < 3 then
		
		if simDR_radio_height_pilot_ft < 400 then
			if ap_on == 0
			and B738DR_fd_on == 0 then		-- terminate AP GoAround mode
				at_mode = 0
				ap_roll_mode_eng = 10
				ap_pitch_mode_eng = 10
				ap_goaround = 0
				simDR_fdir_pitch_ovr = 0
				B738DR_autopilot_to_ga_pfd = 0		-- PFD pitch> TO/GA
			end
		end
		
		if ap_pitch_mode ~= 0 then
			at_mode = 2
			ap_pitch_mode_eng = 10
			ap_goaround = 0
			simDR_fdir_pitch_ovr = 0
			if cmd_first == 0 then
				autopilot_cmd_b_status = 0
			else
				autopilot_cmd_a_status = 0
			end
		end
		--if B738DR_autopilot_alt_acq_pfd == 1 then
		if ap_pitch_mode == 6 and ap_pitch_mode_eng == 6 then
			--B738DR_autopilot_to_ga_pfd = 0		-- PFD pitch> TO/GA
			ap_goaround = 0
			simDR_fdir_pitch_ovr = 0
			if cmd_first == 0 then
				autopilot_cmd_b_status = 0
			else
				autopilot_cmd_a_status = 0
			end
		end
		
		if ap_goaround == 1 then		-- first push
			if flaps == 0 then
				flaps_speed = 230
			elseif flaps <= 0.25 then		-- flaps 1,2
				flaps_speed = B738DR_pfd_flaps_1
			elseif flaps <= 0.375 then		-- flaps 5
				flaps_speed = B738DR_pfd_flaps_5
			elseif flaps <= 0.5 then		-- flaps 10
				flaps_speed = B738DR_pfd_flaps_10
			elseif flaps <= 0.625 then		-- flaps 15
				if B738DR_fms_vref_15 == 0 then
					flaps_speed = B738DR_pfd_flaps_15
				else
					flaps_speed = B738DR_fms_vref_15
				end
			elseif flaps <= 0.75 then		-- flaps 25
				if B738DR_fms_vref_25 == 0 then
					flaps_speed = 175
				else
					flaps_speed = B738DR_fms_vref_25
				end
			elseif flaps <= 0.875 then		-- flaps 30
				if B738DR_fms_vref_30 == 0 then
					flaps_speed = 165
				else
					flaps_speed = B738DR_fms_vref_30
				end
			else		-- flaps 40
				if B738DR_fms_vref_40 == 0 then
					flaps_speed = 155
				else
					flaps_speed = B738DR_fms_vref_40
				end
			end
			simDR_airspeed_dial = flaps_speed
			if simDR_vvi_fpm_pilot < 1200 then
				fd_target = 15
				fd_cur = B738_set_anim_value(fd_cur, fd_target, -20, 20, 0.5)
				simDR_fdir_pitch = fd_cur
			else
				simDR_fdir_pitch_ovr = 0
				if simDR_autopilot_altitude_mode ~= 5 then
					airspeed_dial = simDR_airspeed_dial
					simCMD_autopilot_lvl_chg:once()		--LVL CHG on
					simDR_airspeed_dial = airspeed_dial
				end
				
			end
			--simDR_autothrottle_enable = 1
			if B738DR_autopilot_autothr_arm_pos == 1 then
				if at_mode_eng ~= 4 then
					at_mode = 4
					B738DR_pfd_spd_mode = PFD_SPD_GA
				end
				eng1_N1_thrust_trg = N1_goaround_thrust * 0.9		-- N1 GOAROUND THRUST
				eng2_N1_thrust_trg = N1_goaround_thrust * 0.9		-- N1 GOAROUND THRUST
			end
			
		elseif ap_goaround == 2 then	-- second push
			if flaps == 0 then
				flaps_speed = 230
			elseif flaps <= 0.25 then		-- flaps 1,2
				flaps_speed = B738DR_pfd_flaps_1
			elseif flaps <= 0.375 then		-- flaps 5
				flaps_speed = B738DR_pfd_flaps_5
			elseif flaps <= 0.5 then		-- flaps 10
				flaps_speed = B738DR_pfd_flaps_10
			elseif flaps <= 0.625 then		-- flaps 15
				if B738DR_fms_vref_15 == 0 then
					flaps_speed = B738DR_pfd_flaps_15
				else
					flaps_speed = B738DR_fms_vref_15
				end
			elseif flaps <= 0.75 then		-- flaps 25
				if B738DR_fms_vref_25 == 0 then
					flaps_speed = 175
				else
					flaps_speed = B738DR_fms_vref_25
				end
			elseif flaps <= 0.875 then		-- flaps 30
				if B738DR_fms_vref_30 == 0 then
					flaps_speed = 165
				else
					flaps_speed = B738DR_fms_vref_30
				end
			else		-- flaps 40
				if B738DR_fms_vref_40 == 0 then
					flaps_speed = 155
				else
					flaps_speed = B738DR_fms_vref_40
				end
			end
			simDR_airspeed_dial = flaps_speed
			simDR_fdir_pitch_ovr = 0
			simDR_autothrottle_enable = 0
			----simDR_throttle_override = 1
			
			if B738DR_autopilot_autothr_arm_pos == 1 then
				if at_mode_eng ~= 4 then
					at_mode = 4
					B738DR_pfd_spd_mode = PFD_SPD_GA
				end
				eng1_N1_thrust_trg = N1_goaround_thrust		-- N1 FULL GOAROUND THRUST
				eng2_N1_thrust_trg = N1_goaround_thrust		-- N1 FULL GOAROUND THRUST
			end
			
			--B738DR_autopilot_n1_status = 1
--			--simDR_throttle_all = N1_goaround_thrust		-- N1 FULL GOAROUND THRUST
			if simDR_autopilot_altitude_mode ~= 5 then
				airspeed_dial = simDR_airspeed_dial
				simCMD_autopilot_lvl_chg:once()		--LVL CHG on
				simDR_airspeed_dial = airspeed_dial
			end
		end
		
	-- A/P GoAround after touchdown
	--elseif at_mode == 8 and at_mode_eng == 8 then
	elseif ap_goaround == 3 then
		--if fd_on == 0 or ap_on == 0 then
		if B738DR_fd_on == 0 or ap_on == 0 then
			at_mode = 0
			ap_goaround = 0
			simDR_fdir_pitch_ovr = 0
		else
			fd_target = 15
			fd_cur = B738_set_anim_value(fd_cur, fd_target, -20, 20, 0.5)
			simDR_fdir_pitch = fd_cur
			
			if B738DR_autopilot_autothr_arm_pos == 1 then
				if at_mode_eng ~= 8 then
					at_mode = 8
					B738DR_pfd_spd_mode = PFD_SPD_GA
				end
				eng1_N1_thrust_trg = N1_goaround_thrust		-- N1 FULL GOAROUND THRUST
				eng2_N1_thrust_trg = N1_goaround_thrust		-- N1 FULL GOAROUND THRUST
			end
			
			--B738DR_autopilot_n1_status = 1
--			--simDR_throttle_all = N1_goaround_thrust		-- N1 FULL GOAROUND THRUST
			if simDR_autopilot_altitude_mode ~= 5 then
				airspeed_dial = simDR_airspeed_dial
				simCMD_autopilot_lvl_chg:once()		--LVL CHG on
				simDR_airspeed_dial = airspeed_dial
			end
		end
		--if B738DR_autopilot_alt_acq_pfd == 1 then
		if ap_pitch_mode_eng == 6 or ap_pitch_mode_eng == 3 then
			--B738DR_autopilot_to_ga_pfd = 0		-- PFD pitch> TO/GA
			ap_goaround = 0
			simDR_fdir_pitch_ovr = 0
			if cmd_first == 0 then
				autopilot_cmd_b_status = 0
			else
				autopilot_cmd_a_status = 0
			end
		elseif ap_pitch_mode ~= 0 then
			at_mode = 0
			ap_goaround = 0
			simDR_fdir_pitch_ovr = 0
			if cmd_first == 0 then
				autopilot_cmd_b_status = 0
			else
				autopilot_cmd_a_status = 0
			end
		end
	
	-- F/D GoAround
	--elseif at_mode == 5 and at_mode_eng == 5 then
	elseif fd_goaround > 0 then
		
		if simDR_radio_height_pilot_ft < 400 then
			if B738DR_fd_on == 0 then		-- terminate FD GoAround mode
				at_mode = 0
				ap_roll_mode_eng = 10
				ap_pitch_mode_eng = 10
				fd_goaround = 0
				B738DR_autopilot_to_ga_pfd = 0		-- PFD pitch> TO/GA
			end
		else
			--if ap_pitch_mode_old ~= ap_pitch_mode then
			if ap_pitch_mode ~= 0 then
				if ap_roll_mode == 0 then
					ap_roll_mode = 1
				end
				at_mode = 2
				B738DR_autopilot_to_ga_pfd = 0		-- PFD pitch> TO/GA
				fd_goaround = 0
				simDR_fdir_pitch_ovr = 0
			end
			--if B738DR_autopilot_alt_acq_pfd == 1 then
			if ap_pitch_mode_eng == 6 or ap_pitch_mode_eng == 3 then
				at_mode = 2
				B738DR_autopilot_to_ga_pfd = 0		-- PFD pitch> TO/GA
				fd_goaround = 0
				simDR_fdir_pitch_ovr = 0
			end
			-- if ap_roll_mode ~= 0 or ap_pitch_mode ~= 0 
			-- or B738DR_autopilot_alt_acq_pfd == 1 then
				-- at_mode = 2
				-- B738DR_autopilot_to_ga_pfd = 0		-- PFD pitch> TO/GA
				-- ap_roll_mode_eng = 10
				-- ap_pitch_mode_eng = 10
				-- fd_goaround = 0
				-- simDR_fdir_pitch_ovr = 0
			-- end
		end
		if ap_on == 1 then
			ap_roll_mode = 1
			ap_pitch_mode = 2
			ap_pitch_mode_eng = 10
			fd_goaround = 0
			simDR_fdir_pitch_ovr = 0
		end
		
		if fd_goaround == 1 then		-- first push
			-- speed: maximal current flaps speed
			-- if B738DR_pfd_flaps_bug < 250 then
				-- flap_speed = B738DR_pfd_flaps_bug - 10
				-- if flap_speed == 0 then
					-- flap_speed = 180
				-- end
			-- else
				-- flap_speed = 250
			-- end
			if flaps == 0 then
				flaps_speed = 230
			elseif flaps <= 0.25 then		-- flaps 1,2
				flaps_speed = B738DR_pfd_flaps_1
			elseif flaps <= 0.375 then		-- flaps 5
				flaps_speed = B738DR_pfd_flaps_5
			elseif flaps <= 0.5 then		-- flaps 10
				flaps_speed = B738DR_pfd_flaps_10
			elseif flaps <= 0.625 then		-- flaps 15
				if B738DR_fms_vref_15 == 0 then
					flaps_speed = B738DR_pfd_flaps_15
				else
					flaps_speed = B738DR_fms_vref_15
				end
			elseif flaps <= 0.75 then		-- flaps 25
				if B738DR_fms_vref_25 == 0 then
					flaps_speed = 175
				else
					flaps_speed = B738DR_fms_vref_25
				end
			elseif flaps <= 0.875 then		-- flaps 30
				if B738DR_fms_vref_30 == 0 then
					flaps_speed = 165
				else
					flaps_speed = B738DR_fms_vref_30
				end
			else		-- flaps 40
				if B738DR_fms_vref_40 == 0 then
					flaps_speed = 155
				else
					flaps_speed = B738DR_fms_vref_40
				end
			end
						
			simDR_airspeed_dial = flaps_speed
			
			if B738DR_autopilot_autothr_arm_pos == 1 then
				if at_mode_eng ~= 5 then
					at_mode = 5
					B738DR_pfd_spd_mode = PFD_SPD_GA
				end
				if simDR_vvi_fpm_pilot < 500 and fd_go_disable == 0 then
					--simDR_autothrottle_enable = 0
					eng1_N1_thrust_trg = N1_goaround_thrust		-- N1 FULL GOAROUND THRUST
					eng2_N1_thrust_trg = N1_goaround_thrust		-- N1 FULL GOAROUND THRUST
				else
					fd_go_disable = 1
					-- simDR_autothrottle_enable = 1
					eng1_N1_thrust_trg = N1_goaround_thrust * 0.9		-- N1 GOAROUND THRUST
					eng2_N1_thrust_trg = N1_goaround_thrust * 0.9		-- N1 GOAROUND THRUST
				end
			end
			
			if simDR_vvi_fpm_pilot < 1200 then
				fd_target = 15
				fd_cur = B738_set_anim_value(fd_cur, fd_target, -20, 20, 0.5)
				simDR_fdir_pitch = fd_cur
			else
				simDR_fdir_pitch_ovr = 0
				if simDR_autopilot_altitude_mode ~= 5 then
					airspeed_dial = simDR_airspeed_dial
					simCMD_autopilot_lvl_chg:once()		--LVL CHG on
					simDR_airspeed_dial = airspeed_dial
				end
			end
		
		elseif fd_goaround == 2 then	-- second push
			if flaps == 0 then
				flaps_speed = 230
			elseif flaps <= 0.25 then		-- flaps 1,2
				flaps_speed = B738DR_pfd_flaps_1
			elseif flaps <= 0.375 then		-- flaps 5
				flaps_speed = B738DR_pfd_flaps_5
			elseif flaps <= 0.5 then		-- flaps 10
				flaps_speed = B738DR_pfd_flaps_10
			elseif flaps <= 0.625 then		-- flaps 15
				if B738DR_fms_vref_15 == 0 then
					flaps_speed = B738DR_pfd_flaps_15
				else
					flaps_speed = B738DR_fms_vref_15
				end
			elseif flaps <= 0.75 then		-- flaps 25
				if B738DR_fms_vref_25 == 0 then
					flaps_speed = 175
				else
					flaps_speed = B738DR_fms_vref_25
				end
			elseif flaps <= 0.875 then		-- flaps 30
				if B738DR_fms_vref_30 == 0 then
					flaps_speed = 165
				else
					flaps_speed = B738DR_fms_vref_30
				end
			else		-- flaps 40
				if B738DR_fms_vref_40 == 0 then
					flaps_speed = 155
				else
					flaps_speed = B738DR_fms_vref_40
				end
			end
			simDR_airspeed_dial = flaps_speed
			simDR_autothrottle_enable = 0
			----simDR_throttle_override = 1
			
			if B738DR_autopilot_autothr_arm_pos == 1 then
				if at_mode_eng ~= 5 then
					at_mode = 5
					B738DR_pfd_spd_mode = PFD_SPD_GA
				end
				eng1_N1_thrust_trg = N1_goaround_thrust		-- N1 FULL GOAROUND THRUST
				eng2_N1_thrust_trg = N1_goaround_thrust		-- N1 FULL GOAROUND THRUST
			end
			
			--B738DR_autopilot_n1_status = 1
--			--simDR_throttle_all = N1_goaround_thrust		-- N1 FULL GOAROUND THRUST
			if simDR_autopilot_altitude_mode ~= 5 then
				airspeed_dial = simDR_airspeed_dial
				simCMD_autopilot_lvl_chg:once()		--LVL CHG on
				simDR_airspeed_dial = airspeed_dial
			end
		end
	end
	ap_pitch_mode_old = ap_pitch_mode_eng
	ap_roll_mode_old = ap_roll_mode_eng

end

function B738_fd_show()

	if to_after_80kts == 0 then		-- if no Takeoff without F/D on
		if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1 or simDR_on_ground_2 == 1 then
			if ap_pitch_mode == 0 and ap_roll_mode == 0 then
				B738DR_fd_pilot_show = 0
				B738DR_fd_copilot_show = 0
			else
				B738DR_fd_pilot_show = B738DR_autopilot_fd_pos
				B738DR_fd_copilot_show = B738DR_autopilot_fd_fo_pos
			end
		else
			B738DR_fd_pilot_show = B738DR_autopilot_fd_pos
			B738DR_fd_copilot_show = B738DR_autopilot_fd_fo_pos
		end
	end

end


---- IAS and ALT DISAGREE ----

function ias_disagree_timer()
	ias_disagree = 1
end

function alt_disagree_timer()
	alt_disagree = 1
end

function B738_ias_alt_disagree()

	local delta_airspeed = 0
	local delta_alt = 0
	
	-- IAS disagree
	delta_airspeed = simDR_airspeed_pilot - simDR_airspeed_copilot
	if delta_airspeed < 0 then
		delta_airspeed = -delta_airspeed
	end
	if delta_airspeed > 5 then
		if is_timer_scheduled(ias_disagree_timer) == false then
			run_after_time(ias_disagree_timer, 5)	-- 5 seconds
		end
	else
		if is_timer_scheduled(ias_disagree_timer) == true then
			stop_timer(ias_disagree_timer)
		end
		ias_disagree = 0
	end
	
	-- ALT disagree
	delta_alt = simDR_altitude_pilot - simDR_altitude_copilot
	if delta_alt < 0 then
		delta_alt = -delta_alt
	end
	if delta_alt > 200 then
		if is_timer_scheduled(alt_disagree_timer) == false then
			run_after_time(alt_disagree_timer, 5)	-- 5 seconds
		end
	else
		if is_timer_scheduled(alt_disagree_timer) == true then
			stop_timer(alt_disagree_timer)
		end
		alt_disagree = 0
	end
	B738DR_ias_disagree = ias_disagree
	B738DR_alt_disagree = alt_disagree

end


function B738_eng_n1_set()
	
	local thrust_correct = 0
	local alt_correct = 0
	local req_idle = 0
	local req1_idle = 0
	local req2_idle = 0
	
	if B738DR_n1_set_source == -2 then		-- ENG 2 SET
		if simDR_reverse2_deploy > 0.01 then
			B738DR_eng2_N1_bug_dig = 0
			eng2_N1_thrust = 0
		else
			B738DR_eng2_N1_bug_dig = 1
			B738DR_eng2_N1_bug = B738DR_n1_set_adjust
			req_idle = math.max(0.5, simDR_engine_mixture2)
			req1_idle = B738_rescale(0.5, 0.5138, 1.0, 0.3741, req_idle)
			req2_idle = B738_rescale(0.5, 1.015, 1.0, 1.008, req_idle)
			eng2_N1_thrust = B738_rescale(0.6, req1_idle, req2_idle, 1.04, B738DR_eng2_N1_bug)
			eng2_N1_man = B738DR_eng2_N1_bug
		end
		if simDR_reverse1_deploy > 0.01 then
			B738DR_eng1_N1_bug_dig = 0
			eng1_N1_thrust = 0
		else
			B738DR_eng1_N1_bug_dig = 1
			req_idle = math.max(0.5, simDR_engine_mixture1)
			req1_idle = B738_rescale(0.5, 0.5138, 1.0, 0.3741, req_idle)
			req2_idle = B738_rescale(0.5, 1.015, 1.0, 1.008, req_idle)
			eng1_N1_thrust = B738_rescale(0.6, req1_idle, req2_idle, 1.04, B738DR_eng1_N1_bug)
		end
		B738DR_assum_temp_show = 0
		B738DR_N1_mode_man = 1
	
	elseif  B738DR_n1_set_source == -1 then	-- ENG 1 SET
		if simDR_reverse1_deploy > 0.01 then
			B738DR_eng1_N1_bug_dig = 0
			eng1_N1_thrust = 0
		else
			B738DR_eng1_N1_bug_dig = 1
			B738DR_eng1_N1_bug = B738DR_n1_set_adjust
			req_idle = math.max(0.5, simDR_engine_mixture1)
			req1_idle = B738_rescale(0.5, 0.5138, 1.0, 0.3741, req_idle)
			req2_idle = B738_rescale(0.5, 1.015, 1.0, 1.008, req_idle)
			eng1_N1_thrust = B738_rescale(0.6, req1_idle, req2_idle, 1.04, B738DR_eng1_N1_bug)
			eng1_N1_man = B738DR_eng1_N1_bug
		end
		if simDR_reverse2_deploy > 0.01 then
			B738DR_eng2_N1_bug_dig = 0
			eng2_N1_thrust = 0
		else
			B738DR_eng2_N1_bug_dig = 1
			req_idle = math.max(0.5, simDR_engine_mixture2)
			req1_idle = B738_rescale(0.5, 0.5138, 1.0, 0.3741, req_idle)
			req2_idle = B738_rescale(0.5, 1.015, 1.0, 1.008, req_idle)
			eng2_N1_thrust = B738_rescale(0.6, req1_idle, req2_idle, 1.04, B738DR_eng2_N1_bug)
		end
		B738DR_assum_temp_show = 0
		B738DR_N1_mode_man = 1
	
	elseif  B738DR_n1_set_source == 0 then	-- FMC AUTO
		B738DR_N1_mode_man = 0
		if simDR_reverse1_deploy > 0.01 
		or simDR_reverse2_deploy > 0.01 then
			B738DR_eng1_N1_bug_dig = 0
			B738DR_eng2_N1_bug_dig = 0
			eng1_N1_thrust = 0
			eng2_N1_thrust = 0
			B738DR_assum_temp_show = 0
		else
			if B738DR_fms_N1_mode == 0 or B738DR_fms_N1_mode == 13 then		-- no mode
				B738DR_eng1_N1_bug_dig = 0
				B738DR_eng2_N1_bug_dig = 0
				B738DR_assum_temp_show = 0
			elseif B738DR_fms_N1_mode > 0 then
				B738DR_eng1_N1_bug_dig = 1
				B738DR_eng2_N1_bug_dig = 1
				req_idle = math.max(0.5, simDR_engine_mixture1)
				req1_idle = B738_rescale(0.5, 0.5138, 1.0, 0.3741, req_idle)
				req2_idle = B738_rescale(0.5, 1.015, 1.0, 1.008, req_idle)
				eng1_N1_thrust = B738_rescale(0.6, req1_idle, req2_idle, 1.04, B738DR_eng1_N1_bug)
				req_idle = math.max(0.5, simDR_engine_mixture2)
				req1_idle = B738_rescale(0.5, 0.5138, 1.0, 0.3741, req_idle)
				req2_idle = B738_rescale(0.5, 1.015, 1.0, 1.008, req_idle)
				eng2_N1_thrust = B738_rescale(0.6, req1_idle, req2_idle, 1.04, B738DR_eng2_N1_bug)
				B738DR_eng1_N1_bug = B738DR_fms_N1_thrust
				B738DR_eng2_N1_bug = B738DR_fms_N1_thrust
				if B738DR_fms_N1_mode > 3 and B738DR_fms_N1_mode < 7 then
					B738DR_assum_temp_show = 1
				else
					B738DR_assum_temp_show = 0
				end
			end
		end
	
	elseif  B738DR_n1_set_source == 1 then	-- both ENG SET
		if simDR_reverse1_deploy > 0.01 then
			B738DR_eng1_N1_bug_dig = 0
			eng1_N1_thrust = 0
		else
			B738DR_eng1_N1_bug_dig = 1
			B738DR_eng1_N1_bug = B738DR_n1_set_adjust
			req_idle = math.max(0.5, simDR_engine_mixture1)
			req1_idle = B738_rescale(0.5, 0.5138, 1.0, 0.3741, req_idle)
			req2_idle = B738_rescale(0.5, 1.015, 1.0, 1.008, req_idle)
			eng1_N1_thrust = B738_rescale(0.6, req1_idle, req2_idle, 1.04, B738DR_eng1_N1_bug)
			eng1_N1_man = B738DR_eng1_N1_bug
		end
		if simDR_reverse2_deploy > 0.01 then
			B738DR_eng2_N1_bug_dig = 0
			eng2_N1_thrust = 0
		else
			B738DR_eng2_N1_bug_dig = 1
			B738DR_eng2_N1_bug = B738DR_n1_set_adjust
			req_idle = math.max(0.5, simDR_engine_mixture2)
			req1_idle = B738_rescale(0.5, 0.5138, 1.0, 0.3741, req_idle)
			req2_idle = B738_rescale(0.5, 1.015, 1.0, 1.008, req_idle)
			eng2_N1_thrust = B738_rescale(0.6, req1_idle, req2_idle, 1.04, B738DR_eng2_N1_bug)
			eng2_N1_man = B738DR_eng2_N1_bug
		end
		B738DR_assum_temp_show = 0
		B738DR_N1_mode_man = 1
	end
	
	-- ALT THRUST CORRECT
	
	local alt_corr = 0
	local corr_min = 0
	local corr_max = 0
	alt_correct = math.min(40000, (simDR_elevation_m * 3.28))
	alt_correct = math.max(0, alt_correct)
	
	corr_min = roundDownToIncrement(alt_correct, 5000 )
	corr_max = roundUpToIncrement(alt_correct, 5000 )
	alt_corr = alt_correct
	thrust_correct = B738_rescale(corr_min, n1_correct[corr_min][2], corr_max, n1_correct[corr_max][2], alt_correct)
	thrust_correct = thrust_correct / 1000
	
	if eng1_N1_thrust > 0 then
		eng1_N1_thrust = eng1_N1_thrust + thrust_correct
		eng1_N1_thrust = math.min ( 1.04, eng1_N1_thrust)
	end
	
	if eng2_N1_thrust > 0 then
		eng2_N1_thrust = eng2_N1_thrust + thrust_correct
		eng2_N1_thrust = math.min ( 1.04, eng2_N1_thrust)
	end
	--B738DR_test_test = thrust_correct
	
end



function B738_eng_n1_set_old()
	
	local thrust_correct = 0
	local alt_correct = 0
	local req_idle = 0
	local req1_idle = 0
	local req2_idle = 0
	
	if B738DR_n1_set_source == -2 then		-- ENG 2 SET
		if simDR_reverse2_deploy > 0.01 then
			B738DR_eng2_N1_bug_dig = 0
			eng2_N1_thrust = 0
		else
			B738DR_eng2_N1_bug_dig = 1
			B738DR_eng2_N1_bug = B738DR_n1_set_adjust
			eng2_N1_thrust = B738DR_eng2_N1_bug
			eng2_N1_man = B738DR_eng2_N1_bug
		end
		if simDR_reverse1_deploy > 0.01 then
			B738DR_eng1_N1_bug_dig = 0
			eng1_N1_thrust = 0
		else
			B738DR_eng1_N1_bug_dig = 1
			req_idle = math.max(0.5, simDR_engine_mixture1)
			req1_idle = B738_rescale(0.5, 0.5138, 1.0, 0.3741, req_idle)
			req2_idle = B738_rescale(0.5, 1.015, 1.0, 1.008, req_idle)
			eng1_N1_thrust = B738DR_eng1_N1_bug
		end
		B738DR_assum_temp_show = 0
		B738DR_N1_mode_man = 1
	
	elseif  B738DR_n1_set_source == -1 then	-- ENG 1 SET
		if simDR_reverse1_deploy > 0.01 then
			B738DR_eng1_N1_bug_dig = 0
			eng1_N1_thrust = 0
		else
			B738DR_eng1_N1_bug_dig = 1
			B738DR_eng1_N1_bug = B738DR_n1_set_adjust
			req_idle = math.max(0.5, simDR_engine_mixture1)
			req1_idle = B738_rescale(0.5, 0.5138, 1.0, 0.3741, req_idle)
			req2_idle = B738_rescale(0.5, 1.015, 1.0, 1.008, req_idle)
			eng1_N1_thrust = B738_rescale(0.6, req1_idle, req2_idle, 1.04, B738DR_eng1_N1_bug)
			eng1_N1_man = B738DR_eng1_N1_bug
		end
		if simDR_reverse2_deploy > 0.01 then
			B738DR_eng2_N1_bug_dig = 0
			eng2_N1_thrust = 0
		else
			B738DR_eng2_N1_bug_dig = 1
			req_idle = math.max(0.5, simDR_engine_mixture2)
			req1_idle = B738_rescale(0.5, 0.5138, 1.0, 0.3741, req_idle)
			req2_idle = B738_rescale(0.5, 1.015, 1.0, 1.008, req_idle)
			eng2_N1_thrust = B738_rescale(0.6, req1_idle, req2_idle, 1.04, B738DR_eng2_N1_bug)
		end
		B738DR_assum_temp_show = 0
		B738DR_N1_mode_man = 1
	
	elseif  B738DR_n1_set_source == 0 then	-- FMC AUTO
		B738DR_N1_mode_man = 0
		if simDR_reverse1_deploy > 0.01 
		or simDR_reverse2_deploy > 0.01 then
			B738DR_eng1_N1_bug_dig = 0
			B738DR_eng2_N1_bug_dig = 0
			eng1_N1_thrust = 0
			eng2_N1_thrust = 0
			B738DR_assum_temp_show = 0
		else
			if B738DR_fms_N1_mode == 0 or B738DR_fms_N1_mode == 13 then		-- no mode
				B738DR_eng1_N1_bug_dig = 0
				B738DR_eng2_N1_bug_dig = 0
				B738DR_assum_temp_show = 0
			elseif B738DR_fms_N1_mode > 0 then
				B738DR_eng1_N1_bug_dig = 1
				B738DR_eng2_N1_bug_dig = 1
				req_idle = math.max(0.5, simDR_engine_mixture1)
				req1_idle = B738_rescale(0.5, 0.5138, 1.0, 0.3741, req_idle)
				req2_idle = B738_rescale(0.5, 1.015, 1.0, 1.008, req_idle)
				eng1_N1_thrust = B738_rescale(0.6, req1_idle, req2_idle, 1.04, B738DR_eng1_N1_bug)
				req_idle = math.max(0.5, simDR_engine_mixture2)
				req1_idle = B738_rescale(0.5, 0.5138, 1.0, 0.3741, req_idle)
				req2_idle = B738_rescale(0.5, 1.015, 1.0, 1.008, req_idle)
				eng2_N1_thrust = B738_rescale(0.6, req1_idle, req2_idle, 1.04, B738DR_eng2_N1_bug)
				B738DR_eng1_N1_bug = B738DR_fms_N1_thrust
				B738DR_eng2_N1_bug = B738DR_fms_N1_thrust
				if B738DR_fms_N1_mode > 3 and B738DR_fms_N1_mode < 7 then
					B738DR_assum_temp_show = 1
				else
					B738DR_assum_temp_show = 0
				end
			end
		end
	
	elseif  B738DR_n1_set_source == 1 then	-- both ENG SET
		if simDR_reverse1_deploy > 0.01 then
			B738DR_eng1_N1_bug_dig = 0
			eng1_N1_thrust = 0
		else
			B738DR_eng1_N1_bug_dig = 1
			B738DR_eng1_N1_bug = B738DR_n1_set_adjust
			eng1_N1_thrust = B738DR_eng1_N1_bug
			eng1_N1_man = B738DR_eng1_N1_bug
		end
		if simDR_reverse2_deploy > 0.01 then
			B738DR_eng2_N1_bug_dig = 0
			eng2_N1_thrust = 0
		else
			B738DR_eng2_N1_bug_dig = 1
			B738DR_eng2_N1_bug = B738DR_n1_set_adjust
			eng2_N1_thrust = B738DR_eng2_N1_bug
			eng2_N1_man = B738DR_eng2_N1_bug
		end
		B738DR_assum_temp_show = 0
		B738DR_N1_mode_man = 1
	end
	
	-- ALT THRUST CORRECT
	
	local alt_corr = 0
	local corr_min = 0
	local corr_max = 0
	alt_correct = math.min(40000, (simDR_elevation_m * 3.28))
	alt_correct = math.max(0, alt_correct)
	
	corr_min = roundDownToIncrement(alt_correct, 5000 )
	corr_max = roundUpToIncrement(alt_correct, 5000 )
	alt_corr = alt_correct
	thrust_correct = B738_rescale(corr_min, n1_correct[corr_min][2], corr_max, n1_correct[corr_max][2], alt_correct)
	thrust_correct = thrust_correct / 1000
	
	if eng1_N1_thrust > 0 then
		eng1_N1_thrust = eng1_N1_thrust + thrust_correct
		eng1_N1_thrust = math.min ( 1.04, eng1_N1_thrust)
	end
	
	if eng2_N1_thrust > 0 then
		eng2_N1_thrust = eng2_N1_thrust + thrust_correct
		eng2_N1_thrust = math.min ( 1.04, eng2_N1_thrust)
	end
	--B738DR_test_test = thrust_correct
	
end



function B738_N1_thrust_manage2()

	--local thr1_target = 0
	--local thr2_target = 0
	local thr1_limit = 0
	local thr2_limit = 0
	local thr1_anim = 0
	local thr2_anim = 0
	local delta_throttle = 0
	local throttle_noise = B738DR_throttle_noise / 100

	if reverse_max_enable1 == 0 and reverse_max_enable2 == 0 then
		thr1_target = eng1_N1_thrust_cur
		thr2_target = eng2_N1_thrust_cur
		
		if at_throttle_hold == 0 then		-- manual throttle
			
			if at_mode_eng == 0 then
				
				
				if B738DR_throttle_noise == 0 or lock_throttle == 0 then
					thr1_target = B738_rescale(0, 0, 1, 1.04, simDR_throttle_1)
					thr2_target = B738_rescale(0, 0, 1, 1.04, simDR_throttle_2)
				else
					if B738DR_joy_axis_throttle == -1 then
						
						if B738DR_joy_axis_throttle1 == -1 and B738DR_joy_axis_throttle2 == -1 then
							lock_throttle = 0
						else
							delta_throttle = math.abs(axis_throttle1_old - B738DR_joy_axis_throttle1)
							if delta_throttle > throttle_noise then
								lock_throttle = 0
							end
							delta_throttle = math.abs(axis_throttle2_old - B738DR_joy_axis_throttle2)
							if delta_throttle > throttle_noise then
								lock_throttle = 0
							end
						end
					else
						delta_throttle = math.abs(axis_throttle_old - B738DR_joy_axis_throttle)
						if delta_throttle > throttle_noise then
							lock_throttle = 0
						end
					end
				end
				
				--thr1_target = B738_rescale(0, 0, 1, 1.04, simDR_throttle_1)
				--thr2_target = B738_rescale(0, 0, 1, 1.04, simDR_throttle_2)
				eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, thr1_target, 0.0, 1.04, 10)
				eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, thr2_target, 0.0, 1.04, 10)
				simDR_throttle1_use = eng1_N1_thrust_cur
				simDR_throttle2_use = eng2_N1_thrust_cur
				--thr1_anim = simDR_throttle_1
				--thr2_anim = simDR_throttle_2
				
				--thr1_anim = eng1_N1_thrust_cur
				--thr2_anim = eng2_N1_thrust_cur
				thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
				thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
				
			elseif at_mode_eng == 2 then	-- speed mode
				-- thr1_target = B738_rescale(0, 0, 1, 1.04, simDR_throttle_1)
				-- thr2_target = B738_rescale(0, 0, 1, 1.04, simDR_throttle_2)
				-- eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, thr1_target, 0.0, 1.04, 8)
				-- eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, thr2_target, 0.0, 1.04, 8)
				-- simDR_throttle1_use = eng1_N1_thrust_cur
				-- simDR_throttle2_use = eng2_N1_thrust_cur
				-- thr1_anim = math.min(1.0, eng1_N1_thrust_cur)
				-- thr2_anim = math.min(1.0, eng2_N1_thrust_cur)
				lock_throttle = 1
				if B738DR_n1_set_source == 0 then	-- FMC AUTO
					if B738DR_fms_N1_mode == 0 or B738DR_fms_N1_mode == 13 then		-- no mode
						thr1_limit = 1.04
						thr2_limit = 1.04
					else
						thr1_limit = eng1_N1_thrust
						thr2_limit = eng2_N1_thrust
					end
				else 
					thr1_limit = eng1_N1_thrust
					thr2_limit = eng2_N1_thrust
				end
				if simDR_throttle_1 > thr1_limit then
					thr1_target = thr1_limit
				else
					thr1_target = simDR_throttle_1
				end
				if simDR_throttle_2 > thr2_limit then
					thr2_target = thr2_limit
				else
					thr2_target = simDR_throttle_2
				end
				eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, thr1_target, 0.0, 1.04, 8)
				eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, thr2_target, 0.0, 1.04, 8)
				simDR_throttle1_use = eng1_N1_thrust_cur
				simDR_throttle2_use = eng2_N1_thrust_cur
				--thr1_anim = math.min(1.0, eng1_N1_thrust_cur)
				--thr2_anim = math.min(1.0, eng2_N1_thrust_cur)
				thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
				thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
				
				axis_throttle_old = B738DR_joy_axis_throttle
				axis_throttle1_old = B738DR_joy_axis_throttle1
				axis_throttle2_old = B738DR_joy_axis_throttle2
				
			elseif at_mode_eng == 9 then	-- speed mode with N1 limit
				lock_throttle = 1
				if B738DR_n1_set_source == 0 then	-- FMC AUTO
					if B738DR_fms_N1_mode == 0 or B738DR_fms_N1_mode == 13 then		-- no mode
						thr1_limit = 1.04
						thr2_limit = 1.04
					else
						thr1_limit = eng1_N1_thrust
						thr2_limit = eng2_N1_thrust
					end
				else 
					thr1_limit = eng1_N1_thrust
					thr2_limit = eng2_N1_thrust
				end
				if simDR_throttle_1 > thr1_limit then
					thr1_target = thr1_limit
				else
					thr1_target = simDR_throttle_1
				end
				if simDR_throttle_2 > thr2_limit then
					thr2_target = thr2_limit
				else
					thr2_target = simDR_throttle_2
				end
				eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, thr1_target, 0.0, 1.04, 8)
				eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, thr2_target, 0.0, 1.04, 8)
				simDR_throttle1_use = eng1_N1_thrust_cur
				simDR_throttle2_use = eng2_N1_thrust_cur
				--thr1_anim = math.min(1.0, eng1_N1_thrust_cur)
				--thr2_anim = math.min(1.0, eng2_N1_thrust_cur)
				thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
				thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
			
				
				axis_throttle_old = B738DR_joy_axis_throttle
				axis_throttle1_old = B738DR_joy_axis_throttle1
				axis_throttle2_old = B738DR_joy_axis_throttle2
				
			elseif at_mode_eng == 6 then	-- LVL CHG
				lock_throttle = 1
				if  B738DR_autoland_status == 0 then
					if eng1_N1_thrust_trg == 0 then		--retard
						eng1_N1_thrust_cur = eng1_N1_thrust_cur - 0.002
						if eng1_N1_thrust_cur < 0 then
							eng1_N1_thrust_cur = 0
						end
					else
						eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, eng1_N1_thrust_trg, 0.0, 1.04, 0.5)	--1.5
					end
					if eng2_N1_thrust_trg == 0 then		--retard
						eng2_N1_thrust_cur = eng2_N1_thrust_cur - 0.002
						if eng2_N1_thrust_cur < 0 then
							eng2_N1_thrust_cur = 0
						end
					else
						eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, eng2_N1_thrust_trg, 0.0, 1.04, 0.5)	--1.5
					end
				else
					eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, eng1_N1_thrust_trg, 0.0, 1.04, 1.0)
					eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, eng2_N1_thrust_trg, 0.0, 1.04, 1.0)
				end
				simDR_throttle1_use = eng1_N1_thrust_cur
				simDR_throttle2_use = eng2_N1_thrust_cur
				simDR_throttle_1 = eng1_N1_thrust_cur
				simDR_throttle_2 = eng2_N1_thrust_cur
				--thr1_anim = math.min(1.0, eng1_N1_thrust_cur)
				--thr2_anim = math.min(1.0, eng2_N1_thrust_cur)
				thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
				thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
				
				thr1_target = eng1_N1_thrust_trg
				thr2_target = eng2_N1_thrust_trg
			
				
				axis_throttle_old = B738DR_joy_axis_throttle
				axis_throttle1_old = B738DR_joy_axis_throttle1
				axis_throttle2_old = B738DR_joy_axis_throttle2
				
			elseif at_mode_eng == 4 or at_mode_eng == 5 or at_mode_eng == 8 then	-- AP and FD GoAround
				lock_throttle = 1
				if ap_goaround == 1 or fd_goaround == 1 then
					if B738DR_n1_set_source == 0 then	-- FMC AUTO
						if B738DR_fms_N1_mode == 0 or B738DR_fms_N1_mode == 13 then		-- no mode
							thr1_limit = 1.04
							thr2_limit = 1.04
						else
							thr1_limit = eng1_N1_thrust
							thr2_limit = eng2_N1_thrust
						end
					else 
						thr1_limit = eng1_N1_thrust
						thr2_limit = eng2_N1_thrust
					end
					if fd_go_disable == 0 and at_mode_eng == 5 then
						thr1_target = eng1_N1_thrust_trg
						thr2_target = eng2_N1_thrust_trg
					else
						if simDR_throttle_1 > thr1_limit then
							thr1_target = thr1_limit
						else
							thr1_target = simDR_throttle_1
						end
						if simDR_throttle_2 > thr2_limit then
							thr2_target = thr2_limit
						else
							thr2_target = simDR_throttle_2
						end
					end
					eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, thr1_target, 0.0, 1.04, 8)
					eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, thr2_target, 0.0, 1.04, 8)
					simDR_throttle1_use = eng1_N1_thrust_cur
					simDR_throttle2_use = eng2_N1_thrust_cur
					--thr1_anim = math.min(1.0, eng1_N1_thrust_cur)
					--thr2_anim = math.min(1.0, eng2_N1_thrust_cur)
					thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
					thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
				else
					eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, eng1_N1_thrust_trg, 0.0, 1.04, 0.5)	--1.5
					eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, eng2_N1_thrust_trg, 0.0, 1.04, 0.5)	--1.5
					simDR_throttle1_use = eng1_N1_thrust_cur
					simDR_throttle2_use = eng2_N1_thrust_cur
					simDR_throttle_1 = eng1_N1_thrust_cur
					simDR_throttle_2 = eng2_N1_thrust_cur
					--thr1_anim = math.min(1.0, eng1_N1_thrust_cur)
					--thr2_anim = math.min(1.0, eng2_N1_thrust_cur)
					thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
					thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
				end
				thr1_target = eng1_N1_thrust_trg
				thr2_target = eng2_N1_thrust_trg
				
				axis_throttle_old = B738DR_joy_axis_throttle
				axis_throttle1_old = B738DR_joy_axis_throttle1
				axis_throttle2_old = B738DR_joy_axis_throttle2
				
			else
				lock_throttle = 1
				eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, eng1_N1_thrust_trg, 0.0, 1.04, 0.5)	--1.5
				eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, eng2_N1_thrust_trg, 0.0, 1.04, 0.5)	--1.5
				simDR_throttle1_use = eng1_N1_thrust_cur
				simDR_throttle2_use = eng2_N1_thrust_cur
				simDR_throttle_1 = eng1_N1_thrust_cur
				simDR_throttle_2 = eng2_N1_thrust_cur
				--thr1_anim = math.min(1.0, eng1_N1_thrust_cur)
				--thr2_anim = math.min(1.0, eng2_N1_thrust_cur)
				thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
				thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
				
				thr1_target = eng1_N1_thrust_trg
				thr2_target = eng2_N1_thrust_trg
				
				axis_throttle_old = B738DR_joy_axis_throttle
				axis_throttle1_old = B738DR_joy_axis_throttle1
				axis_throttle2_old = B738DR_joy_axis_throttle2
				
			end
		
		else
				
			if B738DR_throttle_noise == 0 or lock_throttle == 0 then
				thr1_target = B738_rescale(0, 0, 1, 1.04, simDR_throttle_1)
				thr2_target = B738_rescale(0, 0, 1, 1.04, simDR_throttle_2)
			else
				if B738DR_joy_axis_throttle == -1 then
					
					if B738DR_joy_axis_throttle1 == - 1 and B738DR_joy_axis_throttle2 == -1 then
						lock_throttle = 0
					else
						delta_throttle = math.abs(axis_throttle1_old - B738DR_joy_axis_throttle1)
						if delta_throttle > throttle_noise then
							lock_throttle = 0
						end
						delta_throttle = math.abs(axis_throttle2_old - B738DR_joy_axis_throttle2)
						if delta_throttle > throttle_noise then
							lock_throttle = 0
						end
					end
				else
					delta_throttle = math.abs(axis_throttle_old - B738DR_joy_axis_throttle)
					if delta_throttle > throttle_noise then
						lock_throttle = 0
					end
				end
			end
				
			-- thr1_target = B738_rescale(0, 0, 1, 1.04, simDR_throttle_1)
			-- thr2_target = B738_rescale(0, 0, 1, 1.04, simDR_throttle_2)
			eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, thr1_target, 0.0, 1.04, 2)
			eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, thr2_target, 0.0, 1.04, 2)
			simDR_throttle1_use = eng1_N1_thrust_cur
			simDR_throttle2_use = eng2_N1_thrust_cur
			--thr1_anim = simDR_throttle_1
			--thr2_anim = simDR_throttle_2
			thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
			thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
			--thr1_target = eng1_N1_thrust_trg
			--thr2_target = eng2_N1_thrust_trg
			
		end
	else
		if reverse_max_on1 == 1 then
			if simDR_reverse1_deploy > 0.9 then
				eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, 0.95, 0.0, 1.04, 1.5)
				simDR_throttle1_use = eng1_N1_thrust_cur
				simDR_throttle_1 = eng1_N1_thrust_cur
				--thr1_anim = math.min(1.0, eng1_N1_thrust_cur)
				--thr2_anim = math.min(1.0, eng2_N1_thrust_cur)
				thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
			end
		else
			eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, 0.0, 0.0, 1.04, 1.5)
			simDR_throttle1_use = eng1_N1_thrust_cur
			simDR_throttle_1 = eng1_N1_thrust_cur
			--thr1_anim = math.min(1.0, eng1_N1_thrust_cur)
			--thr2_anim = math.min(1.0, eng2_N1_thrust_cur)
			thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
			if simDR_throttle1_use < 0.01 then
				simDR_reverse1_act = 1
				reverse_max_enable1 = 0
				eng1_N1_thrust_cur = 0
				simDR_throttle1_use = eng1_N1_thrust_cur
				simDR_throttle_1 = 0
			end
		end
		if reverse_max_on2 == 1 then
			if simDR_reverse2_deploy > 0.9 then
				eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, 0.95, 0.0, 1.04, 1.5)
				simDR_throttle2_use = eng2_N1_thrust_cur
				simDR_throttle_2 = eng2_N1_thrust_cur
				thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
			end
		else
			eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, 0.0, 0.0, 1.04, 1.5)
			simDR_throttle2_use = eng2_N1_thrust_cur
			simDR_throttle_2 = eng2_N1_thrust_cur
			thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
			if simDR_throttle2_use < 0.01 then
				simDR_reverse2_act = 1
				reverse_max_enable2 = 0
				eng2_N1_thrust_cur = 0
				simDR_throttle2_use = eng2_N1_thrust_cur
				simDR_throttle_2 = 0
			end
		end
	end
	
	-- B738DR_thrust1_leveler = B738_set_anim_value(B738DR_thrust1_leveler, thr1_anim, 0.0, 1.0, 8)	--thr1_anim
	-- B738DR_thrust2_leveler = B738_set_anim_value(B738DR_thrust2_leveler, thr2_anim, 0.0, 1.0, 8)	--thr2_anim
	--B738DR_thrust1_leveler = B738_set_anim_value(B738DR_thrust1_leveler, thr1_anim, 0.0, 1.0, 8)	--thr1_anim
	--B738DR_thrust2_leveler = B738_set_anim_value(B738DR_thrust2_leveler, thr2_anim, 0.0, 1.0, 8)	--thr2_anim
	B738DR_thrust1_leveler = thr1_anim
	B738DR_thrust2_leveler = thr2_anim
	
end

function control_SPD()
	
	local SPD_act = simDR_airspeed_pilot
	local SPD_err = 0
	local SPD_corr = 0
	local SPD_corr2 = 0
	local SPD_target = B738DR_mcp_speed_dial_kts
	local SPD_predict = 0
	local max_change = 0
	
	max_change = SPD_act - SPD_target
	if max_change < 0 then
		max_change = -max_change
	end
	
	SPD_err = spd_ratio
	if SPD_err < 0 then
		SPD_err = -SPD_err
	end
	
	if lock_at ~= 0 then
		at_lock_time2 = at_lock_time2 + SIM_PERIOD
		if at_lock_time2 > 2 then
			at_lock_time2 = 0
			if max_change > 5.5 and at_spd > 5 then
				lock_at = 0
			end
			at_spd = max_change
		end
	else
		at_lock_time2 = 0
		at_spd = 0
	end
	-- if max_change > 5 and at_spd > 5 then
		-- lock_at = 0
	-- else
		if max_change < 2 and SPD_err < 0.2 and lock_at == 0 then
			lock_at = 2
		end
	-- end
	
	if lock_at == 2 then
		at_lock_time = at_lock_time + SIM_PERIOD
		if at_lock_time > 1 then
			at_lock_time = 0
			if spd_ratio < 0 and at_spd_ratio < 0 then
				at_lock_num = at_lock_num + 1
			elseif spd_ratio > 0 and at_spd_ratio > 0 then
				at_lock_num = at_lock_num + 1
			else
				at_lock_num = 0
			end
			at_spd_ratio = spd_ratio
		end
		if at_lock_num == 6 then
			lock_at = 1
			at_lock_num = 0
		end
	else
		at_lock_time = 0
		at_lock_num = 0
		at_spd_ratio = 0
	end
	
	-- SPD_act2 = B738_set_anim_value(SPD_act2, SPD_act, 0, 500, 1.1)
	-- spd_ratio2 = B738_set_anim_value(spd_ratio2, spd_ratio, -20, 20, 0.8)
	SPD_act2 = SPD_act
	spd_ratio2 = spd_ratio
	
	lock_at = 0
	if lock_at < 2 then
		
		SPD_err = SPD_target - SPD_act2
		SPD_predict = SPD_act2 + (spd_ratio2 * 14)
		
		SPD_corr2 = SPD_target - SPD_predict
		
		if SPD_err < 0 then
			
			if SPD_corr2 > 0 then
				SPD_corr2 = math.min(30, SPD_corr2)
				SPD_corr2 = math.max(0, SPD_corr2)
				SPD_corr2 = 2.0 - B738_rescale(0, 0, 30, 1.8, SPD_corr2)
			else
				SPD_corr2 = 2.0
			end
			
			SPD_corr2 = 2.0
			SPD_corr = -SPD_err
			SPD_corr = math.min(40, SPD_corr)
			SPD_corr = math.max(0, SPD_corr)
			SPD_corr = SPD_corr * 1.5 --* SPD_corr * 3.5
			SPD_corr = math.min(40, SPD_corr)
			SPD_corr = -B738_rescale(0, 0, 40, SPD_corr2, SPD_corr)	-- 3 / sec
		else
			
			if SPD_corr2 < 0 then
				SPD_corr2 = -SPD_corr2
				SPD_corr2 = math.min(30, SPD_corr2)
				SPD_corr2 = math.max(0, SPD_corr2)
				SPD_corr2 = 2.0 - B738_rescale(0, 0, 30, 1.8, SPD_corr2)
			else
				SPD_corr2 = 2.0
			end
			
			SPD_corr2 = 2.0
			SPD_corr = SPD_err
			SPD_corr = math.min(40, SPD_corr)
			SPD_corr = math.max(0, SPD_corr)
			SPD_corr = SPD_corr * 1.5 --* SPD_corr * 3.5
			SPD_corr = math.min(40, SPD_corr)
			SPD_corr = B738_rescale(0, 0, 40, SPD_corr2, SPD_corr)	-- 3 / sec
		end
		
		--B738DR_test_test = spd_ratio2
		--B738DR_test_test2 = SPD_corr
		
		SPD_corr = SPD_corr - spd_ratio2
		SPD_corr = (SPD_corr * 0.02)	--4.2
		
		
		max_change = SPD_corr / SIM_PERIOD
		if max_change > 1.5 then
			SPD_corr = 1.5 * SIM_PERIOD
		end
		if max_change < -1.5 then
			SPD_corr = -1.5 * SIM_PERIOD
		end
	else
		SPD_corr = 0
	end
	
	return SPD_corr
	
end

function Angle180(angle)
	return (angle + 180) % 360
end



function control_SPD1(pid_time_x)
	
	
	local result = 0
	-- local wind_acf = simDR_wind_spd * math.cos(math.rad(Angle180(simDR_wind_hdg))-math.rad(simDR_position_mag_psi))
	-- local wind_comp = (wind_acf - wind_acf_old) / pid_time_x
	-- wind_acf_old = wind_acf
	
	local SPD_act = simDR_airspeed_pilot + (spd_ratio * 4) -- wind_comp
	local SPD_err = B738DR_mcp_speed_dial_kts - SPD_act
	
	--local SPD_out_old = SPD_out
	--local SPD_out_old = math.min(simDR_throttle_1, simDR_throttle_2) * 100
	local SPD_out_old1 = B738_rescale(0, 0, 1.04, 100, eng1_N1_thrust_cur)
	local SPD_out_old2 = B738_rescale(0, 0, 1.04, 100, eng2_N1_thrust_cur)
	local SPD_out_old = math.min(SPD_out_old1, SPD_out_old2)
	
	local SPD_p = B738DR_kp * SPD_err
	
	-- wind up recalc integral
	if B738DR_mcp_speed_dial_kts ~= mcp_dial_old then
		if B738DR_ki == 0 then
			SPD_i = 0
		else
			SPD_i = (1 / B738DR_ki) * (SPD_out - SPD_p)
		end
	end
	mcp_dial_old = B738DR_mcp_speed_dial_kts
	
	-- calc I
	SPD_i = SPD_i + (B738DR_ki * (SPD_err * pid_time_x))
	
	-- calc D
	local SPD_d = 0
	if pid_time_x <= 0 then
		SPD_d = 0
	else
		SPD_d = B738DR_kd * ((SPD_err - SPD_err_old) / pid_time_x)
	end
	
	SPD_err_old = SPD_err
	
	SPD_out = B738DR_bias + SPD_p + SPD_i + SPD_d
	
	--wind-up
	if SPD_out > 100 then
		SPD_out = 100
		if B738DR_ki == 0 then
			SPD_i = 0
		else
			SPD_i = (1 / B738DR_ki) * (SPD_out - B738DR_bias - SPD_p)
		end
	elseif SPD_out < 0 then
		SPD_out = 0
		if B738DR_ki == 0 then
			SPD_i = 0
		else
			SPD_i = (1 / B738DR_ki) * (SPD_out - B738DR_bias - SPD_p)
		end
	end
	
	-- filter output
	--local SPD_out2 = SPD_out - (B738DR_kf * ((SPD_out - SPD_out_old) / pid_time_x))
	local kf = B738DR_kf
	if kf == 0 then
		kf = 60	--7
	end
	
	local limit_out = 0
	if pid_time_x <= 0 then
		limit_out = 0
	else
		limit_out = (SPD_out - SPD_out_old) / pid_time_x
	end
	
	if limit_out > kf then
		SPD_out = SPD_out_old + (kf * pid_time_x)
	elseif limit_out < -kf then
		SPD_out = SPD_out_old - (kf * pid_time_x)
	end
	
	if SPD_out > 100 then
		SPD_out = 100
		if B738DR_ki == 0 then
			SPD_i = 0
		else
			SPD_i = (1 / B738DR_ki) * (SPD_out - B738DR_bias - SPD_p)
		end
	elseif SPD_out < 0 then
		SPD_out = 0
		if B738DR_ki == 0 then
			SPD_i = 0
		else
			SPD_i = (1 / B738DR_ki) * (SPD_out - B738DR_bias - SPD_p)
		end
	end
	
	--result = SPD_out * 0.01
	
	B738DR_pid_p = SPD_p
	B738DR_pid_i = SPD_i
	B738DR_pid_d = SPD_d
	B738DR_pid_out = SPD_out
	
	result = (SPD_out - SPD_out_old) * 0.01
	
	return result
end


function control_SPD2(pid_time_x)
	
	
	local result = 0
	-- local wind_acf = simDR_wind_spd * math.cos(math.rad(Angle180(simDR_wind_hdg))-math.rad(simDR_position_mag_psi))
	-- local wind_comp = (wind_acf - wind_acf_old) / pid_time_x
	-- wind_acf_old = wind_acf
	
	local SPD_act = simDR_airspeed_pilot + (spd_ratio * 4) --- wind_comp
	local SPD_err = B738DR_mcp_speed_dial_kts - SPD_act
	
	local SPD_p = B738DR_kp * (1 + (pid_time_x / B738DR_ki)) * SPD_err
	local SPD_d = B738DR_kd * SPD_err_old
	
	SPD_out = SPD_p - SPD_d
	
	SPD_err_old = SPD_err
	
	B738DR_pid_p = SPD_p
	B738DR_pid_i = SPD_i
	B738DR_pid_d = SPD_d
	B738DR_pid_out = SPD_out
	
	--result = (SPD_out - SPD_out_old) * 0.01
	
	local limit_out = SPD_out / pid_time_x
	if limit_out > B738DR_kf then
		SPD_out = B738DR_kf * pid_time_x
	end
	if limit_out < -B738DR_kf then
		SPD_out = -B738DR_kf * pid_time_x
	end
	
	result = SPD_out
	
	return result
end


function control_SPD3(pid_time_x)
	
	
	local result = 0
	-- local wind_acf = simDR_wind_spd * math.cos(math.rad(Angle180(simDR_wind_hdg))-math.rad(simDR_position_mag_psi))
	-- local wind_comp = (wind_acf - wind_acf_old) / pid_time_x
	-- wind_acf_old = wind_acf
	
	local pid_p_old = SPD_p
	local pid_i_old = SPD_i
	local pid_d_old = SPD_d
	local pid_out_old = pid_p_old + pid_i_old + pid_d_old
	
	
	local SPD_act = simDR_airspeed_pilot + (spd_ratio * B738DR_bias) -- wind_comp
	local SPD_err = B738DR_mcp_speed_dial_kts - SPD_act
	
	--local SPD_out_old = SPD_out
	--local SPD_out_old = math.min(simDR_throttle_1, simDR_throttle_2) * 100
	local SPD_out_old1 = B738_rescale(0, 0, 1.04, 100, eng1_N1_thrust_cur)
	local SPD_out_old2 = B738_rescale(0, 0, 1.04, 100, eng2_N1_thrust_cur)
	local SPD_out_old = math.min(SPD_out_old1, SPD_out_old2)
	-- local SPD_out_old = SPD_out
	
	SPD_p = B738DR_kp * SPD_err
	
	-- wind up recalc integral
	-- if B738DR_mcp_speed_dial_kts ~= mcp_dial_old then
		-- SPD_i = 0
		-- else
			-- SPD_i = (1 / B738DR_ki) * (SPD_out - SPD_p)
		-- end
	-- end
	mcp_dial_old = B738DR_mcp_speed_dial_kts
	
	-- calc I
	SPD_i = SPD_i + (B738DR_ki * (SPD_err * pid_time_x))
	
	-- calc D
	SPD_d = 0
	if pid_time_x <= 0 then
		SPD_d = 0
	else
		SPD_d = B738DR_kd * ((SPD_err - SPD_err_old) / pid_time_x)
	end
	
	SPD_err_old = SPD_err
	
	SPD_out = SPD_p + SPD_i + SPD_d
	
	-- if SPD_out > 100 then
		-- if SPD_i > 0 then
			-- SPD_i = 0 --pid_i_old	-- 0
		-- end
		-- SPD_out = 100
	-- elseif SPD_out < 0 then
		-- if SPD_i < 0 then
			-- SPD_i = 0	--pid_i_old	-- 0
		-- end
		-- SPD_out = 0
	-- end
	
	-- filter output
	--local SPD_out2 = SPD_out - (B738DR_kf * ((SPD_out - SPD_out_old) / pid_time_x))
	local kf = B738DR_kf
	if kf == 0 then
		kf = 60	--7
	end
	
	local limit_out = 0
	if pid_time_x <= 0 then
		limit_out = 0
	else
		limit_out = (SPD_out - SPD_out_old) / pid_time_x
	end
	
	if limit_out > kf then
		SPD_out = SPD_out_old + (kf * pid_time_x)
	elseif limit_out < -kf then
		SPD_out = SPD_out_old - (kf * pid_time_x)
	end
	
	if SPD_out > 100 then
		if SPD_i > 0 then
			SPD_i = 0	--pid_i_old
		end
		SPD_out = 100
	elseif SPD_out < 0 then
		if SPD_i < 0 then
			SPD_i = 0	--pid_i_old
		end
		SPD_out = 0
	end
	
	--result = SPD_out * 0.01
	local pid_out = SPD_out - SPD_out_old
	
	
	B738DR_pid_p = SPD_p
	B738DR_pid_i = SPD_i
	B738DR_pid_d = SPD_d
	B738DR_pid_out = pid_out
	
	result = pid_out * 0.01
	
	return result
end



function control_N1(N1_lim1, N1_lim2)
	
	local N1_corr = 0
	
	local eng_N1_ratio = math.max(B738DR_eng1_N1_ratio, B738DR_eng2_N1_ratio)
	local eng_N1 = math.max(N1_lim1, N1_lim2) * 100
	local eng_N1_pct = math.max(simDR_engine_N1_pct1, simDR_engine_N1_pct2)
	local N1_err = eng_N1 - eng_N1_pct
	
	if N1_err < 0 then
		N1_corr = -N1_err
		N1_corr = math.min(25, N1_corr)
		N1_corr = math.max(0, N1_corr)
		N1_corr = -B738_rescale(0, 0, 25, 40, N1_corr)
	else
		N1_corr = N1_err
		N1_corr = math.min(25, N1_corr)
		N1_corr = math.max(0, N1_corr)
		N1_corr = B738_rescale(0, 0, 25, 40, N1_corr)
	end
	
	N1_corr = N1_corr - (eng_N1_ratio * 1)
	N1_corr = ((N1_corr / 100) * SIM_PERIOD * 70)
	
	return N1_corr
	
end

function rst_ghust_detect2()
	ghust_detect2 = 0
end

-- function rst_ghust_detect()
	-- ghust_detect = 0
-- end

function rst_block_ghust()
	block_ghust = 0
end

function control_SPD4()
	
	local SPD_corr = 0
	local SPD_corr2 = 0
	
	-- local wind_acf = simDR_wind_spd * math.cos(math.rad(Angle180(simDR_wind_hdg))-math.rad(simDR_position_mag_psi))
	-- local wind_comp = (wind_acf - wind_acf_old) / pid_time_x
	-- wind_acf_old = wind_acf
	
	local actual_err = 0
	if autopilot_cmd_b_status == 1 then
		actual_err = B738DR_mcp_speed_dial_kts - simDR_airspeed_copilot
	else
		actual_err = B738DR_mcp_speed_dial_kts - simDR_airspeed_pilot
	end
	
	--local SPD_delta = spd_ratio - gnd_spd_ratio
	local SPD_delta = spd_ratio_old
	if SPD_delta < 0 then
		SPD_delta = -SPD_delta
	end
	
	-- if ghust_detect == 0 then
		-- -- if actual_err < 3.5 and actual_err > -3.5 then
			-- -- if SPD_delta > 0.45 then
				-- -- ghust_detect = 1
			-- -- end
			-- -- if spd_ratio > -0.4 and spd_ratio < 0.4 then
				-- -- ghust_detect = 1
			-- -- end
		-- -- end
		
		-- if SPD_delta > 0.95 then	--0.45
			-- if actual_err < 6 and actual_err > -6 then
				-- if is_timer_scheduled(rst_ghust_detect) == true then
					-- stop_timer(rst_ghust_detect)
				-- end
				-- ghust_detect = 1
			-- end
		-- -- else
			-- -- if actual_err < 3.5 and actual_err > -3.5 then
				-- -- --if spd_ratio > -0.4 and spd_ratio < 0.4 then
				-- -- if spd_ratio > -0.2 and spd_ratio < 0.2 then
					-- -- ghust_detect = 1
				-- -- end
			-- -- end
		-- end
	-- else
		-- if SPD_delta > 0.95 then	--0.45
			-- --if (actual_err > 8 or actual_err < -8) and (spd_ratio < -0.8 or spd_ratio > 0.8) then
			-- if (actual_err > 8 or actual_err < -8) and (spd_ratio < -0.5 or spd_ratio > 0.5) then
				-- ghust_detect = 0
			-- end
		-- else
			-- if is_timer_scheduled(rst_ghust_detect) == false then
				-- run_after_time(rst_ghust_detect, 10)
			-- end
		-- end
	-- end
	
	-- -- if SPD_delta > 0.65 then	--0.45
		-- -- if is_timer_scheduled(rst_ghust_detect2) == true then
			-- -- stop_timer(rst_ghust_detect2)
		-- -- end
		-- -- run_after_time(rst_ghust_detect2, 5)
		-- -- ghust_detect2 = 1
	-- -- end
	
	-- if actual_err > 20 or actual_err < -20 then
		-- ghust_detect = 0
		-- -- ghust_detect2 = 0
	-- end
	
	local SPD_act = 0
	if autopilot_cmd_b_status == 1 then
		SPD_act = simDR_airspeed_copilot
	else
		SPD_act = simDR_airspeed_pilot
	end
	
	local SPD_err = B738DR_mcp_speed_dial_kts - SPD_act
	
	if SPD_err < 0 then
		SPD_corr = -SPD_err
		SPD_corr = math.min(17, SPD_corr)	--14
		SPD_corr = math.max(0, SPD_corr)
		SPD_corr2 = math.min(2, SPD_corr)
		--SPD_corr = -B738_rescale(0, 0, 580, 40, SPD_corr)
		--SPD_corr = -B738_rescale(0, 0, 20, 1.38, SPD_corr)
		--SPD_corr = -B738_rescale(0, 0, 14, 1.4, SPD_corr)
		SPD_corr = -B738_rescale(0, 0, 17, 1.4, SPD_corr)
	else
		SPD_corr = SPD_err
		SPD_corr = math.min(17, SPD_corr)	--14
		SPD_corr = math.max(0, SPD_corr)
		SPD_corr2 = math.min(2, SPD_corr)
		--SPD_corr = B738_rescale(0, 0, 580, 40, SPD_corr)
		--SPD_corr = B738_rescale(0, 0, 20, 1.38, SPD_corr)	--1.38
		--SPD_corr = B738_rescale(0, 0, 14, 1.4, SPD_corr)
		SPD_corr = B738_rescale(0, 0, 17, 1.4, SPD_corr)
	end
	
	--B738DR_pid_out = ghust_spd
	--B738DR_pid_p = SPD_delta
	
	SPD_corr = SPD_corr - spd_ratio
	--SPD_corr = SPD_corr * SIM_PERIOD * 7	--10 --12	--16
	
	SPD_corr2 = B738_rescale(0, 2, 2, 7, SPD_corr2)
	SPD_corr = SPD_corr * SIM_PERIOD * SPD_corr2
	-- if SPD_err > -1 and SPD_err < 1 then
		-- SPD_corr = SPD_corr * SIM_PERIOD * 2	--4	--10 --12	--16
	-- else
		-- SPD_corr = SPD_corr * SIM_PERIOD * 7	--10 --12	--16
	-- end
	
	local limit = 18	--15	--10	--20
	
	if simDR_autopilot_altitude_mode ~= altitude_mode_old then
		if altitude_mode_old ~= 0 and B738DR_autoland_status == 0 then
			block_ghust = 1
			if is_timer_scheduled(rst_block_ghust) == true then
				stop_timer(rst_block_ghust)
			end
			run_after_time(rst_block_ghust, 5)
		end
	end
	
	--block_ghust = 1
	if block_ghust == 1 then
		limit = 18
	elseif ghust_detect == 1 and actual_err > -5 and actual_err < 5 then
		limit = 1.5	--1
	-- elseif ghust_detect2 == 1 then
		-- limit = 5
	end
	B738DR_pid_out = limit
	--B738DR_test_test = limit
	
	ghust_spd = B738_set_anim_value(ghust_spd, limit, 0.0, 20, 0.5)		--20
	
	limit = ghust_spd * SIM_PERIOD
	
	if SPD_corr > limit then
		SPD_corr = limit
	end
	if SPD_corr < -limit then
		SPD_corr = -limit
	end
	
	return SPD_corr
	
end


function B738_N1_thrust_manage4()

	--local thr1_target = 0
	--local thr2_target = 0
	local thr1_limit = 0
	local thr2_limit = 0
	local thr1_anim = 0
	local thr2_anim = 0
	local delta_throttle = 0
	local throttle_noise = B738DR_throttle_noise / 100
	local throttle_limit = 0
	local throttle_limit2 = 0
	local control_N1_thrust = 0
	local control_N1_thrust2 = 0
	local SPD_out_old1 = 0
	local SPD_out_old2 = 0
	
	if reverse_max_enable1 == 0 and reverse_max_enable2 == 0 then
		thr1_target = eng1_N1_thrust_cur
		thr2_target = eng2_N1_thrust_cur
		
		if at_throttle_hold == 0 then		-- manual throttle
			
			if at_mode_eng == 0 then
				
				
				if B738DR_throttle_noise == 0 or lock_throttle == 0 then
					thr1_target = B738_rescale(0, 0, 1, 1.04, simDR_throttle_1)
					thr2_target = B738_rescale(0, 0, 1, 1.04, simDR_throttle_2)
				else
					if B738DR_joy_axis_throttle == -1 then
						
						if B738DR_joy_axis_throttle1 == -1 and B738DR_joy_axis_throttle2 == -1 then
							lock_throttle = 0
						else
							delta_throttle = math.abs(axis_throttle1_old - B738DR_joy_axis_throttle1)
							if delta_throttle > throttle_noise then
								lock_throttle = 0
							end
							delta_throttle = math.abs(axis_throttle2_old - B738DR_joy_axis_throttle2)
							if delta_throttle > throttle_noise then
								lock_throttle = 0
							end
						end
					else
						delta_throttle = math.abs(axis_throttle_old - B738DR_joy_axis_throttle)
						if delta_throttle > throttle_noise then
							lock_throttle = 0
						end
					end
				end
				
				eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, thr1_target, 0.0, 1.04, 10)
				eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, thr2_target, 0.0, 1.04, 10)
				simDR_throttle1_use = eng1_N1_thrust_cur
				simDR_throttle2_use = eng2_N1_thrust_cur
				
				thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
				thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
				
				ghust_detect = 0
				ghust_detect2 = 0
				ghust_spd = 10
				block_ghust = 0
				ghust_detect_block = 0
				-- SPD_err_old = 0
				-- SPD_p = 0
				-- SPD_i = 0
				-- SPD_d = 0
				-- --SPD_out = math.min(simDR_throttle_1, simDR_throttle_2) * 100
				-- SPD_out_old1 = B738_rescale(0, 0, 1.04, 100, eng1_N1_thrust_cur)
				-- SPD_out_old2 = B738_rescale(0, 0, 1.04, 100, eng2_N1_thrust_cur)
				-- SPD_out = math.min(SPD_out_old1, SPD_out_old2)
				
				-- thr1_target_pid = simDR_throttle_1
				-- thr2_target_pid = simDR_throttle_2
				-- pid_time = 0
				-- mcp_dial_old = 0
				
			elseif at_mode_eng == 2 then	-- speed mode
				lock_throttle = 1
				
				throttle_limit2 = control_SPD4()
				throttle_limit = control_N1(B738DR_eng1_N1_bug, B738DR_eng2_N1_bug)
				throttle_limit = math.min(throttle_limit, throttle_limit2)
				thr1_target = eng1_N1_thrust_cur + throttle_limit
				thr2_target = eng2_N1_thrust_cur + throttle_limit
				
				eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, thr1_target, 0.0, 1.04, 0.5)	--2.0
				eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, thr2_target, 0.0, 1.04, 0.5)	--2.0
				
				simDR_throttle1_use = eng1_N1_thrust_cur
				simDR_throttle2_use = eng2_N1_thrust_cur
				
				thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
				thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
				
				simDR_throttle_1 = B738_rescale(0, 0, 1.04, 1.0, simDR_throttle1_use)
				simDR_throttle_2 = B738_rescale(0, 0, 1.04, 1.0, simDR_throttle2_use)
				
				axis_throttle_old = B738DR_joy_axis_throttle
				axis_throttle1_old = B738DR_joy_axis_throttle1
				axis_throttle2_old = B738DR_joy_axis_throttle2
				
			elseif at_mode_eng == 9 then	-- speed mode with N1 limit
				
				lock_throttle = 1
				
				throttle_limit2 = control_SPD4()
				throttle_limit = control_N1(B738DR_eng1_N1_bug, B738DR_eng2_N1_bug)
				throttle_limit = math.min(throttle_limit, throttle_limit2)
				thr1_target = eng1_N1_thrust_cur + throttle_limit
				thr2_target = eng2_N1_thrust_cur + throttle_limit
				
				eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, thr1_target, 0.0, 1.04, 0.5)	--2.0
				eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, thr2_target, 0.0, 1.04, 0.5)	--2.0
				
				simDR_throttle1_use = eng1_N1_thrust_cur
				simDR_throttle2_use = eng2_N1_thrust_cur
				
				thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
				thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
				
				simDR_throttle_1 = B738_rescale(0, 0, 1.04, 1.0, simDR_throttle1_use)
				simDR_throttle_2 = B738_rescale(0, 0, 1.04, 1.0, simDR_throttle2_use)
				
				axis_throttle_old = B738DR_joy_axis_throttle
				axis_throttle1_old = B738DR_joy_axis_throttle1
				axis_throttle2_old = B738DR_joy_axis_throttle2
				
			elseif at_mode_eng == 6 or at_mode_eng == 7 then	-- LVL CHG and VNAV
				lock_throttle = 1
				if B738DR_autoland_status == 0 then
					if eng1_N1_thrust_trg == 0 then		--retard
						--eng1_N1_thrust_cur = eng1_N1_thrust_cur - 0.002
						eng1_N1_thrust_cur = eng1_N1_thrust_cur - (0.15 * SIM_PERIOD)
						if eng1_N1_thrust_cur < 0 then
							eng1_N1_thrust_cur = 0
						end
					else
						control_N1_thrust = control_N1(B738DR_eng1_N1_bug, B738DR_eng2_N1_bug)
						-- control_N1_thrust2 = (control_N1_thrust / SIM_PERIOD) * 100
						-- if control_N1_thrust2 > 0.5 then
							-- control_N1_thrust = 0.5
						-- end
						-----
						eng1_N1_thrust_trg = eng1_N1_thrust_cur + control_N1_thrust
						-- control_N1_thrust2 = eng1_N1_thrust_trg - eng1_N1_thrust_cur
						
						-- if control_N1_thrust2 > (0.15 * SIM_PERIOD) then
							-- eng1_N1_thrust_trg = eng1_N1_thrust_cur + (0.15 * SIM_PERIOD)
						-- -- elseif control_N1_thrust2 < (-0.05 * SIM_PERIOD) then
							-- -- eng1_N1_thrust_trg = eng1_N1_thrust_cur - (0.05 * SIM_PERIOD)
						-- end
						--------
						--eng1_N1_thrust_trg = eng1_N1_thrust_cur + control_N1_thrust
						eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, eng1_N1_thrust_trg, 0.0, 1.04, 0.15)	--1.5
					end
					if eng2_N1_thrust_trg == 0 then		--retard
						--eng2_N1_thrust_cur = eng2_N1_thrust_cur - 0.002
						eng2_N1_thrust_cur = eng2_N1_thrust_cur - (0.15 * SIM_PERIOD)
						if eng2_N1_thrust_cur < 0 then
							eng2_N1_thrust_cur = 0
						end
					else
						control_N1_thrust = control_N1(B738DR_eng1_N1_bug, B738DR_eng2_N1_bug)
						--control_N1_thrust2 = (control_N1_thrust / SIM_PERIOD) * 100
						-- if control_N1_thrust2 > 0.5 then
							-- control_N1_thrust = 0.5
						-- end
						-----
						eng2_N1_thrust_trg = eng2_N1_thrust_cur + control_N1_thrust
						-- control_N1_thrust2 = eng2_N1_thrust_trg - eng2_N1_thrust_cur
						
						-- if control_N1_thrust2 > (0.15 * SIM_PERIOD) then
							-- eng2_N1_thrust_trg = eng2_N1_thrust_cur + (0.15 * SIM_PERIOD)
						-- -- elseif control_N1_thrust2 < -B738DR_kf then
							-- -- eng2_N1_thrust_trg = eng2_N1_thrust_cur - (0.05 * SIM_PERIOD)
						-- end
						--------
						-- eng1_N1_thrust_trg = eng1_N1_thrust_cur + control_N1_thrust
						-- eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, eng1_N1_thrust_trg, 0.0, 1.04, 0.11)	--1.5
						--eng2_N1_thrust_trg = eng2_N1_thrust_cur + control_N1_thrust
						eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, eng2_N1_thrust_trg, 0.0, 1.04, 0.15)	--1.5
					end
				else
					eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, eng1_N1_thrust_trg, 0.0, 1.04, 1.0)
					eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, eng2_N1_thrust_trg, 0.0, 1.04, 1.0)
				end
				simDR_throttle1_use = eng1_N1_thrust_cur
				simDR_throttle2_use = eng2_N1_thrust_cur
				-- simDR_throttle_1 = eng1_N1_thrust_cur
				-- simDR_throttle_2 = eng2_N1_thrust_cur
				--thr1_anim = math.min(1.0, eng1_N1_thrust_cur)
				--thr2_anim = math.min(1.0, eng2_N1_thrust_cur)
				thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
				thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
				
				thr1_target = eng1_N1_thrust_trg
				thr2_target = eng2_N1_thrust_trg
				
				simDR_throttle_1 = B738_rescale(0, 0, 1.04, 1.0, simDR_throttle1_use)
				simDR_throttle_2 = B738_rescale(0, 0, 1.04, 1.0, simDR_throttle2_use)
				
				axis_throttle_old = B738DR_joy_axis_throttle
				axis_throttle1_old = B738DR_joy_axis_throttle1
				axis_throttle2_old = B738DR_joy_axis_throttle2
				
				-- SPD_err_old = 0
				-- SPD_p = 0
				-- SPD_i = 0
				-- SPD_d = 0
				-- SPD_out_old1 = B738_rescale(0, 0, 1.04, 100, eng1_N1_thrust_cur)
				-- SPD_out_old2 = B738_rescale(0, 0, 1.04, 100, eng2_N1_thrust_cur)
				-- SPD_out = math.min(SPD_out_old1, SPD_out_old2)
				-- thr1_target_pid = simDR_throttle_1
				-- thr2_target_pid = simDR_throttle_2
				-- pid_time = 0
				-- mcp_dial_old = 0
			
			elseif at_mode_eng == 4 or at_mode_eng == 5 or at_mode_eng == 8 then	-- AP and FD GoAround
				lock_throttle = 1
				-- if ap_goaround == 1 or fd_goaround == 1 then
					-- if B738DR_n1_set_source == 0 then	-- FMC AUTO
						-- if B738DR_fms_N1_mode == 0 or B738DR_fms_N1_mode == 13 then		-- no mode
							-- thr1_limit = 1.04
							-- thr2_limit = 1.04
						-- else
							-- thr1_limit = eng1_N1_thrust
							-- thr2_limit = eng2_N1_thrust
						-- end
					-- else 
						-- thr1_limit = eng1_N1_thrust
						-- thr2_limit = eng2_N1_thrust
					-- end
					-- if fd_go_disable == 0 and at_mode_eng == 5 then
						-- thr1_target = eng1_N1_thrust_trg
						-- thr2_target = eng2_N1_thrust_trg
					-- else
						-- if simDR_throttle_1 > thr1_limit then
							-- thr1_target = thr1_limit
						-- else
							-- thr1_target = simDR_throttle_1
						-- end
						-- if simDR_throttle_2 > thr2_limit then
							-- thr2_target = thr2_limit
						-- else
							-- thr2_target = simDR_throttle_2
						-- end
					-- end
					-- eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, thr1_target, 0.0, 1.04, 8)
					-- eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, thr2_target, 0.0, 1.04, 8)
					-- simDR_throttle1_use = eng1_N1_thrust_cur
					-- simDR_throttle2_use = eng2_N1_thrust_cur
					-- thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
					-- thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
				-- else
					-- eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, eng1_N1_thrust_trg, 0.0, 1.04, 0.5)	--1.5
					-- eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, eng2_N1_thrust_trg, 0.0, 1.04, 0.5)	--1.5
					-- simDR_throttle1_use = eng1_N1_thrust_cur
					-- simDR_throttle2_use = eng2_N1_thrust_cur
					-- simDR_throttle_1 = eng1_N1_thrust_cur
					-- simDR_throttle_2 = eng2_N1_thrust_cur
					-- thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
					-- thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
				-- end
				
				control_N1_thrust = control_N1(B738DR_eng1_N1_bug, B738DR_eng2_N1_bug)
				eng1_N1_thrust_trg = eng1_N1_thrust_cur + control_N1_thrust
				eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, eng1_N1_thrust_trg, 0.0, 1.04, 0.15)
				
				control_N1_thrust = control_N1(B738DR_eng1_N1_bug, B738DR_eng2_N1_bug)
				eng2_N1_thrust_trg = eng2_N1_thrust_cur + control_N1_thrust
				eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, eng2_N1_thrust_trg, 0.0, 1.04, 0.15)
				
				-- eng1_N1_thrust_trg = eng1_N1_thrust_cur + control_N1(eng1_N1_thrust_trg, eng2_N1_thrust_trg)
				-- eng2_N1_thrust_trg = eng2_N1_thrust_cur + control_N1(eng1_N1_thrust_trg, eng2_N1_thrust_trg)
				-- eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, eng1_N1_thrust_trg, 0.0, 1.04, 0.5)
				-- eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, eng2_N1_thrust_trg, 0.0, 1.04, 0.5)
				
				simDR_throttle1_use = eng1_N1_thrust_cur
				simDR_throttle2_use = eng2_N1_thrust_cur
				-- simDR_throttle_1 = eng1_N1_thrust_cur
				-- simDR_throttle_2 = eng2_N1_thrust_cur
				thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
				thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
				
				thr1_target = eng1_N1_thrust_trg
				thr2_target = eng2_N1_thrust_trg
				
				simDR_throttle_1 = B738_rescale(0, 0, 1.04, 1.0, simDR_throttle1_use)
				simDR_throttle_2 = B738_rescale(0, 0, 1.04, 1.0, simDR_throttle2_use)
				
				axis_throttle_old = B738DR_joy_axis_throttle
				axis_throttle1_old = B738DR_joy_axis_throttle1
				axis_throttle2_old = B738DR_joy_axis_throttle2
				
				-- SPD_err_old = 0
				-- SPD_p = 0
				-- SPD_i = 0
				-- SPD_d = 0
				-- SPD_out_old1 = B738_rescale(0, 0, 1.04, 100, eng1_N1_thrust_cur)
				-- SPD_out_old2 = B738_rescale(0, 0, 1.04, 100, eng2_N1_thrust_cur)
				-- SPD_out = math.min(SPD_out_old1, SPD_out_old2)
				-- thr1_target_pid = simDR_throttle_1
				-- thr2_target_pid = simDR_throttle_2
				-- pid_time = 0
				-- mcp_dial_old = 0
			
			else
				lock_throttle = 1
				
				eng1_N1_thrust_trg = eng1_N1_thrust_cur + control_N1(B738DR_eng1_N1_bug, B738DR_eng2_N1_bug)
				eng2_N1_thrust_trg = eng2_N1_thrust_cur + control_N1(B738DR_eng1_N1_bug, B738DR_eng2_N1_bug)
				if at_mode_eng == 3 then
					eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, eng1_N1_thrust_trg, 0.0, 1.04, 0.38)
					eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, eng2_N1_thrust_trg, 0.0, 1.04, 0.38)
				else
					eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, eng1_N1_thrust_trg, 0.0, 1.04, 0.5)
					eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, eng2_N1_thrust_trg, 0.0, 1.04, 0.5)
				end
				
				simDR_throttle1_use = eng1_N1_thrust_cur
				simDR_throttle2_use = eng2_N1_thrust_cur
				-- simDR_throttle_1 = eng1_N1_thrust_cur
				-- simDR_throttle_2 = eng2_N1_thrust_cur
				thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
				thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
				
				thr1_target = eng1_N1_thrust_trg
				thr2_target = eng2_N1_thrust_trg
				
				simDR_throttle_1 = B738_rescale(0, 0, 1.04, 1.0, simDR_throttle1_use)
				simDR_throttle_2 = B738_rescale(0, 0, 1.04, 1.0, simDR_throttle2_use)
				
				axis_throttle_old = B738DR_joy_axis_throttle
				axis_throttle1_old = B738DR_joy_axis_throttle1
				axis_throttle2_old = B738DR_joy_axis_throttle2
				
				-- SPD_err_old = 0
				-- SPD_p = 0
				-- SPD_i = 0
				-- SPD_d = 0
				-- SPD_out_old1 = B738_rescale(0, 0, 1.04, 100, eng1_N1_thrust_cur)
				-- SPD_out_old2 = B738_rescale(0, 0, 1.04, 100, eng2_N1_thrust_cur)
				-- SPD_out = math.min(SPD_out_old1, SPD_out_old2)
				-- thr1_target_pid = simDR_throttle_1
				-- thr2_target_pid = simDR_throttle_2
				-- pid_time = 0
				-- mcp_dial_old = 0
			
			end
		
		else
				
			if B738DR_throttle_noise == 0 or lock_throttle == 0 then
				thr1_target = B738_rescale(0, 0, 1, 1.04, simDR_throttle_1)
				thr2_target = B738_rescale(0, 0, 1, 1.04, simDR_throttle_2)
			else
				if B738DR_joy_axis_throttle == -1 then
					
					if B738DR_joy_axis_throttle1 == - 1 and B738DR_joy_axis_throttle2 == -1 then
						lock_throttle = 0
					else
						delta_throttle = math.abs(axis_throttle1_old - B738DR_joy_axis_throttle1)
						if delta_throttle > throttle_noise then
							lock_throttle = 0
						end
						delta_throttle = math.abs(axis_throttle2_old - B738DR_joy_axis_throttle2)
						if delta_throttle > throttle_noise then
							lock_throttle = 0
						end
					end
				else
					delta_throttle = math.abs(axis_throttle_old - B738DR_joy_axis_throttle)
					if delta_throttle > throttle_noise then
						lock_throttle = 0
					end
				end
			end
				
			-- thr1_target = B738_rescale(0, 0, 1, 1.04, simDR_throttle_1)
			-- thr2_target = B738_rescale(0, 0, 1, 1.04, simDR_throttle_2)
			eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, thr1_target, 0.0, 1.04, 2)
			eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, thr2_target, 0.0, 1.04, 2)
			simDR_throttle1_use = eng1_N1_thrust_cur
			simDR_throttle2_use = eng2_N1_thrust_cur
			--thr1_anim = simDR_throttle_1
			--thr2_anim = simDR_throttle_2
			thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
			thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
			--thr1_target = eng1_N1_thrust_trg
			--thr2_target = eng2_N1_thrust_trg
			
			-- SPD_err_old = 0
			-- SPD_p = 0
			-- SPD_i = 0
			-- SPD_d = 0
			-- SPD_out_old1 = B738_rescale(0, 0, 1.04, 100, eng1_N1_thrust_cur)
			-- SPD_out_old2 = B738_rescale(0, 0, 1.04, 100, eng2_N1_thrust_cur)
			-- SPD_out = math.min(SPD_out_old1, SPD_out_old2)
			-- thr1_target_pid = simDR_throttle_1
			-- thr2_target_pid = simDR_throttle_2
			-- pid_time = 0
			-- mcp_dial_old = 0
			
		end
	else
		if reverse_max_on1 == 1 then
			if simDR_reverse1_deploy > 0.9 then
				eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, 0.95, 0.0, 1.04, 1.5)
				simDR_throttle1_use = eng1_N1_thrust_cur
				simDR_throttle_1 = eng1_N1_thrust_cur
				--thr1_anim = math.min(1.0, eng1_N1_thrust_cur)
				--thr2_anim = math.min(1.0, eng2_N1_thrust_cur)
				thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
			end
		else
			eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, 0.0, 0.0, 1.04, 1.5)
			simDR_throttle1_use = eng1_N1_thrust_cur
			simDR_throttle_1 = eng1_N1_thrust_cur
			--thr1_anim = math.min(1.0, eng1_N1_thrust_cur)
			--thr2_anim = math.min(1.0, eng2_N1_thrust_cur)
			thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
			if simDR_throttle1_use < 0.01 then
				simDR_reverse1_act = 1
				reverse_max_enable1 = 0
				eng1_N1_thrust_cur = 0
				simDR_throttle1_use = eng1_N1_thrust_cur
				simDR_throttle_1 = 0
			end
		end
		if reverse_max_on2 == 1 then
			if simDR_reverse2_deploy > 0.9 then
				eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, 0.95, 0.0, 1.04, 1.5)
				simDR_throttle2_use = eng2_N1_thrust_cur
				simDR_throttle_2 = eng2_N1_thrust_cur
				thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
			end
		else
			eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, 0.0, 0.0, 1.04, 1.5)
			simDR_throttle2_use = eng2_N1_thrust_cur
			simDR_throttle_2 = eng2_N1_thrust_cur
			thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
			if simDR_throttle2_use < 0.01 then
				simDR_reverse2_act = 1
				reverse_max_enable2 = 0
				eng2_N1_thrust_cur = 0
				simDR_throttle2_use = eng2_N1_thrust_cur
				simDR_throttle_2 = 0
			end
		end
		
		-- SPD_err_old = 0
		-- SPD_p = 0
		-- SPD_i = 0
		-- SPD_d = 0
		-- SPD_out_old1 = B738_rescale(0, 0, 1.04, 100, eng1_N1_thrust_cur)
		-- SPD_out_old2 = B738_rescale(0, 0, 1.04, 100, eng2_N1_thrust_cur)
		-- SPD_out = math.min(SPD_out_old1, SPD_out_old2)
		-- thr1_target_pid = simDR_throttle_1
		-- thr2_target_pid = simDR_throttle_2
		-- pid_time = 0
		-- mcp_dial_old = 0
			
	end
	
	-- B738DR_thrust1_leveler = B738_set_anim_value(B738DR_thrust1_leveler, thr1_anim, 0.0, 1.0, 8)	--thr1_anim
	-- B738DR_thrust2_leveler = B738_set_anim_value(B738DR_thrust2_leveler, thr2_anim, 0.0, 1.0, 8)	--thr2_anim
	--B738DR_thrust1_leveler = B738_set_anim_value(B738DR_thrust1_leveler, thr1_anim, 0.0, 1.0, 8)	--thr1_anim
	--B738DR_thrust2_leveler = B738_set_anim_value(B738DR_thrust2_leveler, thr2_anim, 0.0, 1.0, 8)	--thr2_anim
	B738DR_thrust1_leveler = thr1_anim
	B738DR_thrust2_leveler = thr2_anim
	
end















function B738_N1_thrust_manage3()

	--local thr1_target = 0
	--local thr2_target = 0
	local thr1_limit = 0
	local thr2_limit = 0
	local thr1_anim = 0
	local thr2_anim = 0
	local delta_throttle = 0
	local throttle_noise = B738DR_throttle_noise / 100

	if reverse_max_enable1 == 0 and reverse_max_enable2 == 0 then
		thr1_target = eng1_N1_thrust_cur
		thr2_target = eng2_N1_thrust_cur
		
		if at_throttle_hold == 0 then		-- manual throttle
			
			if at_mode_eng == 0 then
				
				
				if B738DR_throttle_noise == 0 or lock_throttle == 0 then
					thr1_target = B738_rescale(0, 0, 1, 1.04, simDR_throttle_1)
					thr2_target = B738_rescale(0, 0, 1, 1.04, simDR_throttle_2)
				else
					if B738DR_joy_axis_throttle == -1 then
						
						if B738DR_joy_axis_throttle1 == - 1 and B738DR_joy_axis_throttle2 == -1 then
							lock_throttle = 0
						else
							delta_throttle = math.abs(axis_throttle1_old - B738DR_joy_axis_throttle1)
							if delta_throttle > throttle_noise then
								lock_throttle = 0
							end
							delta_throttle = math.abs(axis_throttle2_old - B738DR_joy_axis_throttle2)
							if delta_throttle > throttle_noise then
								lock_throttle = 0
							end
						end
					else
						delta_throttle = math.abs(axis_throttle_old - B738DR_joy_axis_throttle)
						if delta_throttle > throttle_noise then
							lock_throttle = 0
						end
					end
				end
				
				simDR_throttle1_in = simDR_throttle_1
				simDR_throttle2_in = simDR_throttle_2
				thr1_target = B738_rescale(0, 0, 1, 1.04, simDR_throttle_1)
				thr2_target = B738_rescale(0, 0, 1, 1.04, simDR_throttle_2)
				eng1_N1_thrust_cur = thr1_target
				eng2_N1_thrust_cur = thr2_target
				simDR_throttle1_use = thr1_target
				simDR_throttle2_use = thr2_target
				thr1_anim = simDR_throttle_1
				thr2_anim = simDR_throttle_2
				
				-- eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, thr1_target, 0.0, 1.04, 10)
				-- eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, thr2_target, 0.0, 1.04, 10)
				-- simDR_throttle1_use = eng1_N1_thrust_cur
				-- simDR_throttle2_use = eng2_N1_thrust_cur
				
				-- thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
				-- thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
				
			elseif at_mode_eng == 2 then	-- speed mode
				-- thr1_target = B738_rescale(0, 0, 1, 1.04, simDR_throttle_1)
				-- thr2_target = B738_rescale(0, 0, 1, 1.04, simDR_throttle_2)
				-- eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, thr1_target, 0.0, 1.04, 8)
				-- eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, thr2_target, 0.0, 1.04, 8)
				-- simDR_throttle1_use = eng1_N1_thrust_cur
				-- simDR_throttle2_use = eng2_N1_thrust_cur
				-- thr1_anim = math.min(1.0, eng1_N1_thrust_cur)
				-- thr2_anim = math.min(1.0, eng2_N1_thrust_cur)
				lock_throttle = 1
				if B738DR_n1_set_source == 0 then	-- FMC AUTO
					if B738DR_fms_N1_mode == 0 or B738DR_fms_N1_mode == 13 then		-- no mode
						thr1_limit = 1.04
						thr2_limit = 1.04
					else
						thr1_limit = eng1_N1_thrust
						thr2_limit = eng2_N1_thrust
					end
				else 
					thr1_limit = eng1_N1_thrust
					thr2_limit = eng2_N1_thrust
				end
				-- if simDR_throttle_1 > thr1_limit then
					-- thr1_target = thr1_limit
				-- else
					-- thr1_target = simDR_throttle_1
				-- end
				-- if simDR_throttle_2 > thr2_limit then
					-- thr2_target = thr2_limit
				-- else
					-- thr2_target = simDR_throttle_2
				-- end
				
				thr1_limit = thr1_limit * 100
				thr2_limit = thr2_limit * 100
				
				simDR_throttle1_in = simDR_throttle_1
				simDR_throttle2_in = simDR_throttle_2
				thr1_target = B738_rescale(0, 0, 1, 1.04, simDR_throttle_1)
				thr2_target = B738_rescale(0, 0, 1, 1.04, simDR_throttle_2)
				if simDR_engine_N1_pct1 > thr1_limit then
					simDR_throttle1_use = simDR_throttle1_use - 0.001
				else
					simDR_throttle1_use = math.min((simDR_throttle2_use + 0.001), thr1_target)
				end
				if simDR_engine_N1_pct2 > thr2_limit then
					simDR_throttle2_use = simDR_throttle2_use - 0.001
				else
					simDR_throttle2_use = math.min((simDR_throttle2_use + 0.001), thr2_target)
				end
				-- eng1_N1_thrust_cur = thr1_target
				-- eng2_N1_thrust_cur = thr2_target
				--simDR_throttle1_use = eng1_N1_thrust_cur
				--simDR_throttle2_use = eng2_N1_thrust_cur
				thr1_anim = simDR_throttle_1
				thr2_anim = simDR_throttle_2
				
				
				-- eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, thr1_target, 0.0, 1.04, 8)
				-- eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, thr2_target, 0.0, 1.04, 8)
				-- simDR_throttle1_use = eng1_N1_thrust_cur
				-- simDR_throttle2_use = eng2_N1_thrust_cur
				
				-- thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
				-- thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
				
				axis_throttle_old = B738DR_joy_axis_throttle
				axis_throttle1_old = B738DR_joy_axis_throttle1
				axis_throttle2_old = B738DR_joy_axis_throttle2
				
			elseif at_mode_eng == 9 then	-- speed mode with N1 limit
				lock_throttle = 1
				if B738DR_n1_set_source == 0 then	-- FMC AUTO
					if B738DR_fms_N1_mode == 0 or B738DR_fms_N1_mode == 13 then		-- no mode
						thr1_limit = 1.04
						thr2_limit = 1.04
					else
						thr1_limit = eng1_N1_thrust
						thr2_limit = eng2_N1_thrust
					end
				else 
					thr1_limit = eng1_N1_thrust
					thr2_limit = eng2_N1_thrust
				end
				if simDR_throttle_1 > thr1_limit then
					thr1_target = thr1_limit
				else
					thr1_target = simDR_throttle_1
				end
				if simDR_throttle_2 > thr2_limit then
					thr2_target = thr2_limit
				else
					thr2_target = simDR_throttle_2
				end
				eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, thr1_target, 0.0, 1.04, 8)
				eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, thr2_target, 0.0, 1.04, 8)
				simDR_throttle1_use = eng1_N1_thrust_cur
				simDR_throttle2_use = eng2_N1_thrust_cur
				--thr1_anim = math.min(1.0, eng1_N1_thrust_cur)
				--thr2_anim = math.min(1.0, eng2_N1_thrust_cur)
				thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
				thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
			
				
				axis_throttle_old = B738DR_joy_axis_throttle
				axis_throttle1_old = B738DR_joy_axis_throttle1
				axis_throttle2_old = B738DR_joy_axis_throttle2
				
			elseif at_mode_eng == 6 then	-- LVL CHG
				lock_throttle = 1
				if  B738DR_autoland_status == 0 then
					if eng1_N1_thrust_trg == 0 then		--retard
						eng1_N1_thrust_cur = eng1_N1_thrust_cur - 0.002
						if eng1_N1_thrust_cur < 0 then
							eng1_N1_thrust_cur = 0
						end
					else
						eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, eng1_N1_thrust_trg, 0.0, 1.04, 0.5)	--1.5
					end
					if eng2_N1_thrust_trg == 0 then		--retard
						eng2_N1_thrust_cur = eng2_N1_thrust_cur - 0.002
						if eng2_N1_thrust_cur < 0 then
							eng2_N1_thrust_cur = 0
						end
					else
						eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, eng2_N1_thrust_trg, 0.0, 1.04, 0.5)	--1.5
					end
				else
					eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, eng1_N1_thrust_trg, 0.0, 1.04, 1.0)
					eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, eng2_N1_thrust_trg, 0.0, 1.04, 1.0)
				end
				simDR_throttle1_use = eng1_N1_thrust_cur
				simDR_throttle2_use = eng2_N1_thrust_cur
				simDR_throttle_1 = eng1_N1_thrust_cur
				simDR_throttle_2 = eng2_N1_thrust_cur
				--thr1_anim = math.min(1.0, eng1_N1_thrust_cur)
				--thr2_anim = math.min(1.0, eng2_N1_thrust_cur)
				thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
				thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
				
				thr1_target = eng1_N1_thrust_trg
				thr2_target = eng2_N1_thrust_trg
			
				
				axis_throttle_old = B738DR_joy_axis_throttle
				axis_throttle1_old = B738DR_joy_axis_throttle1
				axis_throttle2_old = B738DR_joy_axis_throttle2
				
			elseif at_mode_eng == 4 or at_mode_eng == 5 or at_mode_eng == 8 then	-- AP and FD GoAround
				lock_throttle = 1
				if ap_goaround == 1 or fd_goaround == 1 then
					if B738DR_n1_set_source == 0 then	-- FMC AUTO
						if B738DR_fms_N1_mode == 0 or B738DR_fms_N1_mode == 13 then		-- no mode
							thr1_limit = 1.04
							thr2_limit = 1.04
						else
							thr1_limit = eng1_N1_thrust
							thr2_limit = eng2_N1_thrust
						end
					else 
						thr1_limit = eng1_N1_thrust
						thr2_limit = eng2_N1_thrust
					end
					if fd_go_disable == 0 and at_mode_eng == 5 then
						thr1_target = eng1_N1_thrust_trg
						thr2_target = eng2_N1_thrust_trg
					else
						if simDR_throttle_1 > thr1_limit then
							thr1_target = thr1_limit
						else
							thr1_target = simDR_throttle_1
						end
						if simDR_throttle_2 > thr2_limit then
							thr2_target = thr2_limit
						else
							thr2_target = simDR_throttle_2
						end
					end
					eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, thr1_target, 0.0, 1.04, 8)
					eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, thr2_target, 0.0, 1.04, 8)
					simDR_throttle1_use = eng1_N1_thrust_cur
					simDR_throttle2_use = eng2_N1_thrust_cur
					--thr1_anim = math.min(1.0, eng1_N1_thrust_cur)
					--thr2_anim = math.min(1.0, eng2_N1_thrust_cur)
					thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
					thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
				else
					eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, eng1_N1_thrust_trg, 0.0, 1.04, 0.5)	--1.5
					eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, eng2_N1_thrust_trg, 0.0, 1.04, 0.5)	--1.5
					simDR_throttle1_use = eng1_N1_thrust_cur
					simDR_throttle2_use = eng2_N1_thrust_cur
					simDR_throttle_1 = eng1_N1_thrust_cur
					simDR_throttle_2 = eng2_N1_thrust_cur
					--thr1_anim = math.min(1.0, eng1_N1_thrust_cur)
					--thr2_anim = math.min(1.0, eng2_N1_thrust_cur)
					thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
					thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
				end
				thr1_target = eng1_N1_thrust_trg
				thr2_target = eng2_N1_thrust_trg
				
				axis_throttle_old = B738DR_joy_axis_throttle
				axis_throttle1_old = B738DR_joy_axis_throttle1
				axis_throttle2_old = B738DR_joy_axis_throttle2
				
			else
				lock_throttle = 1
				eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, eng1_N1_thrust_trg, 0.0, 1.04, 0.5)	--1.5
				eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, eng2_N1_thrust_trg, 0.0, 1.04, 0.5)	--1.5
				simDR_throttle1_use = eng1_N1_thrust_cur
				simDR_throttle2_use = eng2_N1_thrust_cur
				simDR_throttle_1 = eng1_N1_thrust_cur
				simDR_throttle_2 = eng2_N1_thrust_cur
				--thr1_anim = math.min(1.0, eng1_N1_thrust_cur)
				--thr2_anim = math.min(1.0, eng2_N1_thrust_cur)
				thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
				thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
				
				thr1_target = eng1_N1_thrust_trg
				thr2_target = eng2_N1_thrust_trg
				
				axis_throttle_old = B738DR_joy_axis_throttle
				axis_throttle1_old = B738DR_joy_axis_throttle1
				axis_throttle2_old = B738DR_joy_axis_throttle2
				
			end
		
		else
				
			if B738DR_throttle_noise == 0 or lock_throttle == 0 then
				thr1_target = B738_rescale(0, 0, 1, 1.04, simDR_throttle_1)
				thr2_target = B738_rescale(0, 0, 1, 1.04, simDR_throttle_2)
			else
				if B738DR_joy_axis_throttle == -1 then
					
					if B738DR_joy_axis_throttle1 == - 1 and B738DR_joy_axis_throttle2 == -1 then
						lock_throttle = 0
					else
						delta_throttle = math.abs(axis_throttle1_old - B738DR_joy_axis_throttle1)
						if delta_throttle > throttle_noise then
							lock_throttle = 0
						end
						delta_throttle = math.abs(axis_throttle2_old - B738DR_joy_axis_throttle2)
						if delta_throttle > throttle_noise then
							lock_throttle = 0
						end
					end
				else
					delta_throttle = math.abs(axis_throttle_old - B738DR_joy_axis_throttle)
					if delta_throttle > throttle_noise then
						lock_throttle = 0
					end
				end
			end
				
			-- thr1_target = B738_rescale(0, 0, 1, 1.04, simDR_throttle_1)
			-- thr2_target = B738_rescale(0, 0, 1, 1.04, simDR_throttle_2)
			eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, thr1_target, 0.0, 1.04, 2)
			eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, thr2_target, 0.0, 1.04, 2)
			simDR_throttle1_use = eng1_N1_thrust_cur
			simDR_throttle2_use = eng2_N1_thrust_cur
			--thr1_anim = simDR_throttle_1
			--thr2_anim = simDR_throttle_2
			thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
			thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
			--thr1_target = eng1_N1_thrust_trg
			--thr2_target = eng2_N1_thrust_trg
			
		end
	else
		if reverse_max_on1 == 1 then
			if simDR_reverse1_deploy > 0.9 then
				eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, 0.95, 0.0, 1.04, 1.5)
				simDR_throttle1_use = eng1_N1_thrust_cur
				simDR_throttle_1 = eng1_N1_thrust_cur
				--thr1_anim = math.min(1.0, eng1_N1_thrust_cur)
				--thr2_anim = math.min(1.0, eng2_N1_thrust_cur)
				thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
			end
		else
			eng1_N1_thrust_cur = B738_set_anim_value(eng1_N1_thrust_cur, 0.0, 0.0, 1.04, 1.5)
			simDR_throttle1_use = eng1_N1_thrust_cur
			simDR_throttle_1 = eng1_N1_thrust_cur
			--thr1_anim = math.min(1.0, eng1_N1_thrust_cur)
			--thr2_anim = math.min(1.0, eng2_N1_thrust_cur)
			thr1_anim = B738_rescale(0, 0, 1.04, 1, eng1_N1_thrust_cur)
			if simDR_throttle1_use < 0.01 then
				simDR_reverse1_act = 1
				reverse_max_enable1 = 0
				eng1_N1_thrust_cur = 0
				simDR_throttle1_use = eng1_N1_thrust_cur
				simDR_throttle_1 = 0
			end
		end
		if reverse_max_on2 == 1 then
			if simDR_reverse2_deploy > 0.9 then
				eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, 0.95, 0.0, 1.04, 1.5)
				simDR_throttle2_use = eng2_N1_thrust_cur
				simDR_throttle_2 = eng2_N1_thrust_cur
				thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
			end
		else
			eng2_N1_thrust_cur = B738_set_anim_value(eng2_N1_thrust_cur, 0.0, 0.0, 1.04, 1.5)
			simDR_throttle2_use = eng2_N1_thrust_cur
			simDR_throttle_2 = eng2_N1_thrust_cur
			thr2_anim = B738_rescale(0, 0, 1.04, 1, eng2_N1_thrust_cur)
			if simDR_throttle2_use < 0.01 then
				simDR_reverse2_act = 1
				reverse_max_enable2 = 0
				eng2_N1_thrust_cur = 0
				simDR_throttle2_use = eng2_N1_thrust_cur
				simDR_throttle_2 = 0
			end
		end
	end
	
	-- B738DR_thrust1_leveler = B738_set_anim_value(B738DR_thrust1_leveler, thr1_anim, 0.0, 1.0, 8)	--thr1_anim
	-- B738DR_thrust2_leveler = B738_set_anim_value(B738DR_thrust2_leveler, thr2_anim, 0.0, 1.0, 8)	--thr2_anim
	--B738DR_thrust1_leveler = B738_set_anim_value(B738DR_thrust1_leveler, thr1_anim, 0.0, 1.0, 8)	--thr1_anim
	--B738DR_thrust2_leveler = B738_set_anim_value(B738DR_thrust2_leveler, thr2_anim, 0.0, 1.0, 8)	--thr2_anim
	B738DR_thrust1_leveler = thr1_anim
	B738DR_thrust2_leveler = thr2_anim
	
end


-- Draw green cirlce
function B738_draw_arc()

	local delta_alt = 0
	local arc_dist = 0
	local arc_dist2 = 0
	local arc_time = 0
	local arc_zoom = 0
	local arc_vvi = 0
	
	--if simDR_EFIS_mode == 2 and B738DR_capt_map_mode <= 2 then
	if (B738DR_capt_map_mode == 2 or B738DR_fo_map_mode == 2) then --and ap_pitch_mode ~= 5 then
		if ap_pitch_mode == 1 then		-- V/S
			arc_vvi = simDR_ap_vvi_dial
			if arc_vvi > 100 and simDR_ap_altitude_dial_ft > simDR_altitude_pilot then
				delta_alt = simDR_ap_altitude_dial_ft - simDR_altitude_pilot
			elseif arc_vvi < -100 and simDR_ap_altitude_dial_ft < simDR_altitude_pilot then
				delta_alt = simDR_altitude_pilot - simDR_ap_altitude_dial_ft
				arc_vvi = -arc_vvi
			else
				arc_vvi = 0
			end
			
			if arc_vvi ~= 0 then 
				arc_time = delta_alt / (arc_vvi / 60) 	-- secs
				arc_dist = simDR_ground_spd * arc_time * 0.00054	-- m to NM
				
				-- Captain
				if B738DR_capt_map_mode == 2 then	--and B738DR_capt_exp_map_mode == 1 then
					arc_zoom = 0
					if B738DR_efis_map_range_capt == 0 then	-- 5 NM
						arc_zoom = 0.226
					elseif B738DR_efis_map_range_capt == 1 then	-- 10 NM
						arc_zoom = 0.113
					elseif B738DR_efis_map_range_capt == 2 then	-- 20 NM
						arc_zoom = 0.0565
					elseif B738DR_efis_map_range_capt == 3 then	-- 40 NM
						arc_zoom = 0.02825
					elseif B738DR_efis_map_range_capt == 4 then	-- 80 NM
						arc_zoom = 0.014125
					end
					if arc_zoom == 0 then
						B738DR_green_arc_show = 0
					else
						arc_dist2 = arc_dist * arc_zoom
						if B738DR_capt_exp_map_mode == 0 then
							arc_dist2 = arc_dist2 + 0.465294
						end
						if arc_dist2 < 0.005 or arc_dist2 > 1.0 then
							B738DR_green_arc_show = 0
						else
							B738DR_green_arc = arc_dist2
							B738DR_green_arc_show = 1
						end
					end
				else
					B738DR_green_arc_show = 0
				end
				
				-- First Officer
				if B738DR_fo_map_mode == 2 then	--and B738DR_fo_exp_map_mode == 1 then
					arc_zoom = 0
					if B738DR_efis_map_range_fo == 0 then	-- 5 NM
						arc_zoom = 0.226
					elseif B738DR_efis_map_range_fo == 1 then	-- 10 NM
						arc_zoom = 0.113
					elseif B738DR_efis_map_range_fo == 2 then	-- 20 NM
						arc_zoom = 0.0565
					elseif B738DR_efis_map_range_fo == 3 then	-- 40 NM
						arc_zoom = 0.02825
					elseif B738DR_efis_map_range_fo == 4 then	-- 80 NM
						arc_zoom = 0.014125
					end
					if arc_zoom == 0 then
						B738DR_green_arc_fo_show = 0
					else
						arc_dist2 = arc_dist * arc_zoom
						if B738DR_fo_exp_map_mode == 0 then
							arc_dist2 = arc_dist2 + 0.465294
						end
						if arc_dist2 < 0.005 or arc_dist2 > 1.0 then
							B738DR_green_arc_fo_show = 0
						else
							B738DR_green_arc_fo = arc_dist2
							B738DR_green_arc_fo_show = 1
						end
					end
				else
					B738DR_green_arc_fo_show = 0
				end
			else
				B738DR_green_arc_show = 0
				B738DR_green_arc_fo_show = 0
			end
		elseif ap_pitch_mode == 2 then		-- LVL CHG
			arc_vvi = simDR_vvi_fpm_pilot
			if arc_vvi > 100 and simDR_ap_altitude_dial_ft > simDR_altitude_pilot then
				delta_alt = simDR_ap_altitude_dial_ft - simDR_altitude_pilot
			elseif arc_vvi < -100 and simDR_ap_altitude_dial_ft < simDR_altitude_pilot then
				delta_alt = simDR_altitude_pilot - simDR_ap_altitude_dial_ft
				arc_vvi = -arc_vvi
			else
				arc_vvi = 0
			end
			if arc_vvi ~= 0 then
				arc_time = delta_alt / (arc_vvi / 60)	-- secs
				arc_dist = simDR_ground_spd * arc_time * 0.00054	-- m to NM
				
				-- Captain
				if B738DR_capt_map_mode == 2 then	--and B738DR_capt_exp_map_mode == 1 then
					arc_zoom = 0
					if B738DR_efis_map_range_capt == 0 then	-- 5 NM
						arc_zoom = 0.226
					elseif B738DR_efis_map_range_capt == 1 then	-- 10 NM
						arc_zoom = 0.113
					elseif B738DR_efis_map_range_capt == 2 then	-- 20 NM
						arc_zoom = 0.0565
					elseif B738DR_efis_map_range_capt == 3 then	-- 40 NM
						arc_zoom = 0.02825
					elseif B738DR_efis_map_range_capt == 4 then	-- 80 NM
						arc_zoom = 0.014125
					end
					if arc_zoom == 0 then
						B738DR_green_arc_show = 0
					else
						arc_dist2 = arc_dist * arc_zoom
							if B738DR_capt_exp_map_mode == 0 then
								arc_dist2 = arc_dist2 + 0.465294
							end
						if arc_dist2 < 0.005 or arc_dist2 > 1.0 then
							B738DR_green_arc_show = 0
						else
							B738DR_green_arc = arc_dist2
							B738DR_green_arc_show = 1
						end
					end
				else
					B738DR_green_arc_show = 0
				end
				
				-- First Officer
				if B738DR_fo_map_mode == 2 then	--and B738DR_fo_exp_map_mode == 1 then
					arc_zoom = 0
					if B738DR_efis_map_range_fo == 0 then	-- 5 NM
						arc_zoom = 0.226
					elseif B738DR_efis_map_range_fo == 1 then	-- 10 NM
						arc_zoom = 0.113
					elseif B738DR_efis_map_range_fo == 2 then	-- 20 NM
						arc_zoom = 0.0565
					elseif B738DR_efis_map_range_fo == 3 then	-- 40 NM
						arc_zoom = 0.02825
					elseif B738DR_efis_map_range_fo == 4 then	-- 80 NM
						arc_zoom = 0.014125
					end
					if arc_zoom == 0 then
						B738DR_green_arc_fo_show = 0
					else
						arc_dist2 = arc_dist * arc_zoom
						if B738DR_fo_exp_map_mode == 0 then
							arc_dist2 = arc_dist2 + 0.465294
						end
						if arc_dist2 < 0.005 or arc_dist2 > 1.0 then
							B738DR_green_arc_fo_show = 0
						else
							B738DR_green_arc_fo = arc_dist2
							B738DR_green_arc_fo_show = 1
						end
					end
				else
					B738DR_green_arc_fo_show = 0
				end
			else
				B738DR_green_arc_show = 0
				B738DR_green_arc_fo_show = 0
			end
		elseif ap_pitch_mode == 5 then		-- VNAV
			if simDR_autopilot_altitude_mode == 4 or simDR_autopilot_altitude_mode == 5 then	-- VS or LVL CHG
				arc_vvi = simDR_vvi_fpm_pilot
				if arc_vvi > 100 and simDR_ap_altitude_dial_ft > simDR_altitude_pilot then
					delta_alt = simDR_ap_altitude_dial_ft - simDR_altitude_pilot
				elseif arc_vvi < -100 and simDR_ap_altitude_dial_ft < simDR_altitude_pilot then
					delta_alt = simDR_altitude_pilot - simDR_ap_altitude_dial_ft
					arc_vvi = -arc_vvi
				else
					arc_vvi = 0
				end
				if arc_vvi ~= 0 then
					arc_time = delta_alt / (arc_vvi / 60)	-- secs
					arc_dist = simDR_ground_spd * arc_time * 0.00054	-- m to NM
				
					-- Captain
					if B738DR_capt_map_mode == 2 then	--and B738DR_capt_exp_map_mode == 1 then
						arc_zoom = 0
						if B738DR_efis_map_range_capt == 0 then	-- 5 NM
							arc_zoom = 0.226
						elseif B738DR_efis_map_range_capt == 1 then	-- 10 NM
							arc_zoom = 0.113
						elseif B738DR_efis_map_range_capt == 2 then	-- 20 NM
							arc_zoom = 0.0565
						elseif B738DR_efis_map_range_capt == 3 then	-- 40 NM
							arc_zoom = 0.02825
						elseif B738DR_efis_map_range_capt == 4 then	-- 80 NM
							arc_zoom = 0.014125
						end
						if arc_zoom == 0 then
							B738DR_green_arc_show = 0
						else
							arc_dist2 = arc_dist * arc_zoom
							if B738DR_capt_exp_map_mode == 0 then
								arc_dist2 = arc_dist2 + 0.465294
							end
							if arc_dist2 < 0.005 or arc_dist2 > 1.0 then
								B738DR_green_arc_show = 0
							else
								B738DR_green_arc = arc_dist2
								B738DR_green_arc_show = 1
							end
						end
					else
						B738DR_green_arc_show = 0
					end
					
					-- First Officer
					if B738DR_fo_map_mode == 2 then	--and B738DR_fo_exp_map_mode == 1 then
						arc_zoom = 0
						if B738DR_efis_map_range_fo == 0 then	-- 5 NM
							arc_zoom = 0.226
						elseif B738DR_efis_map_range_fo == 1 then	-- 10 NM
							arc_zoom = 0.113
						elseif B738DR_efis_map_range_fo == 2 then	-- 20 NM
							arc_zoom = 0.0565
						elseif B738DR_efis_map_range_fo == 3 then	-- 40 NM
							arc_zoom = 0.02825
						elseif B738DR_efis_map_range_fo == 4 then	-- 80 NM
							arc_zoom = 0.014125
						end
						if arc_zoom == 0 then
							B738DR_green_arc_fo_show = 0
						else
							arc_dist2 = arc_dist * arc_zoom
							if B738DR_fo_exp_map_mode == 0 then
								arc_dist2 = arc_dist2 + 0.465294
							end
							if arc_dist2 < 0.005 or arc_dist2 > 1.0 then
								B738DR_green_arc_fo_show = 0
							else
								B738DR_green_arc_fo = arc_dist2
								B738DR_green_arc_fo_show = 1
							end
						end
					else
						B738DR_green_arc_fo_show = 0
					end
				else
					B738DR_green_arc_show = 0
					B738DR_green_arc_fo_show = 0
				end
			else
				B738DR_green_arc_show = 0
				B738DR_green_arc_fo_show = 0
			end
		else
			B738DR_green_arc_show = 0
			B738DR_green_arc_fo_show = 0
		end
	else
		B738DR_green_arc_show = 0
		B738DR_green_arc_fo_show = 0
	end


end

function B738_vor_sel()

	local str_len = 0
	local vor_crs = 0
	local vor_bcrs = 0
	local vor_hdg = 0
	local vor_bearing = 0
	local vor_distance = 0
	local vor_bear_l = 0
	local vor_bear_r = 0
	local str_crs = ""
	local str_bcrs = ""
	local vor_angle = 0
	local efis_zoom = 0
	local out_of_range = 0
	local vor_x = 0
	local vor_y = 0
	local vor_quadr = 0
	local vor2_sel_disable = 0
	local relative_brg = 0
	
	-- if simDR_autopilot_source ~= 2 then
		simDR_hsi_crs1 = simDR_nav1_obs_pilot
	-- end
	-- if simDR_autopilot_fo_source ~= 2 then
		simDR_hsi_crs2 = simDR_nav1_obs_copilot
	-- end
	
	--if xfirst_time2 == 0 then
	
	--if B738DR_capt_exp_map_mode == 1 and B738DR_capt_map_mode ~= 3 then
	if B738DR_capt_map_mode == 2 then
		
		-- CAPTAIN VOR1
--		if simDR_vor1_capt == 2 and simDR_nav1_type == 4 then	-- VOR select
		if simDR_nav1_type == 4 then	-- VOR select
			if simDR_nav1_nav_id == nil or simDR_nav1_dme == nil or simDR_nav1_has_dme == 0 then
				B738DR_vor1_show = 0
			else
				str_len = string.len(simDR_nav1_nav_id)
				B738DR_vor1_sel_id = ""
				if str_len < 4 then
					B738DR_vor1_sel_id = " "
				end
				B738DR_vor1_sel_id = B738DR_vor1_sel_id .. simDR_nav1_nav_id
				vor_crs = simDR_nav1_obs_pilot
				vor_bcrs = (vor_crs + 180) % 360
				if vor_crs < 10 then
					if vor_crs < 0 then
						B738DR_vor1_sel_crs = "000"
					else
						B738DR_vor1_sel_crs = "00" .. string.format("%1d", vor_crs)
					end
				elseif vor_crs < 100 then
					B738DR_vor1_sel_crs = "0" .. string.format("%2d", vor_crs)
				else
					B738DR_vor1_sel_crs = string.format("%3d", vor_crs)
				end
				if vor_bcrs < 10 then
					if vor_bcrs < 0 then
						B738DR_vor1_sel_bcrs = "000"
					else
						B738DR_vor1_sel_bcrs = "00" .. string.format("%1d", vor_bcrs)
					end
				elseif vor_bcrs < 100 then
					B738DR_vor1_sel_bcrs = "0" .. string.format("%2d", vor_bcrs)
				else
					B738DR_vor1_sel_bcrs = string.format("%3d", vor_bcrs)
				end
				
				if B738DR_track_up == 0 then
					vor_hdg = simDR_ahars_mag_hdg -- simDR_mag_variation
				else
					if B738DR_track_up_active == 0 then
						vor_hdg = simDR_ahars_mag_hdg
					else
						vor_hdg = simDR_mag_hdg
					end
				end
				
				vor_bearing = simDR_nav1_bearing
				vor_distance = simDR_nav1_dme
				
				relative_brg = (vor_bearing - vor_hdg + 360) % 360
				if relative_brg > 180 then
					relative_brg = relative_brg - 360
				end
				
				if relative_brg >= 0 and relative_brg < 90 then
					vor_angle = math.rad(relative_brg)
					vor_y = vor_distance * math.cos(vor_angle)
					vor_x = vor_distance * math.sin(vor_angle)
				elseif relative_brg >= 90 and relative_brg <= 180 then
					vor_angle = math.rad(relative_brg - 90)
					vor_x = vor_distance * math.cos(vor_angle)
					vor_y = -vor_distance * math.sin(vor_angle)
				elseif relative_brg >= -180 and relative_brg < -90 then
					vor_angle = -relative_brg
					vor_angle = math.rad(vor_angle - 90)
					vor_x = -vor_distance * math.cos(vor_angle)
					vor_y = -vor_distance * math.sin(vor_angle)
				elseif relative_brg >= -90 and relative_brg < 0 then
					vor_angle = -relative_brg
					vor_angle = math.rad(vor_angle)
					vor_y = vor_distance * math.cos(vor_angle)
					vor_x = -vor_distance * math.sin(vor_angle)
				end
				
				if B738DR_efis_map_range_capt == 0 then	-- 5 NM
					efis_zoom = 2
				elseif B738DR_efis_map_range_capt == 1 then	-- 10 NM
					efis_zoom = 1
				elseif B738DR_efis_map_range_capt == 2 then	-- 20 NM
					efis_zoom = 0.5
				elseif B738DR_efis_map_range_capt == 3 then	-- 40 NM
					efis_zoom = 0.25
				elseif B738DR_efis_map_range_capt == 4 then	-- 80 NM
					efis_zoom = 0.125
				else
					out_of_range = 1
				end
				
				vor_x = vor_x * efis_zoom		-- zoom
				vor_y = vor_y * efis_zoom		-- zoom
				
				if B738DR_capt_map_mode == 3 then
					vor_y = vor_y + 4.1	-- adjust center
				elseif B738DR_capt_vsd_map_mode == 1 then
					vor_y = vor_y + 5.1	-- adjust center
				elseif B738DR_capt_exp_map_mode == 0 then
					vor_y = vor_y + 4.1	-- adjust center
				end
				
				if vor_y > 11.0 or vor_y < -15.0 then
					out_of_range = 1
				end
				if vor_x < -15.0 or vor_x > 15.0 then
					out_of_range = 1
				end
				
				vor_hdg = (vor_crs - vor_hdg) % 360
				vor_hdg = (90 + vor_hdg) % 360
				--vor_hdg = vor_hdg + simDR_mag_variation
				B738DR_vor1_sel_rotate = vor_hdg
				
				if out_of_range == 0 then
					B738DR_vor1_sel_x = vor_x
					B738DR_vor1_sel_y = vor_y
					B738DR_vor1_show = 1
					if simDR_vor1_capt == 2 then
						B738DR_vor1_line_show = 1
					else
						B738DR_vor1_line_show = 0
					end
					
					-- position
					if cpt_pos_enable == 0 then
						B738DR_vor1_sel_pos_show = 0
					else
						B738DR_vor1_sel_pos_show = 1
						B738DR_vor1_sel_pos = relative_brg
						B738DR_vor1_sel_pos_dist = vor_distance * efis_zoom
						B738DR_vor1_sel_pos_brg = string.format("%03d", vor_bearing)
					end
				else
					B738DR_vor1_show = 0
				end
			end
		else
			B738DR_vor1_show = 0
		end
		-- CAPTAIN VOR2
		if simDR_nav2_nav_id ~= nil then
			if B738DR_vor1_show == 1 and simDR_nav1_nav_id == simDR_nav2_nav_id then
				vor2_sel_disable = 1
			end
		end
--		if simDR_vor2_capt == 2 and simDR_nav2_type == 4 and vor2_sel_disable == 0 then	-- VOR select
		if simDR_nav2_type == 4 and vor2_sel_disable == 0 then	-- VOR select
			if simDR_nav2_nav_id == nil or simDR_nav2_dme == nil or simDR_nav2_has_dme == 0 then
				B738DR_vor2_show = 0
			else
				str_len = string.len(simDR_nav2_nav_id)
				B738DR_vor2_sel_id = ""
				if str_len < 4 then
					B738DR_vor2_sel_id = " "
				end
				B738DR_vor2_sel_id = B738DR_vor2_sel_id .. simDR_nav2_nav_id
				vor_crs = simDR_nav1_obs_copilot	--simDR_nav1_obs_pilot
				vor_bcrs = (vor_crs + 180) % 360
				if vor_crs < 10 then
					if vor_crs < 0 then
						B738DR_vor2_sel_crs = "000"
					else
						B738DR_vor2_sel_crs = "00" .. string.format("%1d", vor_crs)
					end
				elseif vor_crs < 100 then
					B738DR_vor2_sel_crs = "0" .. string.format("%2d", vor_crs)
				else
					B738DR_vor2_sel_crs = string.format("%3d", vor_crs)
				end
				if vor_bcrs < 10 then
					if vor_bcrs < 0 then
						B738DR_vor2_sel_bcrs = "000"
					else
						B738DR_vor2_sel_bcrs = "00" .. string.format("%1d", vor_bcrs)
					end
				elseif vor_bcrs < 100 then
					B738DR_vor2_sel_bcrs = "0" .. string.format("%2d", vor_bcrs)
				else
					B738DR_vor2_sel_bcrs = string.format("%3d", vor_bcrs)
				end
				
				if B738DR_track_up == 0 then
					vor_hdg = simDR_ahars_mag_hdg -- simDR_mag_variation
				else
					if B738DR_track_up_active == 0 then
						vor_hdg = simDR_ahars_mag_hdg
					else
						vor_hdg = simDR_mag_hdg
					end
					-- vor_hdg = simDR_mag_hdg
				end
				
				vor_bearing = simDR_nav2_bearing
				vor_distance = simDR_nav2_dme
				
				relative_brg = (vor_bearing - vor_hdg + 360) % 360
				if relative_brg > 180 then
					relative_brg = relative_brg - 360
				end
				
				if relative_brg >= 0 and relative_brg < 90 then
					vor_angle = math.rad(relative_brg)
					vor_y = vor_distance * math.cos(vor_angle)
					vor_x = vor_distance * math.sin(vor_angle)
				elseif relative_brg >= 90 and relative_brg <= 180 then
					vor_angle = math.rad(relative_brg - 90)
					vor_x = vor_distance * math.cos(vor_angle)
					vor_y = -vor_distance * math.sin(vor_angle)
				elseif relative_brg >= -180 and relative_brg < -90 then
					vor_angle = -relative_brg
					vor_angle = math.rad(vor_angle - 90)
					vor_x = -vor_distance * math.cos(vor_angle)
					vor_y = -vor_distance * math.sin(vor_angle)
				elseif relative_brg >= -90 and relative_brg < 0 then
					vor_angle = -relative_brg
					vor_angle = math.rad(vor_angle)
					vor_y = vor_distance * math.cos(vor_angle)
					vor_x = -vor_distance * math.sin(vor_angle)
				end
				
				out_of_range = 0
				if B738DR_efis_map_range_capt == 0 then	-- 5 NM
					efis_zoom = 2
				elseif B738DR_efis_map_range_capt == 1 then	-- 10 NM
					efis_zoom = 1
				elseif B738DR_efis_map_range_capt == 2 then	-- 20 NM
					efis_zoom = 0.5
				elseif B738DR_efis_map_range_capt == 3 then	-- 40 NM
					efis_zoom = 0.25
				elseif B738DR_efis_map_range_capt == 4 then	-- 80 NM
					efis_zoom = 0.125
				else
					out_of_range = 1
				end
				
				vor_x = vor_x * efis_zoom		-- zoom
				vor_y = vor_y * efis_zoom		-- zoom
				
				if B738DR_capt_map_mode == 3 then
					vor_y = vor_y + 4.1	-- adjust center
				elseif B738DR_capt_vsd_map_mode == 1 then
					vor_y = vor_y + 5.1	-- adjust center
				elseif B738DR_capt_exp_map_mode == 0 then
					vor_y = vor_y + 4.1	-- adjust center
				end
				
				if vor_y > 11.0 or vor_y < -15.0 then
					out_of_range = 1
				end
				if vor_x < -15.0 or vor_x > 15.0 then
					out_of_range = 1
				end
				
				vor_hdg = (vor_crs - vor_hdg) % 360
				vor_hdg = (90 + vor_hdg) % 360
				--vor_hdg = vor_hdg + simDR_mag_variation
				B738DR_vor2_sel_rotate = vor_hdg
				
				if out_of_range == 0 then
					B738DR_vor2_sel_x = vor_x
					B738DR_vor2_sel_y = vor_y
					B738DR_vor2_show = 1
					if simDR_vor2_capt == 2 then
						B738DR_vor2_line_show = 1
					else
						B738DR_vor2_line_show = 0
					end
				else
					B738DR_vor2_show = 0
				end
			end
		else
			B738DR_vor2_show = 0
		end
	else
		B738DR_vor1_show = 0
		B738DR_vor2_show = 0
	end
	
	--end
	
	if B738DR_capt_map_mode < 2 then
		vor_hdg =  simDR_ahars_mag_hdg
	elseif B738DR_capt_map_mode == 2 then
		if B738DR_track_up == 0 then
			vor_hdg = simDR_ahars_mag_hdg -- simDR_mag_variation
		else
			if B738DR_track_up_active == 0 then
				vor_hdg = simDR_ahars_mag_hdg
			else
				vor_hdg = simDR_mag_hdg
			end
		end
	end
	B738DR_vor1_arrow = simDR_nav1_bearing - vor_hdg
	B738DR_vor2_arrow = simDR_nav2_bearing - vor_hdg
	
	B738DR_adf1_arrow = simDR_adf1_bearing - vor_hdg
	B738DR_adf2_arrow = simDR_adf2_bearing - vor_hdg
	
	
	--if xfirst_time2 == 0 then
	
	--if B738DR_fo_exp_map_mode == 1 and B738DR_fo_map_mode ~= 3 then
	if B738DR_fo_map_mode == 2 then
	
		-- FIRST OFFICER VOR1
		str_len = 0
		vor_crs = 0
		vor_bcrs = 0
		vor_hdg = 0
		vor_bearing = 0
		vor_distance = 0
		vor_bear_l = 0
		vor_bear_r = 0
		str_crs = ""
		str_bcrs = ""
		vor_angle = 0
		efis_zoom = 0
		out_of_range = 0
		vor_x = 0
		vor_y = 0
		vor_quadr = 0
		vor2_sel_disable = 0
--		if simDR_vor1_fo == 2 and simDR_nav1_type == 4 then	-- VOR select
		if simDR_nav1_type == 4 then	-- VOR select
			if simDR_nav1_nav_id == nil or simDR_nav1_dme == nil or simDR_nav1_has_dme == 0 then
				B738DR_vor1_copilot_show = 0
			else
				str_len = string.len(simDR_nav1_nav_id)
				B738DR_vor1_sel_id_fo = ""
				if str_len < 4 then
					B738DR_vor1_sel_id_fo = " "
				end
				B738DR_vor1_sel_id_fo = B738DR_vor1_sel_id_fo .. simDR_nav1_nav_id
				vor_crs = simDR_nav1_obs_pilot
				vor_bcrs = (vor_crs + 180) % 360
				if vor_crs < 10 then
					if vor_crs < 0 then
						B738DR_vor1_sel_crs_fo = "000"
					else
						B738DR_vor1_sel_crs_fo = "00" .. string.format("%1d", vor_crs)
					end
				elseif vor_crs < 100 then
					B738DR_vor1_sel_crs_fo = "0" .. string.format("%2d", vor_crs)
				else
					B738DR_vor1_sel_crs_fo = string.format("%3d", vor_crs)
				end
				if vor_bcrs < 10 then
					if vor_bcrs < 0 then
						B738DR_vor1_sel_bcrs_fo = "000"
					else
						B738DR_vor1_sel_bcrs_fo = "00" .. string.format("%1d", vor_bcrs)
					end
				elseif vor_bcrs < 100 then
					B738DR_vor1_sel_bcrs_fo = "0" .. string.format("%2d", vor_bcrs)
				else
					B738DR_vor1_sel_bcrs_fo = string.format("%3d", vor_bcrs)
				end
				
				if B738DR_track_up == 0 then
					vor_hdg = simDR_ahars_mag_hdg -- simDR_mag_variation
				else
					if B738DR_track_up_active == 0 then
						vor_hdg = simDR_ahars_mag_hdg
					else
						vor_hdg = simDR_mag_hdg
					end
					-- vor_hdg = simDR_mag_hdg
				end
				
				vor_bearing = simDR_nav1_bearing
				vor_distance = simDR_nav1_dme
				
				relative_brg = (vor_bearing - vor_hdg + 360) % 360
				if relative_brg > 180 then
					relative_brg = relative_brg - 360
				end
				
				if relative_brg >= 0 and relative_brg < 90 then
					vor_angle = math.rad(relative_brg)
					vor_y = vor_distance * math.cos(vor_angle)
					vor_x = vor_distance * math.sin(vor_angle)
				elseif relative_brg >= 90 and relative_brg <= 180 then
					vor_angle = math.rad(relative_brg - 90)
					vor_x = vor_distance * math.cos(vor_angle)
					vor_y = -vor_distance * math.sin(vor_angle)
				elseif relative_brg >= -180 and relative_brg < -90 then
					vor_angle = -relative_brg
					vor_angle = math.rad(vor_angle - 90)
					vor_x = -vor_distance * math.cos(vor_angle)
					vor_y = -vor_distance * math.sin(vor_angle)
				elseif relative_brg >= -90 and relative_brg < 0 then
					vor_angle = -relative_brg
					vor_angle = math.rad(vor_angle)
					vor_y = vor_distance * math.cos(vor_angle)
					vor_x = -vor_distance * math.sin(vor_angle)
				end
				
				out_of_range = 0
				if B738DR_efis_map_range_fo == 0 then	-- 5 NM
					efis_zoom = 2
				elseif B738DR_efis_map_range_fo == 1 then	-- 10 NM
					efis_zoom = 1
				elseif B738DR_efis_map_range_fo == 2 then	-- 20 NM
					efis_zoom = 0.5
				elseif B738DR_efis_map_range_fo == 3 then	-- 40 NM
					efis_zoom = 0.25
				elseif B738DR_efis_map_range_fo == 4 then	-- 80 NM
					efis_zoom = 0.125
				else
					out_of_range = 1
				end
				
				vor_x = vor_x * efis_zoom		-- zoom
				vor_y = vor_y * efis_zoom		-- zoom
				
				if B738DR_fo_map_mode == 3 then
					vor_y = vor_y + 4.1	-- adjust center
				elseif B738DR_fo_vsd_map_mode == 1 then
					vor_y = vor_y + 5.1	-- adjust center
				elseif B738DR_fo_exp_map_mode == 0 then
					vor_y = vor_y + 4.1	-- adjust center
				end
				
				if vor_y > 11.0 or vor_y < -15.0 then
					out_of_range = 1
				end
				if vor_x < -15.0 or vor_x > 15.0 then
					out_of_range = 1
				end
				
				vor_hdg = (vor_crs - vor_hdg) % 360
				vor_hdg = (90 + vor_hdg) % 360
				--vor_hdg = vor_hdg + simDR_mag_variation
				B738DR_vor1_sel_rotate_fo = vor_hdg
				
				if out_of_range == 0 then
					B738DR_vor1_sel_x_fo = vor_x
					B738DR_vor1_sel_y_fo = vor_y
					B738DR_vor1_copilot_show = 1
					if simDR_vor1_fo == 2 then
						B738DR_vor1_line_copilot_show = 1
					else
						B738DR_vor1_line_copilot_show = 0
					end
				else
					B738DR_vor1_copilot_show = 0
				end
			end
		else
			B738DR_vor1_copilot_show = 0
		end
		
		-- FIRST OFFICER VOR2
		if simDR_nav2_nav_id ~= nil then
			if B738DR_vor1_copilot_show == 1 and simDR_nav1_nav_id == simDR_nav2_nav_id then
				vor2_sel_disable = 1
			end
		end
--		if simDR_vor2_fo == 2 and simDR_nav2_type == 4 and vor2_sel_disable == 0 then	-- VOR select
		if simDR_nav2_type == 4 and vor2_sel_disable == 0 then	-- VOR select
			if simDR_nav2_nav_id == nil or simDR_nav2_dme == nil or simDR_nav2_has_dme == 0 then
				B738DR_vor2_copilot_show = 0
			else
				str_len = string.len(simDR_nav2_nav_id)
				B738DR_vor2_sel_id_fo = ""
				if str_len < 4 then
					B738DR_vor2_sel_id_fo = " "
				end
				B738DR_vor2_sel_id_fo = B738DR_vor2_sel_id_fo .. simDR_nav2_nav_id
				vor_crs = simDR_nav1_obs_copilot	--simDR_nav1_obs_pilot
				vor_bcrs = (vor_crs + 180) % 360
				if vor_crs < 10 then
					if vor_crs < 0 then
						B738DR_vor2_sel_crs_fo = "000"
					else
						B738DR_vor2_sel_crs_fo = "00" .. string.format("%1d", vor_crs)
					end
				elseif vor_crs < 100 then
					B738DR_vor2_sel_crs_fo = "0" .. string.format("%2d", vor_crs)
				else
					B738DR_vor2_sel_crs_fo = string.format("%3d", vor_crs)
				end
				if vor_bcrs < 10 then
					if vor_bcrs < 0 then
						B738DR_vor2_sel_bcrs_fo = "000"
					else
						B738DR_vor2_sel_bcrs_fo = "00" .. string.format("%1d", vor_bcrs)
					end
				elseif vor_bcrs < 100 then
					B738DR_vor2_sel_bcrs_fo = "0" .. string.format("%2d", vor_bcrs)
				else
					B738DR_vor2_sel_bcrs_fo = string.format("%3d", vor_bcrs)
				end
				
				if B738DR_track_up == 0 then
					vor_hdg = simDR_ahars_mag_hdg -- simDR_mag_variation
				else
					if B738DR_track_up_active == 0 then
						vor_hdg = simDR_ahars_mag_hdg
					else
						vor_hdg = simDR_mag_hdg
					end
					-- vor_hdg = simDR_mag_hdg
				end
				
				vor_bearing = simDR_nav2_bearing
				vor_distance = simDR_nav2_dme
				
				relative_brg = (vor_bearing - vor_hdg + 360) % 360
				if relative_brg > 180 then
					relative_brg = relative_brg - 360
				end
				
				if relative_brg >= 0 and relative_brg < 90 then
					vor_angle = math.rad(relative_brg)
					vor_y = vor_distance * math.cos(vor_angle)
					vor_x = vor_distance * math.sin(vor_angle)
				elseif relative_brg >= 90 and relative_brg <= 180 then
					vor_angle = math.rad(relative_brg - 90)
					vor_x = vor_distance * math.cos(vor_angle)
					vor_y = -vor_distance * math.sin(vor_angle)
				elseif relative_brg >= -180 and relative_brg < -90 then
					vor_angle = -relative_brg
					vor_angle = math.rad(vor_angle - 90)
					vor_x = -vor_distance * math.cos(vor_angle)
					vor_y = -vor_distance * math.sin(vor_angle)
				elseif relative_brg >= -90 and relative_brg < 0 then
					vor_angle = -relative_brg
					vor_angle = math.rad(vor_angle)
					vor_y = vor_distance * math.cos(vor_angle)
					vor_x = -vor_distance * math.sin(vor_angle)
				end
				
				if B738DR_efis_map_range_fo == 0 then	-- 5 NM
					efis_zoom = 2
				elseif B738DR_efis_map_range_fo == 1 then	-- 10 NM
					efis_zoom = 1
				elseif B738DR_efis_map_range_fo == 2 then	-- 20 NM
					efis_zoom = 0.5
				elseif B738DR_efis_map_range_fo == 3 then	-- 40 NM
					efis_zoom = 0.25
				elseif B738DR_efis_map_range_fo == 4 then	-- 80 NM
					efis_zoom = 0.125
				else
					out_of_range = 1
				end
				
				vor_x = vor_x * efis_zoom		-- zoom
				vor_y = vor_y * efis_zoom		-- zoom
				
				if B738DR_fo_map_mode == 3 then
					vor_y = vor_y + 4.1	-- adjust center
				elseif B738DR_fo_vsd_map_mode == 1 then
					vor_y = vor_y + 5.1	-- adjust center
				elseif B738DR_fo_exp_map_mode == 0 then
					vor_y = vor_y + 4.1	-- adjust center
				end
				
				if vor_y > 11.0 or vor_y < -15.0 then
					out_of_range = 1
				end
				if vor_x < -15.0 or vor_x > 15.0 then
					out_of_range = 1
				end
				
				vor_hdg = (vor_crs - vor_hdg) % 360
				vor_hdg = (90 + vor_hdg) % 360
				--vor_hdg = vor_hdg + simDR_mag_variation
				B738DR_vor2_sel_rotate_fo = vor_hdg
				
				if out_of_range == 0 then
					B738DR_vor2_sel_x_fo = vor_x
					B738DR_vor2_sel_y_fo = vor_y
					B738DR_vor2_copilot_show = 1
					if simDR_vor2_fo == 2 then
						B738DR_vor2_line_copilot_show = 1
					else
						B738DR_vor2_line_copilot_show = 0
					end
				else
					B738DR_vor2_copilot_show = 0
				end
			end
		else
			B738DR_vor2_copilot_show = 0
		end
	else
		B738DR_vor1_copilot_show = 0
		B738DR_vor2_copilot_show = 0
	end
	
	--end
	
	if B738DR_fo_map_mode < 2 then
		vor_hdg = simDR_ahars_mag_hdg
	elseif B738DR_fo_map_mode == 2 then
		if B738DR_track_up == 0 then
			vor_hdg = simDR_ahars_mag_hdg -- simDR_mag_variation
		else
			if B738DR_track_up_active == 0 then
				vor_hdg = simDR_ahars_mag_hdg
			else
				vor_hdg = simDR_mag_hdg
			end
		end
	end
	B738DR_vor1_arrow_fo = simDR_nav1_bearing - vor_hdg
	B738DR_vor2_arrow_fo = simDR_nav2_bearing - vor_hdg
	
	B738DR_adf1_arrow_fo = simDR_adf1_bearing - vor_hdg
	B738DR_adf2_arrow_fo = simDR_adf2_bearing - vor_hdg

end

function timer_efis_disagr()
	B738DR_efis_disagree = 1
end

function timer_efis_disagr_fo()
	B738DR_efis_disagree_fo = 1
end

function B738_efis()
	
	local efis_disagree = 0
	local nav_type_vor = 0
	if B738DR_nav_type == 0 then
		nav_type_vor = -1
	elseif B738DR_nav_type == 4 then
		nav_type_vor = 1
	end
	if B738DR_capt_map_mode == 0 then
		-- APP
		if nav_type_vor == 1 then
			efis_disagree = 1
		end
	elseif B738DR_capt_map_mode == 1 then
		-- VOR
		if nav_type_vor == 0 then
			efis_disagree = 1
		end
	end
	
	if efis_disagree == 0 then
		B738DR_efis_disagree = 0
		if is_timer_scheduled(timer_efis_disagr) == true then
			stop_timer(timer_efis_disagr)
		end
	else
		if B738DR_efis_disagree == 0 then
			if is_timer_scheduled(timer_efis_disagr) == false then
				run_after_time(timer_efis_disagr, 1.8)
			end
		end
	end
	--B738DR_efis_disagree = efis_disagree
	
	efis_disagree = 0
	nav_type_vor = 0
	if B738DR_nav_type_fo == 0 then
		nav_type_vor = -1
	elseif B738DR_nav_type_fo == 4 then
		nav_type_vor = 1
	end
	if B738DR_fo_map_mode == 0 then
		-- APP
		if nav_type_vor == 1 then
			efis_disagree = 1
		end
	elseif B738DR_fo_map_mode == 1 then
		-- VOR
		if nav_type_vor == 0 then
			efis_disagree = 1
		end
	end
	
	if efis_disagree == 0 then
		B738DR_efis_disagree_fo = 0
		if is_timer_scheduled(timer_efis_disagr_fo) == true then
			stop_timer(timer_efis_disagr_fo)
		end
	else
		if B738DR_efis_disagree_fo == 0 then
			if is_timer_scheduled(timer_efis_disagr_fo) == false then
				run_after_time(timer_efis_disagr_fo, 1.8)
			end
		end
	end
	--B738DR_efis_disagree_fo = efis_disagree

end

-- Baro altimeter
function B738_efis_baro()

	-- Captain
	if B738DR_baro_set_std_pilot == 1 then	-- set STD
		if baro_sel_old ~= B738DR_baro_sel_in_hg_pilot then
			B738DR_baro_sel_pilot_show = 1
		end
		if B738DR_flight_phase > 3 then
			if simDR_altitude_pilot < B738DR_trans_lvl then
				B738DR_baro_std_box_pilot_show = 1
				B738DR_baro_box_pilot_show = 0
			else
				B738DR_baro_std_box_pilot_show = 0
				B738DR_baro_box_pilot_show = 0
			end
		else
			B738DR_baro_std_box_pilot_show = 0
			B738DR_baro_box_pilot_show = 0
		end
	else
		simDR_barometer_setting_capt = B738DR_baro_sel_in_hg_pilot
		if B738DR_flight_phase < 4 then
			if simDR_altitude_pilot > B738DR_trans_alt 
			and simDR_barometer_setting_capt ~= 29.92 then
				B738DR_baro_box_pilot_show = 1
				B738DR_baro_std_box_pilot_show = 0
			else
				B738DR_baro_box_pilot_show = 0
				B738DR_baro_std_box_pilot_show = 0
			end
		else
			B738DR_baro_box_pilot_show = 0
			B738DR_baro_std_box_pilot_show = 0
		end
	end

	-- First Officer
	if B738DR_baro_set_std_copilot == 1 then	-- set STD
		if baro_sel_co_old ~= B738DR_baro_sel_in_hg_copilot then
			B738DR_baro_sel_copilot_show = 1
		end
		if B738DR_flight_phase > 3 then
			if simDR_altitude_copilot < B738DR_trans_lvl then
				B738DR_baro_std_box_copilot_show = 1
				B738DR_baro_box_copilot_show = 0
			else
				B738DR_baro_std_box_copilot_show = 0
				B738DR_baro_box_copilot_show = 0
			end
		else
			B738DR_baro_std_box_copilot_show = 0
			B738DR_baro_box_copilot_show = 0
		end
	else
		simDR_barometer_setting_fo = B738DR_baro_sel_in_hg_copilot
		if B738DR_flight_phase < 4 then
			if simDR_altitude_copilot > B738DR_trans_alt 
			and simDR_barometer_setting_fo ~= 29.92 then
				B738DR_baro_box_copilot_show = 1
				B738DR_baro_std_box_copilot_show = 0
			else
				B738DR_baro_box_copilot_show = 0
				B738DR_baro_std_box_copilot_show = 0
			end
		else
			B738DR_baro_box_copilot_show = 0
			B738DR_baro_std_box_copilot_show = 0
		end
	end

end

function rst_ghust_detect()
	ghust_detect = 0
end

-- Speed ratio, Vertical speed ratio
function speed_ratio_timer()

	local airspeed = 0
	if autopilot_cmd_b_status == 1 then
		airspeed = simDR_airspeed_copilot
	else
		airspeed = simDR_airspeed_pilot
	end
	
	B738DR_speed_ratio = airspeed - airspeed_pilot_old
	airspeed_pilot_old = airspeed
	
	local vert_speed = simDR_vvi_fpm_pilot
	B738DR_v_speed_ratio = vert_speed - v_speed_pilot_old
	v_speed_pilot_old = vert_speed
	
	local vdot = 0
	if simDR_vdot_nav1_pilot == nil then
		B738DR_vdot_ratio = 999
	else
		vdot = simDR_vdot_nav1_pilot
		B738DR_vdot_ratio = vdot_ratio_old - vdot
		vdot_ratio_old = vdot
	end
	
	local radio_height = simDR_radio_height_pilot_ft
	if radio_height_ratio == 0 then
		radio_height_ratio = radio_height - radio_height_old
	else
		B738DR_radio_height_ratio = radio_height - radio_height_old
		B738DR_radio_height_ratio = (B738DR_radio_height_ratio + radio_height_ratio) / 2
		radio_height_ratio = 0
	end
	radio_height_old = radio_height
	
	local altitude_pilot = simDR_altitude_pilot
	B738DR_altitude_pilot_ratio = altitude_pilot - altitude_pilot_old
	altitude_pilot_old = altitude_pilot
	
	local air_on_acf = simDR_air_on_acf
	B738DR_air_on_acf_ratio = air_on_acf - air_on_acf_old
	air_on_acf_old = air_on_acf
	
	local eng1_N1 = simDR_engine_N1_pct1
	B738DR_eng1_N1_ratio = eng1_N1 - eng1_N1_old
	eng1_N1_old = eng1_N1
	
	local eng2_N1 = simDR_engine_N1_pct2
	B738DR_eng2_N1_ratio = eng2_N1 - eng2_N1_old
	eng2_N1_old = eng2_N1
	
	local wind_hdg_ratio = simDR_wind_hdg - wind_hdg_old
	if wind_hdg_ratio < 0 then
		wind_hdg_ratio = -wind_hdg_ratio
	end
	wind_hdg_ratio = wind_hdg_ratio % 360
	if wind_hdg_ratio > 180 then
		wind_hdg_ratio = wind_hdg_ratio - 360
	end
	local wind_hdg_rel_ratio = wind_hdg_ratio - wind_hdg_rel_old
	if wind_hdg_rel_ratio < 0 then
		wind_hdg_rel_ratio = -wind_hdg_rel_ratio
	end
	
	wind_hdg_old = simDR_wind_hdg
	wind_hdg_rel_old = wind_hdg_ratio
	
	local wind_spd_ratio = simDR_wind_spd - wind_spd_old
	if wind_spd_ratio < 0 then
		wind_spd_ratio = -wind_spd_ratio
	end
	wind_spd_old = simDR_wind_spd
	
	if wind_hdg_rel_ratio > 5 or wind_spd_ratio > 2.1 then
		ghust_detect = 1
		if is_timer_scheduled(rst_ghust_detect) == true then
			stop_timer(rst_ghust_detect)
		end
		run_after_time(rst_ghust_detect, 10)
	else
		if is_timer_scheduled(rst_ghust_detect) == false then
			ghust_detect = 0
		end
	end
	B738DR_pid_i = wind_hdg_ratio
	B738DR_pid_d = wind_spd_ratio
	measure = 1
	
end

function B738_radio_height()
	
	local height = 0
	
	-- pilot
	height = simDR_radio_height_pilot_ft - 4
	if height < 100 then
		B738DR_agl_pilot = height + 4
	elseif height < 500 then
		B738DR_agl_pilot = roundDownToIncrement(height, 10) + 4
	else
		B738DR_agl_pilot = roundDownToIncrement(height, 20) + 4
	end
	
	-- copilot
	height = simDR_radio_height_copilot_ft - 4
	if height < 100 then
		B738DR_agl_copilot = height + 4
	elseif height < 500 then
		B738DR_agl_copilot = roundDownToIncrement(height, 10) + 4
	else
		B738DR_agl_copilot = roundDownToIncrement(height, 20) + 4
	end
end

function dh_min_off_pilot()
	dh_min_enable_pilot = 1
end

function dh_min_off_copilot()
	dh_min_enable_copilot = 1
end


function B738_baro_radio()
	
	local alt_dh = 0
	if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1 or simDR_on_ground_2 == 1 then
		dh_min_block_pilot = 1
		dh_min_block_copilot = 1
	end
	-- captain
	if B738DR_minim_capt == 0 then	--radio DH
		simDR_dh_pilot = B738DR_dh_pilot
		if simDR_radio_height_pilot_ft < B738DR_dh_pilot and simDR_radio_height_pilot_ft > 0 then
			dh_minimum_pilot = 1
		end
		alt_dh = B738DR_dh_pilot + 75
		if simDR_radio_height_pilot_ft > alt_dh then
			dh_minimum_pilot = 0
			dh_min_block_pilot = 0
		end
		if B738DR_dh_pilot == 0 then
			dh_minimum_pilot = 0
		end
	else	-- baro DH
		if baro_dh_pilot > 0 then
			if simDR_altitude_pilot < baro_dh_pilot and baro_dh_pilot_disable == 0 then
				simDR_dh_pilot = simDR_radio_height_pilot_ft + 5
				baro_dh_pilot_disable = 1
				dh_minimum_pilot = 1
			end
			alt_dh = simDR_radio_height_pilot_ft - 5
			if simDR_dh_pilot < alt_dh then
				simDR_dh_pilot = 0
			end
			alt_dh = baro_dh_pilot + 75
			if simDR_altitude_pilot > alt_dh and baro_dh_pilot_disable == 1 then
				baro_dh_pilot_disable = 0
				simDR_dh_pilot = 0
				dh_minimum_pilot = 0
				dh_min_block_pilot = 0
			end
		else
			dh_minimum_pilot = 0
		end
	end
	if dh_minimum_pilot == 0 or dh_min_block_pilot == 1 then
		B738DR_dh_minimum_pilot2 = 0		-- green
		dh_min_enable_pilot = 0
		if is_timer_scheduled(dh_min_off_pilot) == true then
			stop_timer(dh_min_off_pilot)
		end
	else
		if dh_min_enable_pilot == 0 then
			if DRblink == 0 then
				B738DR_dh_minimum_pilot2 = 1		-- amber
			else
				B738DR_dh_minimum_pilot2 = 2		-- off
			end
			if is_timer_scheduled(dh_min_off_pilot) == false then
				run_after_time(dh_min_off_pilot, 3)	-- 3 seconds
			end
		else
			B738DR_dh_minimum_pilot2 = 1		-- amber
		end
	end
	
	-- first officer
	if B738DR_minim_fo == 0 then	--radio DH
		simDR_dh_copilot = B738DR_dh_copilot
		if simDR_radio_height_copilot_ft < B738DR_dh_copilot and simDR_radio_height_copilot_ft > 0 then
			dh_minimum_copilot = 1
		end
		alt_dh = B738DR_dh_copilot + 75
		if simDR_radio_height_copilot_ft > alt_dh then
			dh_minimum_copilot = 0
			dh_min_block_copilot = 0
		end
		if B738DR_dh_copilot == 0 then
			dh_minimum_copilot = 0
		end
	else	-- baro DH
		if baro_dh_copilot > 0 then
			if simDR_altitude_copilot < baro_dh_copilot and baro_dh_copilot_disable == 0 then
				simDR_dh_copilot = simDR_radio_height_copilot_ft + 5
				baro_dh_copilot_disable = 1
				dh_minimum_copilot = 1
			end
			alt_dh = simDR_radio_height_copilot_ft - 5
			if simDR_dh_copilot < alt_dh then
				simDR_dh_copilot = 0
			end
			alt_dh = baro_dh_copilot + 75
			if simDR_altitude_copilot > alt_dh and baro_dh_copilot_disable == 1 then
				baro_dh_copilot_disable = 0
				simDR_dh_copilot = 0
				dh_minimum_copilot = 0
				dh_min_block_copilot = 0
			end
		else
			dh_minimum_copilot = 0
		end
	end
	-- if dh_minimum_copilot == 0 then
		-- B738DR_dh_minimum_copilot2 = 0
	-- else
		-- B738DR_dh_minimum_copilot2 = 1
	-- end
	if dh_minimum_copilot == 0 or dh_min_block_copilot == 1 then
		B738DR_dh_minimum_copilot2 = 0		-- green
		dh_min_enable_copilot = 0
		if is_timer_scheduled(dh_min_off_copilot) == true then
			stop_timer(dh_min_off_copilot)
		end
	else
		if dh_min_enable_copilot == 0 then
			if DRblink == 0 then
				B738DR_dh_minimum_copilot2 = 1		-- amber
			else
				B738DR_dh_minimum_copilot2 = 2		-- off
			end
			if is_timer_scheduled(dh_min_off_copilot) == false then
				run_after_time(dh_min_off_copilot, 3)	-- 3 seconds
			end
		else
			B738DR_dh_minimum_copilot2 = 1		-- amber
		end
	end
	
end


function B738_baro_radio2()
	
	local alt_dh = 0
	if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1 or simDR_on_ground_2 == 1 then
		dh_min_block_pilot = 1
		dh_min_block_copilot = 1
	end
	-- captain
	if B738DR_minim_capt == 0 then	--radio DH
		simDR_dh_pilot = B738DR_dh_pilot
		if simDR_radio_height_pilot_ft < B738DR_dh_pilot and simDR_radio_height_pilot_ft > 0 then
			dh_minimum_pilot = 1
		end
		alt_dh = B738DR_dh_pilot + 75
		if simDR_radio_height_pilot_ft > alt_dh then
			dh_minimum_pilot = 0
			dh_min_block_pilot = 0
		end
		if B738DR_dh_pilot == 0 then
			dh_minimum_pilot = 0
		end
	else	-- baro DH
		simDR_dh_pilot = 0	--B738DR_dh_pilot
		if simDR_altitude_pilot < B738DR_dh_pilot and simDR_altitude_pilot > 0 then
			dh_minimum_pilot = 1
		end
		alt_dh = B738DR_dh_pilot + 75
		if simDR_altitude_pilot > alt_dh then
			dh_minimum_pilot = 0
			dh_min_block_pilot = 0
		end
		if B738DR_dh_pilot == 0 then
			dh_minimum_pilot = 0
		end
	end
	if dh_minimum_pilot == 0 or dh_min_block_pilot == 1 then
		B738DR_dh_minimum_pilot2 = 0		-- green
		dh_min_enable_pilot = 0
		if is_timer_scheduled(dh_min_off_pilot) == true then
			stop_timer(dh_min_off_pilot)
		end
	else
		if dh_min_enable_pilot == 0 then
			if DRblink == 0 then
				B738DR_dh_minimum_pilot2 = 1		-- amber
			else
				B738DR_dh_minimum_pilot2 = 2		-- off
			end
			if is_timer_scheduled(dh_min_off_pilot) == false then
				run_after_time(dh_min_off_pilot, 3)	-- 3 seconds
			end
		else
			B738DR_dh_minimum_pilot2 = 1		-- amber
		end
	end
	
	-- first officer
	if B738DR_minim_fo == 0 then	--radio DH
		simDR_dh_copilot = B738DR_dh_copilot
		if simDR_radio_height_copilot_ft < B738DR_dh_copilot and simDR_radio_height_copilot_ft > 0 then
			dh_minimum_copilot = 1
		end
		alt_dh = B738DR_dh_copilot + 75
		if simDR_radio_height_copilot_ft > alt_dh then
			dh_minimum_copilot = 0
			dh_min_block_copilot = 0
		end
		if B738DR_dh_copilot == 0 then
			dh_minimum_copilot = 0
		end
	else	-- baro DH
		simDR_dh_copilot = 0 	--B738DR_dh_copilot
		if simDR_altitude_copilot < B738DR_dh_copilot and simDR_altitude_copilot > 0 then
			dh_minimum_copilot = 1
		end
		alt_dh = B738DR_dh_copilot + 75
		if simDR_altitude_copilot > alt_dh then
			dh_minimum_copilot = 0
			dh_min_block_copilot = 0
		end
		if B738DR_dh_copilot == 0 then
			dh_minimum_copilot = 0
		end
	end
	if dh_minimum_copilot == 0 or dh_min_block_copilot == 1 then
		B738DR_dh_minimum_copilot2 = 0		-- green
		dh_min_enable_copilot = 0
		if is_timer_scheduled(dh_min_off_copilot) == true then
			stop_timer(dh_min_off_copilot)
		end
	else
		if dh_min_enable_copilot == 0 then
			if DRblink == 0 then
				B738DR_dh_minimum_copilot2 = 1		-- amber
			else
				B738DR_dh_minimum_copilot2 = 2		-- off
			end
			if is_timer_scheduled(dh_min_off_copilot) == false then
				run_after_time(dh_min_off_copilot, 3)	-- 3 seconds
			end
		else
			B738DR_dh_minimum_copilot2 = 1		-- amber
		end
	end
	
end

-- ILS info on PFD
function ils_radio_pfd()

	if B738DR_autopilot_vhf_source_pos == -1 then
		B738DR_pfd_nav1_pilot = 1
		B738DR_pfd_nav2_pilot = 0
		B738DR_pfd_nav1_copilot = 1
		B738DR_pfd_nav2_copilot = 0
	elseif B738DR_autopilot_vhf_source_pos == 0 then
		B738DR_pfd_nav1_pilot = 1
		B738DR_pfd_nav2_pilot = 0
		B738DR_pfd_nav1_copilot = 0
		B738DR_pfd_nav2_copilot = 1
	elseif B738DR_autopilot_vhf_source_pos == 1 then
		B738DR_pfd_nav1_pilot = 0
		B738DR_pfd_nav2_pilot = 1
		B738DR_pfd_nav1_copilot = 0
		B738DR_pfd_nav2_copilot = 1
	end

end

function B738_flight_director()
	
	local fdir_temp = 0
	
	fdir_temp = simDR_fdir_pitch - simDR_ahars_pitch_deg_pilot
	fdir_temp = math.max(fdir_temp, -15)
	fdir_temp = math.min(fdir_temp, 15)
	B738DR_fdir_pitch_pilot = fdir_temp

	fdir_temp = simDR_fdir_pitch - simDR_ahars_pitch_deg_copilot
	fdir_temp = math.max(fdir_temp, -15)
	fdir_temp = math.min(fdir_temp, 15)
	B738DR_fdir_pitch_copilot = fdir_temp
	
end

function B738_hyd_sys()
	
	-- CMD A and CMD B (autoland)
	if B738DR_hyd_A_status == 0 or B738DR_hyd_B_status == 0 then
		if autopilot_cmd_a_status == 1 and autopilot_cmd_b_status == 1 then
			-- disengage A/P and autoland
				simDR_flight_dir_mode = 1
			-- F/D on
				ap_roll_mode = 0
				ap_pitch_mode = 0
				ap_roll_mode_eng = 0
				ap_pitch_mode_eng = 0
				autopilot_cmd_a_status = 0
				autopilot_cmd_b_status = 0
				B738DR_autoland_status = 0
				B738DR_flare_status = 0
				B738DR_rollout_status = 0
				B738DR_retard_status = 0
				simDR_ap_vvi_dial = 0
				at_mode = 0
				--at_mode_eng = 0
				vorloc_only = 0
				ils_test_enable = 0
				ils_test_on = 0
		end
	end
	-- CMD A
	if B738DR_hyd_A_status == 0 then
		if autopilot_cmd_a_status == 1 then
			-- disengaged A/P (A)
			simDR_flight_dir_mode = 1
				-- F/D on only
			autopilot_cws_a_status = 0
			autopilot_cmd_a_status = 0
			B738DR_single_ch_status = 0
			ap_roll_mode = 0
			ap_pitch_mode = 0
		end
	end
	-- CMD B
	if B738DR_hyd_B_status == 0 then
		if autopilot_cmd_b_status == 1 then
			-- disengaged A/P (B)
			simDR_flight_dir_mode = 1
				-- F/D on only
			autopilot_cws_b_status = 0
			autopilot_cmd_b_status = 0
			B738DR_single_ch_status = 0
			ap_roll_mode = 0
			ap_pitch_mode = 0
		end
	end
	
	-- -- A/T disarm
	local on_the_ground = simDR_on_ground_0 + simDR_on_ground_1 + simDR_on_ground_2
	on_the_ground = math.min(on_the_ground, 1)
	if eng1_N1_thrust == 0 or eng2_N1_thrust == 0 or (B738DR_fms_N1_mode == 13 and on_the_ground == 1)then
		if B738DR_autopilot_autothr_arm_pos == 1 and autothr_arm_pos == 0 then
			B738DR_autopilot_autothr_arm_pos = 0
			B738DR_autopilot_autothrottle_status = 0
			at_mode = 0
			simCMD_autothrottle_discon:once()	-- disconnect autothrotle
			at_status = 0
		end
	end

end

function hdg_line_timer()
	hide_hdg_line = 1
end

function hdg_line_timer_fo()
	hide_hdg_line_fo = 1
end

function B738_nd()
	
	local relative_brg = 0
	
	-- CAPTAIN
	if B738DR_capt_map_mode < 2 then
		B738DR_mcp_hdg_dial_nd = B738DR_mcp_hdg_dial - simDR_ahars_mag_hdg
		B738DR_nd_crs = B738DR_course_pilot - simDR_ahars_mag_hdg
		if B738DR_capt_exp_map_mode == 0 then
			B738DR_mcp_hdg_dial_nd_show = 0
		else
			B738DR_mcp_hdg_dial_nd_show = 1
		end
		if cpt_tcas_enable == 0 then
			B738DR_EFIS_TCAS_on = 0
		else
			B738DR_EFIS_TCAS_on = 1
		end
	elseif B738DR_capt_map_mode == 2 then
		if B738DR_track_up == 0 then
			-- HDG-UP
			B738DR_mcp_hdg_dial_nd = B738DR_mcp_hdg_dial - simDR_ahars_mag_hdg
			B738DR_nd_crs = B738DR_course_pilot - simDR_ahars_mag_hdg
			if B738DR_capt_exp_map_mode == 0 then
				B738DR_mcp_hdg_dial_nd_show = 2
			else
				B738DR_mcp_hdg_dial_nd_show = 1
			end
		else
			-- TRK-UP
			if simDR_ground_spd < 45 then
				-- TRK/HDG
				B738DR_mcp_hdg_dial_nd = B738DR_mcp_hdg_dial - simDR_ahars_mag_hdg
				B738DR_nd_crs = B738DR_course_pilot - simDR_ahars_mag_hdg
				if B738DR_capt_exp_map_mode == 0 then
					B738DR_mcp_hdg_dial_nd_show = 2
				else
					B738DR_mcp_hdg_dial_nd_show = 1
				end
			else
				B738DR_mcp_hdg_dial_nd = B738DR_mcp_hdg_dial - simDR_mag_hdg
				if B738DR_capt_exp_map_mode == 0 then
					B738DR_mcp_hdg_dial_nd_show = 2
				else
					B738DR_mcp_hdg_dial_nd_show = 1
				end
			end
		end
		--B738DR_mcp_hdg_dial_nd_show = 1
		
		if cpt_tcas_enable == 0 then
			B738DR_EFIS_TCAS_on = 0
		else
			B738DR_EFIS_TCAS_on = 1
		end
		
	else
		B738DR_mcp_hdg_dial_nd_show = 0
		B738DR_EFIS_TCAS_on = 0
	end
	
	if simDR_ground_spd < 45 then
		B738DR_track_up_active = 0
	else
		B738DR_track_up_active = 1
	end
	-- ND basic
	--if B738DR_capt_exp_map_mode == 1 then
		if B738DR_capt_map_mode <= 2 then
			--B738DR_hdg_mag_nd_show = 1
			if B738DR_capt_map_mode == 2 then
				-- MAP mode
				if B738DR_track_up == 0 then
					-- HDG-UP
					B738DR_hdg_mag_nd = -simDR_ahars_mag_hdg
					relative_brg = (simDR_ahars_mag_hdg - simDR_mag_hdg + 360) % 360
					if relative_brg > 180 then
						relative_brg = relative_brg - 360
					end
					if simDR_ground_spd < 45 then
						B738DR_track_nd = 0
					else
						B738DR_track_nd = relative_brg
					end
					B738DR_hdg_bug_nd = 0
				else
					-- TRK-UP
					if simDR_ground_spd < 45 then
						-- TRK/HDG
						--B738DR_track_up_active = 0
						B738DR_hdg_mag_nd = -simDR_ahars_mag_hdg
						relative_brg = (simDR_ahars_mag_hdg - simDR_mag_hdg + 360) % 360
						if relative_brg > 180 then
							relative_brg = relative_brg - 360
						end
						--B738DR_track_nd = relative_brg
						B738DR_hdg_bug_nd = 0
						B738DR_track_nd = 0
					else
						-- TRK
						--B738DR_track_up_active = 1
						B738DR_hdg_mag_nd = -simDR_mag_hdg
						B738DR_track_nd = 0
						relative_brg = (simDR_ahars_mag_hdg - simDR_mag_hdg + 360) % 360
						if relative_brg > 180 then
							relative_brg = relative_brg - 360
						end
						B738DR_hdg_bug_nd = relative_brg
					end
				end
				
			else
				-- APP, VOR mode
				B738DR_hdg_mag_nd = -simDR_ahars_mag_hdg
				relative_brg = (simDR_ahars_mag_hdg - simDR_mag_hdg + 360) % 360
				if relative_brg > 180 then
					relative_brg = relative_brg - 360
				end
				B738DR_track_nd = relative_brg
				B738DR_hdg_bug_nd = 0
			end
		--else
			-- PLN mode
			--B738DR_hdg_mag_nd_show = 0
		end
		
	
	if B738DR_capt_exp_map_mode == 0 then
		--B738DR_hdg_mag_nd_show = 0
		B738DR_hdg_mag_nd = -simDR_ahars_mag_hdg
	end
	
	-- FIRST OFFICER
	if B738DR_fo_map_mode < 2 then
		B738DR_mcp_hdg_dial_nd_fo = B738DR_mcp_hdg_dial - simDR_ahars_mag_hdg
		B738DR_nd_crs_fo = B738DR_course_copilot - simDR_ahars_mag_hdg
		if B738DR_fo_exp_map_mode == 0 then
			B738DR_mcp_hdg_dial_nd_fo_show = 0
		else
			B738DR_mcp_hdg_dial_nd_fo_show = 1
		end
		if fo_tcas_enable == 0 then
			B738DR_EFIS_TCAS_on_fo = 0
		else
			B738DR_EFIS_TCAS_on_fo = 1
		end
	elseif B738DR_fo_map_mode == 2 then
		if B738DR_track_up == 0 then
			-- HDG-UP
			B738DR_mcp_hdg_dial_nd_fo = B738DR_mcp_hdg_dial - simDR_ahars_mag_hdg
			B738DR_nd_crs_fo = B738DR_course_copilot - simDR_ahars_mag_hdg
			if B738DR_fo_exp_map_mode == 0 then
				B738DR_mcp_hdg_dial_nd_fo_show = 2
			else
				B738DR_mcp_hdg_dial_nd_fo_show = 1
			end
		else
			if simDR_ground_spd < 45 then
				-- TRK/HDG
				B738DR_mcp_hdg_dial_nd_fo = B738DR_mcp_hdg_dial - simDR_ahars_mag_hdg
				B738DR_nd_crs_fo = B738DR_course_copilot - simDR_ahars_mag_hdg
				if B738DR_fo_exp_map_mode == 0 then
					B738DR_mcp_hdg_dial_nd_fo_show = 2
				else
					B738DR_mcp_hdg_dial_nd_fo_show = 1
				end
			else
				-- TRK-UP
				B738DR_mcp_hdg_dial_nd_fo = B738DR_mcp_hdg_dial - simDR_mag_hdg
				if B738DR_fo_exp_map_mode == 0 then
					B738DR_mcp_hdg_dial_nd_fo_show = 2
				else
					B738DR_mcp_hdg_dial_nd_fo_show = 1
				end
			end
		end
		--B738DR_mcp_hdg_dial_nd_fo_show = 1
		if fo_tcas_enable == 0 then
			B738DR_EFIS_TCAS_on_fo = 0
		else
			B738DR_EFIS_TCAS_on_fo = 1
		end
	else
		B738DR_mcp_hdg_dial_nd_fo_show = 0
		B738DR_EFIS_TCAS_on_fo = 0
	end
	
	-- ND basic
	--if B738DR_fo_exp_map_mode == 1 then
		if B738DR_fo_map_mode <= 2 then
			--B738DR_hdg_mag_nd_fo_show = 1
			if B738DR_fo_map_mode == 2 then
				-- MAP mode
				if B738DR_track_up == 0 then
					-- HDG-UP
					B738DR_hdg_mag_nd_fo = -simDR_ahars_mag_hdg
					relative_brg = (simDR_ahars_mag_hdg - simDR_mag_hdg + 360) % 360
					if relative_brg > 180 then
						relative_brg = relative_brg - 360
					end
					if simDR_ground_spd < 45 then
						B738DR_track_nd_fo = 0
					else
						B738DR_track_nd_fo = relative_brg
					end
					--B738DR_track_nd_fo = relative_brg
					B738DR_hdg_bug_nd_fo = 0
				else
					if simDR_ground_spd < 45 then
						-- TRK/HDG
						--B738DR_track_up_active = 0
						B738DR_hdg_mag_nd_fo = -simDR_ahars_mag_hdg
						relative_brg = (simDR_ahars_mag_hdg - simDR_mag_hdg + 360) % 360
						if relative_brg > 180 then
							relative_brg = relative_brg - 360
						end
						--B738DR_track_nd_fo = relative_brg
						B738DR_track_nd_fo = 0
						B738DR_hdg_bug_nd_fo = 0
					else
					-- TRK-UP
						--B738DR_track_up_active = 1
						B738DR_hdg_mag_nd_fo = -simDR_mag_hdg
						B738DR_track_nd_fo = 0
						relative_brg = (simDR_ahars_mag_hdg - simDR_mag_hdg + 360) % 360
						if relative_brg > 180 then
							relative_brg = relative_brg - 360
						end
						B738DR_hdg_bug_nd_fo = relative_brg
					end
				end
			else
				-- APP, VOR mode
				B738DR_hdg_mag_nd_fo = -simDR_ahars_mag_hdg
				relative_brg = (simDR_ahars_mag_hdg - simDR_mag_hdg + 360) % 360
				if relative_brg > 180 then
					relative_brg = relative_brg - 360
				end
				B738DR_track_nd_fo = relative_brg
				B738DR_hdg_bug_nd_fo = 0
			end
		--else
			-- PLN mode
			--B738DR_hdg_mag_nd_fo_show = 0
		end
		
	if B738DR_fo_exp_map_mode == 0 then
		--B738DR_hdg_mag_nd_fo_show = 0
		B738DR_hdg_mag_nd_fo = -simDR_ahars_mag_hdg
	end
	
	-- PFD TRACK LINE
	if simDR_ground_spd < 45 then
		B738DR_track_pfd = simDR_ahars_mag_hdg
	else
		B738DR_track_pfd = simDR_mag_hdg
	end
	
	-- HDG LINE
	if B738DR_capt_map_mode == 2 then
		if simDR_approach_status == 2 or lnav_engaged == 1 then
			if B738DR_mcp_hdg_dial ~= mcp_hdg_dial_old then
				hide_hdg_line = 0
				if is_timer_scheduled(hdg_line_timer) == true then
					stop_timer(hdg_line_timer)
				end
				run_after_time(hdg_line_timer, 10)
			else
				if is_timer_scheduled(hdg_line_timer) == false and hide_hdg_line == 0 then
					run_after_time(hdg_line_timer, 10)
				end
			end
		else
			if is_timer_scheduled(hdg_line_timer) == true then
				stop_timer(hdg_line_timer)
			end
			hide_hdg_line = 0
		end
	else
		if is_timer_scheduled(hdg_line_timer) == true then
			stop_timer(hdg_line_timer)
		end
		hide_hdg_line = 0
	end
	
	if B738DR_fo_map_mode == 2 then
		if simDR_approach_status == 2 or lnav_engaged == 1 then
			if B738DR_mcp_hdg_dial ~= mcp_hdg_dial_old then
				hide_hdg_line_fo = 0
				if is_timer_scheduled(hdg_line_timer_fo) == true then
					stop_timer(hdg_line_timer_fo)
				end
				run_after_time(hdg_line_timer_fo, 10)
			else
				if is_timer_scheduled(hdg_line_timer_fo) == false and hide_hdg_line_fo == 0 then
					run_after_time(hdg_line_timer_fo, 10)
				end
			end
		else
			if is_timer_scheduled(hdg_line_timer_fo) == true then
				stop_timer(hdg_line_timer_fo)
			end
			hide_hdg_line_fo = 0
		end
	else
		if is_timer_scheduled(hdg_line_timer_fo) == true then
			stop_timer(hdg_line_timer_fo)
		end
		hide_hdg_line_fo = 0
	end

	if hide_hdg_line == 0 then
		B7378DR_hdg_line_enable = 1
	else
		B7378DR_hdg_line_enable = 0
	end
	if hide_hdg_line_fo == 0 then
		B7378DR_hdg_line_fo_enable = 1
	else
		B7378DR_hdg_line_fo_enable = 0
	end
	
	mcp_hdg_dial_old = B738DR_mcp_hdg_dial
	
	-- TERRAIN
	if B738DR_windshear == 1 and B738DR_enable_gpwstest_long == 0 and B738DR_enable_gpwstest_short == 0 then
		-- detected windshear
		if B738DR_efis_wxr_on == 1 then
			cpt_terr_enable = 0
		end
		if B738DR_efis_fo_wxr_on == 1 then
			fo_terr_enable = 0
		end
	end
	
	-- one terrain radar at the same time
	if cpt_terr_enable == 0 and fo_terr_enable == 0 then
		-- terrain turn off
		B738DR_efis_terr_on = 0
		B738DR_efis_fo_terr_on = 0
	else
		if cpt_terr_enable == 1 then
			fo_terr_enable = 0
		else
			cpt_terr_enable = 0
		end
	end
	
	local terr_enable = cpt_terr_enable
	if B738DR_capt_exp_map_mode == 0 and B738DR_capt_map_mode < 2 then
		terr_enable = 0
	elseif B738DR_capt_map_mode == 3 then
		terr_enable = 0
	end
	B738DR_efis_terr_on = terr_enable
	
	terr_enable = fo_terr_enable
	if B738DR_fo_exp_map_mode == 0 and B738DR_fo_map_mode < 2 then
		terr_enable = 0
	elseif B738DR_fo_map_mode == 3 then
		terr_enable = 0
	end
	B738DR_efis_fo_terr_on = terr_enable
	
	-- WEATHER RADAR
	-- one weather radar at the same time
	if B738DR_efis_wxr_on == 0 and B738DR_efis_fo_wxr_on == 0 then
		-- turn off WX
		if simDR_efis_wxr_on == 1 then
			simCMD_efis_wxr:once()
		end
	else
		if B738DR_efis_wxr_on == 0 then
			-- First Officer
			if B738DR_fo_map_mode <= 2 then
				-- APP, VOR mode
				if B738DR_fo_exp_map_mode == 0 then
					-- turn off WX for CTR mode
					if simDR_efis_wxr_on == 1 then
						simCMD_efis_wxr:once()
					end
				elseif B738DR_efis_map_range_fo == 0 then
					-- turn off WX for range 5NM
					if simDR_efis_wxr_on == 1 then
						simCMD_efis_wxr:once()
					end
				else
					-- if B738DR_efis_fo_terr_on == 0 then
						-- turn on WW for First Officer
						if simDR_efis_wxr_on == 0 then	--and B738DR_fo_exp_map_mode == 1 then
							simCMD_efis_wxr:once()
						end
						simDR_efis_map_range = B738DR_efis_map_range_fo
					-- else
						-- if simDR_efis_wxr_on == 1 then
							-- simCMD_efis_wxr:once()
						-- end
					-- end
				end
			else
				-- turn off WX for PLN mode
				if simDR_efis_wxr_on == 1 then
					simCMD_efis_wxr:once()
				end
			end
		else
			-- Captain
			if B738DR_capt_map_mode <= 2 then
				-- APP, VOR mode
				if B738DR_capt_exp_map_mode == 0 then
					-- turn off WX for CTR mode
					if simDR_efis_wxr_on == 1 then
						simCMD_efis_wxr:once()
					end
				elseif B738DR_efis_map_range_capt == 0 then
					-- turn off WX for range 5NM
					if simDR_efis_wxr_on == 1 then
						simCMD_efis_wxr:once()
					end
				else
				-- turn on WX for Captain
					-- if B738DR_efis_terr_on == 0 then
						if simDR_efis_wxr_on == 0 then	--and B738DR_capt_exp_map_mode == 1 then
							simCMD_efis_wxr:once()
						end
						simDR_efis_map_range = B738DR_efis_map_range_capt
					-- else
						-- if simDR_efis_wxr_on == 1 then
							-- simCMD_efis_wxr:once()
						-- end
					-- end
				end
			else
				-- turn off WX for PLN mode
				if simDR_efis_wxr_on == 1 then
					simCMD_efis_wxr:once()
				end
			end
		end
	end
	
	-- ND Rings
	local efis_rings = 0
	if B738DR_nd_rings ~= 0 then
		if B738DR_capt_exp_map_mode == 1 and B738DR_capt_map_mode <= 2 then
			if B738DR_efis_terr_on == 1 or B738DR_efis_wxr_on == 1 or B738DR_EFIS_TCAS_on == 1 then
				efis_rings = 1
			end
		end
	end
	B738DR_efis_rings = efis_rings
	
	efis_rings = 0
	if B738DR_nd_rings ~= 0 then
		if B738DR_fo_exp_map_mode == 1 and B738DR_fo_map_mode <= 2 then
			if B738DR_efis_fo_terr_on == 1 or B738DR_efis_fo_wxr_on == 1 or B738DR_EFIS_TCAS_on_fo == 1 then
				efis_rings = 1
			end
		end
	end
	B738DR_efis_fo_rings = efis_rings
	
end

function B738_ctr_exp_mode()
	
	-- Captain
	if B738DR_capt_map_mode < 2 then
		-- APP/VOR mode
		B738DR_capt_exp_map_mode = capt_exp_vor_app_mode
		B738DR_capt_vsd_map_mode = 0
	elseif B738DR_capt_map_mode == 2 then
		-- MAP mode
		B738DR_capt_exp_map_mode = capt_exp_map_mode
		B738DR_capt_vsd_map_mode = capt_vsd_map_mode
	else
		-- PLN mode
		B738DR_capt_exp_map_mode = 1
		B738DR_capt_vsd_map_mode = 0
	end
	
	-- First Officier
	if B738DR_fo_map_mode < 2 then
		-- APP/VOR mode
		B738DR_fo_exp_map_mode = fo_exp_vor_app_mode
		B738DR_fo_vsd_map_mode = 0
	elseif B738DR_fo_map_mode == 2 then
		-- MAP mode
		B738DR_fo_exp_map_mode = fo_exp_map_mode
		B738DR_fo_vsd_map_mode = fo_vsd_map_mode
	else
		-- PLN mode
		B738DR_fo_exp_map_mode = 1
		B738DR_fo_vsd_map_mode = 0
	end
	
	
end

function B738_yoke()
	
	local yoke_pitch = 0
	local yoke_roll = 0
	
	if simDR_flight_dir_mode == 2 then
		simDR_pitch_ratio2 = B738_set_anim_value(simDR_pitch_ratio2, 0, -1.0, 1.0, 3)
		simDR_roll_ratio2 = B738_set_anim_value(simDR_roll_ratio2, 0, -1.0, 1.0, 3)
		simDR_heading_ratio2 = B738_set_anim_value(simDR_heading_ratio2, 0, -1.0, 1.0, 3)
		
		yoke_pitch = simDR_pitch_ratio2 + simDR_servo_pitch_ratio
		yoke_pitch = math.min(yoke_pitch, 1.0)
		yoke_pitch = math.max(yoke_pitch, -1.0)
		
		yoke_roll = simDR_roll_ratio2 + simDR_servo_roll_ratio
		yoke_roll = math.min(yoke_roll, 1.0)
		yoke_roll = math.max(yoke_roll, -1.0)
		
		B738DR_yoke_pitch = B738_set_anim_value(B738DR_yoke_pitch, yoke_pitch, -1.0, 1.0, 3)
		B738DR_yoke_roll = B738_set_anim_value(B738DR_yoke_roll, yoke_roll, -1.0, 1.0, 3)
		
		yoke_servo = 1
	else
		if yoke_servo == 0 then
			B738DR_yoke_pitch = simDR_pitch_ratio2
			B738DR_yoke_roll = simDR_roll_ratio2
		else
			B738DR_yoke_pitch = B738_set_anim_value(B738DR_yoke_pitch, simDR_pitch_ratio2, -1.0, 1.0, 3)
			B738DR_yoke_roll = B738_set_anim_value(B738DR_yoke_roll, simDR_roll_ratio2, -1.0, 1.0, 3)
			yoke_pitch = B738DR_yoke_pitch - simDR_pitch_ratio2
			if yoke_pitch < 0 then
				yoke_pitch = -yoke_pitch
			end
			yoke_roll = B738DR_yoke_roll - simDR_roll_ratio2
			if yoke_roll < 0 then
				yoke_roll = -yoke_roll
			end
			if yoke_pitch < 0.01 and yoke_roll < 0.01 then
				yoke_servo = 0
			end
		end
	end
	
end


function B738_spd_ratio()
	time_spd_ratio = time_spd_ratio + SIM_PERIOD
	if time_spd_ratio > 0.1 then
		
		if spd_ratio_num == 0 then
			spd_ratio_num = 1
		end
		
		-- spd_ratio = (simDR_airspeed_pilot - spd_ratio_old) / time_spd_ratio
		-- spd_ratio_old = simDR_airspeed_pilot
		
		gnd_spd_ratio = ((simDR_ground_spd * 1.94384449244) - gnd_spd_ratio_old) / time_spd_ratio
		gnd_spd_ratio_old = simDR_ground_spd * 1.94384449244
		
		spd_ratio_old = simDR_airspeed_accel_pilot - spd_ratio
		spd_ratio = simDR_airspeed_accel_pilot
		spd_ratio_old = spd_ratio
		
		hdg_ratio = (simDR_ahars_mag_hdg - hdg_ratio_old + 360) % 360
		if hdg_ratio > 180 then
			hdg_ratio = hdg_ratio - 360
		end
		hdg_ratio = hdg_ratio / time_spd_ratio
		hdg_ratio_old = simDR_ahars_mag_hdg
		
		spd_ratio_num = 0
		time_spd_ratio = 0	--time_spd_ratio - 1
	else
		
		spd_ratio_num = spd_ratio_num + 1
	end

end

function B738_afs_protect()
	if B738DR_autopilot_autothr_arm_pos == 1 then
		if at_mode == 0 and ap_pitch_mode ~= 5 then
			if simDR_airspeed_is_mach == 0 then
				if simDR_airspeed_pilot > (B738DR_afs_spd_limit_max - 8) then
					if simDR_airspeed_dial_kts > B738DR_afs_spd_limit_max then
						simDR_airspeed_dial_kts = B738DR_afs_spd_limit_max
					end
					at_mode = 2
				end
			end
		elseif at_mode ~= 3 and at_mode ~= 4 and at_mode ~= 5 and at_mode ~= 8 and ap_pitch_mode ~= 5 then
			if simDR_airspeed_is_mach == 0 then
				if simDR_airspeed_pilot > (B738DR_afs_spd_limit_max - 5) and simDR_airspeed_dial_kts > B738DR_afs_spd_limit_max then
					simDR_airspeed_dial_kts = B738DR_afs_spd_limit_max
				end
			end
		end
		if simDR_radio_height_pilot_ft > 400 then
			if at_mode == 0 and ap_pitch_mode ~= 5 then
				if simDR_airspeed_is_mach == 0 then
					if simDR_airspeed_pilot < (B738DR_pfd_min_speed + 13) then
						if simDR_airspeed_dial_kts < B738DR_pfd_min_speed then
							simDR_airspeed_dial_kts = B738DR_pfd_min_speed + 5
						end
						at_mode = 2
					end
				end
			elseif at_mode ~= 3 and at_mode ~= 4 and at_mode ~= 5 and at_mode ~= 8 and ap_pitch_mode ~= 5 then
				if simDR_airspeed_is_mach == 0 then
					if simDR_airspeed_pilot < (B738DR_pfd_min_speed + 8) and simDR_airspeed_dial_kts < B738DR_pfd_min_speed then
						simDR_airspeed_dial_kts = B738DR_pfd_min_speed + 4
					end
				end
			end
		end
	end
end

function B738_eng_out()
	
	local delta_N1 = simDR_engine_N1_pct1 - simDR_engine_N1_pct2
	if delta_N1 < 0 then
		delta_N1 = -delta_N1
	end
	
	if simDR_radio_height_pilot_ft > 50 then
		if delta_N1 > 10 or simDR_engine_N1_pct1 < 18 or simDR_engine_N1_pct2 < 18 then
				B738DR_eng_out = 1
		else
			B738DR_eng_out = 0
		end
	end
	
end

--*************************************************************************************--
--** 				               XLUA EVENT CALLBACKS       	        			 **--
--*************************************************************************************--

--function aircraft_load() end

--function aircraft_unload() end

function flight_start()

-- simDR_vor1_capt = 1
-- simDR_vor2_capt	= 1
-- simDR_vor1_fo	= 1
-- simDR_vor2_fo	= 1

B738DR_efis_vor1_capt_pos = 1
B738DR_efis_vor2_capt_pos = 1
simDR_vor1_capt = 2
simDR_vor2_capt = 2
B738DR_minim_capt = 1
B738DR_efis_vor1_fo_pos = 1
B738DR_efis_vor2_fo_pos = 1
simDR_vor1_fo = 2
simDR_vor2_fo = 2
B738DR_minim_fo = 1
B738DR_capt_map_mode = 2
B738DR_fo_map_mode = 2
simDR_EFIS_mode = 2



simDR_efis_ndb	= 0
simDR_bank_angle = 4
simDR_autopilot_source = 0
simDR_autopilot_fo_source = 1
simDR_autopilot_side = 0
B738DR_autopilot_bank_angle_pos = 2

autopilot_cmd_a_status = 0
autopilot_cmd_b_status = 0
autopilot_cws_a_status = 0
autopilot_cws_b_status = 0
B738DR_autopilot_hdg_sel_status = 0
B738DR_autopilot_vorloc_status = 0
B738DR_autopilot_app_status = 0
B738DR_autopilot_lnav_status = 0
B738DR_autopilot_vs_status = 0
B738DR_autopilot_lvl_chg_status = 0
B738DR_autopilot_alt_hld_status = 0
B738DR_autopilot_vnav_status = 0
B738DR_autopilot_fd_pos = 0
B738DR_autopilot_fd_fo_pos = 0
B738DR_autopilot_n1_pfd = 0
B738DR_autopilot_n1_status = 0
B738DR_autopilot_vnav_alt_pfd = 0
B738DR_autopilot_vnav_pth_pfd = 0
B738DR_autopilot_vnav_spd_pfd = 0
B738DR_autopilot_fmc_spd_pfd = 0
B738DR_autopilot_vvi_status_pfd = 0
ap_roll_mode = 0
ap_pitch_mode = 0
ap_roll_mode_eng = 0
ap_pitch_mode_eng = 0
simDR_joy_pitch_override = 0
B738DR_autopilot_autothr_arm_pos = 0
B738DR_autopilot_autothrottle_status = 0

simDR_throttle_override = 1
eng1_N1_thrust_cur = 0
eng2_N1_thrust_cur = 0
------simDR_throttle_override = 0

B738DR_autoland_status = 0
B738DR_flare_status = 0
B738DR_rollout_status = 0
B738DR_retard_status = 0
B738DR_single_ch_status = 0
vorloc_only = 0
B738DR_ils_pointer_disable = 0
aircraft_was_on_air = 0
B738DR_fmc_mode = 0
B738DR_fmc_descent_now = 0
B738DR_lowerDU_page = 0
DRblink = 0
B738DR_mach_disable = 0
B738DR_kts_disable = 0
B738DR_was_on_cruise = 0
mem_airspeed_dial = 100
mem_speed_mode = 0
at_mode = 0
at_mode_eng = 0
ap_pitch_mode_old = 0
ap_roll_mode_old = 0
approach_status_old = 0
glideslope_status_old = 0
B738DR_autopilot_to_ga_pfd = 0
B738DR_autopilot_thr_hld_pfd = 0
B738DR_autopilot_ga_pfd = 0
B738DR_autopilot_alt_acq_pfd = 0
takeoff_n1 = 0
ap_goaround = 0
fd_goaround = 0
cmd_first = 0
ils_test_enable = 0
ils_test_on = 0
ils_test_ok = 0
ap_app_block_800 = 0
B738DR_lowerDU_page = 1
vnav_descent = 0
vnav_active = 0
--vnav_active2 = 0
vnav_cruise = 0
--vnav_speed_dial = 200
--vnav_speed_dial2 = 0
--vnav_block_thrust = 0
lift_off_150 = 0
on_ground_30 = 1
ap_goaround_block = 0
B738DR_pfd_vorloc_lnav = 0
ias_disagree = 0
alt_disagree = 0

B738DR_eng1_N1_bug = 0.984
B738DR_eng2_N1_bug = 0.984
eng1_N1_man = 0.984
eng2_N1_man = 0.984

at_throttle_hold = 0
nav_id_old = "*"

B738DR_mcp_alt_dial = simDR_ap_altitude_dial_ft
if B738DR_mcp_alt_dial < 0 then
	B738DR_mcp_alt_dial = 0
end
simDR_ap_vvi_dial = 0

--- FLARE CONSTANTS ---
B738DR_thrust_vvi_1 = -200
B738DR_thrust_vvi_2 = -520
B738DR_thrust_ratio_1 = 0.06
B738DR_thrust_ratio_2 = 0.03	--0.003
B738DR_flare_ratio = 2.0	--0.6	--1.2
B738DR_pitch_ratio = 2.2	--1.6	--1.8	--2.1	--2.2	--2.22
B738DR_pitch_offset = 0.85

B738DR_baro_sel_in_hg_pilot = 29.92	--simDR_barometer_setting_capt
B738DR_baro_sel_in_hg_copilot = 29.92	--simDR_barometer_setting_fo

B738DR_EFIS_TCAS_on = 1
B738DR_EFIS_TCAS_on_fo = 1
simDR_EFIS_TCAS = 0
cpt_tcas_enable = 1
fo_tcas_enable = 1
cpt_terr_enable = 0
fo_terr_enable = 0
cpt_pos_enable = 0
fo_pos_enable = 0

B738DR_ap_spd_interv_status = 0
lnav_app = 0

simDR_fdir_pitch_ovr = 1
simDR_fdir_pitch = 0
simDR_fdir_pitch_ovr = 0

vnav_vs = 0
lvl_chg_vs = 0
vnav_alt_hld = 0
altitude_dial_ft_old = 0
bellow_400ft = 0

if is_timer_scheduled(speed_ratio_timer) == false then
	run_at_interval(speed_ratio_timer, 1)
end


B738DR_pfd_nav1_pilot = 0
B738DR_pfd_nav2_pilot = 0
B738DR_pfd_nav1_copilot = 0
B738DR_pfd_nav2_copilot = 0

B738DR_fms_descent_now = 0

reverse_max_enable1 = 0
reverse_max_on1 = 0
reverse_max_enable2 = 0
reverse_max_on2 = 0

radio_dh_pilot = 0
baro_dh_pilot = 0
baro_dh_pilot_disable = 0
radio_dh_copilot = 0
baro_dh_copilot = 0
baro_dh_copilot_disable = 0

blink_rec_cmd_status1 = 0
blink_rec_cmd_status2 = 0
blink_rec_sch_status = 0
blink_rec_alt_alert_status = 0
cmd_old1 = 0
cmd_old2 = 0
single_ch_status_old = 0
vnav_descent_disable = 0
dh_minimum_pilot = 0
dh_minimum_copilot = 0
dh_min_block_pilot = 0
dh_min_block_copilot = 0

if simDR_startup_running == 0 then
	B738DR_efis_vor_on = 0
	B738DR_efis_apt_on = 0
	B738DR_efis_fix_on = 0
	B738DR_efis_wxr_on = 0
	B738DR_efis_wxr_capt = 0
	B738DR_efis_fo_vor_on = 0
	B738DR_efis_fo_apt_on = 0
	B738DR_efis_fo_fix_on = 0
	B738DR_efis_fo_wxr_on = 0
	simDR_efis_wxr_on = 0
else
	B738DR_efis_vor_on = 1
	B738DR_efis_apt_on = 1
	B738DR_efis_fix_on = 0
	B738DR_efis_wxr_on = 0
	B738DR_efis_wxr_capt = 0
	B738DR_efis_fo_vor_on = 1
	B738DR_efis_fo_apt_on = 1
	B738DR_efis_fo_fix_on = 0
	B738DR_efis_fo_wxr_on = 0

end

simDR_efis_vor_on = 0
simDR_efis_apt_on = 0
simDR_efis_fix_on = 0
simDR_efis_wxr_on = 0
simDR_efis_sub_mode = 2
simDR_efis_map_mode = 0

B738DR_efis_data_capt_status = 0
B738DR_efis_data_fo_status = 0

B738DR_efis_map_range_capt = 1
B738DR_efis_map_range_fo = 1

B738DR_capt_exp_map_mode = 1
B738DR_fo_exp_map_mode = 1

vnav_init = 0
vnav_init2 = 0
vs_first = 0
vnav_alt_hold = 0
vnav_alt_hold_act = 0
mcp_alt_hold = 0
rest_wpt_alt_old = 0
vnav_engaged = 0
lnav_engaged = 0
thr1_anim = 0
thr2_anim = 0

ap_on = 0
ap_on_first = 0
at_on_first = 0
cws_on = 0
cws_on_first = 0
ap_disco_first = 0
ap_dis_time = 0
at_dis_time = 0

roll_mode_old = 0
pitch_mode_old = 0
at_on_old = 0
vnav_desc_spd = 0
vnav_desc_protect_spd = 0
ap_disco_do = 0
vnav_speed_trg_old = 0

fac_engaged = 0
loc_gp_engaged = 0

rest_wpt_alt_idx_old = 0

simDR_nav1_obs_pilot = math.floor(simDR_nav1_obs_pilot + 0.5)
simDR_nav2_obs_pilot = simDR_nav1_obs_pilot
B738DR_course_pilot = simDR_nav1_obs_pilot
simDR_nav1_obs_copilot = math.floor(simDR_nav1_obs_copilot + 0.5)
simDR_nav2_obs_copilot = simDR_nav1_obs_copilot
B738DR_course_copilot = simDR_nav1_obs_copilot
B738DR_mcp_hdg_dial = simDR_ap_capt_heading

at_status = 0

dh_timer = 0
dh_timer2 = 0

axis_throttle_old = 0
axis_throttle1_old = 0
axis_throttle2_old = 0
lock_throttle = 0
ap_disco2 = 0
turn_corr = 0
turn_active = 0
intdir_act = 0
master_light_block_act = 0
autopilot_side = 0

autothr_arm_pos = B738DR_autopilot_autothr_arm_pos

mcp_hdg_dial_old = B738DR_mcp_hdg_dial
hide_hdg_line = 0
hide_hdg_line_fo = 0
dspl_ctrl_pnl_old = 0
in_hpa_cnt = 0

airspeed_dial_kts_old = 0
B738DR_alt_hold_mem = 0
altitude_mode_old = 0

capt_exp_map_mode = 1
fo_exp_map_mode = 1
capt_vsd_map_mode = 0
fo_vsd_map_mode = 0
capt_exp_vor_app_mode = 1
fo_exp_vor_app_mode = 1

AP_airspeed = 0
AP_airspeed_mach = 0

B738DR_kp = 9.0		--10.5
B738DR_ki = 1.6		--1.8		--0.5
B738DR_kd = 1.0		--1.3		--1.5		--1.2
B738DR_kf = 60		--6.0
B738DR_bias = 6

--B738DR_test_test = 1.0
--B738DR_test_test2 = 2.0
--B738DR_test_test = 1.0




end

--function flight_crash() end

function before_physics()
	
	if B738DR_kill_glareshield == 0 then
		B738_nav_source_swap()
		autopilot_system_lights2()
	end

end

function after_physics()
	
	if B738DR_kill_glareshield == 0 then
		
		B738_ctr_exp_mode()
		B738_nav1_nav2_source()
		alt_updn_timer()
		crs1_updn_timer()
		crs2_updn_timer()
		baro_pilot_updn_timer()
		baro_copilot_updn_timer()
		B738_efis_baro()
		B738_ap_logic()
		B738_at_logic()
		B738_ap_takeoff()
		B738_ap_goaround()
		B738_ap_autoland()
		B738_ap_system()
		B738_lnav3()
		--B738_lnav2()
		--B738_gs()
		B738_vnav6()
		
		B738_alt_acq()
		
		B738_fac()
		B738_loc_gp()
		B738_gp()
		B738_lnav_vnav()
		B738_loc_vnav()
		B738_lvl_chg()
		B738_vs()

		--B738_alt_acq()
		B738_alt_hld()
		B738_app()
		B738_hdg()
		B738_vorloc()
		--B738_PFD_flash()
		B738_PFD_flash2()
		B738_bellow_400ft()
		B738_ap_at_disconnect()
		B738_n1()
		B738_lift_off()
		B738_on_ground()
		B738_goaround_block()
		B738_fd_show()
		B738_ias_alt_disagree()
		B738_vnav_active = vnav_active
		
		B738_afs_protect()
		B738_eng_n1_set()
		--B738_N1_thrust_manage2()
		--B738_N1_thrust_manage3()
		B738_N1_thrust_manage4()
		
		B738_draw_arc()
		B738_radio_height()
		--B738_baro_radio()
		B738_baro_radio2()
		ils_radio_pfd()
		B738_vor_sel()
		B738_efis()
		B738_flight_director()
		B738_hyd_sys()
		B738_bank_angle()
		at_on_old = B738DR_autopilot_autothr_arm_pos
		simDR_efis_sub_mode = 2
		simDR_efis_map_mode = 0
		B738_nd()
		B738_yoke()
		B738_spd_ratio()
		B738_eng_out()
		B738_ctrl_panel()
		altitude_mode_old = simDR_autopilot_altitude_mode
		
		--B738DR_mcp_hdg_dial_nd = B738DR_test_test
		--B738DR_data_test = 0
		--B738DR_test_test = spd_ratio
	end

 end

--function after_replay() end

--simDR_mag_hdg


--*************************************************************************************--
--** 				               SUB-MODULE PROCESSING       	        			 **--
--*************************************************************************************--

-- dofile("")



