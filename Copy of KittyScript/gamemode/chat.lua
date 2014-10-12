----------------------------
-- KittyScript January 15, 2008)
-- by John [MT]OMalley Dorian
--
-- First beta - March 25, 2008
-- 
--Chat commands and processing
/*---------------------------------------------------------
 <<<<<Get the party started>>>>>
---------------------------------------------------------*/
ChatCommands = { }

--Usage:
--Chat command, Callback, Should the prefix stay constant?
function AddChatCommand( cmd, callback, prefixconst )
	table.insert( ChatCommands, { cmd = cmd, callback = callback, prefixconst = prefixconst } );
end

function GM:PlayerSay( ply, text )
	self.BaseClass:PlayerSay( ply, text );
	local ftext = string.lower( text );
	for k, v in pairs( ChatCommands ) do
		local endpos = string.len( v.cmd );
		local strcmd = string.sub( ftext, 1, endpos );
		local argstart = 1;
		if( string.sub( text, endpos + 1, endpos + 1 ) == " " ) then
			argstart = 2;
		end
		if( strcmd == v.cmd ) then
			return v.callback( ply, string.sub( text, string.len( v.cmd ) + argstart ) or "" );
		end
	end
	if( 0 == 0 ) then--alltalk is 0?
		RangeChat( ply:GetNWString( "RPName" ) .. ": " .. text, ply:GetPos(), 250 , ply );
		return "";
	end
	return text;
end

local ents_FindInSphere = ents.FindInSphere

/*---------------------------------------------------------
  Range chat - Are people within the distance or sphere?
---------------------------------------------------------*/
function RangeChat(msg, pos, size, ply)
	if( ply:Alive() ) then
		local sphere = ents_FindInSphere(pos, size)
		for k, v in pairs(sphere) do
			if ( v:IsPlayer() ) then
				v:ChatPrint(msg)
			end
		end
	end
end

/*---------------------------------------------------------
  Range chat - Are people within the distance or sphere?
---------------------------------------------------------*/
function RangeChatKill(msg, pos, size, ply)
	local sphere = ents_FindInSphere(pos, size)
	for k, v in pairs(sphere) do
		if ( v:IsPlayer() ) then
			local pos = v:GetPos()
			local effectdata = EffectData()
			effectdata:SetStart(pos)
			effectdata:SetOrigin(pos)
			effectdata:SetScale(1.5)
			util.Effect("HelicopterMegaBomb", effectdata)
			v:EmitSound( Sound( "weapons/explode3.wav" ) );
			v:Kill()
		end
	end
end

function Notify( ply, msgtype, len, msg )--Notify? Find out where this is used, seems un-needed. In Private messaging
	ply:PrintMessage( 2, msg );
	ply:SendLua( "GAMEMODE:AddNotify(\"" .. msg .. "\", " .. msgtype .. ", " .. len .. ")" );
end

function FindPlayer( info )--Push through the list, find one that matches the info.
	for k, v in pairs( player.GetAll() ) do
		if( tonumber( info ) == v:EntIndex() ) then
			return v;
		end
		if( info == v:SteamID() ) then
			return v;
		end
		if( string.find( v:GetNWString( "RPName" ), info ) ~= nil ) then
			return v;
		end
	end
	return nil;
end

/*---------------------------------------------------------
  Private Message - A bitch.
---------------------------------------------------------*/
function PM( ply, args )
	local namepos = string.find( args, " " );--Look for a space that would deperate the name and the message
	if( not namepos ) then return ""; end--No space? You suck.
	local name = string.sub( args, 1, namepos - 1 );--Name is before the space
	local msg = string.sub( args, namepos + 1 );--msg is after the space
	target = FindPlayer( name );--Find dat foo
	if( target ) then--Target exists? Send that shit!
		target:PrintMessage( 2, "[PM] from " .. ply:GetNWString( "RPName" ) .. ": " .. msg );--console
		target:PrintMessage( 3, "[PM] from " .. ply:GetNWString( "RPName" ) .. ": " .. msg );--chat
		ply:PrintMessage( 2, "[PM] to" .. " "..target:GetNWString( "RPName" ) .." : ".. msg );--console
		ply:PrintMessage( 3, "[PM] to" .. " "..target:GetNWString( "RPName" ) .." : ".. msg );--chat
	else--If target doesnt exist, BLAH! NO TARGET!
		Notify( ply, 1, 3, "Could not find player: " .. name );--Notify?
		ply:SendMessage("Could not find player: ".. name ,5,Color(255,255,0,255))--Left fading notify.
	end
	return "";
end
AddChatCommand( "/pm", PM );

/*---------------------------------------------------------
  YELLING
---------------------------------------------------------*/
function Yell( ply, args )
	RangeChat( "[YELL]" .. ply:GetNWString( "RPName" ) .. ": " .. args, ply:GetPos(), 550 , ply);
	return "";
