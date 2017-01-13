function GUIBulletDisplay:Initialize()

    self.weaponClip     = 0
    self.weaponVariant  = 1
    self.weaponAmmo     = 0
    self.weaponClipSize = 30--50
    self.globalTime     = 0
    self.lowAmmoWarning = true

    self.onDraw = 0
    self.onHolster = 0

    self.background = GUIManager:CreateGraphicItem()
    self.background:SetSize( Vector(256, 512, 0) )
    self.background:SetPosition( Vector(0, 0, 0))
    self.background:SetTexture("ui/rifledisplay0.dds")
    self.background:SetIsVisible(true)

    self.lowAmmoOverlay = GUIManager:CreateGraphicItem()
    self.lowAmmoOverlay:SetSize( Vector(256, 512, 0) )
    self.lowAmmoOverlay:SetPosition( Vector(0, 0, 0))

    -- Slightly larger copy of the text for a glow effect
    self.ammoTextBg = GUIManager:CreateTextItem()
    self.ammoTextBg:SetFontName(Fonts.kMicrogrammaDMedExt_Large)
    self.ammoTextBg:SetFontIsBold(true)
    self.ammoTextBg:SetFontSize(135)
    self.ammoTextBg:SetTextAlignmentX(GUIItem.Align_Center)
    self.ammoTextBg:SetTextAlignmentY(GUIItem.Align_Center)
    self.ammoTextBg:SetPosition(Vector(135, 88, 0))
    self.ammoTextBg:SetColor(Color(0, 1, 1, 0.25)) --1/1/1/0.25

    -- Text displaying the amount of ammo in the clip
    self.ammoText = GUIManager:CreateTextItem()
    self.ammoText:SetFontName(Fonts.kMicrogrammaDMedExt_Large)
    self.ammoText:SetFontIsBold(true)
    self.ammoText:SetFontSize(120)
    self.ammoText:SetTextAlignmentX(GUIItem.Align_Center)
    self.ammoText:SetTextAlignmentY(GUIItem.Align_Center)
    self.ammoText:SetPosition(Vector(135, 88, 0))

    -- Create the indicators for the number of bullets in reserve.

    self.clipTop    = 400 - 256
    self.clipHeight = 69
    self.clipWidth  = 21

    self.numClips   = 6--4
    self.clip = { }

    for i =1,self.numClips do
        self.clip[i] = GUIManager:CreateGraphicItem()
        self.clip[i]:SetTexture("ui/rifledisplay0.dds")
        self.clip[i]:SetSize( Vector(21, self.clipHeight, 0) )
        self.clip[i]:SetBlendTechnique( GUIItem.Add )
    end

    self.clip[1]:SetPosition(Vector( 46, self.clipTop, 0))--
    self.clip[2]:SetPosition(Vector( 79, self.clipTop, 0))-- 78
    self.clip[3]:SetPosition(Vector( 112, self.clipTop, 0))
    self.clip[4]:SetPosition(Vector( 145, self.clipTop, 0))
    self.clip[5]:SetPosition(Vector( 178, self.clipTop, 0))
    self.clip[6]:SetPosition(Vector( 211, self.clipTop, 0))--

    -- Force an update so our initial state is correct.
    self:Update(0)

end
-------this function isn't really needed afaik, but doesnt work yet for some reaosn
function GUIBulletDisplay:Update(deltaTime)

    PROFILE("GUIBulletDisplay:Update")

    -- Update the ammo counter.

    local ammoFormat = string.format("%02d", self.weaponClip)
    self.ammoText:SetText( ammoFormat )
    self.ammoTextBg:SetText( ammoFormat )

    -- Update the reserve clip.

    local reserveMax      = self.numClips * self.weaponClipSize
    local reserve         = self.weaponAmmo
    local reserveFraction = (reserve / reserveMax) * self.numClips

    for i=1,self.numClips do
        self:SetClipFraction( i, Math.Clamp(reserveFraction - i + 1, 0, 1) )
    end

    local fraction = self.weaponClip / self.weaponClipSize
    local alpha = 0
    local pulseSpeed = 5

    if fraction <= 0.4 then

        if fraction == 0 then
            pulseSpeed = 25
        elseif fraction < 0.25 then
            pulseSpeed = 10
        end

        alpha = (math.sin(self.globalTime * pulseSpeed) + 1) / 2
    end

    if not self.lowAmmoWarning then alpha = 0 end

    self.lowAmmoOverlay:SetColor(Color(1, 0, 0, alpha * 0.25))

end
