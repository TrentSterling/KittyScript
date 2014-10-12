----------------------------
-- KittyScript January 15, 2008)
-- by John [MT]OMalley Dorian
--
-- First beta - March 25, 2008
-- 
--LoopingSounds!
----------------------------
function DelaySoundStartLoop(ply,sound,time)--Take the time and the sound, start the sound after some time, restart this function after the time to do it all again.
	if ply:Alive() then 
		PlaySoundDelayed(sound,time)
		timer.Simple(time,ReStartDelaySoundLoop,ply,sound,time)
	end
end

function PlaySoundDelayed(sound,time)--Play the sound
	sound:Play()
end
function StopSoundDelayed(sound)--Play the sound
	sound:Stop()
end

function ReStartDelaySoundLoop(ply,sound,time)--Resets the loop to play again with given parameters
	if(ply:GetNWInt("playeractive") == 1) then--If true, you are active
		if !ply:Alive() then 
			sound:Stop()
		end
		if ply:Alive() then 
			DelaySoundStartLoop(ply,sound,time)	
		end
	end
end
