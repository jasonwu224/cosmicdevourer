local vector = require("vector")
-- mass is int, pos is vector, vel is vector
local Object = {
    mass = 0,
    pos = nil,
    vel = nil,
    radius = 0
    -- color = 0,  might be able to leave out
    -- destroyed = false
}

Object.__index = Object

function Object.new(mass, pos, vel, radius)
    local self = setmetatable({}, Object)
    self.color = { math.random(), math.random(), math.random() }
    self.destroyed = false
    self.mass = mass
    self.pos = pos
    self.vel = vel
    self.radius = radius
    return self
end

--takes in a force vector
function Object:nextPosition()
    self.pos:add(self.vel)
end

-- takes in a object
function Object:applyForce(obj)
    local distance = obj.pos:subR(self.pos)
    local accMag = obj.mass / (distance:magnitude() * distance:magnitude()) -- take out self.mass, so it is acceleration
    local acc = distance:multR(accMag / distance:magnitude())
    self.vel:add(acc)
end

-- Draw method
function Object:draw()
    if (self.destroyed) then
        love.graphics.setColor(1, 1, 1)
        circle = love.graphics.circle("fill", self.pos.x, self.pos.y, self.radius)
    else
        love.graphics.setColor(self.color)
        circle = love.graphics.circle("fill", self.pos.x, self.pos.y, self.radius)
        love.graphics.setColor(0, 0, 0)
        num = love.graphics.print(self.radius, self.pos.x, self.pos.y)
    end
end

function Object:destroy(param)
    self.destroyed = param;
    -- self.radius = 0;
end

return Object
