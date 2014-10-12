----------------------------
-- KittyScript January 15, 2008)
-- by John [MT]OMalley Dorian
--
-- First beta - March 25, 2008
-- 
--Save the player's shit!
----------------------------

include( 'parse.lua' )
CivModels = {
--Males
	"models/Humans/Group01/Male_01.mdl",
	"models/Humans/Group01/male_02.mdl",
	"models/Humans/Group01/male_03.mdl",
	"models/Humans/Group01/Male_04.mdl",
	"models/Humans/Group01/Male_05.mdl",
	"models/Humans/Group01/male_06.mdl",
	"models/Humans/Group01/male_07.mdl",
	"models/Humans/Group01/male_08.mdl",
	"models/Humans/Group01/male_09.mdl",
	"models/Humans/Group02/Male_01.mdl",
	"models/Humans/Group02/male_02.mdl",
	"models/Humans/Group02/male_03.mdl",
	"models/Humans/Group02/Male_04.mdl",
	"models/Humans/Group02/Male_05.mdl",
	"models/Humans/Group02/male_06.mdl",
	"models/Humans/Group02/male_07.mdl",
	"models/Humans/Group02/male_08.mdl",
	"models/Humans/Group02/male_09.mdl",
--Females
	"models/Humans/Group01/Female_01.mdl",
	"models/Humans/Group01/Female_02.mdl",
	"models/Humans/Group01/Female_03.mdl",
	"models/Humans/Group01/Female_04.mdl",
	"models/Humans/Group01/Female_06.mdl",
	"models/Humans/Group01/Female_07.mdl",
	"models/Humans/Group02/Female_01.mdl",
	"models/Humans/Group02/Female_02.mdl",
	"models/Humans/Group02/Female_03.mdl",
	"models/Humans/Group02/Female_04.mdl",
	"models/Humans/Group02/Female_06.mdl",
	"models/Humans/Group02/Female_07.mdl"
}

