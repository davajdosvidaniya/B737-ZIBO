

--*************************************************************************************--
--** 					               CONSTANTS                    				 **--
--*************************************************************************************--

NUM_DROP = 93
NUM_DROP_1 = 31
NUM_DROP_2 = 18
NUM_DROP_3 = 24
NUM_DROP_4 = 28
NUM_DROP_5 = 32
NUM_DROP_6 = 29
NUM_DROP_7 = 24

precip_acf_ratio = 0

--*************************************************************************************--
--** 					            GLOBAL VARIABLES                				 **--
--*************************************************************************************--

--*************************************************************************************--
--** 					            LOCAL VARIABLES                 				 **--
--*************************************************************************************--
--*************************************************************************************--
--** 				             FIND X-PLANE DATAREFS            			    	 **--
--*************************************************************************************--

--simDR_rain_ratio		= find_dataref("sim/weather/rain_percent")
simDR_rain_acf_ratio	= find_dataref("sim/weather/precipitation_on_aircraft_ratio")
simDR_ground_speed		= find_dataref("sim/flightmodel/position/groundspeed")

XE_DR_rain				= find_dataref("env/rain")
XE_DR_snow				= find_dataref("env/snow")

simDR_theta 		= find_dataref("sim/flightmodel/position/theta")
simDR_phi			= find_dataref("sim/flightmodel/position/phi")

--*************************************************************************************--
--** 				               FIND X-PLANE COMMANDS                   	    	 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				              FIND CUSTOM DATAREFS             			    	 **--
--*************************************************************************************--

B738DR_left_wiper_ratio		= find_dataref("laminar/B738/others/left_wiper_ratio")
B738DR_right_wiper_ratio	= find_dataref("laminar/B738/others/right_wiper_ratio")

l_side_temp 	= find_dataref("laminar/B738/ice/l_side_temp")
l_fwd_temp 		= find_dataref("laminar/B738/ice/l_fwd_temp")
r_side_temp 	= find_dataref("laminar/B738/ice/r_side_temp")
r_fwd_temp 		= find_dataref("laminar/B738/ice/r_fwd_temp")

B738DR_left_wiper_up		= find_dataref("laminar/B738/others/left_wiper_up")
B738DR_right_wiper_up		= find_dataref("laminar/B738/others/right_wiper_up")

--*************************************************************************************--
--** 				        CREATE READ-ONLY CUSTOM DATAREFS               	         **--
--*************************************************************************************--
--B738DR_data_test			= create_dataref("laminar/B738/data_test", "number")

B738DR_horizon	= create_dataref("laminar/B738/hud/horizon", "number")

--*************************************************************************************--
--** 				       READ-WRITE CUSTOM DATAREF HANDLERS     	        	     **--
--*************************************************************************************--

function B738DR_align_horizon_DRhandler() end
function B738DR_align_horizon2_DRhandler() end
function B738DR_align_horizon3_DRhandler() end

--*************************************************************************************--
--** 				       CREATE READ-WRITE CUSTOM DATAREFS                         **--
--*************************************************************************************--

B738DR_align_horizon	= create_dataref("laminar/B738/hud/align_horizon", "number", B738DR_align_horizon_DRhandler)
B738DR_align_horizon2	= create_dataref("laminar/B738/hud/align_horizon2", "number", B738DR_align_horizon2_DRhandler)
B738DR_align_horizon3	= create_dataref("laminar/B738/hud/align_horizon3", "number", B738DR_align_horizon3_DRhandler)


--*************************************************************************************--
--** 				             CUSTOM COMMAND HANDLERS            			     **--
--*************************************************************************************--

function B738DR_kill_effect_DRhandler() end

function B738DR_hide_glass_DRhandler() end

function B738DR_hide_windows_xt_DRhandler() end


--*************************************************************************************--
--** 				              CREATE CUSTOM COMMANDS              			     **--
--*************************************************************************************--


--simDR_rain_acf_ratio	= create_dataref("laminar/B738/effect/rain", "number", B738DR_rain_DRhandler)
--simDR_rain_acf_ratio2	= create_dataref("laminar/B738/effect/rain2", "number", B738DR_rain2_DRhandler)

