
AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( "shared.lua" );

function ENT:Initialize()
	self.Entity:PhysicsInit( SOLID_VPHYSICS );
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS );
	self.Entity:SetSolid( SOLID_VPHYSICS );
	self.Entity:SetCollisionGroup(COLLISION_GROUP_WORLD);
	self.Entity.entalpha = 255
	--self.Entity:SetColor(255, 255, 255, 50)
	  
	local phys = self.Entity:GetPhysicsObject();
	  
	if( phys:IsValid() ) then
	  phys:Wake();
	 end
end





function ENT:Think( ent )

			
			if(self.Entity.entalpha >= 1)then
				self.Entity.entalpha = self.Entity.entalpha - 5
				self.Entity:SetColor(255, 255, 255, self.Entity.entalpha)
			end
			if(self.Entity.entalpha < 1)then
					self.Entity:Remove();
			end

	--ent:SetVelocity( Vector(0,0,0) )
--	ent::Freeze(true)
	--	ent:Sleep()

--	if( self.Entity:GetTable().Data ) then
	
--		if( self.Entity:GetTable().Data.OnTouch ) then
		
	--		self.Entity:GetTable().Data.OnTouch( self.Entity:GetTable().Data, ent );
		
	--	end
	
	--end

end



function ENT:Touch( ent )
	--ent:SetVelocity( Vector(0,0,0) )
--	ent::Freeze(true)
	--	ent:Sleep()

--	if( self.Entity:GetTable().Data ) then
	
--		if( self.Entity:GetTable().Data.OnTouch ) then
		
	--		self.Entity:GetTable().Data.OnTouch( self.Entity:GetTable().Data, ent );
		
	--	end
	
	--end

end
