require 'tween'
local newCurve = function(...) return love.math.newBezierCurve(...):render() end

function love.load()
	love.graphics.setFont(love.graphics.newFont(20))
	love.graphics.setLineWidth(3)
	
	map = love.graphics.newImage 'map.png'
	current = 1
	previous = 1
	debug = false
	camx = tween(1020, 0.4)
	camy = tween(215, 0.4)

	places = {
		{1020, 215, 'London'},
		{1210, 340, 'Suez'},
		{1440, 400, 'Bombay'},
		{1520, 375, 'Calcutta'},
		{1670, 385, 'Hong Kong'},
		{1820, 310, 'Yokohama'},
		{2375, 300, 'San Fransisco'},
		{2650, 280, 'New York'},
		{3070, 215, 'London'}
	}

	paths = {
		newCurve(1020, 215, 1060, 270, 1130, 260, 1135, 330, 1210, 340),
		newCurve(1210, 340, 1240, 450, 1275, 450, 1440, 400),
		newCurve(1440, 400, 1469, 339, 1520, 375),
		newCurve(1520, 375, 1580, 550, 1670, 550, 1670, 385),
		newCurve(1670, 385, 1780, 420, 1820, 310),
		newCurve(1820, 310, 2375, 300),
		newCurve(2375, 300, 2400, 250, 2500, 300, 2650, 280),
		newCurve(2650, 280, 3070, 215)
	}
end

function love.update(dt)
	camx:update(dt)
	camy:update(dt)
end

function love.draw()
	love.graphics.push()
	love.graphics.translate(love.window.getWidth() / 2 - camx.value, love.window.getHeight() / 4 - camy.value)
	
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(map)
	love.graphics.draw(map, map:getWidth())

	for i, k in ipairs(places) do
		if i > current then
			break
		end

		love.graphics.setColor(255, 0, 0, 127)
		love.graphics.circle('fill', k[1], k[2], 10)

		if i < previous then
			-- lines that we are not currently on
			--love.graphics.line(k[1], k[2], places[i + 1][1], places[i + 1][2])
			love.graphics.line(paths[i])
		elseif i == current then
			-- line that we are currently on
			--love.graphics.line(places[previous][1], places[previous][2], camx.value, camy.value)
			renderPathTo(paths[previous], 0, current == previous and camx:getPercentage() or 1 - camx:getPercentage())
		end

		if current == i then
			love.graphics.setColor(255, 0, 0, 255)
			love.graphics.print(k[3], k[1] + 15, k[2] - 10)
		end
	end

	love.graphics.pop()
	if debug then
		love.graphics.print(math.floor(camx.value - love.graphics.getWidth() / 2 + love.mouse.getX()))
		love.graphics.print(math.floor(camy.value - love.graphics.getHeight() / 4 + love.mouse.getY()), 0, 20)
	end
end	

function love.keypressed(k)
	if not camx.moving then
		if k == 'left' and current > 1 then
			current = current - 1
			previous = current
			camx:start(places[current][1])
			camy:start(places[current][2])
		end

		if k == 'right' and current < #places then
			previous = current
			current = current + 1
			camx:start(places[current][1])
			camy:start(places[current][2])
		end
	end

	if k == 'escape' then
		love.event.quit()
	end

	if k == '`' then
		debug = not debug
	end
end

function renderPathTo(path, t0, tf)
	accuracy = accuracy or 5
	local length = #path / 2
	local lastInt = math.floor(tf * length) * 2
	local newPath = {}

	if lastInt > 1 and lastInt < math.huge then
		for i = 1, lastInt, 2 do
			newPath[#newPath + 1] = path[i]
			newPath[#newPath + 1] = path[i + 1]
		end

		if #newPath > 2 then
			love.graphics.line(newPath)
		end
	end
end
