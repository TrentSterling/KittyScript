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

//Includes
include( 'animations.lua' )--Give us magical powers!
include( 'resources.lua' )--Give us magical powers!
include( 'player_hooks.lua' )--Give us magical powers!
include( 'commands.lua' )--Set up our regular powers!!!
include( 'combine_sounds.lua' )--Set up our regular powers!!!
include( 'chat.lua' )--Set up our regular powers!!!
include( 'config.lua' )--Set up our variables!!!
include( 'shared.lua' )--Set up our variables!!!

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
