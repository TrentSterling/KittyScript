if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

if( CLIENT ) then
	SWEP.PrintName = "Vortigaunt Gun";
	SWEP.Slot = 1;
	SWEP.SlotPos = 2;
	SWEP.DrawAmmo = false;
	SWEP.DrawCrosshair = true;
end

SWEP.Author			= "Doug Tyrrell"
SWEP.Instructions	= "Left click to shoot, right click to melee, hold R to heal."
SWEP.Contact		= "www.exrp.ca"
SWEP.Purpose		= "Turns you into a vorty <3"

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.AnimPrefix		= "crowbar"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true
  
SWEP.Primary.ClipSize		= -1					// Size of a clip
SWEP.Primary.DefaultClip	= 0				// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= ""

SWEP.Secondary.ClipSize		= -1				// Size of a clip
SWEP.Secondary.DefaultClip	= 0				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo			= ""

Sound("NPC_Vortigaunt.Shoot")
Sound("NPC_Vortigaunt.ZapPowerup")
Sound("NPC_Vortigaunt.StartHealLoop")
Sound("NPC_Vortigaunt.Kick")
Sound("NPC_Vortigaunt.Swing")
Sound("NPC_Vortigaunt.Claw")

function SWEP:Initialize()
	if( SERVER ) then
		self:SetWeaponHoldType( "normal" );
	end
end

function SWEP:Precache()
end

function SWEP:Deploy()
	self.NextHeal = CurTime();
	self.InAttack = false;
	
	-- For my server. Ignore this. :)
	--local ply = self.Owner;
	--ply.IsVort = true;
	-- k stop ignoring
	GAMEMODE:SetPlayerSpeed(self.Owner, 92, 200) 
	
	if CLIENT then return end
	self.Owner:DrawViewModel( false );
	self.Owner:DrawWorldModel( false );
	self.OldModel = self.Owner:GetModel();
	self.Owner:SetModel("models/vortigaunt.mdl")
	self.Owner:ResetSequence(2)
	self.Owner:SetPlaybackRate(1.0);
end

function SWEP:Holster( wep )
	-- For my server. Ignore this. :)
	--local ply = self.Owner;
	--ply.IsVort = false;
	-- k stop ignoring
	GAMEMODE:SetPlayerSpeed(self.Owner, 200, 350) 

	if CLIENT then return end
	self.Owner:SetModel(self.OldModel)
	return true;
end 

function ResetVortIdle(ply, self)
	ply:ResetSequence(2)
	ply:SetPlaybackRate(1.0);
	ply:StopSound(Sound("NPC_Vortigaunt.ZapPowerup"))
	ply:StopSound(Sound("NPC_Vortigaunt.StartHealLoop"))
	self.InAttack = false;
end

function VortigauntZap(ply, wep)
	ply:EmitSound(Sound("NPC_Vortigaunt.Shoot"))
	trace = ply:GetEyeTrace()
	local bullet = {
		Num			= 1,
		Src 		= ply:GetShootPos(),
		Dir 		= ply:GetAimVector(),
		Spread		= 0,
		Tracer		= 50,
		Force		= 5,
		Damage		= 200,
		AmmoType	= "Pistol"
	}
	
	-- Not all to sure what some of this effectdata does, so I'll just leave it in
	
	local effectdata = EffectData()
	effectdata:SetOrigin( trace.HitPos )
	effectdata:SetNormal( trace.HitNormal )
	effectdata:SetEntity( trace.Entity )
	effectdata:SetAttachment( trace.PhysicsBone )

	local effectdata = EffectData()
	effectdata:SetOrigin( trace.HitPos )
	effectdata:SetStart( ply:GetShootPos() )
	effectdata:SetAttachment( 1 )
	effectdata:SetEntity( wep )
	
	util.Effect( "cball_explode", effectdata )
	util.Effect( "ManhackSparks", effectdata )
	util.Effect( "ToolTracer", effectdata )
	ply:FireBullets( bullet )
end

function SWEP:PrimaryAttack()
	if self.InAttack then return end
	self.Weapon:SetNextPrimaryFire( CurTime() + 3.0 );
	self.InAttack = true;
	if CLIENT then return end
	
	local sequence = self.Owner:LookupSequence("zapattack1")
	self.Owner:ResetSequence(sequence)
	self.Owner:SetPlaybackRate(1.0);
	
	self.Owner:EmitSound(Sound("NPC_Vortigaunt.ZapPowerup"))
	timer.Simple(1.5,VortigauntZap, self.Owner, self.Weapon)
	timer.Simple(3, ResetVortIdle, self.Owner, self)
