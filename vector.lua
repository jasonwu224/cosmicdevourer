local Vector = {
    x = 0,
    y = 0
}

Vector.__index = Vector

function Vector.new(x, y)
    local self = setmetatable({}, Vector)
    self.x = x
    self.y = y
    return self
end

function Vector:theta()
    return math.atan(self.y, self.x)
end

function Vector:magnitude()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vector:change(vec)
    self.x = vec.x
    self.y = vec.y
end

-- vec is a Vector
function Vector:add(vec)
    self.x = self.x + vec.x
    self.y = self.y + vec.y
end

-- vec is a Vector
function Vector:sub(vec)
    self.x = self.x - vec.x
    self.y = self.y - vec.y
end

-- vec is a Vector, subR returns a new vector, doesn't modify own state
function Vector:subR(vec)
    return Vector.new(self.x - vec.x, self.y - vec.y)
end

-- scalar
function Vector:mult(scalar)
    self.x = self.x * scalar
    self.y = self.y * scalar
end

-- scalar
function Vector:multR(scalar)
    return Vector.new(self.x * scalar, self.y * scalar)
end

-- same magnitude change to new theta
-- currently useless, delete later if not needed
function Vector:rotate(newTheta)
    mag = self:magnitude()
    self.x = mag * math.cos(newTheta)
    self.y = mag * math.sin(newTheta)
end

return Vector
