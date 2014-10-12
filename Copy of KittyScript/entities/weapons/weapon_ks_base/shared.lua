

if( SERVER ) then

	SWEP.Weight = 5;
	SWEP.AutoSwitchTo = false;
	SWEP.AutoSwitchFrom = false;
	
	SWEP.FOVAmt = 25;

	AddCSLuaFile( "shared.lua" );

end

if( CLIENT ) then

	SWEP.DrawAmmo = true;
	SWEP.DrawCrosshair = false;
	SWEP.ViewModelFOV = 50;
	SWEP.DefaultFOV = 50;
	SWEP.ViewModelFlip = false;

	surface.CreateFont( "csd", ScreenScale( 30 ), 500, true, true, "CSKillIcons" )
	surface.CreateFont( "csd", ScreenScale( 60 ), 500, true, true, "CSSelectIcons" )	

end

SWEP.Author = "John Dorian";
SWEP.Contact = "";
SWEP.Purpose = "";
SWEP.Instructions = "";

SWEP.Spawnable = false;
SWEP.AdminSpawnable = true;

SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = -1;
SWEP.Primary.Ammo = "";
SWEP.Primary.Automatic = false;

SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = -1;
SWEP.Secondary.Ammo = "";
SWEP.Secondary.Automatic = false;

SWEP.ViewPunchStray = false; --Enabled or not
SWEP.ViewPunchOffset = Vector( 0, 0, 0 ); --Offset to view punch
SWEP.ViewPunchAdd = Vector( 0, 0, 0 ); --How much to add to the view punch offset
SWEP.StraySpeed = 0; --Multiplier.  How fast the view punch offset is changed

SWEP.SwayUpDownAmt = 0;
SWEP.SwayLeftRightAmt = 0;

SWEP.LearnCurve = 0;

function SWEP:Initialize()

	if( SERVER ) then
	
		self:SetWeaponHoldType( self.HoldType );
		self.Weapon:SetNWBool( "ironsights", false );
	
	end

end

function SWEP:CanShootPrimary()

	if( not self:CanPrimaryAttack() ) then return false; end

	if( not self.Weapon:GetNWBool( "NPCAimed" ) ) then
		return false;
	end
	
	return true;

end

function SWEP:Reload()

	self.Weapon:DefaultReload( ACT_VM_RELOAD );
	self.Weapon:SetNWBool( "ironsights", false );
	
	self.ViewPunchOffset = Vector( 0, 0, 0 );
	
	if( SERVER ) then
		self.Owner:SetFOV( 90, .6 );
	end

end

function SWEP:Deploy()

	self.Weapon:SetNWBool( "ironsights", false );
	self.IronSights  = nil;
	
	self.ViewPunchOffset = Vector( 0, 0, 0 );
	
	if( SERVER ) then
		self.Owner:SetFOV( 90, 0 );
	end
	
	self.LearnCurve = 0;
	
	if( SERVER ) then
		self.Owner:DrawViewModel( true );
	end
	
end

function SWEP:Think()

	if( not self.Owner:KeyDown( IN_ATTACK ) ) then
	
		if( self.ViewPunchStray and self.ViewPunchOffset.x ~= 0 and self.ViewPunchOffset.y ~= 0 and self.ViewPunchOffset.z ~= 0 ) then
		
			self.ViewPunchOffset.x = math.Clamp( FrameTime() * self.ViewPunchOffset.x - self.ViewPunchAdd.x * self.StraySpeed * .5, 0, 99 );
			self.ViewPunchOffset.y = math.Clamp( FrameTime() * self.ViewPunchOffset.y - self.ViewPunchAdd.y * self.StraySpeed * .5, 0, 99 );
			self.ViewPunchOffset.z = math.Clamp( FrameTime() * self.ViewPunchOffset.z - self.ViewPunchAdd.z * self.StraySpeed * .5, 0, 99 );
		
		end
		
		self.LearnCurve = math.Clamp( self.LearnCurve - .6 * FrameTime(), 0, 1 );
	
	end

end

