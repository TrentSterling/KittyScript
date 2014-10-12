
ITEM.Name = "Dime Bag";

ITEM.Weight = 1;
ITEM.Size = 1;
ITEM.Model = "models/katharsmodels/contraband/zak_wiet/zak_wiet.mdl";
ITEM.Usable = true;
ITEM.PickUpAble = true;

ITEM.Desc = "Shitchyeahhh";


function ITEM:OnPickup()
	self.Owner:SetNWInt("money", self.Owner:GetNWInt( "money" ) + 500)	
end
