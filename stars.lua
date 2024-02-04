Stars = {}
--constructor
function Stars:new(x, y, radius)
    newObj = { x = x, y = y, radius = radius, color = { 1, 1, 1 } }
    self.__index = self
    return setmetatable(newObj, self)
end

function Stars:update(dt)
    ---define what the stars do later
end

--draw method
function Stars:draw()
    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.x, self.y, self.radius)
end

return Stars
