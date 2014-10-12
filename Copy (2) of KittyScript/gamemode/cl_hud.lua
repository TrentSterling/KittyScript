----------------------------
-- KittyScript January 15, 2008)
-- by John [MT]OMalley Dorian
--
-- First beta - March 25, 2008
-- 
--HUD modificaitons and drawing
/*---------------------------------------------------------
 <<<<<Get the party started>>>>>
---------------------------------------------------------*/

//Hurt so we get blurry vision
local function DrawDamagedDisplay()
	--if( not LocalPlayer():Alive() ) then return; end
	if( LocalPlayer():Health() <= 50 ) then
		if( LocalPlayer():Health() <= 40 ) then
			local blurmul = 0;
			local cutoff = 50;
			if( LocalPlayer():Health() <= 30 ) then
				cutoff = 120;
			end
			if( LocalPlayer():Health() <= 20 ) then
				cutoff = 200;
			end	
			blurmul = 1 - math.Clamp( LocalPlayer():Health() / cutoff, 0, 1 );
			-- .149
			-- .955
			-- .068
			DrawMotionBlur( .149 * blurmul, .955 * blurmul, .068 * blurmul );
		end
		surface.SetDrawColor( 135, 0, 0, 160 * ( 1 - math.Clamp( LocalPlayer():Health() / 50, 0, 1 ) ) );
		surface.DrawRect( 0, 0, ScrW(), ScrH() );
	end
end












//Hunger so we get blurry vision
local function DrawHungerDisplay()
	--if( not LocalPlayer():Alive() ) then return; end
	if( LocalPlayer():GetNWInt( "hunger" ) <= 50 ) then
		if( LocalPlayer():GetNWInt( "hunger" ) <= 40 ) then
			local blurmul = 0;
			local cutoff = 50;
			if( LocalPlayer():GetNWInt( "hunger" ) <= 30 ) then
				cutoff = 120;
			end
			if( LocalPlayer():GetNWInt( "hunger" ) <= 20 ) then
				cutoff = 200;
			end	
			blurmul = 1 - math.Clamp( LocalPlayer():GetNWInt( "hunger" ) / cutoff, 0, 1 );
			-- .149
			-- .955
			-- .068
			DrawMotionBlur( .149 * blurmul, .955 * blurmul, .068 * blurmul );
		end
		surface.SetDrawColor( 0, 0, 0, 160 * ( 1 - math.Clamp( LocalPlayer():GetNWInt( "hunger" ) / 50, 0, 1 ) ) );
		surface.DrawRect( 0, 0, ScrW(), ScrH() );
	end
end





//Thirst so we get blurry vision
local function DrawThirstDisplay()
	--if( not LocalPlayer():Alive() ) then return; end
	if( LocalPlayer():GetNWInt( "thirst" ) <= 50 ) then
		if( LocalPlayer():GetNWInt( "thirst" ) <= 40 ) then
			local blurmul = 0;
			local cutoff = 50;
			if( LocalPlayer():GetNWInt( "thirst" ) <= 30 ) then
				cutoff = 120;
			end
			if( LocalPlayer():GetNWInt( "thirst" ) <= 20 ) then
				cutoff = 200;
			end	
			blurmul = 1 - math.Clamp( LocalPlayer():GetNWInt( "thirst" ) / cutoff, 0, 1 );
			-- .149
			-- .955
			-- .068
			DrawMotionBlur( .149 * blurmul, .955 * blurmul, .068 * blurmul );
		end
		surface.SetDrawColor( 0, 0, 0, 160 * ( 1 - math.Clamp( LocalPlayer():GetNWInt( "thirst" ) / 50, 0, 1 ) ) );
		surface.DrawRect( 0, 0, ScrW(), ScrH() );
	end
end












function MoneyHud() 
	local client = LocalPlayer()
	if !client:Alive() then return 
	end
surface.CreateFont( "Tahoma", 18, 700, true, false, "MONEYHUDFONT" );
	
	surface.SetFont( "MONEYHUDFONT" );
	local creditsw, creditsh = surface.GetTextSize( client:GetNWInt( "money" ) );
	local nickw, nickh = surface.GetTextSize( client:GetNWString( "RPName" ) );
	local jobtitlew, jobtitleh = surface.GetTextSize( client:GetNWString( "jobtitle" ));
	pboxw = 0;
	if( nickw > jobtitlew ) then
		pboxw = nickw+20;
	end
	if( nickw < jobtitlew ) then
		pboxw = jobtitlew+25;
	end
	if( creditsw+60 > pboxw ) then
		pboxw = creditsw+60;
	end
	draw.RoundedBox( 4, 13, ScrH() - 122, 20+pboxw , 20, Color( 100, 100, 100, 200 ) )
	draw.RoundedBox( 4, 10, ScrH() - 125, 26+pboxw , 85, Color( 33, 33, 33, 150 ) )
	draw.RoundedBox( 4, 13, ScrH() - 122, 20+pboxw , 79, Color( 0, 0, 0, 200 ) )
	draw.SimpleText("Player", "MONEYHUDFONT", 20,  ScrH() - 119, Color(255, 255, 255, 255), 0, 0)  
	draw.SimpleText(client:GetNWInt( "money" ) .. " Credits", "MONEYHUDFONT", 20,  ScrH() - 100, Color(255, 255, 255, 255), 0, 0)  
	draw.SimpleText(client:GetNWString( "jobtitle" ) .. " ", "MONEYHUDFONT", 20,  ScrH() - 80, Color(255, 255, 255, 255), 0, 0)  
	draw.SimpleText(client:GetNWString( "RPName" ) .. " ", "MONEYHUDFONT", 20,  ScrH() - 60, Color(255, 255, 255, 255), 0, 0)  
