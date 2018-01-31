

--*************************************************************************************--
--** 					               CONSTANTS                    				 **--
--*************************************************************************************--



--*************************************************************************************--
--** 					            GLOBAL VARIABLES                				 **--
--*************************************************************************************--

xtime = 0

-- AUTOPILOT
n1_butt_old = 0
speed_butt_old = 0
lvl_chg_butt_old = 0
vnav_butt_old = 0
lnav_butt_old = 0
vor_loc_butt_old = 0
app_butt_old = 0
hdg_sel_butt_old = 0
alt_hld_butt_old = 0
vs_butt_old = 0
cmd_a_butt_old = 0
cmd_b_butt_old = 0
cws_a_butt_old = 0
cws_b_butt_old = 0
co_butt_old = 0
disconnect_old = 0
fd_ca_old = 0
fd_fo_old = 0
at_arm_old = 0
at_arm_old_pos = 0
ap_disc_old = 0
ap_disc_old_pos = 0
bank_angle_old = 0
apu_start_old = 0
B738_apu_start_old = 0
spd_intv_butt_old = 0
alt_intv_butt_old = 0

landing_gear_old = 0

fmc_a_old = 0
fmc_b_old = 0
fmc_c_old = 0
fmc_d_old = 0
fmc_e_old = 0
fmc_f_old = 0
fmc_g_old = 0
fmc_h_old = 0
fmc_i_old = 0
fmc_j_old = 0
fmc_k_old = 0
fmc_l_old = 0
fmc_m_old = 0
fmc_n_old = 0
fmc_o_old = 0
fmc_p_old = 0
fmc_q_old = 0
fmc_r_old = 0
fmc_s_old = 0
fmc_t_old = 0
fmc_u_old = 0
fmc_v_old = 0
fmc_w_old = 0
fmc_x_old = 0
fmc_y_old = 0
fmc_z_old = 0
fmc_0_old = 0
fmc_1_old = 0
fmc_2_old = 0
fmc_3_old = 0
fmc_4_old = 0
fmc_5_old = 0
fmc_6_old = 0
fmc_7_old = 0
fmc_8_old = 0
fmc_9_old = 0
fmc_period_old = 0
fmc_minus_old = 0
fmc_slash_old = 0
fmc_sp_old = 0
fmc_clr_old = 0
fmc_del_old = 0
fmc_exec_old = 0
fmc_1L_old = 0
fmc_2L_old = 0
fmc_3L_old = 0
fmc_4L_old = 0
fmc_5L_old = 0
fmc_6L_old = 0
fmc_1R_old = 0
fmc_2R_old = 0
fmc_3R_old = 0
fmc_4R_old = 0
fmc_5R_old = 0
fmc_6R_old = 0
fmc_init_ref_old = 0
fmc_menu_old = 0
fmc_n1_limit_old = 0
fmc_rte_old = 0
fmc_legs_old = 0
fmc_fix_old = 0
fmc_clb_old = 0
fmc_crs_old = 0
fmc_des_old = 0
fmc_dep_arr_old = 0
fmc_hold_old = 0
fmc_prev_old = 0
fmc_next_old = 0
fmc_prog_old = 0

--*************************************************************************************--
--** 					            LOCAL VARIABLES                 				 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				             FIND X-PLANE DATAREFS            			    	 **--
--*************************************************************************************--

simDR_startup_running	= find_dataref("sim/operation/prefs/startup_running")

simDR_throttle_override			= find_dataref("sim/operation/override/override_throttles")
simDR_joy_pitch_override		= find_dataref("sim/operation/override/override_joystick_pitch")
simDR_fdir_pitch_ovr			= find_dataref("sim/operation/override/override_flightdir_ptch")
simDR_fdir_roll_ovr				= find_dataref("sim/operation/override/override_flightdir_roll")
simDR_fms_override 				= find_dataref("sim/operation/override/override_fms_advance")
simDR_toe_brakes_ovr			= find_dataref("sim/operation/override/override_toe_brakes")
simDR_steer_ovr					= find_dataref("sim/operation/override/override_wheel_steer")
simDR_override_heading			= find_dataref("sim/operation/override/override_joystick_heading")
simDR_override_pitch			= find_dataref("sim/operation/override/override_joystick_pitch")
simDR_override_roll				= find_dataref("sim/operation/override/override_joystick_roll")
simDR_kill_map_fms				= find_dataref("sim/graphics/misc/kill_map_fms_line")

simDR_gpu_on				= find_dataref("sim/cockpit/electrical/gpu_on")
--*************************************************************************************--
--** 				               FIND X-PLANE COMMANDS                   	    	 **--
--*************************************************************************************--

simCMD_gpu_on					= find_command("sim/electrical/GPU_on")
simCMD_generator_1_off			= find_command("sim/electrical/generator_1_off")
simCMD_generator_2_off			= find_command("sim/electrical/generator_2_off")






--*************************************************************************************--
--** 				              FIND CUSTOM DATAREFS             			    	 **--
--*************************************************************************************--

B738DR_autopilot_fd_pos				= find_dataref("laminar/B738/autopilot/flight_director_pos")
B738DR_autopilot_fd_fo_pos			= find_dataref("laminar/B738/autopilot/flight_director_fo_pos")
B738DR_autopilot_bank_angle_pos		= find_dataref("laminar/B738/autopilot/bank_angle_pos")
B738DR_autopilot_autothr_arm_pos	= find_dataref("laminar/B738/autopilot/autothrottle_arm_pos")
B738DR_autopilot_disconnect_pos		= find_dataref("laminar/B738/autopilot/disconnect_pos")
B738DR_gear_handle_pos				= find_dataref("laminar/B738/controls/gear_handle_down")

B738DR_apu_power_bus1				= find_dataref("laminar/B738/electrical/apu_power_bus1")
B738DR_apu_power_bus2				= find_dataref("laminar/B738/electrical/apu_power_bus2")

B738DR_engine_no_running_state 		= find_dataref("laminar/B738/fms/engine_no_running_state")

--*************************************************************************************--
--** 				              FIND CUSTOM COMMANDS              			     **--
--*************************************************************************************--

-- AUTOPILOT
B738CMD_autopilot_n1_press				= find_command("laminar/B738/autopilot/n1_press")
B738CMD_autopilot_speed_press			= find_command("laminar/B738/autopilot/speed_press")
B738CMD_autopilot_lvl_chg_press			= find_command("laminar/B738/autopilot/lvl_chg_press")
B738CMD_autopilot_vnav_press			= find_command("laminar/B738/autopilot/vnav_press")
B738CMD_autopilot_co_press				= find_command("laminar/B738/autopilot/change_over_press")

B738CMD_autopilot_lnav_press			= find_command("laminar/B738/autopilot/lnav_press")
B738CMD_autopilot_vorloc_press			= find_command("laminar/B738/autopilot/vorloc_press")
B738CMD_autopilot_app_press				= find_command("laminar/B738/autopilot/app_press")
B738CMD_autopilot_hdg_sel_press			= find_command("laminar/B738/autopilot/hdg_sel_press")