B738DR_kill_effect	= create_dataref("laminar/B738/perf/kill_effect", "number", B738DR_kill_effect_DRhandler)

B738DR_hide_glass = create_dataref("laminar/B738/effect/hide_glass", "number", B738DR_hide_glass_DRhandler)

B738DR_hide_windows_xt = create_dataref("laminar/B738/effect/hide_windows_xt", "number", B738DR_hide_windows_xt_DRhandler)
--simDR_rain_acf_ratio = create_dataref("laminar/B738/effect/hide_windows_xt", "number", B738DR_hide_windows_xt_DRhandler)

B738DR_window_effect_L = create_dataref("laminar/B738/effect/windowL", "number")
B738DR_window_effect_LS = create_dataref("laminar/B738/effect/windowLS", "number")
B738DR_window_effect_R = create_dataref("laminar/B738/effect/windowR", "number")
B738DR_window_effect_RS = create_dataref("laminar/B738/effect/windowRS", "number")

B738DR_window_effect_L02 = create_dataref("laminar/B738/effect/windowL02", "number")
B738DR_window_effect_LS02 = create_dataref("laminar/B738/effect/windowLS02", "number")
B738DR_window_effect_R02 = create_dataref("laminar/B738/effect/windowR02", "number")
B738DR_window_effect_RS02 = create_dataref("laminar/B738/effect/windowRS02", "number")

B738DR_window_effect_L03 = create_dataref("laminar/B738/effect/windowL03", "number")
B738DR_window_effect_LS03 = create_dataref("laminar/B738/effect/windowLS03", "number")
B738DR_window_effect_R03 = create_dataref("laminar/B738/effect/windowR03", "number")
B738DR_window_effect_RS03 = create_dataref("laminar/B738/effect/windowRS03", "number")

B738DR_window_effect_L04 = create_dataref("laminar/B738/effect/windowL04", "number")
B738DR_window_effect_LS04 = create_dataref("laminar/B738/effect/windowLS04", "number")
B738DR_window_effect_R04 = create_dataref("laminar/B738/effect/windowR04", "number")
B738DR_window_effect_RS04 = create_dataref("laminar/B738/effect/windowRS04", "number")

B738DR_window_effect_L05 = create_dataref("laminar/B738/effect/windowL05", "number")
B738DR_window_effect_LS05 = create_dataref("laminar/B738/effect/windowLS05", "number")
B738DR_window_effect_R05 = create_dataref("laminar/B738/effect/windowR05", "number")
B738DR_window_effect_RS05 = create_dataref("laminar/B738/effect/windowRS05", "number")

B738DR_window_effect_animL = create_dataref("laminar/B738/effect/window_animL", "array[7]")
B738DR_window_effect_animR = create_dataref("laminar/B738/effect/window_animR", "array[7]")
B738DR_window_effect_animL02 = create_dataref("laminar/B738/effect/window_animL02", "array[7]")
B738DR_window_effect_animR02 = create_dataref("laminar/B738/effect/window_animR02", "array[7]")

--*************************************************************************************--
--** 				             X-PLANE COMMAND HANDLERS               	    	 **--
--*************************************************************************************--



--*************************************************************************************--
--** 				             REPLACE X-PLANE COMMANDS                  	    	 **--
--*************************************************************************************--



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

wiper_up_table = { [0] = 10, [1] = 20, [2] = 30, [3] = 40, [4] = 50, [5] = 57, [6] = 66, [7] = 75 }
wiper_dn_table = { [0] =  5, [1] = 10, [2] = 20, [3] = 30, [4] = 40, [5] = 50, [6] = 55, [7] = 64 }


i = 0

rain_ratio = 0
rain_acf = 0
timer_rain = 0

left_out_window_ratio = 0
right_out_window_ratio = 0
left_side_window_ratio = 0
right_side_window_ratio = 0

left_out_window_ratio_t = 0
right_out_window_ratio_t = 0
left_side_window_ratio_t = 0
right_side_window_ratio_t = 0

was_left_frost = 0
was_right_frost = 0
was_left_side_frost = 0
was_right_side_frost = 0

animL_ratio_tgt = {}
animR_ratio_tgt = {}
animL_ratio = {}
animR_ratio = {}
animL_transp_ratio = {}
animR_transp_ratio = {}
animL_ratio_tgt_w = {}
animR_ratio_tgt_w = {}

