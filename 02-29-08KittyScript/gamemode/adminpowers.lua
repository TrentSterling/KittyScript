----------------------------
-- KittyScript January 15, 2008)
-- by John [MT]OMalley Dorian
--
-- First beta - March 25, 2008
-- 
--Give admins magical powers!
----------------------------

include( 'adminsetflag.lua' )--INCLUDE THE FLAG SYSTEM!

function Klik(ply, cmd, args)
	umsg.Start("KlickJoo", ply)
	umsg.End()
end
concommand.Add( "rp_klik", Klik )

function SeeAll(ply, cmd, args)
	if( tonumber(ply:GetNWInt( "adminlevel" )) < 2 ) then
		ply:SendMessage("You need admin rights for this!",3,Color(255,0,0,255))
	return end
	umsg.Start("ToggleSeeAll", ply)
	umsg.End()
end
concommand.Add( "rp_seeall", SeeAll );

/*---------------------------------------------------------
  SWEP Spawning
---------------------------------------------------------*/
//Override SWEP spawning. --Later, add a code so that admins CAN spawn sweps.
function CCSpawnSWEP( ply, command, arguments )
	ply:SendMessage("You can't do that you faggot!",3,Color(255,0,0,255))
end
concommand.Add( "gm_giveswep", CCSpawnSWEP )
 
//Find players by name.
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

function GlobalMessage(text)
	for k, v in pairs(player.GetAll()) do
		v:ChatPrint(text)
	end
end



function GlobalConsoleMessage(text)
	for k, v in pairs(player.GetAll()) do
		v:PrintMessage( 2, text );
	end
end



/*---------------------------------------------------------
Admin like abilites!
---------------------------------------------------------*/
//Explode the motherfucker
function AdminExplode(ply, cmd, args)
	
	if( tonumber(ply:GetNWInt( "adminlevel" )) < 2 ) then
		ply:SendMessage("You need admin rights for this!",3,Color(255,0,0,255))
	return end
	local target = GetPlayerByName(args[1])
	if(target != nil) then
		local pos = target:GetPos()
		local effectdata = EffectData()
		effectdata:SetStart(pos)
		effectdata:SetOrigin(pos)
		effectdata:SetScale(1.5)
		util.Effect("HelicopterMegaBomb", effectdata)
		target:EmitSound( Sound( "vo/citadel/br_ohshit.wav" ) );
		target:EmitSound( Sound( "weapons/explode3.wav" ) );
		target:Kill()
		GlobalMessage(target:Nick() .. " was exploded by " .. ply:Nick() )
	end
	if(target == nil) then
		ply:PrintMessage( 2, "Failed" );
	end
end
concommand.Add("rp_explode", AdminExplode)

//Teleport yourself!
function GM.TeleportSelf(ply)
	local GM = GAMEMODE
	if( tonumber(ply:GetNWInt( "adminlevel" )) < 2 ) then
		ply:SendMessage("You need admin rights for this!",3,Color(255,0,0,255))
	return end
	local tr = ply:TraceFromEyes(10000)
	ply:SetPos(tr.HitPos + Vector(0,0,30))
	ply:SendMessage("Teleported!",3,Color(0,255,255,255))
	ply:SetLocalVelocity( Vector( 0, 0, 0 ) ) -- Stop!
	GlobalConsoleMessage(ply:Nick() .. " TELEPORTED!")
end
concommand.Add("rp_teleport",GM.TeleportSelf)

function GM.TestKill(ply)
	local GM = GAMEMODE
	if( tonumber(ply:GetNWInt( "adminlevel" )) < 2 ) then
		ply:SendMessage("You need admin rights for this!",3,Color(255,0,0,255))
	return end
	ply:Kill();
end
concommand.Add("rp_kill",GM.TestKill)

//Spectator Mode--Basically noclip, still buggy.
function GM.SpectateAdmin(ply)
	if( tonumber(ply:GetNWInt( "adminlevel" )) < 2 ) then
		ply:SendMessage("You need admin rights for this!",3,Color(255,0,0,255))
	return end
	ply:SetMoveType(MOVETYPE_NOCLIP)
	ply:ConCommand("-duck")--If a scanner, this should allow flying in no-clip
end
concommand.Add("rp_spec",GM.SpectateAdmin)

