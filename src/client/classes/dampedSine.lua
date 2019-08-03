local DampedSine = {}
DampedSine.__index = DampedSine

function DampedSine.new(initialAmplitude, decayConstant, angularFrequency)
	local self = setmetatable({}, DampedSine)
	self.initialAmplitude = initialAmplitude or 1
	self.decayConstant = decayConstant or 1
	self.angularFrequency = angularFrequency or 1

	self.value = initialAmplitude

	self.lastUpdate = tick()
	self.lastTrigger = tick()

	return self
end

function DampedSine:trigger(initialAmplitude, decayConstant, angularFrequency)
	self.lastTrigger = tick()

	self.initialAmplitude = initialAmplitude or self.initialAmplitude
	self.decayConstant = decayConstant or self.decayConstant
	self.angularFrequency = angularFrequency or self.angularFrequency
end

function DampedSine:update()
	local deltaTime = tick() - self.lastTrigger
	self.lastUpdate = tick()

	self.value =
		self.initialAmplitude *
		math.exp(-1*self.decayConstant*deltaTime) *
		(math.cos(self.angularFrequency*deltaTime))
end

function DampedSine:getValue()
	return self.value
end

return DampedSine
