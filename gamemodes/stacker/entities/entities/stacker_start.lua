ENT.Base = "base_point"
ENT.Type = "point"

--entity functions
function ENT:Initialize() GAMEMODE.PropSpawnStartPoint = self:GetPos() end