//UNSpectator--Get out of noclip, again, buggy.
function GM.UnSpectateAdmin(ply)
	if( tonumber(ply:GetNWInt( "adminlevel" )) < 2 ) then
	ply:SendMessage("You need admin rights for this!",3,Color(255,0,0,255))
	return end
	ply:SetMoveType(MOVETYPE_WALK)
	if(ply:GetNWInt("setflag") == 2) then--If true, your flag is set to scanner, reduck yourself
		ply:ConCommand("+duck")
		ply:SetMoveType(4)
	end
	if(ply:GetNWInt("setflag") == 4) then--If true, your flag is set to scanner, reduck yourself
		ply:ConCommand("+duck")
		ply:SetMoveType(4)
	end
end
concommand.Add("rp_unspec",GM.UnSpectateAdmin)

function GM.GiveToolAdmin(ply)--Give a toolgun to a player
		ply:Give( "gmod_tool" );
end
concommand.Add("rp_tool",GM.GiveToolAdmin)

function GM.GivePhysAdmin(ply)--Give a physics gun to a player
		ply:Give( "weapon_physgun" );
end
concommand.Add("rp_phys",GM.GivePhysAdmin)

function SaveAdmin(player)
	local dir = "KittyScript/admindata/" .. FormatSteamID(player) .. ".txt";
	if( not file.Exists( dir ) ) then
		file.Write( dir, "0" );
	end

	file.Write( dir, player:GetNWInt( "adminlevel" ))
end

function MakeAdmin(ply, cmd, args)
	if( tonumber(ply:GetNWInt( "adminlevel" )) < 2 ) then
		ply:SendMessage("You need admin rights for this!",3,Color(255,0,0,255))
	return end
	if args[1] then
		local target = GetPlayerByName(args[1])
		if(target != nil) then
            target:SendMessage("You have been allowed ADMIN!",7,Color(0,255,0,255))
			target:SetNWInt("adminlevel", 2)
			ply:PrintMessage( 2, "Sucessfully added ADMIN to player *** " .. target:GetNWString( "RPName" ) .. " *** ." );
            ply:SendMessage("Sucessfully added ADMIN to  player *** " .. target:GetNWString( "RPName" ) .. " *** .",7,Color(0,255,0,255))
			SaveAdmin(target)
			GlobalConsoleMessage(ply:Nick() .. " gave ADMIN to " .. target:Nick())
		end
		
		if(target == nil) then
			ply:PrintMessage( 2, "Failed to find player."  .. args[1]);
            ply:SendMessage("Failed to find player."  .. args[1],7,Color(0,255,0,255))
		end
	end
end
concommand.Add("rp_makeadmin", MakeAdmin)

function MakeModerator(ply, cmd, args)
	if( tonumber(ply:GetNWInt( "adminlevel" )) < 2 ) then
		ply:SendMessage("You need admin rights for this!",3,Color(255,0,0,255))
	return end
	if args[1] then
		local target = GetPlayerByName(args[1])
		if(target != nil) then
            target:SendMessage("You have been allowed MODERATOR!",7,Color(0,255,0,255))
			target:SetNWInt("adminlevel", 1)
			ply:PrintMessage( 2, "Sucessfully added MODERATOR to player *** " .. target:GetNWString( "RPName" ) .. " *** ." );
            ply:SendMessage("Sucessfully added MODERATOR to player *** " .. target:GetNWString( "RPName" ) .. " *** .",7,Color(0,255,0,255))
			SaveAdmin(target)
			GlobalConsoleMessage(ply:Nick() .. " gave MODERATOR to " .. target:Nick())
		end
		
		if(target == nil) then
			ply:PrintMessage( 2, "Failed to find player."  .. args[1]);
            ply:SendMessage("Failed to find player."  .. args[1],7,Color(0,255,0,255))
		end
	end
end
concommand.Add("rp_makemoderator", MakeModerator)

