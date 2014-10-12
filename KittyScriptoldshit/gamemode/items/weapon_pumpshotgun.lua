

ITEM.Name = "Pump Shotty";

ITEM.Weight = 3;
ITEM.Size = 0;
ITEM.Model = "models/weapons/w_shot_m3super90.mdl";
ITEM.Usable = false;

ITEM.Desc = "weapon_pumpshotgun";

ITEM.BlackMarket = true;
ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 700;
ITEM.FactoryStock = 4;
ITEM.PickUpAble = true;
ITEM.BigWeapon = true;
ITEM.WeaponName = "weapon_pumpshotgun";--Must have for big weapons



function ITEM:OnPickup()
	
	self.Owner:Give( "weapon_pumpshotgun" );

	
end