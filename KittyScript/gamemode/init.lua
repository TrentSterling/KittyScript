----------------------------
-- KittyScript January 15, 2008)
-- by John [MT]OMalley Dorian
--
-- First beta - March 25, 2008
-- 
--Initialize EVERYTHING
----------------------------
--NEVER EVER FOR HL2LAND.NET SERVERS. DO NOT LET GREYFOX OR RICK D. GET A COPY OF THIS. RAGGLEFRAGGLE--
/*---------------------------------------------------------

 <<<<<Get the party started>>>>>
-------------Ready for some hacky shit?
---------------------------------------------------------*/

DeriveGamemode( "sandbox" );
//ClientSideShit
AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "cl_hud.lua" );
AddCSLuaFile( "vgui/cl_helpvgui.lua" );
AddCSLuaFile("cl_scoreboard.lua");
AddCSLuaFile("animations.lua");
AddCSLuaFile("shared.lua");
AddCSLuaFile("vgui/cl_charcreatevgui.lua");


//Includes
include( 'animations.lua' )--Give us magical powers!
include( 'player_hooks.lua' )--Give us magical powers!
include( 'combine_sounds.lua' )--Set up our regular powers!!!
include( 'chat.lua' )--Set up our regular powers!!!
include( 'shared.lua' )--Set up our variables!!!
include( 'adminpowers.lua' )--Set up our variables!!!

GM.Name = "KittyScript";

local PlayerMeta = FindMetaTable("Player")

function GM:Initialize()
	self.BaseClass:Initialize();
end

function GM:ShowHelp(ply)
	umsg.Start("togglehelp",ply) -- pop up box
	umsg.End()
end

function GM:CanPlayerSuicide(ply)
	ply:ChatPrint("No suiciding.")
	return false
end

/*---------------------------------------------------------
 <<<<<Utility functions>>>>>
---------------------------------------------------------*/
/*---------------------------------------------------------
  Eye Tracing
---------------------------------------------------------*/
function PlayerMeta:TraceFromEyes(dist)
         local trace = {}
         trace.start = self:GetShootPos()
         trace.endpos = trace.start + (self:GetAimVector() * dist)
         trace.filter = self
         return util.TraceLine(trace)
end
/*---------------------------------------------------------
  END Eye Tracing
---------------------------------------------------------*/

/*---------------------------------------------------------
  Custom player messages
---------------------------------------------------------*/
function PlayerMeta:SendMessage(text,duration,color)
         local duration = duration or 3
         local color = color or Color(255,255,255,255)
         umsg.Start("ls_sendmessage",self)
         umsg.String(text)
         umsg.Short(duration)
         umsg.String(color.r..","..color.g..","..color.b..","..color.a)
         umsg.End()
end

function gDoorSkin(ply, cmd, args)

		local trace = util.GetPlayerTrace( ply, ply:GetCursorAimVector( ) )
		local tr = util.TraceLine( trace )
				if( ply:GetPos():Distance( tr.Entity:GetPos() ) < 100 ) then
		if tr.Entity then
			ply:SendMessage("Skin is set to " .. tr.Entity:GetSkin() .. ".",7,Color(0,255,0,255));
		end
		end
end
concommand.Add("rp_gskin", gDoorSkin)

function DoorSkin(ply, cmd, args)
	if args[1] then
		local trace = util.GetPlayerTrace( ply, ply:GetCursorAimVector( ) )
		local tr = util.TraceLine( trace )
		if( tr.Entity:GetClass() == "prop_door_rotating" ) then 
		
			if( ply:GetPos():Distance( tr.Entity:GetPos() ) < 100 ) then
				if tr.HitNonWorld then
					tr.Entity:SetSkin(tonumber(args[1]))
					ply:SendMessage("Skin set to " .. tonumber(args[1]) .. ".",7,Color(0,255,0,255));
				else
					ply:SendMessage("You must be aimed at a door!",7,Color(0,255,0,255));
				end
			end
		end
	else
		ply:SendMessage("You fucked up!",7,Color(0,255,0,255));
	end
end
concommand.Add("rp_dskin", DoorSkin)

function OpenDoor(ply, cmd, args)
		ply:SendMessage("You are a citizen.",7,Color(0,255,0,255));
		local ent = ply:GetEyeTrace().Entity
			local doorstate = ent:GetNWInt("doorstate") 
			if(doorstate == 7 ) then
				ent:Fire("toggle", 1)
			end
end
concommand.Add("rp_opendoor", OpenDoor)

	

function SoundList2( ply, cmd, args )
	ply:PrintMessage( 2, "COMBINE SOUND LIST - USE playline <id> OR rp_playline <id>" );
	ply:PrintMessage( 2, "ID   |   LINE" );
	for k, v in pairs( CombineSounds ) do
		ply:PrintMessage( 2, k .. "  |  " .. v.line );
	end
end
concommand.Add( "rp_soundlist2", SoundList2 );




function DropCash2( ply, cmd, args )
	local n = tonumber( args[1] );
	if( n == nil ) then
		ply:PrintMessage( 2, "Invalid." );
		return;
	end
	if( n > 0 ) then
		if( n < ply:GetNWInt( "money" )+1 ) then
			ply:SetNWInt("money", ply:GetNWInt( "money" ) - n)	
			ply:SendMessage("You dropped " .. args[1] .. " credits.",7,Color(0,255,0,255));
			SaveInfo(ply);
		end
	end
end
concommand.Add( "rp_dropcredits2", DropCash2 );













function PlaySound2( ply, cmd, args )
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
concommand.Add( "rp_playline2", PlaySound2 );
concommand.Add( "playline2", PlaySound2 );









function GiveCredits2(ply, cmd, args)
	if args[1] then
		
		if args[2] then
		
		--if( args[2]:GetClass() == "player" ) then 
	local target = GetPlayerByName(args[2])
		
			local n = tonumber( args[1] );
	if( n == nil ) then
		ply:PrintMessage( 2, "Invalid." );
		return;
	end
	
	
	
	
	
	
			if( ply:GetPos():Distance( target:GetPos() ) < 150 ) then
	
	
	
	if( n > 0 ) then
		if( n < ply:GetNWInt( "money" )+1 ) then
			ply:SetNWInt("money", ply:GetNWInt( "money" ) - n)	
			target:SetNWInt("money", target:GetNWInt( "money" ) + n)	
			SaveInfo(ply)
			SaveInfo(target)
			ply:SendMessage("**You gave " .. args[1] .. " credits to " .. target:GetNWString( "RPName" ) .. ".**",7,Color(0,255,0,255));
			ply:PrintMessage( 2, "**You gave " .. args[1] .. " credits to " .. target:GetNWString( "RPName" ) .. ".**" );
			target:SendMessage("**You received " .. args[1] .. " credits from " .. ply:GetNWString( "RPName" ) .. ".**",7,Color(0,255,0,255));
			target:PrintMessage( 2, "**You received " .. args[1] .. " credits from " .. ply:GetNWString( "RPName" ) .. ".**" );
		end
	end
	
	
	
	
	
	
	
	end
	
	
	
			if( ply:GetPos():Distance( target:GetPos() ) >= 150 ) then
	
			ply:SendMessage("**Not close enough!**",7,Color(255,255,0,255));
			ply:PrintMessage( 2, "**Not close enough!**" );
	
	
	end
	
	
	
	
		
		end
	
	end
end
concommand.Add("rp_givecredits2", GiveCredits2)






