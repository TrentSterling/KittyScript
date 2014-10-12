
team.SetUp(1, "Citizens", Color(200, 150, 0, 255))
team.SetUp(2, "Combine", Color(0, 0, 200, 225))
team.SetUp(3, "Vortigaunts", Color(0, 200, 0, 255))
team.SetUp(4, "Shield Scanners", Color(0, 0, 200, 255))
team.SetUp(5, "Earth", Color(0, 255, 0, 255))
team.SetUp(6, "Dragon", Color(0, 0, 0, 255))

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
	
	//Create the menu
	local MainMenu = DermaMenu() -- create a derma menu
	MainMenu:SetPos(gui.MousePos()) --put it wherever the cursor is at the time
	MainMenu:AddOption("Prop 'Q' menu", function() player:ConCommand("rp_toggleqmenu")  gui.EnableScreenClicker(false) clicker=false end )--Always have the Q Menu
	
		//Add the -MainMenu:Self- SubMenu
		local PlayerSelfMenu = MainMenu:AddSubMenu( "Self" )
		PlayerSelfMenu:AddOption("Character Selection", function() player:ConCommand("menutest2") gui.EnableScreenClicker(false) clicker=false end )
		PlayerSelfMenu:AddSpacer()
		PlayerSelfMenu:AddOption("Name: " .. player:GetNWString( "RPName" ), function() gui.EnableScreenClicker(false) clicker=false end )
		PlayerSelfMenu:AddOption("Title: " .. player:GetNWString( "jobtitle" ), function() gui.EnableScreenClicker(false) clicker=false end )
		PlayerSelfMenu:AddSpacer()
		PlayerSelfMenu:AddOption("Prop menu", function() player:ConCommand("rp_toggleqmenu")  gui.EnableScreenClicker(false) clicker=false end )
		PlayerSelfMenu:AddSpacer()

			//Add the -Self:Options- SubMenu
				local PlayerSelfMenuOptions = PlayerSelfMenu:AddSubMenu( "Options" )
				PlayerSelfMenuOptions:AddOption( "Toggle Headbob", function() player:ConCommand("rp_headbob") gui.EnableScreenClicker(false) clicker=false end )
				PlayerSelfMenuOptions:AddSpacer()

			//Add the -Self:Flags- SubMenu
				local PlayerSelfMenuFlags = PlayerSelfMenu:AddSubMenu( "Flags" )
				PlayerSelfMenuFlags:AddOption( "Citizen", function() player:ConCommand("say /Citizen") gui.EnableScreenClicker(false) clicker=false end )
				if(player:GetNWInt("allowscanner") == 1) then
					PlayerSelfMenuFlags:AddOption( "City Scanner", function() player:ConCommand("say /scanner") gui.EnableScreenClicker(false) clicker=false end )
				end
				if(player:GetNWInt("allowshieldscanner") == 1) then
					PlayerSelfMenuFlags:AddOption( "Shield Scanner", function() player:ConCommand("say /shieldscanner") gui.EnableScreenClicker(false) clicker=false end )
				end
				if(player:GetNWInt("allowvort") == 1) then
					PlayerSelfMenuFlags:AddOption( "Vortigaunt", function() player:ConCommand("say /vort") gui.EnableScreenClicker(false) clicker=false end )
				end
				if(player:GetNWInt("customsetflag") > 0) then
					PlayerSelfMenuFlags:AddOption( "Custom Model", function() player:ConCommand("say /custom") gui.EnableScreenClicker(false) clicker=false end )
				end

			//Add the -Self:Admin- SubMenu
				if( tonumber(player:GetNWInt( "adminlevel" )) > 1 ) then
					MainMenu:AddSpacer()
					local PlayerSelfMenuAdmin = PlayerSelfMenu:AddSubMenu( "Admin" )
					PlayerSelfMenuAdmin:AddOption( "Drop ration!", function() player:ConCommand("rp_dropration") gui.EnableScreenClicker(false) clicker=false end )
					PlayerSelfMenuAdmin:AddOption( "See all players", function() player:ConCommand("rp_seeall") gui.EnableScreenClicker(false) clicker=false end )
					PlayerSelfMenuAdmin:AddOption( "Enable NoClip", function() player:ConCommand("rp_spec") gui.EnableScreenClicker(false) clicker=false end )
					PlayerSelfMenuAdmin:AddOption( "Disable NoClip", function() player:ConCommand("rp_unspec") gui.EnableScreenClicker(false) clicker=false end )
				end


	
	if trace.HitNonWorld then
		target = trace.Entity --Store the entity it hit
	end
	
	
		
	if !trace.HitNonWorld then
		target = NULL --Store the entity it hit
	end
	
	
if( target == NULL ) then return end
	if (target) then--If I hit an entity
