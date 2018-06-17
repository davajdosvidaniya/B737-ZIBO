-- (C) audiobirdxp / o. schmidt 2017 / 2018

--  ============================================== SETTING values ========================================================== 

    is_success = 0
    is_cargo_sounds = 0
--  ============================================== FINDING datarefs ========================================================== 



    is_command_cabindoor_closed = find_dataref("laminar/b738/fmodpack/cabindoor_closed")
    is_cargo_loading = find_dataref("laminar/b738/fmodpack/fmod_play_cargo")
  

------------------------------------------------- CREATING DATAREFS - ZIBO ONLY!!! --------------------------------------------

-- creating mixer relevant datarefs

-- door ratios --
    door_ratio_fwd_L = create_dataref("737u/doors/L1", "number")
    door_ratio_fwd_R = create_dataref("737u/doors/R1", "number")
    door_ratio_aft_L = create_dataref("737u/doors/L2", "number")
    door_ratio_aft_R = create_dataref("737u/doors/R2", "number")
    door_ratio_fwd_cargo = create_dataref("737u/doors/Fwd_Cargo", "number")
    door_ratio_aft_cargo = create_dataref("737u/doors/aft_Cargo", "number")

-- door states acting like commands --
    door_state_fwd_L = create_dataref("737u/doorstate/L1", "number")
    door_state_fwd_R = create_dataref("737u/doorstate/R1", "number")
    door_state_aft_L = create_dataref("737u/doorstate/L2", "number")
    door_state_aft_R = create_dataref("737u/doorstate/R2", "number")
    door_state_fwd_cargo = create_dataref("737u/doorstate/Fwd_Cargo", "number")
    door_state_aft_cargo = create_dataref("737u/doorstate/aft_Cargo", "number")

-------^^---------------------------------------- CREATING DATAREFS - ZIBO ONLY!!! -------------------------------------^^-----




--  ============================================== CREATING datarefs ========================================================== --

-- Zibo and Ultimate

is_success = create_dataref("axp/success", "number")
is_cargo_sounds = create_dataref("axp/cargo_sounds_on", "number")




--  ============================================== CREATING functions ========================================================== --

function success()

    is_success = 1

end

function AXP_manage_cargo_doors()

    if is_cargo_loading == 1 then
    
        is_cargo_sounds = 1
        door_ratio_fwd_cargo = 1
        door_ratio_aft_cargo = 1
        door_state_aft_cargo = 1
        door_state_fwd_cargo = 1

    elseif is_cargo_loading == 0 then

        is_cargo_sounds = 0
        door_ratio_fwd_cargo = 0
        door_ratio_aft_cargo = 0
        door_state_aft_cargo = 0
        door_state_fwd_cargo = 0

    end

end

   
function AXP_autoclose_all_doors_CMDhandler(phase, duration)
    -- when run set all door states to 0 effectively closing them --
    -- necessary by user incompetence --
    
        if phase == 0 then
    
            door_state_fwd_L = 0
            door_state_fwd_R = 0
            door_state_aft_L = 0
            door_state_aft_R = 0
            door_state_aft_cargo = 0
            door_state_fwd_cargo = 0
            door_ratio_fwd_L = 0
            door_ratio_fwd_R = 0
            door_ratio_aft_L = 0
            door_ratio_aft_R = 0
            door_ratio_fwd_cargo = 0
            door_ratio_aft_cargo = 0
        
        end
    
end


function AXP_autoopen_L1_CMDhandler(phase, duration)
        -- when run set all door states to 0 effectively closing them --
        -- necessary by user incompetence --
        
            if phase == 0 then
        
                door_state_fwd_L = 1
                door_ratio_fwd_L = 1
                
            end
end


function zibo_secure_doors()
-- if gate departure is initialized or aircraft airborne or taxi phase started by setting taxi lights => force doors closed

-- set ratios equal state for mixer

    if is_command_cabindoor_closed == 1 then

        AXP_CMD_closeall_ZIBO:once()

    elseif is_command_cabindoor_closed == 0 then

        AXP_CMD_openall_ZIBO:once()
    end

end

--  ============================================== CREATING commands ========================================================== --

-- Zibo and Ultimate

AXP_CMD_autoclose_all_doors = create_command("axp/commands/autoclose_all_doors_zibo", "This will close all open doors of the aircraft", AXP_autoclose_all_doors_CMDhandler)
AXP_CMD_autoopen_L1 = create_command("axp/commands/autoopen_L1_zibo", "This will close all open doors of the aircraft", AXP_autoopen_L1_CMDhandler)
-- =================================================================== RUNNING FUNCTIONS  ===============================================================================




function zibo_secure_doors()
    -- if gate departure is initialized or aircraft airborne or taxi phase started by setting taxi lights => force doors closed
    
    -- set ratios equal state for mixer
    
        if is_command_cabindoor_closed == 1 then
    
            AXP_CMD_autoclose_all_doors:once()
    
        elseif is_command_cabindoor_closed == 0 then
    
            AXP_CMD_autoopen_L1:once()
        end
    
end




function flight_start()

    is_success = 0
    is_cargo_sounds = 0

    -- start with fwd left open

        door_ratio_fwd_L = 1
        door_ratio_fwd_R = 0
        door_ratio_aft_L = 0
        door_ratio_aft_R = 0
        door_ratio_fwd_cargo = 0
        door_ratio_aft_cargo = 0

    -- start with fwd left open
        door_state_fwd_L = 1
        door_state_fwd_R = 0
        door_state_aft_L = 0
        door_state_aft_R = 0
        door_state_fwd_cargo = 0
        door_state_aft_cargo = 0



end


function after_physics() 

    success()
    AXP_manage_cargo_doors()
    zibo_secure_doors()
  

end








