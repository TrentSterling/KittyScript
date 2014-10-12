



local PANEL6={}
--function PANEL6:DoClick()
	--LocalPlayer():ConCommand("cl_playermodel "..self.Name)
--end
vgui.Register( "ModelButton", PANEL6, "SpawnIcon" )

local PANEL3={}

function PANEL3:Init()
		self:SetSize( ScrW()/3, ScrH()/3+15 );
		
		self:SetPos( ScrW()/3, ScrH()/3 );
		
		
		
		
	self.Title = vgui.Create("Label", self)
	self.Title:SetText("Character Selection")
		
	self.Title:SetPos(3, 4)
		
		
	self.Title:SetFont("ChatFont")
	self.Title:SetFGColor(Color(255, 255, 255, 255)) 	
		
	self.Title:SizeToContents()
		
		
		
	local spawnicon = vgui.Create( "ModelButton", self )
	x = 8
	y = 8+15
	
	ply = LocalPlayer()
		spawnicon:SetModel(ply:GetNWString( "citizenmodel" ));
		spawnicon:SetPos( x, y );
		spawnicon:SetSize( 64, 64 );
	
end

function PANEL3:Paint()

	draw.RoundedBox(4, 3, 3, ScrW()/3-6, ScrH()/3-6+15, Color(15, 15, 15, 150))
	draw.RoundedBox(4, 3, 3+2, ScrW()/3-6, ScrH()/3-6+13, Color(15, 15, 15, 150))
	draw.RoundedBox(4, 3, 3+15, ScrW()/3-6, ScrH()/3-6, Color(15, 15, 15, 150))
	draw.RoundedBox(4, 5, 5+15, ScrW()/3-10, ScrH()/3-10, Color(75, 75, 75, 150))
end

vgui.Register("CharacterWindow", PANEL3, "PANEL")

-- model select button 





function testpanel3()
CHARWINDOW=vgui.Create( "CharacterWindow" )
CHARWINDOW:SetVisible( true )
end

concommand.Add("menutest3", testpanel3) -- adding the console command (allows players to bind)





