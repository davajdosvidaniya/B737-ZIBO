--- (C) Zibo, audiobirdxp (AXP) 2017/2018
--- 1801+

---------- CREATE REFS -------------------------------------------------------------------------------
--B738DR_enable_chatter	= create_dataref("laminar/b738/fmodpack/pax_talk", "number")
--B738DR_enable_pax_boarding	= create_dataref("laminar/b738/fmodpack/pax_board", "number")

B738DR_enable_pax_boarding	= create_dataref("laminar/b738/fmodpack/fmod_pax_boarding_on", "number")
B738DR_enable_gyro	= create_dataref("laminar/b738/fmodpack/fmod_woodpecker_on", "number")
B738DR_enable_chatter	= create_dataref("laminar/b738/fmodpack/fmod_chatter_on", "number")
B738DR_airport_set = create_dataref("laminar/b738/fmodpack/fmod_airport_set", "number")
B738DR_vol_int_ducker = create_dataref("laminar/b738/fmodpack/fmod_vol_int_ducker", "number")
B738DR_vol_int_eng = create_dataref("laminar/b738/fmodpack/fmod_vol_int_eng", "number")
B738DR_vol_int_start = create_dataref("laminar/b738/fmodpack/fmod_vol_int_start", "number")
B738DR_vol_int_ac = create_dataref("laminar/b738/fmodpack/fmod_vol_int_ac", "number")
B738DR_vol_int_gyro = create_dataref("laminar/b738/fmodpack/fmod_vol_int_gyro", "number")
B738DR_vol_int_roll = create_dataref("laminar/b738/fmodpack/fmod_vol_int_roll", "number")
B738DR_vol_int_bump = create_dataref("laminar/b738/fmodpack/fmod_vol_int_bump", "number")

-- new AXP 1801

B738DR_eng_LEAP1B = create_dataref("laminar/b738/fmodpack/fmod_eng_LEAP1B", "number")

-- new AXP 1713

B738DR_vol_computer = create_dataref("laminar/b738/fmodpack/fmod_vol_computer", "number")

-- new AXP 1711

B738DR_vol_PM = create_dataref("laminar/b738/fmodpack/fmod_vol_PM", "number")
B738DR_vol_crew = create_dataref("laminar/b738/fmodpack/fmod_vol_crew", "number")

play_cruise_msg = create_dataref("laminar/b738/fmodpack/play_cruise_msg", "number") 
play_descent_msg = create_dataref("laminar/b738/fmodpack/play_descent_msg", "number") 
play_preland_msg = create_dataref("laminar/b738/fmodpack/play_preland_msg", "number")
play_welcome_msg = create_dataref("laminar/b738/fmodpack/play_welcome_msg", "number") 

play_turbulence_msg = create_dataref("laminar/b738/fmodpack/play_turbulence_msg", "number")

-- new AXP 1712

play_cargo = create_dataref("laminar/b738/fmodpack/fmod_play_cargo", "number") 

-- new AXP 1711

B738DR_vol_int_pax = create_dataref("laminar/b738/fmodpack/fmod_vol_int_pax", "number")
B738DR_vol_int_pax_applause = create_dataref("laminar/b738/fmodpack/fmod_pax_applause_on", "number")
B738DR_vol_int_wind_vol = create_dataref("laminar/b738/fmodpack/fmod_vol_int_wind", "number")

-- ********************* NEW audiobirdxp 8-7-2017
-- to mute the trim wheel when the AP is trimming
B738DR_enable_mutetrim	= create_dataref("laminar/b738/fmodpack/fmod_mutetrim_on", "number")
-- to set the airport volume (5 = standard)
B738DR_vol_airport	= create_dataref("laminar/b738/fmodpack/fmod_vol_airport", "number")
-- to trigger the long GWPS test
B738DR_mute_gpwstest	= create_dataref("laminar/b738/fmodpack/fmod_mute_gpwstest", "number")

-- provides dataref => this would be better  put into the lua file wherever the switch is programmed

B738DR_full_gpws_test_on = create_dataref("laminar/b738/fmodpack/fmod_gpwstest_long_on","number")
B738DR_short_gpws_test_on	= create_dataref("laminar/b738/fmodpack/fmod_gpwstest_short_on", "number")

-- future feature turn on or off automatic passengers

B738DR_enable_fmc_mute_on = create_dataref("laminar/b738/fmodpack/fmod_enable_fmc_mute_on", "number")