B738CMD_autopilot_alt_hld_press			= find_command("laminar/B738/autopilot/alt_hld_press")
B738CMD_autopilot_vs_press				= find_command("laminar/B738/autopilot/vs_press")

B738CMD_autopilot_disconnect_toggle		= find_command("laminar/B738/autopilot/disconnect_toggle")
B738CMD_autopilot_autothr_arm_toggle	= find_command("laminar/B738/autopilot/autothrottle_arm_toggle")
B738CMD_autopilot_flight_dir_toggle		= find_command("laminar/B738/autopilot/flight_director_toggle")
B738CMD_autopilot_flight_dir_fo_toggle	= find_command("laminar/B738/autopilot/flight_director_fo_toggle")
B738CMD_autopilot_bank_angle_up			= find_command("laminar/B738/autopilot/bank_angle_up")
B738CMD_autopilot_bank_angle_dn			= find_command("laminar/B738/autopilot/bank_angle_dn")

B738CMD_autopilot_cmd_a_press			= find_command("laminar/B738/autopilot/cmd_a_press")
B738CMD_autopilot_cmd_b_press			= find_command("laminar/B738/autopilot/cmd_b_press")

B738CMD_autopilot_cws_a_press			= find_command("laminar/B738/autopilot/cws_a_press")
B738CMD_autopilot_cws_b_press			= find_command("laminar/B738/autopilot/cws_b_press")

B738CMD_vhf_nav_source_switch_lft		= find_command("laminar/B738/toggle_switch/vhf_nav_source_lft")
B738CMD_vhf_nav_source_switch_rgt		= find_command("laminar/B738/toggle_switch/vhf_nav_source_rgt")

B738CMD_gear_down						= find_command("laminar/B738/push_button/gear_down")
B738CMD_gear_up							= find_command("laminar/B738/push_button/gear_up")
B738CMD_gear_off						= find_command("laminar/B738/push_button/gear_off")

B738CMD_apu_starter_switch_up	= find_command("laminar/B738/spring_toggle_switch/APU_start_pos_up")
B738CMD_apu_starter_switch_dn	= find_command("laminar/B738/spring_toggle_switch/APU_start_pos_dn")


B738CMD_autopilot_spd_interv			= find_command("laminar/B738/autopilot/spd_interv")
B738CMD_autopilot_alt_interv			= find_command("laminar/B738/autopilot/alt_interv")


B738CMD_fmc1_1L = find_command("laminar/B738/button/fmc1_1L")
B738CMD_fmc1_2L = find_command("laminar/B738/button/fmc1_2L")
B738CMD_fmc1_3L = find_command("laminar/B738/button/fmc1_3L")
B738CMD_fmc1_4L = find_command("laminar/B738/button/fmc1_4L")
B738CMD_fmc1_5L = find_command("laminar/B738/button/fmc1_5L")
B738CMD_fmc1_6L = find_command("laminar/B738/button/fmc1_6L")
B738CMD_fmc1_1R = find_command("laminar/B738/button/fmc1_1R")
B738CMD_fmc1_2R = find_command("laminar/B738/button/fmc1_2R")
B738CMD_fmc1_3R = find_command("laminar/B738/button/fmc1_3R")
B738CMD_fmc1_4R = find_command("laminar/B738/button/fmc1_4R")
B738CMD_fmc1_5R = find_command("laminar/B738/button/fmc1_5R")
B738CMD_fmc1_6R = find_command("laminar/B738/button/fmc1_6R")
B738CMD_fmc1_0 = find_command("laminar/B738/button/fmc1_0")
B738CMD_fmc1_1 = find_command("laminar/B738/button/fmc1_1")
B738CMD_fmc1_2 = find_command("laminar/B738/button/fmc1_2")
B738CMD_fmc1_3 = find_command("laminar/B738/button/fmc1_3")
B738CMD_fmc1_4 = find_command("laminar/B738/button/fmc1_4")
B738CMD_fmc1_5 = find_command("laminar/B738/button/fmc1_5")
B738CMD_fmc1_6 = find_command("laminar/B738/button/fmc1_6")
B738CMD_fmc1_7 = find_command("laminar/B738/button/fmc1_7")
B738CMD_fmc1_8 = find_command("laminar/B738/button/fmc1_8")
B738CMD_fmc1_9 = find_command("laminar/B738/button/fmc1_9")
B738CMD_fmc1_period = find_command("laminar/B738/button/fmc1_period")
B738CMD_fmc1_minus = find_command("laminar/B738/button/fmc1_minus")
B738CMD_fmc1_slash = find_command("laminar/B738/button/fmc1_slash")
B738CMD_fmc1_A = find_command("laminar/B738/button/fmc1_A")
B738CMD_fmc1_B = find_command("laminar/B738/button/fmc1_B")
B738CMD_fmc1_C = find_command("laminar/B738/button/fmc1_C")
B738CMD_fmc1_D = find_command("laminar/B738/button/fmc1_D")
B738CMD_fmc1_E = find_command("laminar/B738/button/fmc1_E")
B738CMD_fmc1_F = find_command("laminar/B738/button/fmc1_F")
B738CMD_fmc1_G = find_command("laminar/B738/button/fmc1_G")
B738CMD_fmc1_H = find_command("laminar/B738/button/fmc1_H")
B738CMD_fmc1_I = find_command("laminar/B738/button/fmc1_I")
B738CMD_fmc1_J = find_command("laminar/B738/button/fmc1_J")
B738CMD_fmc1_K = find_command("laminar/B738/button/fmc1_K")
B738CMD_fmc1_L = find_command("laminar/B738/button/fmc1_L")
B738CMD_fmc1_M = find_command("laminar/B738/button/fmc1_M")
B738CMD_fmc1_N = find_command("laminar/B738/button/fmc1_N")
B738CMD_fmc1_O = find_command("laminar/B738/button/fmc1_O")
B738CMD_fmc1_P = find_command("laminar/B738/button/fmc1_P")
B738CMD_fmc1_Q = find_command("laminar/B738/button/fmc1_Q")
B738CMD_fmc1_R = find_command("laminar/B738/button/fmc1_R")
B738CMD_fmc1_S = find_command("laminar/B738/button/fmc1_S")
B738CMD_fmc1_T = find_command("laminar/B738/button/fmc1_T")
B738CMD_fmc1_U = find_command("laminar/B738/button/fmc1_U")
B738CMD_fmc1_V = find_command("laminar/B738/button/fmc1_V")
B738CMD_fmc1_W = find_command("laminar/B738/button/fmc1_W")
B738CMD_fmc1_X = find_command("laminar/B738/button/fmc1_X")
B738CMD_fmc1_Y = find_command("laminar/B738/button/fmc1_Y")
B738CMD_fmc1_Z = find_command("laminar/B738/button/fmc1_Z")
B738CMD_fmc1_SP = find_command("laminar/B738/button/fmc1_SP")
B738CMD_fmc1_clr = find_command("laminar/B738/button/fmc1_clr")
B738CMD_fmc1_del = find_command("laminar/B738/button/fmc1_del")
B738CMD_fmc1_prev_page = find_command("laminar/B738/button/fmc1_prev_page")
B738CMD_fmc1_next_page = find_command("laminar/B738/button/fmc1_next_page")
B738CMD_fmc1_init_ref = find_command("laminar/B738/button/fmc1_init_ref")
B738CMD_fmc1_menu = find_command("laminar/B738/button/fmc1_menu")
B738CMD_fmc1_n1_lim = find_command("laminar/B738/button/fmc1_n1_lim")
B738CMD_fmc1_rte = find_command("laminar/B738/button/fmc1_rte")
B738CMD_fmc1_legs = find_command("laminar/B738/button/fmc1_legs")
B738CMD_fmc1_fix = find_command("laminar/B738/button/fmc1_fix")
B738CMD_fmc1_clb = find_command("laminar/B738/button/fmc1_clb")
B738CMD_fmc1_crz = find_command("laminar/B738/button/fmc1_crz")
B738CMD_fmc1_des = find_command("laminar/B738/button/fmc1_des")
B738CMD_fmc1_dep_arr = find_command("laminar/B738/button/fmc1_dep_app")
B738CMD_fmc1_hold = find_command("laminar/B738/button/fmc1_hold")
B738CMD_fmc1_prog = find_command("laminar/B738/button/fmc1_prog")
B738CMD_fmc1_exec = find_command("laminar/B738/button/fmc1_exec")

