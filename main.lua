require "TileMap";

inclination = 0;
tileSize = 60;
globalX = 1;
globalY = 1;
tileWidth = 30;
tileHeight = 20;
camX = 352;
camY = -304;
resolutionX = 600;
resolutionY = 600;
globalWaterLimit = 0.5;

waterAnimX = 0;
waterAnimY = 1;

birdAnimX = 0;
birdAnimY = 0;

function love.load()
    love.window.setMode(resolutionX, resolutionY);
    -- love.window.setFullscreen(true);
end

function love.draw()
    love.graphics.setBackgroundColor(0, 0, 0);

    -- TileMap:draw(false, tileWidth, tileHeight, tileSize + 1, camX, camY, 0, 0, 0.9, 0.9 , 0.7, 1, 0.9, 0.9);
    renderMap();
    -- drawPerlinNoise();

    birdAnimX = birdAnimX + 0.05;
    birdAnimY = birdAnimY + 0.05;

    if (birdAnimX > 1000) then
        birdAnimX = 0;
    end

    if (birdAnimY > 1000) then
        birdAnimY = 0;
    end

    for x = 0, love.graphics.getWidth() / 10 do
        for y = 0, love.graphics.getHeight() / 10 do
            birdNoise = smoothedNoise((x + globalX + birdAnimX) / 100, ((y + globalY + birdAnimY) / 100));
            if (birdNoise < 0.4) then
                -- drawBird(((x - y) * 10) + love.graphics.getWidth() / 2, (((x + y) * 10) - love.graphics.getHeight() / 2));
                love.graphics.setColor(1, 1, 1, 0.2);
                love.graphics.setPointSize(20);
                love.graphics.points(((x - y) * 10) + love.graphics.getWidth() / 2,
                    ((x + y) * 10) - love.graphics.getHeight() / 2);
            end
        end
    end
end

function drawBird(x, y)
    love.graphics.setColor(1, 1, 1);
    y = y + smoothedNoise(x, y) * 100;
    x = x + smoothedNoise(x, y) * 100;
    local curve = love.math.newBezierCurve({x - 5, y + 5, x, y, x + 5, y + 5});
    local curve2 = love.math.newBezierCurve({x + 5, y + 5, x + 10, y, x + 15, y + 5});

    love.graphics.line(curve:render());
    love.graphics.line(curve2:render());
end

function printOnScreen(text)
    love.graphics.setColor(1, 1, 1);
    love.graphics.print(text, 0, 0);
end

function drawPerlinNoise()
    size = 10;

    for x = 0, resolutionX / size do
        for y = 0, resolutionY / size do
            noise1 = smoothedNoise(x, y);
            waterNoise1 = love.math.noise(x, y);

            if (noise1 < noise1 / 2) then
                noise1 = noise1 / 2;
            end

            if (waterNoise1 < 0.5) then
                noise1 = 0;
            end

            love.graphics.setColor(noise1, noise1, noise1);

            love.graphics.setPointSize(size);
            love.graphics.points(x * size, y * size);
        end
    end
end

function smoothedNoise(x, y)
    corners =
        (love.math.noise((x) - 1, (y) - 1) + love.math.noise((x) + 1, (y) - 1) + love.math.noise((x) - 1, (y) + 1) +
            love.math.noise((x) + 1, (y) + 1)) / 16;

    sides = (love.math.noise((x) - 1, (y)) + love.math.noise((x) + 1, (y)) + love.math.noise((x), (y) - 1) +
                love.math.noise((x), (y) + 1)) / 8;

    center = love.math.noise((x), (y)) / 4;
    return corners + sides + center;
end

