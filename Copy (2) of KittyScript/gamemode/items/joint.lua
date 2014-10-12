


ITEM.Name = "Joint";

ITEM.Weight = 1;
ITEM.Size = 1;
ITEM.Model = "models/katharsmodels/contraband/jointjes/jointjes.mdl";
ITEM.Usable = true;
ITEM.PickUpAble = true;

ITEM.Desc = "Shitchyeahhh";

ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 50;
ITEM.FactoryStock = 20;

function ITEM:OnUse()

	self.Owner:SetHealth( self.Owner:Health() + 10 );

end

function ITEM:OnPickup()

	self.Owner:SetFOV( 60, 2.5 );
		
	self.Owner:SetHealth( self.Owner:Health() + 10 );
	timer.Simple( 5, self.Owner.SetFOV, self.Owner, 90, 3.5 );
end