if( target == NULL ) then return end
		local class = target:GetClass();--Get the entity's class
		
			if( class == "player" ) then --If the class is a player...
				if( player:GetPos():Distance( target:GetPos() ) < 100 ) then

					//Add the -MainMenu:Player- SubMenu
					local PlayerMenu = MainMenu:AddSubMenu( "Player" )
					PlayerMenu:AddOption("Name: " .. target:GetNWString( "RPName" ), function() gui.EnableScreenClicker(false) clicker=false end )
					PlayerMenu:AddOption("Title: " .. target:GetNWString( "jobtitle" ), function() gui.EnableScreenClicker(false) clicker=false end )
					PlayerMenu:AddSpacer()
					
					//Add the -Player:Functions- SubMenu
					local PlayerMenuFunct = PlayerMenu:AddSubMenu( "Functions" )
					PlayerMenuFunct:AddOption( "Punch", function() player:ConCommand("say /me attempts to punch " .. target:GetNWString( "RPName" ) .. ".") gui.EnableScreenClicker(false) clicker=false end )
					PlayerMenuFunct:AddOption( "Stick Tounge Out", function() player:ConCommand("say /me sticks their tounge out at " .. target:GetNWString( "RPName" ) .. ".") gui.EnableScreenClicker(false) clicker=false end )
					PlayerMenuFunct:AddOption( "Pokes", function() player:ConCommand("say /me pokes " .. target:GetNWString( "RPName" ) .. ".") gui.EnableScreenClicker(false) clicker=false end )
					
					//Add the -Player:Admin- SubMenu
					local PlayerMenuAdmin = PlayerMenu:AddSubMenu( "Admin" )
					PlayerMenuAdmin:AddOption( "View stickynote", function() player:ConCommand("rp_gnote " ..  "\"" .. target:SteamID().."\"") gui.EnableScreenClicker(false) clicker=false end )
					PlayerMenuAdmin:AddOption( "Kick player", function() gui.EnableScreenClicker(false) clicker=false end )
					PlayerMenuAdmin:AddOption( "Ban player", function() gui.EnableScreenClicker(false) clicker=false end )
					PlayerMenuAdmin:AddOption( "Explode player", function() player:ConCommand("rp_explode " .. "\"" .. target:SteamID().."\"") gui.EnableScreenClicker(false) clicker=false end )
					
					//Add the -PlayerMenuAdmin:Flags- SubMenu
					local PlayerMenuAdminFlags = PlayerMenuAdmin:AddSubMenu( "Flags" )
					PlayerMenuAdminFlags:AddOption( "Rebels", function() gui.EnableScreenClicker(false) clicker=false end )
					PlayerMenuAdminFlags:AddOption( "Allow Rebel", function() gui.EnableScreenClicker(false) clicker=false end )
					PlayerMenuAdminFlags:AddSpacer()
					PlayerMenuAdminFlags:AddOption( "Vortigaunts", function() gui.EnableScreenClicker(false) clicker=false end )
					PlayerMenuAdminFlags:AddOption( "Allow Vortigaunt", function() player:ConCommand("rp_allowvort " ..  "\"" .. target:SteamID().."\"") gui.EnableScreenClicker(false) clicker=false end )
					PlayerMenuAdminFlags:AddSpacer()
					PlayerMenuAdminFlags:AddOption( "Civil Protection", function() gui.EnableScreenClicker(false) clicker=false end )
					PlayerMenuAdminFlags:AddOption( "Allow Scanner", function() player:ConCommand("rp_allowscanner " ..  "\"" .. target:Nick().."\"") gui.EnableScreenClicker(false) clicker=false end )
					PlayerMenuAdminFlags:AddOption( "Allow Shield Scanner", function() player:ConCommand("rp_allowshieldscanner " ..  "\"" .. target:SteamID().."\"") gui.EnableScreenClicker(false) clicker=false end )
				end
			end
			
			if( class == "prop_door_rotating" ) then  --If the class is a door...
				if( player:GetPos():Distance( target:GetPos() ) < 100 ) then
				
					//Add the -MainMenu:Door- SubMenu
					local DoorMenu = MainMenu:AddSubMenu( "Door" )
					DoorMenu:AddOption("Door Menu", function() gui.EnableScreenClicker(false) clicker=false end )
					DoorMenu:AddSpacer()
					DoorMenu:AddOption(target:GetNWString("buildingname"), function() gui.EnableScreenClicker(false) clicker=false end )
					DoorMenu:AddOption(target:GetNWString("doorname"), function() gui.EnableScreenClicker(false) clicker=false end )
					
