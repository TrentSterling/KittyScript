
AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( "shared.lua" );

function ENT:Initialize()

	self.Entity:PhysicsInit( SOLID_VPHYSICS );
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS );
	self.Entity:SetSolid( SOLID_VPHYSICS );
	  
	local phys = self.Entity:GetPhysicsObject();
	  
	if( phys:IsValid() ) then
	  phys:Wake();
	 end
  
end

function ENT:SetData( data )

	self.Entity:GetTable().Data = data;
	
	self.Entity:SetNWString( "Name", data.Name );
	self.Entity:SetNWFloat( "Size", data.Size );

end

function ENT:GiveTo( ply )
	
	if( self.Entity:GetTable().Data and self.Entity:GetTable().Data.Wearable ) then
	
		if( ply:HasItem( self.Entity:GetTable().Data.UniqueID ) ) then
			if( ply:HasRoomForItem( self.Entity:GetTable().Data.UniqueID ) ) then
				self.Entity:Remove();
			end
		else
			self.Entity:Remove();
		end
	
	elseif( self.Entity:GetTable().Data and ply:HasRoomForItem( self.Entity:GetTable().Data.UniqueID ) ) then
		self.Entity:Remove();
	end

	if( self.Entity:GetTable().Data ) then
		ply:GiveItem( self.Entity:GetTable().Data.UniqueID );
	end
	
end 

function ENT:Touch( ent )

	if( self.Entity:GetTable().Data ) then
	
		if( self.Entity:GetTable().Data.OnTouch ) then
		
			self.Entity:GetTable().Data.OnTouch( self.Entity:GetTable().Data, ent );
		
		end
	
	end

end