B738DR_announcement_set = create_dataref("laminar/b738/fmodpack/fmod_announcement_set", "number")

--test

axp_dev_event = create_dataref("axp/dev_event","number")

-- new AXP 1811

B738DR_vol_FAC = create_dataref("laminar/b738/fmodpack/fmod_vol_FAC", "number")


--- new 1803-03-09+


B738DR_vol_weather = create_dataref("laminar/b738/fmodpack/fmod_vol_weather", "number")

--obsolete but kept to maintain compatibility with Zibo's FMC menu
B738DR_enable_crew					= create_dataref("laminar/b738/fmodpack/fmod_crew_on", "number")


---------- FIND REFS -------------------------------------------------------------------------------




-- to control overall interior volume (XP11 setting) directly from FMC
B738DR_vol_int_XP = find_dataref("sim/operation/sound/interior_volume_ratio")

---------- COMMANDS HANDLER FUNCTIONS -------------------------------------------------------------------------------

--- DEV
function dev_CMDhandler(phase, duration)

	if phase == 0 then
		if axp_dev_event  == 0 then
			axp_dev_event  = 1
		elseif axp_dev_event  == 1 then
			axp_dev_event  = 0
		end
	end
end
--- DEV

function B738_enable_pax_boarding_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_enable_pax_boarding == 0 then
			B738DR_enable_pax_boarding = 1
		elseif B738DR_enable_pax_boarding == 1 then
			B738DR_enable_pax_boarding = 0
		end
	end
end

function B738_enable_gyro_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_enable_gyro == 0 then
			B738DR_enable_gyro = 1
		elseif B738DR_enable_gyro == 1 then
			B738DR_enable_gyro = 0
		end
	end
end

function B738_enable_chatter_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_enable_chatter == 0 then
			B738DR_enable_chatter = 1
		elseif B738DR_enable_chatter == 1 then
			B738DR_enable_chatter = 0
		end
	end
end

--************** EDITED by ZIBO 29.11.2017
function B738_airport_set_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_airport_set == 1 then
			B738DR_airport_set = 2
		elseif B738DR_airport_set == 2 then
			B738DR_airport_set = 3
		else
			B738DR_airport_set = 1
		end
	end 
end
--**************


-- B738DR_announcement_set , 3 = male set

function B738_announcement_set_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_announcement_set == 0 then
			B738DR_announcement_set = 1
		elseif B738DR_announcement_set == 1 then
			B738DR_announcement_set = 2
		elseif B738DR_announcement_set == 2 then
			B738DR_announcement_set = 3
		elseif B738DR_announcement_set == 3 then
			B738DR_announcement_set = 4
		elseif B738DR_announcement_set == 4 then
			B738DR_announcement_set = 5
		elseif B738DR_announcement_set == 5 then
			B738DR_announcement_set = 6
		elseif B738DR_announcement_set == 6 then
			B738DR_announcement_set = 7
		elseif B738DR_announcement_set == 7 then
			B738DR_announcement_set = 8
		elseif B738DR_announcement_set == 8 then
			B738DR_announcement_set = 9
		elseif B738DR_announcement_set == 9 then
			B738DR_announcement_set = 10
		elseif B738DR_announcement_set == 10 then
			B738DR_announcement_set = 0
		end
	end 
end



-- function to drop internal volume by 10 db
function B738_vol_int_ducker_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_vol_int_ducker == 0 then
			B738DR_vol_int_ducker = 1
		elseif B738DR_vol_int_ducker == 1 then
			B738DR_vol_int_ducker = 0
		end
	end
end

-- function to control eng volume inside
function B738_vol_int_eng_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_vol_int_eng <= 9 then
			B738DR_vol_int_eng = (B738DR_vol_int_eng +1)
		elseif B738DR_vol_int_eng == 10 then
			B738DR_vol_int_eng = 0
		end
	end
end

-- function to control eng volume inside
function B738_vol_int_start_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_vol_int_start <= 9 then
			B738DR_vol_int_start = (B738DR_vol_int_start +1)
		elseif B738DR_vol_int_start == 10 then
			B738DR_vol_int_start = 0
		end
	end
end

--  function to control AC volume inside 
function B738_vol_int_ac_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_vol_int_ac <= 9 then
			B738DR_vol_int_ac = (B738DR_vol_int_ac +1)
		elseif B738DR_vol_int_ac == 10 then
			B738DR_vol_int_ac = 0
		end
	end