local DOORNAME = GetGlobalFloat( "door" .. target:EntIndex() )
					DoorMenu:AddSpacer()
					DoorMenu:AddSpacer()
					DoorMenu:AddOption(DOORNAME, function() gui.EnableScreenClicker(false) clicker=false end )
					DoorMenu:AddSpacer()
					DoorMenu:AddSpacer()
					
					DoorMenu:AddOption(target:GetNWFloat("doorprice") .. " credits", function() gui.EnableScreenClicker(false) clicker=false end )
					DoorMenu:AddSpacer()
					
					//Add the -Door:Skins- SubMenu
					local DoorMenuSkins = DoorMenu:AddSubMenu( "Skins" )
					DoorMenuSkins:AddOption( "Skin 1", function() player:ConCommand("rp_dskin 1") gui.EnableScreenClicker(false) clicker=false end )
					DoorMenuSkins:AddOption( "Skin 2", function() player:ConCommand("rp_dskin 2") gui.EnableScreenClicker(false) clicker=false end )
					DoorMenuSkins:AddOption( "Skin 3", function() player:ConCommand("rp_dskin 3") gui.EnableScreenClicker(false) clicker=false end )
					DoorMenuSkins:AddOption( "Skin 4", function() player:ConCommand("rp_dskin 4") gui.EnableScreenClicker(false) clicker=false end )
					DoorMenuSkins:AddOption( "Skin 5", function() player:ConCommand("rp_dskin 5") gui.EnableScreenClicker(false) clicker=false end )
					DoorMenuSkins:AddOption( "Skin 6", function() player:ConCommand("rp_dskin 6") gui.EnableScreenClicker(false) clicker=false end )
					DoorMenuSkins:AddOption( "Skin 7", function() player:ConCommand("rp_dskin 7") gui.EnableScreenClicker(false) clicker=false end )
					DoorMenuSkins:AddOption( "Skin 8", function() player:ConCommand("rp_dskin 8") gui.EnableScreenClicker(false) clicker=false end )
					DoorMenuSkins:AddOption( "Skin 9", function() player:ConCommand("rp_dskin 9") gui.EnableScreenClicker(false) clicker=false end )
					DoorMenuSkins:AddOption( "Skin 10", function() player:ConCommand("rp_dskin 10") gui.EnableScreenClicker(false) clicker=false end )
					DoorMenuSkins:AddOption( "Skin 11", function() player:ConCommand("rp_dskin 11") gui.EnableScreenClicker(false) clicker=false end )
					DoorMenuSkins:AddOption( "Skin 12", function() player:ConCommand("rp_dskin 12") gui.EnableScreenClicker(false) clicker=false end )
					DoorMenuSkins:AddOption( "Skin 13", function() player:ConCommand("rp_dskin 13") gui.EnableScreenClicker(false) clicker=false end )
					DoorMenuSkins:AddOption( "Skin 14", function() player:ConCommand("rp_dskin 14") gui.EnableScreenClicker(false) clicker=false end )
					DoorMenuSkins:AddSpacer()
					DoorMenuSkins:AddOption("Get Skin", function() player:ConCommand("rp_gskin") gui.EnableScreenClicker(false) clicker=false end )
				end
			end
			
			if( string.sub(class, 1, 5) == "item_" ) then  --If the class is an item...
				if( player:GetPos():Distance( target:GetPos() ) < 100 ) then
					MainMenu:AddOption("Item Menu", function() gui.EnableScreenClicker(false) clicker=false end )
					MainMenu:AddSpacer()
					MainMenu:AddOption("Name: " .. target:GetItemName(), function() gui.EnableScreenClicker(false) clicker=false end )
					MainMenu:AddOption("Size: " .. target:GetItemSize(), function() gui.EnableScreenClicker(false) clicker=false end )
					MainMenu:AddOption("Pick Up", function() player:ConCommand("rp_pickupitem") gui.EnableScreenClicker(false) clicker=false end )
					MainMenu:AddSpacer()
					end
			end
			
			if( class == "prop_physics" ) then  --If the class is a prop...
				MainMenu:AddOption("Prop Menu", function() gui.EnableScreenClicker(false) clicker=false end )
				MainMenu:AddSpacer()
				MainMenu:AddOption("Spawned by: " .. target:GetNWString("propspawnby") .. " --" .. target:GetNWString("rppropspawnby") , function() gui.EnableScreenClicker(false) clicker=false end )
				MainMenu:AddSpacer()
				local submenu = MainMenu:AddSubMenu( "Admin" )
				submenu:AddOption( "Ban from propspawn", function() gui.EnableScreenClicker(false) clicker=false end )
				submenu:AddOption( "Kick player", function() player:ConCommand("rp_kick " .. "\"" .. target:GetNWString("SIDpropspawnby") .. "\"" .. " PROPSPAWN") gui.EnableScreenClicker(false) clicker=false end )
				submenu:AddOption( "Ban player", function() gui.EnableScreenClicker(false) clicker=false end )
			end
	end
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

concommand.Add("rp_menu", testpanel) -- adding the console command (allows players to bind)
hook.Add( "KeyPress", "KeyPress", EnableClicker )
hook.Add("GUIMousePressed", "GuiMousePressed", GUIMousePressed)