function GiveVIP(ply, cmd, args)
	if( tonumber(ply:GetNWInt( "adminlevel" )) < 2 ) then
		ply:SendMessage("You need admin rights for this!",3,Color(255,0,0,255))
	return end
	if args[1] then
		local target = GetPlayerByName(args[1])
		if(target != nil) then
            target:SendMessage("You have been allowed VIP!",7,Color(0,255,0,255))
			target:SetNWInt("vip", 1)
			ply:PrintMessage( 2, "Sucessfully added VIP to player *** " .. target:GetNWString( "RPName" ) .. " *** ." );
            ply:SendMessage("Sucessfully added VIP to player *** " .. target:GetNWString( "RPName" ) .. " *** .",7,Color(0,255,0,255))
			SaveVIP(target)
			target:Give( "gmod_tool" );
			GlobalConsoleMessage(ply:Nick() .. " gave VIP to " .. target:Nick())
		end
		
		if(target == nil) then
			ply:PrintMessage( 2, "Failed to find player."  .. args[1]);
            ply:SendMessage("Failed to find player."  .. args[1],7,Color(0,255,0,255))
		end
	end
end
concommand.Add("rp_givevip", GiveVIP)

function ccDropRation( ply, cmd, args )
	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 55;
	trace.filter = ply;
	local tr = util.TraceLine( trace );
	CreateItem( "ration", Vector(1611.7014, 443.5894, 1874.4227) );
	GlobalConsoleMessage(ply:Nick() .. " dropped a ration!")
end
concommand.Add( "rp_dropration", ccDropRation );

function ccDropDimebag( ply, cmd, args )
	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 55;
	trace.filter = ply;
	local tr = util.TraceLine( trace );
	CreateItem( "weedbag", tr.HitPos );
end
concommand.Add( "rp_dimebag", ccDropDimebag );


function ccDropSetItem( ply, cmd, args )
	if( not ItemData[args[1]] ) then return; end
	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 55;
	trace.filter = ply;
	local tr = util.TraceLine( trace );
	
	CreateItem( args[1], tr.HitPos );
end
concommand.Add( "rp_createitem", ccDropSetItem );


function CreateItem( id, pos, ang )
	local item = ents.Create( "item_prop" );
		item:SetModel( ItemData[id].Model );--Indentation is not needed like this, but it looks nicer
		item:SetData( ItemData[id] );
		item:SetPos( pos );
		item:SetAngles( ang or Angle( 0, 0, 0 ) );
	item:Spawn();
end


function ccUseItem( ply, cmd, args )
	local trace = util.GetPlayerTrace( ply, ply:GetCursorAimVector( ) )
	local tr = util.TraceLine( trace )
	local item = tr.Entity
	if tr.HitNonWorld then
		target = tr.Entity --Store the entity it hit
	end

	if (target) then
	local class = item:GetClass();
		if( string.sub(class, 1, 5) == "item_" ) then 
			if( ply:GetPos():Distance( target:GetPos() ) < 100 ) then
			if(not target:GetTable().Data ) then return; end
			if( target:GetTable().Data == nil ) then return; end
			ItemData[item:GetTable().Data.UniqueID].Owner = ply
			ItemData[item:GetTable().Data.UniqueID].OnPickup( ItemData[item:GetTable().Data.UniqueID], ply )
			SaveInfo(ply);
			tr.Entity:Remove();
			end
		end
	end
end
concommand.Add( "rp_useitem", ccUseItem );

//Dont need this
include( 'parseitems.lua' )--Make sure its here, even if its already in init, Oh wait, this is redundant. Remove after more testing.

//For inventory - Dont use it yet
function GiveItem( id, tr, ply )--lul dont use yet
local size = ItemData[id].Size;
--if( ItemData[id].OnPickup ) then
--	ItemData[id].OnPickup( ply )
--end
tr.Entity:Remove();
end


function AdminKick(ply, cmd, args)--kick by RPname
	if( tonumber(ply:GetNWInt( "adminlevel" )) < 2 ) then
		ply:SendMessage("You need admin rights for this!",3,Color(255,0,0,255))
	return end
	local target = GetPlayerByName(args[1])
	if(target != nil) then
		if(args[2] != nil) then
			game.ConsoleCommand("kickid " .. target:UserID() .. " " .. args[2] .. "\n")
		end
		if(args[2] == nil) then	
			game.ConsoleCommand("kickid " .. target:UserID() .. " " .. "kick" .. "\n")
		end
	end
end
concommand.Add("rp_kick", AdminKick)


function AdminBan(ply, cmd, args)--ban by RPname (NOT WORKING)
	if( tonumber(ply:GetNWInt( "adminlevel" )) < 2 ) then
		ply:SendMessage("You need admin rights for this!",3,Color(255,0,0,255))
	return end
	local target = GetPlayerByName(args[1])
	if(target != nil) then
		game.ConsoleCommand("banid " .. target:UserID() .. " " .. args[2] .. "\n")
	end