end
AddChatCommand( "/y", Yell );

function Boom( ply, args )
	ply:EmitSound( Sound( "vo/citadel/br_ohshit.wav" ) );
	local pos = ply:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(pos)
	effectdata:SetOrigin(pos)
	effectdata:SetScale(1.5)
	util.Effect("HelicopterMegaBomb", effectdata)
	RangeChatKill( "[YELL]" .. ply:GetNWString( "RPName" ) .. ": " .. args, ply:GetPos(), 550 , ply);
	return "";
end
AddChatCommand( "/boom", Boom );

/*---------------------------------------------------------
 /me
---------------------------------------------------------*/
function Me( ply, args )
	RangeChat( "*** " .. ply:GetNWString( "RPName" ) .. " " .. args, ply:GetPos(), 550 , ply);
	return "";
end
AddChatCommand( "/me", Me );

/*---------------------------------------------------------
 Local OOC
---------------------------------------------------------*/
function LocalOOC( ply, args )
	RangeChat( "[LocalOOC]" .. ply:GetNWString( "RPName" ) .. ": " .. args, ply:GetPos(), 550 , ply);
	return "";
end
AddChatCommand( "[[", LocalOOC );

/*---------------------------------------------------------
  Whispering
---------------------------------------------------------*/
function Whisper( ply, args )
	RangeChat( "[WHISPER]" .. ply:GetNWString( "RPName" ) .. ": " .. args, ply:EyePos(), 90 , ply);
	return "";                                                       
end
AddChatCommand( "/w", Whisper );

/*---------------------------------------------------------
  Smileing
---------------------------------------------------------*/
function Smile( ply, args )
	if( args == "") then
		RangeChat( "[Emote]" .. ply:GetNWString( "RPName" ) .. " smiles. ", ply:EyePos(), 190 , ply);
	end                                                           
	
	if( args != "") then
		RangeChat( "[Emote]" .. ply:GetNWString( "RPName" ) .. " smiles, and then says ''" .. args .. "''", ply:EyePos(), 190 , ply);
	end                                                                                        
	return "";
end
 AddChatCommand( ":)", Smile );
AddChatCommand( "=d", Smile );
AddChatCommand( ":d", Smile );
AddChatCommand( ": )", Smile );
AddChatCommand( "=)", Smile );
AddChatCommand( "=]", Smile );
AddChatCommand( ":-)", Smile );
AddChatCommand( ":o)", Smile );
AddChatCommand( "=o)", Smile );
AddChatCommand( "=od", Smile );
AddChatCommand( ":-d", Smile);
AddChatCommand( "=-)", Smile);
AddChatCommand( "=o]", Smile);
AddChatCommand( "=-]", Smile);
AddChatCommand( "= d", Smile);
AddChatCommand( ": d", Smile);

/*---------------------------------------------------------
  Winking
---------------------------------------------------------*/
function Wink( ply, args )
	if( args == "") then
		RangeChat( "[Emote]" .. ply:GetNWString( "RPName" ) .. " winks. ", ply:EyePos(), 190 , ply);
	end                                                          
	if( args != "") then
		RangeChat( "[Emote]" .. ply:GetNWString( "RPName" ) .. " winks, and then says ''" .. args .. "''", ply:EyePos(), 190 , ply);
	end                                                                                       
	return "";
end
AddChatCommand( ";)", Wink );
AddChatCommand( "; )", Wink );
AddChatCommand( ";-)", Wink );
AddChatCommand( ";o)", Wink);
AddChatCommand( "; ]", Wink);
AddChatCommand( ";-]", Wink);
AddChatCommand( ";o]", Wink);

/*---------------------------------------------------------
  Frowning
---------------------------------------------------------*/
function Frown( ply, args )
	if( args == "") then
		RangeChat( "[Emote]" .. ply:GetNWString( "RPName" ) .. " frowns. ", ply:EyePos(), 190 , ply);
	end                                                           
	if( args != "") then
		RangeChat( "[Emote]" .. ply:GetNWString( "RPName" ) .. " frowns, and then says ''" .. args .. "''", ply:EyePos(), 190 , ply);
	end                                                                                        
	return "";
end
AddChatCommand( ":(", Frown );
AddChatCommand( "=(", Frown );
AddChatCommand( ":-(", Frown );
AddChatCommand( ": (", Frown );
AddChatCommand( ":o(", Frown );
AddChatCommand( "=o(", Frown );
AddChatCommand( "= [", Frown );
AddChatCommand( "=-[", Frown );
AddChatCommand( "=o[", Frown );

/*---------------------------------------------------------
  Crying
---------------------------------------------------------*/
function Cry( ply, args )
	if( args == "") then
		RangeChat( "[Emote]" .. ply:GetNWString( "RPName" ) .. " cries. ", ply:EyePos(), 190 , ply);
	end                                                          
	if( args != "") then
		RangeChat( "[Emote]" .. ply:GetNWString( "RPName" ) .. " cries, and then says ''" .. args .. "''", ply:EyePos(), 190 , ply);
	end                                                                                       
	return "";
