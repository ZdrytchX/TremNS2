function ScoringMixin:AddScore(points, res, wasKill)

    -- Should only be called on the Server.
    if Server and points and points ~= 0 and not GetGameInfoEntity():GetWarmUpActive() then
        -- Tell client to display cool effect.
            local displayRes = ConditionalValue(type(res) == "number", res, 0)
            Server.SendNetworkMessage(Server.GetOwner(self), "ScoreUpdate", { points = points, res = displayRes, wasKill = wasKill == true }, true)
            self.score = Clamp(self.score + points, 0, self:GetMixinConstants().kMaxScore --[[or 100]])

            if not self.scoreGainedCurrentLife then
                self.scoreGainedCurrentLife = 0
            end

            self.scoreGainedCurrentLife = self.scoreGainedCurrentLife + points

    end

end
