local obj_arrow = Material( "sog/arrow1.png" )

function EFFECT:Init( data )
	
	local pos = data:GetOrigin()+vector_up*2
	local endpos = data:GetStart()+vector_up*2
	
	local duration = data:GetScale()

	self.ActualDuration = duration
	self.Duration = CurTime() + duration
	self.Pos = pos
	self.EndPos = endpos

end

function EFFECT:Think()
	return CurTime() < self.Duration
end

function EFFECT:Render()
	
	local delta = math.Clamp((self.Duration - CurTime()) / self.ActualDuration, 0, 1)
	
	local r = 0.5*math.sin(RealTime()*1)*255 + 255/2
	local g = -0.5*math.sin(RealTime()*1)*255 + 255/2
	local b = 210

	local ang = (self.Pos-self.EndPos):GetNormal():Angle()
	
	cam.Start3D2D(self.Pos, ang, 0.5)
		surface.SetMaterial( obj_arrow )
		surface.SetDrawColor( r, g, b, delta * 255 )
		surface.DrawTexturedRectRotated( 0, 0, 180, 110, 180 )
		surface.DrawTexturedRectRotated( 0, 0, 180, 110, 180 )
	cam.End3D2D()
	
end