--*************************************************************************************--
--** 				        CREATE READ-ONLY CUSTOM DATAREFS               	         **--
--*************************************************************************************--



--*************************************************************************************--
--** 				       READ-WRITE CUSTOM DATAREF HANDLERS     	        	     **--
--*************************************************************************************--

function B738_n1_butt_DRhandler()end
function B738_speed_butt_DRhandler()end
function lvl_chg_butt_DRhandler()end
function B738_vnav_butt_DRhandler()end
function B738_lnav_butt_DRhandler()end
function B738_vor_loc_butt_DRhandler()end
function B738_app_butt_DRhandler()end
function B738_hdg_sel_butt_DRhandler()end
function B738_alt_hld_butt_DRhandler()end
function B738_vs_butt_DRhandler()end
function B738_cmd_a_butt_DRhandler()end
function B738_cmd_b_butt_DRhandler()end
function B738_cws_a_butt_DRhandler()end
function B738_cws_b_butt_DRhandler()end
function B738_co_butt_DRhandler()end

function B738_fd_ca_switch_DRhandler()end
function B738_fd_fo_switch_DRhandler()end
function B738_at_arm_switch_DRhandler()end
function B738_ap_disconnect_switch_DRhandler()end

function B738_bank_angle_rot_DRhandler()end

function B738_landing_gear_DRhandler()end
function B738_apu_start_DRhandler()end

function B738_spd_intv_butt_DRhandler()end
function B738_alt_intv_butt_DRhandler()end


function B738_fmc_a_DRhandler() end
function B738_fmc_b_DRhandler() end
function B738_fmc_c_DRhandler() end
function B738_fmc_d_DRhandler() end
function B738_fmc_e_DRhandler() end
function B738_fmc_f_DRhandler() end
function B738_fmc_g_DRhandler() end
function B738_fmc_h_DRhandler() end
function B738_fmc_i_DRhandler() end
function B738_fmc_j_DRhandler() end
function B738_fmc_k_DRhandler() end
function B738_fmc_l_DRhandler() end
function B738_fmc_m_DRhandler() end
function B738_fmc_n_DRhandler() end
function B738_fmc_o_DRhandler() end
function B738_fmc_p_DRhandler() end
function B738_fmc_q_DRhandler() end
function B738_fmc_r_DRhandler() end
function B738_fmc_s_DRhandler() end
function B738_fmc_t_DRhandler() end
function B738_fmc_u_DRhandler() end
function B738_fmc_v_DRhandler() end
function B738_fmc_w_DRhandler() end
function B738_fmc_x_DRhandler() end
function B738_fmc_y_DRhandler() end
function B738_fmc_z_DRhandler() end
function B738_fmc_0_DRhandler() end
function B738_fmc_1_DRhandler() end
function B738_fmc_2_DRhandler() end
function B738_fmc_3_DRhandler() end
function B738_fmc_4_DRhandler() end
function B738_fmc_5_DRhandler() end
function B738_fmc_6_DRhandler() end
function B738_fmc_7_DRhandler() end
function B738_fmc_8_DRhandler() end
function B738_fmc_9_DRhandler() end
function B738_fmc_slash_DRhandler() end
function B738_fmc_minus_DRhandler() end
function B738_fmc_sp_DRhandler() end
function B738_fmc_clr_DRhandler() end
function B738_fmc_del_DRhandler() end
function B738_fmc_exec_DRhandler() end
function B738_fmc_1L_DRhandler() end
function B738_fmc_2L_DRhandler() end
function B738_fmc_3L_DRhandler() end
function B738_fmc_4L_DRhandler() end
function B738_fmc_5L_DRhandler() end
function B738_fmc_6L_DRhandler() end
function B738_fmc_1R_DRhandler() end
function B738_fmc_2R_DRhandler() end
function B738_fmc_3R_DRhandler() end
function B738_fmc_4R_DRhandler() end
function B738_fmc_5R_DRhandler() end
function B738_fmc_6R_DRhandler() end
function B738_fmc_init_ref_DRhandler() end
function B738_fmc_menu_DRhandler() end
function B738_fmc_n1_limit_DRhandler() end
function B738_fmc_rte_DRhandler() end
function B738_fmc_1egs_DRhandler() end
function B738_fmc_fix_DRhandler() end
function B738_fmc_clb_DRhandler() end
function B738_fmc_crz_DRhandler() end
function B738_fmc_des_DRhandler() end
function B738_fmc_dep_arr_DRhandler() end
function B738_fmc_hold_DRhandler() end
function B738_fmc_prev_DRhandler() end
function B738_fmc_next_DRhandler() end
function B738_fmc_prog_DRhandler() end

--*************************************************************************************--
--** 				       CREATE READ-WRITE CUSTOM DATAREFS                         **--
--*************************************************************************************--

