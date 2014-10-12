
--Format a door entity (has to do with properties, etc..)
function FormatDoorEntity( x, y, z, buildingname, name, parent, state, price )

				GlobalConsoleMessage("Door format start!")
	local ents = ents.FindInBox( Vector( x, y, z ), Vector( x, y, z ) );
	
	for k, v in pairs( ents ) do
	
		
			local door = v;
			
			door:SetNWString( "buildingname", buildingname );
				GlobalConsoleMessage("Door set to " .. buildingname)
			door:SetNWString( "doorname", name );
				GlobalConsoleMessage("Door set to " .. name)
			door:SetNWString( "doorparent", parent );
			door:SetNWInt( "doorstate", state );
			door:SetNWFloat( "doorprice", price );
			door:SetNWBool( "formatteddoor", true );
			
				GlobalConsoleMessage("Door formatted!")
			if( state == 1 or state == 2 or state == 3 ) then
				door:Fire( "lock", "", 0 );
				
				GlobalConsoleMessage("Combine door locked!!!!")
			end
			
			door:GetTable().OrigName = name;
		
			table.insert( DoorGroups[buildingname], door );
		
	
	end
	
end

--Loads map's property info
function CreateDoorInfo()

		Msg( "PARSINGDOORS------------------------------------------------------\n" );
				GlobalConsoleMessage("Doors loading...!")
	local arg = GetArgumentLists( file.Read( "KittyScript/mapdata/" .. game.GetMap() .. ".txt" ) );
	
	if( not arg ) then return; end
	
				GlobalConsoleMessage("Map found!")
	DoorGroups = { }

	for k, v in pairs( arg ) do
	
		if( v[1] == "BEGINBUILDING" ) then
		
				GlobalConsoleMessage("Building began!-----------------------------------------")
			local buildingname = v[2] or " ";
			k = k + 1;

			if( not DoorGroups[buildingname] ) then
				DoorGroups[buildingname] = { }
			end
			
			while( arg[k][1] ~= "ENDBUILDING" ) do
			
				local x = tonumber( arg[k][1] );
				local y = tonumber( arg[k][2] );
				local z = tonumber( arg[k][3] );
				local doorname = arg[k][4];
				local parent = arg[k][5];
				local doorstate = tonumber( arg[k][6] );
				local doorprice = tonumber( arg[k][7] );
				
				FormatDoorEntity( x, y, z, buildingname, doorname, parent, doorstate, doorprice );
				k = k + 1;
			
			end
			
		end
	
	end
		Msg( "ENDDOORS------------------------------------------------------\n" );
	
end