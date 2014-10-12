

ITEM.Name = "Shotty Ammunition";

ITEM.Weight = 3;
ITEM.Size = 0;
ITEM.Model = "models/Items/BoxBuckshot.mdl";
ITEM.Usable = false;

ITEM.Desc = "Ammo for pew pew lazurz";

ITEM.BlackMarket = true;
ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 70;
ITEM.FactoryStock = 4;
ITEM.PickUpAble = true;
ITEM.BigWeapon = true;


function ITEM:OnPickup()
	
	self.Owner:GiveAmmo(16, "buckshot")

	
end