end
AddChatCommand( ":*(", Cry );
AddChatCommand( "=*(", Cry );
AddChatCommand( "=-*(", Cry );
AddChatCommand( ":-*(", Cry );

/*---------------------------------------------------------
 Set Job title!
---------------------------------------------------------*/
function SetPlayerJob( ply, args )
	if( args != "") then
		ply:SetNWString("jobtitle", args)
	end                                                                                       
	return "";
end
AddChatCommand( "/title", SetPlayerJob );

/*---------------------------------------------------------
 Set Job title!
---------------------------------------------------------*/
function SetName( ply, args )
	if( args != "") then
	
				GlobalConsoleMessage(ply:GetNWString("RPName") .. " changed name to " .. args)
		ply:SetNWString("RPNewName", tostring(args))
		SaveInfo(ply);
		
	end                                                                                       
	return "";
end
--AddChatCommand( "/name", SetName );

/*---------------------------------------------------------
  LaughOutLoud
---------------------------------------------------------*/
function LaughOutLoud( ply, args )
	if( args == "") then
		RangeChat( "[Emote]" .. ply:GetNWString( "RPName" ) .. " laughs. ", ply:EyePos(), 190 , ply);
	end                                                          
	if( args != "") then
		RangeChat( "[Emote]" .. ply:GetNWString( "RPName" ) .. " laughs, and then says ''" .. args .. "''", ply:EyePos(), 190 , ply);
	end                                                                                       
	return "";
end
AddChatCommand( "lol", LaughOutLoud );

/*---------------------------------------------------------
  Evilness
---------------------------------------------------------*/
function Evil( ply, args )
	if( args == "") then
		RangeChat( "[Emote]" .. ply:GetNWString( "RPName" ) .. " smiles evily. ", ply:EyePos(), 190 , ply);
	end                                                                
	if( args != "") then
		RangeChat( "[Emote]" .. ply:GetNWString( "RPName" ) .. " smiles evily, and then says ''" .. args .. "''", ply:EyePos(), 190 , ply);
	end                                                                                             
	return "";
end
AddChatCommand( ">: )", Evil );
AddChatCommand( ">:)", Evil );
AddChatCommand( ">:-)", Evil);
AddChatCommand( ">:D", Evil);
AddChatCommand( ">: D", Evil);

/*---------------------------------------------------------
  Out of Character
---------------------------------------------------------*/
function OOC( ply, args )
	return "(" .. ply:GetNWString( "RPName" ) .. ")[OOC] " .. args;
end
AddChatCommand( "//", OOC, true );
AddChatCommand( "/a ", OOC, true );
AddChatCommand( "/ooc", OOC, true );

/*---------------------------------------------------------
  Flags
---------------------------------------------------------*/
function GoScanner( ply )
	if(ply:GetNWInt("setflag") != 2) then
		if(ply:GetNWInt("allowscanner") == 1) then
			ply:Kill();
			ply:SetNWInt("setflag", 2)
		end
	end
	return ""
end
AddChatCommand( "/scanner", GoScanner );

function GoShieldScanner( ply )
	if(ply:GetNWInt("setflag") != 4) then
		if(ply:GetNWInt("allowshieldscanner") == 1) then
			ply:Kill();
			ply:SetNWInt("setflag", 4)
		end
	end
	return ""
end
AddChatCommand( "/shieldscanner", GoShieldScanner );

function GoCitizen( ply )
	if(ply:GetNWInt("setflag") != 1) then
		ply:Kill();
		ply:SetNWInt("setflag", 1)
	end
	return ""
end
AddChatCommand( "/citizen", GoCitizen );

function GoVort( ply )		
	if(ply:GetNWInt("setflag") != 3) then
		if(ply:GetNWInt("allowvort") == 1) then
			ply:Kill();
			ply:SetNWInt("setflag", 3)
		end
	end
	return ""
end
AddChatCommand( "/vort", GoVort );

function GoCustom( ply )		
	if(tonumber(ply:GetNWInt("customsetflag")) != 0 ) then
		if(tonumber(ply:GetNWInt("setflag")) != tonumber(ply:GetNWInt( "customsetflag" ))) then
				ply:Kill();
				ply:SetNWInt("setflag", tonumber(ply:GetNWInt( "customsetflag" )))
		end        
	end                  
		return ""
end
AddChatCommand( "/custom", GoCustom );



function ChatHeadBob( ply )	
 ply:ConCommand("rp_headbob") 	
 return ""
end
AddChatCommand( "!bob", ChatHeadBob );



function ChatSlap( ply, args )	
 ply:ConCommand("rp_slap "..args) 	
 return ""
end
AddChatCommand( "!slap", ChatSlap );












