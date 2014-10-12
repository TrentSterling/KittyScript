EFFECT.Time = 1

function EFFECT:Init( data )

	self.Pos = data:GetOrigin()
	
end

function EFFECT:Think( )

if self.Time < 2 then

	self.Count = CurTime()
	self.Time = self.Time + 1

	local NumParticles = 64

	local emitter = ParticleEmitter(self.Pos)
	
		for i=0, NumParticles do

			local Pos = (self.Pos)
		
			local particle = emitter:Add( "effects/muzzleflash2", Pos )
			if (particle) then
				
				particle:SetVelocity( VectorRand() * 128 )
				
				particle:SetLifeTime( 0 )
				particle:SetDieTime( 0.82 )
				
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 0 )
				
				particle:SetStartSize( 0 )
				particle:SetEndSize( 32 )
				
				particle:SetRoll( math.Rand(-210, 210) )
				particle:SetRollDelta( math.Rand(-3.2, 3.2) )
				
				particle:SetAirResistance( 120 )
				
				particle:SetGravity( Vector( 0, 0, 112 ) )
			
			end
			
		end
		
	emitter:Finish()
	return true

end

if self.Time >= 2 then
return false
end

end

function EFFECT:Render()
end