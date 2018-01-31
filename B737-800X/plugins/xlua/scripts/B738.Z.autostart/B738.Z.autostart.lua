-- --[[
-- *****************************************************************************************
-- * Program Script Name	:	B738.Z.autostart
-- *
-- * Author Name			:	Alex Unruh, Jim Gregory
-- *
-- *   Revisions:
-- *   -- DATE --	--- REV NO ---		--- DESCRIPTION ---
-- *   
-- *
-- *
-- *
-- *
-- *****************************************************************************************
-- *        COPYRIGHT � 2017 ALEX UNRUH / LAMINAR RESEARCH - ALL RIGHTS RESERVED
-- *****************************************************************************************
-- --]]



-- --*************************************************************************************--
-- --** 					              XLUA GLOBALS              				     **--
-- --*************************************************************************************--

-- --[[

-- SIM_PERIOD - this contains the duration of the current frame in seconds (so it is alway a
-- fraction).  Use this to normalize rates,  e.g. to add 3 units of fuel per second in a
-- per-frame callback you’d do fuel = fuel + 3 * SIM_PERIOD.

-- IN_REPLAY - evaluates to 0 if replay is off, 1 if replay mode is on

-- --]]


-- --*************************************************************************************--
-- --** 					               CONSTANTS                    				 **--
-- --*************************************************************************************--



-- --*************************************************************************************--
-- --** 					            GLOBAL VARIABLES                				 **--
-- --*************************************************************************************--



-- --*************************************************************************************--
-- --** 					            LOCAL VARIABLES                 				 **--
-- --*************************************************************************************--

-- local autoboard = {
    -- step = -1,
    -- phase = {},
    -- sequence_timeout = false
-- }

-- local autostart = {
    -- step = -1,
    -- phase = {},
    -- sequence_timeout = false
-- }


-- --*************************************************************************************--
-- --** 				             FIND X-PLANE DATAREFS            			    	 **--
-- --*************************************************************************************--

-- simDR_startup_running               	= find_dataref("sim/operation/prefs/startup_running")
-- simDR_autoboard_in_progress         	= find_dataref("sim/flightmodel2/misc/auto_board_in_progress")
-- simDR_autostart_in_progress         	= find_dataref("sim/flightmodel2/misc/auto_start_in_progress")

-- simDR_parking_brake						= find_dataref("sim/cockpit2/controls/parking_brake_ratio")
-- simDR_battery_on						= find_dataref("sim/cockpit2/electrical/battery_on[0]")
-- simDR_stby_battery_on					= find_dataref("sim/cockpit2/electrical/battery_on[1]")
-- simDR_apu_running						= find_dataref("sim/cockpit2/electrical/APU_running")
-- simDR_apu_generator_switch				= find_dataref("sim/cockpit2/electrical/APU_generator_on")

-- simDR_yaw_damper_switch					= find_dataref("sim/cockpit2/switches/yaw_damper_on")
-- simDR_window_heat						= find_dataref("sim/cockpit2/ice/ice_window_heat_on")

-- simDR_elec_hydro_pumps_on				= find_dataref("sim/cockpit2/switches/electric_hydraulic_pump_on")
-- simDR_logo_lights_on					= find_dataref("sim/cockpit2/switches/generic_lights_switch[1]")

-- simDR_panel_brightness1					= find_dataref("sim/cockpit2/switches/panel_brightness_ratio[0]")
-- simDR_panel_brightness2					= find_dataref("sim/cockpit2/switches/panel_brightness_ratio[1]")
-- simDR_panel_brightness3					= find_dataref("sim/cockpit2/switches/panel_brightness_ratio[2]")
-- simDR_panel_brightness4					= find_dataref("sim/cockpit2/switches/panel_brightness_ratio[3]")

-- simDR_fuel_tank_pump1					= find_dataref("sim/cockpit2/fuel/fuel_tank_pump_on[0]")
-- simDR_fuel_tank_pump2					= find_dataref("sim/cockpit2/fuel/fuel_tank_pump_on[1]")
-- simDR_fuel_tank_pump3					= find_dataref("sim/cockpit2/fuel/fuel_tank_pump_on[2]")

-- simDR_fuel_selector_l					= find_dataref("sim/cockpit2/fuel/fuel_tank_selector_left")
-- simDR_fuel_selector_r					= find_dataref("sim/cockpit2/fuel/fuel_tank_selector_right")

-- simDR_beacon_on							= find_dataref("sim/cockpit2/switches/beacon_on")

-- simDR_starter_is_running1				= find_dataref("sim/flightmodel2/engines/starter_is_running[0]")
-- simDR_starter_is_running2				= find_dataref("sim/flightmodel2/engines/starter_is_running[1]")

-- simDR_engine1_N2						= find_dataref("sim/cockpit2/engine/indicators/N2_percent[0]")
-- simDR_engine2_N2						= find_dataref("sim/cockpit2/engine/indicators/N2_percent[1]")

-- simDR_generator1_on						= find_dataref("sim/cockpit2/electrical/generator_on[0]")
-- simDR_generator2_on						= find_dataref("sim/cockpit2/electrical/generator_on[1]")

-- simDR_ignition_key1						= find_dataref("sim/cockpit2/engine/actuators/ignition_key[0]")
-- simDR_ignition_key2						= find_dataref("sim/cockpit2/engine/actuators/ignition_key[1]")

-- simDR_bleed_air_mode 					= find_dataref("sim/cockpit2/pressurization/actuators/bleed_air_mode")

-- --*************************************************************************************--
-- --** 				               FIND X-PLANE COMMANDS                   	    	 **--
-- --*************************************************************************************--

-- simCMD_seatbelt_toggle					= find_command("sim/systems/seatbelt_sign_toggle")

-- --*************************************************************************************--
-- --** 				              FIND CUSTOM DATAREFS             			    	 **--
-- --*************************************************************************************--

-- B738DR_init_systems_CD					= find_dataref("laminar/B738/systems/init_CD")
-- B738DR_init_annun_CD					= find_dataref("laminar/B738/annun/init_CD")
-- B738DR_init_chrono_CD					= find_dataref("laminar/B738/chrono/init_CD")
-- B738DR_init_comms_CD					= find_dataref("laminar/B738/comms/init_CD")
-- B738DR_init_fire_CD						= find_dataref("laminar/B738/fire/init_CD")
-- B738DR_init_glare_CD					= find_dataref("laminar/B738/glare/init_CD")
-- B738DR_init_lighting_CD 				= find_dataref("laminar/B738/lighting/init_CD")

-- B738DR_battery_switch_cover_pos			= find_dataref("laminar/B738/button_switch/cover_position[2]")
-- B738DR_stby_battery_switch_cover_pos	= find_dataref("laminar/B738/button_switch/cover_position[3]")

-- B738DR_cockpit_dome_switch_pos			= find_dataref("laminar/B738/toggle_switch/cockpit_dome_pos")
-- simDR_cockpit_dome_switch 				= find_dataref("sim/cockpit2/switches/generic_lights_switch[9]")

-- B738DR_condition_lever1					= find_dataref("laminar/B738/engine/slider/condition_lever1")
-- B738DR_condition_lever2					= find_dataref("laminar/B738/engine/slider/condition_lever2")
-- B738DR_condition_lever1_target			= find_dataref("laminar/B738/engine/slider/condition_lever1_target")
-- B738DR_condition_lever2_target			= find_dataref("laminar/B738/engine/slider/condition_lever2_target")

-- B738DR_ground_power_avail_annun			= find_dataref("laminar/B738/annunciator/ground_power_avail")
-- B738DR_ground_power_switch_pos 			= find_dataref("laminar/B738/toggle_switch/gpu")

-- B738DR_fire_test_switch_pos				= find_dataref("laminar/B738/toggle_switch/fire_test")
-- B738DR_cargo_fire_annuns				= find_dataref("laminar/B738/annunciator/cargo_fire")
-- B738DR_fire_bell_annun					= find_dataref("laminar/B738/annunciator/fire_bell_annun")
-- B738DR_master_caution_light				= find_dataref("laminar/B738/annunciator/master_caution_light")

-- B738DR_seatbelt_sign_switch_pos 		= find_dataref("laminar/B738/toggle_switch/seatbelt_sign_pos")

-- B738DR_apu_gen_off_bus					= find_dataref("laminar/B738/annunciator/apu_gen_off_bus")

-- B738DR_bleed_air_1_switch_position 		= find_dataref("laminar/B738/toggle_switch/bleed_air_1_pos")
-- B738DR_bleed_air_2_switch_position 		= find_dataref("laminar/B738/toggle_switch/bleed_air_2_pos")
-- B738DR_bleed_air_apu_switch_position 	= find_dataref("laminar/B738/toggle_switch/bleed_air_apu_pos")

-- B738DR_yaw_damper 						= find_dataref("laminar/B738/annunciator/yaw_damp")

-- B738DR_window_heat_annun				= find_dataref("laminar/B738/annunciator/window_heat")

-- B738DR_hyd_press_a						= find_dataref("laminar/B738/annunciator/hyd_press_a")
-- B738DR_hyd_press_b						= find_dataref("laminar/B738/annunciator/hyd_press_b")

-- B738DR_position_light_switch_pos		= find_dataref("laminar/B738/toggle_switch/position_light_pos")

-- B738DR_starter_1_pos					= find_dataref("laminar/B738/spring_knob/starter_1")
-- B738DR_starter_2_pos					= find_dataref("laminar/B738/spring_knob/starter_2")

-- B738DR_gen_off_bus1						= find_dataref("laminar/B738/annunciator/gen_off_bus1")
-- B738DR_gen_off_bus2						= find_dataref("laminar/B738/annunciator/gen_off_bus2")

-- B738DR_probes_capt_switch_pos			= find_dataref("laminar/B738/toggle_switch/capt_probes_pos")
-- B738DR_probes_fo_switch_pos				= find_dataref("laminar/B738/toggle_switch/fo_probes_pos")


-- --*************************************************************************************--
-- --** 				              FIND CUSTOM COMMANDS              			     **--
-- --*************************************************************************************--

-- B738CMD_battery_switch_cover			= find_command("laminar/B738/button_switch_cover02")
-- B738CMD_stby_battery_switch_cover		= find_command("laminar/B738/button_switch_cover03")

