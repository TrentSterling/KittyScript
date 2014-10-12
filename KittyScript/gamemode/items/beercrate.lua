


ITEM.Name = "Crate O' Beer";

ITEM.Weight = 1;
ITEM.Size = 1;
ITEM.Model = "models/props/CS_militia/caseofbeer01.mdl";
ITEM.Usable = true;
ITEM.PickUpAble = true;

ITEM.Desc = "LETS GO GET SOME BEEEEEEEEER";

ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 50;
ITEM.FactoryStock = 20;

function ITEM:OnUse()
	self.Owner:SetNWInt( "thirst_add", self.Owner:GetNWInt( "thirst_add" ) + 6000)

	self.Owner:SetHealth( self.Owner:Health() + 10 );
	
	
	local ply = self.Owner
	
			ply:EmitSound( Sound( "npc/barnacle/barnacle_gulp2.wav" ),math.random( 80, 110 ),math.random( 80, 110 ));
	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + ply:GetAimVector() * 55;
	trace.filter = ply;
	local tr = util.TraceLine( trace );
	for i=0, 5 do
					local chunk1 = ents.Create("fading_prop")
				chunk1:SetPos( tr.HitPos+ Vector(math.random( -20, 20 ),math.random( -20, 20 ), 0)) 
				chunk1:SetModel( "models/props/CS_militia/bottle01.mdl" );
				chunk1:Spawn()
				
									local chunk2 = ents.Create("fading_prop")
				chunk2:SetPos( tr.HitPos+ Vector(math.random( -20, 20 ),math.random( -20, 20 ), 0)) 
				chunk2:SetModel( "models/props/CS_militia/bottle02.mdl" );
				chunk2:Spawn()
				
									local chunk3 = ents.Create("fading_prop")
				chunk3:SetPos( tr.HitPos+ Vector(math.random( -20, 20 ),math.random( -20, 20 ), 0)) 
				chunk3:SetModel( "models/props/CS_militia/bottle03.mdl" );
				chunk3:Spawn()
	end

end

function ITEM:OnPickup()



end
