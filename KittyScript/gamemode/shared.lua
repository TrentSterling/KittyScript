

function testpanel()
	gui.EnableScreenClicker(true)
	clicker = true
	--// Trace Stuff ////////////////////
	local player = LocalPlayer()
	local pos = player:GetShootPos()
	local ang = gui.ScreenToVector( gui.MousePos() )
	local tracedata = {}
	tracedata.start = pos
	tracedata.endpos = pos+(ang*1000)
	tracedata.filter = player
	local trace = util.TraceLine(tracedata)

	if !trace.HitNonWorld then
		local menu123 = DermaMenu() -- create a derma menu
		menu123:SetPos(gui.MousePos()) --put it wherever the cursor is at the time
		--menu123:AddOption("TESTING THIS YOU HOEBAG", function() player:ConCommand("rp_teleport") gui.EnableScreenClicker(false) clicker=false end )
		--menu123:AddOption("TESTING THIS YOU HOEBAG", function() player:ConCommand("rp_teleport") gui.EnableScreenClicker(false) clicker=false end )
		menu123:AddOption("Character Selection", function() player:ConCommand("menutest2") gui.EnableScreenClicker(false) clicker=false end )
		menu123:AddSpacer()
		menu123:AddOption("Name: " .. player:GetNWString( "RPName" ), function() gui.EnableScreenClicker(false) clicker=false end )
		menu123:AddOption("Title: " .. player:GetNWString( "jobtitle" ), function() gui.EnableScreenClicker(false) clicker=false end )
		menu123:AddSpacer()
			local submenu = menu123:AddSubMenu( "Functions" )
			submenu:AddOption( "Sit down", function() player:ConCommand("say /me sits down.") gui.EnableScreenClicker(false) clicker=false end )
			
			
			
			
			
		menu123:AddSpacer()
			local flagsubmenu = menu123:AddSubMenu( "Flags" )
			
			flagsubmenu:AddOption( "Citizen", function() player:ConCommand("say /Citizen") gui.EnableScreenClicker(false) clicker=false end )
			
			if(player:GetNWInt("allowscanner") == 1) then
			flagsubmenu:AddOption( "City Scanner", function() player:ConCommand("say /scanner") gui.EnableScreenClicker(false) clicker=false end )
			end
			if(player:GetNWInt("allowshieldscanner") == 1) then
			flagsubmenu:AddOption( "Shield Scanner", function() player:ConCommand("say /shieldscanner") gui.EnableScreenClicker(false) clicker=false end )
			end
			if(player:GetNWInt("allowvort") == 1) then
			flagsubmenu:AddOption( "Vortigaunt", function() player:ConCommand("say /vort") gui.EnableScreenClicker(false) clicker=false end )
			end
			if(player:GetNWInt("customsetflag") > 0) then
			flagsubmenu:AddOption( "Custom Model", function() player:ConCommand("say /custom") gui.EnableScreenClicker(false) clicker=false end )
			end
			
			
			
			
			
	if( tonumber(player:GetNWInt( "adminlevel" )) > 1 ) then
		menu123:AddSpacer()
			local adminsubmenu = menu123:AddSubMenu( "Admin" )
			adminsubmenu:AddOption( "See all players", function() player:ConCommand("rp_seeall") gui.EnableScreenClicker(false) clicker=false end )
			adminsubmenu:AddOption( "Enable NoClip", function() player:ConCommand("rp_spec") gui.EnableScreenClicker(false) clicker=false end )
			adminsubmenu:AddOption( "Disable NoClip", function() player:ConCommand("rp_unspec") gui.EnableScreenClicker(false) clicker=false end )
			
 end
 
 
 
 
 
 
 
		return
	end
	
	if trace.HitNonWorld then
		target = trace.Entity --Store the entity it hit
	end
	
	if (target) then
		local class = target:GetClass();
			if( class == "player" ) then 
			--if( target:GetPos() ) then 
				if( player:GetPos():Distance( target:GetPos() ) < 100 ) then
					local menu123 = DermaMenu() -- create a derma menu
					menu123:SetPos(gui.MousePos()) --put it wherever the cursor is at the time
					--menu123:AddOption("TESTING THIS YOU HOEBAG", function() player:ConCommand("rp_teleport") gui.EnableScreenClicker(false) clicker=false end )
					--menu123:AddOption("TESTING THIS YOU HOEBAG", function() player:ConCommand("rp_teleport") gui.EnableScreenClicker(false) clicker=false end )
					menu123:AddOption("Player Menu", function() gui.EnableScreenClicker(false) clicker=false end )
					menu123:AddSpacer()
					menu123:AddOption("Name: " .. target:GetNWString( "RPName" ), function() gui.EnableScreenClicker(false) clicker=false end )
					menu123:AddOption("Title: " .. target:GetNWString( "jobtitle" ), function() gui.EnableScreenClicker(false) clicker=false end )
					menu123:AddSpacer()
					local submenu = menu123:AddSubMenu( "Functions" )
					submenu:AddOption( "Punch", function() player:ConCommand("say /me attempts to punch " .. target:GetNWString( "RPName" ) .. ".") gui.EnableScreenClicker(false) clicker=false end )
					submenu:AddOption( "Stick Tounge Out", function() player:ConCommand("say /me sticks their tounge out at " .. target:GetNWString( "RPName" ) .. ".") gui.EnableScreenClicker(false) clicker=false end )
					submenu:AddOption( "Pokes", function() player:ConCommand("say /me pokes " .. target:GetNWString( "RPName" ) .. ".") gui.EnableScreenClicker(false) clicker=false end )
					local adminsubmenu = menu123:AddSubMenu( "Admin" )
					adminsubmenu:AddOption( "Kick player", function() gui.EnableScreenClicker(false) clicker=false end )
					adminsubmenu:AddOption( "Ban player", function() gui.EnableScreenClicker(false) clicker=false end )
					adminsubmenu:AddOption( "Explode player", function() player:ConCommand("rp_explode " .. target:GetNWString( "RPName" )) gui.EnableScreenClicker(false) clicker=false end )
					local adminflagsubmenu = adminsubmenu:AddSubMenu( "Flags" )
					adminflagsubmenu:AddOption( "Rebels", function() gui.EnableScreenClicker(false) clicker=false end )
					adminflagsubmenu:AddOption( "Allow Rebel", function() gui.EnableScreenClicker(false) clicker=false end )
					adminflagsubmenu:AddSpacer()
					adminflagsubmenu:AddOption( "Vortigaunts", function() gui.EnableScreenClicker(false) clicker=false end )
					adminflagsubmenu:AddOption( "Allow Vortigaunt", function() player:ConCommand("rp_allowvort " .. target:GetNWString( "RPName" )) gui.EnableScreenClicker(false) clicker=false end )
					adminflagsubmenu:AddSpacer()
					adminflagsubmenu:AddOption( "Civil Protection", function() gui.EnableScreenClicker(false) clicker=false end )
					adminflagsubmenu:AddOption( "Allow Scanner", function() player:ConCommand("rp_allowscanner " .. target:GetNWString( "RPName" )) gui.EnableScreenClicker(false) clicker=false end )
					adminflagsubmenu:AddOption( "Allow Shield Scanner", function() player:ConCommand("rp_allowshieldscanner " .. target:GetNWString( "RPName" )) gui.EnableScreenClicker(false) clicker=false end )
				else
					player:PrintMessage( HUD_PRINTTALK, "You must move in closer!" )
				end
			end
			if( class == "prop_door_rotating" ) then 
				if( player:GetPos():Distance( target:GetPos() ) < 100 ) then
					local menu123 = DermaMenu() -- create a derma menu
					menu123:SetPos(gui.MousePos()) --put it wherever the cursor is at the time
					--menu123:AddOption("TESTING THIS YOU HOEBAG", function() player:ConCommand("rp_teleport") gui.EnableScreenClicker(false) clicker=false end )
					--menu123:AddOption("TESTING THIS YOU HOEBAG", function() player:ConCommand("rp_teleport") gui.EnableScreenClicker(false) clicker=false end )
					--menu123:AddOption(target:GetNWString( "jobtitle" ), function() player:ConCommand("rp_kill") gui.EnableScreenClicker(false) clicker=false end )
					menu123:AddOption("Door Menu", function() gui.EnableScreenClicker(false) clicker=false end )
					menu123:AddSpacer()
					menu123:AddOption("DOORTITLE", function() gui.EnableScreenClicker(false) clicker=false end )
					menu123:AddSpacer()
					local submenu = menu123:AddSubMenu( "Skins" )
					submenu:AddOption( "Skin 1", function() player:ConCommand("rp_dskin 1") gui.EnableScreenClicker(false) clicker=false end )
					submenu:AddOption( "Skin 2", function() player:ConCommand("rp_dskin 2") gui.EnableScreenClicker(false) clicker=false end )
					submenu:AddOption( "Skin 3", function() player:ConCommand("rp_dskin 3") gui.EnableScreenClicker(false) clicker=false end )
					submenu:AddOption( "Skin 4", function() player:ConCommand("rp_dskin 4") gui.EnableScreenClicker(false) clicker=false end )
					submenu:AddOption( "Skin 5", function() player:ConCommand("rp_dskin 5") gui.EnableScreenClicker(false) clicker=false end )
					submenu:AddOption( "Skin 6", function() player:ConCommand("rp_dskin 6") gui.EnableScreenClicker(false) clicker=false end )
					submenu:AddOption( "Skin 7", function() player:ConCommand("rp_dskin 7") gui.EnableScreenClicker(false) clicker=false end )
					submenu:AddOption( "Skin 8", function() player:ConCommand("rp_dskin 8") gui.EnableScreenClicker(false) clicker=false end )
					submenu:AddOption( "Skin 9", function() player:ConCommand("rp_dskin 9") gui.EnableScreenClicker(false) clicker=false end )
					submenu:AddOption( "Skin 10", function() player:ConCommand("rp_dskin 10") gui.EnableScreenClicker(false) clicker=false end )
					submenu:AddOption( "Skin 11", function() player:ConCommand("rp_dskin 11") gui.EnableScreenClicker(false) clicker=false end )
					submenu:AddOption( "Skin 12", function() player:ConCommand("rp_dskin 12") gui.EnableScreenClicker(false) clicker=false end )
					submenu:AddOption( "Skin 13", function() player:ConCommand("rp_dskin 13") gui.EnableScreenClicker(false) clicker=false end )
					submenu:AddOption( "Skin 14", function() player:ConCommand("rp_dskin 14") gui.EnableScreenClicker(false) clicker=false end )
					menu123:AddSpacer()
					menu123:AddOption("Get Skin", function() player:ConCommand("rp_gskin") gui.EnableScreenClicker(false) clicker=false end )
				else
					player:PrintMessage( HUD_PRINTTALK, "You must move in closer!" )
				end
			end
			if( class == "prop_physics" ) then 
				local menu123 = DermaMenu() -- create a derma menu
				menu123:SetPos(gui.MousePos()) --put it wherever the cursor is at the time
				--menu123:AddOption("TESTING THIS YOU HOEBAG", function() player:ConCommand("rp_teleport") gui.EnableScreenClicker(false) clicker=false end )
				--menu123:AddOption("TESTING THIS YOU HOEBAG", function() player:ConCommand("rp_teleport") gui.EnableScreenClicker(false) clicker=false end )
				--menu123:AddOption(target:GetNWString( "jobtitle" ), function() player:ConCommand("rp_kill") gui.EnableScreenClicker(false) clicker=false end )
				menu123:AddOption("Prop Menu", function() gui.EnableScreenClicker(false) clicker=false end )
				menu123:AddSpacer()
				menu123:AddOption("Whoever made this prop's name should be here!", function() gui.EnableScreenClicker(false) clicker=false end )
				menu123:AddSpacer()
				local submenu = menu123:AddSubMenu( "Admin" )
				submenu:AddOption( "Ban from propspawn", function() gui.EnableScreenClicker(false) clicker=false end )
				submenu:AddOption( "Kick player", function() gui.EnableScreenClicker(false) clicker=false end )
				submenu:AddOption( "Ban player", function() gui.EnableScreenClicker(false) clicker=false end )
			end
	end
	--/////////////////////////////////
end

function GUIMousePressed( btn )
	if SERVER then return end
	
	if (btn == MOUSE_LEFT) then --If you left click on nothing, the cursor disappears.
		gui.EnableScreenClicker(false)
		clicker = false
	elseif (btn == MOUSE_RIGHT) then --Right click and the menu pops up
		testpanel()
	end
end

--TO DO LIST:
-----Pick up/drop objects

concommand.Add("menutest", testpanel) -- adding the console command (allows players to bind)
hook.Add( "KeyPress", "KeyPress", EnableClicker )
hook.Add("GUIMousePressed", "GuiMousePressed", GUIMousePressed)


























