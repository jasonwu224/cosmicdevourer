local vector = require("vector")
local object = require("object")

-- Class definition
local Ball = {
    mass = 0,
    pos = nil,
    vel = nil,
    radius = 0
}

Ball.__index = Ball

function Ball.new(mass, pos, vel, radius)
    local self = setmetatable({}, Ball)
    self.color = { math.random(), math.random(), math.random() }
    self.destroyed = false
    self.mass = mass
    self.pos = pos
    self.vel = vel
    self.radius = radius
    self.fake_a = vector.new(0, 0)
    return self
end

--takes in a force vector
function Ball:nextPosition()
    self.pos:add(self.vel)
end

-- takes in a object
function Ball:applyForce(obj)
    local distance = obj.pos:subR(self.pos)
    local accMag = obj.mass / (distance:magnitude() * distance:magnitude()) -- take out self.mass, so it is acceleration
    local acc = distance:multR(accMag / (4 * distance:magnitude()))
    self.vel:add(acc)
    return acc
end

-- Update method
function Ball:update(dt)
    if love.keyboard.isDown("right") then
        self.fake_a.x = 0.5 * dt
    end
    if love.keyboard.isDown("left") then
        self.fake_a.x = -0.5 * dt
    end
    if love.keyboard.isDown("up") then
        self.fake_a.y = -0.5 * dt
    end
    if love.keyboard.isDown("down") then
        self.fake_a.y = 0.5 * dt
    end
    return self.fake_a
end

-- Draw method
function Ball:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", 500, 500, self.radius)
end

return Ball