function CharCreate(player)
		player:GetTable().PlayerModel = CivModels[math.random( 1, #CivModels )];--Set a model to a random civilian until player select is finished.
	player:SetNWString("citizenmodel", player:GetTable().PlayerModel)
	player:SetNWInt("money", 5000)
	player:SetNWInt("customsetflag", 0)
	--Allow flags set to 0
	player:SetNWInt("allowscanner", 0)
	player:SetNWInt("allowshieldscanner", 0)
	player:SetNWInt("allowvort", 0)
	player:SetNWString("jobtitle", "Citizen")
	player:SetNWString("RPName", "Mike Jones")
	player:SetNWInt("adminlevel", 0)
	--Set citizen flag
	player:SetNWInt("setflag", 1)
	LoadInfo(player)
	SaveInfo(player)
end

function FormatSteamID(player)
	local id = player:SteamID();
	if( not id ) then return "UNKNOWN"; end
	id = string.gsub( id, ":", "" );
	id = string.gsub( id, "_", "" );
	id = string.gsub( id, "STEAM", "" );
	return id;
end

function ExtractCertainSaveInfo( player )
	local dir = "KittyScript/playerdata/" .. FormatSteamID(player) .. ".txt";
	local str = file.Read( dir ) or "";
	local pos1 = string.find( string.gsub( str, "-", "@" ), "START_CHARACTER \"" .. string.gsub( player:GetNWString( "RPName" ), "-", "@" ) .. "\"" );
	if( not pos1 ) then 
		player:PrintMessage( HUD_PRINTTALK, "Player Information or nickname was not found" ) --And how lucky they are to be here!
		return str; 
	end
	local pos2 = string.find( string.gsub( str, "-", "@" ), "END_CHARACTER", pos1 );
	local info = "";
	info = string.sub( str, 1, pos1 - 1 ) .. string.sub( str, pos2 + 14 );
	return info;
end

function SaveInfo(player)
	local dir = "KittyScript/playerdata/" .. FormatSteamID(player) .. ".txt";
	if( not file.Exists( dir ) ) then

		file.Write( dir, "" );
	end
	local oldinfo = ExtractCertainSaveInfo( player );
	local saveinfo = { }
	//Save this shit
	saveinfo["MODEL"] = player:GetNWString( "citizenmodel" );
	saveinfo["MONEY"] = player:GetNWInt( "money" );
	saveinfo["CUSTOMFLAG"] = player:GetNWInt( "customsetflag" );
	saveinfo["HEADBOB"] = player:GetNWInt( "togglebob" );
	saveinfo["SCANNER"] = player:GetNWString( "allowscanner" );
	saveinfo["SHIELDSCANNER"] = player:GetNWInt( "allowshieldscanner" );
	saveinfo["VORT"] = player:GetNWInt( "allowvort" );
	//End of shit
	local savestr = "START_CHARACTER \"" .. string.gsub( player:GetNWString( "RPName" ), "\"", "'" ) .. "\"\n";
	for k, v in pairs( saveinfo ) do
		savestr = savestr .. k .. " \"" .. string.gsub( v, "\"", "'" ) .. "\"\n";
	end
	savestr = savestr .. "END_CHARACTER\n";
	file.Write( dir , oldinfo .. savestr )
	player:SendMessage("Saving Info!",3,Color(0,0,255,255))
end
concommand.Add( "rp_save", SaveInfo );

function ExtractRawSaveInfo( player )
	local dir = "KittyScript/playerdata/" .. FormatSteamID(player) .. ".txt";
		player:PrintMessage( HUD_PRINTTALK, "SaveName " .. dir ) --And how lucky they are to be here!
	local str = file.Read( dir ) or "";
	local pos1 = string.find( string.gsub( str, "-", "@" ), "START_CHARACTER \"" .. string.gsub( player:GetNWString( "RPName" ), "-", "@" ) .. "\"" );
		player:PrintMessage( HUD_PRINTTALK, "PlayerName " ..  player:GetNWString( "RPName" ) ) --And how lucky they are to be here!
		player:PrintMessage( HUD_PRINTTALK, "PlayerNameFORMATTED " ..  string.gsub( player:GetNWString( "RPName" ), "-", "@" ) ) --And how lucky they are to be here!
	if( not pos1 ) then 
		player:PrintMessage( HUD_PRINTTALK, "Player Information or nickname was not found" ) --And how lucky they are to be here!
	return ""; 
	end
	local pos2 = string.find( string.gsub( str, "-", "@" ), "END_CHARACTER", pos1 );
	local info = "";
	info = string.sub( str, pos1, pos2 + 12 );
	return info;
end

function LoadInfo(ply)
	data = ExtractRawSaveInfo( ply );
	LoadInfoFromData( ply , data );
end
concommand.Add( "rp_load", LoadInfo );

function LoadInfoFromData( player , data )
	local args = GetArgumentLists( data );
	for _, v in pairs( args ) do
		local cmd = v[1];
		if( cmd == "MODEL" ) then
			player:SetNWString("citizenmodel",  v[2])
		elseif( cmd == "MONEY" ) then
			player:SetNWInt("money", tonumber( v[2] ) );
		elseif( cmd == "CUSTOMFLAG" ) then
			player:SetNWInt("customsetflag", tonumber(v[2]))
		elseif( cmd == "SCANNER" ) then      
			player:SetNWInt("allowscanner", tonumber(v[2]))
		elseif( cmd == "HEADBOB" ) then      
			player:SetNWInt("togglebob", tonumber(v[2]))
		elseif( cmd == "SHIELDSCANNER" ) then
			player:SetNWInt("allowshieldscanner", tonumber(v[2]))
		elseif( cmd == "VORT" ) then             
			player:SetNWInt("allowvort", tonumber(v[2]))
		elseif( cmd == "END_CHARACTER" ) then
			break;
		end
	end
end