function SWEP:ToggleIronsight()

	self.Weapon:SetNWBool( "ironsights", !self.Weapon:GetNWBool( "ironsights" ) );

	if( self.NoDrawOnIronSights ) then
	
		if( SERVER ) then
			timer.Simple( .2, self.Owner.DrawViewModel, self.Owner, !self.Weapon:GetNWBool( "ironsights" ) );
		end
		
	end

	if( not self.Weapon:GetNWBool( "NPCAimed" ) ) then
		self.Weapon:SetNWBool( "ironsights", false );
	end
	
	if( self.Weapon:GetNWBool( "ironsights" ) and not self.NoIronSightFovChange ) then
	
		if( SERVER ) then
			self.Owner:SetFOV( 90 - self.FOVAmt, .5 );
		end
	
	else
	
		if( SERVER ) then
			self.Owner:SetFOV( 90, .5 );
		end	
	
	end
	
	if( self.IronSightSound ) then
		self.Weapon:EmitSound( self.IronSightSound );
	end
	
end


function SWEP:PrimaryAttack()

	if( not self:CanShootPrimary() ) then return; end

	if( self.Weapon:GetNWBool( "ironsights" ) and self.NoIronSightAttack ) then return; end
	if( self.Owner:KeyDown( IN_SPEED ) and self.Owner:GetVelocity():Length() >= 140 ) then return; end

	if( CLIENT ) then
		self.Weapon:EmitSound( self.Primary.Sound );
	else
		self.Weapon:EmitSound( self.Primary.Sound, self.Volume );
	end
	
	self:ShootEffects();
	
	self.Weapon:SetNextPrimaryFire( CurTime() + ( self.Primary.Delay or .5 ) );
	
	self:TakePrimaryAmmo( 1 );
	self:TSShootBullet();
	
	local punchmul = 1 + ( 1 - math.Clamp( self.Owner:Health() / 50, 0, 1 ) );

	self.Owner:ViewPunch( self.Primary.ViewPunch * punchmul );

	if( self.ViewPunchStray ) then
	
		self.ViewPunchOffset.x = math.Clamp( self.ViewPunchOffset.x + self.ViewPunchAdd.x * self.StraySpeed * .5, 0, 99 );
		self.ViewPunchOffset.y = math.Clamp( self.ViewPunchOffset.y + self.ViewPunchAdd.y * self.StraySpeed * .5, 0, 99 );
		self.ViewPunchOffset.z = math.Clamp( self.ViewPunchOffset.z + self.ViewPunchAdd.z * self.StraySpeed * .5, 0, 99 );
			
	end
	
end

function SWEP:SecondaryAttack()

	self:ToggleIronsight();

end

function SWEP:TSShootBullet()

	local bullet = { }
	
	bullet.Num = self.Primary.NumBullets or 1;
	bullet.Src = self.Owner:GetShootPos();
	bullet.Dir = self.Owner:GetAimVector();
	bullet.Spread = self.Primary.SpreadCone or Vector( 0, 0, 0 );
	bullet.AmmoType = self.Primary.Ammo;

	if( self.Weapon:GetNWBool( "ironsights" ) ) then
	
		if( self.AimSway ) then
	
			
		end

	end
	
	if( self.Owner:KeyDown( IN_DUCK ) ) then
	
		bullet.Spread = self.Primary.CrouchSpreadCone or bullet.Spread;
	
	elseif( self.Owner:KeyDown( IN_SPEED ) ) then
	
		bullet.Spread = self.Primary.RunCone or bullet.Spread;
	
	end
	
	local spreadmul = 1 + ( 1 - math.Clamp( self.Owner:Health() / 50, 0, 1 ) );
	local aimoffset = math.Clamp( 30 / self.Owner:GetNWFloat( "stat.Aim" ), .1, 2.7 );
	
	bullet.Spread = bullet.Spread * aimoffset;
	
	if( self.Owner:Health() <= 35 ) then
	
		spreadmul = spreadmul + math.random( .1, 1 );
		
	end
	
	bullet.Spread = bullet.Spread * spreadmul;
	bullet.Spread = bullet.Spread + self.ViewPunchOffset;
	
	bullet.Tracer = 4;
	bullet.Force = self.Primary.Force or 10;
	bullet.Damage = self.Primary.Damage or 10;
	
	self.Owner:FireBullets( bullet );
	
	local trace = { }
	trace.start = self.Owner:EyePos();
	trace.endpos = trace.start + 4096 * self.Owner:GetAimVector();
	trace.filter = self.Owner;
	
	local tr = util.TraceLine( trace );
	local dist = ( tr.HitPos - trace.start ):Length();
	
	self.LearnCurve = math.Clamp( self.LearnCurve + ( dist / 2000 ) * .3, 0, 1 );
	
	if( SERVER ) then
	
		self.Owner:HandleAimStat( dist, self.LearnCurve );
	
	end
	

