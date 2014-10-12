EFFECT.Count = 0
EFFECT.Ent = nil
EFFECT.Time = 1

function EFFECT:Init(data)
self.Ent = data:GetEntity()
end

function EFFECT:Think()
	
if self.Ent && self.Ent:IsValid() && (self.Time < 32) then
	if self.Count + 0.1 < CurTime() then

	self:Emit()
	self.Count = CurTime()
	self.Time = self.Time + 1

end

self.Entity:NextThink(CurTime())
return true

else return false

end
end

function EFFECT:Emit()

if self.Time < 17 then

local emitter = ParticleEmitter(self.Ent:GetPos(),false)

for i=0, 32 do
	local particle
	local HalfTime = self.Time/2
	particle = emitter:Add("effects/muzzleflash2" , self.Ent:GetPos() + Vector(math.Rand(-32, 32), math.Rand(-32, 32), math.Rand(-32, 32)) )
	if particle then

		particle:SetVelocity(Vector( math.Rand(-120, 120), math.Rand(-120, 120), math.Rand(-120, 120) ))
		particle:SetLifeTime(0)
		particle:SetDieTime(math.Rand( 0.72, 1.2 ))

		particle:SetStartAlpha(math.Clamp(( 272 - (self.Time * 16) ),0,255))
		particle:SetEndAlpha(0)

		particle:SetStartSize(0)
		particle:SetEndSize(32)

		particle:SetAirResistance(120)

		particle:SetRoll( math.Rand(-210, 210) )
		particle:SetRollDelta( math.Rand(-3.2, 3.2) )

		particle:SetGravity( Vector( 0, 0, 128 ) )

	end
end
end

if self.Time > 18 then
return false
end

end

function EFFECT:Render()
end