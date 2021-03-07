function EFFECT:Init( data )

	local pos = data:GetOrigin() + vector_up * 30
	local power = data:GetMagnitude() or 10
	local duration = data:GetScale() or 5
	
	local amount = 45//power*2
	
	local emitter = ParticleEmitter( pos )
	
	sound.Play("weapons/flashbang/flashbang_explode"..math.random(2)..".wav", pos, 100, 100, 1)
	
	if emitter then
		for i=1, amount do
			
			local p = emitter:Add( "particles/smokey", pos + VectorRand() * power/4 * i * 0.05 )
			local vel = ( p:GetPos() - pos ):GetNormal() * power*0.8
			vel.z = 0
			p:SetVelocity( vel )
			p:SetStartAlpha(math.random(240,255))
			p:SetEndAlpha(0)
			p:SetStartSize(math.random(30,110))
			local col = math.random(50,80)
			//p:SetColor( col, col, col )
			p:SetColor( 215, 77, 64 )
			p:SetDieTime(duration)
			p:SetEndSize(math.random(160,213))
			p:SetRoll(math.random(-180, 180))
			p:SetRollDelta(math.Rand(-0.5, 0.5))
			p:SetAirResistance(86)
		
		end

		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end


end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
