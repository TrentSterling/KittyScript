
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
			SaveInfo(ply)
		end
	end
end
concommand.Add( "rp_dropcredits", DropCash );




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
