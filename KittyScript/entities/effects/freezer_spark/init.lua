local matRefraction	= Material( "sprites/light_glow02_add" )

function EFFECT:Init( data )

	self.Refract = 0
	
	self.Size = 6
	
	self.Entity:SetRenderBounds( Vector()*-32, Vector()*32 )
	
end

function EFFECT:Think()

	self.Refract = self.Refract + 3.62 * FrameTime()
	self.Size = ( 6 * (1)/(self.Refract ) ) - self.Refract * 6
	
	if ( self.Refract >= 1 ) then return false end
	
	return true
	
end

function EFFECT:Render()

	local Distance = EyePos():Distance( self.Entity:GetPos() )
	local Pos = self.Entity:GetPos() + (EyePos()-self.Entity:GetPos()):GetNormal() * Distance * (self.Refract^(0.32)) * 0.72

	matRefraction:SetMaterialFloat( "$refractamount", math.sin( self.Refract * math.pi ) * 0.032 )
	render.SetMaterial( matRefraction )
	render.UpdateRefractTexture()
	render.DrawSprite( Pos, self.Size, self.Size )

end