function EFFECT:Init( data )

local HitPos = data:GetOrigin()
local Weapon = data:GetEntity()
local Attachment = data:GetAttachment()
local StartPos = self:GetTracerShootPos( self.Position, Weapon, Attachment )

if Weapon:IsValid() then

local emitter = ParticleEmitter(StartPos)

for i=0, 8 do

		local particle = emitter:Add( "effects/muzzleflash" .. math.random(2,3) .. "", StartPos )
		if (particle) then
	
			particle:SetVelocity( ((HitPos - StartPos):GetNormal() * math.random(1720,1820)) + (VectorRand() * math.random(142,172)) )

			particle:SetLifeTime( 0 )
			particle:SetDieTime( 0.52 )

			particle:SetStartAlpha( math.random(82,112) )
			particle:SetEndAlpha( 0 )

			particle:SetStartSize( math.random(4,6) )
			particle:SetEndSize( math.random(32,52) )

			particle:SetRoll( math.Rand(-360, 360) )
			particle:SetRollDelta( math.Rand(-7.2, 7.2) )

			particle:SetAirResistance( math.random(128, 256) )

			particle:SetCollide( true )

			particle:SetGravity( Vector( 0, 0, 64 ) )

		end
end

	emitter:Finish()

end
end

function EFFECT:Think()
end

function EFFECT:Render()
end