

ITEM.Name = "Baby Food!";
ITEM.Usable = true;
ITEM.Size = 2;
ITEM.Weight = 5;
ITEM.Model = "models/props_c17/doll01.mdl";

function ITEM:OnUse()

	self.Owner:SetHealth( 200 );

end