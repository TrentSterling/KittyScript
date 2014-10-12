

ITEM.Name = "MP5";

ITEM.Weight = 3;
ITEM.Size = 0;
ITEM.Model = "models/weapons/w_smg_mp5.mdl";
ITEM.Usable = false;

ITEM.Desc = "Combine sniper";

ITEM.BlackMarket = true;
ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 70;
ITEM.FactoryStock = 4;
ITEM.PickUpAble = true;
ITEM.BigWeapon = true;
ITEM.WeaponName = "weapon_mp5";--Must have for big weapons



function ITEM:OnPickup()
	
	self.Owner:Give( "weapon_mp5" );

	
end