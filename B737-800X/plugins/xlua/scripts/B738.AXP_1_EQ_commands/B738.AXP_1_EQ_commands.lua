-- DEFINING VARIABLES -------------------------------------------------------------------------------------------------------

use_eq = 0

    -- none


-- FINDING REFS -------------------------------------------------------------------------------------------------------

    -- none


-- CREATING REFS -------------------------------------------------------------------------------------------------------

-- hotkey / toggle


enable_eq = create_dataref("laminar/b738/fmodpack/fmod_eq_enable", "number")
use_eq = create_dataref("laminar/b738/fmodpack/fmod_eq_use", "number")

-- EQ values


function B738DR_eq_high_DRhandler()end
function B738DR_eq_mid_DRhandler()end
function B738DR_eq_low_DRhandler()end

eq_high = create_dataref("laminar/b738/fmodpack/fmod_eq_high","number", B738DR_eq_high_DRhandler)
eq_mid = create_dataref("laminar/b738/fmodpack/fmod_eq_mid","number", B738DR_eq_mid_DRhandler)
eq_low = create_dataref("laminar/b738/fmodpack/fmod_eq_low","number", B738DR_eq_low_DRhandler)

-- CREATING EQ FUNCTIONS -----------------------------------------------------------

-- HIGH


function B738_eq_high_CMDhandler(phase, duration)
	if phase == 0 then
		if eq_high <= 9 then
			eq_high = (eq_high +1)
		elseif eq_high == 10 then
			eq_high = 0
		end
	end
end

-- MID


function B738_eq_mid_CMDhandler(phase, duration)
	if phase == 0 then
		if eq_mid <= 9 then
			eq_mid = (eq_mid +1)
		elseif eq_mid == 10 then
			eq_mid = 0
		end
	end
end

-- LOW

function B738_eq_low_CMDhandler(phase, duration)
	if phase == 0 then
		if eq_low <= 9 then
			eq_low = (eq_low +1)
		elseif eq_low == 10 then
			eq_low = 0
		end
	end
end

-- AUTO DISABLE EQ EVENT IF ALL EQ VOLUMES ARE 0

function autodisable_eq()

    if eq_low == 0 and eq_mid == 0 and eq_high == 0 then
        use_eq = 0
    end
        
    if eq_low > 0 or eq_mid > 0 or eq_high > 0 then
        use_eq = 1
    end
    

end



--- CREATING COMMANDS -------------------------------------------------------------------------------------------------------------

-- EQ values

B738_eq_high = create_command("laminar/b738/fmodpack/fmod_eq_high", "EQ control - high frequencies", B738_eq_high_CMDhandler)
B738_eq_mid = create_command("laminar/b738/fmodpack/fmod_eq_mid", "EQ control - mid frequencies", B738_eq_mid_CMDhandler)
B738_eq_low = create_command("laminar/b738/fmodpack/fmod_eq_low", "EQ control - low frequencies", B738_eq_low_CMDhandler)


function flight_start()


    use_eq = 0


end

function after_physics() 

    autodisable_eq()

end
