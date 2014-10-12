

ITEM.Name = "MP5";

ITEM.Weight = 3;
ITEM.Size = 0;
ITEM.Model = "models/weapons/w_smg_mp5.mdl";
ITEM.Usable = false;

ITEM.Desc = "Combine sniper";

ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 700;
ITEM.FactoryStock = 4;
ITEM.PickUpAble = true;
ITEM.BigWeapon = true;
ITEM.WeaponName = "weapon_mp5";--Must have for big weapons
ITEM.MarketType = "BlackMarket";



function ITEM:OnPickup()
	
	self.Owner:Give( "weapon_mp5" );

	
end