end

function SWEP:SecondaryAttack() 
	if self.InAttack then return end
	self.Weapon:SetNextSecondaryFire( CurTime() + 1.0 );
	self.InAttack = true;
	if CLIENT then return end
	
	local rnd = math.random(1,3)
	if rnd == 1 then
		melan = "MeleeHigh1";
	elseif rnd == 2 then
		melan = "MeleeHigh2";
	elseif rnd == 3 then
		melan = "MeleeHigh3";
	elseif rnd == 4 then
		melan = "MeleeLow";
	end
	
	local sequence = self.Owner:LookupSequence(melan)
	self.Owner:ResetSequence(sequence)
	self.Owner:SetPlaybackRate(1.0);
	
	local tr = self.Owner:GetEyeTrace();
	if tr.HitPos:Distance(self.Owner:GetShootPos()) <= 75 then
		if rnd == 4 then
			self.Owner:EmitSound(Sound("NPC_Vortigaunt.Kick"))
		else
			self.Owner:EmitSound(Sound("NPC_Vortigaunt.Claw"))
		end
		if tr.Entity.TakeDamage then
			tr.Entity:TakeDamage(50, self.Owner)
	   	else
	   		util.BlastDamage(self.Owner, self.Owner, tr.Entity:GetPos(), 4, 50)
	   		if tr.Entity:IsValid() then
			   tr.Entity:Extinguish()
			end
	   	end
	else
		self.Owner:EmitSound(Sound("NPC_Vortigaunt.Swing"))
	end
	timer.Simple(1, ResetVortIdle, self.Owner, self)
end 

function SWEP:Reload()
	if self.InAttack then return end
	self.IsHealing = true;
	self.InAttack = true;
end 

function SWEP:Think()
	if not self.InAttack then
		if self.Owner:KeyDown(IN_FORWARD) and not self.Owner:KeyDown(IN_SPEED) then
			self.Owner:SetSequence(10)
			self.Owner:SetPlaybackRate(1.0);
		elseif self.Owner:KeyDown(IN_BACK) and not self.Owner:KeyDown(IN_SPEED) then
			self.Owner:SetSequence(10)
			self.Owner:SetPlaybackRate(1.0);
		elseif self.Owner:KeyDown(IN_SPEED) and self.Owner:KeyDown(IN_FORWARD) then
			self.Owner:SetSequence(11)
			self.Owner:SetPlaybackRate(1.0);
		elseif self.Owner:KeyDown(IN_SPEED) and self.Owner:KeyDown(IN_BACK) then
			self.Owner:SetSequence(11)
			self.Owner:SetPlaybackRate(1.0);
		elseif self.Owner:KeyDown( IN_DUCK ) then
			self.Owner:SetSequence(5)
			self.Owner:SetPlaybackRate(1.0);
		else
			self.Owner:SetSequence(2)
			self.Owner:SetPlaybackRate(1.0);
		end
	end

	if not self.Owner:KeyDown(IN_RELOAD) then
			if self.IsHealing then
				self.IsHealing = false;
				self.NextHeal = CurTime();
				ResetVortIdle(self.Owner, self);
			end
		return;
	end
	
	if self.IsHealing then	
		self.Owner:SetSequence(34)
		self.Owner:SetPlaybackRate(1.0);
			
		trace = self.Owner:GetEyeTrace()
		local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos )
		effectdata:SetNormal( trace.HitNormal )
		effectdata:SetEntity( trace.Entity )
		effectdata:SetAttachment( trace.PhysicsBone )
		local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos )
		effectdata:SetStart( self.Owner:GetShootPos() )
		effectdata:SetAttachment( 1 )
		effectdata:SetEntity( self.Weapon )
		util.Effect( "ToolTracer", effectdata )
		
		if not self.NextHeal then
			self.NextHeal = CurTime();
		end
		
		if (self.NextHeal < CurTime()) then
			self.NextHeal = CurTime() + 4;
			self.Owner:EmitSound(Sound("NPC_Vortigaunt.StartHealLoop"))
			trace = {}
			trace.start = self.Owner:GetShootPos()
			trace.endpos = trace.start + (self.Owner:GetAimVector() * 400)
			trace.filter = { self.Owner, self.Weapon }
			tr = util.TraceLine( trace )
			
			if tr.HitNonWorld then
				local enthit = tr.Entity
				if enthit:IsValid() then
					enthit:SetHealth(enthit:Health() + 25)
				end
			end
		end
	end
end