function renderMap(seed)
    size = tileSize;

    waterAnimX = waterAnimX + 0.01;
    waterAnimY = waterAnimY + 0.01;

    if (waterAnimX > 100) then
        waterAnimX = 0;
    end
    if (waterAnimY > 100) then
        waterAnimY = 0;
    end

    for x = 0, size do
        for y = 0, size do
            multiplier = 450;
            multiple = 45;

            noise1 = smoothedNoise(x + globalX, y + globalY);
            noise1 = noise1 * multiplier;

            waterNoise1 = smoothedNoise(math.floor(((x + globalX) / 3)), math.floor(((y + globalY) / 3)));
            waterNoise2 = smoothedNoise(math.floor(((x + globalX) / 10)), math.floor(((y + globalY) / 10)));
            noise2 = smoothedNoise(math.floor(((x + globalX) / 30) + 2887), math.floor(((y + globalY) / 30) + 2887));
            noise3 = smoothedNoise(math.floor(((x + globalX) / 30) + 887), math.floor(((y + globalY) / 30) + 3887));

            r = 0;
            g = 0.5;
            b = 0;
            rb = 0.8;
            gb = 0.5;
            bb = 0.5;
            t = 1;

            waterLimit = globalWaterLimit;

            if (waterNoise1 < waterLimit or waterNoise2 < waterLimit) then
                waterNoiseAnim = smoothedNoise(x + globalX + waterAnimX, y + globalY + waterAnimY);

                r = waterNoiseAnim;
                g = waterNoiseAnim;
                b = waterNoiseAnim + 0.1;
                rb = 0;
                gb = 0;
                bb = 0.5;
                t = 0.2;

                noise1 = (multiplier / 2);
            else

                if (noise3 > 0.6) then
                    r = 0.5;
                    g = 0.5;
                    b = 0.3;
                    rb = 0.6;
                    gb = 0.6;
                    bb = 0.4;
                end

                for xs = 1, 3 do
                    for ys = 1, 3 do

                        xsn = 1;
                        ysn = 1;

                        if (xs == 2) then
                            xsn = -1;
                        end

                        if (xs == 3) then
                            xsn = 0;
                        end

                        if (ys == 2) then
                            ysn = -1;
                        end

                        if (ys == 3) then
                            ysn = 0;
                        end

                        sandNoise = smoothedNoise(math.floor(((x + xsn + globalX) / 3)),
                            math.floor(((y + ysn + globalY) / 3)));
                        sandNoise2 = smoothedNoise(math.floor(((x + xsn + globalX) / 10)),
                            math.floor(((y + ysn + globalY) / 10)));

                        if (sandNoise < waterLimit or sandNoise2 < waterLimit) then
                            r = 0.5;
                            g = 0.5;
                            b = 0.3;
                            rb = 0.6;
                            gb = 0.6;
                            bb = 0.4;
                        end
                    end
                end

                if (noise2 > 0.6) then
                    r = 0;
                    g = 0.1;
                    b = 0;
                    rb = 0.2;
                    gb = 0.3;
                    bb = 0.2;

                    noise1 = noise1 + 100;
                end
            end

            if (noise1 < (multiplier / 2)) then
                noise1 = multiplier / 2;
            end

            noise1 = roundToNearestUp(noise1, multiple);

            drawCube(x, y, r, g, b, rb, gb, bb, t, noise1);
        end
    end
end

function roundToNearestUp(number, multiple)
    number = math.floor(number);

    if (multiple == 0) then
        return number;
    end

    remainder = number % multiple;

    if (remainder == 0) then
        return number;
    end

    return number + multiple - remainder;
end

function calculateXDraw(x, y)
    return ((x - y) * (tileWidth / 2)) + camX;
end

function calculateYDraw(x, y)
    return ((x + y) * (tileHeight / 2)) + camY;
end

function calculateXDrawPoint(x, y)
    return ((x - y) * (tileWidth / 4)) + camX;
end

function calculateYDrawPoint(x, y)
    return ((x + y) * (tileHeight / 4)) + camY;
end

