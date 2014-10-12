function EFFECT:Init( data )
	
	local NumParticles1 = 6

	util.PrecacheSound("npc/manhack/mh_blade_snick1.wav")

	WorldSound( "npc/manhack/mh_blade_snick1.wav", data:GetOrigin(), 35, math.Round(math.Rand(90,110)) )

	local emitter1 = ParticleEmitter(data:GetOrigin())
	
		for i=0, NumParticles1 do

			local Pos = ( data:GetOrigin() )
		
			local particle = emitter1:Add( "particle/particle_smokegrenade", Pos )
			if (particle) then
				
				particle:SetVelocity( VectorRand() * math.Rand(320,420) )
				
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand(7, 9) )
				
				particle:SetStartAlpha( math.Rand(4,6) )
				particle:SetEndAlpha( 0 )
				
				particle:SetStartSize( math.Rand(52, 112) )
				particle:SetEndSize( math.Rand(42, 112) )
				
				particle:SetRoll( math.Rand(-360, 360) )
				particle:SetRollDelta( math.Rand(-1.2, 1.2) )
				
				particle:SetAirResistance( math.Rand(520,620) )
				
				particle:SetGravity( Vector( 0, 0, math.Rand(-64, -256) ) )
			
			end
			
		end
		
	emitter1:Finish()

	local NumParticles2 = 8
	
	local emitter2 = ParticleEmitter( data:GetOrigin() )
	
		for i=0, NumParticles2 do

			local Pos = ( data:GetOrigin() + Vector( math.Rand(-32,32), math.Rand(-32,32), math.Rand(-32,32) ) )
		
			local particle = emitter2:Add( "particle/particle_smokegrenade", Pos )
			if (particle) then
				
				particle:SetVelocity( VectorRand() * math.Rand(620,820) )
				
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand(3.2, 4.2) )
				
				particle:SetStartAlpha( math.Rand(8,10) )
				particle:SetEndAlpha( 0 )
				
				local Size = math.Rand(42,82)
				particle:SetStartSize( Size )
				particle:SetEndSize( Size )
				
				particle:SetRoll( math.Rand(-160, 160) )
				particle:SetRollDelta( math.Rand(-0.21, 0.21) )
				
				particle:SetAirResistance( math.Rand(420,620) )
				
				particle:SetGravity( Vector( 0, 0, math.Rand(-210, -320) ) )
			
			end
			
		end
		
	emitter2:Finish()
	
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render()
end