end                                                                
hook.Add("HUDPaint", "MoneyHud", MoneyHud)  

function DrawOutlinedMeter( amt, thickness, x, y, w, h, clr )
	draw.RoundedBox( 4, x-2, y-2, w+4, h+4, Color( 150, 0, 0, 50 ) );
	draw.RoundedBox( 4, x, y, w, h, Color( 0, 0, 0, 255 ) );
	if(  amt > 0.0 ) then
		draw.RoundedBox( 4, x + thickness, y + thickness, ( w - thickness * 2 ) * amt, h - thickness * 2, clr );	
	end
	if( amt > 0.8 ) then
		draw.RoundedBox( 4, x + thickness, y + thickness, ( w - thickness * 2 ) * amt, h - thickness * 2, Color( 75, 0, 0, 255 ) );	
	end
	if(  amt <= 0.8 && amt >= 0.5 ) then
		draw.RoundedBox( 4, x + thickness, y + thickness, ( w - thickness * 2 ) * amt, h - thickness * 2, clr );	
	end
	if( amt < 0.5 && amt >= 0.3 ) then
		draw.RoundedBox( 4, x + thickness, y + thickness, ( w - thickness * 2 ) * amt, h - thickness * 2, Color( 200, 0, 0, 255 ) );	
	end
	if( amt < 0.3 && amt > 0.0 ) then
		draw.RoundedBox( 4, x + thickness, y + thickness, ( w - thickness * 2 ) * amt, h - thickness * 2, Color( 255, 0, 0, 255 ) );	
	end
end





function DrawOutlinedMeter2( amt, thickness, x, y, w, h, clr )

if(LocalPlayer():GetNWInt( "armor" ) > 0)then

	draw.RoundedBox( 4, x-2, y-2, w+4, h+4, Color( 0, 0, 150, 50 ) );
	draw.RoundedBox( 4, x, y, w, h, Color( 0, 0, 0, 255 ) );
	if(  amt > 0.0 ) then
		draw.RoundedBox( 4, x + thickness, y + thickness, ( w - thickness * 2 ) * amt, h - thickness * 2, clr );	
	end
	
	end
end





function DrawOutlinedMeter3( amt, thickness, x, y, w, h, clr )


	draw.RoundedBox( 4, x-2, y-2, w+4, h+4, Color( 0, 150, 0, 50 ) );
	draw.RoundedBox( 4, x, y, w, h, Color( 0, 0, 0, 255 ) );
	if(  amt > 0.0 ) then
		draw.RoundedBox( 4, x + thickness, y + thickness, ( w - thickness * 2 ) * amt, h - thickness * 2, clr );	
	end
	
end

function DrawOutlinedMeter4( amt, thickness, x, y, w, h, clr )


	draw.RoundedBox( 4, x-2, y-2, w+4, h+4, Color( 0, 150, 150, 50 ) );
	draw.RoundedBox( 4, x, y, w, h, Color( 0, 0, 0, 255 ) );
	if(  amt > 0.0 ) then
		draw.RoundedBox( 4, x + thickness, y + thickness, ( w - thickness * 2 ) * amt, h - thickness * 2, clr );	
	end
	
end

	 
	 
//HudPaint
function GM:HUDPaint()
	DrawDamagedDisplay();
	DrawHungerDisplay();
	DrawThirstDisplay();
	
	DrawOutlinedMeter( LocalPlayer():Health() / 100, 2, ScrW() * .33, 5, ScrW() * .33, 16, Color( 150, 0, 0, 255 ) );
	
	DrawOutlinedMeter3( LocalPlayer():GetNWInt( "hunger" ) / 10000, 2, ScrW() * .33, 25, ScrW() * .16, 8, Color( 0, 150, 0, 255 ) );--food
	DrawOutlinedMeter4( LocalPlayer():GetNWInt( "thirst" ) / 10000, 2, ScrW() * .50, 25, ScrW() * .16, 8, Color( 0, 150, 150, 255 ) );--food
	DrawOutlinedMeter2( LocalPlayer():GetNWInt( "armor" ) / 100, 2, ScrW() * .33, 40, ScrW() * .33, 8, Color( 0, 0, 150, 255 ) );
	if( SeeAll ) then
		for k, v in pairs( player.GetAll() ) do
			if( v ~= LocalPlayer()) then
				local pos = v:GetPos():ToScreen();
				draw.DrawText( v:GetNWString( "RPName" ), "ChatFont", pos.x, pos.y, Color( 0, 255, 255, 255 ) );
			end
		end
	end
end

function GM:HUDShouldDraw( name )
	local nodraw = 
	{
		"CHudHealth",
		"CHudAmmo",
		"CHudSecondaryAmmo",
		"CHudBattery",
		--"CHudWeaponSelection"
	}
	for k, v in pairs( nodraw ) do
		if( name == v ) then return false; end
	end
	return true;
end
