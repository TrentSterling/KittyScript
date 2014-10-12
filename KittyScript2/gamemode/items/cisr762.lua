

ITEM.Name = "Combine CISR-762";

ITEM.Weight = 3;
ITEM.Size = 0;
ITEM.Model = "models/weapons/w_msg90.mdl";
ITEM.Usable = false;

ITEM.Desc = "Combine sniper";

ITEM.BlackMarket = true;
ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 7000;
ITEM.FactoryStock = 4;
ITEM.PickUpAble = true;
ITEM.BigWeapon = true;


function ITEM:OnPickup()
	
	self.Owner:Give( "weapon_ks_combinesniper" );

	
end