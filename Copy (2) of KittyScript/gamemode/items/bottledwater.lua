


ITEM.Name = "Bottled Water";

ITEM.Weight = 1;
ITEM.Size = 1;
ITEM.Model = "models/props_junk/GlassBottle01a.mdl";
ITEM.Usable = true;
ITEM.PickUpAble = true;

ITEM.Desc = "Water in a bottle";

ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 50;
ITEM.FactoryStock = 20;

function ITEM:OnUse()

	self.Owner:SetHealth( self.Owner:Health() + 10 );

end

function ITEM:OnPickup()

	self.Owner:SetNWInt( "thirst_add", self.Owner:GetNWInt( "thirst_add" ) + 6000)

	self.Owner:SetHealth( self.Owner:Health() + 10 );

end
