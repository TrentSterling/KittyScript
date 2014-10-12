
CurTargetEnt = nil;
OldTargetEnt = nil;

TargetInfo = { }

TARGET_TYPE_PLAYER = 1;
TARGET_TYPE_ITEM = 2;
TARGET_TYPE_OWNABLENONDOOR = 3;
TARGET_TYPE_OWNABLEDOOR = 4;
TARGET_TYPE_USABLE = 5;

function TargetThink()

	local trace = { }
	trace.start = LocalPlayer():EyePos();
	trace.endpos = trace.start + LocalPlayer():GetAimVector() * 120;
	trace.filter = LocalPlayer();
	
	local tr = util.TraceLine( trace );

	if( tr.Entity:IsValid() ) then
	
		if( CurTargetEnt ~= OldTargetEnt or not CurTargetEnt ) then
		
			OldTargetEnt = CurTargetEnt;
			CurTargetEnt = tr.Entity;
		
			local newti = { }
			newti.Ent = CurTargetEnt;
			newti.LastLook = CurTime();
			newti.alpha = newti.alpha or 0;

			TargetInfo[CurTargetEnt:EntIndex()] = newti;
			
		end
		
		if( TargetInfo[CurTargetEnt:EntIndex()] ) then
		
			TargetInfo[CurTargetEnt:EntIndex()].LastLook = CurTime();
			TargetInfo[CurTargetEnt:EntIndex()].LastLookPos = tr.HitPos;
			
		end
	
	else
	
		OldTargetEnt = CurTargetEnt;
		CurTargetEnt = nil;		
	
	end
	
		--Deprecated shit.  Never use again.
	
		--[[
	
		local newfade = true;
	
		for k, v in pairs( TargetText ) do
			
			if( v.ent == tr.Entity ) then
				
				if( FadingObj[v.id] ) then
				
					FadingObj[v.id].color.a = FadingObj[v.id].fade;
					newfade = false;
						
						
				else

					for n, m in pairs( TargetText ) do
					
						if( m.ent == v.ent ) then
		
							FadingObj[m.id] = nil;
							TargetText[n] = nil;
							
						end
					
					end
					
					newfade = true;
					
				end
					
			end
			
		end
		
		if( newfade ) then
	
			CurTargetEnt = tr.Entity;
			local pos = tr.Entity:EyePos();
			pos.z = pos.z + 10;
			
			local str = "";
			local id = 0;
			local color = Color( 255, 255, 255, 255 );
			local aimpos = false;

			if( tr.Entity:IsPlayer() ) then
				str = tr.Entity:Nick() .. "\n" .. tr.Entity:GetNWString( "title" );
				pos.z = pos.z + 10;
			elseif( tr.Entity:IsWeapon() and not tr.Entity:IsNPC() ) then
				str = "[Use Key]";
				color = Color( 255, 255, 255, 128 );
				local scrpos = pos:ToScreen();
				table.insert( TargetText, { xoffset = -45, yoffset = -3, id = AddFadingRect( scrpos.x, scrpos.y, 89, 30, 4, Color( 60, 60, 60, 200 ), 1, 500, true ), ent = CurTargetEnt } );
			elseif( tr.Entity:IsVehicle() ) then
				if( tr.Entity:GetNWInt( "Owned" ) == 1 ) then
					str = "Owned";
				else
					str = "Not Owned\nPress F4 (gm_showspare2) to own";
					color = Color( 180, 20, 20, 200 );
				end
			elseif( tr.Entity:IsDoor() ) then
			
				if( tr.Entity:GetNWInt( "Owned" ) == 1 ) then
					str = tr.Entity:GetNWString( "doorname" );
				else
					local price = tr.Entity:GetNWFloat( "doorprice" );
					if( not tr.Entity:GetNWBool( "formatteddoor" ) or GetGlobalInt( "PropertyPaying" ) == 0 ) then
						price = 50;
					end
					str = tr.Entity:GetNWString( "buildingname" ) .. "\n" .. tr.Entity:GetNWString( "doorname" ) .. "\n" .. price .. " tokens needed to purchase";
					color = Color( 180, 20, 20, 200 );
				end			
				
				pos = tr.HitPos;
				aimpos = true;
			
			elseif( tr.Entity:IsItem() ) then
			
				if( not tr.Entity:IsPaper() ) then
					str = tr.Entity:GetItemName() .. "\nSize: " .. tr.Entity:GetItemSize() .. "\nTake with [Use Key]";
				else
					str = "Read with [Use Key]";
				end
				
			end
			
			local scrpos = pos:ToScreen();
			
			local id = AddFadingText( scrpos.x, scrpos.y, "TargetID", str, 1, color, 1, 500, true );
			table.insert( TargetText, { id = id, ent = CurTargetEnt, AimPos = pos, aimpos = aimpos } );
			
		end
		
	end
	
	for k, v in pairs( TargetText ) do
	
		local id = v.id;
		local ent = v.ent;
		
		if( FadingObj[id] and ent:IsValid() ) then
			local pos = ent:EyePos();
			pos.z = pos.z + 20;
			
			if( v.aimpos ) then
			
				pos = v.AimPos;
			
			end
			
			local scrpos = pos:ToScreen();
			FadingObj[id].x = scrpos.x + ( v.xoffset or 0 );
			FadingObj[id].y = scrpos.y + ( v.yoffset or 0 );
		else
		
			for n, m in pairs( TargetText ) do
			
				if( m.ent == ent ) then

					FadingObj[m.id] = nil;
					TargetText[n] = nil;
					
				end
			
			end

		end
	
	end
	
	]]--

end
hook.Add( "Think", "TargetThink", TargetThink );