AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()   
BirdModels = {
"models/crow.mdl",
"models/pigeon.mdl",
"models/pigeon.mdl"
}
	self.Entity:SetModel( BirdModels[math.random(3)] ) 	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )    
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )   
	self.Entity:SetSolid( SOLID_VPHYSICS )      

	local phys = self.Entity:GetPhysicsObject()  	
	if (phys:IsValid()) then  		
		phys:Wake()
	end 
self.Entity:SetPhysicsAttacker(self.Entity:GetOwner())
if self.Entity:GetOwner().BirdTarget != nil then
self.Entity.Target = self.Entity:GetOwner().BirdTarget
self.Entity:GetOwner().BirdTarget = nil
self.Entity:GetPhysicsObject():EnableGravity(false)
timer.Simple(15,self.Explode,self)
else 
timer.Simple(4,self.Fade,self)
end
end

function ENT:Think()
if self.Entity.Removing == true then
local r,g,b,a = self.Entity:GetColor()
local newa = a - 5
self.Entity:SetColor(r,g,b,newa)
if newa <= 120 then
self.Entity:Remove()
end
end
if self.Entity.Target != nil then
self.Entity:PointAtEntity( self.Entity.Target )
self.Entity:GetPhysicsObject():ApplyForceCenter( self.Entity:GetForward() * 550 )
self.Entity:NextThink(CurTime())
else 
local sequence = self.Entity:LookupSequence("reference")
self.Entity:SetSequence(sequence) 
end
end

function ENT:PhysicsCollide( )
self.Entity:Explode()
end

function ENT:Explode()
if self.Entity then
util.BlastDamage( self.Entity, self.Entity:GetOwner(), self.Entity:GetPos(), 256, 100 )
 local effectdata = EffectData()
 effectdata:SetStart( self.Entity:GetPos() )
 effectdata:SetOrigin( self.Entity:GetPos() )
 effectdata:SetScale( 2 )
 util.Effect( "Explosion", effectdata ) 
 
 self.Entity:Remove()
 end
 end
function ENT:Fade()
if self.Entity then
self.Entity.Removing = true
end
end

function ENT:OnRemove() 
end
