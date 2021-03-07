local obj_arrow = Material( "sog/arrow1.png" )

function EFFECT:Init( data )
	
	self.Target = data:GetEntity()
	
	self.Entity:SetRenderBounds(Vector(-360,-360,0),Vector(360,360,360))
	
	print(self.Target)
	
end

function EFFECT:Think()
	return self.Target and self.Target:IsValid()
end

function EFFECT:Render()
	
	if self.Target and self.Target:IsValid() then
			
		local r = 0.5*math.sin(RealTime()*1)*255 + 255/2
		local g = -0.5*math.sin(RealTime()*1)*255 + 255/2
		local b = 210
		
		local pos = LocalPlayer():GetPos() + vector_up * 2
		local endpos = self.Target:GetPos() + vector_up * 2

		local dir = ( pos - endpos ):GetNormal()
		local ang = dir:Angle()
		//ang.p = 0
		
		cam.Start3D2D(pos - dir*40, ang, 0.1)
			surface.SetMaterial( obj_arrow )
			surface.SetDrawColor( r, g, b, 255 )
			surface.DrawTexturedRectRotated( 0, 0, 180, 110, 180 )
			surface.DrawTexturedRectRotated( 0, 0, 180, 110, 180 )
		cam.End3D2D()
	end
	
end