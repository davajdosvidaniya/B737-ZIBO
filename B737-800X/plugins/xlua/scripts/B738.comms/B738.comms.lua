--[[
*****************************************************************************************
* Program Script Name	:	B747.15.com
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

first_time = 0
ac_stdbus_status_old = 0
ac_tnsbus2_status_old = 0

--*************************************************************************************--
--** 					            LOCAL VARIABLES                 				 **--
--*************************************************************************************--




--*************************************************************************************--
--** 				                X-PLANE DATAREFS            			    	 **--
--*************************************************************************************--

simDR_startup_running       = find_dataref("sim/operation/prefs/startup_running")





--*************************************************************************************--
--** 				              FIND CUSTOM DATAREFS             			    	 **--
--*************************************************************************************--

B738DR_ac_stdbus_status		= find_dataref("laminar/B738/electric/ac_stdbus_status")
B738DR_ac_tnsbus1_status	= find_dataref("laminar/B738/electric/ac_tnsbus1_status")
B738DR_ac_tnsbus2_status	= find_dataref("laminar/B738/electric/ac_tnsbus2_status")


--*************************************************************************************--
--** 				        CREATE READ-ONLY CUSTOM DATAREFS               	         **--
--*************************************************************************************--

-- RADIO TUNING PANEL LEFT
B738DR_rtp_L_offside_tuning_status  = create_dataref("laminar/B738/comm/rtp_L/offside_tuning_status", "number")
B738DR_rtp_L_off_status             = create_dataref("laminar/B738/comm/rtp_L/off_status", "number")
B738DR_rtp_L_vhf_1_status           = create_dataref("laminar/B738/comm/rtp_L/vhf_1_status", "number")
B738DR_rtp_L_vhf_2_status           = create_dataref("laminar/B738/comm/rtp_L/vhf_2_status", "number")
B738DR_rtp_L_vhf_3_status           = create_dataref("laminar/B738/comm/rtp_L/vhf_3_status", "number")
B738DR_rtp_L_hf_1_status            = create_dataref("laminar/B738/comm/rtp_L/hf_1_status", "number")
B738DR_rtp_L_am_status              = create_dataref("laminar/B738/comm/rtp_L/am_status", "number")
B738DR_rtp_L_hf_2_status            = create_dataref("laminar/B738/comm/rtp_L/hf_2_status", "number")
B738DR_rtp_L_freq_MHz_sel_dial_pos  = create_dataref("laminar/B738/comm/rtp_L/freq_MHz/sel_dial_pos", "number")
B738DR_rtp_L_freq_khz_sel_dial_pos  = create_dataref("laminar/B738/comm/rtp_L/freq_khz/sel_dial_pos", "number")
B738DR_rtp_L_lcd_to_display         = create_dataref("laminar/B738/comm/rtp_L/lcd_to_display", "number")

B738DR_rtp_L_freq_switch_pos		= create_dataref("laminar/B738/comm/push_button/rtp_L_freq_swap", "number")


-- RADIO TUNING PANEL RIGHT
B738DR_rtp_R_offside_tuning_status  = create_dataref("laminar/B738/comm/rtp_R/offside_tuning_status", "number")
B738DR_rtp_R_off_status             = create_dataref("laminar/B738/comm/rtp_R/off_status", "number")
B738DR_rtp_R_vhf_1_status           = create_dataref("laminar/B738/comm/rtp_R/vhf_1_status", "number")
B738DR_rtp_R_vhf_2_status           = create_dataref("laminar/B738/comm/rtp_R/vhf_2_status", "number")
B738DR_rtp_R_vhf_3_status           = create_dataref("laminar/B738/comm/rtp_R/vhf_3_status", "number")
B738DR_rtp_R_hf_1_status            = create_dataref("laminar/B738/comm/rtp_R/hf_1_status", "number")
B738DR_rtp_R_am_status              = create_dataref("laminar/B738/comm/rtp_R/am_status", "number")
B738DR_rtp_R_hf_2_status            = create_dataref("laminar/B738/comm/rtp_R/hf_2_status", "number")
B738DR_rtp_R_freq_MHz_sel_dial_pos  = create_dataref("laminar/B738/comm/rtp_R/freq_MHz/sel_dial_pos", "number")
B738DR_rtp_R_freq_khz_sel_dial_pos  = create_dataref("laminar/B738/comm/rtp_R/freq_khz/sel_dial_pos", "number")
B738DR_rtp_R_lcd_to_display         = create_dataref("laminar/B738/comm/rtp_R/lcd_to_display", "number")

B738DR_rtp_R_freq_switch_pos		= create_dataref("laminar/B738/comm/push_button/rtp_R_freq_swap", "number")

B738DR_nav1_status					= create_dataref("laminar/B738/comm/nav1_status", "number")
B738DR_nav2_status					= create_dataref("laminar/B738/comm/nav2_status", "number")

B738DR_com1_audio_sel_pos			= create_dataref("laminar/B738/comm/com1_audio_sel_pos", "number")
B738DR_com2_audio_sel_pos			= create_dataref("laminar/B738/comm/com2_audio_sel_pos", "number")
B738DR_nav1_audio_sel_pos			= create_dataref("laminar/B738/comm/nav1_audio_sel_pos", "number")
B738DR_nav2_audio_sel_pos			= create_dataref("laminar/B738/comm/nav2_audio_sel_pos", "number")
B738DR_mark_audio_sel_pos			= create_dataref("laminar/B738/comm/mark_audio_sel_pos", "number")

--*************************************************************************************--
--** 				       READ-WRITE CUSTOM DATAREF HANDLERS     	        	     **--
--*************************************************************************************--

-- RADIO TUNING PANEL LEFT
function B738_rtp_L_hf_sens_ctrl_rheo_DRhandler() end


-- RADIO TUNING PANEL RIGHT
function B738_rtp_R_hf_sens_ctrl_rheo_DRhandler() end




--*************************************************************************************--
--** 				       CREATE READ-WRITE CUSTOM DATAREFS                         **--
--*************************************************************************************--

-- RADIO TUNING PANEL LEFT
B738DR_rtp_L_hf_sens_ctrl_rheo      = create_dataref("laminar/B738/comm/rtp_L/hf_sens_ctrl/rheostat", "number", B738_rtp_L_hf_sens_ctrl_rheo_DRhandler)


-- RADIO TUNING PANEL RIGHT
B738DR_rtp_R_hf_sens_ctrl_rheo      = create_dataref("laminar/B738/comm/rtp_R/hf_sens_ctrl/rheostat", "number", B738_rtp_R_hf_sens_ctrl_rheo_DRhandler)




--*************************************************************************************--
--** 				             X-PLANE COMMAND HANDLERS               	    	 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				                 X-PLANE COMMANDS                   	    	 **--
--*************************************************************************************--

simCMD_com1_stby_coarse_up  = find_command("sim/radios/stby_com1_coarse_up")
simCMD_com1_stby_coarse_dn  = find_command("sim/radios/stby_com1_coarse_down")
simCMD_com2_stby_coarse_up  = find_command("sim/radios/stby_com2_coarse_up")
simCMD_com2_stby_coarse_dn  = find_command("sim/radios/stby_com2_coarse_down")

simCMD_com1_stby_fine_up    = find_command("sim/radios/stby_com1_fine_up_833")
simCMD_com1_stby_fine_dn    = find_command("sim/radios/stby_com1_fine_down_833")
simCMD_com2_stby_fine_up    = find_command("sim/radios/stby_com2_fine_up_833")
simCMD_com2_stby_fine_dn    = find_command("sim/radios/stby_com2_fine_down_833")

simCMD_com1_stby_flip       = find_command("sim/radios/com1_standy_flip")
simCMD_com2_stby_flip       = find_command("sim/radios/com2_standy_flip")

simCMD_audio_com1 			= find_command("sim/audio_panel/monitor_audio_com1")
simCMD_audio_com2 			= find_command("sim/audio_panel/monitor_audio_com2")
simCMD_audio_nav1 			= find_command("sim/audio_panel/monitor_audio_nav1")
simCMD_audio_nav2 			= find_command("sim/audio_panel/monitor_audio_nav2")
simCMD_audio_mark 			= find_command("sim/audio_panel/monitor_audio_mkr")

--*************************************************************************************--
--** 				              CUSTOM COMMAND HANDLERS            			     **--
--*************************************************************************************--

-- RADIO TUNING PANEL LEFT
function B738_rtp_L_off_switch_CMDhandler(phase, duration)
    if phase == 0 then
		if B738DR_ac_stdbus_status == 1 then
			if B738DR_rtp_L_off_status == 0 then
				B738DR_rtp_L_off_status = 1
				B738DR_rtp_L_lcd_to_display = 90
				B738_radio_sel_swap(0, 0, 0, 0, 0, 0, 0)
				B738DR_rtp_L_offside_tuning_status = 0
			elseif B738DR_rtp_L_off_status == 1 then
				B738DR_rtp_L_off_status = 0
				--B738_lcd_display_status()
				B738_radio_sel_swap(0, 1, 0, 0, 0, 0, 0)
			end
		end
    end
end

function B738_rtp_L_vhf_1_sel_switch_CMDhandler(phase, duration)
    if phase == 0 then
 		if B738DR_rtp_L_off_status == 0 then
			B738_radio_sel_swap(0, 1, 0, 0, 0, 0, 0)
		end
    end
end

function B738_rtp_L_vhf_2_sel_switch_CMDhandler(phase, duration)
    if phase == 0 then
 		if B738DR_rtp_L_off_status == 0 then
			B738_radio_sel_swap(0, 0, 1, 0, 0, 0, 0)
		end
    end
end


function B738_rtp_L_vhf_3_sel_switch_CMDhandler(phase, duration)
    if phase == 0 then
 		if B738DR_rtp_L_off_status == 0 then
			B738_radio_sel_swap(0, 0, 0, 1, 0, 0, 0)
		end
    end
end

function B738_rtp_L_hf_1_sel_switch_CMDhandler(phase, duration)
    if phase == 0 then
 		if B738DR_rtp_L_off_status == 0 then
			B738_radio_sel_swap(0, 0, 0, 0, 1, 0, 0)
		end
    end
end

function B738_rtp_L_am_sel_switch_CMDhandler(phase, duration)
    if phase == 0 then
 		if B738DR_rtp_L_off_status == 0 then
			B738_radio_sel_swap(0, 0, 0, 0, 0, 1, 0)
		end
    end
end

function B738_rtp_L_hf_2_sel_switch_CMDhandler(phase, duration)
    if phase == 0 then
 		if B738DR_rtp_L_off_status == 0 then
			B738_radio_sel_swap(0, 0, 0, 0, 0, 0, 1)
		end
    end
end

function B738_rtp_L_freq_txfr_switch_CMDhandler(phase, duration)
    if phase == 0 then
        if B738DR_rtp_L_lcd_to_display == 0 then
            simCMD_com1_stby_flip:once()
           	B738DR_rtp_L_freq_switch_pos = 1
        elseif B738DR_rtp_L_lcd_to_display == 1 then
            simCMD_com2_stby_flip:once()
            B738DR_rtp_L_freq_switch_pos = 1
        end
    elseif phase == 2 then
      	B738DR_rtp_L_freq_switch_pos = 0
    end
end

function B738_rtp_L_freq_MHz_sel_dial_up_CMDhandler(phase, duration)

    if phase == 0 then
        if B738DR_rtp_L_off_status == 0 then
            if B738DR_rtp_L_lcd_to_display == 0 then
                simCMD_com1_stby_coarse_up:once()
            elseif B738DR_rtp_L_lcd_to_display == 1 then
                simCMD_com2_stby_coarse_up:once()
            end
        end
        B738DR_rtp_L_freq_MHz_sel_dial_pos = B738DR_rtp_L_freq_MHz_sel_dial_pos + 1
    elseif phase == 1 then
        if duration > 0.5 then
            if B738DR_rtp_L_off_status == 0 then
                if B738DR_rtp_L_lcd_to_display == 0 then
                    simCMD_com1_stby_coarse_up:once()
                elseif B738DR_rtp_L_lcd_to_display == 1 then
                    simCMD_com2_stby_coarse_up:once()
                end
            end
            B738DR_rtp_L_freq_MHz_sel_dial_pos = B738DR_rtp_L_freq_MHz_sel_dial_pos + 1
        end
    end

end

function B738_rtp_L_freq_MHz_sel_dial_dn_CMDhandler(phase, duration)
    if phase == 0 then
        if B738DR_rtp_L_off_status == 0 then
            if B738DR_rtp_L_lcd_to_display == 0 then
                simCMD_com1_stby_coarse_dn:once()
            elseif B738DR_rtp_L_lcd_to_display == 1 then
                simCMD_com2_stby_coarse_dn:once()
            end
        end
        B738DR_rtp_L_freq_MHz_sel_dial_pos = B738DR_rtp_L_freq_MHz_sel_dial_pos - 1
    elseif phase == 1 then
        if duration > 0.5 then
            if B738DR_rtp_L_off_status == 0 then
                if B738DR_rtp_L_lcd_to_display == 0 then
                    simCMD_com1_stby_coarse_dn:once()
                elseif B738DR_rtp_L_lcd_to_display == 1 then
                    simCMD_com2_stby_coarse_dn:once()
                end
            end
            B738DR_rtp_L_freq_MHz_sel_dial_pos = B738DR_rtp_L_freq_MHz_sel_dial_pos - 1
        end
    end
end

function B738_rtp_L_freq_khz_sel_dial_up_CMDhandler(phase, duration)
    if phase == 0 then
        if B738DR_rtp_L_off_status == 0 then
            if B738DR_rtp_L_lcd_to_display == 0 then
                simCMD_com1_stby_fine_up:once()
            elseif B738DR_rtp_L_lcd_to_display == 1 then
                simCMD_com2_stby_fine_up:once()
            end
        end
        B738DR_rtp_L_freq_khz_sel_dial_pos = B738DR_rtp_L_freq_khz_sel_dial_pos + 1
    elseif phase == 1 then
        if duration > 0.5 then
            if B738DR_rtp_L_off_status == 0 then
                if B738DR_rtp_L_lcd_to_display == 0 then
                    simCMD_com1_stby_fine_up:once()
                elseif B738DR_rtp_L_lcd_to_display == 1 then
                    simCMD_com2_stby_fine_up:once()
                end
            end
            B738DR_rtp_L_freq_khz_sel_dial_pos = B738DR_rtp_L_freq_khz_sel_dial_pos + 1
        end
    end
end

function B738_rtp_L_freq_khz_sel_dial_dn_CMDhandler(phase, duration)
    if phase == 0 then
        if B738DR_rtp_L_off_status == 0 then
            if B738DR_rtp_L_lcd_to_display == 0 then
                simCMD_com1_stby_fine_dn:once()
            elseif B738DR_rtp_L_lcd_to_display == 1 then
                simCMD_com2_stby_fine_dn:once()
            end
        end
        B738DR_rtp_L_freq_khz_sel_dial_pos = B738DR_rtp_L_freq_khz_sel_dial_pos - 1
    elseif phase == 1 then
        if duration > 0.5 then
            if B738DR_rtp_L_off_status == 0 then
                if B738DR_rtp_L_lcd_to_display == 0 then
                    simCMD_com1_stby_fine_dn:once()
                elseif B738DR_rtp_L_lcd_to_display == 1 then
                    simCMD_com2_stby_fine_dn:once()
                end
            end
            B738DR_rtp_L_freq_khz_sel_dial_pos = B738DR_rtp_L_freq_khz_sel_dial_pos - 1
        end
    end
end




-- RADIO TUNING PANEL RIGHT
function B738_rtp_R_off_switch_CMDhandler(phase, duration)
    if phase == 0 then
		if B738DR_ac_tnsbus2_status == 1 then
			if B738DR_rtp_R_off_status == 0 then
				B738DR_rtp_R_off_status = 1
				B738DR_rtp_R_lcd_to_display = 90
				B738_radio_sel_swap(1, 0, 0, 0, 0, 0, 0)
				B738DR_rtp_R_offside_tuning_status = 0
			elseif B738DR_rtp_R_off_status == 1 then
				B738DR_rtp_R_off_status = 0
				B738_radio_sel_swap(1, 0, 1, 0, 0, 0, 0)
				--B738_lcd_display_status()
			end
		end
    end
end

function B738_rtp_R_vhf_1_sel_switch_CMDhandler(phase, duration)
    if phase == 0 then
		if B738DR_rtp_R_off_status == 0 then
			B738_radio_sel_swap(1, 1, 0, 0, 0, 0, 0)
		end
    end
end

function B738_rtp_R_vhf_2_sel_switch_CMDhandler(phase, duration)
    if phase == 0 then
		if B738DR_rtp_R_off_status == 0 then
			B738_radio_sel_swap(1, 0, 1, 0, 0, 0, 0)
		end
    end
end

function B738_rtp_R_vhf_3_sel_switch_CMDhandler(phase, duration)
    if phase == 0 then
		if B738DR_rtp_R_off_status == 0 then
			B738_radio_sel_swap(1, 0, 0, 1, 0, 0, 0)
		end
    end
end

function B738_rtp_R_hf_1_sel_switch_CMDhandler(phase, duration)
    if phase == 0 then
		if B738DR_rtp_R_off_status == 0 then
			B738_radio_sel_swap(1, 0, 0, 0, 1, 0, 0)
		end
    end
end

function B738_rtp_R_am_sel_switch_CMDhandler(phase, duration)
    if phase == 0 then
		if B738DR_rtp_R_off_status == 0 then
			B738_radio_sel_swap(1, 0, 0, 0, 0, 1, 0)
		end
    end
end

function B738_rtp_R_hf_2_sel_switch_CMDhandler(phase, duration)
    if phase == 0 then
		if B738DR_rtp_R_off_status == 0 then
			B738_radio_sel_swap(1, 0, 0, 0, 0, 0, 1)
		end
    end
end

function B738_rtp_R_freq_txfr_switch_CMDhandler(phase, duration)
    if phase == 0 then
		if B738DR_rtp_R_lcd_to_display == 0 then
			simCMD_com1_stby_flip:once()
			B738DR_rtp_R_freq_switch_pos = 1
		elseif B738DR_rtp_R_lcd_to_display == 1 then
			simCMD_com2_stby_flip:once()
			B738DR_rtp_R_freq_switch_pos = 1
        end
	elseif phase == 2 then
		B738DR_rtp_R_freq_switch_pos = 0
    end
end

function B738_rtp_R_freq_MHz_sel_dial_up_CMDhandler(phase, duration)
    if phase == 0 then
        if B738DR_rtp_R_off_status == 0 then
            if B738DR_rtp_R_lcd_to_display == 0 then
                simCMD_com1_stby_coarse_up:once()
            elseif B738DR_rtp_R_lcd_to_display == 1 then
                simCMD_com2_stby_coarse_up:once()
            end
        end
        B738DR_rtp_R_freq_MHz_sel_dial_pos = B738DR_rtp_R_freq_MHz_sel_dial_pos + 1
    elseif phase == 1 then
        if duration > 0.5 then
            if B738DR_rtp_R_off_status == 0 then
                if B738DR_rtp_R_lcd_to_display == 0 then
                    simCMD_com1_stby_coarse_up:once()
                elseif B738DR_rtp_R_lcd_to_display == 1 then
                    simCMD_com2_stby_coarse_up:once()
                end
            end
            B738DR_rtp_R_freq_MHz_sel_dial_pos = B738DR_rtp_R_freq_MHz_sel_dial_pos + 1
        end
    end
end

function B738_rtp_R_freq_MHz_sel_dial_dn_CMDhandler(phase, duration)
    if phase == 0 then
        if B738DR_rtp_R_off_status == 0 then
            if B738DR_rtp_R_lcd_to_display == 0 then
                simCMD_com1_stby_coarse_dn:once()
            elseif B738DR_rtp_R_lcd_to_display == 1 then
                simCMD_com2_stby_coarse_dn:once()
            end
        end
        B738DR_rtp_R_freq_MHz_sel_dial_pos = B738DR_rtp_R_freq_MHz_sel_dial_pos - 1
    elseif phase == 1 then
        if duration > 0.5 then
            if B738DR_rtp_R_lcd_to_display == 0 then
                simCMD_com1_stby_coarse_dn:once()
            elseif B738DR_rtp_R_lcd_to_display == 1 then
                simCMD_com2_stby_coarse_dn:once()
            end
            B738DR_rtp_R_freq_MHz_sel_dial_pos = B738DR_rtp_R_freq_MHz_sel_dial_pos - 1
        end
    end
end

function B738_rtp_R_freq_khz_sel_dial_up_CMDhandler(phase, duration)
    if phase == 0 then
        if B738DR_rtp_R_off_status == 0 then
            if B738DR_rtp_R_lcd_to_display == 0 then
                simCMD_com1_stby_fine_up:once()
            elseif B738DR_rtp_R_lcd_to_display == 1 then
                simCMD_com2_stby_fine_up:once()
            end
        end
        B738DR_rtp_R_freq_khz_sel_dial_pos = B738DR_rtp_R_freq_khz_sel_dial_pos + 1
    elseif phase == 1 then
        if duration > 0.5 then
            if B738DR_rtp_R_off_status == 0 then
                if B738DR_rtp_R_lcd_to_display == 0 then
                    simCMD_com1_stby_fine_up:once()
                elseif B738DR_rtp_R_lcd_to_display == 1 then
                    simCMD_com2_stby_fine_up:once()
                end
            end
            B738DR_rtp_R_freq_khz_sel_dial_pos = B738DR_rtp_R_freq_khz_sel_dial_pos + 1
        end
    end
end

function B738_rtp_R_freq_khz_sel_dial_dn_CMDhandler(phase, duration)
    if phase == 0 then
        if B738DR_rtp_R_off_status == 0 then
            if B738DR_rtp_R_lcd_to_display == 0 then
                simCMD_com1_stby_fine_dn:once()
            elseif B738DR_rtp_R_lcd_to_display == 1 then
                simCMD_com2_stby_fine_dn:once()
            end
        end
        B738DR_rtp_R_freq_khz_sel_dial_pos = B738DR_rtp_R_freq_khz_sel_dial_pos - 1
    elseif phase == 1 then
        if duration > 0.5 then
            if B738DR_rtp_R_off_status == 0 then
                if B738DR_rtp_R_lcd_to_display == 0 then
                    simCMD_com1_stby_fine_dn:once()
                elseif B738DR_rtp_R_lcd_to_display == 1 then
                    simCMD_com2_stby_fine_dn:once()
                end
            end
            B738DR_rtp_R_freq_khz_sel_dial_pos = B738DR_rtp_R_freq_khz_sel_dial_pos - 1
        end
    end
end

function B738_com1_audio_sel_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_com1_audio_sel_pos = 1
		simCMD_audio_com1:once()
	elseif phase == 2 then
		B738DR_com1_audio_sel_pos = 0
	end
end

function B738_com2_audio_sel_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_com2_audio_sel_pos = 1
		simCMD_audio_com2:once()
	elseif phase == 2 then
		B738DR_com2_audio_sel_pos = 0
	end
end

function B738_nav1_audio_sel_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_nav1_audio_sel_pos = 1
		simCMD_audio_nav1:once()
	elseif phase == 2 then
		B738DR_nav1_audio_sel_pos = 0
	end
end

function B738_nav2_audio_sel_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_nav2_audio_sel_pos = 1
		simCMD_audio_nav2:once()
	elseif phase == 2 then
		B738DR_nav2_audio_sel_pos = 0
	end
end

function B738_mark_audio_sel_CMDhandler(phase, duration)
	if phase == 0 then
		B738DR_mark_audio_sel_pos = 1
		simCMD_audio_mark:once()
	elseif phase == 2 then
		B738DR_mark_audio_sel_pos = 0
	end
end


--*************************************************************************************--
--** 				              CREATE CUSTOM COMMANDS              			     **--
--*************************************************************************************--

-- RADIO TUNING PANEL LEFT
B738CMD_rtp_L_off_switch            = create_command("laminar/B738/rtp_L/off_switch", "Radio Tuning Panel Left OFF Switch", B738_rtp_L_off_switch_CMDhandler)
B738CMD_rtp_L_vhf_1_sel_switch      = create_command("laminar/B738/rtp_L/vhf_1/sel_switch", "Radio Tuning Panel Left VHF L Sel Switch", B738_rtp_L_vhf_1_sel_switch_CMDhandler)
B738CMD_rtp_L_vhf_2_sel_switch      = create_command("laminar/B738/rtp_L/vhf_2/sel_switch", "Radio Tuning Panel Left VHF C Sel Switch", B738_rtp_L_vhf_2_sel_switch_CMDhandler)
B738CMD_rtp_L_vhf_3_sel_switch      = create_command("laminar/B738/rtp_L/vhf_3/sel_switch", "Radio Tuning Panel Left VHF R Sel Switch", B738_rtp_L_vhf_3_sel_switch_CMDhandler)
B738CMD_rtp_L_hf_1_sel_switch       = create_command("laminar/B738/rtp_L/hf_1/sel_switch", "Radio Tuning Panel Left HF L SelSwitch", B738_rtp_L_hf_1_sel_switch_CMDhandler)
B738CMD_rtp_L_am_sel_switch         = create_command("laminar/B738/rtp_L/am/sel_switch", "Radio Tuning Panel Left AM Sel Switch", B738_rtp_L_am_sel_switch_CMDhandler)
B738CMD_rtp_L_hf_2_sel_switch       = create_command("laminar/B738/rtp_L/hf_2/sel_switch", "Radio Tuning Panel Left HF R Sel Switch", B738_rtp_L_hf_2_sel_switch_CMDhandler)
B738CMD_rtp_L_freq_txfr_switch      = create_command("laminar/B738/rtp_L/freq_txfr/sel_switch", "Radio Tuning Panel Left Freq Txfr Switch", B738_rtp_L_freq_txfr_switch_CMDhandler)

B738CMD_rtp_L_freq_MHz_sel_dial_up  = create_command("laminar/B738/rtp_L/freq_MHz/sel_dial_up", "Radio Tuning Panel Left Freq MHz Sel Up", B738_rtp_L_freq_MHz_sel_dial_up_CMDhandler)
B738CMD_rtp_L_freq_MHz_sel_dial_dn  = create_command("laminar/B738/rtp_L/freq_MHz/sel_dial_dn", "Radio Tuning Panel Left Freq MHz Sel Down", B738_rtp_L_freq_MHz_sel_dial_dn_CMDhandler)

B738CMD_rtp_L_freq_khz_sel_dial_up  = create_command("laminar/B738/rtp_L/freq_khz/sel_dial_up", "Radio Tuning Panel Left Freq khz Sel Up", B738_rtp_L_freq_khz_sel_dial_up_CMDhandler)
B738CMD_rtp_L_freq_khz_sel_dial_dn  = create_command("laminar/B738/rtp_L/freq_khz/sel_dial_dn", "Radio Tuning Panel Left Freq khz Sel Down", B738_rtp_L_freq_khz_sel_dial_dn_CMDhandler)


-- RADIO TUNING PANEL RIGHT
B738CMD_rtp_R_off_switch            = create_command("laminar/B738/rtp_R/off_switch", "Radio Tuning Panel Right OFF Switch", B738_rtp_R_off_switch_CMDhandler)
B738CMD_rtp_R_vhf_1_sel_switch      = create_command("laminar/B738/rtp_R/vhf_1/sel_switch", "Radio Tuning Panel Right VHF L Sel Switch", B738_rtp_R_vhf_1_sel_switch_CMDhandler)
B738CMD_rtp_R_vhf_2_sel_switch      = create_command("laminar/B738/rtp_R/vhf_2/sel_switch", "Radio Tuning Panel Right VHF C Sel Switch", B738_rtp_R_vhf_2_sel_switch_CMDhandler)
B738CMD_rtp_R_vhf_3_sel_switch      = create_command("laminar/B738/rtp_R/vhf_3/sel_switch", "Radio Tuning Panel Right VHF R Sel Switch", B738_rtp_R_vhf_3_sel_switch_CMDhandler)
B738CMD_rtp_R_hf_1_sel_switch       = create_command("laminar/B738/rtp_R/hf_1/sel_switch", "Radio Tuning Panel Right HF L SelSwitch", B738_rtp_R_hf_1_sel_switch_CMDhandler)
B738CMD_rtp_R_am_sel_switch         = create_command("laminar/B738/rtp_R/am/sel_switch", "Radio Tuning Panel Right AM Sel Switch", B738_rtp_R_am_sel_switch_CMDhandler)
B738CMD_rtp_R_hf_2_sel_switch       = create_command("laminar/B738/rtp_R/hf_2/sel_switch", "Radio Tuning Panel Right HF R Sel Switch", B738_rtp_R_hf_2_sel_switch_CMDhandler)
B738CMD_rtp_R_freq_txfr_switch      = create_command("laminar/B738/rtp_R/freq_txfr/sel_switch", "Radio Tuning Panel Right Freq Txfr Switch", B738_rtp_R_freq_txfr_switch_CMDhandler)

B738CMD_rtp_R_freq_MHz_sel_dial_up  = create_command("laminar/B738/rtp_R/freq_MHz/sel_dial_up", "Radio Tuning Panel Right Freq MHz Sel Up", B738_rtp_R_freq_MHz_sel_dial_up_CMDhandler)
B738CMD_rtp_R_freq_MHz_sel_dial_dn  = create_command("laminar/B738/rtp_R/freq_MHz/sel_dial_dn", "Radio Tuning Panel Right Freq MHz Sel Down", B738_rtp_R_freq_MHz_sel_dial_dn_CMDhandler)

B738CMD_rtp_R_freq_khz_sel_dial_up  = create_command("laminar/B738/rtp_R/freq_khz/sel_dial_up", "Radio Tuning Panel Right Freq khz Sel Up", B738_rtp_R_freq_khz_sel_dial_up_CMDhandler)
B738CMD_rtp_R_freq_khz_sel_dial_dn  = create_command("laminar/B738/rtp_R/freq_khz/sel_dial_dn", "Radio Tuning Panel Right Freq khz Sel Down", B738_rtp_R_freq_khz_sel_dial_dn_CMDhandler)

B738CMD_com1_audio_sel 				= create_command("laminar/B738/comm/com1_audio_sel", "Com1 Audio select", B738_com1_audio_sel_CMDhandler)
B738CMD_com2_audio_sel 				= create_command("laminar/B738/comm/com2_audio_sel", "Com2 Audio select", B738_com2_audio_sel_CMDhandler)
B738CMD_nav1_audio_sel 				= create_command("laminar/B738/comm/nav1_audio_sel", "Nav1 Audio select", B738_nav1_audio_sel_CMDhandler)
B738CMD_nav2_audio_sel 				= create_command("laminar/B738/comm/nav2_audio_sel", "Nav1 Audio select", B738_nav2_audio_sel_CMDhandler)
B738CMD_mark_audio_sel 				= create_command("laminar/B738/comm/mark_audio_sel", "Marker Audio select", B738_mark_audio_sel_CMDhandler)

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





----- RESCALE ---------------------------------------------------------------------------
function B738_rescale(in1, out1, in2, out2, x)

    if x < in1 then return out1 end
    if x > in2 then return out2 end
    return out1 + (out2 - out1) * (x - in1) / (in2 - in1)

end





----- ANIMATION UNILITY -----------------------------------------------------------------
function B738_set_animation_position(current_value, target, min, max, speed)

    if target >= (max - 0.001) and current_value >= (max - 0.01) then
        return max
    elseif target <= (min + 0.001) and current_value <= (min + 0.01) then
        return min
    else
        return current_value + ((target - current_value) * (speed * SIM_PERIOD))
    end

end




----- LCD DISPLAY STATUS ----------------------------------------------------------------
function B738_lcd_display_status()

    -- SET WHICH LCD TO DISPLAY (PLANEMAKER HIDE/SHOW)
    if B738DR_rtp_L_off_status == 0 then
        if B738DR_rtp_L_vhf_1_status == 1 then
            B738DR_rtp_L_lcd_to_display = 0
        elseif B738DR_rtp_L_vhf_2_status == 1 then
            B738DR_rtp_L_lcd_to_display = 1
        else
            B738DR_rtp_L_lcd_to_display = 99
        end
    end


    if B738DR_rtp_R_off_status == 0 then
        if B738DR_rtp_R_vhf_1_status == 1 then
            B738DR_rtp_R_lcd_to_display = 0
        elseif B738DR_rtp_R_vhf_2_status == 1 then
            B738DR_rtp_R_lcd_to_display = 1
        else
            B738DR_rtp_R_lcd_to_display = 99
        end
    end

end




----- RADIO PANEL RADIO SELECTOR SWAP ---------------------------------------------------
function B738_radio_sel_swap(radio, vhf_1, vhf_2, vhf_3, hf_1, am, hf_2)

    -- SET SELECTED RADIO STATUS
    if radio == 0 then
        B738DR_rtp_L_vhf_1_status   = vhf_1
        B738DR_rtp_L_vhf_2_status   = vhf_2
        B738DR_rtp_L_vhf_3_status   = vhf_3
        B738DR_rtp_L_hf_1_status    = hf_1
        B738DR_rtp_L_am_status      = am
        B738DR_rtp_L_hf_2_status    = hf_2
		B738DR_rtp_L_offside_tuning_status = 1
		if B738DR_rtp_L_vhf_1_status == 1 or B738DR_rtp_L_vhf_2_status == 1 then
			B738DR_rtp_L_offside_tuning_status = 0
		end

    elseif radio == 1 then
        B738DR_rtp_R_vhf_1_status   = vhf_1
        B738DR_rtp_R_vhf_2_status   = vhf_2
        B738DR_rtp_R_vhf_3_status   = vhf_3
        B738DR_rtp_R_hf_1_status    = hf_1
        B738DR_rtp_R_am_status      = am
        B738DR_rtp_R_hf_2_status    = hf_2
		B738DR_rtp_R_offside_tuning_status = 1
		if B738DR_rtp_R_vhf_1_status == 1 or B738DR_rtp_R_vhf_2_status == 1 then
			B738DR_rtp_R_offside_tuning_status = 0
		end

    end


    -- SET OFFSIDE TUNING STATUS
    -- B738DR_rtp_L_offside_tuning_status = 1
    -- B738DR_rtp_R_offside_tuning_status = 1
 

    --  LEFT RADIO
    -- if (B738DR_rtp_L_vhf_1_status == 0 and B738DR_rtp_L_hf_1_status == 0)
        -- or B738DR_rtp_R_vhf_1_status == 1
        -- or B738DR_rtp_R_hf_1_status == 1
    -- then
        -- B738DR_rtp_L_offside_tuning_status = 1
    -- end


    --  RIGHT RADIO
    -- if (B738DR_rtp_R_vhf_2_status == 0 and B738DR_rtp_R_hf_2_status == 0)
        -- or B738DR_rtp_L_vhf_2_status == 1
        -- or B738DR_rtp_L_hf_2_status == 1
    -- then
        -- B738DR_rtp_R_offside_tuning_status = 1
    -- end
	
	-- if B738DR_rtp_L_vhf_1_status == 1 or B738DR_rtp_L_vhf_2_status == 1 then
		-- B738DR_rtp_L_offside_tuning_status = 0
	-- end
	
	-- if B738DR_rtp_R_vhf_1_status == 1 or B738DR_rtp_R_vhf_2_status == 1 then
		-- B738DR_rtp_R_offside_tuning_status = 0
	-- end
	
	
	
    -- UPDATE LCD DISPLAY STATUS
    B738_lcd_display_status()

end








----- AIRCRAFT LOAD ---------------------------------------------------------------------
function B738_aircraft_load_com()

    -- ALL MODES ------------------------------------------------------------------------
    B738CMD_rtp_L_vhf_1_sel_switch:once()
    B738CMD_rtp_R_vhf_2_sel_switch:once()


    B738DR_rtp_L_hf_sens_ctrl_rheo = 500
    B738DR_rtp_R_hf_sens_ctrl_rheo = 500

    
    

    -- COLD & DARK ----------------------------------------------------------------------
    if simDR_startup_running == 0 then




    -- ENGINES RUNNING ------------------------------------------------------------------
    elseif simDR_startup_running == 1 then



    end

end

function B738_electric_radios()
	
	B738DR_nav1_status = B738DR_ac_stdbus_status
	B738DR_nav2_status = B738DR_ac_tnsbus2_status
	
	if B738DR_ac_stdbus_status == 0 then
		if B738DR_rtp_L_off_status == 0 then
			B738DR_rtp_L_off_status = 1
			B738DR_rtp_L_lcd_to_display = 90
			B738_radio_sel_swap(0, 0, 0, 0, 0, 0, 0)
		end
		B738DR_rtp_L_offside_tuning_status = 0
	else
		if B738DR_rtp_L_off_status == 1 then
			if ac_stdbus_status_old ~= B738DR_ac_stdbus_status then
				B738CMD_rtp_L_off_switch:once()
			else
				B738DR_rtp_L_offside_tuning_status = 1
			end
		end
	end
	
	if B738DR_ac_tnsbus2_status == 0 then
		if B738DR_rtp_R_off_status == 0 then
			B738DR_rtp_R_off_status = 1
			B738DR_rtp_R_lcd_to_display = 90
			B738_radio_sel_swap(1, 0, 0, 0, 0, 0, 0)
		end
		B738DR_rtp_R_offside_tuning_status = 0
	else
		if B738DR_rtp_R_off_status == 1 then
			if ac_tnsbus2_status_old ~= B738DR_ac_tnsbus2_status then
				B738CMD_rtp_R_off_switch:once()
			else
				B738DR_rtp_R_offside_tuning_status = 1
			end
		end
	end
	
	ac_stdbus_status_old = B738DR_ac_stdbus_status
	ac_tnsbus2_status_old = B738DR_ac_tnsbus2_status
	
end




--*************************************************************************************--
--** 				                  EVENT CALLBACKS           	    			 **--
--*************************************************************************************--

function aircraft_load()

    B738_aircraft_load_com()

end

--function aircraft_unload() end

--function flight_start() end

--function flight_crash() end

--function before_physics() end

function after_physics()
	
	if first_time < 3 then
		first_time = first_time + 1
		ac_stdbus_status_old = B738DR_ac_stdbus_status
		ac_tnsbus2_status_old = B738DR_ac_tnsbus2_status
	else
		B738_electric_radios()
	end
	
end

--function after_replay() end