for i = 0, 6 do
	animL_ratio_tgt[i] = 0
	animR_ratio_tgt[i] = 0
	animL_ratio[i] = 0
	animR_ratio[i] = 0
	animL_transp_ratio[i] = 0
	animR_transp_ratio[i] = 0
	animL_ratio_tgt_w[i] = 0
	animR_ratio_tgt_w[i] = 0
end




function B738_rescale(in1, out1, in2, out2, x)
    if x < in1 then return out1 end
    if x > in2 then return out2 end
    return out1 + (out2 - out1) * (x - in1) / (in2 - in1)
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


function rain_triger()
	
	
	local gnd_spd = simDR_ground_speed
	gnd_spd = math.min(gnd_spd, 236)
	gnd_spd = math.max(gnd_spd, 5)
	
	local rain_spd_ratio = B738_rescale(5, 1, 236, 2, gnd_spd)
	
	rain_acf = precip_acf_ratio * rain_spd_ratio
	rain_acf = math.min(rain_acf, 0.5)
	rain_acf = math.max(rain_acf, 0)
	
	local tmp = rain_acf
	if tmp < 0.2 then
		rain_ratio = 2 - B738_rescale(0, 0.8, 0.2, 1.6, tmp)
	else
		rain_ratio = 2 - B738_rescale(0.2, 1.6, 0.5, 1.99, tmp)
	end
	
	timer_rain = timer_rain + SIM_PERIOD

end


