
local Common                    = require "Common/Common"

local player = {}
--require("LuaPanda").start("127.0.0.1",8818)
function player:ReceiveBeginPlay()
    self.Super:ReceiveBeginPlay()
    self:SetTickableWhenPaused(true)
    
    local cameraManager = Common.GetPlayerCameraManager(self)
    cameraManager:StartCameraFade(1.0 ,0.0 ,10.0 ,FLinearColor(0,0,0,1) ,false ,false)
end

return player