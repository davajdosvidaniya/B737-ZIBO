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



--*************************************************************************************--
--** 					            LOCAL VARIABLES                 				 **--
--*************************************************************************************--

local B738_rudder_trim_sel_dial_position_target = 0
local B738_aileron_trim_sel_dial_position_target = 0



--*************************************************************************************--
--** 				              FIND CUSTOM DATAREFS             			    	 **--
--*************************************************************************************--





--*************************************************************************************--
--** 				               FIND CUSTOM COMMANDS              			     **--
--*************************************************************************************--


--*************************************************************************************--
--** 				                X-PLANE DATAREFS            			    	 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				        CREATE READ-ONLY CUSTOM DATAREFS               	         **--
--*************************************************************************************--

B738DR_rudder_trim_sel_dial_pos = create_dataref("laminar/B738/flt_ctrls/rudder_trim/sel_dial_pos", "number")
B738DR_aileron_trim_switch_pos   = create_dataref("laminar/B738/flt_ctrls/aileron_trim/switch_pos", "number")



--*************************************************************************************--
--** 				       READ-WRITE CUSTOM DATAREF HANDLERS     	        	     **--
--*************************************************************************************--


--*************************************************************************************--
--** 				       CREATE READ-WRITE CUSTOM DATAREFS                         **--
--*************************************************************************************--



--*************************************************************************************--
--** 				              CUSTOM COMMAND HANDLERS            			     **--
--*************************************************************************************--



--*************************************************************************************--
--** 				             X-PLANE COMMAND HANDLERS               	    	 **--
--*************************************************************************************--


-- RUDDER TRIM
function sim_rudder_trim_left_beforeCMDhandler(phase, duration) end

function sim_rudder_trim_left_afterCMDhandler(phase, duration)
    if phase == 0 then
        B738_rudder_trim_sel_dial_position_target = -1
    elseif phase == 2 then
        B738_rudder_trim_sel_dial_position_target = 0
    end
end



function sim_rudder_trim_right_beforeCMDhandler(phase, duration) end

function sim_rudder_trim_right_afterCMDhandler(phase, duration)
    if phase == 0 then
        B738_rudder_trim_sel_dial_position_target = 1
    elseif phase == 2 then
        B738_rudder_trim_sel_dial_position_target = 0
    end
end





-- AILERON TRIM
function sim_aileron_trim_left_beforeCMDhandler(phase, duration) end

function sim_aileron_trim_left_afterCMDhandler(phase, duration)
    if phase == 0 then
        B738_aileron_trim_sel_dial_position_target = -1
    elseif phase == 2 then
        B738_aileron_trim_sel_dial_position_target = 0
    end
end



function sim_aileron_trim_right_beforeCMDhandler(phase, duration) end

function sim_aileron_trim_right_afterCMDhandler(phase, duration)
    if phase == 0 then
        B738_aileron_trim_sel_dial_position_target = 1
    elseif phase == 2 then
        B738_aileron_trim_sel_dial_position_target = 0
    end
end









--*************************************************************************************--
--** 				                 X-PLANE COMMANDS                   	    	 **--
--*************************************************************************************--

-- RUDDER TRIM
simCMD_rudder_trim_left         = wrap_command("sim/flight_controls/rudder_trim_left", sim_rudder_trim_left_beforeCMDhandler, sim_rudder_trim_left_afterCMDhandler)
simCMD_rudder_trim_right        = wrap_command("sim/flight_controls/rudder_trim_right", sim_rudder_trim_right_beforeCMDhandler, sim_rudder_trim_right_afterCMDhandler)



-- AILERON TRIM
simCMD_aileron_trim_left        = wrap_command("sim/flight_controls/aileron_trim_left", sim_aileron_trim_left_beforeCMDhandler, sim_aileron_trim_left_afterCMDhandler)
simCMD_aileron_trim_right       = wrap_command("sim/flight_controls/aileron_trim_right", sim_aileron_trim_right_beforeCMDhandler, sim_aileron_trim_right_afterCMDhandler)





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





----- RUDDER TRIM DIAL POSITION ANIMATION --------------------------------------------
function B738_rudder_trim_dial_animation()

    B738DR_rudder_trim_sel_dial_pos = B738_set_animation_position(B738DR_rudder_trim_sel_dial_pos, B738_rudder_trim_sel_dial_position_target, -1.0, 1.0, 10.0)

end




----- AILERON TRIM SWITCH POSITION ANIMATION --------------------------------------------
function B738_aileron_trim_switch_animation()

    B738DR_aileron_trim_switch_pos = B738_set_animation_position(B738DR_aileron_trim_switch_pos, B738_aileron_trim_sel_dial_position_target, -1.0, 1.0, 10.0)

end




--*************************************************************************************--
--** 				                  EVENT CALLBACKS           	    			 **--
--*************************************************************************************--

--function aircraft_load() end

--function aircraft_unload() end

--function flight_start()


--function flight_crash() end

--function before_physics() end

function after_physics()

    B738_rudder_trim_dial_animation()
    B738_aileron_trim_switch_animation()

end

--function after_replay() end