end

-- function to control AC volume inside 
function B738_vol_int_gyro_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_vol_int_gyro <= 9 then
			B738DR_vol_int_gyro = (B738DR_vol_int_gyro +1)
		elseif B738DR_vol_int_gyro == 10 then
			B738DR_vol_int_gyro = 0
		end
	end
end

-- function to control roll volume inside 
function B738_vol_int_roll_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_vol_int_roll <= 9 then
			B738DR_vol_int_roll = (B738DR_vol_int_roll +1)
		elseif B738DR_vol_int_roll == 10 then
			B738DR_vol_int_roll = 0
		end
	end
end


-- function to control intensity of extra bumps volume inside NEW **** audiobirdxp
function B738_vol_int_bump_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_vol_int_bump <= 9 then
			B738DR_vol_int_bump = (B738DR_vol_int_bump +1)
		elseif B738DR_vol_int_bump == 10 then
			B738DR_vol_int_bump = 0
		end
	end
end


-- function to control PAX volume

function B738_vol_int_pax_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_vol_int_pax <= 9 then
			B738DR_vol_int_pax = (B738DR_vol_int_pax +1)
		elseif B738DR_vol_int_pax == 10 then
			B738DR_vol_int_pax = 0
		end
	end
end

-- function to toggle PAX applause on landing ON or OFF

function B738_vol_int_pax_applause_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_vol_int_pax_applause == 0 then
			B738DR_vol_int_pax_applause = 1
		elseif B738DR_vol_int_pax_applause == 1 then
			B738DR_vol_int_pax_applause = 0
		end
	end
end

-- function to control wind volume

function B738_vol_int_wind_vol_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_vol_int_wind_vol <= 9 then
			B738DR_vol_int_wind_vol = (B738DR_vol_int_wind_vol +1)
		elseif B738DR_vol_int_wind_vol == 10 then
			B738DR_vol_int_wind_vol = 0
		end
	end
end


-- function to mute the trimwheel when AP is trimmming NEW AUDIOBIRDXP 8-7-2017

function B738_enable_mutetrim_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_enable_mutetrim == 0 then
			B738DR_enable_mutetrim = 1
		elseif B738DR_enable_mutetrim == 1 then
			B738DR_enable_mutetrim = 0
		end
	end
end

-- function to mute the long or short GPWS self test NEW AUDIOBIRDXP 4-8-2017


function B738_mute_gpwstest_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_mute_gpwstest == 0 then
			B738DR_mute_gpwstest = 1
		elseif B738DR_mute_gpwstest == 1 then
			B738DR_mute_gpwstest = 0
		end
	end
end


-- function to control overall interior volume from FMC (XP11 volume setting) NEW AUDIOBIRDXP 8-7-2017
-- from 0.0 to 1.0 !!!
-- maybe show this in FMC as 10, 20, 30, ... % so it's clear that this is not the FMOD volume but XP volume

function B738_vol_int_XP_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_vol_int_XP <= 0.9 then
			B738DR_vol_int_XP = (B738DR_vol_int_XP + 0.1)
		elseif B738DR_vol_int_XP > 0.9 then
			B738DR_vol_int_XP = 0
		end
	end
end

-- function to control airport ambience volume inside AND outside NEW AUDIOBIRDXP 8-7-2017
function B738_vol_airport_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_vol_airport <= 9 then
			B738DR_vol_airport = (B738DR_vol_airport + 1)
		elseif B738DR_vol_airport == 10 then
			B738DR_vol_airport = 0
		end
	end
end

-- function to enable or disable the FMC message chime
function B738_enable_fmc_mute_on_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_enable_fmc_mute_on == 0 then
			B738DR_enable_fmc_mute_on = 1
		elseif B738DR_enable_fmc_mute_on == 1 then
			B738DR_enable_fmc_mute_on = 0
		end
	end
end


-- ************ EDITED by Zibo 29.11.2017
function reset_welcome_msg()
	play_welcome_msg = 0
end


function reset_cruise_msg()
	play_cruise_msg = 0
end

function reset_descent_msg()
	play_descent_msg = 0
end

function reset_preland_msg()
	play_preland_msg = 0
end

function reset_turbulence_msg()
	play_turbulence_msg = 0
end
-- ************ EDITED by Zibo 29.11.2017


-- new AXP 1711

