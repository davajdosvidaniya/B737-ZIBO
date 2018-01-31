--[[
*****************************************************************************************
* Program Script Name	:	B738.fire
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
*        COPYRIGHT � 2016 JIM GREGORY / LAMINAR RESEARCH - ALL RIGHTS RESERVED	        *
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

eng1_fired = 0
eng2_fired = 0
eng1_fire_time = 0
eng2_fire_time = 0

eng1_bottle_0102L_psi = 0
eng1_bottle_0102R_psi = 0
eng2_bottle_0102L_psi = 0
eng2_bottle_0102R_psi = 0

--*************************************************************************************--
--** 					            LOCAL VARIABLES                 				 **--
--*************************************************************************************--

local fire_extiguisher_switch_lock = {}
for i = 1, 3 do
    fire_extiguisher_switch_lock[i] = 0
end

local fire_extinguisher_switch_pos_arm_target  = {}
for i = 1, 3 do
    fire_extinguisher_switch_pos_arm_target[i] = 0
end

local fire_extinguisher_switch_pos_disch_target = {}
for i = 1, 3 do
    fire_extinguisher_switch_pos_disch_target[i] = 0
end





--*************************************************************************************--
--** 				                X-PLANE DATAREFS            			    	 **--
--*************************************************************************************--

simDR_engine_fire           = find_dataref("sim/cockpit2/annunciators/engine_fires")
simDR_engine_fire_ext_on    = find_dataref("sim/cockpit2/engine/actuators/fire_extinguisher_on")

simDR_apu_bleed_fail = find_dataref("sim/operation/failures/rel_APU_press")

simDR_eng1_fire           = find_dataref("sim/operation/failures/rel_engfir0")
simDR_eng2_fire           = find_dataref("sim/operation/failures/rel_engfir1")

simDR_smoke_cockpit 		= find_dataref("sim/operation/failures/rel_smoke_cpit")

simDR_engine_mixture1		= find_dataref("sim/cockpit2/engine/actuators/mixture_ratio[0]")
simDR_engine_mixture2		= find_dataref("sim/cockpit2/engine/actuators/mixture_ratio[1]")


--*************************************************************************************--
--** 				              FIND CUSTOM DATAREFS             			    	 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				        CREATE READ-ONLY CUSTOM DATAREFS               	         **--
--*************************************************************************************--

B738DR_engine01_fire_ext_switch_pos_arm     = create_dataref("laminar/B738/fire/engine01/ext_switch/pos_arm", "number")
B738DR_engine02_fire_ext_switch_pos_arm     = create_dataref("laminar/B738/fire/engine02/ext_switch/pos_arm", "number")
B738DR_apu_fire_ext_switch_pos_arm          = create_dataref("laminar/B738/fire/apu/ext_switch/pos_arm", "number")

B738DR_engine01_fire_ext_switch_pos_disch   = create_dataref("laminar/B738/fire/engine01/ext_switch/pos_disch", "number")
B738DR_engine02_fire_ext_switch_pos_disch   = create_dataref("laminar/B738/fire/engine02/ext_switch/pos_disch", "number")
B738DR_apu_fire_ext_switch_pos_disch        = create_dataref("laminar/B738/fire/apu/ext_switch/pos_disch", "number")

B738DR_fire_ext_bottle_0102L_psi            = create_dataref("laminar/B738/fire/engine01_02L/ext_bottle/psi", "number")
B738DR_fire_ext_bottle_0102R_psi            = create_dataref("laminar/B738/fire/engine01_02R/ext_bottle/psi", "number")
B738DR_fire_ext_bottle_apu_psi              = create_dataref("laminar/B738/fire/apu/ext_bottle/psi", "number")

B738DR_apu_fire                             = create_dataref("laminar/B738/fire/apu/fire", "number")
B738DR_apu_fire_ext_on                      = create_dataref("laminar/B738/fire/apu/fire_ext", "number")

B738DR_apu_was_fire							= create_dataref("laminar/B738/fire/apu/was_fire", "number")

--*************************************************************************************--
--** 				       READ-WRITE CUSTOM DATAREF HANDLERS     	        	     **--
--*************************************************************************************--





--*************************************************************************************--
--** 				       CREATE READ-WRITE CUSTOM DATAREFS                         **--
--*************************************************************************************--



--*************************************************************************************--
--** 				             X-PLANE COMMAND HANDLERS               	    	 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				                 X-PLANE COMMANDS                   	    	 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				              CUSTOM COMMAND HANDLERS            			     **--
--*************************************************************************************--



----- FIRE EXTINGUISHER SWITCHES --------------------------------------------------------
function B738_eng01_fire_ext_switch_arm_CMDhandler(phase, duration)
    if phase == 0 then
        if fire_extiguisher_switch_lock[1] == 0 then                    -- TODO:  CHANGE TOP ALLOW SIWTHC TO BE RETURNED TO "OFF" WHEN FIRE IS OUT
            if fire_extinguisher_switch_pos_disch_target[1] == 0 then
                fire_extinguisher_switch_pos_arm_target[1] = 1.0 - fire_extinguisher_switch_pos_arm_target[1]
            end
        end
    end
end

function B738_eng02_fire_ext_switch_arm_CMDhandler(phase, duration)
    if phase == 0 then
        if fire_extiguisher_switch_lock[2] == 0 then
            if fire_extinguisher_switch_pos_disch_target[2] == 0 then
                fire_extinguisher_switch_pos_arm_target[2] = 1.0 - fire_extinguisher_switch_pos_arm_target[2]
            end
        end
    end
end

function B738_apu_fire_ext_switch_arm_CMDhandler(phase, duration)
    if phase == 0 then
        if fire_extiguisher_switch_lock[3] == 0 then                    -- TODO:  CHANGE TOP ALLOW SIWTHC TO BE RETURNED TO "OFF" WHEN FIRE IS OUT
            if fire_extinguisher_switch_pos_disch_target[3] == 0 then
                fire_extinguisher_switch_pos_arm_target[3] = 1.0 - fire_extinguisher_switch_pos_arm_target[3]
            end
        end
    end
end




function B738_eng01_fire_ext_switch_L_CMDhandler(phase, duration)
    if phase == 0 then
        if B738DR_engine01_fire_ext_switch_pos_arm == 1 then
            fire_extinguisher_switch_pos_disch_target[1] = math.max(fire_extinguisher_switch_pos_disch_target[1]-1, -1)
       end
    end
end

function B738_eng01_fire_ext_switch_R_CMDhandler(phase, duration)
    if phase == 0 then
        if B738DR_engine01_fire_ext_switch_pos_arm == 1 then
            fire_extinguisher_switch_pos_disch_target[1] = math.min(fire_extinguisher_switch_pos_disch_target[1]+1, 1)
        end
    end
end

function B738_eng02_fire_ext_switch_L_CMDhandler(phase, duration)
    if phase == 0 then
        if B738DR_engine02_fire_ext_switch_pos_arm == 1 then
            fire_extinguisher_switch_pos_disch_target[2] = math.max(fire_extinguisher_switch_pos_disch_target[2]-1, -1)
        end
    end
end

function B738_eng02_fire_ext_switch_R_CMDhandler(phase, duration)
    if phase == 0 then
        if B738DR_engine02_fire_ext_switch_pos_arm == 1 then
            fire_extinguisher_switch_pos_disch_target[2] = math.min(fire_extinguisher_switch_pos_disch_target[2]+1, 1)
        end
    end
end

function B738_apu_fire_ext_switch_L_CMDhandler(phase, duration)
    if phase == 0 then
        if B738DR_apu_fire_ext_switch_pos_arm == 1 then
            fire_extinguisher_switch_pos_disch_target[3] = math.max(fire_extinguisher_switch_pos_disch_target[3]-1, -1)
        end
    end
end

function B738_apu_fire_ext_switch_R_CMDhandler(phase, duration)
    if phase == 0 then
        if B738DR_apu_fire_ext_switch_pos_arm == 1 then
            fire_extinguisher_switch_pos_disch_target[3] = math.min(fire_extinguisher_switch_pos_disch_target[3]+1, 1)
        end
    end
end





--*************************************************************************************--
--** 				              CREATE CUSTOM COMMANDS              			     **--
--*************************************************************************************--


----- FIRE EXTINGUISHER SWITCHES --------------------------------------------------------
B738CMD_eng01_fire_ext_switch_arm   = create_command("laminar/B738/fire/engine01/ext_switch_arm", "Fire Extinguisher Switch 01 Arm", B738_eng01_fire_ext_switch_arm_CMDhandler)
B738CMD_eng02_fire_ext_switch_arm   = create_command("laminar/B738/fire/engine02/ext_switch_arm", "Fire Extinguisher Switch 02 Arm", B738_eng02_fire_ext_switch_arm_CMDhandler)
B738CMD_apu_fire_ext_switch_arm     = create_command("laminar/B738/fire/apu/ext_switch_arm", "Fire Extinguisher Switch APU", B738_apu_fire_ext_switch_arm_CMDhandler)


B738CMD_eng01_fire_ext_switch_L     = create_command("laminar/B738/fire/engine01/ext_switch_L", "Fire Extinguisher Switch L", B738_eng01_fire_ext_switch_L_CMDhandler)
B738CMD_eng01_fire_ext_switch_R     = create_command("laminar/B738/fire/engine01/ext_switch_R", "Fire Extinguisher Switch R", B738_eng01_fire_ext_switch_R_CMDhandler)
B738CMD_eng02_fire_ext_switch_L     = create_command("laminar/B738/fire/engine02/ext_switch_L", "Fire Extinguisher Switch L", B738_eng02_fire_ext_switch_L_CMDhandler)
B738CMD_eng02_fire_ext_switch_R     = create_command("laminar/B738/fire/engine02/ext_switch_R", "Fire Extinguisher Switch R", B738_eng02_fire_ext_switch_R_CMDhandler)
B738CMD_apu_fire_ext_switch_L       = create_command("laminar/B738/fire/apu/ext_switch_L", "Fire Extinguisher Switch L", B738_apu_fire_ext_switch_L_CMDhandler)
B738CMD_apu_fire_ext_switch_R       = create_command("laminar/B738/fire/apu/ext_switch_R", "Fire Extinguisher Switch R", B738_apu_fire_ext_switch_R_CMDhandler)


function B738_blank()
end

function B738_fix_fail_CMDhandler()
	B738DR_fire_ext_bottle_0102L_psi = 600.0
	B738DR_fire_ext_bottle_0102R_psi = 600.0
	B738DR_fire_ext_bottle_apu_psi = 600.0
	B738DR_apu_was_fire = 0
	
	eng1_bottle_0102L_psi = 0
	eng1_bottle_0102R_psi = 0
	eng2_bottle_0102L_psi = 0
	eng2_bottle_0102R_psi = 0
end

simCMD_fix_fail					= wrap_command("sim/operation/fix_all_systems", B738_blank, B738_fix_fail_CMDhandler)

--*************************************************************************************--
--** 					            OBJECT CONSTRUCTORS         		    		 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				               CREATE SYSTEM OBJECTS            				 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				                  SYSTEM FUNCTIONS           	    			 **--
--*************************************************************************************--

----- TERNARY CONDITIONAL ---------------------------------------------------------------
function B738_ternary(condition, ifTrue, ifFalse)
    if condition then return ifTrue else return ifFalse end
end



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





----- FIRE EXTINGUISHER LOCKS -----------------------------------------------------------
function B738_fire_extingiuisher_locks()

    fire_extiguisher_switch_lock[1] = 0 --B738_ternary((simDR_engine_fire[0] == 6), 0, 1) -- TODO: ADD FUEL CUTOFF SWITCH TO LOGIC
    fire_extiguisher_switch_lock[2] = 0 --B738_ternary((simDR_engine_fire[1] == 6), 0, 1)
	fire_extiguisher_switch_lock[3] = 0 --B738_ternary((simDR_engine_fire[1] == 6), 0, 1)


end





----- FIRE EXTINGUISHER SWITCH ANIMATION ------------------------------------------------
function B738_fire_ext_switch_animation()

    B738DR_engine01_fire_ext_switch_pos_arm = B738_set_animation_position(B738DR_engine01_fire_ext_switch_pos_arm, fire_extinguisher_switch_pos_arm_target[1], 0.0, 1.0, 10)
    B738DR_engine02_fire_ext_switch_pos_arm = B738_set_animation_position(B738DR_engine02_fire_ext_switch_pos_arm, fire_extinguisher_switch_pos_arm_target[2], 0.0, 1.0, 10)
    B738DR_apu_fire_ext_switch_pos_arm = B738_set_animation_position(B738DR_apu_fire_ext_switch_pos_arm, fire_extinguisher_switch_pos_arm_target[3], 0.0, 1.0, 10)

    B738DR_engine01_fire_ext_switch_pos_disch = B738_set_animation_position(B738DR_engine01_fire_ext_switch_pos_disch, fire_extinguisher_switch_pos_disch_target[1],-1.0, 1.0, 10)
    B738DR_engine02_fire_ext_switch_pos_disch = B738_set_animation_position(B738DR_engine02_fire_ext_switch_pos_disch, fire_extinguisher_switch_pos_disch_target[2],-1.0, 1.0, 10)
    B738DR_apu_fire_ext_switch_pos_disch = B738_set_animation_position(B738DR_apu_fire_ext_switch_pos_disch, fire_extinguisher_switch_pos_disch_target[3],-1.0, 1.0, 10)

end





----- FIRE EXTINGUISH LOGIC -------------------------------------------------------------
function B738_fire_extinguishers()

    ----- SET SIM FIRE EXTINGUISHER

    -- ENGINE #1
    if B738DR_engine01_fire_ext_switch_pos_disch < -0.95
        or B738DR_engine01_fire_ext_switch_pos_disch > 0.95
    then
        simDR_engine_fire_ext_on[0] = 1
    else
        simDR_engine_fire_ext_on[0] = 0
    end


    -- ENGINE #2
    if B738DR_engine02_fire_ext_switch_pos_disch < -0.95
        or B738DR_engine02_fire_ext_switch_pos_disch > 0.95
    then
        simDR_engine_fire_ext_on[1] = 1
    else
        simDR_engine_fire_ext_on[1] = 0
    end

    -- APU
    if B738DR_apu_fire_ext_switch_pos_disch < -0.95
        or B738DR_apu_fire_ext_switch_pos_disch > 0.95
    then
        B738DR_apu_fire_ext_on = 1
		B738DR_apu_was_fire = 1
		simDR_apu_bleed_fail = 1
    else
        B738DR_apu_fire_ext_on = 0
    end


    ----- SET BOTTLE PRESSURE ON DISCHARGE

    -- ENGINE #1 / BOTTLE L DISCHARGE
    if simDR_engine_fire_ext_on[0] == 1
        and B738DR_engine01_fire_ext_switch_pos_disch < -0.95
        and B738DR_fire_ext_bottle_0102L_psi > 0
    then
        --B738DR_fire_ext_bottle_0102L_psi = math.max(0, B738DR_fire_ext_bottle_0102L_psi - (40.0 * SIM_PERIOD))
        B738DR_fire_ext_bottle_0102L_psi = math.max(0, B738DR_fire_ext_bottle_0102L_psi - (120.0 * SIM_PERIOD))
		if B738DR_fire_ext_bottle_0102L_psi > 0 then
			eng1_bottle_0102L_psi = eng1_bottle_0102L_psi + (120.0 * SIM_PERIOD)
		end
    end

    -- ENGINE #1 / BOTTLE R DISCHARGE
    if simDR_engine_fire_ext_on[0] == 1
        and B738DR_engine01_fire_ext_switch_pos_disch > 0.95
        and B738DR_fire_ext_bottle_0102R_psi > 0
    then
        --B738DR_fire_ext_bottle_0102R_psi = math.max(0, B738DR_fire_ext_bottle_0102R_psi - (40.0 * SIM_PERIOD))
        B738DR_fire_ext_bottle_0102R_psi = math.max(0, B738DR_fire_ext_bottle_0102R_psi - (120.0 * SIM_PERIOD))
		if B738DR_fire_ext_bottle_0102R_psi > 0 then
			eng1_bottle_0102R_psi = eng1_bottle_0102R_psi + (120.0 * SIM_PERIOD)
		end
    end

    -- ENGINE #2 / BOTTLE L DISCHARGE
    if simDR_engine_fire_ext_on[1] == 1
        and B738DR_engine02_fire_ext_switch_pos_disch < -0.95
        and B738DR_fire_ext_bottle_0102L_psi > 0
    then
        --B738DR_fire_ext_bottle_0102L_psi = math.max(0, B738DR_fire_ext_bottle_0102L_psi - (40.0 * SIM_PERIOD))
        B738DR_fire_ext_bottle_0102L_psi = math.max(0, B738DR_fire_ext_bottle_0102L_psi - (120.0 * SIM_PERIOD))
		if B738DR_fire_ext_bottle_0102L_psi > 0 then
			eng2_bottle_0102L_psi = eng2_bottle_0102L_psi + (120.0 * SIM_PERIOD)
		end
    end

    -- ENGINE #2 / BOTTLE R DISCHARGE
    if simDR_engine_fire_ext_on[1] == 1
        and B738DR_engine02_fire_ext_switch_pos_disch > 0.95
        and B738DR_fire_ext_bottle_0102R_psi > 0
    then
        --B738DR_fire_ext_bottle_0102R_psi = math.max(0, B738DR_fire_ext_bottle_0102R_psi - (40.0 * SIM_PERIOD))
        B738DR_fire_ext_bottle_0102R_psi = math.max(0, B738DR_fire_ext_bottle_0102R_psi - (120.0 * SIM_PERIOD))
		if B738DR_fire_ext_bottle_0102R_psi > 0 then
			eng2_bottle_0102R_psi = eng2_bottle_0102R_psi + (120.0 * SIM_PERIOD)
		end
    end

    -- APU / BOTTLE L DISCHARGE
    if B738DR_apu_fire_ext_on == 1
        and B738DR_apu_fire_ext_switch_pos_disch < -0.95
        and B738DR_fire_ext_bottle_apu_psi > 0
    then
        --B738DR_fire_ext_bottle_apu_psi = math.max(0, B738DR_fire_ext_bottle_apu_psi - (40.0 * SIM_PERIOD))
        B738DR_fire_ext_bottle_apu_psi = math.max(0, B738DR_fire_ext_bottle_apu_psi - (120.0 * SIM_PERIOD))
    end

    -- APU / BOTTLE R DISCHARGE
    if B738DR_apu_fire_ext_on == 1
        and B738DR_apu_fire_ext_switch_pos_disch > 0.95
        and B738DR_fire_ext_bottle_apu_psi > 0
    then
        B738DR_fire_ext_bottle_apu_psi = math.max(0, B738DR_fire_ext_bottle_apu_psi - (120.0 * SIM_PERIOD))
    end



end

function B738_fire()
	
	local cockpit_smoke = 0
	local eng1_extinguishing = 0
	local eng2_extinguishing = 0
	
	-- ENG 1
	if simDR_eng1_fire == 6 then
		if eng1_fired < 90 then
			eng1_fired = eng1_fired + SIM_PERIOD
		end
		
		if eng1_bottle_0102L_psi > 400 then
			eng1_extinguishing = 1
		end
		if eng1_bottle_0102R_psi > 400 then
			eng1_extinguishing = 1
		end
		if eng1_extinguishing == 1 then
			if eng1_fire_time < 12 then
				eng1_fire_time = eng1_fire_time + SIM_PERIOD
			end
		end
	else
		eng1_bottle_0102L_psi = 0
		eng1_bottle_0102R_psi = 0
	end
	if eng1_fired >= 90 then
		-- cockpit smoke
		cockpit_smoke = 1
		eng1_fired = 0
	end
	if eng1_fire_time >= 12 then
		simDR_eng1_fire = 0
		eng1_fire_time = 0
	end
	
	-- ENG 2
	if simDR_eng2_fire == 6 then
		if eng2_fired < 90 then
			eng2_fired = eng2_fired + SIM_PERIOD
		end
		if eng2_bottle_0102L_psi > 400 then
			eng2_extinguishing = 1
		end
		if eng2_bottle_0102R_psi > 400 then
			eng2_extinguishing = 1
		end
		if eng2_extinguishing == 1 then
			if eng2_fire_time < 12 then
				eng2_fire_time = eng2_fire_time + SIM_PERIOD
			end
		end
	else
		eng2_bottle_0102L_psi = 0
		eng2_bottle_0102R_psi = 0
	end
	if eng2_fired >= 90 then
		-- cockpit smoke
		cockpit_smoke = 1
		eng2_fired = 0
	end
	if eng2_fire_time >= 12 then
		simDR_eng2_fire = 0
		eng2_fire_time = 0
	end
	
	if cockpit_smoke == 1 then
		simDR_smoke_cockpit = 1
	end
end


--*************************************************************************************--
--** 				                  EVENT CALLBACKS           	    			 **--
--*************************************************************************************--

--function aircraft_load() end

--function aircraft_unload() end

function flight_start()

    B738DR_fire_ext_bottle_0102L_psi = 600.0
    B738DR_fire_ext_bottle_0102R_psi = 600.0
	B738DR_fire_ext_bottle_apu_psi = 600.0
	B738DR_apu_was_fire = 0
	
	eng1_bottle_0102L_psi = 0
	eng1_bottle_0102R_psi = 0
	eng2_bottle_0102L_psi = 0
	eng2_bottle_0102R_psi = 0

end

--function flight_crash() end

--function before_physics() end

function after_physics()

    B738_fire_extingiuisher_locks()
    B738_fire_ext_switch_animation()
    B738_fire_extinguishers()
	B738_fire()

end

--function after_replay() end



