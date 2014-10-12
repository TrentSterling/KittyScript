----------------------------
-- KittyScript January 15, 2008)
-- by John [MT]OMalley Dorian
--
-- First beta - March 25, 2008
-- 
--Initialize EVERYTHING
----------------------------
--NEVER EVER FOR HL2LAND.NET SERVERS. DO NOT LET GREYFOX OR RICK D. GET A COPY OF THIS. RAGGLEFRAGGLE--

DeriveGamemode( "sandbox" );
//ClientSideShit
AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "cl_hud.lua" );
AddCSLuaFile( "vgui/cl_helpvgui.lua" );
AddCSLuaFile("cl_scoreboard.lua");
AddCSLuaFile("animations.lua");
AddCSLuaFile("shared.lua");
AddCSLuaFile("vgui/cl_charcreatevgui.lua");
AddCSLuaFile("headbob.lua");
AddCSLuaFile("cl_think.lua");
AddCSLuaFile("cl_ragspec.lua");
AddCSLuaFile("cl_chat.lua");

//Includes
include( 'animations.lua' )--NPC Animations
include( 'player_hooks.lua' )--Set up character save, load, and most functions
include( 'combine_sounds.lua' )--Sounds....include?
include( 'chat.lua' )--Chat commands
include( 'shared.lua' )--VGUI crap
include( 'adminpowers.lua' )--Give admins powers of greatness
include( 'parseitems.lua' )--Parse the stupid items because they are stupid
include( 'parsedoors.lua' )--Parse the stupid items because they are stupid
include( 'resources.lua' )--Parse the stupid items because they are stupid

GM.Name = "KittyScript";--fucking whore

ParseItems();

	timer.Simple( 2, CreateDoorInfo );

local PlayerMeta = FindMetaTable("Player")

function GM:Initialize()
	self.BaseClass:Initialize();
end

function GM:ShowHelp(ply)
	umsg.Start("togglehelp",ply) -- pop up box
	umsg.End()
end

function GM:CanPlayerSuicide(ply)--THANKS GREY, I MAIDE IT GUUDUR LAWL
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
					
			ply:SetNWInt("money", ply:GetNWInt( "money" ) - 20)	
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


function SoundList2( ply, cmd, args )
	ply:PrintMessage( 2, "COMBINE SOUND LIST - USE playline <id> OR rp_playline <id>" );
	ply:PrintMessage( 2, "ID   |   LINE" );
	for k, v in pairs( CombineSounds ) do
		ply:PrintMessage( 2, k .. "  |  " .. v.line );
	end
end
concommand.Add( "rp_soundlist", SoundList2 );

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
concommand.Add( "rp_dropcredits", DropCash2 );

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
concommand.Add( "rp_playline", PlaySound2 );
concommand.Add( "playline", PlaySound2 );

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
			if( target == nil ) then
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
concommand.Add("rp_givecredits", GiveCredits2)

function GetItemInfo(ply, cmd, args)

		local trace = util.GetPlayerTrace( ply, ply:GetCursorAimVector( ) )
		local tr = util.TraceLine( trace )
		if( ply:GetPos():Distance( tr.Entity:GetPos() ) < 100 ) then
			if tr.Entity then
				ply:SendMessage("Item name is" .. tr.Entity:GetItemName() .. ".",7,Color(0,255,0,255));
			end
		end
end
concommand.Add("rp_getitem", GetItemInfo)







function ToggleBob(ply, cmd, args)

	if ( ply:GetNWInt("togglebob") == 1 ) then
	ply:SetNWInt("togglebob", 0)
				ply:SendMessage("Headbob is off!",7,Color(0,255,0,255));
				return
	end
	
	if ( ply:GetNWInt("togglebob") == 0 ) then
	ply:SetNWInt("togglebob", 1)
				ply:SendMessage("Headbob is on!",7,Color(0,255,0,255));
				return
	end
end
concommand.Add("rp_headbob", ToggleBob)



function OpenDoor(ply, cmd, args)
		local ent = ply:GetEyeTrace().Entity
		if(ply:GetEyeTrace().HitPos:Distance(ply:GetPos()) < 150) then

				ent:Fire("toggle", 1)

		end
end
concommand.Add("rp_opendoor", OpenDoor)





