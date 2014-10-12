AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include("shared.lua")


function ENT:Initialize()


	self.Entity:SetModel( Model( "models/extras/info_speech.mdl" ) )
	self.Entity:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self.Entity:SetColor(255, 255, 255, 175)
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableCollisions( false )		
	end

	self.Entity:SetNotSolid( true )
	

end


function ENT:Think()
	if self.player && self.player:IsValid() then
		self.Entity:SetAngles( self.player:GetAngles() )
	end
end


