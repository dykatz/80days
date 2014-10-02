tween = {}
tween.__index = tween
setmetatable(tween, {__call = function(self, ...)
	local o = setmetatable({}, tween)
	o:init(...)
	return o
end})

local tweens = {}

function tween:init(value, time, func)
	self.moving = false
	self.value = value
	self.destination = 0
	self.delta = 0
	self.time = time
	self.func = func

	tweens[self] = true
end

function tween:start(destination)
	self.moving = true
	self.destination = destination
	self.delta = self.destination - self.value
end

function tween:update(dt)
	if self.moving then
		self.value = self.value + dt * self.delta / self.time

		if (self.value >= self.destination and self.delta > 0) or
			(self.value <= self.destination and self.delta < 0) then
			self.value = self.destination
			self.moving = false
			if self.func then self.func() end
		end
	end
end

function tween:getPercentage()
	return (self.destination - self.value) / self.delta
end

function updateTweens(dt)
	for i in pairs(tweens) do
		i:update(dt)
	end
end