function AdminList2( ply, cmd, args )
	ply:PrintMessage( 2, "**--Admin command list--**" );
	ply:PrintMessage( 2, " " );
	ply:PrintMessage( 2, "rp_seeall" );
	ply:PrintMessage( 2, "rp_explode" );
	ply:PrintMessage( 2, "rp_teleport" );
	ply:PrintMessage( 2, "rp_kill" );
	ply:PrintMessage( 2, "rp_spec" );
	ply:PrintMessage( 2, "rp_unspec" );
	ply:PrintMessage( 2, "rp_tool" );
	ply:PrintMessage( 2, "rp_phys" );
	ply:PrintMessage( 2, "rp_makeadmin" );
	ply:PrintMessage( 2, "rp_makemoderator" );
	ply:PrintMessage( 2, "rp_givevip" );
	ply:PrintMessage( 2, "rp_dropration" );
	ply:PrintMessage( 2, "rp_dimebag" );
	ply:PrintMessage( 2, "rp_createitem - Creates an item via Unique ID" );
	ply:PrintMessage( 2, "rp_kick name reason - works well, but must have quotes around reason" );
	ply:PrintMessage( 2, "rp_ban - lul broken" );
	ply:PrintMessage( 2, "rp_doorname - Not admin, but also not fully developed." );
	ply:PrintMessage( 2, "rp_gdoorname - Not admin, but also not fully developed." );
	ply:PrintMessage( 2, "rp_note playername note - note must have quotes around it" );
	ply:PrintMessage( 2, "rp_gnote - gets the players current stickynote" );
	ply:PrintMessage( 2, "rp_bring" );
	ply:PrintMessage( 2, "rp_slap" );
	ply:PrintMessage( 2, "rp_getpos - Debug command, get XYZ coordinates" );
	ply:PrintMessage( 2, "rp_goto" );
	ply:PrintMessage( 2, "rp_hide" );

end
concommand.Add( "rp_adminhelp", AdminList2 );









function LoadDoorInfoCrap( ply, cmd, args )
				GlobalConsoleMessage("Doors started loading...!")
	CreateDoorInfo();
end
concommand.Add( "rp_doors", LoadDoorInfoCrap );









function ToggleQMenu(ply, cmd, args)

	if ( ply:GetNWInt("menu") == 1 ) then
					ply:ConCommand("-menu") 
	ply:SetNWInt("menu", 0)
				return
	end
	
	if ( ply:GetNWInt("menu") == 0 ) then
					ply:ConCommand("+menu") 
	ply:SetNWInt("menu", 1)
				return
	end
end
concommand.Add("rp_toggleqmenu", ToggleQMenu)


function removegoddamnflatline()
return true
end
hook.Add( "PlayerDeathSound", "RemoveFlatlineSound", removegoddamnflatline )









