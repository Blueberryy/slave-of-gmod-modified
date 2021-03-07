local trace = { mask = MASK_SOLID }
function EFFECT:Init( data )
	
	self:SetRenderBounds( Vector( -2000, -2000, -2000 ), Vector( 2000, 2000, 2000 ) )
	
	self.Origin = data:GetOrigin()
	self.Origin = self.Origin + vector_up * math.random ( 2000, 3000 )
	
	self.Bolts = {}
	
	self.LifeTime = math.random( 2, 3 )
	
	self.Amount = math.random( 4, 9 )
	
	local dlight = DynamicLight( 1000 + math.random( 10 ) )
	if ( dlight ) then
		local size = 2000
		dlight.Pos = self.Origin - vector_up * 1000
		dlight.r = 255
		dlight.g = 255
		dlight.b = 255
		dlight.Brightness = math.random( 11, 15 )
		dlight.Size = size
		dlight.Decay = size * 1
		dlight.DieTime = CurTime() + self.LifeTime * 0.8
		dlight.Style = 0
		dlight.nomodel = true
	end
	
	for i=1, self.Amount do
		
		local top_vec = VectorRand( -2000, 2000 )
		top_vec.z = 0
		
		local bottom_vec = VectorRand( -200, 200 )
		bottom_vec.z = 0
		
		local bits = math.random( 11, 17 )
		
		self.Bolts[ i ] = {}
		
		trace.start = self.Origin + top_vec
		trace.endpos = trace.start - vector_up * 500 + bottom_vec
		
		local tr = util.TraceLine( trace )
		
		self.Bolts[ i ].points = {}
		self.Bolts[ i ].bits = bits * 1
		
		self.Bolts[ i ].drawtime = CurTime() + math.Rand( 0.2, 1 ) * self.LifeTime
		
		local dist = trace.start:Distance( tr.HitPos )
		
		local cur_pos = trace.start * 1
		local next_pos
		
		for k=1, bits do
			next_pos = cur_pos + ( dist / bits ) * k * tr.Normal + VectorRand( -200, 200 )
			self.Bolts[ i ].points[ k ] = { cur_pos, next_pos }
			
			cur_pos = next_pos * 1
		end
	
	end
	
	self.DieTime = CurTime() + self.LifeTime

end

function EFFECT:Think()
	return self.DieTime and self.DieTime > CurTime()
end

local mat_beam = Material( "sprites/physbeama" )
local mat_beam2 = Material( "effects/tool_tracer" )
local mat_beam3 = Material( "effects/laser_citadel1" )

local glow = Material( "sprites/physg_glow1" )

local math_Rand = math.Rand
local math_Clamp = math.Clamp

local vec_rand = VectorRand
local color_white = color_white

local render_SetMaterial = render.SetMaterial
local render_DrawSprite = render.DrawSprite
local render_DrawBeam = render.DrawBeam

function EFFECT:Render()
	
	if self.Bolts and self.Amount then
	
		local mini_rand = math_Rand( -1, 1 )
	
		for i=1, self.Amount do
			
			local tbl = self.Bolts[ i ]
			
			if tbl.drawtime and tbl.drawtime < CurTime() then continue end
			
			local col = color_white
			
			col.a = 255 * ( math_Clamp( tbl.drawtime - CurTime(), 0, 1 ) ^ 0.1 )
			
			local tex_offset
			
			local offset = vector_origin
			local next_offset

			for k=1, tbl.bits do
				
				if tbl.points[ k ] then
					tex_offset = tex_offset or RealTime()*0.8
					next_offset = vec_rand( -1 * k, 1 * k )
					
					render_SetMaterial( glow )
					if k == 1 then
						render_DrawSprite( tbl.points[ k ][ 1 ], 2610 + mini_rand * 30, 450 + mini_rand * 20, col )
						render_DrawSprite( tbl.points[ k ][ 1 ], 910 + mini_rand * 30, 250 + mini_rand * 20, col )
					else
						render_DrawSprite( tbl.points[ k ][ 1 ] + offset, 80 + mini_rand * 20, 80 + mini_rand * 20, col )
					end
					
					render_SetMaterial( mat_beam )
					render_DrawBeam( tbl.points[ k ][ 1 ] + offset, tbl.points[ k ][ 2 ] + next_offset, 44 - i, tex_offset, tex_offset - 0.3, col )
					render_SetMaterial( mat_beam2 )
					render_DrawBeam( tbl.points[ k ][ 1 ] + offset * 1.5, tbl.points[ k ][ 2 ] + next_offset * 1.5, 34 - i, tex_offset, tex_offset - 0.4, col )
					render_SetMaterial( mat_beam3 )
					render_DrawBeam( tbl.points[ k ][ 1 ] + offset, tbl.points[ k ][ 2 ] + next_offset, 34 - i, tex_offset, tex_offset - 0.5, col )
					
					tex_offset = tex_offset - 0.3
					offset = next_offset * 1
				end
			
			end
			
			
		end
	
	end
	
end

