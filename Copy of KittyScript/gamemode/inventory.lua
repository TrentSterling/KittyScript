	local list = file.FindInLua( "KittyScript/gamemode/items/*.lua" );
			
for t, s in pairs( list ) do		
	UniqueID = string.gsub( s, ".lua", "" );
			player:GetNWInt( UniqueID .. "_inv")
	end
		