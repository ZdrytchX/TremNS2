local kLifeTime = 5 --1.2

function ClusterGrenade:OnCreate()

    PredictedProjectile.OnCreate(self)

    InitMixin(self, BaseModelMixin)
    InitMixin(self, ModelMixin)
    InitMixin(self, TeamMixin)
    InitMixin(self, DamageMixin)

    if Server then

        self:AddTimedCallback(ClusterGrenade.TimedDetonateCallback, kLifeTime)

    end

end
