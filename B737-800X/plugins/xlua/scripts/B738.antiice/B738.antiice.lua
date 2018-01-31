--[[
*****************************************************************************************
* Program Script Name	:	B738.trim
* Author Name			:	Jim Gregory
*
*   Revisions:
*   -- DATE --	--- REV NO ---		--- DESCRIPTION ---
*   2016-04-26	0.01a				Start of Dev
*
*
*
*
*****************************************************************************************
*        COPYRIGHT � 2016 JIM GREGORY / LAMINAR RESEARCH - ALL RIGHTS RESERVED
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

l_side_temp = 0
l_fwd_temp = 0
r_side_temp = 0
r_fwd_temp = 0

l_side_temp_tgt = 0
l_fwd_temp_tgt = 0
r_side_temp_tgt = 0
r_fwd_temp_tgt = 0

wing_heat_ground_set = 0

--*************************************************************************************--
--** 					            LOCAL VARIABLES                 				 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				             FIND X-PLANE DATAREFS            			    	 **--
--*************************************************************************************--

simDR_engine1_on			= find_dataref("sim/flightmodel2/engines/engine_is_burning_fuel[0]")
simDR_engine2_on			= find_dataref("sim/flightmodel2/engines/engine_is_burning_fuel[1]")

simDR_cowl_ice_0_on			= find_dataref("sim/cockpit2/ice/ice_inlet_heat_on_per_engine[0]")
simDR_cowl_ice_1_on			= find_dataref("sim/cockpit2/ice/ice_inlet_heat_on_per_engine[1]")

simDR_throttle_ratio		= find_dataref("sim/cockpit2/engine/actuators/throttle_ratio_all")
simDR_aircraft_on_ground	= find_dataref("sim/flightmodel/failures/onground_all")
simDR_on_ground_0			= find_dataref("sim/flightmodel2/gear/on_ground[0]")
simDR_on_ground_1			= find_dataref("sim/flightmodel2/gear/on_ground[1]")
simDR_on_ground_2			= find_dataref("sim/flightmodel2/gear/on_ground[2]")


simDR_wing_l_heat_on		= find_dataref("sim/cockpit2/ice/ice_surfce_heat_left_on")
simDR_wing_r_heat_on		= find_dataref("sim/cockpit2/ice/ice_surfce_heat_right_on")

simDR_window_heat_on		= find_dataref("sim/cockpit2/ice/ice_window_heat_on")

simDR_TAT					= find_dataref("sim/cockpit2/temperature/outside_air_LE_temp_degc")
simDR_aircraft_groundspeed 	= find_dataref("sim/flightmodel/position/groundspeed")

simDR_radio_height_pilot_ft		= find_dataref("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot")

simDR_startup_running 		= find_dataref("sim/operation/prefs/startup_running")

--*************************************************************************************--
--** 				               FIND X-PLANE COMMANDS                   	    	 **--
--*************************************************************************************--

simCMD_eng1_heat_on		= find_command("sim/ice/inlet_heat0_on")
simCMD_eng1_heat_off	= find_command("sim/ice/inlet_heat0_off")
simCMD_eng2_heat_on		= find_command("sim/ice/inlet_heat1_on")
simCMD_eng2_heat_off	= find_command("sim/ice/inlet_heat1_off")

simCMD_wing_l_heat_on		= find_command("sim/ice/wing_heat0_on")
simCMD_wing_l_heat_off		= find_command("sim/ice/wing_heat0_off")
simCMD_wing_r_heat_on		= find_command("sim/ice/wing_heat1_on")
simCMD_wing_r_heat_off		= find_command("sim/ice/wing_heat1_off")

--*************************************************************************************--
--** 				              FIND CUSTOM DATAREFS             			    	 **--
--*************************************************************************************--

B738DR_duct_pressure_L	= find_dataref("laminar/B738/indicators/duct_press_L")
B738DR_duct_pressure_R	= find_dataref("laminar/B738/indicators/duct_press_R")

B738DR_ac_tnsbus1_status	= find_dataref("laminar/B738/electric/ac_tnsbus1_status")
B738DR_ac_tnsbus2_status	= find_dataref("laminar/B738/electric/ac_tnsbus2_status")

--*************************************************************************************--
--** 				               FIND CUSTOM COMMANDS              			     **--
--*************************************************************************************--


--*************************************************************************************--
--** 				                X-PLANE DATAREFS            			    	 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				        CREATE READ-ONLY CUSTOM DATAREFS               	         **--
--*************************************************************************************--

-- WING ANTI ICE
--B738DR_wing_ice_on_L		= create_dataref("laminar/B738/annunciator/wing_ice_on_L", "number")
--B738DR_wing_ice_on_R		= create_dataref("laminar/B738/annunciator/wing_ice_on_R", "number")


B738DR_eng1_tai			= create_dataref("laminar/B738/eicas/eng1_tai", "number")
B738DR_eng2_tai			= create_dataref("laminar/B738/eicas/eng2_tai", "number")


l_side_temp 	= create_dataref("laminar/B738/ice/l_side_temp", "number")
l_fwd_temp 		= create_dataref("laminar/B738/ice/l_fwd_temp", "number")
r_side_temp 	= create_dataref("laminar/B738/ice/r_side_temp", "number")
r_fwd_temp 		= create_dataref("laminar/B738/ice/r_fwd_temp", "number")

--*************************************************************************************--
--** 				       READ-WRITE CUSTOM DATAREF HANDLERS     	        	     **--
--*************************************************************************************--


function B738DR_eng1_heat_pos_DRhandler()end
function B738DR_eng2_heat_pos_DRhandler()end
function B738DR_wing_heat_pos_DRhandler()end
function B738DR_window_heat_l_side_pos_DRhandler()end
function B738DR_window_heat_l_fwd_pos_DRhandler()end
function B738DR_window_heat_r_side_pos_DRhandler()end
function B738DR_window_heat_r_fwd_pos_DRhandler()end

function B738DR_kill_anti_ice_DRhandler()end

--*************************************************************************************--
--** 				       CREATE READ-WRITE CUSTOM DATAREFS                         **--
--*************************************************************************************--
B738DR_kill_anti_ice	= create_dataref("laminar/B738/perf/kill_anti_ice", "number", B738DR_kill_anti_ice_DRhandler)

B738DR_eng1_heat_pos	= create_dataref("laminar/B738/ice/eng1_heat_pos", "number", B738DR_eng1_heat_pos_DRhandler)
B738DR_eng2_heat_pos	= create_dataref("laminar/B738/ice/eng2_heat_pos", "number", B738DR_eng2_heat_pos_DRhandler)

B738DR_wing_heat_pos	= create_dataref("laminar/B738/ice/wing_heat_pos", "number", B738DR_wing_heat_pos_DRhandler)

B738DR_window_heat_l_side_pos	= create_dataref("laminar/B738/ice/window_heat_l_side_pos", "number", B738DR_window_heat_l_side_pos_DRhandler)
B738DR_window_heat_l_fwd_pos	= create_dataref("laminar/B738/ice/window_heat_l_fwd_pos", "number", B738DR_window_heat_l_fwd_pos_DRhandler)
B738DR_window_heat_r_side_pos	= create_dataref("laminar/B738/ice/window_heat_r_side_pos", "number", B738DR_window_heat_r_side_pos_DRhandler)
B738DR_window_heat_r_fwd_pos	= create_dataref("laminar/B738/ice/window_heat_r_fwd_pos", "number", B738DR_window_heat_r_fwd_pos_DRhandler)

--*************************************************************************************--
--** 				              CUSTOM COMMAND HANDLERS            			     **--
--*************************************************************************************--

-- ENGINE ANTI ICE

function B738CMD_eng1_heat_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_eng1_heat_pos == 0 then
			B738DR_eng1_heat_pos = 1
		elseif B738DR_eng1_heat_pos == 1 then
			B738DR_eng1_heat_pos = 0
		end
	end
end

function B738CMD_eng2_heat_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_eng2_heat_pos == 0 then
			B738DR_eng2_heat_pos = 1
		elseif B738DR_eng2_heat_pos == 1 then
			B738DR_eng2_heat_pos = 0
		end
	end
end

-- WING ANTI ICE

function B738CMD_wing_heat_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_wing_heat_pos == 0 then
			B738DR_wing_heat_pos = 1
			--if simDR_aircraft_on_ground == 1 then
			if simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1 or simDR_on_ground_2 == 1 then
				wing_heat_ground_set = 1
			end
		elseif B738DR_wing_heat_pos == 1 then
			B738DR_wing_heat_pos = 0
		end
	end
end

-- WINDOW HEAT

function B738CMD_window_heat_l_side_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_window_heat_l_side_pos == 0 then
			B738DR_window_heat_l_side_pos = 1
			l_side_temp_tgt = 45
		elseif B738DR_window_heat_l_side_pos == 1 then
			B738DR_window_heat_l_side_pos = 0
		end
	end
end

function B738CMD_window_heat_l_fwd_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_window_heat_l_fwd_pos == 0 then
			B738DR_window_heat_l_fwd_pos = 1
			l_fwd_temp_tgt = 45
		elseif B738DR_window_heat_l_fwd_pos == 1 then
			B738DR_window_heat_l_fwd_pos = 0
		end
	end
end

function B738CMD_window_heat_r_side_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_window_heat_r_side_pos == 0 then
			B738DR_window_heat_r_side_pos = 1
			r_side_temp_tgt = 45
		elseif B738DR_window_heat_r_side_pos == 1 then
			B738DR_window_heat_r_side_pos = 0
		end
	end
end

function B738CMD_window_heat_r_fwd_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_window_heat_r_fwd_pos == 0 then
			B738DR_window_heat_r_fwd_pos = 1
			r_fwd_temp_tgt = 45
		elseif B738DR_window_heat_r_fwd_pos == 1 then
			B738DR_window_heat_r_fwd_pos = 0
		end
	end
end




--*************************************************************************************--
--** 				              CREATE CUSTOM COMMANDS              			     **--
--*************************************************************************************--


B738CMD_eng1_heat	= create_command("laminar/B738/toggle_switch/eng1_heat", "ENGINE 1 Anti ice on/off", B738CMD_eng1_heat_CMDhandler)
B738CMD_eng2_heat	= create_command("laminar/B738/toggle_switch/eng2_heat", "ENGINE 2 Anti ice on/off", B738CMD_eng2_heat_CMDhandler)

B738CMD_wing_heat	= create_command("laminar/B738/toggle_switch/wing_heat", "WING Anti ice on/off", B738CMD_wing_heat_CMDhandler)

B738CMD_window_heat_l_side	= create_command("laminar/B738/toggle_switch/window_heat_l_side", "WINDOW Left side heat on/off", B738CMD_window_heat_l_side_CMDhandler)
B738CMD_window_heat_l_fwd	= create_command("laminar/B738/toggle_switch/window_heat_l_fwd", "WINDOW Left fwd heat on/off", B738CMD_window_heat_l_fwd_CMDhandler)
B738CMD_window_heat_r_side	= create_command("laminar/B738/toggle_switch/window_heat_r_side", "WINDOW Right side heat on/off", B738CMD_window_heat_r_side_CMDhandler)
B738CMD_window_heat_r_fwd	= create_command("laminar/B738/toggle_switch/window_heat_r_fwd", "WINDOW Right fwd heat on/off", B738CMD_window_heat_r_fwd_CMDhandler)

--*************************************************************************************--
--** 				             X-PLANE COMMAND HANDLERS               	    	 **--
--*************************************************************************************--


--*************************************************************************************--
--** 				                 X-PLANE COMMANDS                   	    	 **--
--*************************************************************************************--


--*************************************************************************************--
--** 				              CREATE CUSTOM COMMANDS              			     **--
--*************************************************************************************--



--*************************************************************************************--
--** 					            OBJECT CONSTRUCTORS         		    		 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				               CREATE SYSTEM OBJECTS            				 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				                  SYSTEM FUNCTIONS           	    			 **--
--*************************************************************************************--

----- ANIMATION UTILITY -----------------------------------------------------------------
function B738_set_animation_position(current_value, target, min, max, speed)

    if target >= (max - 0.001) and current_value >= (max - 0.01) then
        return max
    elseif target <= (min + 0.001) and current_value <= (min + 0.01) then
        return min
    else
        return current_value + ((target - current_value) * (speed * SIM_PERIOD))
    end

end

function B738_set_animation_rate(current_value, target, min, max, speed)
	local calc_result = 0
	if target >= (max - 0.001) and current_value >= (max - 0.01) then
        return max
    elseif target <= (min + 0.001) and current_value <= (min + 0.01) then
        return min
    elseif current_value > max then
		return max
    elseif current_value < min then
		return min
	elseif current_value < target then
		calc_result = current_value + (SIM_PERIOD / speed)
		if calc_result > target then
			calc_result = target
		end
		return calc_result
	else
		calc_result = current_value - (SIM_PERIOD / speed)
		if calc_result < target then
			calc_result = target
		end
        return calc_result
    end
end

----- RESCALE FLOAT AND CLAMP TO OUTER LIMITS -------------------------------------------

function B738_rescale(in1, out1, in2, out2, x)
    if x < in1 then return out1 end
    if x > in2 then return out2 end
    return out1 + (out2 - out1) * (x - in1) / (in2 - in1)
end



----- ENGINE ANTI ICE
function B738_engine_anti_ice()

	if B738DR_eng1_heat_pos == 1
	and simDR_engine1_on == 1
	and simDR_cowl_ice_0_on == 0 then
		simCMD_eng1_heat_on:once()
	end

	if B738DR_eng1_heat_pos == 0
	and simDR_cowl_ice_0_on == 1 then
		simCMD_eng1_heat_off:once()
	end

	if B738DR_eng2_heat_pos == 1
	and simDR_engine2_on == 1
	   and simDR_cowl_ice_1_on == 0 then
		simCMD_eng2_heat_on:once()
	end
	
	if B738DR_eng2_heat_pos == 0
	and simDR_cowl_ice_1_on == 1 then
		simCMD_eng2_heat_off:once()
	end

end

----- WING ANTI ICE
function B738_wing_anti_ice()

	local wing_heat_enable = 1		-- aircraft on ground and thrust under takeoff
	local wing_l_heat_enable = 1	-- L DUCT > 15 psi
	local wing_r_heat_enable = 1	-- R DUCT > 15 psi
	
	-- if simDR_radio_height_pilot_ft > 50 then
		-- if B738DR_wing_heat_pos == 1 and wing_heat_ground_set == 1 then
			-- B738CMD_wing_heat:once()	-- electric to off
			-- wing_heat_ground_set = 0
		-- end
	-- end
	
	--if simDR_aircraft_on_ground == 1
	if (simDR_on_ground_0 == 1 or simDR_on_ground_1 == 1 or simDR_on_ground_2 == 1) 
	and simDR_throttle_ratio > 0.5 then
		wing_heat_enable = 0
		if B738DR_wing_heat_pos == 1 and wing_heat_ground_set == 1 then
			B738CMD_wing_heat:once()	-- electric to off
			wing_heat_ground_set = 0
		end
	end
	
	if B738DR_duct_pressure_L < 8
	or wing_heat_enable == 0
	or B738DR_wing_heat_pos == 0 then
		wing_l_heat_enable = 0
	end
	
	if B738DR_duct_pressure_R < 8
	or wing_heat_enable == 0
	or B738DR_wing_heat_pos == 0 then
		wing_r_heat_enable = 0
	end
	
	if wing_l_heat_enable == 0 
	and simDR_wing_l_heat_on == 1 then
		simCMD_wing_l_heat_off:once()
	end
	if wing_l_heat_enable == 1 
	and simDR_wing_l_heat_on == 0 then
		simCMD_wing_l_heat_on:once()
	end

	if wing_r_heat_enable == 0 
	and simDR_wing_r_heat_on == 1 then
		simCMD_wing_r_heat_off:once()
	end
	if wing_r_heat_enable == 1 
	and simDR_wing_r_heat_on == 0 then
		simCMD_wing_r_heat_on:once()
	end

end

function B738_window_heat()

	if B738DR_window_heat_l_side_pos == 1
	or B738DR_window_heat_l_fwd_pos == 1
	or B738DR_window_heat_r_side_pos == 1
	or B738DR_window_heat_r_fwd_pos == 1 then
		if B738DR_ac_tnsbus1_status == 0 and B738DR_ac_tnsbus1_status == 0 then
			simDR_window_heat_on = 0
		else
			simDR_window_heat_on = 1
		end
	else
		simDR_window_heat_on = 0
	end


end


function B738_engine_tai()

	if B738DR_eng1_heat_pos == 1
	and simDR_engine1_on == 1 
	and simDR_cowl_ice_0_on == 1 then
		B738DR_eng1_tai = 1
	else
		B738DR_eng1_tai = 0
	end
	
	if B738DR_eng2_heat_pos == 1
	and simDR_engine2_on == 1 
	and simDR_cowl_ice_1_on == 1 then
		B738DR_eng2_tai = 1
	else
		B738DR_eng2_tai = 0
	end

end


function B738_window_temp()
	
	local temp_true = simDR_TAT - (10 * (simDR_aircraft_groundspeed / 180))
	temp_true = math.min(-10, temp_true)
	temp_true = math.max(-50, temp_true)
	local temp_true_tgt = B738_rescale(-50, 20, 18, 45, temp_true)
	
	if B738DR_window_heat_l_side_pos == 0 or B738DR_ac_tnsbus2_status == 0 then
		l_side_temp_tgt = simDR_TAT
	else
		l_side_temp_tgt = temp_true_tgt
	end
	if B738DR_window_heat_l_fwd_pos == 0 or B738DR_ac_tnsbus1_status == 0 then
		l_fwd_temp_tgt = simDR_TAT
	else
		l_fwd_temp_tgt = temp_true_tgt
	end
	if B738DR_window_heat_r_side_pos == 0 or B738DR_ac_tnsbus1_status == 0 then
		r_side_temp_tgt = simDR_TAT
	else
		r_side_temp_tgt = temp_true_tgt
	end
	if B738DR_window_heat_r_fwd_pos == 0 or B738DR_ac_tnsbus2_status == 0 then
		r_fwd_temp_tgt = simDR_TAT
	else
		r_fwd_temp_tgt = temp_true_tgt
	end
	
	l_side_temp = B738_set_animation_rate(l_side_temp, l_side_temp_tgt, -50, 70, 10)
	l_fwd_temp = B738_set_animation_rate(l_fwd_temp, l_fwd_temp_tgt, -50, 70, 10)
	r_side_temp = B738_set_animation_rate(r_side_temp, r_side_temp_tgt, -50, 70, 10)
	r_fwd_temp = B738_set_animation_rate(r_fwd_temp, r_fwd_temp_tgt, -50, 70, 10)
	
end

--*************************************************************************************--
--** 				               XLUA EVENT CALLBACKS       	        			 **--
--*************************************************************************************--

--function aircraft_load() end

--function aircraft_unload() end

function flight_start() 

	B738DR_eng1_heat_pos = 0
	B738DR_eng2_heat_pos = 0
	B738DR_wing_heat_pos = 0
	B738DR_window_heat_l_side_pos = 0
	B738DR_window_heat_l_fwd_pos = 0
	B738DR_window_heat_r_side_pos = 0
	B738DR_window_heat_r_fwd_pos = 0

	if simDR_startup_running == 0 then
		l_side_temp = simDR_TAT
		l_fwd_temp = simDR_TAT
		r_side_temp = simDR_TAT
		r_fwd_temp = simDR_TAT
	else
		l_side_temp = 20
		l_fwd_temp = 20
		r_side_temp = 20
		r_fwd_temp = 20
	end

	l_side_temp_tgt = 0
	l_fwd_temp_tgt = 0
	r_side_temp_tgt = 0
	r_fwd_temp_tgt = 0
	
	wing_heat_ground_set = 0

end

--function flight_crash() end

--function before_physics() 

--	
--end

function after_physics() 

	B738_engine_anti_ice()
	B738_wing_anti_ice()
	B738_window_heat()
	B738_engine_tai()
	B738_window_temp()

end

--function after_replay() end




--*************************************************************************************--
--** 				               SUB-MODULE PROCESSING       	        			 **--
--*************************************************************************************--

-- dofile("")



