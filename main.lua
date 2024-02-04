local vector = require("vector")
local object = require("object")
local ball = require("ball")
local stars = require("stars")
local gameState = "start"

function love.load()
    --black hole initially spawns at center
    blackHole = object.new(100, vector.new(500, 500), vector.new(0, 0), 100)

    -- v = sqrt(blackHole.mass / 500)
    ball1 = ball.new(10, vector.new(500, 100), vector.new(0, 0), 20)

    -- center on the player ball by adding distance from ball to black hole vector to everything
    -- ball1_vec = vector.new(ball1.x, ball1.y)
    d_ball_blackhole = blackHole.pos:subR(ball1.pos)
    blackHole.pos:add(d_ball_blackhole)
    ball1.pos:add(d_ball_blackhole)

    planetTable = {}
    for i = 1, 10 do
        --ran pos
        local ranx = math.random(0, 1000)
        local rany = math.random(0, 1000)
        local pos = vector.new(ranx, rany)
        --ran mass
        local ranmass = math.random(100, 120)
        --generate radius
        local ranradius = math.sqrt(ranmass)
        --a velocity
        local distance = blackHole.pos:subR(pos)
        --magnitude of velocity calculated for stable orbit
        local vmag = math.sqrt(blackHole.mass / distance:magnitude())
        --add some disturbance to shake up the orbits, 0.1
        local ranXVel = math.random(-1 * distance.y - 0.2, -1 * distance.y + 0.2)
        local ranYVel = math.random(distance.x - 0.2, distance.x + 0.2)
        local vel = vector.new(math.random(-1 * distance.y - 0.1, -1 * distance.y + 0.1),
            math.random(distance.x - 0.1, distance.x + 0.1))
        local vel = vector.new(ranXVel, ranYVel)
        vel:mult(vmag / distance:magnitude())

        --shift so ball is at center
        -- pos:add(d_ball_blackhole)
        table.insert(planetTable, object.new(ranmass, pos, vel, ranradius))
    end

    starTable = {}
    for i = 1, 180 do
        local ranx = math.random(0, 1000);
        local rany = math.random(0, 1000);
        local ranradius = 0.8;
        table.insert(starTable, stars:new(ranx, rany, ranradius))
    end
end

-- currently ~120 frames per second

function love.keypressed(key)
    if gameState == "start" then
        gameState = "running"
    else
        if gameState == "gameover" then
            love.load()
            gameState = "running"
        end
        if gameState == "winner" then
            love.load()
            gameState = "running"
        end
        if gameState == "running" then
            gameState = "pause"
        end
        if gameState == "pause" then
            gameState = "running"
        end
    end
end

function love.update(dt)
    if gameState == "running" then
        if (#planetTable == 0) then
            gameState = "winner"
        end
        local fake_a = ball1:update(dt)
        local distance = ball1.pos:subR(blackHole.pos)
        -- f = ball1:applyForce(blackHole)
        -- ball1:nextPosition()
        blackHole.vel:add(fake_a)
        blackHole.vel:sub(ball1.vel)
        blackHole:nextPosition()
        for _, obj in ipairs(planetTable) do
            obj:nextPosition()
            obj.vel:add(fake_a)
            obj.vel:sub(ball1.vel)
            obj:applyForce(blackHole)
            -- black hole does not get force applied
        end
        for i, obj1 in ipairs(planetTable) do
            --Collision between planets
            --if possible remove collided planets from table
            for j, obj2 in ipairs(planetTable) do
                if not (obj2 == obj1) then
                    local distance1 = obj2.pos:subR(obj1.pos)
                    if distance1:magnitude() <= obj1.radius + obj2.radius then
                        if handlePlanetCollision(obj1, obj2) == 1 then
                            table.remove(planetTable, i)
                        else
                            table.remove(planetTable, j)
                        end
                    end
                end
            end

            --Collision with ball
            local distance = ball1.pos:subR(obj1.pos)
            if distance:magnitude() <= ball1.radius + obj1.radius then
                if handleBallCollision(ball1, obj1) == 1 then
                    table.remove(planetTable, i)
                else
                    gameState = "gameover"
                end
            end
        end
        local distance = ball1.pos:subR(blackHole.pos)
        if distance:magnitude() <= ball1.radius + blackHole.radius then
            if gameState == "ending" then
                gameState = "winner"
            else
                gameState = "gameover"
            end
        end
    end

    --Implement COLLISION!

    function handleBallCollision(player, planet)
        if (player.radius > planet.radius) then
            player.radius = player.radius + planet.radius
            return 1;
        end
    end

    function handlePlanetCollision(planet1, planet2)
        if not (planet1.radius == planet2.radius) then
            if (planet1.radius > planet2.radius) then
                planet1.radius = planet1.radius + planet2.radius
                return 2
            else
                if (planet2.radius > planet1.radius) then
                    planet2.radius = planet2.radius + planet1.radius
                    return 1
                end
            end
        end
    end

    function updateState()
        if gameState == "start" then
            --Update something?
        end
    end

    function love.draw()
        if gameState == "start" then
            for _, obj in ipairs(starTable) do
                obj:draw()
            end
            love.graphics.print("Welcome to Cosmic Devourer!", 240, 0, 0, 2, 2)
            love.graphics.print("Consume smaller planets to grow", 220, 35, 0, 2, 2)
            love.graphics.print("Press any key to start", 270, 500, 0, 2, 2)
            love.graphics.print("Version 1.0.0", 900, 900, 0, 0.8, 0.8)
            love.graphics.print("Created by: Bill, Jason, Brendan, and Albert", 0, 900, 0, 0.8, 0.8)
            love.graphics.draw(love.graphics.newImage("mars.png"), 100, 200)
        end
        if (gameState == "running") or (gameState == "ending") then
            if gameState == "ending" then
                love.graphics.print("You're now the largest planet. Eat the blackhole to win!", 100, 0, 0, 2, 2)
            end
            love.graphics.print("Avoid larger planets! Click any key to unpause", 100, 0, 0, 2, 2)
            love.graphics.setBackgroundColor(0, 0, 0)
            for _, obj in ipairs(starTable) do
                obj:draw()
            end
            for _, obj in ipairs(planetTable) do
                obj:draw()
            end
            blackHole:draw()
            ball1:draw()
            -- love.graphics.line(ball1.pos.x, ball1.pos.y, ball1.pos.x + 100000 * f.x,
            -- ball1.pos.y + 100000 * f.y)
        end
        if gameState == "gameover" then
            love.graphics.print("GAME OVER! Click any key to play again!", 250, 500, 0, 2, 2)
        end
        if gameState == "pause" then
            love.graphics.print("Click any key to unpause", 250, 400, 0, 2, 2)
        end
        if gameState == "winner" then
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle("fill", 0, 0, 1000, 1000)
            love.graphics.setColor(0, 0, 1)
            love.graphics.print("Congrats! You are THE DEVOURER!", 250, 500, 0, 2, 2)
        end
    end
end