-- AUTOPILOT buttons
B738_n1_butt			= create_dataref("laminar/B738/buttons/autopilot/n1", "number", B738_n1_butt_DRhandler)
B738_speed_butt			= create_dataref("laminar/B738/buttons/autopilot/speed", "number", B738_speed_butt_DRhandler)
B738_lvl_chg_butt		= create_dataref("laminar/B738/buttons/autopilot/lvl_chg", "number", lvl_chg_butt_DRhandler)
B738_vnav_butt			= create_dataref("laminar/B738/buttons/autopilot/vnav", "number", B738_vnav_butt_DRhandler)
B738_lnav_butt			= create_dataref("laminar/B738/buttons/autopilot/lnav", "number", B738_lnav_butt_DRhandler)
B738_vor_loc_butt		= create_dataref("laminar/B738/buttons/autopilot/vor_loc", "number", B738_vor_loc_butt_DRhandler)
B738_app_butt			= create_dataref("laminar/B738/buttons/autopilot/app", "number", B738_app_butt_DRhandler)
B738_hdg_sel_butt		= create_dataref("laminar/B738/buttons/autopilot/hdg_sel", "number", B738_hdg_sel_butt_DRhandler)
B738_alt_hld_butt		= create_dataref("laminar/B738/buttons/autopilot/alt_hld", "number", B738_alt_hld_butt_DRhandler)
B738_vs_butt			= create_dataref("laminar/B738/buttons/autopilot/vs", "number", B738_vs_butt_DRhandler)
B738_cmd_a_butt			= create_dataref("laminar/B738/buttons/autopilot/cmd_a", "number", B738_cmd_a_butt_DRhandler)
B738_cmd_b_butt			= create_dataref("laminar/B738/buttons/autopilot/cmd_b", "number", B738_cmd_b_butt_DRhandler)
B738_cws_a_butt			= create_dataref("laminar/B738/buttons/autopilot/cws_a", "number", B738_cws_a_butt_DRhandler)
B738_cws_b_butt			= create_dataref("laminar/B738/buttons/autopilot/cws_b", "number", B738_cws_b_butt_DRhandler)
B738_co_butt			= create_dataref("laminar/B738/buttons/autopilot/co", "number", B738_co_butt_DRhandler)
B738_spd_intv_butt		= create_dataref("laminar/B738/buttons/autopilot/spd_intv", "number", B738_spd_intv_butt_DRhandler)
B738_alt_intv_butt		= create_dataref("laminar/B738/buttons/autopilot/alt_intv", "number", B738_alt_intv_butt_DRhandler)

-- AUTOPILOT switches
B738_fd_ca_switch	= create_dataref("laminar/B738/switches/autopilot/fd_ca", "number", B738_fd_ca_switch_DRhandler)
B738_fd_fo_switch	= create_dataref("laminar/B738/switches/autopilot/fd_fo", "number", B738_fd_fo_switch_DRhandler)
-- AUTOPILOT switches with auto-off
B738_at_arm_switch			= create_dataref("laminar/B738/switches/autopilot/at_arm", "number", B738_at_arm_switch_DRhandler)
B738_ap_disconnect_switch	= create_dataref("laminar/B738/switches/autopilot/ap_disconnect", "number", B738_ap_disconnect_switch_DRhandler)
-- AUTOPILOT rotary
B738_bank_angle_rot		= create_dataref("laminar/B738/rotary/autopilot/bank_angle", "number", B738_bank_angle_rot_DRhandler)

-- OTHERS
B738_landing_gear		= create_dataref("laminar/B738/switches/landing_gear", "number", B738_landing_gear_DRhandler)
B738_apu_start			= create_dataref("laminar/B738/switches/apu_start", "number", B738_apu_start_DRhandler)