function window_ratio()
	
	local ratio_tgt = 0
	local ratio_time = 0
	local k = 0
	local tmp2 = 0
	
	local gnd_spd = simDR_ground_speed
	gnd_spd = math.min(gnd_spd, 236)
	gnd_spd = math.max(gnd_spd, 5)
	
	local tmp = precip_acf_ratio * B738_rescale(5, 1, 236, 4.5, gnd_spd)	-- 2.5
	tmp = math.min(tmp, 1)
	tmp = math.max(tmp, 0)
	
	local ratio_time_rain2 = 0
	if tmp < 0.1 then
		ratio_time_rain2 = B738_rescale(0, 0.11, 0.1, 0.37, tmp)	-- window transp
	elseif tmp < 0.4 then
		ratio_time_rain2 = B738_rescale(0.1, 0.37, 0.4, 0.72, tmp)	-- window transp
	else
		ratio_time_rain2 = B738_rescale(0.4, 0.72, 1, 0.87, tmp)	-- window transp
	end
	
	local ratio_time_rain3 = 0
	if tmp < 0.1 then
		ratio_time_rain3 = 40 - B738_rescale(0, 0, 0.1, 21.5, tmp)	-- window spd
	elseif tmp < 0.4 then
		ratio_time_rain3 = 40 - B738_rescale(0.1, 21.5, 0.4, 36.8, tmp)	-- window spd
	else
		ratio_time_rain3 = 40 - B738_rescale(0.4, 36.8, 1, 38.7, tmp)	-- window spd
	end
	
	
	--local ratio_time_rain = B738_rescale(0, 0, 1, 0.77, precip_acf_ratio)
	ratio_time_rain = 0
	tmp = precip_acf_ratio
	if tmp < 0.1 then
		ratio_time_rain = B738_rescale(0, 0.11, 0.1, 0.37, tmp)	-- window transp
	elseif tmp < 0.4 then
		ratio_time_rain = B738_rescale(0.1, 0.37, 0.4, 0.72, tmp)	-- window transp
	else
		ratio_time_rain = B738_rescale(0.4, 0.72, 1, 0.87, tmp)	-- window transp
	end
	
	if rain_acf > 0 then
		ratio_time_rain3 = ratio_time_rain3 / 2
		ratio_time_rain2 = ratio_time_rain2 / 2
		ratio_time_rain = ratio_time_rain / 2
	end
	
	-----
	-- LEFT OUT --
	ratio_time = ratio_time_rain3
	if rain_acf > 0 then
		ratio_tgt = ratio_time_rain2
	else
		ratio_tgt = 0
	end
	if ratio_tgt < left_out_window_ratio then
		ratio_time = ratio_time * 2.3
	end
	if l_fwd_temp < 0.2 then
		was_left_frost = 1
		if ratio_tgt < left_out_window_ratio_t then
			ratio_time = 240
		end
		ratio_tgt = 0.977
	end
	--if was_left_frost == 0 then
	if rain_acf > 0 or was_left_frost == 0 then
		left_out_window_ratio = B738_set_animation_rate(left_out_window_ratio, ratio_tgt, 0, 0.977, ratio_time)
	end
	if left_out_window_ratio == ratio_tgt or was_left_frost == 1 then
		left_out_window_ratio_t = B738_set_animation_rate(left_out_window_ratio_t, ratio_tgt, 0, 0.977, ratio_time)
	end
	B738DR_window_effect_L = left_out_window_ratio_t
	tmp = math.min(left_out_window_ratio, 0.3)
	tmp = math.max(tmp, 0)
	if ratio_tgt < left_out_window_ratio then
		tmp2 = B738_rescale(0, 0, 0.21, 1, tmp)
		if tmp2 > left_out_window_ratio then
			B738DR_window_effect_L02 = left_out_window_ratio
		else
			B738DR_window_effect_L02 = tmp2
		end
	else
		B738DR_window_effect_L02 = B738_rescale(0, 0, 0.3, 1, tmp)
	end
	
	
	-----
	-- LEFT SIDE --
	ratio_time = 40
	if rain_acf > 0 then
		ratio_tgt = ratio_time_rain
	else
		ratio_tgt = 0
	end
	if ratio_tgt < left_side_window_ratio then
		ratio_time = ratio_time * 2
	end
	if l_side_temp < 0.2 then
		was_left_side_frost = 1
		if ratio_tgt < left_side_window_ratio_t then
			ratio_time = 240
		end
		ratio_tgt = 0.977
	else
		if ratio_time_rain >= left_side_window_ratio_t then
			was_left_side_frost = 0
		end
	end
	--if was_left_side_frost == 0 then
	if rain_acf > 0 or was_left_side_frost == 0 then
		left_side_window_ratio = B738_set_animation_rate(left_side_window_ratio, ratio_tgt, 0, 0.977, ratio_time)
	end
	if left_side_window_ratio == ratio_tgt or was_left_side_frost == 1 then
		left_side_window_ratio_t = B738_set_animation_rate(left_side_window_ratio_t, ratio_tgt, 0, 0.977, ratio_time)
	end
	
	
	B738DR_window_effect_LS02 = left_side_window_ratio_t
	tmp = math.min(left_side_window_ratio, 0.3)
	tmp = math.max(tmp, 0)
	if ratio_tgt < left_side_window_ratio then
		tmp2 = B738_rescale(0, 0, 0.21, 1, tmp)
		if tmp2 > left_side_window_ratio then
			B738DR_window_effect_LS = left_side_window_ratio
		else
			B738DR_window_effect_LS = tmp2
		end
	else
		B738DR_window_effect_LS = B738_rescale(0, 0, 0.3, 1, tmp)
	end
	-----
	-- RIGHT OUT --
	ratio_time = ratio_time_rain3
	if rain_acf > 0 then
		ratio_tgt = ratio_time_rain2
	else
		ratio_tgt = 0
	end
	if ratio_tgt < right_out_window_ratio then
		ratio_time = ratio_time * 2.3
	end
	if r_fwd_temp < 0.2 then
		was_right_frost = 1
		if ratio_tgt < right_out_window_ratio_t then
			ratio_time = 240
		end
		ratio_tgt = 0.977
	end
	--if was_right_frost == 0 then
	if rain_acf > 0 or was_right_frost == 0 then
		right_out_window_ratio = B738_set_animation_rate(right_out_window_ratio, ratio_tgt, 0, 0.977, ratio_time)
	end
	if left_out_window_ratio == ratio_tgt or was_right_frost == 1 then
		right_out_window_ratio_t = B738_set_animation_rate(right_out_window_ratio_t, ratio_tgt, 0, 0.977, ratio_time)
	end
	B738DR_window_effect_R = right_out_window_ratio_t
	tmp = math.min(right_out_window_ratio, 0.3)
	tmp = math.max(tmp, 0)
	if ratio_tgt < right_out_window_ratio then
		tmp2 = B738_rescale(0, 0, 0.21, 1, tmp)
		if tmp2 > right_out_window_ratio then
			B738DR_window_effect_R02 = right_out_window_ratio
		else
			B738DR_window_effect_R02 = tmp2
		end
	else
		B738DR_window_effect_R02 = B738_rescale(0, 0, 0.3, 1, tmp)
	end
	
	-----
	-- RIGHT SIDE --
	ratio_time = 40
	if rain_acf > 0 then
		ratio_tgt = ratio_time_rain
	else
		ratio_tgt = 0
	end
	if ratio_tgt < right_side_window_ratio then
		ratio_time = ratio_time * 2
	end
	if r_side_temp < 0.2 then
		was_right_side_frost = 1
		if ratio_tgt < right_side_window_ratio_t then
			ratio_time = 240
		end
		ratio_tgt = 0.977
	else
		if ratio_time_rain >= right_side_window_ratio_t then
			was_right_side_frost = 0
		end
	end
	--if was_right_side_frost == 0 then
	if rain_acf > 0 or was_right_side_frost == 0 then
		right_side_window_ratio = B738_set_animation_rate(right_side_window_ratio, ratio_tgt, 0, 0.977, ratio_time)
	end
	if right_side_window_ratio == ratio_tgt or was_right_side_frost == 1 then
		right_side_window_ratio_t = B738_set_animation_rate(right_side_window_ratio_t, ratio_tgt, 0, 0.977, ratio_time)
	end
	
	
	B738DR_window_effect_RS02 = right_side_window_ratio_t
	tmp = math.min(right_side_window_ratio, 0.3)
	tmp = math.max(tmp, 0)
	if ratio_tgt < right_side_window_ratio then
		tmp2 = B738_rescale(0, 0, 0.21, 1, tmp)
		if tmp2 > right_side_window_ratio then
			B738DR_window_effect_RS = right_side_window_ratio
		else
			B738DR_window_effect_RS = tmp2
		end
	else
		B738DR_window_effect_RS = B738_rescale(0, 0, 0.3, 1, tmp)
	end
	
	-----
	-- LEFT IN --
	--
	for k = 0, 6 do
		ratio_time = ratio_time_rain3
		if rain_acf > 0 then
			-- if B738DR_left_wiper_ratio > wiper_up_table[k] and B738DR_left_wiper_ratio < wiper_up_table[k+1] and B738DR_left_wiper_up == 1 then
				-- animL_ratio_tgt[k] = 0
			-- elseif B738DR_left_wiper_ratio < wiper_dn_table[k] and B738DR_left_wiper_ratio > wiper_up_table[k+1] and B738DR_left_wiper_up == 0 then
				-- animL_ratio_tgt[k] = 0
			if B738DR_left_wiper_ratio > wiper_up_table[k] and B738DR_left_wiper_up == 1 then
				animL_ratio_tgt[k] = 0
				animL_ratio_tgt_w[k] = 1
			elseif B738DR_left_wiper_ratio < wiper_dn_table[k] and B738DR_left_wiper_up == 0 then
				animL_ratio_tgt[k] = 0
				animL_ratio_tgt_w[k] = 1
			else
				animL_ratio_tgt[k] = ratio_time_rain2
			end
		else
			animL_ratio_tgt[k] = 0
		end
		if animL_ratio_tgt[k] < animL_ratio[k] then
			ratio_time = ratio_time * 2.3
		end
		if l_fwd_temp < 0.2 then
			was_left_frost = 1
			if animL_ratio_tgt[k] < animL_transp_ratio[k] then
				ratio_time = 240
				animL_ratio_tgt_w[k] = 0
			end
			animL_ratio_tgt[k] = 0.977
		else
			if ratio_time_rain2 >= animL_transp_ratio[k] then
				was_left_frost = 0
			end
		end
		
		-- if rain_acf > 0 and animL_ratio_tgt[k] == 0 and was_left_frost == 0 then
			-- --animL_ratio[k] = B738_set_animation_rate(animL_ratio[k], animL_ratio_tgt[k], 0, 0.97, 0.1)
			-- animL_ratio[k] = 0
		if rain_acf > 0 and animL_ratio_tgt_w[k] == 1 and was_left_frost == 0 then
			animL_ratio[k] = B738_set_animation_rate(animL_ratio[k], 0, 0, 0.977, 0.1)
			animL_transp_ratio[k] = B738_set_animation_rate(animL_transp_ratio[k], 0, 0, 0.977, 0.1)
		else
			--if was_left_frost == 0 then
			if rain_acf > 0 or was_left_frost == 0 then
				animL_ratio[k] = B738_set_animation_rate(animL_ratio[k], animL_ratio_tgt[k], 0, 0.977, ratio_time)
			end
			if animL_ratio[k] == animL_ratio_tgt[k] or was_left_frost == 1 then
				animL_transp_ratio[k] = B738_set_animation_rate(animL_transp_ratio[k], animL_ratio_tgt[k], 0, 0.977, ratio_time)
			end
		end
		if animL_ratio[k] == 0 then
			animL_ratio_tgt_w[k] = 0
		end
		
		B738DR_window_effect_animL[k] = animL_transp_ratio[k]
		tmp = math.min(animL_ratio[k], 0.3)
		tmp = math.max(tmp, 0)
		if animL_ratio_tgt[k] < animL_ratio[k] then
			tmp2 = B738_rescale(0, 0, 0.21, 1, tmp)
			if tmp2 > animL_ratio[k] then
				B738DR_window_effect_animL02[k] = animL_ratio[k]
			else
				B738DR_window_effect_animL02[k] = tmp2
			end
		else
			B738DR_window_effect_animL02[k] = B738_rescale(0, 0, 0.3, 1, tmp)
		end
		
	end
	
	-----
	-- RIGHT IN --
	
	--
	for k = 0, 6 do
		ratio_time = ratio_time_rain3
		if rain_acf > 0 then
			-- if B738DR_right_wiper_ratio > wiper_up_table[k] and B738DR_right_wiper_ratio < wiper_up_table[k+1] and B738DR_right_wiper_up == 1 then
				-- animR_ratio_tgt[k] = 0
			-- elseif B738DR_right_wiper_ratio < wiper_dn_table[k] and B738DR_right_wiper_ratio > wiper_up_table[k+1] and B738DR_right_wiper_up == 0 then
				-- animR_ratio_tgt[k] = 0
			if B738DR_right_wiper_ratio > wiper_up_table[k] and B738DR_right_wiper_up == 1 then
				animR_ratio_tgt[k] = 0
				animR_ratio_tgt_w[k] = 1
			elseif B738DR_right_wiper_ratio < wiper_dn_table[k] and B738DR_right_wiper_up == 0 then
				animR_ratio_tgt[k] = 0
				animR_ratio_tgt_w[k] = 1
			else
				animR_ratio_tgt[k] = ratio_time_rain2
			end
		else
			animR_ratio_tgt[k] = 0
		end
		if animR_ratio_tgt[k] < animR_ratio[k] then
			ratio_time = ratio_time * 2.3
		end
		if r_fwd_temp < 0.2 then
			was_right_frost = 1
			if animR_ratio_tgt[k] < animR_transp_ratio[k] then
				ratio_time = 240
				animR_ratio_tgt_w[k] = 0
			end
			animR_ratio_tgt[k] = 0.977
		else
			if ratio_time_rain2 >= animR_transp_ratio[k] then
				was_right_frost = 0
			end
		end
		
		-- if rain_acf > 0 and animR_ratio_tgt[k] == 0 and was_right_frost == 0 then
			-- --animR_ratio[k] = B738_set_animation_rate(animR_ratio[k], animR_ratio_tgt[k], 0, 0.97, 0.1)
			-- animR_ratio[k] = 0
		if rain_acf > 0 and animR_ratio_tgt_w[k] == 1 and was_right_frost == 0 then
			animR_ratio[k] = B738_set_animation_rate(animR_ratio[k], 0, 0, 0.977, 0.1)
			animR_transp_ratio[k] = B738_set_animation_rate(animR_transp_ratio[k], 0, 0, 0.977, 0.1)
		else
			--if was_right_frost == 0 then
			if rain_acf > 0 or was_right_frost == 0 then
				animR_ratio[k] = B738_set_animation_rate(animR_ratio[k], animR_ratio_tgt[k], 0, 0.977, ratio_time)
			end
			if animR_ratio[k] == animR_ratio_tgt[k] or was_right_frost == 1 then
				animR_transp_ratio[k] = B738_set_animation_rate(animR_transp_ratio[k], animR_ratio_tgt[k], 0, 0.977, ratio_time)
			end
		end
		if animR_ratio[k] == 0 then
			animR_ratio_tgt_w[k] = 0
		end
		
		B738DR_window_effect_animR[k] = animR_transp_ratio[k]
		tmp = math.min(animR_ratio[k], 0.3)
		tmp = math.max(tmp, 0)
		if animR_ratio_tgt[k] < animR_ratio[k] then
			tmp2 = B738_rescale(0, 0, 0.21, 1, tmp)
			if tmp2 > animR_ratio[k] then
				B738DR_window_effect_animR02[k] = animR_ratio[k]
			else
				B738DR_window_effect_animR02[k] = tmp2
			end
		else
			B738DR_window_effect_animR02[k] = B738_rescale(0, 0, 0.3, 1, tmp)
		end
	end
	
	
