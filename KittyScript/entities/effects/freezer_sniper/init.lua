local matRefraction	= Material( "refract_ring" )

function EFFECT:Init( data )

	self.Refract = 0
	
	self.Size = 32
	
	self.Entity:SetRenderBounds( Vector()*-128, Vector()*128 )
	
end

function EFFECT:Think()

	self.Refract = self.Refract + 3.72 * FrameTime()
	self.Size = ( 32 * (1)/(self.Refract ) ) - self.Refract * 32
	
	if ( self.Refract >= 1 ) then return false end
	
	return true
	
end

function EFFECT:Render()

	local Distance = EyePos():Distance( self.Entity:GetPos() )
	local Pos = self.Entity:GetPos() + (EyePos()-self.Entity:GetPos()):GetNormal() * Distance * (self.Refract^(0.32)) * 0.72

	matRefraction:SetMaterialFloat( "$refractamount", math.sin( self.Refract * math.pi ) * 0.042 )
	render.SetMaterial( matRefraction )
	render.UpdateRefractTexture()
	render.DrawSprite( Pos, self.Size, self.Size )

end