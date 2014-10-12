


ITEM.Name = "Watermelon";

ITEM.Weight = 1;
ITEM.Size = 1;
ITEM.Model = "models/props_junk/watermelon01.mdl";
ITEM.Usable = true;
ITEM.PickUpAble = true;

ITEM.Desc = "Watermelon";

ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 50;
ITEM.FactoryStock = 20;

function ITEM:OnUse()

	self.Owner:SetHealth( self.Owner:Health() + 10 );

end

function ITEM:OnPickup()

	self.Owner:SetNWInt( "hunger_add", self.Owner:GetNWInt( "hunger_add" ) + 5000)

	self.Owner:SetHealth( self.Owner:Health() + 10 );

end
