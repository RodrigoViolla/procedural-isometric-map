TileMap = {}

function TileMap:draw(showPoints, tileWidth, tileHeight, size, positionX, positionY, initialPositionX, initialPositionY,
    r, g, b, rBorder,gBorder,bBorder)
    floorHeight = 45 * (1 - (tileHeight / tileWidth));

    love.graphics.setColor(r, g, b);
    love.graphics.polygon("fill", calculateXDraw(0, 0, tileWidth, positionX + initialPositionX),
        calculateYDraw(0, 0, tileWidth, positionX + initialPositionY),
        calculateXDraw(0, size, tileWidth, positionX + initialPositionX),
        calculateYDraw(0, size, tileWidth, positionX + initialPositionY),
        calculateXDraw(size, size, tileWidth, positionX + initialPositionX),
        calculateYDraw(size, size, tileWidth, positionX + initialPositionY),
        calculateXDraw(size, 0, tileWidth, positionX + initialPositionX),
        calculateYDraw(size, 0, tileWidth, positionX + initialPositionY),
        calculateXDraw(0, 0, tileWidth, positionX + initialPositionX),
        calculateYDraw(0, 0, tileWidth, positionX + initialPositionY));

    love.graphics.setColor(rBorder, gBorder, bBorder);
    love.graphics.polygon("fill", calculateXDraw(0, size, tileWidth, positionX + initialPositionX),
        calculateYDraw(0, size, tileWidth, positionX + initialPositionY),
        calculateXDraw(0, size, tileWidth, positionX + initialPositionX),
        calculateYDraw(0, size, tileWidth, positionX + initialPositionY) + floorHeight,
        calculateXDraw(size, size, tileWidth, positionX + initialPositionX),
        calculateYDraw(size, size, tileWidth, positionX + initialPositionY) + floorHeight,
        calculateXDraw(size, size, tileWidth, positionX + initialPositionX),
        calculateYDraw(size, size, tileWidth, positionX + initialPositionY),
        calculateXDraw(0, size, tileWidth, positionX + initialPositionX),
        calculateYDraw(0, size, tileWidth, positionX + initialPositionY));

        love.graphics.polygon("fill", calculateXDraw(size, size, tileWidth, positionX + initialPositionX),
        calculateYDraw(size, size, tileWidth, positionX + initialPositionY),
        calculateXDraw(size, size, tileWidth, positionX + initialPositionX),
        calculateYDraw(size, size, tileWidth, positionX + initialPositionY) + floorHeight,
        calculateXDraw(size, 0, tileWidth, positionX + initialPositionX),
        calculateYDraw(size, 0, tileWidth, positionX + initialPositionY) + floorHeight,
        calculateXDraw(size, 0, tileWidth, positionX + initialPositionX),
        calculateYDraw(size, 0, tileWidth, positionX + initialPositionY),
        calculateXDraw(size, size, tileWidth, positionX + initialPositionX),
        calculateYDraw(size, size, tileWidth, positionX + initialPositionY));

    love.graphics.setPointSize(5);
    love.graphics.setColor(0, 0, 0, 0);

    for i = 0, size do
        love.graphics.line(TileMap:calculateXDraw(0, i, tileWidth, positionX + initialPositionX),
            TileMap:calculateYDraw(0, i, tileHeight, positionY + initialPositionY),
            TileMap:calculateXDraw(size, i, tileWidth, positionX + initialPositionX),
            TileMap:calculateYDraw(size, i, tileHeight, positionY + initialPositionY));

        love.graphics.line(TileMap:calculateXDraw(i, 0, tileWidth, positionX + initialPositionX),
            TileMap:calculateYDraw(i, 0, tileHeight, positionY + initialPositionY),
            TileMap:calculateXDraw(i, size, tileWidth, positionX + initialPositionX),
            TileMap:calculateYDraw(i, size, tileHeight, positionY + initialPositionY));
    end

    love.graphics.line(TileMap:calculateXDraw(size, size, tileWidth, positionX + initialPositionX),
        TileMap:calculateYDraw(size, size, tileHeight, positionY + initialPositionY),
        TileMap:calculateXDraw(size, size, tileWidth, positionX + initialPositionX),
        TileMap:calculateYDraw(size, size, tileHeight, positionY + initialPositionY) + floorHeight);

    love.graphics.line(TileMap:calculateXDraw(0, size, tileWidth, positionX + initialPositionX),
        TileMap:calculateYDraw(0, size, tileHeight, positionY + initialPositionY),
        TileMap:calculateXDraw(0, size, tileWidth, positionX + initialPositionX),
        TileMap:calculateYDraw(0, size, tileHeight, positionY + initialPositionY) + floorHeight);

    love.graphics.line(TileMap:calculateXDraw(size, 0, tileWidth, positionX + initialPositionX),
        TileMap:calculateYDraw(size, 0, tileHeight, positionY + initialPositionY),
        TileMap:calculateXDraw(size, 0, tileWidth, positionX + initialPositionX),
        TileMap:calculateYDraw(size, 0, tileHeight, positionY + initialPositionY) + floorHeight);

    love.graphics.line(TileMap:calculateXDraw(size, size, tileWidth, positionX + initialPositionX),
        TileMap:calculateYDraw(size, size, tileHeight, positionY + initialPositionY) + floorHeight,
        TileMap:calculateXDraw(0, size, tileWidth, positionX + initialPositionX),
        TileMap:calculateYDraw(0, size, tileHeight, positionY + initialPositionY) + floorHeight);

    love.graphics.line(TileMap:calculateXDraw(size, size, tileWidth, positionX + initialPositionX),
        TileMap:calculateYDraw(size, size, tileHeight, positionY + initialPositionY) + floorHeight,
        TileMap:calculateXDraw(size, 0, tileWidth, positionX + initialPositionX),
        TileMap:calculateYDraw(size, 0, tileHeight, positionY + initialPositionY) + floorHeight);

    if (showPoints) then
        for x = 0, size do
            for y = 0, size do
                xDraw = TileMap:calculateXDraw(x, y, tileWidth, positionX);
                yDraw = TileMap:calculateYDraw(x, y, tileHeight, positionY);
                love.graphics.setColor(0, 0, 255);
                love.graphics.points(xDraw, yDraw);
                love.graphics.setColor(0, 0, 0);
                love.graphics.print(x .. ", " .. y, xDraw, yDraw);
            end
        end
    end
end

function TileMap:calculateXDraw(x, y, tileWidth, position)
    return ((x - y) * (tileWidth / 2)) + position;
end

function TileMap:calculateYDraw(x, y, tileHeight, position)
    return ((x + y) * (tileHeight / 2)) + position;
end