end

function SWEP:GetViewModelPosition( pos, ang )

	local doironsights = false;

	self.BobScale = 1;
	self.SwayScale = 1;
	
	if( self.Weapon:GetNWBool( "ironsights" ) ) then

		self.BobScale = .4;
		self.SwayScale = .4;

		if( not self.IronSights ) then

			self.IronSightTime = CurTime();
			self.IronSightMul = self.IronSightMul or 0;
			self.IronSights = true;
		
		end

		self.IronSightMul = math.Clamp( ( CurTime() - self.IronSightTime ) * 2.5, 0, 1 );
		doironsights = true;
	
	elseif( self.IronSightMul and self.IronSightMul > 0.0 ) then
	
		if( self.IronSights ) then
		
			self.IronSights = false;
			self.IronSightTime = CurTime();
			self.OldIronSightMul = self.IronSightMul or 0;
		
		end

		self.IronSightMul = self.OldIronSightMul - math.Clamp( ( ( CurTime() - self.IronSightTime ) * 2.5 ), 0, 1 );
		doironsights = true;
		
		if( self.IronSightMul == 0 ) then
			self.IronSightTime = nil;
		end
	
	else
		self.ViewModelFOV = self.DefaultFOV;
	end

	if( doironsights ) then

		ang:RotateAroundAxis( ang:Right(), self.IronSightAng.x * self.IronSightMul );
		ang:RotateAroundAxis( ang:Up(), self.IronSightAng.y * self.IronSightMul );
		ang:RotateAroundAxis( ang:Forward(), self.IronSightAng.z * self.IronSightMul );

		pos = pos + self.IronSightPos.x * ang:Right() * self.IronSightMul;
		pos = pos + self.IronSightPos.y * ang:Up() * self.IronSightMul;
		pos = pos + self.IronSightPos.z * ang:Forward() * self.IronSightMul;
	
		if( self.AimSway ) then
	
			ang:RotateAroundAxis( ang:Up(), self.SwayCone.x * math.sin( self.SwayLeftRightAmt ) );
			ang:RotateAroundAxis( ang:Right(), self.SwayCone.y * math.sin( self.SwayUpDownAmt ) );
			
			self.SwayUpDownAmt = self.SwayUpDownAmt + math.random( 0, 1 ) * FrameTime();
			self.SwayLeftRightAmt = self.SwayLeftRightAmt + math.random( 0, 1 ) * FrameTime();
			
			if( self.SwayUpDownAmt > 360 ) then self.SwayUpDownAmt = 0; end
			if( self.SwayLeftRightAmt > 360 ) then self.SwayLeftRightAmt = 0; end
		
		end
	
	
	end
	
	if( self.Owner:Health() <= 50 ) then 
	
		if( self.Owner:Health() <= 15 ) then
			self.BobScale = 1.2;
			self.SwayScale = 1.2;
		elseif( self.Owner:Health() <= 30 ) then
			self.BobScale = 1;
			self.SwayScale = 1;
		elseif( self.Owner:Health() <= 40 ) then
			self.BobScale = .8;
			self.SwayScale = .8;
		else
			self.BobScale = .6;
			self.SwayScale = .6;
		end
		
	end
	
	self.BobScale = self.BobScale * math.Clamp( ( 20 / self.Owner:GetNWFloat( "stat.Aim" ) ), .2, 5 );
	self.SwayScale = self.SwayScale * math.Clamp( ( 20 / self.Owner:GetNWFloat( "stat.Aim" ) ), .2, 5 );
	
	return pos, ang;

end

function SWEP:DrawHUD()

	if( self.DrawDotCrosshair and self.Owner:GetNWInt( "holstered" ) == 0 ) then
	
		draw.DrawText( "o", "TargetID", ScrW() / 2, ScrH() / 2, Color( 255, 255, 255, 255 ), 1, 1 );
	
	end

end

