----------------------------
-- KittyScript January 15, 2008)
-- by John [MT]OMalley Dorian
--
-- First beta - March 25, 2008
-- 
--Set up flags
----------------------------
--setflag 1 = citizen
--setflag 2 = scanner
--setflag 3 = vort
--setflag 4 = shieldscanner

include( 'loopingsound.lua' )--Looping sounds
include( 'player_hooks.lua' )--Looping sounds

function PlayerFlags(ply)
	if(ply:GetNWInt("setflag") == 1) then--If true, your flag is set to citizen
		ply:SendMessage("You are a citizen.",7,Color(0,255,0,255));
		ply:SetModel( ply:GetNWString( "citizenmodel" ) );
		ply:Give( "weapon_physgun" );
		ply:Give( "weapon_physcannon" );
		ply:Give( "door_keys" );
		ply:SelectWeapon( "door_keys" );
		if( tonumber(ply:GetNWInt( "vip" )) > 0 ) then
		ply:Give( "gmod_tool" );
		end
	end

	if(ply:GetNWInt("setflag") == 2) then--If true, your flag is set to scanner
		ply:SendMessage("You are a City Scanner!",7,Color(0,255,0,255));
		ply:SetModel( "models/Combine_Scanner.mdl" );
		ply:SetMoveType(4);
	end

	if(ply:GetNWInt("setflag") == 3) then--If true, your flag is set to vorty
		ply:SendMessage("You are a Vort!",7,Color(0,255,0,255));
		ply:SetModel( "models/vortigaunt.mdl" );
	end

	if(ply:GetNWInt("setflag") == 4) then--If true, your flag is set to Shieldscanner
		ply:SendMessage("You are a Shield Scanner!",7,Color(0,255,0,255));
		ply:SetModel( "models/Shield_Scanner.mdl" );
		ply:SetMoveType(4);
	end
end
