
if( SERVER ) then

	AddCSLuaFile( "shared.lua" );
	
	SWEP.HoldType = "ar2";
	SWEP.FOVAmt = 80;
	SWEP.NoDrawOnIronSights = true;

end

if( CLIENT ) then

	SWEP.PrintName = "CISR-762";
	SWEP.Slot = 3;
	SWEP.SlotPos = 1;
	
	SWEP.DrawCrosshair = false;

end

SWEP.Base = "weapon_ks_base";

SWEP.Primary.Sound = Sound( "npc/sniper/sniper1.wav" );

SWEP.WorldModel = "models/weapons/w_msg90.mdl";
SWEP.ViewModel = "models/weapons/v_msg90.mdl";

SWEP.Primary.ClipSize = 12;
SWEP.Primary.DefaultClip = 12;
SWEP.Primary.Ammo = "ar2";
SWEP.Primary.Delay = 2.1;
SWEP.Primary.Damage = 200;
SWEP.Primary.Force = 15;
SWEP.Primary.RunCone = Vector( 0.01, 0.01, 0 );
SWEP.Primary.SpreadCone = Vector( 0.002, 0.002, 0 );
SWEP.Primary.CrouchSpreadCone = Vector( 0.001, 0.001, 0 );
SWEP.Primary.ViewPunch = Angle( -1.75, 0.0, 0 );
SWEP.Primary.Automatic = false;

SWEP.AimSway = true;
SWEP.SwayCone = Vector( .1, .1, 0 );

SWEP.IronSightPos = Vector( -6.4, 2.5, -9.0 );
SWEP.IronSightAng = Vector( 0.0, 0.0, 0.0 );

SWEP.IronSightSound = Sound( "weapons/sniper/sniper_zoomin.wav" );

SWEP.Volume = 600;

if( CLIENT ) then
	SWEP.Mat = Material( "models/weapons/msg-90/vscope" );
end

function SWEP:DrawHUD()
	
	if( self.Weapon:GetNWBool( "ironsights" ) ) then

		surface.SetDrawColor( 0, 0, 0, 255 );
		
		surface.SetMaterial( self.Mat );
		surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() );

	end

end


