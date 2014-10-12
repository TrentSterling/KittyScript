

ITEM.Name = "SMG Ammunition";

ITEM.Weight = 3;
ITEM.Size = 0;
ITEM.Model = "models/Items/BoxSRounds.mdl";
ITEM.Usable = false;

ITEM.Desc = "Ammo for pew pew lazurz";

ITEM.BlackMarket = true;
ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 70;
ITEM.FactoryStock = 4;
ITEM.PickUpAble = true;
ITEM.BigWeapon = true;


function ITEM:OnPickup()
	
	self.Owner:GiveAmmo(80, "smg1")

	
end