end



--function aircraft_load() end

--function aircraft_unload() end

function flight_start()

	--B738DR_kill_effect = 1
	
	left_out_window_ratio = 0
	right_out_window_ratio = 0
	left_side_window_ratio = 0
	right_side_window_ratio = 0
	left_out_window_ratio_t = 0
	right_out_window_ratio_t = 0
	left_side_window_ratio_t = 0
	right_side_window_ratio_t = 0
	was_left_frost = 0
	was_right_frost = 0
	was_left_side_frost = 0
	was_right_side_frost = 0
	
	for h = 0, 7 do
		B738DR_window_effect_animL[h] = 0
		B738DR_window_effect_animR[h] = 0
		B738DR_window_effect_animL02[h] = 0
		B738DR_window_effect_animR02[h] = 0
		animL_ratio_tgt_w[h] = 0
		animR_ratio_tgt_w[h] = 0
		animL_transp_ratio[h] = 0
		animR_transp_ratio[h] = 0
		animL_ratio[h] = 0
		animR_ratio[h] = 0
	end
	
	B738DR_align_horizon = 26		-- basic multiplier up/down
	B738DR_align_horizon2 = -30		-- move up/down by head position
	B738DR_align_horizon3 = 2		-- multiplier by angle
	
end


--function flight_crash() end

