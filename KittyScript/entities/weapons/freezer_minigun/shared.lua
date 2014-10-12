SWEP.Author			= "Team Half-Life"
SWEP.Contact		= "Don't"
SWEP.Purpose		= "Anti-Fortification/Supressive Fire"
SWEP.Instructions	= "Left-Click: Pulse rounds\nRight-Click: Concussion rounds"
SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true
SWEP.ViewModel			= "models/weapons/v_irifle.mdl"
SWEP.WorldModel			= "models/weapons/w_irifle.mdl"
SWEP.HoldType			= "smg"
SWEP.Primary.Automatic		= true
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			= ""
SWEP.Secondary.ClipSize		= 75
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "ar2"

SWEP.ReloadDelay = 0
SWEP.Trace = 0
SWEP.ReloadType = 1

if (SERVER) then
resource.AddFile("materials/refract_ring.vtf")
resource.AddFile("materials/refract_ring.vmt")
end

function SWEP:Precache()

util.PrecacheSound("weapons/ar2/fire1.wav")

util.PrecacheSound("npc/roller/mine/rmine_predetonate.wav")
util.PrecacheSound("ambient/levels/labs/electric_explosion5.wav")

for var=1, 5, 1 do
util.PrecacheSound("weapons/fx/rics/ric" .. var .. ".wav")
end

for var=1, 9, 1 do
util.PrecacheSound("ambient/explosions/explode_" .. var .. ".wav")
end

util.PrecacheSound("ambient/machines/keyboard2_clicks.wav")
util.PrecacheSound("common/warning.wav")

util.PrecacheSound("ambient/levels/labs/electric_explosion1.wav")
util.PrecacheSound("npc/scanner/scanner_nearmiss2.wav")
util.PrecacheSound("ambient/machines/thumper_dust.wav")

end

function SWEP:PrimaryAttack()

if (SERVER) then
if (self.Owner:GetAmmoCount("ar2") < 1) || (self.ReloadDelay == 1) then self.ReloadType = 1 self:Reload() return end
end

if (self.Owner:GetAmmoCount("ar2") > 0) && (self.ReloadDelay == 0) then

self.Owner:MuzzleFlash()

if (SERVER) then
self.Owner:EmitSound( "weapons/ar2/fire1.wav", 42, math.Rand(82,120) )
end

self.Owner:RemoveAmmo( 1, self.Weapon:GetSecondaryAmmoType() )

if self.Owner:GetAmmoCount("ar2") == 14 then
self.Weapon:EmitSound( "common/warning.wav", 42, 100 )
end

self.Weapon:SetNextPrimaryFire( CurTime() + 0.082 )
self.Weapon:SetNextSecondaryFire( CurTime() + 0.14 )
self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

local bullet = {}
bullet.Num = 1
bullet.Src = self.Owner:GetShootPos()
bullet.Dir = self.Owner:GetAimVector()
bullet.Spread = Vector(0.045,0.045,0.045)
local tracer = 0
if math.Round(math.Rand(0,2)) == 2 then tracer = 1 end
bullet.Tracer = tracer
bullet.Force = math.Rand(72,120)
bullet.Damage = math.Rand(6,8)
bullet.Callback = function(attacker, trace, damageinfo) self.Trace = trace end
self.Owner:FireBullets(bullet)
util.ScreenShake( self:GetPos(), 3, 2, 0.32, 128 )

local trace = self.Trace
if trace.Hit && !trace.HitSky then

if trace.Entity:IsValid() then
if trace.Entity:GetPhysicsObject():IsValid() && !trace.Entity:IsNPC() && !trace.Entity:IsPlayer() then
trace.Entity:EmitSound( "weapons/fx/rics/ric" .. math.Round(math.Rand(1,5)) .. ".wav", 52, 100 )
if math.Round(math.Rand(1,3)) == 3 && !trace.Entity:IsOnFire() then trace.Entity:Ignite(math.random(10,12), 32) end
if math.Round(math.Rand(1,8)) == 8 && trace.Entity:GetVelocity() == Vector(0,0,0) then
trace.Entity:GetPhysicsObject():EnableMotion(true)
trace.Entity:GetPhysicsObject():Wake()
trace.Entity:EmitSound( "ambient/explosions/explode_" .. math.Round(math.Rand(1,9)) .. ".wav", 72, 100 )
local effectdata = EffectData()
effectdata:SetEntity( trace.Entity )
util.Effect( "freezer_minigun_flame", effectdata, true, true )
util.ScreenShake( self:GetPos(), 12, 2, 0.32, 512 )
end
end
end

if trace.Entity:IsValid() && trace.Entity:IsNPC() && math.random(1,14) == 14 then
if trace.Entity:GetPhysicsObject():IsValid() then
trace.Entity:Ignite(math.random(10,12), 32)
end
end

if trace.HitWorld || trace.Entity:IsNPC() || trace.Entity:IsPlayer() then
local effectdata = EffectData()
if trace.Entity:IsValid() then if trace.Entity:IsNPC() then
util.BlastDamage( self.Weapon, self.Owner, trace.HitPos, 32, 4 )
end end
effectdata:SetOrigin( trace.HitPos )
util.Effect( "freezer_minigun_fire", effectdata, true, true )
util.ScreenShake( trace.HitPos, 3, 2, 0.52, 256 )
end

local Pos1 = trace.HitPos + trace.HitNormal
local Pos2 = trace.HitPos - trace.HitNormal
util.Decal("FadingScorch",Pos1,Pos2)

