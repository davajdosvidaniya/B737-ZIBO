-- DEFINING VARIABLES -------------------------------------------------------------------------------------------------------

    -- none

start_leg = 0
end_leg = 0

-- FINDING REFS -------------------------------------------------------------------------------------------------------

-- none


-- CREATING REFS -------------------------------------------------------------------------------------------------------

-- control pax presence


start_leg = create_dataref("laminar/b738/fmodpack/fmod_start_leg", "number")
end_leg = create_dataref("laminar/b738/fmodpack/fmod_end_leg", "number")



-- CREATING FUNCTIONS -----------------------------------------------------------

-- start leg


function B738_start_leg_CMDhandler(phase, duration)
	if phase == 0 then
		if start_leg == 0 then
			start_leg = 1
            end_leg = 0
		end
	end
end

-- end leg


function B738_end_leg_CMDhandler(phase, duration)
	if phase == 0 then
		if start_leg == 1 then
			start_leg = 0
            end_leg = 1
		end
	end
end






--- CREATING COMMANDS -------------------------------------------------------------------------------------------------------------


B738_end_leg = create_command("laminar/b738/fmodpack/fmod_end_leg", "PAX Terminate current leg of flight - remove PAX and reset", B738_end_leg_CMDhandler)
B738_start_leg = create_command("laminar/b738/fmodpack/fmod_start_leg", "PAX Begin leg of flight - start boarding", B738_start_leg_CMDhandler)

function after_physics() 
end