function B738_vol_PM_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_vol_PM <= 9 then
			B738DR_vol_PM = (B738DR_vol_PM + 1)
		elseif B738DR_vol_PM == 10 then
			B738DR_vol_PM = 0
		end
	end
end

function B738_vol_crew_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_vol_crew <= 9 then
			B738DR_vol_crew = (B738DR_vol_crew + 1)
		elseif B738DR_vol_crew == 10 then
			B738DR_vol_crew = 0
		end
	end
end



-- ************ EDITED by Zibo 29.11.2017

function B738_play_welcome_msg_CMDhandler(phase, duration)
	if phase == 0 then
		if play_welcome_msg == 0 then
			play_welcome_msg = 1
			if is_timer_scheduled(reset_welcome_msg) == false then
				run_after_time(reset_welcome_msg, 1)
			end
		elseif play_welcome_msg == 1 then
			if is_timer_scheduled(reset_welcome_msg) == true then
				stop_timer(reset_welcome_msg)
			end
			play_welcome_msg = 0
		end
	end
end

function B738_play_cruise_msg_CMDhandler(phase, duration)
	if phase == 0 then
		if play_cruise_msg == 0 then
			play_cruise_msg = 1
			if is_timer_scheduled(reset_cruise_msg) == false then
				run_after_time(reset_cruise_msg, 1)
			end
		elseif play_cruise_msg == 1 then
			if is_timer_scheduled(reset_cruise_msg) == true then
				stop_timer(reset_cruise_msg)
			end
			play_cruise_msg = 0
		end
	end
end

function B738_play_descent_msg_CMDhandler(phase, duration)
	if phase == 0 then
		if play_descent_msg == 0 then
			play_descent_msg = 1
			if is_timer_scheduled(reset_descent_msg) == false then
				run_after_time(reset_descent_msg, 1)
			end
		elseif play_descent_msg == 1 then
			if is_timer_scheduled(reset_descent_msg) == true then
				stop_timer(reset_descent_msg)
			end
			play_descent_msg = 0
		end
	end
end

function B738_play_preland_msg_CMDhandler(phase, duration)
	if phase == 0 then
		if play_preland_msg == 0 then
			play_preland_msg = 1
			if is_timer_scheduled(reset_preland_msg) == false then
				run_after_time(reset_preland_msg, 1)
			end
		elseif play_preland_msg == 1 then
			if is_timer_scheduled(reset_preland_msg) == true then
				stop_timer(reset_preland_msg)
			end
			play_preland_msg = 0
		end
	end
end

function B738_play_turbulence_msg_CMDhandler(phase, duration)
	if phase == 0 then
		if play_turbulence_msg == 0 then
			play_turbulence_msg = 1
			if is_timer_scheduled(reset_turbulence_msg) == false then
				run_after_time(reset_turbulence_msg, 1)
			end
		elseif play_turbulence_msg == 1 then
			if is_timer_scheduled(reset_turbulence_msg) == true then
				stop_timer(reset_turbulence_msg)
			end
			play_turbulence_msg = 0
		end
	end
end

-- ************ EDITED by Zibo 29.11.2017



-- new AXP 1712

function B738_play_cargo_CMDhandler(phase, duration)
	if phase == 0 then
		if play_cargo == 0 then
			play_cargo = 1
		elseif play_cargo == 1 then
			play_cargo = 0
		end
	end
end

-- new AXP 1711

--obsolete but kept to maintain compatibility with Zibo's FMC menu
function B738_enable_crew_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_enable_crew == 0 then
			B738DR_enable_crew = 1
		elseif B738DR_enable_crew == 1 then
			B738DR_enable_crew = 0
		end
	end
end
--obsolete but kept to maintain compatibility with Zibo's FMC menu

function B738_vol_computer_CMDhandler(phase, duration)

	if phase == 0 then
		if B738DR_vol_computer  <= 9 then
			B738DR_vol_computer  = (B738DR_vol_computer  + 1)
		elseif B738DR_vol_computer  == 10 then
			B738DR_vol_computer  = 0
		end
	end
end	


-- new AXP 1801

function B738_eng_LEAP1B_CMDhandler(phase, duration)
	if phase == 0 then
		if B738DR_eng_LEAP1B == 0 then
			B738DR_eng_LEAP1B = 1
		elseif B738DR_eng_LEAP1B == 1 then
			B738DR_eng_LEAP1B = 0
		end
	end
end

