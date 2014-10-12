
function GM:PlayerBindPress( ply, bind, down )
	if( bind == "+menu" ) then
		if ( ply:GetNWInt("menu") == 1 ) then
			ply:ConCommand("rp_toggleqmenu") 
		return false
		end
		if ( ply:GetNWInt("menu") == 0 ) then
		ply:ConCommand("rp_menu") 
		return true
		end
	end	

	if( bind == "gm_showspare2" ) then
		ply:ConCommand("rp_toggleqmenu") 
	end
	
	if( bind == "+use" ) then
		ply:ConCommand("rp_pickupitem") --Change this to a total use command, that uses items, and opens combine doors, instead of using the trace below.
		return false;
	end
	
	if( bind == "+jump" ) then
		--ply:ConCommand("rp_jump") --Change this to a total use command, that uses items, and opens combine doors, instead of using the trace below.
		return false;--If false, it acts like true...sorta.
	end
	
	
	
	
end



function GM:Think()


local SecondsLeft = GetGlobalFloat( "door853" )
	



	local list = file.FindInLua( "KittyScript/gamemode/items/*.lua" );

		
			
for t, s in pairs( list ) do		
	UniqueID = string.gsub( s, ".lua", "" );
			local InventoryGet = LocalPlayer():GetNWInt( UniqueID .. "_inv")
			
		--Msg( UniqueID .. " " .. InventoryGet .. "\n\n" );
	end
		
		
end
