function drawCube(x, y, r, g, b, rBorder, gBorder, bBorder, transparency, cubeHeight)
    limit = 1000;
    if (cubeHeight > limit) then
        cubeHeight = limit;
    end

    if (cubeHeight < 0) then
        cubeHeight = 0;
    end

    initialHeight = cubeHeight;
    cubeHeight = cubeHeight * (1 - (tileHeight / tileWidth));
    love.graphics.setColor(rBorder, gBorder, bBorder, transparency);

    love.graphics.polygon("fill", calculateXDraw(x, y), calculateYDraw(x, y), calculateXDraw(x, y),
        calculateYDraw(x, y) - cubeHeight, calculateXDraw(x, y + 1), calculateYDraw(x, y + 1) - cubeHeight,
        calculateXDraw(x, y + 1), calculateYDraw(x, y + 1), calculateXDraw(x, y), calculateYDraw(x, y));

    love.graphics.polygon("fill", calculateXDraw(x, y), calculateYDraw(x, y), calculateXDraw(x, y),
        calculateYDraw(x, y) - cubeHeight, calculateXDraw(x + 1, y), calculateYDraw(x + 1, y) - cubeHeight,
        calculateXDraw(x + 1, y), calculateYDraw(x + 1, y), calculateXDraw(x, y), calculateYDraw(x, y));

    love.graphics.polygon("fill", calculateXDraw(x + 1, y + 1), calculateYDraw(x + 1, y + 1),
        calculateXDraw(x + 1, y + 1), calculateYDraw(x + 1, y + 1) - cubeHeight, calculateXDraw(x + 1, y),
        calculateYDraw(x + 1, y) - cubeHeight, calculateXDraw(x + 1, y), calculateYDraw(x + 1, y),
        calculateXDraw(x + 1, y + 1), calculateYDraw(x + 1, y + 1));

    love.graphics.polygon("fill", calculateXDraw(x + 1, y + 1), calculateYDraw(x + 1, y + 1),
        calculateXDraw(x + 1, y + 1), calculateYDraw(x + 1, y + 1) - cubeHeight, calculateXDraw(x, y + 1),
        calculateYDraw(x, y + 1) - cubeHeight, calculateXDraw(x, y + 1), calculateYDraw(x, y + 1),
        calculateXDraw(x + 1, y + 1), calculateYDraw(x + 1, y + 1));

    colorAdjust = (initialHeight / limit);
    love.graphics.setColor(r + colorAdjust, g + colorAdjust, b + colorAdjust, transparency);

    love.graphics.polygon("fill", calculateXDraw(x, y), calculateYDraw(x, y) - cubeHeight, calculateXDraw(x, y + 1),
        calculateYDraw(x, y + 1) - cubeHeight, calculateXDraw(x + 1, y + 1), calculateYDraw(x + 1, y + 1) - cubeHeight,
        calculateXDraw(x + 1, y), calculateYDraw(x + 1, y) - cubeHeight, calculateXDraw(x, y),
        calculateYDraw(x, y) - cubeHeight);

    love.graphics.setColor(0, 0, 0, 0.1);

    love.graphics.line(calculateXDraw(x, y), calculateYDraw(x, y) - cubeHeight, calculateXDraw(x, y + 1),
        calculateYDraw(x, y + 1) - cubeHeight, calculateXDraw(x + 1, y + 1), calculateYDraw(x + 1, y + 1) - cubeHeight,
        calculateXDraw(x + 1, y), calculateYDraw(x + 1, y) - cubeHeight, calculateXDraw(x, y),
        calculateYDraw(x, y) - cubeHeight);

    love.graphics.line(calculateXDraw(x, y + 1), calculateYDraw(x, y + 1), calculateXDraw(x, y + 1),
        calculateYDraw(x, y + 1) - cubeHeight);

    love.graphics.line(calculateXDraw(x + 1, y), calculateYDraw(x + 1, y), calculateXDraw(x + 1, y),
        calculateYDraw(x + 1, y) - cubeHeight);

    love.graphics.line(calculateXDraw(x + 1, y + 1), calculateYDraw(x + 1, y + 1), calculateXDraw(x + 1, y + 1),
        calculateYDraw(x + 1, y + 1) - cubeHeight);
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    end

    if (key == "z" and tileHeight < tileWidth) then
        tileHeight = tileHeight + step;
    end

    if (key == "x" and tileHeight > 0) then
        tileHeight = tileHeight - step;
    end

    -- if key == "a" then
    --     globalX = globalX - step;
    -- end

    -- if key == "d" then
    --     globalX = globalX + step;
    -- end

    -- if key == "w" then
    --     globalY = globalY - step;
    -- end

    -- if key == "s" then
    --     globalY = globalY + step;
    -- end
end

function love.update()
    step = 1;
    camStep = 1;

    if love.keyboard.isDown("a") then
        globalX = globalX - step;
    end

    if love.keyboard.isDown("d") then
        globalX = globalX + step;
    end

    if love.keyboard.isDown("w") then
        globalY = globalY - step;
    end

    if love.keyboard.isDown("s") then
        globalY = globalY + step;
    end

    -- if love.keyboard.isDown("q") then
    --     globalSeed = globalSeed - step;
    -- end

    -- if love.keyboard.isDown("e") then
    --     globalSeed = globalSeed + step;
    -- end

    if love.keyboard.isDown("t") then
        globalWaterLimit = globalWaterLimit + 0.01;
    end

    if love.keyboard.isDown("g") then
        globalWaterLimit = globalWaterLimit - 0.01;
    end

    if love.keyboard.isDown("j") then
        camX = camX + camStep;
    end

    if love.keyboard.isDown("l") then
        camX = camX - camStep;
    end

    if love.keyboard.isDown("i") then
        camY = camY + camStep;
    end

    if love.keyboard.isDown("k") then
        camY = camY - camStep;
    end
end
