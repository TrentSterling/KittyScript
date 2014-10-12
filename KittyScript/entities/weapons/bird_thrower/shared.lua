 if ( SERVER ) then

AddCSLuaFile( "shared.lua" )
resource.AddFile("materials/VGUI/entities/bird_thrower.vmt")
resource.AddFile("materials/VGUI/entities/bird_thrower.vtf")
SWEP.HoldType= "rpg"

end

if ( CLIENT ) then
    
SWEP.PrintName = "Bird Launcher"
    SWEP.Author = "BennyG"
    SWEP.Contact = ""
    SWEP.Purpose = ""
    SWEP.Instructions = "Left Click to launch. Right Click to fire an Homing-Bird"
SWEP.IconLetter= "x"

end
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Weight= 4
SWEP.WorldModel = "models/weapons/w_rocket_launcher.mdl"
SWEP.ViewModel = "models/weapons/v_rpg.mdl"
SWEP.Slot = 4
SWEP.SlotPos = 7
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.Primary.ClipSize= -1
SWEP.Primary.DefaultClip= -1
SWEP.Primary.Automatic   = true
 
 
function SWEP:Initialize()
if (CLIENT) then 
self.Weapon.size = 64

 end
self.Weapon:SetNetworkedBool( "Lockring", false )
self.Weapon.Targetted = false
self.Weapon.Primary.Sounds = {
Sound( "npc/crow/alert2.wav" ),
Sound( "npc/crow/alert3.wav"),
Sound( "npc/crow/pain2.wav"),
Sound( "npc/crow/pain1.wav")
}
self.Weapon.Locksound = Sound("npc/sniper/reload1.wav")
self.Weapon.Cantfire = Sound("plats/crane/vertical_stop.wav")

end
if (CLIENT) then
function SWEP:HUDShouldDraw( element )
      if (element == "CHudAmmo" or element == "CHudSecondaryAmmo" ) then
      return false
     else
      return true
     end
    end 
	
function SWEP:DrawHUD( )

  local tex=surface.GetTextureID("sprites/reticle")
  surface.SetTexture(tex)
  surface.SetDrawColor(255,25,25,200)
  if self.Weapon:GetNetworkedBool( "Lockring" ) == false then
  self.Weapon.size = 64
	surface.SetDrawColor(255,25,25,200)
	surface.DrawTexturedRect(ScrW()*0.5-32,ScrH()*0.5-32,64,64) 
  elseif self.Weapon:GetNetworkedBool( "Lockring" ) == true then
  
	self.Weapon.size = self.Weapon.size - 1.2
	surface.SetDrawColor(25,255,25,200)
	if self.Weapon.size <= 20 then
   self.Weapon.size = 20
   surface.SetDrawColor(255,255,25,200)
   end
	surface.DrawTexturedRect(ScrW()*0.5-(self.Weapon.size/2 + 2),ScrH()*0.5-(self.Weapon.size/2),self.Weapon.size,self.Weapon.size) 

   
  
  end
end
end

function SWEP:PrimaryAttack()
	local Homing = false
	self.Weapon:CreateBird(Homing)
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
end

function SWEP:SecondaryAttack()

local target = self.Weapon.Owner:GetEyeTrace().Entity
	if target:GetClass() != "worldspawn" then
		self.Weapon:SetNetworkedBool( "Lockring", true )	
		
		timer.Simple(1.5,self.SecondFire,self,target)
		self.Weapon:EmitSound(self.Weapon.Locksound)


	else
	self.Weapon:EmitSound(self.Weapon.Cantfire)
	end
self.Weapon:SetNextSecondaryFire(CurTime() + 1.6)
end
function SWEP:SecondFire(oldtarget)
	if oldtarget == self.Weapon.Owner:GetEyeTrace().Entity then
		local Homing = true
		self.Weapon:SetNetworkedBool( "Lockring", false )
		self.Weapon:CreateBird(Homing)
	else
		self.Weapon:SetNetworkedBool( "Lockring", false )
		self.Weapon:EmitSound(self.Weapon.Cantfire)
end
end

function SWEP:CreateBird(Homing)
	if Homing == true then
		self.Weapon.Owner.BirdTarget = self.Weapon.Owner:GetEyeTrace().Entity
	else
		self.Weapon.Owner.BirdTarget = nil
	end
	local Owner = self.Weapon.Owner
	if (SERVER) then
	Bird = ents.Create( "sent_bird" )  
        Bird:SetOwner( Owner )
        Bird:SetPos( Owner:GetShootPos() + (Owner:GetAngles():Forward() * 28) + (Owner:GetAngles():Right() * 15) - Vector(0,0,5)) // I had to use another way,because the RPGdoesnt have a muzzle Attchment
        Bird:SetAngles( self.Weapon:GetAngles() ) 
        Bird:Spawn()  
		Bird:Activate()
	local physics = Bird:GetPhysicsObject()
		physics:ApplyForceCenter( Owner:GetAimVector() * 40000)
	
   self.Owner:ViewPunch( Angle( -1, 0, 0 ) )
  
   self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)	
   timer.Simple(0.4,self.Idle,self)
	end
	self.Weapon:EmitSound(self.Weapon.Primary.Sounds[math.random(4)])

end
function SWEP:Idle()
self.Weapon:SendWeaponAnim(ACT_VM_IDLE)	
end


