


ITEM.Name = "Fruit";

ITEM.Weight = 1;
ITEM.Size = 1;
ITEM.Model = "models/props/de_inferno/crate_fruit_break_gib2.mdl";
ITEM.Usable = true;
ITEM.PickUpAble = true;

ITEM.Desc = "Fruit";

ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 50;
ITEM.FactoryStock = 20;

function ITEM:OnUse()

	self.Owner:SetNWInt( "hunger_add", self.Owner:GetNWInt( "hunger_add" ) + 5000)
	self.Owner:SetNWInt( "thirst_add", self.Owner:GetNWInt( "thirst_add" ) + 2000)

	self.Owner:SetHealth( self.Owner:Health() + 10 );
	
	local ply = self.Owner
	
			ply:EmitSound( Sound( "npc/barnacle/barnacle_crunch2.wav" ),math.random( 80, 110 ),math.random( 80, 110 ));
	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 55;
	trace.filter = ply;
	local tr = util.TraceLine( trace );
	
				local chunk1 = ents.Create("fading_prop")
				chunk1:SetPos( tr.HitPos+ Vector(math.random( -20, 20 ),math.random( -20, 20 ), 0)) 
				chunk1:SetModel( "models/props/de_inferno/crate_fruit_break_gib3.mdl" );
				chunk1:Spawn()
				
				
				
				
				
				
				
				
				
				
	
	
	
	
	
	

end

function ITEM:OnPickup()


end
