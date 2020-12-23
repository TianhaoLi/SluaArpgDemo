local Common                    = require "Common/Common"

local player = {}
require("LuaPanda").start("127.0.0.1",8818)
function player:ReceiveBeginPlay()
    self.Super:ReceiveBeginPlay()
    self:SetTickableWhenPaused(true)
    
    local cameraManager = Common.GetPlayerCameraManager(self)
    cameraManager:StartCameraFade(1.0 ,0.0 ,10.0 ,FLinearColor(0,0,0,1) ,false ,false)
end

-- Inputs
function player:Run()
    self.CharacterMovement.MaxWalkSpeed  = 1250
end

function player:StopRun()
    self.CharacterMovement.MaxWalkSpeed = 600
end

function player:NormalAttack()
    self:DoMeleeAttack()
end

function player:SpecailAttack()
    self:DoSkillAttack()
end

function player:UseItem()
    self:UseItemPotion()
end

function player:Roll()
    self:DoRoll()
end

function player:ChangeWeapon()
    self:SwitchWeapon()
end

--Handle state changes
function player:OnManaChanged()
    self:UpdateManaBar()
end

function player:OnHealthChanged()
    self:UpdateHealthBar()

    if not self:IsAlive() then
        local gameMode = Common.GetGameMode(self)
        gameMode:GameOver()
    end

    self:DebugFinish()
end

--Handle damage messages
function player:OnDamaged()
    self:DebugUpdate()
    local stMontage = slua.loadObject("AnimMontage'/Game/Characters/Animations/AM_React_Hit.AM_React_Hit'")
    if not self["IsProtectedByShield"] and self:CanUseAnyAbility() then
        self:PlayAnimMontage(stMontage,1.0,math.random(1))
        self:PlayMaterialEffect(FLinearColor(1,0,0,1))
    end
end

--Player's HP bar
function player:UpdateHealthBar()
    local controller = Common.GetMyController(self)
    controller["OnScreenControls"]:SetHP(self:GetHealth() / self:GetMaxHealth())
end

--Player's Mana bar
function player:UpdateManaBar()
    local controller = Common.GetMyController(self)
    controller["OnScreenControls"]:SetMana(self:GetMana() / self:GetMaxMana())
end

--LowHealthScreenAlert
function player:OnLowHPWarning()
    self:HealthAlertAni()
end

--When Rolling Button is clicked
function player:DoRoll()
    player:UseEquippedPotion()

    if self:CanUseAnyAbility() then
        if player:IsChangingDir() then
            --蓝图中的SetActorRotation 实际上是K2_SetActorRotation
            self:K2_SetActorRotation(FRotator(0 ,0 ,0),true)
        end
        player:PlayRollMontage()
    end
end

function player:PlayRollMontage()
    local stMontage = slua.loadObject("AnimMontage'/Game/Characters/Animations/AM_Rolling.AM_Rolling'")
    self:PlayHighPriorityMontage(stMontage,"None")
end

function player:IsChangingDir()
    local  controller = Common.GetMyController(self)
    local vector = FVector(controller:GetInputAxisValue("MoveForward"),controller:GetInputAxisValue("MoveRight"),0.0)
    if vector:Size() > 0 then
        return true
    else
        return false
    end
end

--Actual Potion effect and cost will be conducted by GameplayEffect that is called by the AnimNotify in PotionMontage
function player:UseEquippedPotion()
    -- local ItemSlot = slua.loadObject("RPGItemSlot'/Script/ActionRPG.RPGItemSlot'")
    local slot = self["Potion"]
    self:ActivateAbilitiesWithItemSlot(slot,false)
end

--When 'Change Weapon' is called

function player:SwitchWeapon()
    if self:GetCurrentMontage() == nil then
        self:AttachNextWeapon()
    end
end

return player