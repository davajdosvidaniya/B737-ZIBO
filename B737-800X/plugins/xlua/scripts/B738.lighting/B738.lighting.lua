--[[
*****************************************************************************************
* Program Script Name	:	B738.lighting
*
* Author Name			:	Jim Gregory
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

fist_time = 0
first_time_enable = 1

--*************************************************************************************--
--** 					            LOCAL VARIABLES                 				 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				             FIND X-PLANE DATAREFS            			    	 **--
--*************************************************************************************--

simDR_compass_brightness_switch  = find_dataref("sim/cockpit2/switches/instrument_brightness_ratio[6]")

simDR_taxi_light_brightness_switch  = find_dataref("sim/cockpit2/switches/generic_lights_switch[4]") 

simDR_landing_light_on_0 = find_dataref("sim/cockpit2/switches/landing_lights_switch[0]")
simDR_landing_light_on_1 = find_dataref("sim/cockpit2/switches/landing_lights_switch[1]")
simDR_landing_light_on_2 = find_dataref("sim/cockpit2/switches/landing_lights_switch[2]")
simDR_landing_light_on_3 = find_dataref("sim/cockpit2/switches/landing_lights_switch[3]")

simDR_rwy_light_left = find_dataref("sim/cockpit2/switches/generic_lights_switch[2]")
simDR_rwy_light_right = find_dataref("sim/cockpit2/switches/generic_lights_switch[3]")

simDR_cockpit_dome_switch = find_dataref("sim/cockpit2/switches/generic_lights_switch[9]")

simDR_seatbelt_sign_switch 	= find_dataref("sim/cockpit2/switches/fasten_seat_belts")
simDR_no_smoking_switch 	= find_dataref("sim/cockpit2/switches/no_smoking")

--simDR_standby_compass_light_level = find_dataref("sim/cockpit2/switches/instrument_brightness_ratio[6]")


simDR_cockpit_forw_panel 	= find_dataref("sim/cockpit2/switches/generic_lights_switch[6]")
simDR_cockpit_glareshield 	= find_dataref("sim/cockpit2/switches/generic_lights_switch[7]")

simDR_sun_pitch 			= find_dataref("sim/graphics/scenery/sun_pitch_degrees")

simDR_bus_load0			= find_dataref("sim/cockpit2/electrical/plugin_bus_load_amps[0]")
simDR_bus_load1			= find_dataref("sim/cockpit2/electrical/plugin_bus_load_amps[1]")
simDR_bus_load2			= find_dataref("sim/cockpit2/electrical/plugin_bus_load_amps[2]")

simDR_apu_status = find_dataref("sim/cockpit2/electrical/APU_N1_percent")
simDR_engine1_on = find_dataref("sim/flightmodel2/engines/engine_is_burning_fuel[0]")
simDR_engine2_on = find_dataref("sim/flightmodel2/engines/engine_is_burning_fuel[1]")
simDR_gen1_on					= find_dataref("sim/cockpit2/electrical/generator_on[0]")
simDR_gen2_on					= find_dataref("sim/cockpit2/electrical/generator_on[1]")

simDR_on_ground_0				= find_dataref("sim/flightmodel2/gear/on_ground[0]")
simDR_on_ground_1				= find_dataref("sim/flightmodel2/gear/on_ground[1]")
simDR_on_ground_2				= find_dataref("sim/flightmodel2/gear/on_ground[2]")
simDR_radio_height_pilot_ft		= find_dataref("sim/cockpit2/gauges/indicators/radio_altimeter_height_ft_pilot")

simDR_logo_light_switch  		= find_dataref("sim/cockpit2/switches/generic_lights_switch[1]") 
simDR_wing_light_switch  		= find_dataref("sim/cockpit2/switches/generic_lights_switch[0]") 
simDR_wheel_light_switch 		= find_dataref("sim/cockpit2/switches/generic_lights_switch[5]") 

-- captain_main_panel_brg			= find_dataref("sim/cockpit2/switches/panel_brightness_ratio[0]")
-- first_officer_panel_brg			= find_dataref("sim/cockpit2/switches/panel_brightness_ratio[1]")
-- overhead_panel_brg				= find_dataref("sim/cockpit2/switches/panel_brightness_ratio[2]")
-- pedestal_panel_brg				= find_dataref("sim/cockpit2/switches/panel_brightness_ratio[3]")


--*************************************************************************************--
--** 				               FIND X-PLANE COMMANDS                   	    	 **--
--*************************************************************************************--

simCMD_nav_lights_on				= find_command("sim/lights/nav_lights_on") 
simCMD_nav_lights_off				= find_command("sim/lights/nav_lights_off")

simCMD_strobe_lights_on				= find_command("sim/lights/strobe_lights_on")
simCMD_strobe_lights_off			= find_command("sim/lights/strobe_lights_off")

simCMD_seatbelt_toggle				= find_command("sim/systems/seatbelt_sign_toggle")
simCMD_nosmoking_toggle				= find_command("sim/systems/no_smoking_toggle")

--*************************************************************************************--
--** 				              FIND CUSTOM DATAREFS             			    	 **--
--*************************************************************************************--

B738DR_apu_gen1_pos				= find_dataref("laminar/B738/electrical/apu_gen1_pos")
B738DR_apu_gen2_pos				= find_dataref("laminar/B738/electrical/apu_gen1_pos")

B738DR_engine_no_running_state 	= find_dataref("laminar/B738/fms/engine_no_running_state")

B738DR_apu_start_load			= find_dataref("laminar/B738/electric/apu_start_load")

B738DR_batbus_status			= find_dataref("laminar/B738/electric/batbus_status")

--*************************************************************************************--
--** 				              FIND CUSTOM COMMANDS              			     **--
--*************************************************************************************--



--*************************************************************************************--
--** 				        CREATE READ-ONLY CUSTOM DATAREFS               	         **--
--*************************************************************************************--

B738DR_position_light_switch_pos	= create_dataref("laminar/B738/toggle_switch/position_light_pos", "number")

B738DR_compass_brighness_switch_pos	= create_dataref("laminar/B738/toggle_switch/compass_brightness_pos", "number")

B738DR_cockpit_dome_switch_pos	= create_dataref("laminar/B738/toggle_switch/cockpit_dome_pos", "number")

B738DR_taxi_light_brightness_switch_pos = create_dataref("laminar/B738/toggle_switch/taxi_light_brightness_pos", "number")

B738DR_landing_lights_all_on_pos = create_dataref("laminar/B738/spring_switch/landing_lights_all_on", "number")

B738DR_land_lights_ret_left_pos = create_dataref("laminar/B738/switch/land_lights_ret_left_pos", "number")
B738DR_land_lights_ret_right_pos = create_dataref("laminar/B738/switch/land_lights_ret_right_pos", "number")

B738DR_seatbelt_sign_switch_pos = create_dataref("laminar/B738/toggle_switch/seatbelt_sign_pos", "number")

B738DR_land_ret_left_pos	= create_dataref("laminar/B738/lights/land_ret_left_pos", "number")
B738DR_land_ret_right_pos	= create_dataref("laminar/B738/lights/land_ret_right_pos", "number")


--*************************************************************************************--
--** 				       READ-WRITE CUSTOM DATAREF HANDLERS     	        	     **--
--*************************************************************************************--

function B738DR_no_smoking_pos_DRhandler() end
function B738DR_ife_pass_seat_pos_DRhandler() end
function B738DR_cab_util_pos_DRhandler() end

function B738DR_window0_DRhandler() end

--*************************************************************************************--
--** 				       CREATE READ-WRITE CUSTOM DATAREFS                         **--
--*************************************************************************************--

B738DR_no_smoking_pos = 	create_dataref("laminar/B738/toggle_switch/no_smoking_pos", "number", B738DR_no_smoking_pos_DRhandler)
B738DR_ife_pass_seat_pos = 	create_dataref("laminar/B738/toggle_switch/ife_pass_seat_pos", "number", B738DR_ife_pass_seat_pos_DRhandler)
B738DR_cab_util_pos = 		create_dataref("laminar/B738/toggle_switch/cab_util_pos", "number", B738DR_cab_util_pos_DRhandler)

B738DR_window0 = 			create_dataref("laminar/B738/window/window0", "number", B738DR_window0_DRhandler)

--*************************************************************************************--
--** 				             CUSTOM COMMAND HANDLERS            			     **--
--*************************************************************************************--

-- POSITION LIGHT SWITCH
function B738_position_light_switch_up_CMDhandler(phase, duration)
	if phase == 0 then
        if B738DR_position_light_switch_pos == -1 then
            B738DR_position_light_switch_pos = 0
            simCMD_nav_lights_off:once()
            simCMD_strobe_lights_off:once()
        elseif B738DR_position_light_switch_pos == 0 then
            B738DR_position_light_switch_pos = 1
            simCMD_nav_lights_on:once()
            simCMD_strobe_lights_on:once()
        end		
	end	
end	


function B738_position_light_switch_dn_CMDhandler(phase, duration)
	if phase == 0 then
        if B738DR_position_light_switch_pos == 1 then
            B738DR_position_light_switch_pos = 0
            simCMD_nav_lights_off:once()
            simCMD_strobe_lights_off:once()
        elseif B738DR_position_light_switch_pos == 0 then
            B738DR_position_light_switch_pos = -1
            simCMD_nav_lights_on:once()          
        end		
	end			
end	





-- COMPASS LIGHT SWITCH
function B738_compass_brightness_switch_rgt_CMDhandler(phase, duration)
	if phase == 0 then
        if B738DR_compass_brighness_switch_pos == -1 then
            B738DR_compass_brighness_switch_pos = 0
            simDR_compass_brightness_switch = 0
        elseif B738DR_compass_brighness_switch_pos == 0 then
            B738DR_compass_brighness_switch_pos = 1
            simDR_compass_brightness_switch = 1
        end		
	end	
end	


function B738_compass_brightness_switch_lft_CMDhandler(phase, duration)
	if phase == 0 then
        if B738DR_compass_brighness_switch_pos == 1 then
            B738DR_compass_brighness_switch_pos = 0
            simDR_compass_brightness_switch = 0
        elseif B738DR_compass_brighness_switch_pos == 0 then
            B738DR_compass_brighness_switch_pos = -1
            simDR_compass_brightness_switch = 0.33          
        end		
	end			
end	


-- COCKPIT DOME LIGHT SWITCH
function B738_cockpit_dome_switch_up_CMDhandler(phase, duration)
	if phase == 0 then
        if B738DR_cockpit_dome_switch_pos == -1 then
            B738DR_cockpit_dome_switch_pos = 0
            simDR_cockpit_dome_switch = 0
        elseif B738DR_cockpit_dome_switch_pos == 0 then
            B738DR_cockpit_dome_switch_pos = 1
            simDR_cockpit_dome_switch = 0.4
        end		
	end	
end	


function B738_cockpit_dome_switch_dn_CMDhandler(phase, duration)
	if phase == 0 then
        if B738DR_cockpit_dome_switch_pos == 1 then
            B738DR_cockpit_dome_switch_pos = 0
            simDR_cockpit_dome_switch = 0
        elseif B738DR_cockpit_dome_switch_pos == 0 then
            B738DR_cockpit_dome_switch_pos = -1
            simDR_cockpit_dome_switch = 1          
        end		
	end			
end	



-- TAXI LIGHT SWITCH
function B738_taxi_light_brightness_switch_up_CMDhandler(phase, duration)
	if phase == 0 then
        if B738DR_taxi_light_brightness_switch_pos == 2 then
            B738DR_taxi_light_brightness_switch_pos = 1
            simDR_taxi_light_brightness_switch = 0.5
        elseif B738DR_taxi_light_brightness_switch_pos == 1 then
            B738DR_taxi_light_brightness_switch_pos = 0
            simDR_taxi_light_brightness_switch = 0
        end		
	end	
end	


function B738_taxi_light_brightness_switch_dn_CMDhandler(phase, duration)
	if phase == 0 then
        if B738DR_taxi_light_brightness_switch_pos == 0 then
            B738DR_taxi_light_brightness_switch_pos = 1
            simDR_taxi_light_brightness_switch = 0.5
        elseif B738DR_taxi_light_brightness_switch_pos == 1 then
            B738DR_taxi_light_brightness_switch_pos = 2
            simDR_taxi_light_brightness_switch = 1         
        end		
	end			
end	

function B738_taxi_light_bright_switch_toggle_CMDhandler(phase, duration)
	if phase == 0 then
        if B738DR_taxi_light_brightness_switch_pos == 0 then
            B738DR_taxi_light_brightness_switch_pos = 2
            simDR_taxi_light_brightness_switch = 1
        elseif B738DR_taxi_light_brightness_switch_pos == 1 then
            B738DR_taxi_light_brightness_switch_pos = 2
            simDR_taxi_light_brightness_switch = 1
        elseif B738DR_taxi_light_brightness_switch_pos == 2 then
            B738DR_taxi_light_brightness_switch_pos = 0
            simDR_taxi_light_brightness_switch = 0
        end		
	end			
end	



-- LANDING LIGHT ALL
function B738_landing_lights_all_on_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_landing_lights_all_on_pos == 0 then
			B738DR_landing_lights_all_on_pos = 1
			B738DR_land_lights_ret_left_pos = 2		-- landing lights retract
			B738DR_land_lights_ret_right_pos = 2	-- landing lights retract
			simDR_landing_light_on_0 = 1
			simDR_landing_light_on_1 = 1
			simDR_landing_light_on_2 = 1
			simDR_landing_light_on_3 = 1
			end
	elseif phase == 2 then
		if B738DR_landing_lights_all_on_pos == 1 then
			B738DR_landing_lights_all_on_pos = 0
		end
	end
end

-- LANDING LIGHTS RETRACT LEFT and RIGHT
function B738_land_lights_ret_left_up_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_land_lights_ret_left_pos == 1 then
			B738DR_land_lights_ret_left_pos = 0
			simDR_landing_light_on_1 = 0
		elseif B738DR_land_lights_ret_left_pos == 2 then
			B738DR_land_lights_ret_left_pos = 1
			simDR_landing_light_on_1 = 0
		end
	end
end
function B738_land_lights_ret_left_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_land_lights_ret_left_pos == 0 then
			B738DR_land_lights_ret_left_pos = 1
			simDR_landing_light_on_1 = 0
		elseif B738DR_land_lights_ret_left_pos == 1 then
			B738DR_land_lights_ret_left_pos = 2
			simDR_landing_light_on_1 = 1
		end
	end
end
function B738_land_lights_ret_right_up_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_land_lights_ret_right_pos == 1 then
			B738DR_land_lights_ret_right_pos = 0
			simDR_landing_light_on_2 = 0
		elseif B738DR_land_lights_ret_right_pos == 2 then
			B738DR_land_lights_ret_right_pos = 1
			simDR_landing_light_on_2 = 0
		end
	end
end
function B738_land_lights_ret_right_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_land_lights_ret_right_pos == 0 then
			B738DR_land_lights_ret_right_pos = 1
			simDR_landing_light_on_2 = 0
		elseif B738DR_land_lights_ret_right_pos == 1 then
			B738DR_land_lights_ret_right_pos = 2
			simDR_landing_light_on_2 = 1
		end
	end
end

	
-- SEAT BELT SIGN SWITCH
function B738_seatbelt_sign_switch_up_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_seatbelt_sign_switch_pos == 2 then
			B738DR_seatbelt_sign_switch_pos = 1
			simDR_seatbelt_sign_switch = 1
		elseif B738DR_seatbelt_sign_switch_pos == 1 then
			B738DR_seatbelt_sign_switch_pos = 0
			simDR_seatbelt_sign_switch = 0
		end
	end
end

function B738_seatbelt_sign_switch_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_seatbelt_sign_switch_pos == 0 then
			B738DR_seatbelt_sign_switch_pos = 1
			simCMD_seatbelt_toggle:once()
		elseif B738DR_seatbelt_sign_switch_pos == 1 then
			B738DR_seatbelt_sign_switch_pos = 2
			simCMD_seatbelt_toggle:once()
			simDR_seatbelt_sign_switch = 2
		end
	end
end


-- NO SMOKING SIGN SWITCH
function B738_no_smoking_up_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_no_smoking_pos == 2 then
			B738DR_no_smoking_pos = 1
			simDR_no_smoking_switch = 1
		elseif B738DR_no_smoking_pos == 1 then
			B738DR_no_smoking_pos = 0
			simDR_no_smoking_switch = 0
		end
	end
end

function B738_no_smoking_dn_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_no_smoking_pos == 0 then
			B738DR_no_smoking_pos = 1
			simCMD_nosmoking_toggle:once()
		elseif B738DR_no_smoking_pos == 1 then
			B738DR_no_smoking_pos = 2
			simCMD_nosmoking_toggle:once()
			simDR_no_smoking_switch = 2
		end
	end
end


-- IFE PASS SEAT SWITCH
function B738_ife_pass_seat_toggle_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_ife_pass_seat_pos == 0 then
			B738DR_ife_pass_seat_pos = 1
		elseif B738DR_ife_pass_seat_pos == 1 then
			B738DR_ife_pass_seat_pos = 0
		end
	end
end

-- CABIN UTILITY SWITCH
function B738_cab_util_toggle_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_cab_util_pos == 0 then
			B738DR_cab_util_pos = 1
		elseif B738DR_cab_util_pos == 1 then
			B738DR_cab_util_pos = 0
		end
	end
end

function B738_rwy_light_left_on_CMDhandler(phase, duration)
	if phase == 0 then
		simDR_rwy_light_left = 1
	end
 end

 function B738_rwy_light_left_off_CMDhandler(phase, duration)
	if phase == 0 then
		simDR_rwy_light_left = 0
	end
 end

 function B738_rwy_light_right_on_CMDhandler(phase, duration)
	if phase == 0 then
		simDR_rwy_light_right = 1
	end
 end

 function B738_rwy_light_right_off_CMDhandler(phase, duration)
	if phase == 0 then
		simDR_rwy_light_right = 0
	end
 end

 
 
function B738_logo_light_switch_on_CMDhandler(phase, duration)
	if phase == 0 then
		simDR_logo_light_switch = 1
	end	
end	

function B738_logo_light_switch_off_CMDhandler(phase, duration)
	if phase == 0 then
		simDR_logo_light_switch = 0
	end	
end	

function B738_wing_light_switch_on_CMDhandler(phase, duration)
	if phase == 0 then
		simDR_wing_light_switch = 1
	end	
end	

function B738_wing_light_switch_off_CMDhandler(phase, duration)
	if phase == 0 then
		simDR_wing_light_switch = 0
	end	
end	
 
function B738_wheel_light_switch_on_CMDhandler(phase, duration)
	if phase == 0 then
		simDR_wheel_light_switch = 1
	end	
end	

function B738_wheel_light_switch_off_CMDhandler(phase, duration)
	if phase == 0 then
		simDR_wheel_light_switch = 0
	end	
end	

 --*************************************************************************************--
--** 				              CREATE CUSTOM COMMANDS              			     **--
--*************************************************************************************--

-- LOGO LIGHT SWITCH
B738CMD_logo_light_switch_on 	= create_command("laminar/B738/switch/logo_light_on", "Logo Light Switch On", B738_logo_light_switch_on_CMDhandler)
B738CMD_logo_light_switch_off 	= create_command("laminar/B738/switch/logo_light_off", "Logo Light Switch Off", B738_logo_light_switch_off_CMDhandler)

-- WING LIGHT SWITCH
B738CMD_wing_light_switch_on 	= create_command("laminar/B738/switch/wing_light_on", "Wing Light Switch On", B738_wing_light_switch_on_CMDhandler)
B738CMD_wing_light_switch_off 	= create_command("laminar/B738/switch/wing_light_off", "Wing Light Switch Off", B738_wing_light_switch_off_CMDhandler)

-- WHEEL LIGHT SWITCH
B738CMD_wheel_light_switch_on 	= create_command("laminar/B738/switch/wheel_light_on", "Wheel Light Switch On", B738_wheel_light_switch_on_CMDhandler)
B738CMD_wheel_light_switch_off 	= create_command("laminar/B738/switch/wheel_light_off", "Wheel Light Switch Off", B738_wheel_light_switch_off_CMDhandler)

-- POSITION LIGHT SWITCH
B738CMD_position_light_switch_up 	= create_command("laminar/B738/toggle_switch/position_light_up", "Position Light Switch Up", B738_position_light_switch_up_CMDhandler)
B738CMD_position_light_switch_dn 	= create_command("laminar/B738/toggle_switch/position_light_down", "Position Light Switch Down", B738_position_light_switch_dn_CMDhandler)

-- RUNWAY LIGHT SWITCH
B738CMD_rwy_light_left_on 	= create_command("laminar/B738/switch/rwy_light_left_on", "Runway light left ON", B738_rwy_light_left_on_CMDhandler)
B738CMD_rwy_light_left_off 	= create_command("laminar/B738/switch/rwy_light_left_off", "Runway light left OFF", B738_rwy_light_left_off_CMDhandler)

B738CMD_rwy_light_right_on 	= create_command("laminar/B738/switch/rwy_light_right_on", "Runway light right ON", B738_rwy_light_right_on_CMDhandler)
B738CMD_rwy_light_right_off 	= create_command("laminar/B738/switch/rwy_light_right_off", "Runway light right OFF", B738_rwy_light_right_off_CMDhandler)

-- COMPASS LIGHT SWITCH
B738CMD_compass_brightness_switch_lft 	= create_command("laminar/B738/toggle_switch/compass_brightness_lft", "Standby Compass Light Switch Left", B738_compass_brightness_switch_lft_CMDhandler)
B738CMD_compass_brightness_switch_rgt	= create_command("laminar/B738/toggle_switch/compass_brightness_rgt", "Standby Compass Light Switch Right", B738_compass_brightness_switch_rgt_CMDhandler)


-- COCKPIT DOME LIGHT SWITCH
B738CMD_cockpit_dome_switch_up 	= create_command("laminar/B738/toggle_switch/cockpit_dome_up", "Cockpit Dome Light Switch Up", B738_cockpit_dome_switch_up_CMDhandler)
B738CMD_cockpit_dome_switch_dn	= create_command("laminar/B738/toggle_switch/cockpit_dome_dn", "Cockpit Dome LIght Switch Down", B738_cockpit_dome_switch_dn_CMDhandler)


-- TAXI LIGHT SWITCH
B738CMD_taxi_light_brightness_switch_up	= create_command("laminar/B738/toggle_switch/taxi_light_brightness_pos_up", "Taxi Light Brightness Up", B738_taxi_light_brightness_switch_up_CMDhandler)
B738CMD_taxi_light_brightness_switch_dn	= create_command("laminar/B738/toggle_switch/taxi_light_brightness_pos_dn", "Taxi Light Brightness Down", B738_taxi_light_brightness_switch_dn_CMDhandler)
B738CMD_taxi_light_bright_switch_toggle	= create_command("laminar/B738/toggle_switch/taxi_light_brigh_toggle", "Taxi Light Brightness Toggle", B738_taxi_light_bright_switch_toggle_CMDhandler)


-- LANDING LIGHT ALL
B738CMD_landing_lights_all_on = create_command("laminar/B738/spring_switch/landing_lights_all", "All Landing Lights On", B738_landing_lights_all_on_CMDhandler)
B738CMD_land_lights_ret_left_up = create_command("laminar/B738/switch/land_lights_ret_left_up", "Landing Lights Retract Left Up", B738_land_lights_ret_left_up_CMDhandler)
B738CMD_land_lights_ret_left_dn = create_command("laminar/B738/switch/land_lights_ret_left_dn", "Landing Lights Retract Left Down", B738_land_lights_ret_left_dn_CMDhandler)
B738CMD_land_lights_ret_right_up = create_command("laminar/B738/switch/land_lights_ret_right_up", "Landing Lights Retract Right Up", B738_land_lights_ret_right_up_CMDhandler)
B738CMD_land_lights_ret_right_dn = create_command("laminar/B738/switch/land_lights_ret_right_dn", "Landing Lights Retract Right Down", B738_land_lights_ret_right_dn_CMDhandler)

-- SEAT BELT SIGN SWITCH
B738CMD_seatbelt_sign_switch_up = create_command("laminar/B738/toggle_switch/seatbelt_sign_up", "Seat Belt Switch Up", B738_seatbelt_sign_switch_up_CMDhandler)
B738CMD_seatbelt_sign_switch_dn = create_command("laminar/B738/toggle_switch/seatbelt_sign_dn", "Seat Belt Switch Down", B738_seatbelt_sign_switch_dn_CMDhandler)

-- NO SMOKING SWITCH
B738CMD_no_smoking_up = create_command("laminar/B738/toggle_switch/no_smoking_up", "No Smoking Switch Up", B738_no_smoking_up_CMDhandler)
B738CMD_no_smoking_dn = create_command("laminar/B738/toggle_switch/no_smoking_dn", "No Smoking Switch Down", B738_no_smoking_dn_CMDhandler)

-- IFE PASS SEAT SWITCH
B738CMD_ife_pass_seat_toggle	= create_command("laminar/B738/autopilot/ife_pass_seat_toggle", "IFE PASS SEAT", B738_ife_pass_seat_toggle_CMDhandler)

-- CABIN UTILITY SWITCH
B738CMD_cab_util_toggle			= create_command("laminar/B738/autopilot/cab_util_toggle", "CABIN UTILITY", B738_cab_util_toggle_CMDhandler)

--*************************************************************************************--
--** 				             X-PLANE COMMAND HANDLERS               	    	 **--
--*************************************************************************************--

function B738_landing_lights_on_CMDhandler(phase, duration)
	if phase == 0 then
		if simDR_landing_light_on_0 == 0
		or simDR_landing_light_on_1 == 0
		or simDR_landing_light_on_2 == 0 
		or simDR_landing_light_on_3 == 0 then
			B738DR_land_lights_ret_left_pos = 2		-- landing lights retract
			B738DR_land_lights_ret_right_pos = 2	-- landing lights retract
			simDR_landing_light_on_0 = 1
			simDR_landing_light_on_1 = 1
			simDR_landing_light_on_2 = 1
			simDR_landing_light_on_3 = 1
		end
	end
end

function B738_landing_lights_off_CMDhandler(phase, duration)
	if phase == 0 then
		if simDR_landing_light_on_0 == 1
		and simDR_landing_light_on_1 == 1
		and simDR_landing_light_on_2 == 1 
		and simDR_landing_light_on_3 == 1 then
			B738DR_land_lights_ret_left_pos = 0		-- landing lights retract
			B738DR_land_lights_ret_right_pos = 0	-- landing lights retract
			simDR_landing_light_on_0 = 0
			simDR_landing_light_on_1 = 0
			simDR_landing_light_on_2 = 0
			simDR_landing_light_on_3 = 0
		end
	end
end

function B738_landing_lights_toggle_CMDhandler(phase, duration)
	if phase == 0 then
		if simDR_landing_light_on_0 == 1
		or simDR_landing_light_on_1 == 1
		or simDR_landing_light_on_2 == 1 
		or simDR_landing_light_on_3 == 1 then
			B738DR_land_lights_ret_left_pos = 2		-- landing lights retract
			B738DR_land_lights_ret_right_pos = 2	-- landing lights retract
			simDR_landing_light_on_0 = 1
			simDR_landing_light_on_1 = 1
			simDR_landing_light_on_2 = 1
			simDR_landing_light_on_3 = 1
		else
			B738DR_land_lights_ret_left_pos = 0		-- landing lights retract
			B738DR_land_lights_ret_right_pos = 0	-- landing lights retract
			simDR_landing_light_on_0 = 0
			simDR_landing_light_on_1 = 0
			simDR_landing_light_on_2 = 0
			simDR_landing_light_on_3 = 0
		end
	end
end


--*************************************************************************************--
--** 				             REPLACE X-PLANE COMMANDS                  	    	 **--
--*************************************************************************************--

B738CMD_landing_lights_on		= replace_command("sim/lights/landing_lights_on", B738_landing_lights_on_CMDhandler)
B738CMD_landing_lights_off		= replace_command("sim/lights/landing_lights_off", B738_landing_lights_off_CMDhandler)
B738CMD_landing_lights_toggle		= replace_command("sim/lights/landing_lights_toggle", B738_landing_lights_toggle_CMDhandler)


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

function B738_set_anim_value(current_value, target, min, max, speed)

    if target >= (max - 0.001) and current_value >= (max - 0.01) then
        return max
    elseif target <= (min + 0.001) and current_value <= (min + 0.01) then
        return min
    else
        return current_value + ((target - current_value) * (speed * SIM_PERIOD))
    end

end

function B738_light_state()

	-- captain_main_panel_brg = 0
	-- first_officer_panel_brg = 0
	-- overhead_panel_brg = 0
	-- pedestal_panel_brg = 0

-- POSITION LIGHT SWITCH
	if B738DR_position_light_switch_pos == 0 then
		simCMD_nav_lights_off:once()
		simCMD_strobe_lights_off:once()
	elseif B738DR_position_light_switch_pos == 1 then
		simCMD_nav_lights_on:once()
		simCMD_strobe_lights_on:once()
	elseif B738DR_position_light_switch_pos == -1 then
		simCMD_nav_lights_on:once() 
	end		

-- COMPASS LIGHT SWITCH
	if B738DR_compass_brighness_switch_pos == 0 then
		simDR_compass_brightness_switch = 0
	elseif B738DR_compass_brighness_switch_pos == 1 then
		simDR_compass_brightness_switch = 1
	elseif B738DR_compass_brighness_switch_pos == -1 then
		simDR_compass_brightness_switch = 0.33          
	end		

-- COCKPIT DOME LIGHT SWITCH
	if B738DR_cockpit_dome_switch_pos == 0 then
		simDR_cockpit_dome_switch = 0
	elseif B738DR_cockpit_dome_switch_pos == 1 then
		simDR_cockpit_dome_switch = 0.4
	elseif B738DR_cockpit_dome_switch_pos == -1 then
		simDR_cockpit_dome_switch = 1          
	end		

-- TAXI LIGHT SWITCH
	if B738DR_taxi_light_brightness_switch_pos == 1 then
		simDR_taxi_light_brightness_switch = 0.5
	elseif B738DR_taxi_light_brightness_switch_pos == 0 then
		simDR_taxi_light_brightness_switch = 0
	elseif B738DR_taxi_light_brightness_switch_pos == 2 then
		simDR_taxi_light_brightness_switch = 1         
	end		

-- LANDING LIGHT ALL
	if B738DR_landing_lights_all_on_pos == 1 then
		B738DR_land_lights_ret_left_pos = 2		-- landing lights retract
		B738DR_land_lights_ret_right_pos = 2	-- landing lights retract
		simDR_landing_light_on_0 = 1
		simDR_landing_light_on_1 = 1
		simDR_landing_light_on_2 = 1
		simDR_landing_light_on_3 = 1
	end
	
-- SEAT BELT SIGN SWITCH
	if B738DR_seatbelt_sign_switch_pos == 1 then
		simDR_seatbelt_sign_switch = 1
	elseif B738DR_seatbelt_sign_switch_pos == 0 then
		simDR_seatbelt_sign_switch = 0
	elseif B738DR_seatbelt_sign_switch_pos == 2 then
		simCMD_seatbelt_toggle:once()
		simDR_seatbelt_sign_switch = 2
	end
	
	

end

-- function first_time_timer()
	-- fist_time = 1
-- end

function bus_load()
	
	local bus_load0 = 0
	local bus_load1 = 0
	local cabin_util_disable = 0
	
	local bus1_apu_off = 1
	local bus2_apu_off = 1
	
	if simDR_apu_status > 95 then
		if B738DR_apu_gen1_pos == 1 then
			bus1_apu_off = 0
		end
		if B738DR_apu_gen2_pos == 1 then
			bus2_apu_off = 0
		end
	end
	
	local bus1_gen_off = 1
	local bus2_gen_off = 1
	if simDR_engine1_on == 1 and simDR_gen1_on == 1 then
		bus1_gen_off = 0
	end
	if simDR_engine2_on == 1 and simDR_gen2_on == 1 then
		bus2_gen_off = 0
	end
	
	if B738DR_ife_pass_seat_pos == 1 then
--		if bus1_apu_off == 0 or simDR_gen_off_bus1 == 0 then
			bus_load0 = bus_load0 + 27
--		end
--		if bus2_apu_off == 0 or simDR_gen_off_bus2 == 0 then
			bus_load1 = bus_load1 + 27
--		end
	end
	
	if B738DR_cab_util_pos == 1 then
		-- if simDR_on_ground_0 == 0 
		-- and simDR_on_ground_1 == 0 
		-- and simDR_on_ground_2 == 0 then
		if simDR_radio_height_pilot_ft > 50 then
			-- in flight
			-- APU on bus, GEN off bus
			if bus1_gen_off == 1 and bus2_gen_off == 1 then
				cabin_util_disable = 1
			end
		end
		if cabin_util_disable == 0 then
			-- enable logo lights
			-- enable L and R recirc fans
			if bus1_apu_off == 0 or bus1_gen_off == 0 then
				bus_load0 = bus_load0 + 11
			end
			if bus2_apu_off == 0 or bus2_gen_off == 0 then
				bus_load1 = bus_load1 + 11
			end
		else
			-- disable logo lights
			-- disable L and R recirc fans
		end
	end
	
	simDR_bus_load0 = bus_load0 + B738DR_apu_start_load
	simDR_bus_load1 = bus_load1 + B738DR_apu_start_load

end


function land_ret_anim()
	
	local land_ret_left_tgt = 0
	if B738DR_land_lights_ret_left_pos > 0 then
		land_ret_left_tgt = 1
	end
	
	if B738DR_batbus_status ~= 0 then
		B738DR_land_ret_left_pos = B738_set_anim_value(B738DR_land_ret_left_pos, land_ret_left_tgt, 0, 1, 3)
	end
	
	local land_ret_right_tgt = 0
	if B738DR_land_lights_ret_right_pos > 0 then
		land_ret_right_tgt = 1
	end
	
	if B738DR_batbus_status ~= 0 then
		B738DR_land_ret_right_pos = B738_set_anim_value(B738DR_land_ret_right_pos, land_ret_right_tgt, 0, 1, 3)
	end
	
end



--function aircraft_load() end

--function aircraft_unload() end

function flight_start()

	simDR_compass_brightness_switch = 0
	fist_time = 0
	first_time_enable = 1
	B738_light_state()
end


--function flight_crash() end

--function before_physics() end

function after_physics()
	bus_load()
	land_ret_anim()
end

--function after_replay() end




--*************************************************************************************--
--** 				               SUB-MODULE PROCESSING       	        			 **--
--*************************************************************************************--

-- dofile("")