-- B738CMD_fire_test_switch_lft			= find_command("laminar/B738/toggle_switch/fire_test_lft")
-- B738CMD_fire_test_switch_rgt			= find_command("laminar/B738/toggle_switch/fire_test_rgt")
-- B738CMD_cargo_fire_test_button			= find_command("laminar/B738/push_button/cargo_fire_test_push")
-- B738CMD_fire_bell_light_button1			= find_command("laminar/B738/push_button/fire_bell_light1")
-- B738CMD_master_caution_button1			= find_command("laminar/B738/push_button/master_caution1")

-- B738CMD_apu_starter_switch_up			= find_command("laminar/B738/spring_toggle_switch/APU_start_pos_up")
-- B738CMD_apu_starter_switch_dn			= find_command("laminar/B738/spring_toggle_switch/APU_start_pos_dn")

-- -- BLEED AIR

-- B738CMD_bleed_air_1_on 					= find_command("laminar/B738/toggle_switch/bleed_air_1_on")
-- B738CMD_bleed_air_2_on 					= find_command("laminar/B738/toggle_switch/bleed_air_2_on")

-- B738CMD_bleed_air_apu_on 				= find_command("laminar/B738/toggle_switch/bleed_air_apu_on")
-- B738CMD_bleed_air_apu_off 				= find_command("laminar/B738/toggle_switch/bleed_air_apu_off")

-- B738CMD_hydro_pumps_switch				= find_command("laminar/B738/toggle_switch/hydro_pumps")

-- B738CMD_position_light_switch_dn		= find_command("laminar/B738/toggle_switch/position_light_down")

-- B738CMD_starter1_knob_up				= find_command("laminar/B738/knob/starter1_up")
-- B738CMD_starter2_knob_up				= find_command("laminar/B738/knob/starter2_up")

-- B738CMD_probes_capt_switch_pos_on 		= find_command("laminar/B738/toggle_switch/capt_probes_pos_on")
-- B738CMD_probes_fo_switch_pos_on 		= find_command("laminar/B738/toggle_switch/fo_probes_pos_on")

-- --*************************************************************************************--
-- --** 				        CREATE READ-ONLY CUSTOM DATAREFS               	         **--
-- --*************************************************************************************--


-- B738DR_autostart_timer_running			= create_dataref("laminar/B738/testing/autostart_timer", "number")


-- --*************************************************************************************--
-- --** 				       READ-WRITE CUSTOM DATAREF HANDLERS     	        	     **--
-- --*************************************************************************************--



-- --*************************************************************************************--
-- --** 				       CREATE READ-WRITE CUSTOM DATAREFS                         **--
-- --*************************************************************************************--



-- --*************************************************************************************--
-- --** 				             CUSTOM COMMAND HANDLERS            			     **--
-- --*************************************************************************************--



-- --*************************************************************************************--
-- --** 				              CREATE CUSTOM COMMANDS              			     **--
-- --*************************************************************************************--



-- --*************************************************************************************--
-- --** 				             X-PLANE COMMAND HANDLERS               	    	 **--
-- --*************************************************************************************--

-- function sim_autoboard_CMDhandler(phase, duration)
    -- if phase == 0 then
        -- print("==> AUTOBOARD COMMAND INVOKED")
        -- if simDR_autoboard_in_progress == 0
        -- and simDR_autostart_in_progress == 0
            -- --and autoboard.step < 0
        -- then
            -- simDR_autoboard_in_progress = 1
            -- autoboard.step = 0
            -- autoboard.phase = {}
            -- autoboard.sequence_timeout = false
        -- end
    -- end
-- end

-- function sim_autostart_CMDhandler(phase, duration)
    -- if phase == 0 then
    -- print("==> AUTOSTART COMMAND INVOKED")
        -- if simDR_autoboard_in_progress == 0
            -- and simDR_autostart_in_progress == 0
            -- -- and autostart.step < 0
        -- then
            -- autostart.step = 0
        -- end
    -- end
-- end


-- --*************************************************************************************--
-- --** 				             REPLACE X-PLANE COMMANDS                  	    	 **--
-- --*************************************************************************************--

-- simCMD_autoboard                    = replace_command("sim/operation/auto_board", sim_autoboard_CMDhandler)
-- simCMD_autostart                    = replace_command("sim/operation/auto_start", sim_autostart_CMDhandler)


-- --*************************************************************************************--
-- --** 				              WRAP X-PLANE COMMANDS                  	    	 **--
-- --*************************************************************************************--



-- --*************************************************************************************--
-- --** 					           OBJECT CONSTRUCTORS         		        		 **--
-- --*************************************************************************************--



-- --*************************************************************************************--
-- --** 				                  CREATE OBJECTS              	     			 **--
-- --*************************************************************************************--



-- --*************************************************************************************--
-- --** 				                 SYSTEM FUNCTIONS           	    			 **--
-- --*************************************************************************************--

-- function B738_print_sequence_status(step, phase, message)
    -- local msg = string.format("| Step:%02d/Phase:%02d - %s", step, phase, message)
    -- print(msg)
-- end

-- function B738_print_completed_line()
    -- print("+----------------------------------------------+")
-- end





-- ----- AUTO-BOARD SEQUENCE ---------------------------------------------------------------

-- function B738_autoboard_init()
    -- autoboard.step = -1
    -- autoboard.phase = {}
    -- autoboard.sequence_timeout = false
-- end

-- function B738_print_autoboard_begin()
    -- print("+----------------------------------------------+")
    -- print("|          AUTO-BOARD SEQUENCE BEGIN           |")
    -- print("+----------------------------------------------+")
-- end

-- function B738_print_autoboard_abort()
    -- print("+----------------------------------------------+")
    -- print("|         AUTO-BOARD SEQUENCE ABORTED          |")
    -- print("+----------------------------------------------+")
-- end

-- function B738_print_autoboard_completed()
    -- print("+----------------------------------------------+")
    -- print("|        AUTO-BOARD SEQUENCE COMPLETED         |")
    -- print("+----------------------------------------------+")
-- end

-- function B738_print_autoboard_monitor(step, phase)
    -- B738_print_sequence_status(step, phase, "Monitoring...")
-- end

-- function B738_print_autoboard_timer_start(step, phase)
    -- B738_print_sequence_status(step, phase, "Auto-Board Phase Timer Started...")
-- end

-- function B738_autoboard_phase_monitor(time)
    -- if autoboard.phase[autoboard.step] == 2 then
        -- B738_print_autoboard_monitor(autoboard.step, autoboard.phase[autoboard.step])       -- PRINT THE MONITOR PHASE MESSAGE
        -- if is_timer_scheduled(B738_autoboard_phase_timeout) == false then                   -- START MONITOR TIMER
            -- run_after_time(B738_autoboard_phase_timeout, time)
        -- end
        -- autoboard.phase[autoboard.step] = 3                                                 -- INCREMENT THE PHASE
        -- B738_print_autoboard_timer_start(autoboard.step, autoboard.phase[autoboard.step])   -- PRINT THE TIMER MESSAGE
    -- end
-- end

-- function B738_autoboard_step_failed(step, phase)
    -- B738_print_sequence_status(step, phase, "***  F A I L E D  ***")
    -- autoboard.sequence_timeout = false
    -- autoboard.step = 700
-- end

-- function B738_autoboard_step_completed(step, phase, message)
    -- B738_print_sequence_status(step, phase, message)
    -- B738_print_completed_line()
    -- autoboard.step = autoboard.step + 1.0
    -- autoboard.phase[autoboard.step] = 1
-- end

-- function B738_autoboard_seq_aborted()
    -- B738_print_autoboard_abort()
    -- autoboard.step = 800
-- end

-- function B738_autoboard_seq_completed()
    -- B738_print_autoboard_completed()
    -- autoboard.step = 999
    -- simDR_autoboard_in_progress = 0
-- end

-- function B738_autoboard_phase_timeout()
    -- autoboard.sequence_timeout = true
    -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "Step Has Timed Out...")
-- end




