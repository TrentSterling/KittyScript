
--Entirely serverside.

ITEM.Name = "Bottle O' Cyanide";
ITEM.Usable = true;
ITEM.Size = 1;
ITEM.Weight = .1;
ITEM.Model = "models/props_junk/garbage_glassbottle001a.mdl";
ITEM.PickUpAble = true;

ITEM.Desc = "This shit'll kill ya";

ITEM.BlackMarket = true;
ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 50;
ITEM.FactoryStock = 5;

function ITEM:OnUse()

	self.Owner:Kill();

end