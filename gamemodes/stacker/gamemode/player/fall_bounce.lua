--locals
local fall_effect = EffectData()
local max_fall_pitch = 140
local max_fall_pitch_deduction = 120
local max_speed = 3500

--gamemode functions
function GM:GetFallDamage(ply, speed)
	fall_effect:SetEntity(ply)
	fall_effect:SetOrigin(ply:GetPos())
	
	if ply:KeyDown(IN_DUCK) then --if they are crouching, don't make them bounce
		ply:EmitSound(
			"physics/flesh/flesh_strider_impact_bullet" .. math.random(3) .. ".wav",
			75, --sound level in db,
			80, --pitch
			1 --volume
		)
		
		fall_effect:SetScale(speed / max_speed * 500)
		util.Effect("ThumperDust", fall_effect, nil, true)
	else --if they fall, make them bounce
		ply:SetVelocity(Vector(0, 0, speed * 0.6))
		
		--sound.Play is also an option
		ply:EmitSound(
			"physics/plastic/plastic_barrel_impact_bullet" .. math.random(3) .. ".wav",
			75, --sound level in db,
			max_fall_pitch - (speed / max_speed) ^ 1.5 * max_fall_pitch_deduction, --pitch
			1 --volume
		)
		
		util.Effect("StunstickImpact", fall_effect, nil, true)
	end
	
	return 0
end