-- CAPTAIN FMC
B738_fmc_a				= create_dataref("laminar/B738/buttons/fmc/capt/a", "number", B738_fmc_a_DRhandler)
B738_fmc_b				= create_dataref("laminar/B738/buttons/fmc/capt/b", "number", B738_fmc_b_DRhandler)
B738_fmc_c				= create_dataref("laminar/B738/buttons/fmc/capt/c", "number", B738_fmc_c_DRhandler)
B738_fmc_d				= create_dataref("laminar/B738/buttons/fmc/capt/d", "number", B738_fmc_d_DRhandler)
B738_fmc_e				= create_dataref("laminar/B738/buttons/fmc/capt/e", "number", B738_fmc_e_DRhandler)
B738_fmc_f				= create_dataref("laminar/B738/buttons/fmc/capt/f", "number", B738_fmc_f_DRhandler)
B738_fmc_g				= create_dataref("laminar/B738/buttons/fmc/capt/g", "number", B738_fmc_g_DRhandler)
B738_fmc_h				= create_dataref("laminar/B738/buttons/fmc/capt/h", "number", B738_fmc_h_DRhandler)
B738_fmc_i				= create_dataref("laminar/B738/buttons/fmc/capt/i", "number", B738_fmc_i_DRhandler)
B738_fmc_j				= create_dataref("laminar/B738/buttons/fmc/capt/j", "number", B738_fmc_j_DRhandler)
B738_fmc_k				= create_dataref("laminar/B738/buttons/fmc/capt/k", "number", B738_fmc_k_DRhandler)
B738_fmc_l				= create_dataref("laminar/B738/buttons/fmc/capt/l", "number", B738_fmc_l_DRhandler)
B738_fmc_m				= create_dataref("laminar/B738/buttons/fmc/capt/m", "number", B738_fmc_m_DRhandler)
B738_fmc_n				= create_dataref("laminar/B738/buttons/fmc/capt/n", "number", B738_fmc_n_DRhandler)
B738_fmc_o				= create_dataref("laminar/B738/buttons/fmc/capt/o", "number", B738_fmc_o_DRhandler)
B738_fmc_p				= create_dataref("laminar/B738/buttons/fmc/capt/p", "number", B738_fmc_p_DRhandler)
B738_fmc_q				= create_dataref("laminar/B738/buttons/fmc/capt/q", "number", B738_fmc_q_DRhandler)
B738_fmc_r				= create_dataref("laminar/B738/buttons/fmc/capt/r", "number", B738_fmc_r_DRhandler)
B738_fmc_s				= create_dataref("laminar/B738/buttons/fmc/capt/s", "number", B738_fmc_s_DRhandler)
B738_fmc_t				= create_dataref("laminar/B738/buttons/fmc/capt/t", "number", B738_fmc_t_DRhandler)
B738_fmc_u				= create_dataref("laminar/B738/buttons/fmc/capt/u", "number", B738_fmc_u_DRhandler)
B738_fmc_v				= create_dataref("laminar/B738/buttons/fmc/capt/v", "number", B738_fmc_v_DRhandler)
B738_fmc_w				= create_dataref("laminar/B738/buttons/fmc/capt/w", "number", B738_fmc_w_DRhandler)
B738_fmc_x				= create_dataref("laminar/B738/buttons/fmc/capt/x", "number", B738_fmc_x_DRhandler)
B738_fmc_y				= create_dataref("laminar/B738/buttons/fmc/capt/y", "number", B738_fmc_y_DRhandler)
B738_fmc_z				= create_dataref("laminar/B738/buttons/fmc/capt/z", "number", B738_fmc_z_DRhandler)
B738_fmc_0				= create_dataref("laminar/B738/buttons/fmc/capt/0", "number", B738_fmc_0_DRhandler)
B738_fmc_1				= create_dataref("laminar/B738/buttons/fmc/capt/1", "number", B738_fmc_1_DRhandler)
B738_fmc_2				= create_dataref("laminar/B738/buttons/fmc/capt/2", "number", B738_fmc_2_DRhandler)
B738_fmc_3				= create_dataref("laminar/B738/buttons/fmc/capt/3", "number", B738_fmc_3_DRhandler)
B738_fmc_4				= create_dataref("laminar/B738/buttons/fmc/capt/4", "number", B738_fmc_4_DRhandler)
B738_fmc_5				= create_dataref("laminar/B738/buttons/fmc/capt/5", "number", B738_fmc_5_DRhandler)
B738_fmc_6				= create_dataref("laminar/B738/buttons/fmc/capt/6", "number", B738_fmc_6_DRhandler)
B738_fmc_7				= create_dataref("laminar/B738/buttons/fmc/capt/7", "number", B738_fmc_7_DRhandler)
B738_fmc_8				= create_dataref("laminar/B738/buttons/fmc/capt/8", "number", B738_fmc_8_DRhandler)
B738_fmc_9				= create_dataref("laminar/B738/buttons/fmc/capt/9", "number", B738_fmc_9_DRhandler)
B738_fmc_slash			= create_dataref("laminar/B738/buttons/fmc/capt/slash", "number", B738_fmc_slash_DRhandler)
B738_fmc_minus			= create_dataref("laminar/B738/buttons/fmc/capt/minus", "number", B738_fmc_minus_DRhandler)
B738_fmc_period			= create_dataref("laminar/B738/buttons/fmc/capt/period", "number", B738_fmc_minus_DRhandler)
B738_fmc_sp				= create_dataref("laminar/B738/buttons/fmc/capt/sp", "number", B738_fmc_sp_DRhandler)
B738_fmc_clr			= create_dataref("laminar/B738/buttons/fmc/capt/clr", "number", B738_fmc_clr_DRhandler)
B738_fmc_del			= create_dataref("laminar/B738/buttons/fmc/capt/del", "number", B738_fmc_del_DRhandler)
B738_fmc_exec			= create_dataref("laminar/B738/buttons/fmc/capt/exec", "number", B738_fmc_exec_DRhandler)
B738_fmc_1L				= create_dataref("laminar/B738/buttons/fmc/capt/1L", "number", B738_fmc_1L_DRhandler)
B738_fmc_2L				= create_dataref("laminar/B738/buttons/fmc/capt/2L", "number", B738_fmc_2L_DRhandler)
B738_fmc_3L				= create_dataref("laminar/B738/buttons/fmc/capt/3L", "number", B738_fmc_3L_DRhandler)
B738_fmc_4L				= create_dataref("laminar/B738/buttons/fmc/capt/4L", "number", B738_fmc_4L_DRhandler)
B738_fmc_5L				= create_dataref("laminar/B738/buttons/fmc/capt/5L", "number", B738_fmc_5L_DRhandler)
B738_fmc_6L				= create_dataref("laminar/B738/buttons/fmc/capt/6L", "number", B738_fmc_6L_DRhandler)
B738_fmc_1R				= create_dataref("laminar/B738/buttons/fmc/capt/1R", "number", B738_fmc_1R_DRhandler)
B738_fmc_2R				= create_dataref("laminar/B738/buttons/fmc/capt/2R", "number", B738_fmc_2R_DRhandler)
B738_fmc_3R				= create_dataref("laminar/B738/buttons/fmc/capt/3R", "number", B738_fmc_3R_DRhandler)
B738_fmc_4R				= create_dataref("laminar/B738/buttons/fmc/capt/4R", "number", B738_fmc_4R_DRhandler)
B738_fmc_5R				= create_dataref("laminar/B738/buttons/fmc/capt/5R", "number", B738_fmc_5R_DRhandler)
B738_fmc_6R				= create_dataref("laminar/B738/buttons/fmc/capt/6R", "number", B738_fmc_6R_DRhandler)
B738_fmc_init_ref		= create_dataref("laminar/B738/buttons/fmc/capt/init_ref", "number", B738_fmc_init_ref_DRhandler)
B738_fmc_menu			= create_dataref("laminar/B738/buttons/fmc/capt/menu", "number", B738_fmc_menu_DRhandler)
B738_fmc_n1_limit		= create_dataref("laminar/B738/buttons/fmc/capt/n1_limit", "number", B738_fmc_n1_limit_DRhandler)
B738_fmc_rte			= create_dataref("laminar/B738/buttons/fmc/capt/rte", "number", B738_fmc_rte_DRhandler)
B738_fmc_legs			= create_dataref("laminar/B738/buttons/fmc/capt/legs", "number", B738_fmc_1egs_DRhandler)
B738_fmc_fix			= create_dataref("laminar/B738/buttons/fmc/capt/fix", "number", B738_fmc_fix_DRhandler)
B738_fmc_clb			= create_dataref("laminar/B738/buttons/fmc/capt/clb", "number", B738_fmc_clb_DRhandler)
B738_fmc_crs			= create_dataref("laminar/B738/buttons/fmc/capt/crz", "number", B738_fmc_crz_DRhandler)
B738_fmc_des			= create_dataref("laminar/B738/buttons/fmc/capt/des", "number", B738_fmc_des_DRhandler)
B738_fmc_dep_arr		= create_dataref("laminar/B738/buttons/fmc/capt/dep_arr", "number", B738_fmc_dep_arr_DRhandler)
B738_fmc_hold			= create_dataref("laminar/B738/buttons/fmc/capt/hold", "number", B738_fmc_hold_DRhandler)
B738_fmc_prev			= create_dataref("laminar/B738/buttons/fmc/capt/prev", "number", B738_fmc_prev_DRhandler)
B738_fmc_next			= create_dataref("laminar/B738/buttons/fmc/capt/next", "number", B738_fmc_next_DRhandler)
B738_fmc_prog			= create_dataref("laminar/B738/buttons/fmc/capt/prog", "number", B738_fmc_prog_DRhandler)

--*************************************************************************************--
--** 				             CUSTOM COMMAND HANDLERS            			     **--
--*************************************************************************************--


			
--*************************************************************************************--
--** 				              CREATE CUSTOM COMMANDS              			     **--
--*************************************************************************************--



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



--*************************************************************************************--
--** 				               XLUA EVENT CALLBACKS       	        			 **--
--*************************************************************************************--


-- AUTOPILOT buttons

