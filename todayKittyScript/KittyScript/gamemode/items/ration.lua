
ITEM.Name = "Combine Ration";

ITEM.Weight = 1;
ITEM.Size = 1;
ITEM.Model = "models/weapons/w_package.mdl";
ITEM.Usable = true;
ITEM.PickUpAble = true;

ITEM.Desc = "Combine issued ration containing necessary food and tokens";


function ITEM:OnPickup()
	self.Owner:SetNWInt("money", self.Owner:GetNWInt( "money" ) + 50)	
end

function ITEM:Use()
	self.Owner:SetNWInt("money", self.Owner:GetNWInt( "money" ) + 5000)	
end