function B738_vol_FAC_CMDhandler(phase, duration)

	if phase == 0 then
		if B738DR_vol_FAC <= 9 then
			B738DR_vol_FAC = (B738DR_vol_FAC + 1)
		elseif B738DR_vol_FAC == 10 then
			B738DR_vol_FAC = 0
		end
	end
end

-- NEW AXP 1803+

-- B738DR_disable_weather = create_dataref("laminar/b738/fmodpack/fmod_disable_weather_on", "number")

function B738_vol_weather_CMDhandler(phase, duration)

	if phase == 0 then
		if B738DR_vol_weather <= 9 then
			B738DR_vol_weather = (B738DR_vol_weather + 1)
		elseif B738DR_vol_weather == 10 then
			B738DR_vol_weather = 0
		end
	end
end



---------- CREATE COMMANDS -------------------------------------------------------------------------------

-- new AXP 1801

B738CMD_eng_LEAP1B 		= create_command("laminar/b738/fmodpack/fmod_eng_LEAP1B", "TBA", B738_eng_LEAP1B_CMDhandler)



--B738CMD_enable_pax_boarding 		= create_command("laminar/b738/fmodpack/fmod_toggle_pax_boarding", "Play PAX boarding", B738_enable_pax_boarding_CMDhandler)
B738CMD_enable_pax_boarding 		= create_command("laminar/b738/fmodpack/pax_board", "Play PAX boarding", B738_enable_pax_boarding_CMDhandler)


B738CMD_enable_gyro 				= create_command("laminar/b738/fmodpack/fmod_woodpecker_on", "Toggle classic gyro vibrator ON or OFF", B738_enable_gyro_CMDhandler)

-- new AXP 1711

B738CMD_enable_chatter 		= create_command("laminar/b738/fmodpack/pax_talk", "Toggle chatter ON or OFF", B738_enable_chatter_CMDhandler)
--B738CMD_enable_chatter 		= create_command("laminar/b738/fmodpack/fmod_chatter_on", "Toggle chatter ON or OFF", B738_enable_chatter_CMDhandler)
B738CMD_airport_set 		= create_command("laminar/b738/fmodpack/fmod_airport_set", "Toggle airport ambience sets regional, busy or OFF", B738_airport_set_CMDhandler)
B738CMD_vol_int_ducker 		= create_command("laminar/b738/fmodpack/fmod_vol_int_ducker", "Toggle 10 db reduction of internal volume", B738_vol_int_ducker_CMDhandler)
B738CMD_vol_int_eng 		= create_command("laminar/b738/fmodpack/fmod_vol_int_eng", "Change engine volume inside", B738_vol_int_eng_CMDhandler)
B738CMD_vol_int_start 		= create_command("laminar/b738/fmodpack/fmod_vol_int_start", "Change engine start and stop volume inside", B738_vol_int_start_CMDhandler)

--- new commands *************** audiobirdxp
B738CMD_vol_int_ac 		= create_command("laminar/b738/fmodpack/fmod_vol_int_ac", "Change AC fans volume", B738_vol_int_ac_CMDhandler)
B738CMD_vol_int_gyro 		= create_command("laminar/b738/fmodpack/fmod_vol_int_gyro", "Change gyro vibrator volume if enabled", B738_vol_int_gyro_CMDhandler)
B738CMD_vol_int_roll		= create_command("laminar/b738/fmodpack/fmod_vol_int_roll", "Change roll volume", B738_vol_int_roll_CMDhandler)
B738CMD_vol_int_bump		= create_command("laminar/b738/fmodpack/fmod_vol_int_bump", "Change intensity of extra bumps when rolling", B738_vol_int_bump_CMDhandler)


-- ********************* NEW audiobirdxp 28-06-2017

B738CMD_vol_int_pax		= create_command("laminar/b738/fmodpack/fmod_vol_int_pax", "Change volume of passengers if enabled", B738_vol_int_pax_CMDhandler)
B738CMD_vol_int_pax_applause		= create_command("laminar/b738/fmodpack/fmod_pax_applause_on", "Toggle passengers applause on landing On or OFF", B738_vol_int_pax_applause_CMDhandler)
B738CMD_vol_int_wind_vol		= create_command("laminar/b738/fmodpack/fmod_vol_int_wind", "Change wind volume", B738_vol_int_wind_vol_CMDhandler)


-- ********************* NEW audiobirdxp 8-7-2017
-- ********************* AP trim wheel mute

