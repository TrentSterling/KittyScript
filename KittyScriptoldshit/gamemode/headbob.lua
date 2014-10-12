
local PlayerMeta = FindMetaTable("Player")--get the players
function PlayerMeta:HeadshotAngles()
 	self:GetTable().HeadShotStart = self:GetTable().HeadShotStart or 0
 	self:GetTable().HeadShotRoll = self:GetTable().HeadShotRoll or 0
 	self:GetTable().HeadShotRoll = math.Approach( self:GetTable().HeadShotRoll, 0.0, 40.0 * FrameTime() )
 	local roll = self:GetTable().HeadShotRoll
 	local Time = (CurTime() - self:GetTable().HeadShotStart) * 10
 	return Angle( math.sin( Time ) * roll * 0.5, 0, math.sin( Time * 2 ) * roll * -1 )
end
local WalkTimer = 0
local VelSmooth = 0

//Head bob--Make it TOGGLE!--ADD INJURY MODE
function GM:CalcView( ply, origin, angle, fov )
 	local vel = ply:GetVelocity()
 	local ang = ply:EyeAngles()

 	VelSmooth = VelSmooth * 0.9 + vel:Length() * 0.1

 	WalkTimer = WalkTimer + VelSmooth * FrameTime() * 0.05

 	-- Roll on strafe
	if ( ply:GetNWInt("togglebob") == 1 ) then
		angle.roll = angle.roll + ang:Right():DotProduct( vel ) * 0.01
	end

 	-- Roll on steps
	
	if ( ply:GetNWInt("togglebob") == 1 ) then
	 	if ( ply:GetGroundEntity() != NULL ) then
	 		angle.roll = angle.roll + math.sin( WalkTimer ) * VelSmooth * 0.005
	 		angle.pitch = angle.pitch + math.sin( WalkTimer * 0.5 ) * VelSmooth * 0.005
	 	end
	end
 	angle = angle + ply:HeadshotAngles()
 	return self.BaseClass:CalcView( ply, origin, angle, fov )
end
