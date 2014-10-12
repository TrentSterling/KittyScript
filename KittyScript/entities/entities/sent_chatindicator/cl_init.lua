

include("shared.lua")

function ENT:Draw()

	local text = self.Entity:GetNetworkedString("text") or ""
	
	if string.len( (text or "") ) > 20 then // this is so badly done, but works...sorta
		V = text:sub( 1, 20 )
		V2 = text:sub( 21 )
	else
		V = text
		V2 = ""
	end

	local ang = self.Entity:GetAngles()
	local Res = 0.1
	local rot = Vector(-90,90,0)
	ang:RotateAroundAxis(ang:Right(), 	rot.x)
	ang:RotateAroundAxis(ang:Up(), 		rot.y)
	ang:RotateAroundAxis(ang:Forward(), rot.z)
	
	local pos = self.Entity:GetPos() + ( (self.Entity:EyeAngles():Forward()) * 3.5 ) - Vector( 0, 0, 5 )//* 50 
		
		cam.Start3D2D(pos,ang,Res)
			local ply = ( self.Entity:GetNetworkedEntity( "textplayer" ) or LocalPlayer() )
			local colour // yeah i'm aussie, stfu

				colour = ( Color(255,255,255,255) )
//backer
			draw.RoundedBox(4, (-70)-53 , (-110)+30-(75), 6 + 245 /*(string.len( (V or "" ) ) * 12)*/ , 66 , Color(0, 0, 0, 200))
			
			draw.RoundedBox(4, (-70)-49 , (-110)+30-(75), 245 /*(string.len( (V or "" ) ) * 12)*/ , 30 , Color(25, 25, 25, 200))
			draw.DrawText(V,"ChatFont",(-60)-50,(-103)+30-(75), colour,0)
			
			draw.RoundedBox(4, (-70)-49 , (-110)+62-(75), 245 /*(string.len( (V2 or "" ) ) * 12)*/ , 30 , Color(25, 25, 25, 200))
			draw.DrawText(V2,"ChatFont",(-60)-48,(-103)+62-(75), colour,0)
		cam.End3D2D()
			
		
end