B738CMD_enable_mutetrim 		= create_command("laminar/b738/fmodpack/fmod_mutetrim_on", "Toggle trimwheel muting ON or OFF", B738_enable_mutetrim_CMDhandler)

-- ********************* XP11 interior volume NEW audiobirdxp 8-7-2017
B738CMD_vol_int_XP		= create_command("laminar/b738/fmodpack/fmod_vol_int_XP", "Modify overall interior volume, same as XP11 setting", B738_vol_int_XP_CMDhandler)	

-- ********************* airport volume inside and outside NEW audiobirdxp 8-7-2017

B738CMD_vol_airport		= create_command("laminar/b738/fmodpack/fmod_vol_airport", "Change airport ambience volume inside and outside", B738_vol_airport_CMDhandler)	

-- ********************* enable playback of long GWPS self test NEW audiobirdxp 8-7-2017

B738CMD_mute_gpwstest		= create_command("laminar/b738/fmodpack/fmod_mute_gpwstest", "Mute long or short GWPS self-test", B738_mute_gpwstest_CMDhandler)	

B738CMD_enable_fmc_mute_on = create_command("laminar/b738/fmodpack/fmod_enable_fmc_mute_on", "Enable or disable FMC chimes", B738_enable_fmc_mute_on_CMDhandler)	

B738CMD_announcement_set 		= create_command("laminar/b738/fmodpack/fmod_announcement_set", "Choose announcement sets 1 to 4/male", B738_announcement_set_CMDhandler)

-- new AXP 1713

-- B738DR_vol_computer = create_dataref("laminar/b738/fmodpack/fmod_vol_int_computer", "number")

B738CMD_vol_computer				= create_command("laminar/b738/fmodpack/fmod_vol_computer", "Change GPWS and TCAS volume ", B738_vol_computer_CMDhandler)	
-- new AXP 1711

B738CMD_vol_crew			= create_command("laminar/b738/fmodpack/fmod_vol_crew", "Change crew announcement volume", B738_vol_crew_CMDhandler)	
B738CMD_vol_PM				= create_command("laminar/b738/fmodpack/fmod_vol_PM", "Change Pilot Monitoring volume ", B738_vol_PM_CMDhandler)	

B738CMD_play_welcome		= create_command("laminar/b738/fmodpack/play_welcome_msg", "Play welcome message CAPT", B738_play_welcome_msg_CMDhandler)
B738CMD_play_cruise			= create_command("laminar/b738/fmodpack/play_cruise_msg", "Play cruise message CAPT", B738_play_cruise_msg_CMDhandler)
B738CMD_play_descent		= create_command("laminar/b738/fmodpack/play_descent_msg", "Play desent message CAPT", B738_play_descent_msg_CMDhandler)
B738CMD_play_preland		= create_command("laminar/b738/fmodpack/play_preland_msg", "Play on approach messages CAPT FA", B738_play_preland_msg_CMDhandler)
B738CMD_play_turbulence		= create_command("laminar/b738/fmodpack/play_turbulence_msg", "Play turbulence warning FA", B738_play_turbulence_msg_CMDhandler)

B738CMD_play_cargo 			= create_command("laminar/b738/fmodpack/fmod_play_cargo", "Play cargo loading / catering crew / cleaning crew", B738_play_cargo_CMDhandler)

-- new AXP 1711

--obsolete but kept to maintain compatibility with FMC menu
-- Please REMOVE from FMC
B738CMD_enable_crew		= create_command("laminar/b738/fmodpack/fmod_crew_on", "Toggle crew ON or OFF", B738_enable_crew_CMDhandler)
--obsolete but kept to maintain compatibility with FMC menu

-- test

CMD_axp_dev_event = create_command("axp/dev_event", "For developers only", dev_CMDhandler)

-- new AXP 1801


B738CMD_vol_FAC		= create_command("laminar/b738/fmodpack/fmod_vol_FAC", "Change volume of FA in-cockpit events", B738_vol_FAC_CMDhandler)


-- NEW AXP 1803

B738CMD_vol_weather = create_command("laminar/b378/fmodpack/fmod_vol_weather", "Control volume of thunder and rain", B738_vol_weather_CMDhandler)


function after_physics() 
end

-- AXP 1711:
-- prepared scripts to be used with menu
-- removed automation for cruise / descent / preland messages
-- removed toggles for CREW and PM, replace by volume function for CREW and PM

-- AXP 1712:
-- added support for cargo loading etc

