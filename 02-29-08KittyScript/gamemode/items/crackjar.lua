

ITEM.Name = "Jar O' Crack Rocks";

ITEM.Weight = .5;
ITEM.Size = 2;
ITEM.Model = "models/props_lab/jar01a.mdl";
ITEM.Usable = true;

ITEM.Desc = "Head asplode";

ITEM.BlackMarket = true;
ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 1200;
ITEM.FactoryStock = 5;


function ITEM:OnPickup()

	self.Owner:SetFOV( 160, 2.5 );
	
		
			self.Owner:SetVelocity(Vector(math.random(-500,500), math.random(-500,500), math.random(400, 500)))
	
	self.Owner:EmitSound(Sound("ambient/wind/wind_hit2.wav"),50,60)
	self.Owner:EmitSound(Sound( "npc/stalker/breathing3.wav" ),20,60)
	self.Owner:EmitSound(Sound( "npc/stalker/breathing3.wav" ),30,100)
	self.Owner:EmitSound(Sound( "vo/npc/barney/ba_letsdoit.wav" ),100,60)
	self.Owner:EmitSound(Sound( "npc/stalker/go_alert2a.wav" ),60,50)
	  	self.Owner:ConCommand("+left")
	
	timer.Simple( 7, self.Owner.SetFOV, self.Owner, 90, 0.5 );
	
			timer.Simple( 7, self.Owner.ConCommand, self.Owner, "-left\n" );
	
	timer.Simple( 7, self.Owner.EmitSound, self.Owner, Sound( "npc/stalker/go_alert2a.wav" ) );
	timer.Simple( 3, self.Owner.EmitSound, self.Owner, Sound( "npc/stalker/breathing3.wav" ) );
	self.Owner:SetNWInt("money", self.Owner:GetNWInt( "money" ) + 50)	
end

