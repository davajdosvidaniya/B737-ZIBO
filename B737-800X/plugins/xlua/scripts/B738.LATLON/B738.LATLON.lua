--[[
*****************************************************************************************
* Program Script Name	:	B738.LATLON
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
--** 					               CONSTANTS                    				 **--
--*************************************************************************************--


--ALIGNMENT_TIME_MIN = 2		-- 2 minutes (real 5 minutes)
--ALIGNMENT_TIME_MAX = 5		-- 5 minutes (real 17 minutes)

--*************************************************************************************--
--** 					            GLOBAL VARIABLES                				 **--
--*************************************************************************************--

irs_dspl_test_enable = 0
irs_dspl_test_run = 0

alignment_left_enable = 0
--alignment_left_remain = 0
alignment_right_enable = 0
--alignment_right_remain = 0
alignment_left_status = 0
alignment_right_status = 0
irs_left_mode = 0
irs_right_mode = 0
irs_left_status = 0
irs_right_status = 0
irs_enable = 1
irs_enable2 = 1
irs_flashing = 0
irs_time = 0
alignment_right_entry = 0
alignment_left_entry = 0
irs_left_restart = 0
irs_right_restart = 0
irs_left_fail = 0
irs_right_fail = 0
actual_pos = "-----.-------.-"
irs_left_test = 0
irs_right_test = 0
irs_pos_set = "*****.*******.*"
irs2_pos_set = "*****.*******.*"
irs_hdg_set = "---"
irs2_hdg_set = "---"

align_lat = 0
align_lon = 0

first_time = 0
R_turn_off = 0

irs_align_fail_left = 0
irs_align_fail_right = 0
irs_dc_fail_left = 0
irs_dc_fail_right = 0

--*************************************************************************************--
--** 					            LOCAL VARIABLES                 				 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				             FIND X-PLANE DATAREFS            			    	 **--
--*************************************************************************************--

simDR_startup_running	= find_dataref("sim/operation/prefs/startup_running")

simDR_bus_volts1		= find_dataref("sim/cockpit2/electrical/bus_volts[0]")
simDR_bus_volts2		= find_dataref("sim/cockpit2/electrical/bus_volts[1]")
simDR_bus_volts3		= find_dataref("sim/cockpit2/electrical/bus_volts[2]")


simDR_latitude			= find_dataref("sim/flightmodel/position/latitude")
simDR_longitude			= find_dataref("sim/flightmodel/position/longitude")

--simDR_true_track		= find_dataref("sim/cockpit/autopilot/heading")
simDR_true_track		= find_dataref("sim/flightmodel/position/hpath")
simDR_ground_speed		= find_dataref("sim/flightmodel/position/groundspeed")

simDR_wind_direct		= find_dataref("sim/cockpit2/gauges/indicators/wind_heading_deg_mag")
simDR_wind_speed		= find_dataref("sim/cockpit2/gauges/indicators/wind_speed_kts")

simDR_gps_left_fail		= find_dataref("sim/operation/failures/rel_gps")
simDR_gps_right_fail	= find_dataref("sim/operation/failures/rel_gps2")

simDR_track_left		= find_dataref("sim/cockpit2/gauges/indicators/ground_track_mag_pilot")
simDR_track_right		= find_dataref("sim/cockpit2/gauges/indicators/ground_track_mag_copilot")

simDR_true_heading		= find_dataref("sim/cockpit/misc/compass_indicated")
simDR_true_attitude		= find_dataref("sim/flightmodel/position/vpath")

simDR_airspeed_pilot			= find_dataref("sim/cockpit2/gauges/indicators/airspeed_kts_pilot")
simDR_altitude_pilot			= find_dataref("sim/cockpit2/gauges/indicators/altitude_ft_pilot")


simDR_yaw_damper_switch			= find_dataref("sim/cockpit2/switches/yaw_damper_on")
B738DR_yaw_damper_switch_pos	= find_dataref("laminar/B738/toggle_switch/yaw_dumper_pos")

--*************************************************************************************--
--** 				               FIND X-PLANE COMMANDS                   	    	 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				              FIND CUSTOM DATAREFS             			    	 **--
--*************************************************************************************--

B738DR_irs_pos_fmc			= find_dataref("laminar/B738/FMS/irs_pos_fmc")
B738DR_irs_hdg_fmc_set		= find_dataref("laminar/B738/FMS/irs_hdg_fmc_set")
B738DR_irs2_hdg_fmc_set		= find_dataref("laminar/B738/FMS/irs2_hdg_fmc_set")
B738DR_irs_pos_fmc_set		= find_dataref("laminar/B738/FMS/irs_pos_fmc_set")
B738DR_irs2_pos_fmc_set		= find_dataref("laminar/B738/FMS/irs2_pos_fmc_set")
B738DR_last_pos_str			= find_dataref("laminar/B738/FMS/last_pos_str")

B738DR_engine_no_running_state 		= find_dataref("laminar/B738/fms/engine_no_running_state")

simDR_overwr_gps			= find_dataref("sim/operation/override/override_gps")
B738DR_align_time			= find_dataref("laminar/B738/FMS/align_time")
simDR_overwr_fms			= find_dataref("sim/operation/override/override_fms_advance")

B738DR_ac_stdbus_status		= find_dataref("laminar/B738/electric/ac_stdbus_status")
B738DR_ac_tnsbus1_status	= find_dataref("laminar/B738/electric/ac_tnsbus1_status")
B738DR_ac_tnsbus2_status	= find_dataref("laminar/B738/electric/ac_tnsbus2_status")

B738DR_lights_test 			= find_dataref("laminar/B738/annunciator/test")

--*************************************************************************************--
--** 				              FIND CUSTOM COMMANDS              			     **--
--*************************************************************************************--



--*************************************************************************************--
--** 				        CREATE READ-ONLY CUSTOM DATAREFS               	         **--
--*************************************************************************************--

B738DR_latitude_deg			= create_dataref("laminar/B738/latitude_deg", "number")
B738DR_latitude_min			= create_dataref("laminar/B738/latitude_min", "number")
B738DR_latitude_NS			= create_dataref("laminar/B738/latitude_NS", "number")

B738DR_longitude_deg		= create_dataref("laminar/B738/longitude_deg", "number")
B738DR_longitude_min		= create_dataref("laminar/B738/longitude_min", "number")
B738DR_longitude_EW			= create_dataref("laminar/B738/longitude_EW", "number")

B738DR_irs_left1			= create_dataref("laminar/B738/irs_left1", "number")
B738DR_irs_left2			= create_dataref("laminar/B738/irs_left2", "number")
B738DR_irs_right1			= create_dataref("laminar/B738/irs_right1", "number")
B738DR_irs_right2			= create_dataref("laminar/B738/irs_right2", "number")

B738DR_irs_ns_ew_show		= create_dataref("laminar/B738/ns_ew_show", "number")
B738DR_irs_lat_deg_show		= create_dataref("laminar/B738/lat_deg_show", "number")
B738DR_irs_lat_min_show		= create_dataref("laminar/B738/lat_min_show", "number")
B738DR_irs_lon_deg_show		= create_dataref("laminar/B738/lon_deg_show", "number")
B738DR_irs_lon_min_show		= create_dataref("laminar/B738/lon_min_show", "number")
B738DR_irs_decimals_show	= create_dataref("laminar/B738/decimals_show", "number")
B738DR_irs_left1_show		= create_dataref("laminar/B738/irs_left1_show", "number")
B738DR_irs_left2_show		= create_dataref("laminar/B738/irs_left2_show", "number")
B738DR_irs_right1_show		= create_dataref("laminar/B738/irs_right1_show", "number")
B738DR_irs_right2_show		= create_dataref("laminar/B738/irs_right2_show", "number")

-- ANNUNANCIATES
B738DR_irs_align_fail_right		= create_dataref("laminar/B738/annunciator/irs_align_fail_right", "number")
B738DR_irs_align_fail_left		= create_dataref("laminar/B738/annunciator/irs_align_fail_left", "number")
B738DR_irs_align_right			= create_dataref("laminar/B738/annunciator/irs_align_right", "number")
B738DR_irs_align_left			= create_dataref("laminar/B738/annunciator/irs_align_left", "number")

B738DR_irs_dc_fail_left			= create_dataref("laminar/B738/annunciator/irs_dc_fail_left", "number")
B738DR_irs_on_dc_left			= create_dataref("laminar/B738/annunciator/irs_on_dc_left", "number")
B738DR_irs_dc_fail_right		= create_dataref("laminar/B738/annunciator/irs_dc_fail_right", "number")
B738DR_irs_on_dc_right			= create_dataref("laminar/B738/annunciator/irs_on_dc_right", "number")

B738DR_irs_left_fail			= create_dataref("laminar/B738/annunciator/irs_left_fail", "number")
B738DR_irs_right_fail			= create_dataref("laminar/B738/annunciator/irs_right_fail", "number")

B738DR_gps_pos					= create_dataref("laminar/B738/irs/gps_pos", "string")
B738DR_gps2_pos					= create_dataref("laminar/B738/irs/gps2_pos", "string")
B738DR_irs_pos					= create_dataref("laminar/B738/irs/irs_pos", "string")
B738DR_irs2_pos					= create_dataref("laminar/B738/irs/irs2_pos", "string")
B738DR_irs_status			= create_dataref("laminar/B738/irs/irs_status", "number")
B738DR_irs2_status			= create_dataref("laminar/B738/irs/irs2_status", "number")

B738DR_irs_left_mode		= create_dataref("laminar/B738/irs/irs_mode", "number")
B738DR_irs_right_mode		= create_dataref("laminar/B738/irs/irs2_mode", "number")


B738DR_irs_pfd_allign		= create_dataref("laminar/B738/irs/pfd_allign", "number")
B738DR_irs_pfd_allign_hdg	= create_dataref("laminar/B738/irs/pfd_allign_hdg", "number")
B738DR_irs_nd_allign		= create_dataref("laminar/B738/irs/nd_allign", "number")

alignment_left_remain		= create_dataref("laminar/B738/irs/alignment_left_remain", "number")
alignment_right_remain		= create_dataref("laminar/B738/irs/alignment_right_remain", "number")

test						= create_dataref("laminar/B738/irs/test", "number")
test2						= create_dataref("laminar/B738/irs/test2", "number")

--*************************************************************************************--
--** 				       READ-WRITE CUSTOM DATAREF HANDLERS     	        	     **--
--*************************************************************************************--

function B738DR_irs_source_DRhandler() end
function B738DR_irs_left_DRhandler() end
function B738DR_irs_right_DRhandler() end
function B738DR_irs_sys_dspl_DRhandler() end
function B738DR_irs_dspl_sel_DRhandler() end
function B738DR_irs_dspl_sel_brt_DRhandler() end

function B738DR_irs_pos_set_DRhandler() end

function B738DR_irs1_restart_DRhandler() end
function B738DR_irs2_restart_DRhandler() end

function B738DR_kill_lat_lon_DRhandler() end

--*************************************************************************************--
--** 				       CREATE READ-WRITE CUSTOM DATAREFS                         **--
--*************************************************************************************--

B738DR_kill_lat_lon	= create_dataref("laminar/B738/perf/kill_lat_lon", "number", B738DR_kill_lat_lon_DRhandler)

B738DR_irs_source = 			create_dataref("laminar/B738/toggle_switch/irs_source", "number", B738DR_irs_source_DRhandler)
B738DR_irs_left = 				create_dataref("laminar/B738/toggle_switch/irs_left", "number", B738DR_irs_left_DRhandler)
B738DR_irs_right = 				create_dataref("laminar/B738/toggle_switch/irs_right", "number", B738DR_irs_right_DRhandler)
B738DR_irs_sys_dspl = 			create_dataref("laminar/B738/toggle_switch/irs_sys_dspl", "number", B738DR_irs_sys_dspl_DRhandler)
B738DR_irs_dspl_sel = 			create_dataref("laminar/B738/toggle_switch/irs_dspl_sel", "number", B738DR_irs_dspl_sel_DRhandler)
B738DR_irs_dspl_sel_brt = 		create_dataref("laminar/B738/toggle_switch/irs_dspl_sel_brt", "number", B738DR_irs_dspl_sel_brt_DRhandler)

B738DR_irs_pos_set				= create_dataref("laminar/B738/irs/irs_pos_set", "string", B738DR_irs_pos_set_DRhandler)

B738DR_irs1_restart			= create_dataref("laminar/B738/toggle_switch/irs_restart", "number", B738DR_irs1_restart_DRhandler)
B738DR_irs2_restart			= create_dataref("laminar/B738/toggle_switch/irs2_restart", "number", B738DR_irs2_restart_DRhandler)

--*************************************************************************************--
--** 				             CUSTOM COMMAND HANDLERS            			     **--
--*************************************************************************************--

-- IRS NAVIGATION SWITCH
function B738_irs_source_left_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_irs_source == 0 then
			B738DR_irs_source = -1
		elseif B738DR_irs_source == 1 then
			B738DR_irs_source = 0
		end
	end
end

function B738_irs_source_right_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_irs_source == -1 then
			B738DR_irs_source = 0
		elseif B738DR_irs_source == 0 then
			B738DR_irs_source = 1
		end
	end
end

-- IRS L SWITCH
function B738_irs_L_left_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_irs_left == 1 then
			B738DR_irs_left = 0
		elseif B738DR_irs_left == 2 then
			B738DR_irs_left = 1
		elseif B738DR_irs_left == 3 then
			B738DR_irs_left = 2
		end
	end
end

function B738_irs_L_right_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_irs_left == 0 then
			B738DR_irs_left = 1
			alignment_left_enable = 1		-- start alignment
		elseif B738DR_irs_left == 1 then
			B738DR_irs_left = 2
		elseif B738DR_irs_left == 2 then
			B738DR_irs_left = 3
			alignment_left_entry = 0
		end
	end
end

-- IRS R SWITCH
function B738_irs_R_left_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_irs_right == 1 then
			B738DR_irs_right = 0
		elseif B738DR_irs_right == 2 then
			B738DR_irs_right = 1
		elseif B738DR_irs_right == 3 then
			B738DR_irs_right = 2
		end
	end
end

function B738_irs_R_right_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_irs_right == 0 then
			B738DR_irs_right = 1
			alignment_right_enable = 1		-- start alignment
		elseif B738DR_irs_right == 1 then
			B738DR_irs_right = 2
		elseif B738DR_irs_right == 2 then
			B738DR_irs_right = 3
			alignment_right_entry = 0
		end
	end
end

-- IRS SYSTEM DISPLAY SWITCH
function B738_irs_sys_dspl_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_irs_sys_dspl == 0 then
			B738DR_irs_sys_dspl = 1
		elseif B738DR_irs_sys_dspl == 1 then
			B738DR_irs_sys_dspl = 0
		end
	end
end

-- IRS DISPLAY SELECT
function B738_irs_dspl_sel_left_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_irs_dspl_sel == 1 then
			B738DR_irs_dspl_sel = 0
		elseif B738DR_irs_dspl_sel == 2 then
			B738DR_irs_dspl_sel = 1
		elseif B738DR_irs_dspl_sel == 3 then
			B738DR_irs_dspl_sel = 2
		elseif B738DR_irs_dspl_sel == 4 then
			B738DR_irs_dspl_sel = 3
		end
	elseif phase == 2 then
		if B738DR_irs_dspl_sel == 0 then	-- spring to TK/GS
			B738DR_irs_dspl_sel = 1
			irs_dspl_test_enable = 1
			irs_dspl_test_run = 1
		end
	end
end

function B738_irs_dspl_sel_right_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_irs_dspl_sel == 0 then
			B738DR_irs_dspl_sel = 1
		elseif B738DR_irs_dspl_sel == 1 then
			B738DR_irs_dspl_sel = 2
		elseif B738DR_irs_dspl_sel == 2 then
			B738DR_irs_dspl_sel = 3
		elseif B738DR_irs_dspl_sel == 3 then
			B738DR_irs_dspl_sel = 4
		end
	end
end

-- IRS DISPLAY BRIGHT KNOB
function B738_irs_dspl_brt_left_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_irs_dspl_sel_brt >= 0.1 then
			B738DR_irs_dspl_sel_brt = B738DR_irs_dspl_sel_brt - 0.1
		end
	end
end

function B738_irs_dspl_brt_right_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_irs_dspl_sel_brt <= 0.9 then
			B738DR_irs_dspl_sel_brt = B738DR_irs_dspl_sel_brt + 0.1
		end
	end
end





--*************************************************************************************--
--** 				              CREATE CUSTOM COMMANDS              			     **--
--*************************************************************************************--

B738CMD_irs_source_left = create_command("laminar/B738/toggle_switch/irs_source_left", "IRS source left", B738_irs_source_left_CMDhandler)
B738CMD_irs_source_right = create_command("laminar/B738/toggle_switch/irs_source_right", "IRS source right", B738_irs_source_right_CMDhandler)
B738CMD_irs_L_left = create_command("laminar/B738/toggle_switch/irs_L_left", "IRS L left", B738_irs_L_left_CMDhandler)
B738CMD_irs_L_right = create_command("laminar/B738/toggle_switch/irs_L_right", "IRS L right", B738_irs_L_right_CMDhandler)
B738CMD_irs_R_left = create_command("laminar/B738/toggle_switch/irs_R_left", "IRS R left", B738_irs_R_left_CMDhandler)
B738CMD_irs_R_right = create_command("laminar/B738/toggle_switch/irs_R_right", "IRS R right", B738_irs_R_right_CMDhandler)
B738CMD_irs_sys_dspl = create_command("laminar/B738/toggle_switch/irs_sys_dspl", "IRS system display", B738_irs_sys_dspl_CMDhandler)
B738CMD_irs_dspl_sel_left = create_command("laminar/B738/toggle_switch/irs_dspl_sel_left", "IRS display select left", B738_irs_dspl_sel_left_CMDhandler)
B738CMD_irs_dspl_sel_right = create_command("laminar/B738/toggle_switch/irs_dspl_sel_right", "IRS display select right", B738_irs_dspl_sel_right_CMDhandler)
B738CMD_irs_dspl_brt_left = create_command("laminar/B738/toggle_switch/irs_dspl_sel_brt_left", "IRS display bright left", B738_irs_dspl_brt_left_CMDhandler)
B738CMD_irs_dspl_brt_right = create_command("laminar/B738/toggle_switch/irs_dspl_sel_brt_right", "IRS display bright right", B738_irs_dspl_brt_right_CMDhandler)


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

-- ROUNDING ---
function roundUpToIncrement(number, increment)

    local y = number / increment
    local q = math.ceil(y)
    local z = q * increment

    return z

end


function latitude()

local lat = (math.abs(simDR_latitude))

local lat_deg = (math.floor(lat))

local lat_min_dec = (math.fmod(lat,1.0)*600)

local lat_min_dec2 = (string.format("%06.3f",lat_min_dec))

B738DR_latitude_deg = lat_deg
B738DR_latitude_min = lat_min_dec2
B738DR_latitude_NS = 0
if simDR_latitude < 0 then
	B738DR_latitude_NS = 1
end

end


function longitude()

local lon = (math.abs(simDR_longitude))

local lon_deg = (math.floor(lon))

local lon_min_dec = (math.fmod(lon,1.0)*600)

local lon_min_dec2 = (string.format("%06.3f",lon_min_dec))

B738DR_longitude_deg = lon_deg
B738DR_longitude_min = lon_min_dec2
B738DR_longitude_EW = 0
if simDR_longitude < 0 then
	B738DR_longitude_EW = 1
end


end

function dist_to_latlon(latlon_str)
	
	local dist_lat = 0
	local dist_lon  = 0
	
	dist_lat = tonumber(string.sub(latlon_str, 2, 3)) + (tonumber(string.sub(latlon_str, 4, 7)) / 60)
	if string.sub(latlon_str, 1, 1) == "S" then
		dist_lat = -dist_lat
	end
	
	dist_lon = tonumber(string.sub(latlon_str, 9, 11)) + (tonumber(string.sub(latlon_str, 12, 15)) / 60)
	if string.sub(latlon_str, 8, 8) == "W" then
		dist_lon = -dist_lon
	end
	
	return nd_calc_dist2(simDR_latitude, simDR_longitude, dist_lat, dist_lon)
	
end

function nd_calc_dist2(req_lat, req_lon, req_lat2, req_lon2)
	
	local nd_lat = math.rad(req_lat)
	local nd_lat2 = math.rad(req_lat2)
	
	local nd_dlat = math.rad(req_lat2-req_lat)
	local nd_dlon = math.rad(req_lon2-req_lon)
	
	local nd_a = math.sin(nd_dlat/2)*math.sin(nd_dlat/2)+math.cos(nd_lat)*math.cos(nd_lat2)*math.sin(nd_dlon/2)*math.sin(nd_dlon/2)
	local nd_b = 2 * math.atan2(math.sqrt(nd_a), math.sqrt(1-nd_a))
	local nd_dis = nd_b * 3440.064795	--nm
	
	return nd_dis
end

function B738_random_irs_time()
	-- local int, frac = math.modf(os.clock())
	-- local seed = math.random(1, frac*1000.0)
	-- local irs_min = 0
	-- local irs_max = 0
	--math.randomseed(seed)
	--irs_time = math.random(ALIGNMENT_TIME_MIN, ALIGNMENT_TIME_MAX)
	
	local lat_irs = math.abs(simDR_latitude)
	
	if B738DR_align_time == 1 then
		-- LONG
		irs_time = 5
	elseif B738DR_align_time == 2 then
		-- SHORT
		irs_time = 1
	else
		-- REAL
		lat_irs = math.min(lat_irs, 78)
		if lat_irs <= 45 then
			irs_time = B738_rescale(0, 0, 45, 12, lat_irs)
		else
			irs_time = B738_rescale(45, 12, 78, 18, lat_irs)
		end
		irs_time = math.max(irs_time, 6)
		irs_time = roundUpToIncrement(irs_time, 1 )
	end
	
end


function B738_irs_dspl_test_off()
	irs_dspl_test_run = 0
	irs_align_fail_left = 0
	B738DR_irs_align_left = 0
	irs_dc_fail_left = 0
	B738DR_irs_on_dc_left = 0
	irs_align_fail_right = 0
	B738DR_irs_align_right = 0
	irs_dc_fail_right = 0
	B738DR_irs_on_dc_right = 0
end

function B738_irs_display_data()

	local irs_sys_dspl = B738DR_irs_sys_dspl
	local irs_dspl_sel = B738DR_irs_dspl_sel
	local used_x = 0
	local alignment_remain = 0
	local alignment_entry = 0
	local irs_status = 0
	local irs_mode = 0
	local true_track = 0
	local irs_fail = 0
  local alignment_status = 0
	
	-- run test IRS DSPL SEL
	if irs_dspl_test_enable == 1 
	and B738DR_irs_dspl_sel > 0 then
		irs_dspl_test_enable = 0
		if is_timer_scheduled(B738_irs_dspl_test_off) == false then
			run_after_time(B738_irs_dspl_test_off, 10)	-- 10 seconds
		end
	end
	
	if irs_dspl_test_run == 1 or B738DR_lights_test == 1 then
		if irs_left_status == 1
		or irs_right_status == 1 then
			-- test running
			B738DR_irs_left1 = 88
			B738DR_irs_left2 = 888
			B738DR_irs_right1 = 88
			B738DR_irs_right2 = 888
			B738DR_irs_left1_show = 1
			B738DR_irs_left2_show = 1
			B738DR_irs_right1_show = 1
			B738DR_irs_right2_show = 1
			B738DR_irs_ns_ew_show = 1
			B738DR_irs_lat_deg_show = 0
			B738DR_irs_lat_min_show = 0
			B738DR_irs_lon_deg_show = 0
			B738DR_irs_lon_min_show = 0
			B738DR_irs_decimals_show = 1
		end
	else
		if irs_sys_dspl == 0 then
			alignment_remain = alignment_left_remain
			irs_status = irs_left_status
			irs_mode = irs_left_mode
			true_track = simDR_track_left
			irs_fail = irs_left_fail
			alignment_entry = alignment_left_entry
			alignment_status = alignment_left_status
		else
			alignment_remain = alignment_right_remain
			irs_status = irs_right_status
			irs_mode = irs_right_mode
			true_track = simDR_track_right
			irs_fail = irs_right_fail
			alignment_entry = alignment_right_entry
			alignment_status = alignment_right_status
		end
		B738DR_irs_left1_show = 0
		B738DR_irs_right1_show = 0
		
		if irs_status == 0 then
			B738DR_irs_ns_ew_show = 0
			B738DR_irs_lat_deg_show = 0
			B738DR_irs_lat_min_show = 0
			B738DR_irs_lon_deg_show = 0
			B738DR_irs_lon_min_show = 0
			B738DR_irs_decimals_show = 0
			B738DR_irs_left2_show = 0
			B738DR_irs_right2_show = 0
		elseif irs_fail == 1 then
			B738DR_irs_left1 = 0
			B738DR_irs_right1 = 0
			B738DR_irs_left2 = 0
			B738DR_irs_right2 = 0
			B738DR_irs_ns_ew_show = 0
			B738DR_irs_lat_deg_show = 0
			B738DR_irs_lat_min_show = 0
			B738DR_irs_lon_deg_show = 0
			B738DR_irs_lon_min_show = 0
			B738DR_irs_decimals_show = 0
			B738DR_irs_left2_show = 0
			B738DR_irs_right2_show = 0
		else
			if irs_mode == 1 then
				if irs_dspl_sel == 2 and alignment_status == 1 then 
					-- PPOS -> latitude / longtitude
					B738DR_irs_ns_ew_show = 1
					B738DR_irs_lat_deg_show = 1
					B738DR_irs_lat_min_show = 1
					B738DR_irs_lon_deg_show = 1
					B738DR_irs_lon_min_show = 1
					B738DR_irs_decimals_show = 1
					B738DR_irs_left2_show = 0
					B738DR_irs_right2_show = 0
					B738DR_irs_left1 = 0
					B738DR_irs_right1 = 0
					B738DR_irs_left2 = 0
					B738DR_irs_right2 = 0
				elseif irs_dspl_sel == 4 then
					-- alignment remain in minutes
					B738DR_irs_left1 = 0
					B738DR_irs_right1 = 0
					B738DR_irs_left2 = 0
					B738DR_irs_right2 = 0
					B738DR_irs_ns_ew_show = 0
					B738DR_irs_lat_deg_show = 0
					B738DR_irs_lat_min_show = 0
					B738DR_irs_lon_deg_show = 0
					B738DR_irs_lon_min_show = 0
					B738DR_irs_decimals_show = 0
					B738DR_irs_left2_show = 1
					B738DR_irs_right2_show = 1
					B738DR_irs_left2_show = 0
					if alignment_remain > 0 then
						if alignment_remain > 15 then
							B738DR_irs_right2 = 15
						else
							B738DR_irs_right2 = alignment_remain
						end
					else
						B738DR_irs_right2_show = 0
					end
				else
					B738DR_irs_left1 = 0
					B738DR_irs_right1 = 0
					B738DR_irs_left2 = 0
					B738DR_irs_right2 = 0
					B738DR_irs_ns_ew_show = 0
					B738DR_irs_lat_deg_show = 0
					B738DR_irs_lat_min_show = 0
					B738DR_irs_lon_deg_show = 0
					B738DR_irs_lon_min_show = 0
					B738DR_irs_decimals_show = 0
					B738DR_irs_left2_show = 0
					B738DR_irs_right2_show = 0
				end
			elseif irs_mode == 2 then	-- < 3
				if irs_dspl_sel == 1 then
					-- TK/GS -> true track course / ground speed knots
					used_x = true_track
					B738DR_irs_left2 = math.floor(used_x + 0.5)
					--used_x = B738_rescale(0, 0, 205, 400, simDR_ground_speed)
					used_x = simDR_ground_speed * 1.94384
					B738DR_irs_right2 = math.floor(used_x + 0.5)
					B738DR_irs_ns_ew_show = 0
					B738DR_irs_lat_deg_show = 0
					B738DR_irs_lat_min_show = 0
					B738DR_irs_lon_deg_show = 0
					B738DR_irs_lon_min_show = 0
					B738DR_irs_decimals_show = 0
					B738DR_irs_left2_show = 1
					B738DR_irs_right2_show = 1
				elseif irs_dspl_sel == 2 then
					-- PPOS -> latitude / longtitude
					B738DR_irs_ns_ew_show = 1
					B738DR_irs_lat_deg_show = 1
					B738DR_irs_lat_min_show = 1
					B738DR_irs_lon_deg_show = 1
					B738DR_irs_lon_min_show = 1
					B738DR_irs_decimals_show = 1
					B738DR_irs_left2_show = 0
					B738DR_irs_right2_show = 0
				elseif irs_dspl_sel == 3 then
					-- WIND -> wind direction / wind speed knots
					used_x = simDR_wind_speed
					B738DR_irs_right2 = math.floor(used_x + 0.5)
					if B738DR_irs_right2 == 0 then	-- no wind
						used_x = 0
					else
						used_x = simDR_wind_direct
					end
					B738DR_irs_left2 = math.floor(used_x + 0.5)
					B738DR_irs_ns_ew_show = 0
					B738DR_irs_lat_deg_show = 0
					B738DR_irs_lat_min_show = 0
					B738DR_irs_lon_deg_show = 0
					B738DR_irs_lon_min_show = 0
					B738DR_irs_decimals_show = 0
					B738DR_irs_left2_show = 1
					B738DR_irs_right2_show = 1
				elseif irs_dspl_sel == 4 then
				-- HDG/STS -> true heading / status code
					used_x = simDR_true_heading
					B738DR_irs_left2 = math.floor(used_x + 0.5)
					used_x = 024
					B738DR_irs_right2 = math.floor(used_x + 0.5)
					B738DR_irs_ns_ew_show = 0
					B738DR_irs_lat_deg_show = 0
					B738DR_irs_lat_min_show = 0
					B738DR_irs_lon_deg_show = 0
					B738DR_irs_lon_min_show = 0
					B738DR_irs_decimals_show = 0
					B738DR_irs_left2_show = 1
					B738DR_irs_right2_show = 1
				end
				-- if alignment_entry == 0 then
					-- B738DR_irs_left1 = 0
					-- B738DR_irs_right1 = 0
					-- B738DR_irs_left2 = 0
					-- B738DR_irs_right2 = 0
					-- B738DR_irs_ns_ew_show = 0
					-- B738DR_irs_lat_deg_show = 0
					-- B738DR_irs_lat_min_show = 0
					-- B738DR_irs_lon_deg_show = 0
					-- B738DR_irs_lon_min_show = 0
					-- B738DR_irs_decimals_show = 0
					-- B738DR_irs_left2_show = 1
					-- B738DR_irs_right2_show = 1
				-- end
				-- if alignment_remain > 0 or alignment_remain < 0 then
					-- B738DR_irs_left1 = 0
					-- B738DR_irs_right1 = 0
					-- B738DR_irs_left2 = 0
					-- B738DR_irs_right2 = 0
					-- B738DR_irs_ns_ew_show = 0
					-- B738DR_irs_lat_deg_show = 0
					-- B738DR_irs_lat_min_show = 0
					-- B738DR_irs_lon_deg_show = 0
					-- B738DR_irs_lon_min_show = 0
					-- B738DR_irs_decimals_show = 0
					-- B738DR_irs_left2_show = 1
					-- B738DR_irs_right2_show = 1
					-- if irs_dspl_sel == 4 then
						-- B738DR_irs_left2_show = 0
						-- if alignment_remain > 0 then
							-- -- HDG/STS during alignment -> munutes remaining until alignment is complete
							-- B738DR_irs_right2 = alignment_remain
						-- else
							-- B738DR_irs_right2_show = 0
						-- end
					-- elseif irs_dspl_sel == 2 then
						-- B738DR_irs_left1_show = 1
						-- B738DR_irs_right1_show = 1
					-- end
				-- end
			elseif irs_mode == 3 then
				-- display only attitude and heading info
				used_x = simDR_true_attitude
				B738DR_irs_left2 = math.floor(used_x + 0.5)
				used_x = simDR_true_heading
				B738DR_irs_right2 = math.floor(used_x + 0.5)
				B738DR_irs_ns_ew_show = 0
				B738DR_irs_lat_deg_show = 0
				B738DR_irs_lat_min_show = 0
				B738DR_irs_lon_deg_show = 0
				B738DR_irs_lon_min_show = 0
				B738DR_irs_decimals_show = 0
				B738DR_irs_left2_show = 1
				B738DR_irs_right2_show = 1
			else
				B738DR_irs_right2 = 0
				B738DR_irs_left2 = 0
				B738DR_irs_ns_ew_show = 0
				B738DR_irs_lat_deg_show = 0
				B738DR_irs_lat_min_show = 0
				B738DR_irs_lon_deg_show = 0
				B738DR_irs_lon_min_show = 0
				B738DR_irs_decimals_show = 0
				B738DR_irs_left2_show = 1
				B738DR_irs_right2_show = 1
			end
		end
	end

end


function B738_irs_left_off()
	irs_left_status = 0		-- irs left off
	irs_left_mode = 0
end

function B738_irs_left_align()
	-- alignment_left_remain = alignment_left_remain - 1
	-- if alignment_left_remain == 0 then
		-- alignment_left_remain = 0
	-- end
	if alignment_left_remain > 0 then
		alignment_left_remain = alignment_left_remain - 1
	else
		alignment_left_remain = 0
	end
end

function B738_irs_right_off()
	irs_right_status = 0		-- irs right off
	irs_right_mode = 0
end

function B738_irs_right_align()
	-- alignment_right_remain = alignment_right_remain - 1
	-- if alignment_right_remain == 0 then
		-- alignment_right_remain = 0
	-- end
	if alignment_right_remain > 0 then
		alignment_right_remain = alignment_right_remain - 1
	else
		alignment_right_remain = 0
	end
end

function B738_irs_test_left2()
	irs_left_test = 0
end

function B738_irs_test_right2()
	irs_right_test = 0
end

function B738_irs_test_left()
	if B738DR_ac_tnsbus1_status == 1 then
		B738DR_irs_on_dc_left = 0
	end
	--irs_left_test = 0
	if is_timer_scheduled(B738_irs_test_left2) == false then
		run_after_time(B738_irs_test_left2, 1.5)		-- 1.5 seconds
	end
end

function B738_irs_test_right()
	if B738DR_ac_tnsbus2_status == 1 then
		B738DR_irs_on_dc_right = 0
	end
	--irs_right_test = 0
	if is_timer_scheduled(B738_irs_test_right2) == false then
		run_after_time(B738_irs_test_right2, 1.5)		-- 1.5 seconds
	end
end

function B738_run_irs_left()
	if is_timer_scheduled(B738_irs_left_align) == false then
		run_at_interval(B738_irs_left_align, 60)	-- every 60 seconds
	else
		stop_timer(B738_irs_left_align)
		run_at_interval(B738_irs_left_align, 60)	-- every 60 seconds
	end
	B738_random_irs_time()
	alignment_left_remain = irs_time
--			alignment_left_remain = ALIGNMENT_TIME
	if is_timer_scheduled(B738_irs_test_left) == false then
		run_after_time(B738_irs_test_left, 4)		-- 4 seconds
	else
		stop_timer(B738_irs_test_left)
		run_after_time(B738_irs_test_left, 4)		-- 4 seconds
	end
	if is_timer_scheduled(B738_irs_test_left2) == true then
		stop_timer(B738_irs_test_left2)
	end
	B738DR_irs_on_dc_left = 1
	irs_left_test = 1
end

function B738_run_irs_right()
	if is_timer_scheduled(B738_irs_right_align) == false then
		run_at_interval(B738_irs_right_align, 60)	-- every 60 seconds
	else
		stop_timer(B738_irs_right_align)
		run_at_interval(B738_irs_right_align, 60)	-- every 60 seconds
	end
	B738_random_irs_time()
	alignment_right_remain = irs_time
--			alignment_right_remain = ALIGNMENT_TIME
	if is_timer_scheduled(B738_irs_test_right) == false then
		run_after_time(B738_irs_test_right, 4)		-- 4 seconds
	else
		stop_timer(B738_irs_test_right)
		run_after_time(B738_irs_test_right, 4)		-- 4 seconds
	end
	if is_timer_scheduled(B738_irs_test_right2) == true then
		stop_timer(B738_irs_test_right2)
	end
	B738DR_irs_on_dc_right = 1
	irs_right_test = 1
end



---- TEMPORARY - WAITING FOR INPUT ----
function B738_entry_left()
	alignment_left_entry = 1
	irs_left_mode = 1	-- align mode
end
function B738_entry_right()
	alignment_right_entry = 1
	irs_right_mode = 1	-- align mode
end
---- TEMPORARY - WAITING FOR INPUT ----

function B738_irs_R_turn_off()
	R_turn_off = 2
end

function B738_irs_system()

	local delta_lat = 0
	local delta_lon = 0
	local aircraft_move = 0
	local align_dist = 0
	local align_dist_ok = 0
	
	local irs_lft = B738DR_irs_left
	if irs_lft == 0 then
		-- stop align
		if is_timer_scheduled(B738_irs_left_align) == true then
			stop_timer(B738_irs_left_align)
		end
		if is_timer_scheduled(B738_irs_test_left2) == true then
			stop_timer(B738_irs_test_left2)
		end
		-- start shutdown cycle
		if is_timer_scheduled(B738_irs_left_off) == false then
			run_after_time(B738_irs_left_off, 30)	-- 30 seconds shutdown cycle
		end
		if irs_left_mode < 2 then
			irs_left_status = 0		-- irs left off
		end
		B738DR_irs_on_dc_left = 0
		alignment_left_entry = 0
		irs_left_mode = 0
		irs_left_restart = 0
		irs_left_fail = 0
		alignment_left_status = 0
		B738DR_irs_pos = "-----.-------.-"
	else
		if is_timer_scheduled(B738_irs_left_off) == true then
			stop_timer(B738_irs_left_off)
		end
		irs_left_status = 1		-- irs left on
		if alignment_left_enable == 1 then		-- run alignment
			alignment_left_enable = 0
			irs_left_mode = 1	-- align mode
			irs_left_restart = 0
--			align_lat = simDR_latitude
--			align_lon = simDR_longitude
			B738_run_irs_left()
		end
		if irs_lft == 3 then
			-- att mode
			if is_timer_scheduled(B738_entry_left) == false then	 -- delay for ATT mode
				run_after_time(B738_entry_left, 3)
			end
			if alignment_left_entry == 1 then
				alignment_left_remain = -1		-- NAV align off
				if is_timer_scheduled(B738_irs_left_align) == true then
					stop_timer(B738_irs_left_align)
				end
				if irs_hdg_set ~= "---" then
					local test_x = simDR_true_heading
					test_x = math.floor(test_x + 0.5)
					local test_y = tonumber(irs_hdg_set) - test_x
					if test_y < 0 then
						test_y = -test_y
					end
					if irs_left_fail == 0 and test_y < 2 then
						irs_left_mode = 3	-- att mode
						alignment_left_status = 1
					else
						irs_left_fail = 1
						irs_left_mode = 4
						alignment_left_status = 0
					end
				end
			end
		else
			if is_timer_scheduled(B738_entry_left) == true then
				stop_timer(B738_entry_left)
			end
		end
		if alignment_left_remain == 0 then
			if is_timer_scheduled(B738_irs_left_align) == true then
				stop_timer(B738_irs_left_align)
			end
			if irs_lft == 1 and irs_left_mode ~= 2 and irs_left_mode ~= 4 then
				-- align mode
				irs_left_mode = 1	-- align mode
				alignment_left_entry = 0
			elseif irs_lft == 2 and irs_left_mode ~= 4 then
				-- nav mode
				if irs_right_mode == 2 then
					irs_left_mode = 2	-- nav mode
					B738DR_irs_pos = actual_pos
					alignment_left_status = 1
					alignment_left_entry = 1
				end
				if alignment_left_status == 0 then ---and alignment_right_status == 0 then
					-- flashing, waiting for entry
					-- if B738DR_irs_pos_fmc == 1 then		-- entry from FMC
						-- if alignment_right_status == 1 then		-- if irs right alignment
							-- B738DR_irs_pos_fmc = 0
						-- end
					-- if B738DR_last_pos_str ~= "*****.*******.*" then
						-- align_dist = dist_to_latlon(B738DR_last_pos_str)
						-- if align_dist < 4 then	-- to 4NM
							-- align_dist_ok = 1
						-- end
					-- end
					if irs_pos_set ~= "*****.*******.*" then
						align_dist_ok = 0
						align_dist = dist_to_latlon(irs_pos_set)
						if align_dist < 4 then	-- to 4NM
							align_dist_ok = 1
						end
						--if align_dist < 4 then	-- to 4NM
						if align_dist_ok == 1 then
							irs_left_mode = 2	-- nav mode
							B738DR_irs_pos = actual_pos
							alignment_left_status = 1
						else
							-- IRS fail
							irs_left_fail = 1
							irs_left_mode = 4
							alignment_left_status = 0
							alignment_left_entry = 0
						end
					end
				else
					-- alignment complete
						irs_left_mode = 2	-- nav mode
						B738DR_irs_pos = actual_pos
						alignment_left_status = 1
				end
			end
		end
		if alignment_left_status == 1 then
			B738DR_irs_pos = actual_pos
		end
	end
	B738DR_irs_left_mode = irs_left_mode
	
	--------------------------------------
	-- IRS 2
	--------------------------------------
	
	local irs_rgt = B738DR_irs_right
	if irs_enable2 == 0 then
		irs_align_fail_right = 0
		B738DR_irs_align_right = 0
		if irs_rgt == 0 then
			B738DR_irs_on_dc_right = 0
			R_turn_off = 0
			if is_timer_scheduled(B738_irs_R_turn_off) == true then
				stop_timer(B738_irs_R_turn_off)
			end
		else
			if R_turn_off == 0 then
				R_turn_off = 1
			end
			if is_timer_scheduled(B738_irs_R_turn_off) == false then
				run_after_time(B738_irs_R_turn_off, 300)	-- 5 minutes remain DC ON light
			end
			irs_right_status = 0		-- irs right off
			irs_right_mode = 0
			if R_turn_off == 1 then
				B738DR_irs_on_dc_right = 1
			else
				B738DR_irs_on_dc_right = 0
			end
		end
	else
		if irs_rgt == 0 then
			-- stop align
			if is_timer_scheduled(B738_irs_right_align) == true then
				stop_timer(B738_irs_right_align)
			end
			if is_timer_scheduled(B738_irs_test_right2) == true then
				stop_timer(B738_irs_test_right2)
			end
			-- start shutdown cycle
			if is_timer_scheduled(B738_irs_right_off) == false then
				run_after_time(B738_irs_right_off, 30)	-- 30 seconds shutdown cycle
			end
			if is_timer_scheduled(B738_entry_right) == true then	 -- waiting for entry
				stop_timer(B738_entry_right)
			end
			if irs_right_mode < 2 then
				irs_right_status = 0		-- irs left off
			end
			B738DR_irs_on_dc_right = 0
			alignment_right_entry = 0
			irs_right_mode = 0
			irs_right_restart = 0
			irs_right_fail = 0
			B738DR_irs2_pos = "-----.-------.-"
			alignment_right_status = 0
		else
			if is_timer_scheduled(B738_irs_right_off) == true then
				stop_timer(B738_irs_right_off)
			end
			irs_right_status = 1		-- irs right on
			if alignment_right_enable == 1 then		-- run alignment
				alignment_right_enable = 0
				irs_right_mode = 1	-- align mode
				irs_right_restart = 0
	--			align_lat = simDR_latitude
	--			align_lon = simDR_longitude
				B738_run_irs_right()
			end
			if irs_rgt == 3 then
				-- att mode
				if is_timer_scheduled(B738_entry_right) == false then	 -- delay for ATT mode
					run_after_time(B738_entry_right, 3)
				end
				if alignment_right_entry == 1 then
					alignment_right_remain = -1		-- NAV align off
					if is_timer_scheduled(B738_irs_right_align) == true then
						stop_timer(B738_irs_right_align)
					end
					if irs2_hdg_set ~= "---" and irs_right_mode ~= 3 then
						local test_x = simDR_true_heading
						test_x = math.floor(test_x + 0.5)
						local test_y = tonumber(irs2_hdg_set) - test_x
						if test_y < 0 then
							test_y = -test_y
						end
						if irs_right_fail == 0 and test_y < 2 then
							irs_right_mode = 3	-- att mode
							alignment_right_status = 1
						else
							irs_right_fail = 1
							irs_right_mode = 4
							alignment_right_status = 0
						end
					end
				end
			else
				if is_timer_scheduled(B738_entry_right) == true then
					stop_timer(B738_entry_right)
				end
			end
			if alignment_right_remain == 0 then
				if is_timer_scheduled(B738_irs_right_align) == true then
					stop_timer(B738_irs_right_align)
				end
				if irs_rgt == 1 and irs_right_mode ~= 2 and irs_right_mode ~= 4 then
					-- align mode
					irs_right_mode = 1	-- align mode
					alignment_right_entry = 0
				elseif irs_rgt == 2 and irs_right_mode ~= 4 then
					-- nav mode
					if irs_left_mode == 2 then
						irs_right_mode = 2	-- nav mode
						B738DR_irs_pos = actual_pos
						alignment_right_status = 1
						alignment_right_entry = 1
					end
					if alignment_right_status == 0 then ---and alignment_left_status == 0 then
						-- flashing, waiting for entry
						-- if B738DR_irs_pos_fmc == 1 then		-- entry from FMC
							-- B738DR_irs_pos_fmc = 0
							-- if B738DR_last_pos_str ~= "*****.*******.*" then
								-- align_dist = dist_to_latlon(B738DR_last_pos_str)
								-- if align_dist < 4 then	-- to 4NM
									-- align_dist_ok = 1
								-- end
							-- end
							if irs2_pos_set ~= "*****.*******.*" then
							align_dist_ok = 0
							align_dist = dist_to_latlon(irs_pos_set)
							if align_dist < 4 then	-- to 4NM
								align_dist_ok = 1
							end
							-- align_dist = dist_to_latlon(irs2_pos_set)
							-- if align_dist < 3 then	-- to 3NM
							if align_dist_ok == 1 then
								irs_right_mode = 2	-- nav mode
								B738DR_irs2_pos = actual_pos
								alignment_right_status = 1
							else
								-- IRS fail
								irs_right_fail = 1
								irs_right_mode = 4
								alignment_right_status = 0
								alignment_right_entry = 0
							end
						end
					else
						-- alignment complete
						irs_right_mode = 2	-- nav mode
						B738DR_irs2_pos = actual_pos
						alignment_right_status = 1
					end
				end
			end
			if alignment_right_status == 1 then
				B738DR_irs2_pos = actual_pos
			end
		end
		B738DR_irs_right_mode = irs_right_mode
	end
	
	delta_lat = align_lat - simDR_latitude
	if delta_lat < 0 then
		delta_lat = -delta_lat
	end
	delta_lon = align_lon - simDR_longitude
	if delta_lon < 0 then
		delta_lon = -delta_lon
	end
	if delta_lat > 0.000009 and delta_lon > 0.000009 then
		aircraft_move = 1
		align_lat = simDR_latitude
		align_lon = simDR_longitude
	else
		aircraft_move = 0
	end
	
	if alignment_left_remain > 0 and aircraft_move == 1 
	and irs_left_restart == 0 then
		irs_left_restart = 1
		B738DR_irs1_restart = 1
		if is_timer_scheduled(B738_irs_left_align) == true then
			stop_timer(B738_irs_left_align)
		end
	end
	
	if irs_left_restart == 1 and aircraft_move == 0 
	and alignment_left_remain > 0 then
		irs_left_restart = 0
		B738_run_irs_left()
	end
	
	if alignment_right_remain > 0 and aircraft_move == 1 
	and irs_right_restart == 0 then
		irs_right_restart = 1
		B738DR_irs2_restart = 1
		if is_timer_scheduled(B738_irs_right_align) == true then
			stop_timer(B738_irs_right_align)
		end
	end
	
	if irs_right_restart == 1 and aircraft_move == 0 
	and alignment_right_remain > 0 then
		irs_right_restart = 0
		B738_run_irs_right()
	end
	
	if B738DR_irs_left_mode == 1 then
		if B738DR_irs_left == 2 then
			irs_pos_set = B738DR_irs_pos_fmc_set
		elseif B738DR_irs_left == 3 then
			irs_hdg_set = B738DR_irs_hdg_fmc_set
		end
	end
	if B738DR_irs_right_mode == 1 then
		if B738DR_irs_right == 2 then
			irs2_pos_set = B738DR_irs_pos_fmc_set
		elseif B738DR_irs_right == 3 then
			irs2_hdg_set = B738DR_irs_hdg_fmc_set
		end
	end
	
end

function B738_irs_annun()

	local irs_lft = B738DR_irs_left
	local irs_rgt = B738DR_irs_right
	
	if irs_lft == 0 then
		irs_align_fail_left = 0		-- on, if fault entry only
		if irs_left_status == 0 then
			B738DR_irs_align_left = 0
		else
			B738DR_irs_align_left = 1	-- shutdown cycle
		end
	else
		if irs_dspl_test_run == 1 then
			irs_align_fail_left = 1
			B738DR_irs_align_left = 1
			irs_dc_fail_left = 1
			B738DR_irs_on_dc_left = 1
		else
			if irs_left_fail == 1 then
				irs_align_fail_left = 1
				B738DR_irs_align_left = 0
			elseif irs_left_mode == 1 then		-- mode ALIGN
				if irs_left_test == 1 then
					B738DR_irs_align_left = 0
				elseif irs_lft == 3 then
					-- flashing
					B738DR_irs_align_left = irs_flashing
				elseif irs_lft == 2 and alignment_left_remain == 0 then
					-- flashing
					B738DR_irs_align_left = irs_flashing
				else
					B738DR_irs_align_left = 1
				end
			elseif irs_left_mode == 4 then
				-- fault
				irs_align_fail_left = 1
			else	-- mode NAV and ATT
				if irs_lft == 1 then
					-- fast realign
					B738DR_irs_align_left = 1
				else
					B738DR_irs_align_left = 0
				end
			end
		end
	end

	----------------------------------------
	-- IRS right
	----------------------------------------
	if irs_enable2 == 1 then
		if irs_rgt == 0 then
			irs_align_fail_right = 0		-- on, if fault entry only
			if irs_right_status == 0 then
				B738DR_irs_align_right = 0
			else
				B738DR_irs_align_right = 1	-- shutdown cycle
			end
		else
			if irs_dspl_test_run == 1 then
				irs_align_fail_right = 1
				B738DR_irs_align_right = 1
				irs_dc_fail_right = 1
				B738DR_irs_on_dc_right = 1
			else
				if irs_right_fail == 1 then
					irs_align_fail_right = 1
					B738DR_irs_align_right = 0
				elseif irs_right_mode == 1 then		-- mode ALIGN
					if irs_right_test == 1 then
						B738DR_irs_align_right = 0
					elseif irs_rgt == 3 then
						B738DR_irs_align_right = irs_flashing
					elseif irs_rgt == 2 and alignment_right_remain == 0 then
						-- flashing
						B738DR_irs_align_right = irs_flashing
					else
						B738DR_irs_align_right = 1
					end
				elseif irs_right_mode == 4 then
					-- fault
					irs_align_fail_right = 1
				else	-- mode NAV and ATT
					if irs_rgt == 1 then
						-- fast realign
						B738DR_irs_align_right = 1
					else
						B738DR_irs_align_right = 0
					end
				end
			end
		end
	end
	
end


function B738_irs_source()

	local irs_lft = B738DR_irs_left
	local irs_rgt = B738DR_irs_right
	local irs_source = B738DR_irs_source

	if irs_source == -1 then		-- both L
		if irs_left_mode == 2 or irs_left_mode == 3 then
			B738DR_irs_left_fail = 0
			B738DR_irs_right_fail = 0
			-- simDR_gps_left_fail = 0
			-- simDR_gps_right_fail = 0
		else
			B738DR_irs_left_fail = 1
			B738DR_irs_right_fail = 1
			-- simDR_gps_left_fail = 6
			-- simDR_gps_right_fail = 6
		end
	elseif irs_source == 0 then		-- normal
		if irs_left_mode == 2 or irs_left_mode == 3 then
			B738DR_irs_left_fail = 0
			-- simDR_gps_left_fail = 0
		else
			B738DR_irs_left_fail = 1
			-- simDR_gps_left_fail = 6
		end
		if irs_right_mode == 2 or irs_right_mode == 3 then
			B738DR_irs_right_fail = 0
			-- simDR_gps_right_fail = 0
		else
			B738DR_irs_right_fail = 1
			-- simDR_gps_right_fail = 6
		end
	elseif irs_source == 1 then		-- both R
		if irs_right_mode == 2 or irs_right_mode == 3 then
			B738DR_irs_left_fail = 0
			B738DR_irs_right_fail = 0
			-- simDR_gps_left_fail = 0
			-- simDR_gps_right_fail = 0
		else
			B738DR_irs_left_fail = 1
			B738DR_irs_right_fail = 1
			-- simDR_gps_left_fail = 6
			-- simDR_gps_right_fail = 6
		end
	end

end

function B738_irs_electric()

	-- IRS working if BUS 1 or BUS 2 > 10 Volts
	if simDR_bus_volts1 > 10 or simDR_bus_volts2 > 10 then
		irs_enable = 1
	else
		irs_enable = 0
		B738DR_irs_align_left = 0
		irs_align_fail_left = 0
		B738DR_irs_align_right = 0
		irs_align_fail_right = 0
		B738DR_irs_on_dc_left = 0
		B738DR_irs_on_dc_right = 0
	end
	if B738DR_ac_tnsbus2_status == 0 then
		irs_enable2 = 0
		B738DR_irs_align_right = 0
		irs_align_fail_right = 0
	else
		irs_enable2 = 1
		R_turn_off = 0
	end
	
end

function B738_irs_flash()

	if irs_flashing == 0 then
		irs_flashing = 1
	else
		irs_flashing = 0
	end

end


function B738_gps_pos()

	local position_min = ""
	local position_deg = ""
	local position = ""
  local pos_deg = ""
  local pos_min = ""

	pos_deg = string.format("%02d", B738DR_latitude_deg)
	pos_min = string.format("%05.1f", B738DR_latitude_min)
--	if B738DR_latitude_deg < 0 then
	if B738DR_latitude_NS == 1 then
		position = ("S" .. pos_deg)
	else
		position = ("N" .. pos_deg)
	end
	position = position .. string.sub(pos_min, 1, 2)
	position = position .. "."
	position = position .. string.sub(pos_min, 3, 3)
	pos_deg = string.format("%03d", B738DR_longitude_deg)
	pos_min = string.format("%05.1f", B738DR_longitude_min)
--	if B738DR_longitude_deg < 0 then
	if B738DR_longitude_EW == 1 then
		position = (position .. "W")
	else
		position = (position .. "E")
	end
	position = position .. pos_deg
	position = position .. string.sub(pos_min, 1, 2)
	position = position .. "."
	position = position .. string.sub(pos_min, 3, 3)

	actual_pos = position
	
	if simDR_gps_left_fail == 0 then
		B738DR_gps_pos = position
	else
		B738DR_gps_pos = "-----.-------.-"
	end

	if simDR_gps_right_fail == 0 then
		B738DR_gps2_pos = position
	else
		B738DR_gps2_pos = "-----.-------.-"
	end

end

function pfd_nd()
	if B738DR_irs_left_mode > 1 or B738DR_irs_right_mode > 1 then
		if B738DR_irs_right_fail == 1 and B738DR_irs_left_fail == 1 then
			B738DR_irs_pfd_allign = 1
			B738DR_irs_pfd_allign_hdg = 1
			B738DR_irs_nd_allign = 1
			simDR_overwr_fms = 1
			--simDR_overwr_gps = 1
		else
			B738DR_irs_pfd_allign = 0
			B738DR_irs_pfd_allign_hdg = 0
			B738DR_irs_nd_allign = 0
			simDR_overwr_fms = 0
			--simDR_overwr_gps = 0
		end
	else
		B738DR_irs_pfd_allign = 1
		B738DR_irs_pfd_allign_hdg = 1
		B738DR_irs_nd_allign = 1
		simDR_overwr_fms = 1
		--simDR_overwr_gps = 1
	end
end

function turn_around_state()
	if first_time > 1 and first_time < 2 then
		first_time = 3
		if simDR_startup_running == 0 and B738DR_engine_no_running_state == 1 then
			-- IRS alignment
			B738DR_irs_left = 2
			B738DR_irs_right = 2
			irs_left_mode = 2
			irs_right_mode = 2
			irs_left_status = 1
			irs_right_status = 1
			simDR_gps_left_fail = 0
			simDR_gps_right_fail = 0
			alignment_left_remain = 0
			alignment_right_remain = 0
			alignment_right_entry = 0
			alignment_left_entry = 0
			latitude()
			longitude()
			B738_gps_pos()
			B738DR_irs_pos = B738DR_gps_pos
			B738DR_irs2_pos = B738DR_gps2_pos
			alignment_left_status = 1
			alignment_right_status = 1
		end
	end
	if first_time < 3 then
		first_time = first_time + SIM_PERIOD
	end
end

--*************************************************************************************--
--** 				               XLUA EVENT CALLBACKS       	        			 **--
--*************************************************************************************--

--function aircraft_load() end

--function aircraft_unload() end

function flight_start() 

	if simDR_startup_running == 0 then
		B738DR_irs_left = 0
		B738DR_irs_right = 0
		irs_left_mode = 0
		irs_right_mode = 0
		irs_left_status = 0
		irs_right_status = 0
--		simDR_gps_left_fail = 0
--		simDR_gps_right_fail = 0
		alignment_left_remain = -1
		alignment_right_remain = -1
		alignment_left_status = 0
		alignment_right_status = 0
		alignment_right_entry = 0
		alignment_left_entry = 0
		B738DR_irs_pos ="-----.-------.-"
		B738DR_irs2_pos = "-----.-------.-"
	else
		-- Engine runnning
		B738DR_irs_left = 2
		B738DR_irs_right = 2
		irs_left_mode = 2
		irs_right_mode = 2
		irs_left_status = 1
		irs_right_status = 1
		simDR_gps_left_fail = 0
		simDR_gps_right_fail = 0
		alignment_left_remain = 0
		alignment_right_remain = 0
		alignment_right_entry = 0
		alignment_left_entry = 0
		latitude()
		longitude()
		B738_gps_pos()
		B738DR_irs_pos = B738DR_gps_pos
		B738DR_irs2_pos = B738DR_gps2_pos
		alignment_left_status = 1
		alignment_right_status = 1
	end
	
	-- Always
	B738DR_irs_dspl_sel = 2
	B738DR_irs_dspl_sel_brt = 1
	
	irs_dspl_test_enable = 0
	irs_dspl_test_run = 0
	alignment_left_enable = 0
	alignment_right_enable = 0
	irs_enable = 1
	irs_left_restart = 0
	irs_right_restart = 0
	irs_left_fail = 0
	irs_right_fail = 0
	irs_pos_set = "*****.*******.*"
	irs2_pos_set = "*****.*******.*"
	irs_hdg_set = "---"
	irs2_hdg_set = "---"

	if is_timer_scheduled(B738_irs_flash) == false then
		run_at_interval(B738_irs_flash, 0.5)
	end

	first_time = 0
	
end

--function flight_crash() end

function before_physics()

	if B738DR_kill_lat_lon == 0 then
		B738_irs_electric()
	end
	-- latitude()
	-- longitude()

end

function after_physics() 

	if B738DR_kill_lat_lon == 0 then
		latitude()
		longitude()
		B738_gps_pos()
		if irs_enable == 1 then
			B738_irs_display_data()
			B738_irs_system()
			B738_irs_annun()
			B738_irs_source()
			B738DR_irs_status = irs_left_status
			B738DR_irs2_status = irs_right_status
			-- DC lights
			if B738DR_irs_left > 0 then
				if B738DR_ac_tnsbus1_status == 0 then
					B738DR_irs_on_dc_left = 1
				else
					if is_timer_scheduled(B738_irs_test_left) == false then
						B738DR_irs_on_dc_left = 0
					end
				end
			end
			if irs_enable2 == 1 then
				if B738DR_irs_right > 0 then
					-- if B738DR_ac_tnsbus2_status == 0 then
						-- B738DR_irs_on_dc_right = 1
					-- else
						if is_timer_scheduled(B738_irs_test_right) == false then
							B738DR_irs_on_dc_right = 0
						end
					-- end
				end
			end
		else
			B738DR_irs_status = 0
			B738DR_irs2_status = 0
		end
		if B738DR_lights_test == 1 then
			B738DR_irs_align_left = 1
			B738DR_irs_align_fail_left = 1
			B738DR_irs_align_right = 1
			B738DR_irs_align_fail_right = 1
			B738DR_irs_on_dc_left = 1
			B738DR_irs_on_dc_right = 1
			B738DR_irs_dc_fail_left = 1
			B738DR_irs_dc_fail_right = 1
		else
			B738DR_irs_align_fail_left = irs_align_fail_left
			B738DR_irs_align_fail_right = irs_align_fail_right
			B738DR_irs_dc_fail_left = irs_dc_fail_left
			B738DR_irs_dc_fail_right = irs_dc_fail_right
		end
		pfd_nd()
		turn_around_state()
	end

end

--function after_replay() end


--*************************************************************************************--
--** 				               SUB-MODULE PROCESSING       	        			 **--
--*************************************************************************************--

-- dofile("")



