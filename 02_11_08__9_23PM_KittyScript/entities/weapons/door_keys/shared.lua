if( SERVER ) then

	AddCSLuaFile( "shared.lua" );

end

if ( CLIENT ) then
	
	SWEP.PrintName			= "Keys"
	SWEP.Slot				= 1						
	SWEP.SlotPos			= 1					
	SWEP.DrawAmmo			= false					
	SWEP.DrawCrosshair		= false 					
	SWEP.DrawWeaponInfoBox	= true					
	
end

SWEP.Author			= "Mambojambo"
SWEP.Contact		= ""
SWEP.Purpose		= "Unlock & Lock doors you own"
SWEP.Instructions	= "Left click to unlock and right click to lock"

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_c4.mdl"
SWEP.WorldModel		= "models/weapons/w_c4.mdl"
SWEP.AnimPrefix		= "normal"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.ClipSize		= -1					// Size of a clip
SWEP.Primary.DefaultClip	= -1				// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= ""

SWEP.Secondary.ClipSize		= 145					// Size of a clip
SWEP.Secondary.DefaultClip	= 166				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo			= ""
local LockedSound = Sound( "doors/default_locked.wav" ) 
local OpenSound = Sound( "doors/door_latch3.wav" ) 


/*---------------------------------------------------------
   Name: SWEP:Initialize( )
   Desc: Called when the weapon is first loaded
---------------------------------------------------------*/
function SWEP:Initialize()
	
	if( CLIENT ) then return end
		
	self:SetWeaponHoldType("normal")
	
end


/*---------------------------------------------------------
   Name: SWEP:Precache( )
   --Desc: Use this function to precache stuff
---------------------------------------------------------*/
function SWEP:Precache()
util.PrecacheSound(LockedSound)
util.PrecacheSound(OpenSound)
util.PrecacheModel(self.ViewModel)
util.PrecacheModel(self.WorldModel)
end

function SWEP:Deploy()

	if( SERVER ) then

		self.Owner:DrawViewModel( false );
		self.Owner:DrawWorldModel( false );
		
	end

end
/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
	local owner = self.Owner 
	local tr = owner:GetEyeTrace()
	if ( tr.HitWorld ) then return end
	
    	// The rest is only done on the server
    
	-- Check if the ent we hit is a door
	if ( tr.Entity ) then
        
		local ent = tr.Entity
		if ( !ent:IsValid() ) then return end
						
		if ( ent:IsOwnable() ) then
				
			if( ent:GetNWString( "Owner") != owner:Nick() ) then return end
			
			if( SERVER ) then
				if( owner:IsOwner(ent) ) then
					ent:Fire( "Unlock", "1", 0 )
				end
			
			elseif( CLIENT ) then
				self.Weapon:EmitSound( OpenSound )
			end
				
		end
	end 
end


/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack( )
   Desc: +attack2 has been pressed
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	local owner = self.Owner
	local tr = owner:GetEyeTrace()
	if ( tr.HitWorld ) then return end
	
   	 // Check is the ent we hit a door
	if ( tr.Entity ) then
        
  	local ent = tr.Entity
   	if ( !ent:IsValid() ) then return end
				
		if ( ent:IsOwnable() ) then
				
			if( ent:GetNWString( "Owner") != owner:Nick() ) then return end
			
			if( SERVER ) then
				if( owner:IsOwner(ent) ) then
					ent:Fire( "Lock", "1", 0 )
				end
			
			elseif( CLIENT ) then
				self.Weapon:EmitSound( LockedSound )
			end
				
		end
 
    end 
end

function SWEP:ShootEffects()

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation

end