end
concommand.Add("rp_ban", AdminBan)


function ccDoorName( ply, cmd, args )
	local trace = util.GetPlayerTrace( ply, ply:GetCursorAimVector( ) )
	local tr = util.TraceLine( trace )
	local door = tr.Entity
	door:SetNWString("doorname", args[1])
	door:GetPos()
end
concommand.Add( "rp_doorname", ccDoorName );


function ccGDoorName( ply, cmd, args )
	local trace = util.GetPlayerTrace( ply, ply:GetCursorAimVector( ) )
	local tr = util.TraceLine( trace )
	local door = tr.Entity
	GlobalMessage(door:GetNWString("doorname") )
	GlobalMessage(door:EntIndex() )
	GlobalMessage(tostring(door:GetPos().x ))
	GlobalMessage(tostring(door:GetPos().y ))
	GlobalMessage(tostring(door:GetPos().z ))
	door:GetNWString("doorname")
end
concommand.Add( "rp_gent", ccGDoorName );


function StickyNote(ply, cmd, args)
	if( tonumber(ply:GetNWInt( "adminlevel" )) < 2 ) then
		ply:SendMessage("You need admin rights for this!",3,Color(255,0,0,255))
	return end
	if args[1] then
		local target = GetPlayerByName(args[1])
		if(target != nil) then
			target:SetNWFloat("stickynote", args[2])
			ply:PrintMessage( 2, "StickyNote saved: " .. args[2] );
            ply:SendMessage("StickyNote saved: " .. args[2],7,Color(255,255,0,255))
			SaveNotes(target);
		end
		
		if(target == nil) then
			ply:PrintMessage( 2, "Failed to find player."  .. args[1]);
            ply:SendMessage("Failed to find player."  .. args[1],7,Color(0,255,0,255))
		end
		end
end
concommand.Add("rp_note", StickyNote)


function gStickyNote(ply, cmd, args)
	if( tonumber(ply:GetNWInt( "adminlevel" )) < 2 ) then
		ply:SendMessage("You need admin rights for this!",3,Color(255,0,0,255))
	return end
	
	if args[1] then
		local target = GetPlayerByName(args[1])
		if(target != nil) then
			ply:SendMessage("Player's StickyNote: " .. target:GetNWFloat("stickynote") ,7,Color(255,255,0,255))
			ply:PrintMessage( 2, "Player's StickyNote: " .. target:GetNWFloat("stickynote") );
		end

		if(target == nil) then
			ply:PrintMessage( 2, "Failed to find player."  .. args[1]);
			ply:SendMessage("Failed to find player."  .. args[1],7,Color(0,255,0,255))
		end
	end
end
concommand.Add("rp_gnote", gStickyNote)


function TeleportPlayer(ply, cmd, args)
	if( tonumber(ply:GetNWInt( "adminlevel" )) < 2 ) then
		ply:SendMessage("You need admin rights for this!",3,Color(255,0,0,255))
	return end
	
	if args[1] then
	local target = GetPlayerByName(args[1])
		if(target != nil) then
			local tr = ply:TraceFromEyes(10000)
			target:SetPos(tr.HitPos + Vector(0,0,30))
			ply:SendMessage("Player teleported!",3,Color(0,255,255,255))
			target:SendMessage("You've been teleported!",3,Color(0,255,255,255))
			target:SetLocalVelocity( Vector( 0, 0, 0 ) ) -- Stop!
			GlobalConsoleMessage(ply:Nick() .. " TELEPORTED " .. target:Nick())
		end
	end
end
concommand.Add("rp_bring",TeleportPlayer)


function AdminSlap(ply, cmd, args)--Fist of god
	if( tonumber(ply:GetNWInt( "adminlevel" )) < 2 ) then
		ply:SendMessage("You need admin rights for this!",3,Color(255,0,0,255))
	return end

	local target = GetPlayerByName(args[1])
	if(target != nil) then
		GlobalMessage(target:Nick() .. " was slapped by " .. ply:Nick())
		target:SetVelocity(Vector(math.random(-300,300), math.random(-300,300), math.random(300, 400)))--WEEEEEEE!
		target:EmitSound( Sound( "npc/strider/charging.wav" ),50,100 );--SHWHOP!!!!
	end