--function before_physics() end

function after_physics()

	local h = 0
	
	B738DR_horizon = (simDR_theta * B738DR_align_horizon) + B738DR_align_horizon2 + (simDR_phi * B738DR_align_horizon3)
	if B738DR_kill_effect < 2 then
		if B738DR_kill_effect == 0 then
			precip_acf_ratio = simDR_rain_acf_ratio
		else
			precip_acf_ratio = math.max(XE_DR_rain, XE_DR_snow)
		end
		--B738DR_hide_glass = 1
		rain_triger()
		window_ratio()
		if timer_rain > rain_ratio then
			timer_rain = 0
		end
	else
		--B738DR_hide_glass = 0
		left_out_window_ratio = 0
		right_out_window_ratio = 0
		left_side_window_ratio = 0
		right_side_window_ratio = 0
		left_out_window_ratio_t = 0
		right_out_window_ratio_t = 0
		left_side_window_ratio_t = 0
		right_side_window_ratio_t = 0
		was_left_frost = 0
		was_right_frost = 0
		was_left_side_frost = 0
		was_right_side_frost = 0
		timer_rain = 0
		for h = 0, 7 do
			B738DR_window_effect_animL[h] = 0
			B738DR_window_effect_animR[h] = 0
			B738DR_window_effect_animL02[h] = 0
			B738DR_window_effect_animR02[h] = 0
			animL_ratio_tgt_w[h] = 0
			animR_ratio_tgt_w[h] = 0
			animL_transp_ratio[h] = 0
			animR_transp_ratio[h] = 0
			animL_ratio[h] = 0
			animR_ratio[h] = 0
		end
	end

end


--function after_replay() end




--*************************************************************************************--
--** 				               SUB-MODULE PROCESSING       	        			 **--
--*************************************************************************************--

-- dofile("")