function B738_ap_buttons()

	-- N1
	if B738_n1_butt ~= n1_butt_old
	and B738_n1_butt == 1 then
		B738CMD_autopilot_n1_press:once()
	end
	n1_butt_old = B738_n1_butt
	
	-- SPEED
	if B738_speed_butt ~= speed_butt_old 
	and B738_speed_butt == 1 then
		B738CMD_autopilot_speed_press:once()
	end
	speed_butt_old = B738_speed_butt
	
	-- LVL CHG
	if B738_lvl_chg_butt ~= lvl_chg_butt_old 
	and B738_lvl_chg_butt == 1 then
		B738CMD_autopilot_lvl_chg_press:once()
	end
	lvl_chg_butt_old = B738_lvl_chg_butt
	
	-- VNAV
	if B738_vnav_butt ~= vnav_butt_old 
	and B738_vnav_butt == 1 then
		B738CMD_autopilot_vnav_press:once()
	end
	vnav_butt_old = B738_vnav_butt
	
	-- LNAV
	if B738_lnav_butt ~= lnav_butt_old 
	and B738_lnav_butt == 1 then
		B738CMD_autopilot_lnav_press:once()
	end
	lnav_butt_old = B738_lnav_butt
	
	-- VOR LOC
	if B738_vor_loc_butt ~= vor_loc_butt_old 
	and B738_vor_loc_butt == 1 then
		B738CMD_autopilot_vorloc_press:once()
	end
	vor_loc_butt_old = B738_vor_loc_butt
	
	-- APP
	if B738_app_butt ~= app_butt_old 
	and B738_app_butt == 1 then
		B738CMD_autopilot_app_press:once()
	end
	app_butt_old = B738_app_butt
	
	-- HDG SEL
	if B738_hdg_sel_butt ~= hdg_sel_butt_old 
	and B738_hdg_sel_butt == 1 then
		B738CMD_autopilot_hdg_sel_press:once()
	end
	hdg_sel_butt_old = B738_hdg_sel_butt
	
	-- ALT HLD
	if B738_alt_hld_butt ~= alt_hld_butt_old 
	and B738_alt_hld_butt == 1 then
		B738CMD_autopilot_alt_hld_press:once()
	end
	alt_hld_butt_old = B738_alt_hld_butt
	
	-- VS
	if B738_vs_butt ~= vs_butt_old 
	and B738_vs_butt == 1 then
		B738CMD_autopilot_vs_press:once()
	end
	vs_butt_old = B738_vs_butt
	
	-- CMD a
	if B738_cmd_a_butt ~= cmd_a_butt_old 
	and B738_cmd_a_butt == 1 then
		B738CMD_autopilot_cmd_a_press:once()
	end
	cmd_a_butt_old = B738_cmd_a_butt
	
	-- CND b
	if B738_cmd_b_butt ~= cmd_b_butt_old 
	and B738_cmd_b_butt == 1 then
		B738CMD_autopilot_cmd_b_press:once()
	end
	cmd_b_butt_old = B738_cmd_b_butt
	
	-- CWS a
	if B738_cws_a_butt ~= cws_a_butt_old 
	and B738_cws_a_butt == 1 then
		B738CMD_autopilot_cws_a_press:once()
	end
	cws_a_butt_old = B738_cws_a_butt
	
	-- CWS b
	if B738_cws_b_butt ~= cws_b_butt_old 
	and B738_cws_b_butt == 1 then
		B738CMD_autopilot_cws_b_press:once()
	end
	cws_b_butt_old = B738_cws_b_butt
	
	-- C/O crossover altitude
	if B738_co_butt ~= co_butt_old 
	and B738_co_butt == 1 then
		B738CMD_autopilot_co_press:once()
	end
	co_butt_old = B738_co_butt
	
	-- FLIGHT DIRECTOR CAPTAIN
	if fd_ca_old ~= B738_fd_ca_switch then
		if B738DR_autopilot_fd_pos ~= B738_fd_ca_switch then
			B738CMD_autopilot_flight_dir_toggle:once()
		end
	end
	fd_ca_old = B738_fd_ca_switch
	
	-- FLIGHT DIRECTOR OFFICER
	if fd_fo_old ~= B738_fd_fo_switch then
		if B738DR_autopilot_fd_fo_pos ~= B738_fd_fo_switch then
			B738CMD_autopilot_flight_dir_fo_toggle:once()
		end
	end
	fd_fo_old = B738_fd_fo_switch
	
	-- BANK ANGLE
	if bank_angle_old ~= B738_bank_angle_rot then
		if B738_bank_angle_rot ~= B738DR_autopilot_bank_angle_pos then
			B738DR_autopilot_bank_angle_pos = B738_bank_angle_rot
		end
	end
	bank_angle_old = B738_bank_angle_rot
	
	-- AUTOTHROTTLE ARM
	if at_arm_old ~= B738_at_arm_switch then
		if B738_at_arm_switch ~= B738DR_autopilot_autothr_arm_pos then
			if B738_at_arm_switch == 0 then
				B738CMD_autopilot_autothr_arm_toggle:once()
			else
				if at_arm_old_pos == 0  then	-- not auto disconnect
					B738CMD_autopilot_autothr_arm_toggle:once()
				end
			end
		else
			at_arm_old_pos = B738DR_autopilot_autothr_arm_pos
		end
	end
	at_arm_old = B738_at_arm_switch
	
	-- AUTOPILOT DISCONNECT
	if ap_disc_old ~= B738_ap_disconnect_switch then
		if B738_ap_disconnect_switch ~= B738DR_autopilot_disconnect_pos then
			if B738_ap_disconnect_switch == 1 then
				B738CMD_autopilot_disconnect_toggle:once()
			else
				if ap_disc_old_pos == 1  then	-- not auto disconnect
					B738CMD_autopilot_disconnect_toggle:once()
				end
			end
		else
			ap_disc_old_pos = B738DR_autopilot_disconnect_pos
		end
	end
	ap_disc_old = B738_ap_disconnect_switch
	
	-- SPEED INTERVENTION
	if B738_spd_intv_butt ~= spd_intv_butt_old
	and B738_spd_intv_butt == 1 then
		B738CMD_autopilot_spd_interv:once()
	end
	spd_intv_butt_old = B738_spd_intv_butt
	
	-- ALT INTERVENTION
	if B738_alt_intv_butt ~= alt_intv_butt_old
	and B738_alt_intv_butt == 1 then
		B738CMD_autopilot_alt_interv:once()
	end
	alt_intv_butt_old = B738_alt_intv_butt
	
end

function B738_land_gear()

	if B738_landing_gear ~= landing_gear_old then
		if B738_landing_gear == 0 then
			if B738DR_gear_handle_pos ~= 0 then
				B738CMD_gear_up:once()
			end
		elseif B738_landing_gear == 1 then
			if B738DR_gear_handle_pos ~= 0.5 then
				B738CMD_gear_off:once()
			end
		elseif B738_landing_gear == 2 then
			if B738DR_gear_handle_pos ~= 1 then
				B738CMD_gear_down:once()
			end
		end
	end
	landing_gear_old = B738_landing_gear

end

function B738_apu_start_stop()

	if B738_apu_start_old ~= B738_apu_start then
		if B738_apu_start_old == 0 then
			if B738_apu_start == 1 then
				B738CMD_apu_starter_switch_up:once()
			elseif B738_apu_start == 2 then
				B738CMD_apu_starter_switch_up:once()
				B738CMD_apu_starter_switch_up:once()
			end
		elseif B738_apu_start_old == 1 then
			if B738_apu_start == 0 then
				B738CMD_apu_starter_switch_dn:once()
			elseif B738_apu_start == 2 then
				B738CMD_apu_starter_switch_up:once()
			end
		elseif B738_apu_start_old == 2 then
			if B738_apu_start == 1 then
				B738CMD_apu_starter_switch_dn:once()
			elseif B738_apu_start == 0 then
				B738CMD_apu_starter_switch_dn:once()
				B738CMD_apu_starter_switch_dn:once()
			end
		end
		B738_apu_start_old = B738_apu_start
	end

end