end
concommand.Add("rp_slap", AdminSlap)


function ccGetPlayerPos( ply, cmd, args )--DEBUG COMMAND: Get the player's X,Y and Z coordinates.
	GlobalMessage(tostring(ply:GetPos() ))
end
concommand.Add( "rp_getpos", ccGetPlayerPos );


function AdminGoto(ply, cmd, args)--Go to a player
	if( tonumber(ply:GetNWInt( "adminlevel" )) < 2 ) then
		ply:SendMessage("You need admin rights for this!",3,Color(255,0,0,255))
	return end

	local target = GetPlayerByName(args[1])
	if(target != nil) then
		local telepoint = (target:GetPos() + target:GetAimVector() * 90)+ Vector(0,0,50)
		ply:SetPos(telepoint)
	end
end
concommand.Add("rp_goto", AdminGoto)


function HideSelf(ply, cmd, args)--Sneaky sneaky admins!
	if( tonumber(ply:GetNWInt( "adminlevel" )) < 2 ) then
		ply:SendMessage("You need admin rights for this!",3,Color(255,0,0,255))
	return end

	if( tonumber(ply:GetNWInt( "adminhiding" )) == 0 ) then
		ply:GetActiveWeapon():SetNoDraw( true );
		ply:SetNoDraw( true );
		ply:SetNWInt( "adminhiding", 1 )
		ply:SendMessage("You are cloaked!",3,Color(255,0,0,255))
	return end

	if( tonumber(ply:GetNWInt( "adminhiding" )) == 1 ) then
		ply:GetNWInt( "adminhiding" )
		ply:GetActiveWeapon():SetNoDraw( false );
		ply:SetNoDraw( false );
		ply:SetNWInt( "adminhiding", 0 )
		ply:SendMessage("You are NOT cloaked!",3,Color(255,0,0,255))
	return end
end
concommand.Add("rp_hide", HideSelf)


function RestartMap(ply)--Restart the map!
	if( tonumber(ply:GetNWInt( "adminlevel" )) < 2 ) then
		ply:SendMessage("You need admin rights for this!",3,Color(255,0,0,255))
	return end
	
	if(ply:EntIndex() == 0) then--If you are consle...
		GlobalMessage("Console is restarting the map.")--Warn everyone!
	else--Otherwise...
		GlobalMessage(ply:Nick() .. " is restarting the map.")--Warn everyone!
	end
	for k, v in pairs(player.GetAll()) do
		SaveInfo(v);--Save their shit!
	end
	timer.Create("restartmap", 5, 1, game.ConsoleCommand, "changelevel " .. game.GetMap() .. "\n")--5 seconds everybody!
end
concommand.Add("rp_restartmap", RestartMap)


function StripAllWeapons(ply, cmd, args)--Strip them of all weapons
	if( tonumber(ply:GetNWInt( "adminlevel" )) < 2 ) then
		ply:SendMessage("You need admin rights for this!",3,Color(255,0,0,255))
	return end
	
	
	local target = GetPlayerByName(args[1])
	if(target != nil) then
			target:StripWeapons();
	end
end
concommand.Add("rp_strip", StripAllWeapons)




function PlaySong(ply, cmd, args)--Strip them of all weapons
	if( tonumber(ply:GetNWInt( "adminlevel" )) < 2 ) then
		ply:SendMessage("You need admin rights for this!",3,Color(255,0,0,255))
	return end
	
	local trace = util.GetPlayerTrace( ply, ply:GetCursorAimVector( ) )
	local tr = util.TraceLine( trace )
	local radio = tr.Entity
radio:EmitSound( Sound("music/hl1_song" .. args[1] .. ".mp3") );

		
end
concommand.Add("rp_song", PlaySong)


function PlaySongAdmins(ply, cmd, args)--Strip them of all weapons

	if( tonumber(ply:GetNWInt( "adminlevel" )) < 2 ) then
		ply:SendMessage("You need admin rights for this!",3,Color(255,0,0,255))
	return end


		for k, v in pairs(player.GetAll()) do
		
	local trace = util.GetPlayerTrace( v, v:GetCursorAimVector( ) )
	local tr = util.TraceLine( trace )
	local radio = tr.Entity
radio:EmitSound( Sound("music/hl1_song" .. args[1] .. ".mp3") );


		end

end
concommand.Add("rp_songadmin", PlaySongAdmins)