function GM:Think()

	for k, v in pairs(player.GetAll()) do

		if ( v:Health() > 100) then
			v:SetHealth( 100 )
		end

			local Speed = v:GetVelocity():Length()
			local JumpSpeed = v:GetVelocity().z


			if (v:Alive()) then 
			
			if (JumpSpeed > 100) then
				v:SetNWInt( "hunger_subt", v:GetNWInt( "hunger_subt") + 0.25)
				v:SetNWInt( "thirst_subt", v:GetNWInt( "thirst_subt") + 0.75)
			end
			if (Speed > 150) then
				v:SetNWInt( "hunger_subt", v:GetNWInt( "hunger_subt") + 0.025)
				v:SetNWInt( "thirst_subt", v:GetNWInt( "thirst_subt") + 0.075)
			end
			if ( v:GetNWInt( "hunger" ) < 0) then
				v:SetNWInt( "hunger_subt", 0)
				v:SetNWInt( "hunger", 0)
			end
			if ( v:GetNWInt( "hunger" ) > 10000) then
				v:SetNWInt( "hunger", 10000)
				v:SetNWInt( "hunger_add", 0)
			end
			
			
			
			
			
			if ( v:GetNWInt( "thirst" ) < 0) then
				v:SetNWInt( "thirst_subt", 0)
				v:SetNWInt( "thirst", 0)
			end
			if ( v:GetNWInt( "thirst" ) > 10000) then
				v:SetNWInt( "thirst", 10000)
				v:SetNWInt( "thirst_add", 0)
			end
			
			
			
				//HungerCatchUp
				if ( v:GetNWInt( "hunger_add" ) > 0) then
					v:SetNWInt( "hunger_add", v:GetNWInt( "hunger_add") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") + 1)
				end
				if ( v:GetNWInt( "hunger_subt" ) > 0) then
					v:SetNWInt( "hunger_subt", v:GetNWInt( "hunger_subt") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") - 1)
				end
				if ( v:GetNWInt( "hunger_add" ) > 0) then
					v:SetNWInt( "hunger_add", v:GetNWInt( "hunger_add") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") + 1)
				end
				if ( v:GetNWInt( "hunger_subt" ) > 0) then
					v:SetNWInt( "hunger_subt", v:GetNWInt( "hunger_subt") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") - 1)
				end			
			
				//HungerCatchUp
				if ( v:GetNWInt( "hunger_add" ) > 0) then
					v:SetNWInt( "hunger_add", v:GetNWInt( "hunger_add") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") + 1)
				end
				if ( v:GetNWInt( "hunger_subt" ) > 0) then
					v:SetNWInt( "hunger_subt", v:GetNWInt( "hunger_subt") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") - 1)
				end
				if ( v:GetNWInt( "hunger_add" ) > 0) then
					v:SetNWInt( "hunger_add", v:GetNWInt( "hunger_add") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") + 1)
				end
				if ( v:GetNWInt( "hunger_subt" ) > 0) then
					v:SetNWInt( "hunger_subt", v:GetNWInt( "hunger_subt") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") - 1)
				end
				
				
				
				//HungerCatchUp
				if ( v:GetNWInt( "hunger_add" ) > 0) then
					v:SetNWInt( "hunger_add", v:GetNWInt( "hunger_add") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") + 1)
				end
				if ( v:GetNWInt( "hunger_subt" ) > 0) then
					v:SetNWInt( "hunger_subt", v:GetNWInt( "hunger_subt") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") - 1)
				end
				if ( v:GetNWInt( "hunger_add" ) > 0) then
					v:SetNWInt( "hunger_add", v:GetNWInt( "hunger_add") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") + 1)
				end
				if ( v:GetNWInt( "hunger_subt" ) > 0) then
					v:SetNWInt( "hunger_subt", v:GetNWInt( "hunger_subt") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") - 1)
				end			
			
				//HungerCatchUp
				if ( v:GetNWInt( "hunger_add" ) > 0) then
					v:SetNWInt( "hunger_add", v:GetNWInt( "hunger_add") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") + 1)
				end
				if ( v:GetNWInt( "hunger_subt" ) > 0) then
					v:SetNWInt( "hunger_subt", v:GetNWInt( "hunger_subt") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") - 1)
				end
				if ( v:GetNWInt( "hunger_add" ) > 0) then
					v:SetNWInt( "hunger_add", v:GetNWInt( "hunger_add") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") + 1)
				end
				if ( v:GetNWInt( "hunger_subt" ) > 0) then
					v:SetNWInt( "hunger_subt", v:GetNWInt( "hunger_subt") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") - 1)
				end
				
				
				
				
				
				
			
				//HungerCatchUp
				if ( v:GetNWInt( "hunger_add" ) > 0) then
					v:SetNWInt( "hunger_add", v:GetNWInt( "hunger_add") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") + 1)
				end
				if ( v:GetNWInt( "hunger_subt" ) > 0) then
					v:SetNWInt( "hunger_subt", v:GetNWInt( "hunger_subt") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") - 1)
				end
				if ( v:GetNWInt( "hunger_add" ) > 0) then
					v:SetNWInt( "hunger_add", v:GetNWInt( "hunger_add") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") + 1)
				end
				if ( v:GetNWInt( "hunger_subt" ) > 0) then
					v:SetNWInt( "hunger_subt", v:GetNWInt( "hunger_subt") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") - 1)
				end			
			
				//HungerCatchUp
				if ( v:GetNWInt( "hunger_add" ) > 0) then
					v:SetNWInt( "hunger_add", v:GetNWInt( "hunger_add") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") + 1)
				end
				if ( v:GetNWInt( "hunger_subt" ) > 0) then
					v:SetNWInt( "hunger_subt", v:GetNWInt( "hunger_subt") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") - 1)
				end
				if ( v:GetNWInt( "hunger_add" ) > 0) then
					v:SetNWInt( "hunger_add", v:GetNWInt( "hunger_add") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") + 1)
				end
				if ( v:GetNWInt( "hunger_subt" ) > 0) then
					v:SetNWInt( "hunger_subt", v:GetNWInt( "hunger_subt") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") - 1)
				end
				
				
				
				//HungerCatchUp
				if ( v:GetNWInt( "hunger_add" ) > 0) then
					v:SetNWInt( "hunger_add", v:GetNWInt( "hunger_add") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") + 1)
				end
				if ( v:GetNWInt( "hunger_subt" ) > 0) then
					v:SetNWInt( "hunger_subt", v:GetNWInt( "hunger_subt") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") - 1)
				end
				if ( v:GetNWInt( "hunger_add" ) > 0) then
					v:SetNWInt( "hunger_add", v:GetNWInt( "hunger_add") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") + 1)
				end
				if ( v:GetNWInt( "hunger_subt" ) > 0) then
					v:SetNWInt( "hunger_subt", v:GetNWInt( "hunger_subt") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") - 1)
				end			
			
				//HungerCatchUp
				if ( v:GetNWInt( "hunger_add" ) > 0) then
					v:SetNWInt( "hunger_add", v:GetNWInt( "hunger_add") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") + 1)
				end
				if ( v:GetNWInt( "hunger_subt" ) > 0) then
					v:SetNWInt( "hunger_subt", v:GetNWInt( "hunger_subt") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") - 1)
				end
				if ( v:GetNWInt( "hunger_add" ) > 0) then
					v:SetNWInt( "hunger_add", v:GetNWInt( "hunger_add") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") + 1)
				end
				if ( v:GetNWInt( "hunger_subt" ) > 0) then
					v:SetNWInt( "hunger_subt", v:GetNWInt( "hunger_subt") - 1)
					v:SetNWInt( "hunger", v:GetNWInt( "hunger") - 1)
				end
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				///////////////////////////////
				
				
				
				
				
				
				//ThirstCatchUp
				if ( v:GetNWInt( "thirst_add" ) > 0) then
					v:SetNWInt( "thirst_add", v:GetNWInt( "thirst_add") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") + 1)
				end
				if ( v:GetNWInt( "thirst_subt" ) > 0) then
					v:SetNWInt( "thirst_subt", v:GetNWInt( "thirst_subt") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") - 1)
				end
				if ( v:GetNWInt( "thirst_add" ) > 0) then
					v:SetNWInt( "thirst_add", v:GetNWInt( "thirst_add") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") + 1)
				end
				if ( v:GetNWInt( "thirst_subt" ) > 0) then
					v:SetNWInt( "thirst_subt", v:GetNWInt( "thirst_subt") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") - 1)
				end				

								
				
				//ThirstCatchUp
				if ( v:GetNWInt( "thirst_add" ) > 0) then
					v:SetNWInt( "thirst_add", v:GetNWInt( "thirst_add") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") + 1)
				end
				if ( v:GetNWInt( "thirst_subt" ) > 0) then
					v:SetNWInt( "thirst_subt", v:GetNWInt( "thirst_subt") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") - 1)
				end
				if ( v:GetNWInt( "thirst_add" ) > 0) then
					v:SetNWInt( "thirst_add", v:GetNWInt( "thirst_add") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") + 1)
				end
				if ( v:GetNWInt( "thirst_subt" ) > 0) then
					v:SetNWInt( "thirst_subt", v:GetNWInt( "thirst_subt") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") - 1)
				end				
				//ThirstCatchUp
				if ( v:GetNWInt( "thirst_add" ) > 0) then
					v:SetNWInt( "thirst_add", v:GetNWInt( "thirst_add") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") + 1)
				end
				if ( v:GetNWInt( "thirst_subt" ) > 0) then
					v:SetNWInt( "thirst_subt", v:GetNWInt( "thirst_subt") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") - 1)
				end
				if ( v:GetNWInt( "thirst_add" ) > 0) then
					v:SetNWInt( "thirst_add", v:GetNWInt( "thirst_add") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") + 1)
				end
				if ( v:GetNWInt( "thirst_subt" ) > 0) then
					v:SetNWInt( "thirst_subt", v:GetNWInt( "thirst_subt") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") - 1)
				end				

								
				
				//ThirstCatchUp
				if ( v:GetNWInt( "thirst_add" ) > 0) then
					v:SetNWInt( "thirst_add", v:GetNWInt( "thirst_add") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") + 1)
				end
				if ( v:GetNWInt( "thirst_subt" ) > 0) then
					v:SetNWInt( "thirst_subt", v:GetNWInt( "thirst_subt") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") - 1)
				end
				if ( v:GetNWInt( "thirst_add" ) > 0) then
					v:SetNWInt( "thirst_add", v:GetNWInt( "thirst_add") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") + 1)
				end
				if ( v:GetNWInt( "thirst_subt" ) > 0) then
					v:SetNWInt( "thirst_subt", v:GetNWInt( "thirst_subt") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") - 1)
				end				


				
				
				
				//ThirstCatchUp
				if ( v:GetNWInt( "thirst_add" ) > 0) then
					v:SetNWInt( "thirst_add", v:GetNWInt( "thirst_add") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") + 1)
				end
				if ( v:GetNWInt( "thirst_subt" ) > 0) then
					v:SetNWInt( "thirst_subt", v:GetNWInt( "thirst_subt") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") - 1)
				end
				if ( v:GetNWInt( "thirst_add" ) > 0) then
					v:SetNWInt( "thirst_add", v:GetNWInt( "thirst_add") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") + 1)
				end
				if ( v:GetNWInt( "thirst_subt" ) > 0) then
					v:SetNWInt( "thirst_subt", v:GetNWInt( "thirst_subt") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") - 1)
				end				

								
				
				//ThirstCatchUp
				if ( v:GetNWInt( "thirst_add" ) > 0) then
					v:SetNWInt( "thirst_add", v:GetNWInt( "thirst_add") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") + 1)
				end
				if ( v:GetNWInt( "thirst_subt" ) > 0) then
					v:SetNWInt( "thirst_subt", v:GetNWInt( "thirst_subt") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") - 1)
				end
				if ( v:GetNWInt( "thirst_add" ) > 0) then
					v:SetNWInt( "thirst_add", v:GetNWInt( "thirst_add") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") + 1)
				end
				if ( v:GetNWInt( "thirst_subt" ) > 0) then
					v:SetNWInt( "thirst_subt", v:GetNWInt( "thirst_subt") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") - 1)
				end				
				//ThirstCatchUp
				if ( v:GetNWInt( "thirst_add" ) > 0) then
					v:SetNWInt( "thirst_add", v:GetNWInt( "thirst_add") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") + 1)
				end
				if ( v:GetNWInt( "thirst_subt" ) > 0) then
					v:SetNWInt( "thirst_subt", v:GetNWInt( "thirst_subt") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") - 1)
				end
				if ( v:GetNWInt( "thirst_add" ) > 0) then
					v:SetNWInt( "thirst_add", v:GetNWInt( "thirst_add") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") + 1)
				end
				if ( v:GetNWInt( "thirst_subt" ) > 0) then
					v:SetNWInt( "thirst_subt", v:GetNWInt( "thirst_subt") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") - 1)
				end				

								
				
				//ThirstCatchUp
				if ( v:GetNWInt( "thirst_add" ) > 0) then
					v:SetNWInt( "thirst_add", v:GetNWInt( "thirst_add") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") + 1)
				end
				if ( v:GetNWInt( "thirst_subt" ) > 0) then
					v:SetNWInt( "thirst_subt", v:GetNWInt( "thirst_subt") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") - 1)
				end
				if ( v:GetNWInt( "thirst_add" ) > 0) then
					v:SetNWInt( "thirst_add", v:GetNWInt( "thirst_add") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") + 1)
				end
				if ( v:GetNWInt( "thirst_subt" ) > 0) then
					v:SetNWInt( "thirst_subt", v:GetNWInt( "thirst_subt") - 1)
					v:SetNWInt( "thirst", v:GetNWInt( "thirst") - 1)
				end				
				
				
				
				
				
				
				
				
				
				
				
				
			end
			
			
			
	end
	
end