function B738_fmc_buttons()
	
	if fmc_a_old ~= B738_fmc_a and B738_fmc_a == 1 then
		B738CMD_fmc1_A:once()
	end
	fmc_a_old = B738_fmc_a
	
	if fmc_b_old ~= B738_fmc_b and B738_fmc_b == 1 then
		B738CMD_fmc1_B:once()
	end
	fmc_b_old = B738_fmc_b
	
	if fmc_c_old ~= B738_fmc_c and B738_fmc_c == 1 then
		B738CMD_fmc1_C:once()
	end
	fmc_c_old = B738_fmc_c
	
	if fmc_d_old ~= B738_fmc_d and B738_fmc_d == 1 then
		B738CMD_fmc1_D:once()
	end
	fmc_d_old = B738_fmc_d
	
	if fmc_e_old ~= B738_fmc_e and B738_fmc_e == 1 then
		B738CMD_fmc1_E:once()
	end
	fmc_e_old = B738_fmc_e
	
	if fmc_f_old ~= B738_fmc_f and B738_fmc_f == 1 then
		B738CMD_fmc1_F:once()
	end
	fmc_f_old = B738_fmc_f
	
	if fmc_g_old ~= B738_fmc_g and B738_fmc_g == 1 then
		B738CMD_fmc1_G:once()
	end
	fmc_g_old = B738_fmc_g
	
	if fmc_h_old ~= B738_fmc_h and B738_fmc_h == 1 then
		B738CMD_fmc1_H:once()
	end
	fmc_h_old = B738_fmc_h
	
	if fmc_i_old ~= B738_fmc_i and B738_fmc_i == 1 then
		B738CMD_fmc1_I:once()
	end
	fmc_i_old = B738_fmc_i
	
	if fmc_j_old ~= B738_fmc_j and B738_fmc_j == 1 then
		B738CMD_fmc1_J:once()
	end
	fmc_j_old = B738_fmc_j
	
	if fmc_k_old ~= B738_fmc_k and B738_fmc_k == 1 then
		B738CMD_fmc1_K:once()
	end
	fmc_k_old = B738_fmc_k
	
	if fmc_l_old ~= B738_fmc_l and B738_fmc_l == 1 then
		B738CMD_fmc1_L:once()
	end
	fmc_l_old = B738_fmc_l
	
	if fmc_m_old ~= B738_fmc_m and B738_fmc_m == 1 then
		B738CMD_fmc1_M:once()
	end
	fmc_m_old = B738_fmc_m
	
	if fmc_n_old ~= B738_fmc_n and B738_fmc_n == 1 then
		B738CMD_fmc1_N:once()
	end
	fmc_n_old = B738_fmc_n
	
	if fmc_o_old ~= B738_fmc_o and B738_fmc_o == 1 then
		B738CMD_fmc1_O:once()
	end
	fmc_o_old = B738_fmc_o
	
	if fmc_p_old ~= B738_fmc_p and B738_fmc_p == 1 then
		B738CMD_fmc1_P:once()
	end
	fmc_p_old = B738_fmc_p
	
	if fmc_q_old ~= B738_fmc_q and B738_fmc_q == 1 then
		B738CMD_fmc1_Q:once()
	end
	fmc_q_old = B738_fmc_q
	
	if fmc_r_old ~= B738_fmc_r and B738_fmc_r == 1 then
		B738CMD_fmc1_R:once()
	end
	fmc_r_old = B738_fmc_r
	
	if fmc_s_old ~= B738_fmc_s and B738_fmc_s == 1 then
		B738CMD_fmc1_S:once()
	end
	fmc_s_old = B738_fmc_s
	
	if fmc_t_old ~= B738_fmc_t and B738_fmc_t == 1 then
		B738CMD_fmc1_T:once()
	end
	fmc_t_old = B738_fmc_t
	
	if fmc_u_old ~= B738_fmc_u and B738_fmc_u == 1 then
		B738CMD_fmc1_U:once()
	end
	fmc_u_old = B738_fmc_u
	
	if fmc_v_old ~= B738_fmc_v and B738_fmc_v == 1 then
		B738CMD_fmc1_V:once()
	end
	fmc_v_old = B738_fmc_v
	
	if fmc_w_old ~= B738_fmc_w and B738_fmc_w == 1 then
		B738CMD_fmc1_W:once()
	end
	fmc_w_old = B738_fmc_w
	
	if fmc_x_old ~= B738_fmc_x and B738_fmc_x == 1 then
		B738CMD_fmc1_X:once()
	end
	fmc_x_old = B738_fmc_x
	
	if fmc_y_old ~= B738_fmc_y and B738_fmc_y == 1 then
		B738CMD_fmc1_Y:once()
	end
	fmc_y_old = B738_fmc_y
	
	if fmc_z_old ~= B738_fmc_z and B738_fmc_z == 1 then
		B738CMD_fmc1_Z:once()
	end
	fmc_z_old = B738_fmc_z
	
	if fmc_0_old ~= B738_fmc_0 and B738_fmc_0 == 1 then
		B738CMD_fmc1_0:once()
	end
	fmc_0_old = B738_fmc_0
	
	if fmc_1_old ~= B738_fmc_1 and B738_fmc_1 == 1 then
		B738CMD_fmc1_1:once()
	end
	fmc_1_old = B738_fmc_1
	
	if fmc_2_old ~= B738_fmc_2 and B738_fmc_2 == 1 then
		B738CMD_fmc1_2:once()
	end
	fmc_2_old = B738_fmc_2
	
	if fmc_3_old ~= B738_fmc_3 and B738_fmc_3 == 1 then
		B738CMD_fmc1_3:once()
	end
	fmc_3_old = B738_fmc_3
	
	if fmc_4_old ~= B738_fmc_4 and B738_fmc_4 == 1 then
		B738CMD_fmc1_4:once()
	end
	fmc_4_old = B738_fmc_4
	
	if fmc_5_old ~= B738_fmc_5 and B738_fmc_5 == 1 then
		B738CMD_fmc1_5:once()
	end
	fmc_5_old = B738_fmc_5
	
	if fmc_6_old ~= B738_fmc_6 and B738_fmc_6 == 1 then
		B738CMD_fmc1_6:once()
	end
	fmc_6_old = B738_fmc_6
	
	if fmc_7_old ~= B738_fmc_7 and B738_fmc_7 == 1 then
		B738CMD_fmc1_7:once()
	end
	fmc_7_old = B738_fmc_7
	
	if fmc_8_old ~= B738_fmc_8 and B738_fmc_8 == 1 then
		B738CMD_fmc1_8:once()
	end
	fmc_8_old = B738_fmc_8
	
	if fmc_9_old ~= B738_fmc_9 and B738_fmc_9 == 1 then
		B738CMD_fmc1_9:once()
	end
	fmc_9_old = B738_fmc_9
	
	if fmc_period_old ~= B738_fmc_period and B738_fmc_period == 1 then
		B738CMD_fmc1_period:once()
	end
	fmc_period_old = B738_fmc_period
	
	if fmc_minus_old ~= B738_fmc_minus and B738_fmc_minus == 1 then
		B738CMD_fmc1_minus:once()
	end
	fmc_minus_old = B738_fmc_minus
	
	if fmc_slash_old ~= B738_fmc_slash and B738_fmc_slash == 1 then
		B738CMD_fmc1_slash:once()
	end
	fmc_slash_old = B738_fmc_slash
	
	if fmc_sp_old ~= B738_fmc_sp and B738_fmc_sp == 1 then
		B738CMD_fmc1_SP:once()
	end
	fmc_sp_old = B738_fmc_sp
	
	if fmc_clr_old ~= B738_fmc_clr and B738_fmc_clr == 1 then
		B738CMD_fmc1_clr:once()
	end
	fmc_clr_old = B738_fmc_clr
	
	if fmc_del_old ~= B738_fmc_del and B738_fmc_del == 1 then
		B738CMD_fmc1_del:once()
	end
	fmc_del_old = B738_fmc_del
	
	if fmc_exec_old ~= B738_fmc_exec and B738_fmc_exec == 1 then
		B738CMD_fmc1_exec:once()
	end
	fmc_exec_old = B738_fmc_exec
	
	if fmc_1L_old ~= B738_fmc_1L and B738_fmc_1L == 1 then
		B738CMD_fmc1_1L:once()
	end
	fmc_1L_old = B738_fmc_1L
	
	if fmc_2L_old ~= B738_fmc_2L and B738_fmc_2L == 1 then
		B738CMD_fmc1_2L:once()
	end
	fmc_2L_old = B738_fmc_2L
	
	if fmc_3L_old ~= B738_fmc_3L and B738_fmc_3L == 1 then
		B738CMD_fmc1_3L:once()
	end
	fmc_3L_old = B738_fmc_3L
	
	if fmc_4L_old ~= B738_fmc_4L and B738_fmc_4L == 1 then
		B738CMD_fmc1_4L:once()
	end
	fmc_4L_old = B738_fmc_4L
	
	if fmc_5L_old ~= B738_fmc_5L and B738_fmc_5L == 1 then
		B738CMD_fmc1_5L:once()
	end
	fmc_5L_old = B738_fmc_5L
	
	if fmc_6L_old ~= B738_fmc_6L and B738_fmc_6L == 1 then
		B738CMD_fmc1_6L:once()
	end
	fmc_6L_old = B738_fmc_6L
	
	if fmc_1R_old ~= B738_fmc_1R and B738_fmc_1R == 1 then
		B738CMD_fmc1_1R:once()
	end
	fmc_1R_old = B738_fmc_1R
	
	if fmc_2R_old ~= B738_fmc_2R and B738_fmc_2R == 1 then
		B738CMD_fmc1_2R:once()
	end
	fmc_2R_old = B738_fmc_2R
	
	if fmc_3R_old ~= B738_fmc_3R and B738_fmc_3R == 1 then
		B738CMD_fmc1_3R:once()
	end
	fmc_3R_old = B738_fmc_3R
	
	if fmc_4R_old ~= B738_fmc_4R and B738_fmc_4R == 1 then
		B738CMD_fmc1_4R:once()
	end
	fmc_4R_old = B738_fmc_4R
	
	if fmc_5R_old ~= B738_fmc_5R and B738_fmc_5R == 1 then
		B738CMD_fmc1_5R:once()
	end
	fmc_5R_old = B738_fmc_5R
	
	if fmc_6R_old ~= B738_fmc_6R and B738_fmc_6R == 1 then
		B738CMD_fmc1_6R:once()
	end
	fmc_6R_old = B738_fmc_6R
	
	if fmc_init_ref_old ~= B738_fmc_init_ref and B738_fmc_init_ref == 1 then
		B738CMD_fmc1_init_ref:once()
	end
	fmc_init_ref_old = B738_fmc_init_ref
	
	if fmc_n1_limit_old ~= B738_fmc_n1_limit and B738_fmc_n1_limit == 1 then
		B738CMD_fmc1_n1_lim:once()
	end
	fmc_n1_limit_old = B738_fmc_n1_limit
	
	if fmc_rte_old ~= B738_fmc_rte and B738_fmc_rte == 1 then
		B738CMD_fmc1_rte:once()
	end
	fmc_rte_old = B738_fmc_rte
	
	if fmc_legs_old ~= B738_fmc_legs and B738_fmc_legs == 1 then
		B738CMD_fmc1_legs:once()
	end
	fmc_legs_old = B738_fmc_legs
	
	if fmc_fix_old ~= B738_fmc_fix and B738_fmc_fix == 1 then
		B738CMD_fmc1_fix:once()
	end
	fmc_fix_old = B738_fmc_fix
	
	if fmc_clb_old ~= B738_fmc_clb and B738_fmc_clb == 1 then
		B738CMD_fmc1_clb:once()
	end
	fmc_clb_old = B738_fmc_clb
	
	if fmc_crs_old ~= B738_fmc_crs and B738_fmc_crs == 1 then
		B738CMD_fmc1_crz:once()
	end
	fmc_crs_old = B738_fmc_crs
	
	if fmc_des_old ~= B738_fmc_des and B738_fmc_des == 1 then
		B738CMD_fmc1_des:once()
	end
	fmc_des_old = B738_fmc_des
	
	if fmc_dep_arr_old ~= B738_fmc_dep_arr and B738_fmc_dep_arr == 1 then
		B738CMD_fmc1_dep_arr:once()
	end
	fmc_dep_arr_old = B738_fmc_dep_arr
	
	if fmc_hold_old ~= B738_fmc_hold and B738_fmc_hold == 1 then
		B738CMD_fmc1_hold:once()
	end
	fmc_hold_old = B738_fmc_hold
	
	if fmc_prev_old ~= B738_fmc_prev and B738_fmc_prev == 1 then
		B738CMD_fmc1_prev_page:once()
	end
	fmc_prev_old = B738_fmc_prev
	
	if fmc_next_old ~= B738_fmc_next and B738_fmc_next == 1 then
		B738CMD_fmc1_next_page:once()
	end
	fmc_next_old = B738_fmc_next
	
	if fmc_menu_old ~= B738_fmc_menu then
		if B738_fmc_menu == 1 then
			B738CMD_fmc1_menu:start()
		else
			B738CMD_fmc1_menu:stop()
		end
	end
	fmc_menu_old = B738_fmc_menu
	
	if fmc_prog_old ~= B738_fmc_prog and B738_fmc_prog == 1 then
		B738CMD_fmc1_prog:once()
	end
	fmc_prog_old = B738_fmc_prog

