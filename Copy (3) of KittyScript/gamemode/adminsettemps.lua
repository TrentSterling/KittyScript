----------------------------
-- KittyScript January 15, 2008)
-- by John [MT]OMalley Dorian
--
-- First beta - March 25, 2008
-- 
--This is where we give admins the ability to allow flags to players. Made external from 'adminpowers.lua' so we can stay organized.
----------------------------

/*---------------------------------------------------------
  Force the player into a class - aka the temp system
---------------------------------------------------------*/
function ForceSetScanner(ply, cmd, args)

	if( tonumber(ply:GetNWInt( "adminlevel" )) < 2 ) then
		ply:SendMessage("You need admin rights for this!",3,Color(255,0,0,255))
	return end
	if args[1] then
	local target = GetPlayerByName(args[1])
	if(target != nil) then
		target:SendMessage("You have been forced into City Scanner!",7,Color(0,255,0,255))
		target:Kill();
		target:SetNWInt("setflag", 2)
	end
	if(target == nil) then
		ply:PrintMessage( 2, "Failed" );
	end	
	end
end
concommand.Add("rp_forcescanner", ForceSetScanner)

function ForceSetCitizen(ply, cmd, args)
	if( tonumber(ply:GetNWInt( "adminlevel" )) < 2 ) then
		ply:SendMessage("You need admin rights for this!",3,Color(255,0,0,255))
	return end
	if args[1] then
	local target = GetPlayerByName(args[1])
	if(target != nil) then
		target:SendMessage("You have been forced into being a citizen!",7,Color(0,255,0,255))
		target:Kill();
		target:SetNWInt("setflag", 1)
	end
	if(target == nil) then
		ply:PrintMessage( 2, "Failed" );
	end
	end
end
concommand.Add("rp_forcecitizen", ForceSetCitizen)
