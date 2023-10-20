AddCSLuaFile()
SWEP.PrintName = "SCP-500"
SWEP.Author = "Isaac"
SWEP.Category = "SCPs"
SWEP.Instructions = ""
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.Ammo = "none"
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Slot = 2
SWEP.SlotPos = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.ViewModel = "models/easzy/ez_body_damage/painkillers/v_painkillers.mdl"
SWEP.WorldModel = "models/easzy/ez_body_damage/painkillers/w_painkillers.mdl"
SWEP.UseHands = true

if SERVER then
    resource.AddWorkshop("3055894146")
end

function SWEP:Initialize()
    self.switchweapon = true
end

function SWEP:DrawWorldModel()
    if !IsValid(self:GetOwner()) then
        self:DrawModel()
        return
    end

    local ow = self:GetOwner()
    local boneIndex = ow:LookupBone("ValveBiped.Bip01_R_Hand")
    local bonePos, boneAng = ow:GetBonePosition(boneIndex)
    boneAng:RotateAroundAxis(boneAng:Right(),180)
    bonePos = bonePos + boneAng:Forward() * -3.5 + boneAng:Right() * 1.5

    self:SetRenderOrigin(bonePos)
    self:SetRenderAngles(boneAng)

    self:DrawModel()
end

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + 1)
    self.switchweapon = false
    local ow = self:GetOwner()

    local vm = ow:GetViewModel()
    local seq = vm:LookupSequence("use")

    if seq ~= -1 then
        vm:SendViewModelMatchingSequence(seq)
        self:SetNextPrimaryFire(CurTime() + vm:SequenceDuration(seq))
        if CLIENT then
            surface.PlaySound("easzy/ez_body_damage/painkillers.mp3")
        end
    end

    if CLIENT then return end
    timer.Simple(vm:SequenceDuration(seq), function()
        ow:SetHealth(ow:GetMaxHealth())
        ow:StripWeapon(self:GetClass())
    end)
end

function SWEP:SecondaryAttack() end

function SWEP:Holster()
    return self.switchweapon
end