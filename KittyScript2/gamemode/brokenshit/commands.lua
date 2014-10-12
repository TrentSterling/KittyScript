----------------------------
-- KittyScript January 15, 2008)
-- by John [MT]OMalley Dorian
--
-- First beta - March 25, 2008
-- 
--Setting up some custom commands both clientside and serverside.
----------------------------
include( 'combine_sounds.lua' )--Set up our regular powers!!!

function SoundList( ply, cmd, args )
	ply:PrintMessage( 2, "COMBINE SOUND LIST - USE playline <id> OR rp_playline <id>" );
	ply:PrintMessage( 2, "ID   |   LINE" );
	for k, v in pairs( CombineSounds ) do
		ply:PrintMessage( 2, k .. "  |  " .. v.line );
	end
end
concommand.Add( "rp_soundlist", SoundList );

function PlaySound( ply, cmd, args )
	local n = tonumber( args[1] );
	if( n == nil ) then
		ply:PrintMessage( 2, "Invalid. Use sound ID" );
		return;
	end
	if( not CombineSounds[n] ) then
		ply:PrintMessage( 2, "Sound doesn't exist" );
		return;
	end
	util.PrecacheSound( CombineSounds[n].dir );
	ply:EmitSound( CombineSounds[n].dir );
end
concommand.Add( "rp_playline", PlaySound );
concommand.Add( "playline", PlaySound );

function DropCash( ply, cmd, args )
	local n = tonumber( args[1] );
	if( n == nil ) then
		ply:PrintMessage( 2, "Invalid." );
		return;
	end
	if( n > 0 ) then
		if( n < ply:GetNWInt( "money" )+1 ) then
			ply:SetNWInt("money", ply:GetNWInt( "money" ) - n)	
		end
	end
end
concommand.Add( "rp_dropcredits", DropCash );

//Find players by name. --TEMPORARILY HERE
function GetPlayerByName(name)--This lets us type in a player name without being exact, and if the player doesnt exist, return nil.
	if(name != nil) then
		for k, v in pairs(player.GetAll()) do
			if(string.find(v:GetNWString( "RPName" ), name) != nil) then
				return v
			end
		end
	end
	return nil
end




function GiveCredits(ply, cmd, args)
	if args[1] then
		
		if args[2] then
		
		--if( args[2]:GetClass() == "player" ) then 
	local target = GetPlayerByName(args[2])
		
			local n = tonumber( args[1] );
	if( n == nil ) then
		ply:PrintMessage( 2, "Invalid." );
		return;
	end
	if( n > 0 ) then
		if( n < ply:GetNWInt( "money" )+1 ) then
			ply:SetNWInt("money", ply:GetNWInt( "money" ) - n)	
			target:SetNWInt("money", target:GetNWInt( "money" ) + n)	
		end
	end
		
		end
	
	end
end
concommand.Add("rp_givecredits", GiveCredits)

	

	