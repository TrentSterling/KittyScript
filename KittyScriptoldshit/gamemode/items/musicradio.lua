
ITEM.Name = "Radio";

ITEM.Weight = 1;
ITEM.Size = 1;
ITEM.Model = "models/props_lab/citizenradio.mdl";
ITEM.Usable = true;
ITEM.PickUpAble = true;
ITEM.FactoryBuyable = true;
ITEM.MarketType = "Electronics";

ITEM.FactoryPrice = 250;



ITEM.Desc = "MUZAK!";


function ITEM:OnPickup()
	self.Owner:EmitSound( Sound("music/hl1_song25_remix3.mp3") );

end

function ITEM:Use()
	self.Owner:SetNWInt("money", self.Owner:GetNWInt( "money" ) + 5000)	
end
