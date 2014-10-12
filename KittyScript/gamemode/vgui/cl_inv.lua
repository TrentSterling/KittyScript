


	local list = file.FindInLua( "KittyScript/gamemode/items/*.lua" );


	





----------------------------
-- KittyScript January 15, 2008)
-- by John [MT]OMalley Dorian
--
-- First beta - March 25, 2008
-- 
--This is just the help menu. Dear god we need some optimization.EDIT: NVM I SUK COKZ!
/*---------------------------------------------------------
 <<<<<Get the party started>>>>>
---------------------------------------------------------*/
local Panel = {}
// Init
function Panel:Init()



	for _, v in pairs( list ) do
	
		UniqueID = string.gsub( v, ".lua", "" );
	
	end
	





	//TitleBar
	self.Title = vgui.Create("Label", self)
	self.Title:SetText(UniqueID)
	// Backer and info
	self.Backer = vgui.Create("Panel", self)
	self.Info = vgui.Create("Panel", self.Backer)
	// Height
	self.Height = 16
	// Categories
	self.Backer = vgui.Create("Panel", self)
	self.Info = vgui.Create("Panel", self.Backer)
	// Scroll
	self.Scroll = 0
	self.DestinationScroll = 0
	// Input
	self:SetKeyboardInputEnabled(true)
	self:SetMouseInputEnabled(true)
	//Opacity
	self.Alphap=0
	// Y
	//Offset vertical by 16.
	local Y = 16
	//STUPID FAGGOT AIDS
			//Text entries--FUCKING SHIT! AUTOMATE ALL OF THIS!!!!
			self.TextArea1 = vgui.Create("Label", self.Info)
			self.TextArea1:SetText(UniqueID)
			self.TextArea1:SetPos(16, Y)
			Y = Y+16
			
			self.TextArea2 = vgui.Create("Label", self.Info)
			self.TextArea2:SetText(UniqueID)
			self.TextArea2:SetPos(16, Y)
			self.TextArea1:SetFont("Default")--Makes it normal
			Y = Y+16
			
		//MORE AIDS TO FIX RESOLUTION AIDS
			// Text
			// Increase Y
			Y = Y + 3200
			// Increase height
			self.Height = self.Height + 3200
		Y = Y + 1600
		self.Height = self.Height + 1600
end

// Perform layout--Sizes shit according to the screen size, and how much text is in the area.
function Panel:PerformLayout()
	// Size
	self:SetSize(500, ScrH() * 0.3)
	// Backer
	self.Backer:SetPos(8, 32)
	self.Backer:SetSize(self:GetWide() - 16, self:GetTall() - 40)
	// Info
	self.Info:SetSize(self.Backer:GetWide(), self.Height)
	// Text--AUTOMATE THIS SHIT LATER
	self.TextArea1:SizeToContents()
	self.TextArea2:SizeToContents()
	self.Info:SizeToContents()
	// Title
	self.Title:SetPos(16, 8)
	self.Title:SizeToContents()
end

// Mouse wheeled
function Panel:OnMouseWheeled(Delta)
    self.DestinationScroll = self.Scroll + (Delta * FrameTime() * 2000)
end

// Paint
function Panel:Paint()
	if self.On then
		self:SetVisible( true )
		if self.Alphap<1 then
			self.Alphap=math.Clamp(self.Alphap+0.1,0,1)	
		end
	else
		if self.Alphap>0 then
			self.Alphap=math.Clamp(self.Alphap-0.05,0,1)
		end
		if self.Alphap == 0 then
			self:SetVisible( false )
		end
	end
	draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), Color(33, 33, 33, 150*self.Alphap))
	draw.RoundedBox(4, 2, 2, self:GetWide() - 4, self:GetTall() - 4, Color(25, 25, 25, 200*self.Alphap))
	draw.RoundedBox(4, self.Backer.X, self.Backer.Y, self.Backer:GetWide(), self.Backer:GetTall(), Color(50, 50, 50, 250*self.Alphap))
	// Y
	local Maximum = self.Backer:GetTall()
	local Division = self.Info:GetTall() - (self:GetTall() + 88)
	local Current = self.Backer.Y - self.Scroll
	local Percentage = (Maximum / Division) * Current
	local Final = math.Clamp(Percentage, self.Backer.Y + 4, Maximum)
	// Scroll
	draw.RoundedBox(4, self.Backer:GetWide() - 12, self.Backer.Y + 4, 12, self.Backer:GetTall() - 12, Color(33, 33, 33, 150*self.Alphap))
	draw.RoundedBox(4, self.Backer:GetWide() - 10, self.Backer.Y + 6, 8, self.Backer:GetTall() - 16, Color(75, 75, 75, 150*self.Alphap))
	draw.RoundedBox(4, self.Backer:GetWide() - 12, Final, 12, 24, Color(75, 75, 75, 150*self.Alphap))
	draw.RoundedBox(4, self.Backer:GetWide() - 10, Final + 2, 8, 20, Color(25, 25, 25, 150*self.Alphap))
	//Titlebar color
	self.Title:SetFGColor(Color(255, 255, 255, 255*self.Alphap))
	//D-D-D-D-DICKS IN MY MOUTH!
	//Fading Text areas --AUTOMATE THIS SHIT TOO
			self.TextArea1:SetFGColor(Color(0, 255, 255, 255*self.Alphap))
			self.TextArea2:SetFGColor(Color(255, 255, 255, 255*self.Alphap))
	// Return true
	return true
end

// Apply scheme settings--Not really needed, seeing as PAINT overwrites this anyway.
function Panel:ApplySchemeSettings()
	self.Title:SetFont("ChatFont")
			self.TextArea1:SetFont("ChatFont")--Makes it bold
	self.Title:SetFGColor(Color(255, 255, 255, 255)) 	
end

// Think
function Panel:Think()
	self:SetPos(8, 48)
	// Clicker
	if self.On then
		gui.EnableScreenClicker(true)
	else
		gui.EnableScreenClicker(false)
	end
	// Scroll
    self.Scroll = self.Scroll + (self.DestinationScroll - self.Scroll) * 0.5
    self.Scroll = math.Clamp(self.Scroll, -(self.Info:GetTall() - (self:GetTall() + 88)), 0)
	// Position
	self.Info:SetPos(0, self.Scroll)
end
// Register
vgui.Register("Inventory", Panel, "Panel")