-- function B738_auto_board()

		
	-- ----- SEQUENCE TIMERS -----

	-- B738_cond1_cutoff = function()
		-- if B738DR_condition_lever1 == 1 then
			-- B738DR_condition_lever1_target = 0
		-- end
	-- end
		
	-- B738_cond2_cutoff = function()
		-- if B738DR_condition_lever2 == 1 then
			-- B738DR_condition_lever2_target = 0
		-- end
	-- end

	-- B738_battery = function() simDR_battery_on = 1 end												-- TURN ON BATTERY SWITCH
	
	-- B738_stby_battery = function() simDR_stby_battery_on = 1 end									-- TURN ON STBY BATTERY SWITCH

	-- B738_fire_test_off = function()
		-- if B738DR_fire_test_switch_pos == -1 then
			-- B738CMD_fire_test_switch_rgt:once()
		-- elseif B738DR_fire_test_switch_pos == 1 then
			-- B738CMD_fire_test_switch_lft:once()
		-- end
	-- end

	-- B738_cargo_test = function()
		-- B738CMD_cargo_fire_test_button:once()
		-- end

	-- B738_fire_warn = function()
		-- B738CMD_fire_bell_light_button1:once()
		-- end
		
	-- B738_master_caution = function()
		-- B738CMD_master_caution_button1:once()
		-- end

	-- B738_seat_belts	= function()
		-- if B738DR_seatbelt_sign_switch_pos == 0 then
			-- B738DR_seatbelt_sign_switch_pos = 1
			-- simCMD_seatbelt_toggle:once()
		-- end
	-- end

	-- B738_apu_gen = function()
		-- simDR_apu_generator_switch = 1
		-- end
		
	-- B738_apu_bleed_on = function()
		-- if B738DR_bleed_air_apu_switch_position == 0 then
			-- B738CMD_bleed_air_apu_on:once()	
		-- end
	-- end
	
	-- B738_apu_bleed_off = function()
		-- if B738DR_bleed_air_apu_switch_position == 1 then
			-- B738CMD_bleed_air_apu_off:once()	
		-- end
	-- end

	-- B738_yaw_damper_on = function()
		-- if simDR_yaw_damper_switch == 0 then
			-- simDR_yaw_damper_switch = 1
		-- elseif simDR_yaw_damper_switch == 1 then
			-- simDR_yaw_damper_switch = 1
		-- end
	-- end

	-- B738_position_lights_steady = function()
		-- if B738DR_position_light_switch_pos == 1 then
			-- B738CMD_position_light_switch_dn:once()
			-- B738CMD_position_light_switch_dn:once()
		-- elseif B738DR_position_light_switch_pos == 0 then
			-- B738CMD_position_light_switch_dn:once()
		-- elseif B738DR_position_light_switch_pos == -1 then
		-- end
	-- end

	-- B738_panel_bright1 = function() simDR_panel_brightness1 = 0.75
	-- end
	-- B738_panel_bright2 = function() simDR_panel_brightness2 = 0.75
	-- end
	-- B738_panel_bright3 = function() simDR_panel_brightness3 = 0.75
	-- end
	-- B738_panel_bright4 = function() simDR_panel_brightness4 = 0.75
	-- end
	


    -- ----- AUTO-BOARD STEP 0: COMMAND HAS BEEN INVOKED
    -- if autoboard.step == 0 then
        -- B738_print_autoboard_begin()                                                        -- PRINT THE AUTO-BOARD HEADER
        -- autoboard.step = 1                                                                  -- SET THE STEP
        -- autoboard.phase[autoboard.step] = 1                                                 -- SET THE PHASE


    -- ----- AUTO-BOARD STEP 1: INIT COLD & DARK
    -- elseif autoboard.step == 1 then

        -- -- PHASE 1: SET THE FLAG
        -- if autoboard.phase[autoboard.step] == 1 then
           -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "Initialize Aircraft Cold & Dark...")  -- PRINT THE START PHASE MESSAGE
           
			-- B738DR_init_systems_CD = 1
			-- B738DR_init_annun_CD = 1
			-- B738DR_init_chrono_CD = 1
			-- B738DR_init_comms_CD = 1
 			-- B738DR_init_fire_CD = 1
			-- B738DR_init_glare_CD = 1
			-- B738DR_init_lighting_CD = 1
			
 			-- autoboard.phase[autoboard.step] = 2                                             -- INCREMENT THE PHASE

        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(5.0)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- --end
            -- elseif B738DR_init_systems_CD == 2                                                -- PHASE WAS SUCCESSFUL, ALL SCRIPTS HAVE BEEN INITIALIZED TO COLD & DARK
                -- and B738DR_init_annun_CD == 2
                -- and B738DR_init_chrono_CD == 2
                -- and B738DR_init_comms_CD == 2
                -- and B738DR_init_fire_CD == 2
                -- and B738DR_init_glare_CD == 2
                -- and B738DR_init_lighting_CD == 2
              
            -- then
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
               
					-- B738DR_init_systems_CD = 0
					-- B738DR_init_annun_CD = 0
					-- B738DR_init_chrono_CD = 0
					-- B738DR_init_comms_CD = 0
					-- B738DR_init_fire_CD = 0
					-- B738DR_init_glare_CD = 0
					-- B738DR_init_lighting_CD = 0  
            
            -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
        -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "Completed, Aircraft is Cold & Dark")
        -- end    
    

	-- ----- AUTO-BOARD STEP 2: SET PARKING BRAKE
    -- elseif autoboard.step == 2 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autoboard.phase[autoboard.step] == 1 then
            -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "PARKING BRAKE TO FULL...")  -- PRINT THE START PHASE MESSAGE
            -- simDR_parking_brake = 1.0                                         				-- SET BRAKE
            -- autoboard.phase[autoboard.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(1.0)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- elseif simDR_parking_brake == 1
            -- then                                                                            -- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "PARKING BRAKE SET")
        -- end

        
	-- ----- AUTO-BOARD STEP 3: OPEN BATTERY MASTER COVER
    -- elseif autoboard.step == 3 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autoboard.phase[autoboard.step] == 1 then
            -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "BATTERY MASTER COVER...")  -- PRINT THE START PHASE MESSAGE
			-- if simDR_battery_on == 0 then
				-- B738CMD_battery_switch_cover:once()											-- OPEN BATTERY SWITCH COVER
			-- end
			-- autoboard.phase[autoboard.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(1.5)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- elseif B738DR_battery_switch_cover_pos == 1
            -- then                                                                            -- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "BATTERY MASTER COVER OPEN")
        -- end

	-- ----- AUTO-BOARD STEP 4: TURN ON BATTERY MASTER
    -- elseif autoboard.step == 4 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autoboard.phase[autoboard.step] == 1 then
            -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "BATTERY MASTER TO ON...")  -- PRINT THE START PHASE MESSAGE
			 -- run_after_time(B738_battery, 0.3)												 -- BATTERY ON
			 -- autoboard.phase[autoboard.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(2.0)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- elseif simDR_battery_on == 1
            -- then                                                                            -- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "BATTERY MASTER ON")
        -- end

	-- ----- AUTO-BOARD STEP 5: OPEN BATTERY MASTER COVER
    -- elseif autoboard.step == 5 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autoboard.phase[autoboard.step] == 1 then
            -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "STBY POWER COVER...")  -- PRINT THE START PHASE MESSAGE
			-- if simDR_stby_battery_on == 0 then
				-- B738CMD_stby_battery_switch_cover:once()									-- OPEN STBY POWER SWITCH COVER
			-- end
			-- autoboard.phase[autoboard.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(1.5)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- elseif B738DR_stby_battery_switch_cover_pos == 1
            -- then                                                                            -- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "STBY POWER COVER OPEN")
        -- end

	-- ----- AUTO-BOARD STEP 6: TURN ON STBY BATTERY
    -- elseif autoboard.step == 6 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autoboard.phase[autoboard.step] == 1 then
            -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "STANDBY POWER TO ON...")  -- PRINT THE START PHASE MESSAGE
			-- run_after_time(B738_stby_battery, 0.3)											-- TURN ON STBY POWER
            -- autoboard.phase[autoboard.step] = 2                                            	-- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(2.0)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- elseif simDR_stby_battery_on == 1
            -- then                                                                            -- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "STANDBY POWER ON")
        -- end


	-- ----- AUTO-BOARD STEP 7: TURN ON DOME LIGHT
    -- elseif autoboard.step == 7 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autoboard.phase[autoboard.step] == 1 then
            -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "DOME LIGHT TO BRT...")  -- PRINT THE START PHASE MESSAGE
			-- B738DR_cockpit_dome_switch_pos = -1												-- DOME LIGHT SWITCH TO BRT
			-- simDR_cockpit_dome_switch = 1
           	-- autoboard.phase[autoboard.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(1.0)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- elseif simDR_cockpit_dome_switch == 1
            -- then                                                                            -- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "DOME LIGHT ON")
        -- end


	-- ----- AUTO-BOARD STEP 8: CYCLE CONDITION LEVER 1 TO IDLE
    -- elseif autoboard.step == 8 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autoboard.phase[autoboard.step] == 1 then
            -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "CYCLE CONDITION LEVER 1 TO IDLE...")  -- PRINT THE START PHASE MESSAGE
            -- B738DR_condition_lever1_target = 1												-- COND LEVER 1 TO IDLE
			-- autoboard.phase[autoboard.step] = 2                                 	        -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(3.0)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- elseif B738DR_condition_lever1 == 1
            -- then                                                                            -- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "CONDITION LEVER 1 TO IDLE")
        -- end

	-- ----- AUTO-BOARD STEP 9: CYCLE CONDITION LEVER 1 TO CUTOFF
    -- elseif autoboard.step == 9 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autoboard.phase[autoboard.step] == 1 then
            -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "CYCLE CONDITION LEVER 1 TO CUTOFF...")  -- PRINT THE START PHASE MESSAGE
			-- run_after_time(B738_cond1_cutoff, 0.5)											-- COND LEVER 1 TO CUTOFF
			-- autoboard.phase[autoboard.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(3.0)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- elseif B738DR_condition_lever1 == 0
            -- then                                                                            -- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "CONDITION LEVER 1 TO CUTOFF")
        -- end

	-- ----- AUTO-BOARD STEP 10: CYCLE CONDITION LEVER 2 TO IDLE
    -- elseif autoboard.step == 10 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autoboard.phase[autoboard.step] == 1 then
            -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "CYCLE CONDITION LEVER 2 TO IDLE...")  -- PRINT THE START PHASE MESSAGE
            -- B738DR_condition_lever2_target = 1												-- COND LEVER 2 TO IDLE
			-- autoboard.phase[autoboard.step] = 2                                 	        -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(3.0)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- elseif B738DR_condition_lever2 == 1
            -- then                                                                            -- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "CONDITION LEVER 2 TO IDLE")
        -- end

	-- ----- AUTO-BOARD STEP 11: CYCLE CONDITION LEVER 2 TO CUTOFF
    -- elseif autoboard.step == 11 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autoboard.phase[autoboard.step] == 1 then
            -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "CYCLE CONDITION LEVER 2 TO CUTOFF...")  -- PRINT THE START PHASE MESSAGE
			-- run_after_time(B738_cond2_cutoff, 0.5)											-- COND LEVER 2 TO CUTOFF
			-- autoboard.phase[autoboard.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(3.0)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- elseif B738DR_condition_lever2 == 0
            -- then                                                                            -- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "CONDITION LEVER 2 TO CUTOFF")
        -- end

	-- ----- AUTO-BOARD STEP 12: GROUND POWER ON IF AVAILABLE
    -- elseif autoboard.step == 12 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autoboard.phase[autoboard.step] == 1 then
            -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "GROUND POWER TO ON...")  -- PRINT THE START PHASE MESSAGE
			-- if B738DR_ground_power_avail_annun == 1 then									-- IF GPU AVAIL
				-- B738DR_ground_power_switch_pos = 1											-- TURN ON
			-- elseif B738DR_ground_power_avail_annun == 0 then								-- IF GPU NOT AVAIL
				-- B738DR_ground_power_switch_pos = 0											-- IGNORE
			-- end
           	-- autoboard.phase[autoboard.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(1.0)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- elseif B738DR_ground_power_switch_pos == 1 or
            	-- B738DR_ground_power_switch_pos == 0
            -- then                                                                            -- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "GROUND POWER ON")
        -- end

	-- ----- AUTO-BOARD STEP 13: FIRE TEST TO FAULT / INOP
    -- elseif autoboard.step == 13 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autoboard.phase[autoboard.step] == 1 then
            -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "FIRE TEST TO FAULT/INOP...")  -- PRINT THE START PHASE MESSAGE										
			-- B738CMD_fire_test_switch_lft:once()												-- SWITCH ENGAGED TO FAULT/INOP
           	-- autoboard.phase[autoboard.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(1.0)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- elseif B738DR_fire_test_switch_pos == -1
            -- then                                                                            -- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "FAULT/INOP TEST")
        -- end
        
	-- ----- AUTO-BOARD STEP 14: FIRE TEST TO OFF
    -- elseif autoboard.step == 14 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autoboard.phase[autoboard.step] == 1 then
            -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "FIRE TEST TO OFF...")  -- PRINT THE START PHASE MESSAGE										
			-- run_after_time(B738_fire_test_off, 0.8)													-- SWITCH ENGAGED TO NEUTRAL
           	-- autoboard.phase[autoboard.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(1.5)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- elseif B738DR_fire_test_switch_pos == 0
            -- then                                                                            -- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "FIRE TEST OFF")
        -- end
 

	-- ----- AUTO-BOARD STEP 15: FIRE TEST TO OVHT/FIRE
    -- elseif autoboard.step == 15 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autoboard.phase[autoboard.step] == 1 then
            -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "FIRE TEST TO OVHT/FIRE...")  -- PRINT THE START PHASE MESSAGE										
			-- B738CMD_fire_test_switch_rgt:once()												-- SWITCH ENGAGED OVHT/FIRE
           	-- autoboard.phase[autoboard.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(1.0)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- elseif B738DR_fire_test_switch_pos == 1
            -- then                                                                            -- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "OVHT/FIRE TEST")
        -- end

 
 	-- ----- AUTO-BOARD STEP 16: FIRE TEST TO OFF
    -- elseif autoboard.step == 16 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autoboard.phase[autoboard.step] == 1 then
            -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "FIRE TEST TO OFF...")  -- PRINT THE START PHASE MESSAGE										
			-- run_after_time(B738_fire_test_off, 0.8)													-- SWITCH ENGAGED TO NEUTRAL
           	-- autoboard.phase[autoboard.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(1.5)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- elseif B738DR_fire_test_switch_pos == 0
            -- then                                                                            -- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "FIRE TEST OFF")
        -- end

	-- ----- AUTO-BOARD STEP 17: CARGO FIRE PANEL TEST
    -- elseif autoboard.step == 17 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autoboard.phase[autoboard.step] == 1 then
            -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "TEST CARGO FIRE PANEL...")  -- PRINT THE START PHASE MESSAGE										
			-- run_after_time(B738_cargo_test, 0.8)											-- CARGO FIRE TEST BUTTON
           	-- autoboard.phase[autoboard.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(2)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- elseif B738DR_cargo_fire_annuns == 1
            -- then                                                                            -- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
					-- stop_timer(B738_cargo_test)
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "CARGO FIRE PANEL TEST ENGAGED")
        -- end

	-- ----- AUTO-BOARD STEP 18: FIRE WARNING BUTTON
    -- elseif autoboard.step == 18 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autoboard.phase[autoboard.step] == 1 then
            -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "PRESS FIRE WARN BUTTON...")  -- PRINT THE START PHASE MESSAGE										
			-- run_after_time(B738_fire_warn, 0.8)												-- FIRE WARN BUTTON
           	-- autoboard.phase[autoboard.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(1.5)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- elseif B738DR_fire_bell_annun == 0
            -- then                                                                            -- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "FIRE WARNING CLEARED")
        -- end

	-- ----- AUTO-BOARD STEP 19: MASTER CAUTION
    -- elseif autoboard.step == 19 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autoboard.phase[autoboard.step] == 1 then
            -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "PRESS MASTER CAUTION...")  -- PRINT THE START PHASE MESSAGE										
			-- run_after_time(B738_master_caution, 0.8)										-- MASTER CAUTION BUTTON
           	-- autoboard.phase[autoboard.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(1.5)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- elseif B738DR_master_caution_light == 0
            -- then                                                                            -- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "MASTER CAUTION CLEARED, FIRE TEST COMPLETE")
        -- end



	-- ----- AUTO-BOARD STEP 20: FASTEN SEATBELTS TO AUTO
    -- elseif autoboard.step == 20 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autoboard.phase[autoboard.step] == 1 then
            -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "SEATBELTS TO AUTO...")  -- PRINT THE START PHASE MESSAGE										
			-- run_after_time(B738_seat_belts, 0.5)											-- SEAT BELTS TO AUTO
           	-- autoboard.phase[autoboard.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(1.5)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- elseif B738DR_seatbelt_sign_switch_pos == 1
            -- then                                                                            -- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "SEATBELTS SIGNS AUTO")
        -- end

	-- ----- AUTO-BOARD STEP 21: APU START
    -- elseif autoboard.step == 21 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autoboard.phase[autoboard.step] == 1 then
            -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "START APU...")  -- PRINT THE START PHASE MESSAGE										
			-- B738CMD_apu_starter_switch_dn:once()											-- APU SWITCH TO ON
			-- B738CMD_apu_starter_switch_dn:start()											-- APU SWITCH TO START
			-- autoboard.phase[autoboard.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(1.5)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- elseif simDR_apu_running == 1
            -- then                                                                            -- PHASE WAS SUCCESSFUL
            	-- B738CMD_apu_starter_switch_dn:stop()
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "APU HAS STARTED")
        -- end

	-- ----- AUTO-BOARD STEP 22: WAIT FOR APU TO SPIN UP
    -- elseif autoboard.step == 22 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autoboard.phase[autoboard.step] == 1 then
            -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "WAIT FOR APU TO FINISH STARTING...")  -- PRINT THE START PHASE MESSAGE										
			-- B738CMD_apu_starter_switch_dn:stop()											-- APU SWITCH TO ON
			-- autoboard.phase[autoboard.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(20.0)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- elseif B738DR_apu_gen_off_bus > 0.4
            -- then                                                                            -- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "APU IS RUNNING")
        -- end

	-- ----- AUTO-BOARD STEP 23: APU GENERATOR ON
    -- elseif autoboard.step == 23 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autoboard.phase[autoboard.step] == 1 then
            -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "SET APU GENERATORS TO ON...")  -- PRINT THE START PHASE MESSAGE										
			-- run_after_time(B738_apu_gen, 0.5)												-- APU GEN TO ON
			-- autoboard.phase[autoboard.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(1.0)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- elseif simDR_apu_generator_switch == 1
            -- then                                                                            -- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "APU GENERATOR ON")
        -- end


	-- ----- AUTO-BOARD STEP 24: APU BLEED ON
    -- elseif autoboard.step == 24 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autoboard.phase[autoboard.step] == 1 then
            -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "SET APU BLEED AIR TO ON...")  -- PRINT THE START PHASE MESSAGE										
			-- run_after_time(B738_apu_bleed_on, 0.5)											-- APU BLEED TO ON
			-- autoboard.phase[autoboard.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(1.0)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- elseif B738DR_bleed_air_apu_switch_position == 1
            -- then                                                                            -- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "APU BLEED ON")
        -- end

	-- ----- AUTO-BOARD STEP 25: YAW DAMPER ON
    -- elseif autoboard.step == 25 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autoboard.phase[autoboard.step] == 1 then
            -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "SET YAW DAMPER TO ON...")  -- PRINT THE START PHASE MESSAGE										
			-- run_after_time(B738_yaw_damper_on, 0.5)											-- YAW DAMPER TO ON
			-- autoboard.phase[autoboard.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(1.0)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- elseif B738DR_yaw_damper == 0
            -- then                                                                            -- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "YAW DAMPER ON")
        -- end

	-- ----- AUTO-BOARD STEP 26: WINDOW HEAT ON
    -- elseif autoboard.step == 26 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autoboard.phase[autoboard.step] == 1 then
            -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "SET WINDOW HEAT TO ON...")  -- PRINT THE START PHASE MESSAGE										
			-- simDR_window_heat = 1															-- WINDOW HEAT TO ON
			-- autoboard.phase[autoboard.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(1.0)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- elseif B738DR_window_heat_annun == 1
            -- then                                                                            -- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "WINDOW HEAT ON")
        -- end

	-- ----- AUTO-BOARD STEP 27: HYDRAULIC PUMPS ON
    -- elseif autoboard.step == 27 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autoboard.phase[autoboard.step] == 1 then
            -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "SET HYDRAULIC PUMPS TO ON...")  -- PRINT THE START PHASE MESSAGE										
			-- simDR_elec_hydro_pumps_on = 1													-- ELEC PUMPS TO ON
			-- B738CMD_hydro_pumps_switch:once()												-- ENG PUMPS TO ON
			-- autoboard.phase[autoboard.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(2.0)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- elseif B738DR_hyd_press_a == 0 and
            		-- B738DR_hyd_press_b == 0
            -- then                                                                            -- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "HYDRAULIC PUMPS ON")
        -- end
        
	-- ----- AUTO-BOARD STEP 28: NAV LIGHTS ON
    -- elseif autoboard.step == 28 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autoboard.phase[autoboard.step] == 1 then
            -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "SET POSITION LIGHTS TO STEADY...")  -- PRINT THE START PHASE MESSAGE										
			-- run_after_time(B738_position_lights_steady, 0.5)								-- POSITION LIGHTS TO STEADY
			-- autoboard.phase[autoboard.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(2.0)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- elseif B738DR_position_light_switch_pos == -1
			-- then                                                                           -- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "POSITION LIGHTS ON")
        -- end

	-- ----- AUTO-BOARD STEP 29: LOGO LIGHTS ON
    -- elseif autoboard.step == 29 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autoboard.phase[autoboard.step] == 1 then
            -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "TURN LOGO LIGHTS TO ON...")  -- PRINT THE START PHASE MESSAGE										
			-- simDR_logo_lights_on = 1														-- LOGO LIGHTS ON
			-- autoboard.phase[autoboard.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(1.0)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- elseif simDR_logo_lights_on == 1
			-- then                                                                           -- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "LOGO LIGHTS ON")
        -- end

	-- ----- AUTO-BOARD STEP 30: PANEL BACKLIGHTING ON
    -- elseif autoboard.step == 30 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autoboard.phase[autoboard.step] == 1 then
            -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "TURN PANEL BACKLIGHTING ON...")  -- PRINT THE START PHASE MESSAGE										
			-- run_after_time(B738_panel_bright1, 0.5)											-- PANEL BACKLIGHTS ON
			-- run_after_time(B738_panel_bright2, 1.0)
			-- run_after_time(B738_panel_bright3, 1.5)
			-- run_after_time(B738_panel_bright4, 2.0)
			-- autoboard.phase[autoboard.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(4.0)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- elseif simDR_panel_brightness4 > 0.7
			-- then                                                                           -- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "LOGO LIGHTS ON")
        -- end

	-- ----- AUTO-BOARD STEP 31: TURN OFF DOME LIGHT
    -- elseif autoboard.step == 31 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autoboard.phase[autoboard.step] == 1 then
            -- B738_print_sequence_status(autoboard.step, autoboard.phase[autoboard.step], "DOME LIGHT TO OFF...")  -- PRINT THE START PHASE MESSAGE
			-- B738DR_cockpit_dome_switch_pos = 0												-- DOME LIGHT SWITCH TO OFF
			-- simDR_cockpit_dome_switch = 0
           	-- autoboard.phase[autoboard.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autoboard_phase_monitor(1.0)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autoboard.phase[autoboard.step] == 3 then
            -- if autoboard.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autoboard_step_failed(autoboard.step, autoboard.phase[autoboard.step])
            -- elseif simDR_cockpit_dome_switch == 0
            -- then                                                                            -- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autoboard_phase_timeout) == true then
                    -- stop_timer(B738_autoboard_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autoboard.phase[autoboard.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autoboard.phase[autoboard.step] == 4 then
            -- B738_autoboard_step_completed(autoboard.step, autoboard.phase[autoboard.step], "DOME LIGHT OFF")
        -- end


   -- ----- AUTOBOARD SEQUENCE COMPLETED
    -- autoboard.step = 888


   -- ----- AUTO-BOARD STEP 700: ABORT
   -- elseif autoboard.step == 700 then
        -- B738_autoboard_seq_aborted()

		-- simDR_autoboard_in_progress = 0
		-- simDR_autostart_in_progress = 0



    -- ----- AUTO-BOARD STEP 888: SEQUENCE COMPLETED
    -- elseif autoboard.step == 888 then
        -- B738_autoboard_seq_completed()
        -- --B738_autostart_init()

   -- end  -- AUTO-BOARD STEPS

-- end -- AUTO-BOARD SEQUENCE






-- ----- AUTO-START SEQUENCE ---------------------------------------------------------------

-- function B738_autostart_init()
    -- autostart.step = -1
    -- autostart.phase = {}
    -- autostart.sequence_timeout = false
-- end

-- function B738_print_autostart_begin()
    -- print("+----------------------------------------------+")
    -- print("|          AUTO-START SEQUENCE BEGIN           |")
    -- print("+----------------------------------------------+")
-- end

-- function B738_print_autostart_abort()
    -- print("+----------------------------------------------+")
    -- print("|         AUTO-START SEQUENCE ABORTED          |")
    -- print("+----------------------------------------------+")
-- end

-- function B738_print_autostart_completed()
    -- print("+----------------------------------------------+")
    -- print("|        AUTO-START SEQUENCE COMPLETED         |")
    -- print("+----------------------------------------------+")
-- end

-- function B738_print_autostart_monitor(step, phase)
    -- B738_print_sequence_status(step, phase, "Monitoring...")
-- end

-- function B738_print_autostart_timer_start(step, phase)
    -- B738_print_sequence_status(step, phase, "Auto-Start Phase Timer Started...")
-- end

-- function B738_autostart_phase_monitor(time)
    -- if autostart.phase[autostart.step] == 2 then
        -- B738_print_autostart_monitor(autostart.step, autostart.phase[autostart.step])       -- PRINT THE MONITOR PHASE MESSAGE
        -- if is_timer_scheduled(B738_autostart_phase_timeout) == false then                   -- START MONITOR TIMER
            -- run_after_time(B738_autostart_phase_timeout, time)
        -- end
        -- autostart.phase[autostart.step] = 3                                                 -- INCREMENT THE PHASE
        -- B738_print_autostart_timer_start(autostart.step, autostart.phase[autostart.step])   -- PRINT THE TIMER MESSAGE
    -- end
-- end

-- function B738_autostart_step_failed(step, phase)
    -- B738_print_sequence_status(step, phase, "***  F A I L E D  ***")
    -- autostart.sequence_timeout = false
    -- autostart.step = 700
-- end

-- function B738_autostart_step_completed(step, phase, message)
    -- B738_print_sequence_status(step, phase, message)
    -- B738_print_completed_line()
    -- autostart.step = autostart.step + 1.0
    -- autostart.phase[autostart.step] = 1
-- end

-- function B738_autostart_seq_aborted()
    -- B738_print_autostart_abort()
    -- autostart.step = 800
-- end

-- function B738_autostart_seq_completed()
    -- B738_print_autostart_completed()
    -- autostart.step = 999
    -- simDR_autostart_in_progress = 0
-- end

-- function B738_autostart_phase_timeout()
    -- autostart.sequence_timeout = true
    -- B738_print_sequence_status(autostart.step, autostart.phase[autostart.step], "Step Has Timed Out...")
-- end





-- function B738_auto_start()

	
	-- ----- SEQUENCE TIMED FUNCTIONS -----
	
	-- B738_fuel_pump2 = function() simDR_fuel_tank_pump2 = 1 end
	
	-- B738_fuel_pump3 = function() simDR_fuel_tank_pump3 = 1 end

	-- B738_beacon_on = function() simDR_beacon_on = 1 end

	-- B738_bleed1_on	= function() B738CMD_bleed_air_1_on:once() end
	
	-- B738_bleed2_on	= function() B738CMD_bleed_air_2_on:once() end

	-- B738_apu_bleed_off = function() B738CMD_bleed_air_apu_off:once() end

	-- B738_apu_switch_up = function() B738CMD_apu_starter_switch_up:once() end

	
	-- B738_starter1_engage = function()
		-- B738DR_starter_1_pos = -1
		-- simDR_ignition_key1 = 4
	-- end

    -- ----- AUTO-START STEP 0: COMMAND HAS BEEN INVOKED
    -- if autostart.step == 0 then

        -- -- RUN AUTOBOARD SEQUENCE IF NOT ALREADY PROCESSED
        -- if autoboard.step < 0 then
            -- simCMD_autoboard:once()
        -- else
            -- -- AUTOBOARD SEQUENCE COMPLETED: BEGIN AUTOSTART
            -- if autoboard.step == 999 then
                -- simDR_autostart_in_progress = 1
                -- B738_print_autostart_begin()
                -- autostart.step = 1
                -- autostart.phase[autostart.step] = 1
                -- B738_autoboard_init()
            -- end
        -- end

    -- ----- AUTO-START STEP 1: LEFT FUEL PUMPS ON
    -- elseif autostart.step == 1 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autostart.phase[autostart.step] == 1 then
            -- B738_print_sequence_status(autostart.step, autostart.phase[autostart.step], "LEFT FUEL PUMPS TO ON...")  -- PRINT THE START PHASE MESSAGE
            -- simDR_fuel_tank_pump1 = 1														-- FUEL PUMPS L ON
            -- autostart.phase[autostart.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autostart_phase_monitor(2.0)


        -- -- PHASE 3: MONITOR THE STATUS
        -- if autostart.phase[autostart.step] == 3 then
            -- if autostart.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autostart_step_failed(autostart.step, autostart.phase[autostart.step])
            -- elseif simDR_fuel_tank_pump1 == 1 
				-- then                                          								-- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autostart_phase_timeout) == true then
                    -- stop_timer(B738_autostart_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autostart.phase[autostart.step] = 4                                         -- INCREMENT THE PHASE
            -- end
        -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autostart.phase[autostart.step] == 4 then
            -- B738_autostart_step_completed(autostart.step, autostart.phase[autostart.step], "LEFT FUEL PUMPS ON")
        -- end


    -- ----- AUTO-START STEP 2: CENTER FUEL PUMPS ON
    -- elseif autostart.step == 2 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autostart.phase[autostart.step] == 1 then
            -- B738_print_sequence_status(autostart.step, autostart.phase[autostart.step], "CENTER FUEL PUMPS TO ON...")  -- PRINT THE START PHASE MESSAGE
            -- run_after_time(B738_fuel_pump2, 0.5)											-- FUEL PUMPS C ON
            -- autostart.phase[autostart.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autostart_phase_monitor(2.0)

        -- -- PHASE 3: MONITOR THE STATUS
        -- if autostart.phase[autostart.step] == 3 then
            -- if autostart.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autostart_step_failed(autostart.step, autostart.phase[autostart.step])
            -- elseif simDR_fuel_tank_pump2 == 1 
				-- then                                          								-- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autostart_phase_timeout) == true then
                    -- stop_timer(B738_fuel_pump2)
                    -- stop_timer(B738_autostart_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autostart.phase[autostart.step] = 4                                         -- INCREMENT THE PHASE
            -- end
        -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autostart.phase[autostart.step] == 4 then
            -- B738_autostart_step_completed(autostart.step, autostart.phase[autostart.step], "CENTER FUEL PUMPS ON")
        -- end


    -- ----- AUTO-START STEP 3: RIGHT FUEL PUMPS ON
    -- elseif autostart.step == 3 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autostart.phase[autostart.step] == 1 then
            -- B738_print_sequence_status(autostart.step, autostart.phase[autostart.step], "RIGHT FUEL PUMPS TO ON...")  -- PRINT THE START PHASE MESSAGE
            -- run_after_time(B738_fuel_pump3, 0.5)											-- FUEL PUMPS R ON
            -- autostart.phase[autostart.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autostart_phase_monitor(2.0)

        -- -- PHASE 3: MONITOR THE STATUS
        -- if autostart.phase[autostart.step] == 3 then
            -- if autostart.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autostart_step_failed(autostart.step, autostart.phase[autostart.step])
            -- elseif simDR_fuel_tank_pump3 == 1 
				-- then                                          								-- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autostart_phase_timeout) == true then
					-- stop_timer(B738_fuel_pump3)
                    -- stop_timer(B738_autostart_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autostart.phase[autostart.step] = 4                                         -- INCREMENT THE PHASE
            -- end
        -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autostart.phase[autostart.step] == 4 then
            -- B738_autostart_step_completed(autostart.step, autostart.phase[autostart.step], "RIGHT FUEL PUMPS ON")
        -- end



    -- ----- AUTO-START STEP 4: ANTI-COLLISION LIGHTS ON
    -- elseif autostart.step == 4 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autostart.phase[autostart.step] == 1 then
            -- B738_print_sequence_status(autostart.step, autostart.phase[autostart.step], "ANTI-COLLISION LIGHTS TO ON...")  -- PRINT THE START PHASE MESSAGE
            -- run_after_time(B738_beacon_on, 0.5)												-- BEACON SWITCH ON
            -- autostart.phase[autostart.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autostart_phase_monitor(1.0)

        -- -- PHASE 3: MONITOR THE STATUS
        -- if autostart.phase[autostart.step] == 3 then
            -- if autostart.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autostart_step_failed(autostart.step, autostart.phase[autostart.step])
            -- elseif simDR_beacon_on == 1
            	-- then                                                						-- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autostart_phase_timeout) == true then
					-- stop_timer(B738_beacon_on)
                    -- stop_timer(B738_autostart_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autostart.phase[autostart.step] = 4                                         -- INCREMENT THE PHASE
            -- end
        -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autostart.phase[autostart.step] == 4 then
            -- B738_autostart_step_completed(autostart.step, autostart.phase[autostart.step], "ANTI-COLLISION LIGHTS ON")
        -- end

    -- ----- AUTO-START STEP 5: GROUND POWER OFF
    -- elseif autostart.step == 5 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autostart.phase[autostart.step] == 1 then
            -- B738_print_sequence_status(autostart.step, autostart.phase[autostart.step], "GROUND POWER TO OFF...")  -- PRINT THE START PHASE MESSAGE
            -- B738DR_ground_power_switch_pos = 0												-- GROUND POWER OFF
            -- autostart.phase[autostart.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autostart_phase_monitor(1.0)

        -- -- PHASE 3: MONITOR THE STATUS
        -- if autostart.phase[autostart.step] == 3 then
            -- if autostart.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autostart_step_failed(autostart.step, autostart.phase[autostart.step])
            -- elseif B738DR_ground_power_switch_pos == 0
            	-- then                                                						-- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autostart_phase_timeout) == true then
                    -- stop_timer(B738_autostart_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autostart.phase[autostart.step] = 4                                         -- INCREMENT THE PHASE
            -- end
        -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autostart.phase[autostart.step] == 4 then
            -- B738_autostart_step_completed(autostart.step, autostart.phase[autostart.step], "GROUND POWER OFF")
        -- end



-- ----------------------------------------------------
-- --------  ** START ENGINE NUMBER 2  **  ------------
-- ----------------------------------------------------

    -- ----- AUTO-START STEP 6: ENGAGE STARTER 2
    -- elseif autostart.step == 6 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autostart.phase[autostart.step] == 1 then
            -- B738_print_sequence_status(autostart.step, autostart.phase[autostart.step], "ENGINE START 2 TO GRD...")  -- PRINT THE START PHASE MESSAGE
            -- B738DR_starter_2_pos = -1
			-- simDR_ignition_key2 = 4															-- STARTER 2 ENGAGED
            -- autostart.phase[autostart.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autostart_phase_monitor(1.0)

        -- -- PHASE 3: MONITOR THE STATUS
        -- if autostart.phase[autostart.step] == 3 then
            -- if autostart.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autostart_step_failed(autostart.step, autostart.phase[autostart.step])
            -- elseif simDR_starter_is_running2 == 1
            	-- then                                                						-- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autostart_phase_timeout) == true then
 					-- stop_timer(B738_autostart_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autostart.phase[autostart.step] = 4                                         -- INCREMENT THE PHASE
            -- end
        -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autostart.phase[autostart.step] == 4 then
            -- B738_autostart_step_completed(autostart.step, autostart.phase[autostart.step], "STARTER 2 ENGAGED")
        -- end


    -- ----- AUTO-START STEP 7: MONITOR ENGINE 2 N2
    -- elseif autostart.step == 7 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autostart.phase[autostart.step] == 1 then
            -- B738_print_sequence_status(autostart.step, autostart.phase[autostart.step], "MONITOR NO.2 N2...")  -- PRINT THE START PHASE MESSAGE
            -- autostart.phase[autostart.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autostart_phase_monitor(25.0)

        -- -- PHASE 3: MONITOR THE STATUS
        -- if autostart.phase[autostart.step] == 3 then
            -- if autostart.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autostart_step_failed(autostart.step, autostart.phase[autostart.step])
            -- elseif simDR_engine2_N2 > 25
            	-- then                                                						-- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autostart_phase_timeout) == true then
                    -- stop_timer(B738_autostart_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autostart.phase[autostart.step] = 4                                         -- INCREMENT THE PHASE
            -- end
        -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autostart.phase[autostart.step] == 4 then
            -- B738_autostart_step_completed(autostart.step, autostart.phase[autostart.step], "ENGINE 2 N2% ABOVE 25%")
        -- end


    -- ----- AUTO-START STEP 8: CONDITION LEVER 2 TO IDLE
    -- elseif autostart.step == 8 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autostart.phase[autostart.step] == 1 then
            -- B738_print_sequence_status(autostart.step, autostart.phase[autostart.step], "CONDITION LEVER 2 TO IDLE...")  -- PRINT THE START PHASE MESSAGE
            -- B738DR_condition_lever2_target = 1												-- CONDITION LEVER 2 TO IDLE POS
            -- autostart.phase[autostart.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autostart_phase_monitor(3.0)

        -- -- PHASE 3: MONITOR THE STATUS
        -- if autostart.phase[autostart.step] == 3 then
            -- if autostart.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autostart_step_failed(autostart.step, autostart.phase[autostart.step])
            -- elseif B738DR_condition_lever2 == 1
            	-- then                                                						-- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autostart_phase_timeout) == true then
                    -- stop_timer(B738_autostart_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autostart.phase[autostart.step] = 4                                         -- INCREMENT THE PHASE
            -- end
        -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autostart.phase[autostart.step] == 4 then
            -- B738_autostart_step_completed(autostart.step, autostart.phase[autostart.step], "ENGINE 2 CONDITION LEVER AT IDLE")
        -- end


    -- ----- AUTO-START STEP 9: MONITOR ENGINE 2 N2
    -- elseif autostart.step == 9 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autostart.phase[autostart.step] == 1 then
            -- B738_print_sequence_status(autostart.step, autostart.phase[autostart.step], "MONITOR ENGINE 2 N2...")  -- PRINT THE START PHASE MESSAGE
            -- autostart.phase[autostart.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autostart_phase_monitor(15.0)

        -- -- PHASE 3: MONITOR THE STATUS
        -- if autostart.phase[autostart.step] == 3 then
            -- if autostart.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autostart_step_failed(autostart.step, autostart.phase[autostart.step])
            -- elseif simDR_engine2_N2 > 56
            	-- then                                                						-- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autostart_phase_timeout) == true then
                    -- stop_timer(B738_autostart_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autostart.phase[autostart.step] = 4                                         -- INCREMENT THE PHASE
            -- end
        -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autostart.phase[autostart.step] == 4 then
            -- B738_autostart_step_completed(autostart.step, autostart.phase[autostart.step], "ENGINE 2 N2 AT 56")
        -- end

    -- ----- AUTO-START STEP 10: DISENGAGE STARTER 12
    -- elseif autostart.step == 10 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autostart.phase[autostart.step] == 1 then
            -- B738_print_sequence_status(autostart.step, autostart.phase[autostart.step], "AUTO STARTER 2 DISENGAGE..")  -- PRINT THE START PHASE MESSAGE
            	-- simDR_ignition_key2 = 0
            	-- B738DR_starter_2_pos = 0
            -- autostart.phase[autostart.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autostart_phase_monitor(0.5)

        -- -- PHASE 3: MONITOR THE STATUS
        -- if autostart.phase[autostart.step] == 3 then
            -- if autostart.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autostart_step_failed(autostart.step, autostart.phase[autostart.step])
            -- elseif simDR_starter_is_running2 == 0
            	-- then                                                						-- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autostart_phase_timeout) == true then
                    -- stop_timer(B738_autostart_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autostart.phase[autostart.step] = 4                                         -- INCREMENT THE PHASE
            -- end
        -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autostart.phase[autostart.step] == 4 then
            -- B738_autostart_step_completed(autostart.step, autostart.phase[autostart.step], "STARTER 2 DISENGAGED")
        -- end


-- ----------------------------------------------------
-- --------  ** START ENGINE NUMBER 1  **  ------------
-- ----------------------------------------------------

    -- ----- AUTO-START STEP 11: ENGAGE STARTER 1
    -- elseif autostart.step == 11 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autostart.phase[autostart.step] == 1 then
            -- B738_print_sequence_status(autostart.step, autostart.phase[autostart.step], "ENGINE START 1 TO GRD...")  -- PRINT THE START PHASE MESSAGE
            -- B738DR_starter_1_pos = -1
			-- simDR_ignition_key1 = 4															-- STARTER 2 ENGAGED
            -- autostart.phase[autostart.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autostart_phase_monitor(1.0)

        -- -- PHASE 3: MONITOR THE STATUS
        -- if autostart.phase[autostart.step] == 3 then
            -- if autostart.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autostart_step_failed(autostart.step, autostart.phase[autostart.step])
            -- elseif simDR_starter_is_running1 == 1
            	-- then                                                						-- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autostart_phase_timeout) == true then
 					-- stop_timer(B738_autostart_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autostart.phase[autostart.step] = 4                                         -- INCREMENT THE PHASE
            -- end
        -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autostart.phase[autostart.step] == 4 then
            -- B738_autostart_step_completed(autostart.step, autostart.phase[autostart.step], "STARTER 1 ENGAGED")
        -- end


    -- ----- AUTO-START STEP 12: MONITOR ENGINE 1 N2
    -- elseif autostart.step == 12 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autostart.phase[autostart.step] == 1 then
            -- B738_print_sequence_status(autostart.step, autostart.phase[autostart.step], "MONITOR NO.1 N2...")  -- PRINT THE START PHASE MESSAGE
            -- autostart.phase[autostart.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autostart_phase_monitor(25.0)

        -- -- PHASE 3: MONITOR THE STATUS
        -- if autostart.phase[autostart.step] == 3 then
            -- if autostart.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autostart_step_failed(autostart.step, autostart.phase[autostart.step])
            -- elseif simDR_engine1_N2 > 25
            	-- then                                                						-- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autostart_phase_timeout) == true then
                    -- stop_timer(B738_autostart_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autostart.phase[autostart.step] = 4                                         -- INCREMENT THE PHASE
            -- end
        -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autostart.phase[autostart.step] == 4 then
            -- B738_autostart_step_completed(autostart.step, autostart.phase[autostart.step], "ENGINE 1 N2 ABOVE 25")
        -- end


    -- ----- AUTO-START STEP 13: CONDITION LEVER 1 TO IDLE
    -- elseif autostart.step == 13 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autostart.phase[autostart.step] == 1 then
            -- B738_print_sequence_status(autostart.step, autostart.phase[autostart.step], "CONDITION LEVER 1 TO IDLE...")  -- PRINT THE START PHASE MESSAGE
            -- B738DR_condition_lever1_target = 1												-- CONDITION LEVER 1 TO IDLE POS
            -- autostart.phase[autostart.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autostart_phase_monitor(3.0)

        -- -- PHASE 3: MONITOR THE STATUS
        -- if autostart.phase[autostart.step] == 3 then
            -- if autostart.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autostart_step_failed(autostart.step, autostart.phase[autostart.step])
            -- elseif B738DR_condition_lever1 == 1
            	-- then                                                						-- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autostart_phase_timeout) == true then
                    -- stop_timer(B738_autostart_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autostart.phase[autostart.step] = 4                                         -- INCREMENT THE PHASE
            -- end
        -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autostart.phase[autostart.step] == 4 then
            -- B738_autostart_step_completed(autostart.step, autostart.phase[autostart.step], "ENGINE 1 CONDITION LEVER AT IDLE")
        -- end


    -- ----- AUTO-START STEP 14: MONITOR ENGINE 1 N2
    -- elseif autostart.step == 14 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autostart.phase[autostart.step] == 1 then
            -- B738_print_sequence_status(autostart.step, autostart.phase[autostart.step], "MONITOR ENGINE 1 N2...")  -- PRINT THE START PHASE MESSAGE
            -- autostart.phase[autostart.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autostart_phase_monitor(15.0)

        -- -- PHASE 3: MONITOR THE STATUS
        -- if autostart.phase[autostart.step] == 3 then
            -- if autostart.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autostart_step_failed(autostart.step, autostart.phase[autostart.step])
            -- elseif simDR_engine1_N2 > 56
            	-- then                                                						-- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autostart_phase_timeout) == true then
                    -- stop_timer(B738_autostart_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autostart.phase[autostart.step] = 4                                         -- INCREMENT THE PHASE
            -- end
        -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autostart.phase[autostart.step] == 4 then
            -- B738_autostart_step_completed(autostart.step, autostart.phase[autostart.step], "ENGINE 1 N2 AT 56")
        -- end

    -- ----- AUTO-START STEP 15: DISENGAGE STARTER 1
    -- elseif autostart.step == 15 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autostart.phase[autostart.step] == 1 then
            -- B738_print_sequence_status(autostart.step, autostart.phase[autostart.step], "AUTO STARTER 1 DISENGAGE..")  -- PRINT THE START PHASE MESSAGE
            	-- simDR_ignition_key1 = 0
            	-- B738DR_starter_1_pos = 0
            -- autostart.phase[autostart.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autostart_phase_monitor(0.5)

        -- -- PHASE 3: MONITOR THE STATUS
        -- if autostart.phase[autostart.step] == 3 then
            -- if autostart.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autostart_step_failed(autostart.step, autostart.phase[autostart.step])
            -- elseif simDR_starter_is_running1 == 0
            	-- then                                                						-- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autostart_phase_timeout) == true then
                    -- stop_timer(B738_autostart_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autostart.phase[autostart.step] = 4                                         -- INCREMENT THE PHASE
            -- end
        -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autostart.phase[autostart.step] == 4 then
            -- B738_autostart_step_completed(autostart.step, autostart.phase[autostart.step], "STARTER 1 DISENGAGED")
        -- end
        
        
	-- ----- AUTO-START STEP 16: GENERATOR 2 ON
    -- elseif autostart.step == 16 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autostart.phase[autostart.step] == 1 then
            -- B738_print_sequence_status(autostart.step, autostart.phase[autostart.step], "TURN GENERATOR 2 TO ON...")  -- PRINT THE START PHASE MESSAGE
           	-- simDR_generator2_on = 1															-- GEN 2 ON
            -- autostart.phase[autostart.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autostart_phase_monitor(0.5)

        -- -- PHASE 3: MONITOR THE STATUS
        -- if autostart.phase[autostart.step] == 3 then
            -- if autostart.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autostart_step_failed(autostart.step, autostart.phase[autostart.step])
            -- elseif B738DR_gen_off_bus2 == 0
            	-- then                                                						-- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autostart_phase_timeout) == true then
                    -- stop_timer(B738_autostart_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autostart.phase[autostart.step] = 4                                         -- INCREMENT THE PHASE
            -- end
        -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autostart.phase[autostart.step] == 4 then
            -- B738_autostart_step_completed(autostart.step, autostart.phase[autostart.step], "GENERATOR 2 ON")
        -- end

    -- ----- AUTO-START STEP 17: GENERATOR 1 ON
    -- elseif autostart.step == 17 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autostart.phase[autostart.step] == 1 then
            -- B738_print_sequence_status(autostart.step, autostart.phase[autostart.step], "TURN GENERATOR 1 TO ON...")  -- PRINT THE START PHASE MESSAGE
           	-- simDR_generator1_on = 1															-- GEN 1 ON
            -- autostart.phase[autostart.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autostart_phase_monitor(0.5)

        -- -- PHASE 3: MONITOR THE STATUS
        -- if autostart.phase[autostart.step] == 3 then
            -- if autostart.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autostart_step_failed(autostart.step, autostart.phase[autostart.step])
            -- elseif B738DR_gen_off_bus1 == 0
            	-- then                                                						-- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autostart_phase_timeout) == true then
                    -- stop_timer(B738_autostart_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autostart.phase[autostart.step] = 4                                         -- INCREMENT THE PHASE
            -- end
        -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autostart.phase[autostart.step] == 4 then
            -- B738_autostart_step_completed(autostart.step, autostart.phase[autostart.step], "GENERATOR 1 ON")
        -- end


    -- ----- AUTO-START STEP 18: CAPTAIN PROBE HEAT ON
    -- elseif autostart.step == 18 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autostart.phase[autostart.step] == 1 then
            -- B738_print_sequence_status(autostart.step, autostart.phase[autostart.step], "CAPTAIN PROBE HEAT TO ON...")  -- PRINT THE START PHASE MESSAGE
           	-- B738CMD_probes_capt_switch_pos_on:once()										-- CAPT PROBE HEAT ON
            -- autostart.phase[autostart.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autostart_phase_monitor(0.5)

        -- -- PHASE 3: MONITOR THE STATUS
        -- if autostart.phase[autostart.step] == 3 then
            -- if autostart.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autostart_step_failed(autostart.step, autostart.phase[autostart.step])
            -- elseif B738DR_probes_capt_switch_pos == 1
            	-- then                                                						-- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autostart_phase_timeout) == true then
                    -- stop_timer(B738_autostart_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autostart.phase[autostart.step] = 4                                         -- INCREMENT THE PHASE
            -- end
        -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autostart.phase[autostart.step] == 4 then
            -- B738_autostart_step_completed(autostart.step, autostart.phase[autostart.step], "CAPTAIN PROBE HEAT ON")
        -- end


    -- ----- AUTO-START STEP 19: FIRST OFFICER PROBE HEAT ON
    -- elseif autostart.step == 19 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autostart.phase[autostart.step] == 1 then
            -- B738_print_sequence_status(autostart.step, autostart.phase[autostart.step], "FIRST OFFICER PROBE HEAT TO ON...")  -- PRINT THE START PHASE MESSAGE
           	-- B738CMD_probes_fo_switch_pos_on:once()											-- FO PROBE HEAT ON
            -- autostart.phase[autostart.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autostart_phase_monitor(0.5)

        -- -- PHASE 3: MONITOR THE STATUS
        -- if autostart.phase[autostart.step] == 3 then
            -- if autostart.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autostart_step_failed(autostart.step, autostart.phase[autostart.step])
            -- elseif B738DR_probes_fo_switch_pos == 1
            	-- then                                                						-- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autostart_phase_timeout) == true then
                    -- stop_timer(B738_autostart_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autostart.phase[autostart.step] = 4                                         -- INCREMENT THE PHASE
            -- end
        -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autostart.phase[autostart.step] == 4 then
            -- B738_autostart_step_completed(autostart.step, autostart.phase[autostart.step], "FIRST OFFICER PROBE HEAT ON")
        -- end


    -- ----- AUTO-START STEP 20: ENGINE 1 BLEED AIR ON
    -- elseif autostart.step == 20 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autostart.phase[autostart.step] == 1 then
            -- B738_print_sequence_status(autostart.step, autostart.phase[autostart.step], "ENGINE 1 BLEED AIR TO ON...")  -- PRINT THE START PHASE MESSAGE
           	-- run_after_time(B738_bleed1_on, 0.5)												-- ENGINE 1 BLEED AIR
            -- autostart.phase[autostart.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autostart_phase_monitor(1.0)

        -- -- PHASE 3: MONITOR THE STATUS
        -- if autostart.phase[autostart.step] == 3 then
            -- if autostart.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autostart_step_failed(autostart.step, autostart.phase[autostart.step])
            -- elseif simDR_bleed_air_mode == 5
            	-- then                                                						-- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autostart_phase_timeout) == true then
                    -- stop_timer(B738_autostart_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autostart.phase[autostart.step] = 4                                         -- INCREMENT THE PHASE
            -- end
        -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autostart.phase[autostart.step] == 4 then
            -- B738_autostart_step_completed(autostart.step, autostart.phase[autostart.step], "ENGINE 1 BLEED AIR ON")
        -- end


    -- ----- AUTO-START STEP 21: ENGINE 2 BLEED AIR ON
    -- elseif autostart.step == 21 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autostart.phase[autostart.step] == 1 then
            -- B738_print_sequence_status(autostart.step, autostart.phase[autostart.step], "ENGINE 2 BLEED AIR TO ON...")  -- PRINT THE START PHASE MESSAGE
           	-- run_after_time(B738_bleed2_on, 0.5)												-- ENGINE 2 BLEED AIR
            -- autostart.phase[autostart.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autostart_phase_monitor(1.0)

        -- -- PHASE 3: MONITOR THE STATUS
        -- if autostart.phase[autostart.step] == 3 then
            -- if autostart.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autostart_step_failed(autostart.step, autostart.phase[autostart.step])
            -- elseif simDR_bleed_air_mode == 5
            	-- then                                                						-- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autostart_phase_timeout) == true then
                    -- stop_timer(B738_autostart_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autostart.phase[autostart.step] = 4                                         -- INCREMENT THE PHASE
            -- end
        -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autostart.phase[autostart.step] == 4 then
            -- B738_autostart_step_completed(autostart.step, autostart.phase[autostart.step], "ENGINE 2 BLEED AIR ON")
        -- end


    -- ----- AUTO-START STEP 22: APU BLEED AIR OFF
    -- elseif autostart.step == 22 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autostart.phase[autostart.step] == 1 then
            -- B738_print_sequence_status(autostart.step, autostart.phase[autostart.step], "APU BLEED AIR TO OFF...")  -- PRINT THE START PHASE MESSAGE
           	-- run_after_time(B738_apu_bleed_off, 0.5)											-- APU BLEED AIR OFF
            -- autostart.phase[autostart.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autostart_phase_monitor(1.0)

        -- -- PHASE 3: MONITOR THE STATUS
        -- if autostart.phase[autostart.step] == 3 then
            -- if autostart.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autostart_step_failed(autostart.step, autostart.phase[autostart.step])
            -- elseif simDR_bleed_air_mode == 2
            	-- then                                                						-- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autostart_phase_timeout) == true then
                    -- stop_timer(B738_autostart_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autostart.phase[autostart.step] = 4                                         -- INCREMENT THE PHASE
            -- end
        -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autostart.phase[autostart.step] == 4 then
            -- B738_autostart_step_completed(autostart.step, autostart.phase[autostart.step], "APU BLEED AIR OFF")
        -- end

    -- ----- AUTO-START STEP 23: APU GENERATOR OFF
    -- elseif autostart.step == 23 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autostart.phase[autostart.step] == 1 then
            -- B738_print_sequence_status(autostart.step, autostart.phase[autostart.step], "APU GENERATOR TO OFF...")  -- PRINT THE START PHASE MESSAGE
           	-- simDR_apu_generator_switch = 0													-- APU GEN OFF
            -- autostart.phase[autostart.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autostart_phase_monitor(0.5)

        -- -- PHASE 3: MONITOR THE STATUS
        -- if autostart.phase[autostart.step] == 3 then
            -- if autostart.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autostart_step_failed(autostart.step, autostart.phase[autostart.step])
            -- elseif B738DR_apu_gen_off_bus > 0.4
            	-- then                                                						-- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autostart_phase_timeout) == true then
                    -- stop_timer(B738_autostart_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autostart.phase[autostart.step] = 4                                         -- INCREMENT THE PHASE
            -- end
        -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autostart.phase[autostart.step] == 4 then
            -- B738_autostart_step_completed(autostart.step, autostart.phase[autostart.step], "APU GENERATOR OFF")
        -- end

    -- ----- AUTO-START STEP 24: APU OFF
    -- elseif autostart.step == 24 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autostart.phase[autostart.step] == 1 then
            -- B738_print_sequence_status(autostart.step, autostart.phase[autostart.step], "APU SWITCH TO OFF...")  -- PRINT THE START PHASE MESSAGE
           	-- run_after_time(B738_apu_switch_up, 0.5)											-- APU OFF
            -- autostart.phase[autostart.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autostart_phase_monitor(10.0)

        -- -- PHASE 3: MONITOR THE STATUS
        -- if autostart.phase[autostart.step] == 3 then
            -- if autostart.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autostart_step_failed(autostart.step, autostart.phase[autostart.step])
            -- elseif simDR_apu_running == 0
            	-- then                                                						-- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autostart_phase_timeout) == true then
                    -- stop_timer(B738_autostart_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autostart.phase[autostart.step] = 4                                         -- INCREMENT THE PHASE
            -- end
        -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autostart.phase[autostart.step] == 4 then
            -- B738_autostart_step_completed(autostart.step, autostart.phase[autostart.step], "APU OFF")
        -- end

    -- ----- AUTO-START STEP 25: ENG 1 TO CONTINUOUS IGNITION
    -- elseif autostart.step == 25 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autostart.phase[autostart.step] == 1 then
            -- B738_print_sequence_status(autostart.step, autostart.phase[autostart.step], "ENG 1 TO CONTINUOUS IGNITION...")  -- PRINT THE START PHASE MESSAGE
           	-- B738CMD_starter1_knob_up:once()													-- ENG 1 TO CONTINUOUS IGNITION
            -- autostart.phase[autostart.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autostart_phase_monitor(0.5)

        -- -- PHASE 3: MONITOR THE STATUS
        -- if autostart.phase[autostart.step] == 3 then
            -- if autostart.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autostart_step_failed(autostart.step, autostart.phase[autostart.step])
            -- elseif B738DR_starter_1_pos == 1
            	-- then                                                						-- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autostart_phase_timeout) == true then
                    -- stop_timer(B738_autostart_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autostart.phase[autostart.step] = 4                                         -- INCREMENT THE PHASE
            -- end
        -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autostart.phase[autostart.step] == 4 then
            -- B738_autostart_step_completed(autostart.step, autostart.phase[autostart.step], "ENGINE 1 CONTINUOUS IGNITION")
        -- end

    -- ----- AUTO-START STEP 26: ENG 2 TO CONTINUOUS IGNITION
    -- elseif autostart.step == 26 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autostart.phase[autostart.step] == 1 then
            -- B738_print_sequence_status(autostart.step, autostart.phase[autostart.step], "ENG 2 TO CONTINUOUS IGNITION...")  -- PRINT THE START PHASE MESSAGE
           	-- B738CMD_starter2_knob_up:once()													-- ENG 2 TO CONTINUOUS IGNITION
            -- autostart.phase[autostart.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autostart_phase_monitor(0.5)

        -- -- PHASE 3: MONITOR THE STATUS
        -- if autostart.phase[autostart.step] == 3 then
            -- if autostart.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autostart_step_failed(autostart.step, autostart.phase[autostart.step])
            -- elseif B738DR_starter_2_pos == 1
            	-- then                                                						-- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autostart_phase_timeout) == true then
                    -- stop_timer(B738_autostart_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autostart.phase[autostart.step] = 4                                         -- INCREMENT THE PHASE
            -- end
        -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autostart.phase[autostart.step] == 4 then
            -- B738_autostart_step_completed(autostart.step, autostart.phase[autostart.step], "ENGINE 2 CONTINUOUS IGNITION")
        -- end

	-- ----- AUTO-BOARD STEP 27: MASTER CAUTION
    -- elseif autostart.step == 27 then

        -- -- PHASE 1: SET THE SWITCH
        -- if autostart.phase[autostart.step] == 1 then
            -- B738_print_sequence_status(autostart.step, autostart.phase[autostart.step], "PRESS MASTER CAUTION...")  -- PRINT THE START PHASE MESSAGE										
			-- B738CMD_master_caution_button1:once()											-- MASTER CAUTION BUTTON
           	-- autostart.phase[autostart.step] = 2                                             -- INCREMENT THE PHASE
        -- end

        -- -- PHASE 2: PRINT MONITOR STATUS AND START PHASE TIMER
        -- B738_autostart_phase_monitor(1.5)

        -- -- PHASE 3: MONITOR THE SIM STATUS
        -- if autostart.phase[autostart.step] == 3 then
            -- if autostart.sequence_timeout == true then                                      -- PHASE FAILED
                -- B738_autostart_step_failed(autostart.step, autostart.phase[autostart.step])
            -- elseif B738DR_master_caution_light == 0
            -- then                                                                            -- PHASE WAS SUCCESSFUL
                -- if is_timer_scheduled(B738_autostart_phase_timeout) == true then
                    -- stop_timer(B738_autostart_phase_timeout)                                -- KILL THE TIMER
                -- end
                -- autostart.phase[autostart.step] = 4                                         -- INCREMENT THE PHASE
            -- end
         -- end

        -- -- PHASE 4: COMPLETE THE STEP
        -- if autostart.phase[autostart.step] == 4 then
            -- B738_autostart_step_completed(autostart.step, autostart.phase[autostart.step], "MASTER CAUTION CLEARED")
        -- end


        -- ----- AUTO-START SEQUENCE COMPLETED
        -- autostart.step = 888


    -- ----- AUTO-START STEP 700: ABORT
    -- elseif autostart.step == 700 then
        -- B738_autostart_seq_aborted()

		-- simDR_autoboard_in_progress = 0
		-- simDR_autostart_in_progress = 0


    -- ----- AUTO-START STEP 888: SEQUENCE COMPLETED
    -- elseif autostart.step == 888 then
        -- B738_autostart_seq_completed()


    -- end -- AUTO-START STEPS

-- end -- AUTO-START SEQUENCE




-- ----- FLIGHT START AI -------------------------------------------------------------------
-- function B738_flight_start_ai()

    -- -- ALL MODES ------------------------------------------------------------------------
    -- B738_autoboard_init()
    -- simDR_autoboard_in_progress = 0
    -- B738_autostart_init()
    -- simDR_autostart_in_progress = 0


    -- -- COLD & DARK ----------------------------------------------------------------------
    -- if simDR_startup_running == 0 then


    -- -- ENGINES RUNNING ------------------------------------------------------------------
    -- elseif simDR_startup_running == 1 then


    -- end

-- end


-- --*************************************************************************************--
-- --** 				               XLUA EVENT CALLBACKS       	        			 **--
-- --*************************************************************************************--

-- --function aircraft_load() end

-- --function aircraft_unload() end

-- --function flight_start()

    -- --B738_flight_start_ai()

-- --end

-- --function flight_crash() end

-- --function before_physics() end

-- --function after_physics()

    -- --B738_auto_board()
	-- --B738_auto_start()

-- --end

-- --function after_replay() end



-- --*************************************************************************************--
-- --** 				               SUB-MODULE PROCESSING       	        			 **--
-- --*************************************************************************************--

-- -- dofile("")