end

--function aircraft_load() end

function aircraft_unload() 
	
	simDR_throttle_override = 0
	simDR_joy_pitch_override = 0
	simDR_fdir_pitch_ovr = 0
	simDR_fdir_roll_ovr = 0
	simDR_fms_override = 0
	simDR_toe_brakes_ovr = 0
	simDR_steer_ovr = 0
	simDR_override_heading = 0
	simDR_override_pitch = 0
	simDR_override_roll = 0
	simDR_kill_map_fms = 0

end

function flight_start()

	if B738DR_gear_handle_pos == 0 then
		B738_landing_gear = 0
	elseif B738DR_gear_handle_pos == 0.5 then
		B738_landing_gear = 1
	elseif B738DR_gear_handle_pos == 1 then
		B738_landing_gear = 2
	end
	landing_gear_old = B738_landing_gear
	xtime = 0

end


--function flight_crash() end

--function before_physics() end

function after_physics()

	if xtime == 0 then
		B738_ap_buttons()
		B738_land_gear()
		B738_apu_start_stop()
		B738_fmc_buttons()
	end
	xtime = xtime + 1
	if xtime > 3 then
		xtime = 0
	end


end

--function after_replay() end




--*************************************************************************************--
--** 				               SUB-MODULE PROCESSING       	        			 **--
--*************************************************************************************--

-- dofile("")



