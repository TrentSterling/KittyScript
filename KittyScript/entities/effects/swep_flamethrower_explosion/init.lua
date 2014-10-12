function EFFECT:Init( data )

util.PrecacheSound("ambient/fire/ignite.wav")

WorldSound( "ambient/fire/ignite.wav", self:GetPos(), 54, math.random(82,112) )

local Pos = data:GetOrigin()

	local emitter = ParticleEmitter(Pos)
	
		for i=0, 16 do
		
			local particle = emitter:Add( "effects/muzzleflash" .. math.random(2,3) .. "", Pos )
			if (particle) then
				
				particle:SetVelocity( VectorRand() * 172 )
				
				particle:SetLifeTime( 0 )
				particle:SetDieTime( 0.72 )
				
				particle:SetStartAlpha( 182 )
				particle:SetEndAlpha( 0 )
				
				particle:SetStartSize( 0 )
				particle:SetEndSize( 64 )
				
				particle:SetRoll( math.Rand(-210, 210) )
				particle:SetRollDelta( math.Rand(-3.2, 3.2) )
				
				particle:SetAirResistance( 350 )
				
				particle:SetGravity( Vector( 0, 0, 64 ) )
			
			end
			
		end
		
	emitter:Finish()
	return true

end

function EFFECT:Think( )
end

function EFFECT:Render()
end