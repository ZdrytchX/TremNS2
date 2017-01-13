-- ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
--
-- lua\GUISpeedDebug.lua
--
--    Created by:   Andreas Urwalek (a_urwa@sbox.tugraz.at)
--
--    UI display for console command "debugspeed". Shows a red bar + number indicating the current
--    velocity and white bar indicating any special move/initial timing (like skulk jump, marine
--    sprint, onos momentum)
--
-- ========= For more information, visit us at http://www.unknownworlds.com =====================

local gMomentumBarHeight = 200
local kFontName = Fonts.kArial_17

class 'GUISpeedDebug' (GUIScript)

function GUISpeedDebug:Initialize()

--fixed bar
    self.momentumBackGround = GetGUIManager():CreateGraphicItem()
    self.momentumBackGround:SetAnchor(GUIItem.Left, GUIItem.Bottom)
    self.momentumBackGround:SetPosition(Vector(100, -210, 0))
    self.momentumBackGround:SetSize(Vector(gMomentumBarHeight, 30, 0))
    self.momentumBackGround:SetColor(Color(1, 0, 0, 0.125))

--fixed lines
--positions: right, up
    self.momentumBackGround0 = GetGUIManager():CreateGraphicItem()
    self.momentumBackGround0:SetAnchor(GUIItem.Left, GUIItem.Bottom)
    self.momentumBackGround0:SetPosition(Vector(100, -210, 0))
    self.momentumBackGround0:SetSize(Vector(2, 30, 0))
    self.momentumBackGround0:SetColor(Color(1, 0.75, 0, 0.25))

    self.momentumBackGround1 = GetGUIManager():CreateGraphicItem()
    self.momentumBackGround1:SetAnchor(GUIItem.Left, GUIItem.Bottom)
    self.momentumBackGround1:SetPosition(Vector(200, -210, 0))
    self.momentumBackGround1:SetSize(Vector(2, 30, 0))
    self.momentumBackGround1:SetColor(Color(1, 0.625, 0, 0.25))

    self.momentumBackGround2 = GetGUIManager():CreateGraphicItem()
    self.momentumBackGround2:SetAnchor(GUIItem.Left, GUIItem.Bottom)
    self.momentumBackGround2:SetPosition(Vector(300, -210, 0))
    self.momentumBackGround2:SetSize(Vector(2, 30, 0))
    self.momentumBackGround2:SetColor(Color(1, 0.5, 0, 0.25))

    self.momentumBackGround3 = GetGUIManager():CreateGraphicItem()
    self.momentumBackGround3:SetAnchor(GUIItem.Left, GUIItem.Bottom)
    self.momentumBackGround3:SetPosition(Vector(400, -210, 0))
    self.momentumBackGround3:SetSize(Vector(2, 30, 0))
    self.momentumBackGround3:SetColor(Color(1, 0.375, 0, 0.25))

    self.momentumBackGround4 = GetGUIManager():CreateGraphicItem()
    self.momentumBackGround4:SetAnchor(GUIItem.Left, GUIItem.Bottom)
    self.momentumBackGround4:SetPosition(Vector(500, -210, 0))
    self.momentumBackGround4:SetSize(Vector(2, 30, 0))
    self.momentumBackGround4:SetColor(Color(1, 0.25, 0, 0.25))

    self.momentumBackGround5 = GetGUIManager():CreateGraphicItem()
    self.momentumBackGround5:SetAnchor(GUIItem.Left, GUIItem.Bottom)
    self.momentumBackGround5:SetPosition(Vector(600, -210, 0))
    self.momentumBackGround5:SetSize(Vector(2, 30, 0))
    self.momentumBackGround5:SetColor(Color(1, 0.125, 0, 0.25))

    self.momentumBackGround6 = GetGUIManager():CreateGraphicItem()
    self.momentumBackGround6:SetAnchor(GUIItem.Left, GUIItem.Bottom)
    self.momentumBackGround6:SetPosition(Vector(700, -210, 0))
    self.momentumBackGround6:SetSize(Vector(2, 30, 0))
    self.momentumBackGround6:SetColor(Color(1, 0, 0, 0.25))

--actual speed
    self.momentumFraction = GetGUIManager():CreateGraphicItem()
    self.momentumFraction:SetSize(Vector(0, 30, 0))
    self.momentumFraction:SetColor(Color(0.5, 1, 0.1, 0.25))

    self.debugText = GetGUIManager():CreateTextItem()
    self.debugText:SetScale(GetScaledVector())
    self.debugText:SetFontName(kFontName)
    GUIMakeFontScale(self.debugText)
    self.debugText:SetPosition(Vector(0, -85, 0))

    self.airAccel = GetGUIManager():CreateTextItem()
    self.airAccel:SetScale(GetScaledVector())
    self.airAccel:SetFontName(kFontName)
    GUIMakeFontScale(self.airAccel)
    self.airAccel:SetPosition(Vector(0, -65, 0))

    self.xzSpeed = GetGUIManager():CreateTextItem()
    self.xzSpeed:SetScale(GetScaledVector())
    self.xzSpeed:SetFontName(kFontName)
    GUIMakeFontScale(self.xzSpeed)
    self.xzSpeed:SetPosition(Vector(0, -45, 0))

    self.qSpeed = GetGUIManager():CreateTextItem()
    self.qSpeed:SetScale(GetScaledVector())
    self.qSpeed:SetFontName(kFontName)
    GUIMakeFontScale(self.qSpeed)
    self.qSpeed:SetPosition(Vector(0, -25, 0))

    self.momentumBackGround:AddChild(self.debugText)
    self.momentumBackGround:AddChild(self.momentumFraction)
    self.momentumBackGround:AddChild(self.xzSpeed)
    self.momentumBackGround:AddChild(self.qSpeed)
    self.momentumBackGround:AddChild(self.airAccel)

    Shared.Message("Enabled speed meter")

end

function GUISpeedDebug:Uninitialize()

    if self.momentumBackGround then
        GUI.DestroyItem(self.momentumBackGround)
        self.momentumBackGround = nil
    end

    Shared.Message("Disabled speed meter")

end

function GUISpeedDebug:SetDebugText(text)
    self.debugText:SetText(text)
end

function GUISpeedDebug:Update(deltaTime)
    PROFILE("GUISpeedDebug:Update")
    local player = Client.GetLocalPlayer()

    if player then

        local velocity = player:GetVelocity()
        local speed = velocity:GetLengthXZ()
        local bonusSpeedFraction
        bonusSpeedFraction = speed / 10
--[[
        if player:isa("Lerk") or player:isa("Fade") then
            bonusSpeedFraction = speed / player:GetMaxSpeed(false)
        else
            bonusSpeedFraction = speed / player:GetMaxSpeed(true)
        end
]]
        local lups = speed * 32

        self.momentumFraction:SetSize(Vector(gMomentumBarHeight * bonusSpeedFraction, 30, 0))
        self.xzSpeed:SetText( string.format( "current speed: %s m/s  vertical speed: %s m/s", ToString(RoundVelocity(speed)), ToString(RoundVelocity(velocity.y)) ) )
        self.qSpeed:SetText( string.format( "%s equivalent quake units per second", ToString(RoundVelocity(lups)) ) )

        local airAccelText = string.format( "air control value: %s m/s/s", ToString(player:GetAirControl()) )
        self.airAccel:SetText(airAccelText)

    end

end