if trace.HitNonWorld && !trace.Entity:IsNPC() && !trace.Entity:IsPlayer() then
local effectdata = EffectData()
effectdata:SetOrigin( trace.HitPos )
util.Effect( "freezer_spark", effectdata, true, true )
util.Effect( "freezer_minigun_airdust", effectdata, true, true )
util.Effect( "freezer_minigun_fire_cheap", effectdata, true, true )
util.ScreenShake( trace.HitPos, 2, 2, 0.52, 256 )
end

end

end
end

function SWEP:SecondaryAttack()

if (SERVER) then
if (self.Owner:GetAmmoCount("ar2") < 1) || self.ReloadDelay == 1 then self.ReloadType = 2 self:Reload() return end
end

if (self.Owner:GetAmmoCount("ar2") > 0) && (self.ReloadDelay == 0) then

self.Owner:MuzzleFlash()

if (SERVER) then
self.Owner:EmitSound( "weapons/ar2/fire1.wav", 44, math.Rand(82,120) )
end

self.Owner:RemoveAmmo( 5, self.Weapon:GetSecondaryAmmoType() )

if self.Owner:GetAmmoCount("ar2") == 35 then
self.Weapon:EmitSound( "common/warning.wav", 32, 100 )
end

self.Weapon:SetNextPrimaryFire( CurTime() + 0.21 )
self.Weapon:SetNextSecondaryFire( CurTime() + 0.1 )
self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

local bullet = {}
bullet.Num = 1
bullet.Src = self.Owner:GetShootPos()
bullet.Dir = self.Owner:GetAimVector()
bullet.Spread = Vector(0.062,0.062,0.062)
bullet.Tracer = 1
bullet.Force = math.Rand(6,10)
bullet.Damage = 0
bullet.Callback = function(attacker, trace, damageinfo) self.Trace = trace end
self.Owner:FireBullets(bullet)
util.ScreenShake( self:GetPos(), 3, 3, 0.42, 256 )

local trace = self.Trace
if trace.Hit && !trace.HitSky then

if trace.Entity:IsValid() then
if trace.Entity:GetPhysicsObject():IsValid() && !trace.Entity:IsNPC() && !trace.Entity:IsPlayer() then
trace.Entity:EmitSound( "weapons/fx/rics/ric" .. math.Round(math.Rand(1,5)) .. ".wav", 62, 100 )
if math.Round(math.Rand(1,10)) == 10 && trace.Entity:GetVelocity() == Vector(0,0,0) then
trace.Entity:GetPhysicsObject():EnableMotion(true)
trace.Entity:GetPhysicsObject():Wake()
trace.Entity:EmitSound( "ambient/explosions/explode_" .. math.Round(math.Rand(1,9)) .. ".wav", 72, 100 )
util.ScreenShake( self:GetPos(), 21, 2, 0.32, 512 )
end
end
end

local explosionsfx = EffectData()
explosionsfx:SetOrigin( trace.HitPos )
util.Effect( "freezer_minigun_airdust", explosionsfx )
util.Effect( "freezer_sniper", explosionsfx )
util.Effect( "freezer_minigun_explosion", explosionsfx )
util.BlastDamage( self.Weapon, self.Owner, trace.HitPos, 256, 1 )
util.ScreenShake( trace.HitPos, 120, 3, 1, 256 )

if (SERVER) then
WorldSound( "ambient/machines/thumper_dust.wav", trace.HitPos, 72, 100 )
WorldSound( "npc/scanner/scanner_nearmiss2.wav", trace.HitPos, 70, math.Round(math.Rand(82,112)) )
WorldSound( "ambient/levels/labs/electric_explosion1.wav", trace.HitPos, 72, math.Round(math.Rand(82,112)) )
end

if (SERVER) then
local repulse = ents.Create("env_physexplosion")
repulse:SetKeyValue("radius", 256)
repulse:SetKeyValue("magnitude", 256 )
repulse:SetKeyValue("spawnflags", "19")
repulse:SetOwner(self.Owner)
repulse:SetPos(trace.HitPos)
repulse:Fire("Explode" , "", 0)
repulse:Fire("kill","", 1)
end

end

end

end

function SWEP:Reload()

if (self.Owner:GetAmmoCount("ar2") > 74) || (self.ReloadDelay == 1) then return end

self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )

self.ReloadDelay = 1

if self.ReloadType == 1 then timer.Simple(1.76, function() self:ReloadSelf() end) end
if self.ReloadType == 2 then timer.Simple(2.1, function() self:ReloadSelf() end) end

end

function SWEP:ReloadSelf()
if (SERVER) then
ammo = math.Clamp( (75 - self.Owner:GetAmmoCount("ar2")), 0, 75)
self.Owner:GiveAmmo(ammo, "ar2")
end
self.ReloadDelay = 0
end

function SWEP:Initialize()
end

function SWEP:Deploy()
self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
self.Weapon:EmitSound( "ambient/machines/keyboard2_clicks.wav", 42, 100 )
return true
end

function SWEP:Think()
end

function SWEP:OnDrop()
self.Weapon:EmitSound( "npc/roller/mine/rmine_predetonate.wav", 62, math.Rand(90,110) )
timer.Simple(0.8, function() self:PreSelfDestruct() end)
end

function SWEP:PreSelfDestruct()
local dustfx = EffectData()
dustfx:SetOrigin( self.Weapon:GetPos() )
util.Effect( "freezer_sniper", dustfx )
timer.Simple(0.1, function() self:SelfDestruct() end)
end

function SWEP:SelfDestruct()
self.Weapon:EmitSound( "ambient/levels/labs/electric_explosion5.wav", 62, math.Rand(90,110) )
local dustfx = EffectData()
dustfx:SetOrigin( self.Weapon:GetPos() )
util.Effect( "freezer_airdust", dustfx )
util.ScreenShake( self.Weapon:GetPos(), 6, 2, 0.72, 256 )
self.Weapon:Remove()
end