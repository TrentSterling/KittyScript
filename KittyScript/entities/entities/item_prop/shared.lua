ENT.Type = "anim"
ENT.Base = "base_gmodentity"

function ENT:GetItemName()

	return self.Entity:GetNWString( "Name" );

end

function ENT:GetItemSize()

	return math.Round( self.Entity:GetNWFloat( "Size" ) * 100 ) / 100;

end