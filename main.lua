require 'tween'

function love.load()
	defaultFont = love.graphics.newFont(20)
	quoteFont = love.graphics.newFont(15)
	love.graphics.setFont(defaultFont)
	love.graphics.setLineJoin 'bevel'
	
	menu = tween(1, 0.5)
	map = love.graphics.newImage 'map.png'
	current = 1
	previous = 1
	debug = false
	camx = tween(1020, 0.4)
	camy = tween(215, 0.4)

	places = {
		{1020,	215,	'London',		tween(1, 0.4)},
		{1210,	340,	'Suez',			tween(0, 0.4)},
		{1440,	400,	'Bombay',		tween(0, 0.4)},
		{1520,	375,	'Calcutta',		tween(0, 0.4)},
		{1670,	385,	'Hong Kong',		tween(0, 0.4)},
		{1820,	310,	'Yokohama',		tween(0, 0.4)},
		{2375,	300,	'San Fransisco',	tween(0, 0.4)},
		{2650,	280,	'New York',		tween(0, 0.4)},
		{3070,	215,	'London',		tween(0, 0.4)}
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

	quotes = {
		{
			"He talked very little, and seemed all the more mysterious for his",
			"taciturn manner. His daily habits were quite open to observation;",
			"but whatever he did was so exactly the same thing that he had always",
			"done before, that the wits of the curious were fairly puzzled. (4)"
		}, {
			"\"But I never see your master on deck.\" - Fix",
			"\"Never; he hasn’t the least curiosity.\" - Passepartout (50)"
		}, {
			"[Passepatout] began to ask himself if this bet that Mr. Fogg talked",
			"about was not really in good earnest, and whether his fate was not",
			"in truth forcing him, despite his love of repose, around the world in",
			"eighty days! (58)"
		}, {
			"\"Save the woman, Mr. Fogg!\" - Guide",
			"\"I have yet twelve hours to spare;",
			"I can devote them to that.\" - Fogg",
			"\"Why, you are a man of heart!\" - Guide",
			"\"Sometimes, when I have the time.\" - Fogg (80)"
		}, {
			"It was every day an increasing wonder to Passepartout, who read in",
			"Aouda’s eyes the depths of her gratitude to his master. Phileas Fogg,",
			"though brave and gallant, must be, he thought, quite heartless. (120)"
		}, {
			""
		}, {
			"\"I will come back to America to find him,\" said Phileas Fogg calmly.",
			"\"It would not be right for an Englishman to permit himself to be",
			"treated in that way, without retaliating.\" (188)"
		}, {
			""
		}, {
			"What had he brought back from this long and weary journey?",
			"Nothing, you say? Perhaps so; nothing but a charming woman,",
			"who, strange as it may appear, made him the happiest of men!",
			"Truly, would you not for less than that make the tour around",
			"the world? (279)"
		}
	}
end

function love.update(dt)
	updateTweens(dt)
end

function love.draw()
	love.graphics.push()
	love.graphics.translate(love.window.getWidth() / 2 - camx.value, love.window.getHeight() / 4 - camy.value)
	
	love.graphics.draw(map)
	love.graphics.draw(map, map:getWidth())

	for i, k in ipairs(places) do
		love.graphics.setColor(255, 0, 0, 127)
		love.graphics.setLineWidth(3)

		if i < previous then
			love.graphics.line(paths[i])
		elseif i == current then
			renderPathTo(paths[previous], current == previous and camx:getPercentage() or 1 - camx:getPercentage())
		end

		love.graphics.setLineWidth(1)
		love.graphics.setColor(255, 0, 0, k[4].value * 255)
		love.graphics.circle('fill', k[1], k[2], k[4].value * 10)
		love.graphics.setColor(2, 2, 2, k[4].value * 255)
		love.graphics.circle('line', k[1], k[2], k[4].value * 10, 15)
		love.graphics.setColor(255, 255, 230, k[4].value * 255)
		roundedRectangle(k[1] - #k[3] * 7.5, k[2] - 56, #k[3] * 15, 32, 10, {2, 2, 2, k[4].value * 255}, camx.value - love.graphics.getWidth() / 2, camy.value - love.graphics.getHeight() / 4, 'down')
		drawQuote(k[1], k[2], quotes[i], {2, 2, 2, k[4].value * 255}, camx.value - love.graphics.getWidth() / 2, camy.value - love.graphics.getHeight() / 4, 'up')
		love.graphics.setColor(0, 0, 0, k[4].value * 255)
		love.graphics.printf(k[3], k[1] - #k[3] * 7.5, k[2] - 50, #k[3] * 15, 'center')
		love.graphics.setColor(255, 255, 255, 255)
	end

	love.graphics.pop()

	if debug then
		roundedRectangle(4, 4, 56, 46, 10, {2, 2, 2, 255})
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.print(math.floor(camx.value - love.graphics.getWidth() / 2 + love.mouse.getX()), 6, 6)
		love.graphics.print(math.floor(camy.value - love.graphics.getHeight() / 4 + love.mouse.getY()), 6, 26)
		love.graphics.setColor(255, 255, 255, 255)
	end

	love.graphics.setColor(0, 0, 0, menu.value * 255)
	love.graphics.rectangle('fill', 0, 0, 1024, 768)
	love.graphics.setColor(255, 255, 255, 255)
end	

function love.keypressed(k)
	if menu.value == 1 and not menu.moving then
		menu:start(0)
	elseif not menu.moving then
		if not camx.moving then
			if k == 'left' and current > 1 then
				places[current][4]:start(0)
				current = current - 1
				previous = current
				camx:start(places[current][1])
				camy:start(places[current][2])
				places[current][4]:start(1)
			end

			if k == 'right' and current < #places then
				places[current][4]:start(0)
				previous = current
				current = current + 1
				camx:start(places[current][1])
				camy:start(places[current][2])
				places[current][4]:start(1)
			end
		end
	end

	if k == 'escape' then
		love.event.quit()
	end

	if k == '`' then
		debug = not debug
	end
end

function newCurve(...)
	return love.math.newBezierCurve(...):render(10)
end

function renderPathTo(path, tf)
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
			local color = {love.graphics.getColor()}
			love.graphics.setColor(color[1], color[2], color[3], 255)
			local px, py = newPath[#newPath - 1] - newPath[#newPath - 3], newPath[#newPath] - newPath[#newPath - 2]
			local plen = math.sqrt(px^2 + py^2)
			px, py = px * 8 / plen, py * 8 / plen
			love.graphics.polygon('fill', newPath[#newPath - 1] + px, newPath[#newPath] + py, newPath[#newPath - 1] - px + py, newPath[#newPath] - py - px, newPath[#newPath - 1] - px - py, newPath[#newPath] - py + px)
			love.graphics.setColor(2, 2, 2, 255)
			love.graphics.setLineWidth(1)
			love.graphics.polygon('line', newPath[#newPath - 1] + px, newPath[#newPath] + py, newPath[#newPath - 1] - px + py, newPath[#newPath] - py - px, newPath[#newPath - 1] - px - py, newPath[#newPath] - py + px)
			love.graphics.setLineWidth(3)
			love.graphics.setColor(color)
		end
	end
end

function roundedRectangle(x, y, w, h, r, border, xoff, yoff, quoteDir)
	local camXOff = xoff or 0
	local camYOff = yoff or 0
	local color = {love.graphics.getColor()}
	love.graphics.rectangle('fill', x + r, y, w - 2 * r, h)
	love.graphics.rectangle('fill', x, y + r, r, h - 2 * r)
	love.graphics.rectangle('fill', x + w - r, y + r, r, h - 2 * r)
	
	if quoteDir == 'up' then
		love.graphics.polygon('fill', x + (w - r) / 2, y, x + (w + r) / 2, y, x + w / 2, y - r)
		love.graphics.setColor(border)
		love.graphics.line(x + r, y, x + (w - r) / 2, y)
		love.graphics.line(x + (w + r) / 2, y, x + w - r, y)
		love.graphics.line(x + (w - r) / 2, y, x + w / 2, y - r)
		love.graphics.line(x + w / 2, y - r, x + (w + r) / 2, y)
	else
		love.graphics.setColor(border)
		love.graphics.line(x + r, y, x + w - r, y)
	end

	if quoteDir == 'down' then
		love.graphics.setColor(color)
		love.graphics.polygon('fill', x + (w - r) / 2, y + h, x + (w + r) / 2, y + h, x + w / 2, y + h + r)
		love.graphics.setColor(border)
		love.graphics.line(x + r, y + h, x + (w - r) / 2, y + h)
		love.graphics.line(x + (w + r) / 2, y + h, x + w - r, y + h)
		love.graphics.line(x + (w - r) / 2, y + h, x + w / 2, y + r + h)
		love.graphics.line(x + w / 2, y + r + h, x + (w + r) / 2, y + h)
	else
		love.graphics.line(x + r, y + h, x + w - r, y + h)
	end

	love.graphics.line(x, y + r, x, y + h - r)
	love.graphics.line(x + w, y + r, x + w, y + h - r)
	love.graphics.setColor(color)
	love.graphics.setScissor(x - camXOff, y - camYOff, r, r)
		love.graphics.circle('fill', x + r, y + r, r)
		love.graphics.setColor(border)
		love.graphics.circle('line', x + r, y + r, r, 15)
		love.graphics.setColor(color)
	love.graphics.setScissor(x + w - r - camXOff, y - camYOff, r, r)
		love.graphics.circle('fill', x + w - r, y + r, r)
		love.graphics.setColor(border)
		love.graphics.circle('line', x + w - r, y + r, r, 15)
		love.graphics.setColor(color)
	love.graphics.setScissor(x - camXOff, y + h - r - camYOff, r, r)
		love.graphics.circle('fill', x + r, y + h - r, r)
		love.graphics.setColor(border)
		love.graphics.circle('line', x + r, y + h - r, r, 15)
		love.graphics.setColor(color)
	love.graphics.setScissor(x + w - r - camXOff, y + h - r - camYOff, r, r)
		love.graphics.circle('fill', x + w - r, y + h - r, r)
		love.graphics.setColor(border)
		love.graphics.circle('line', x + w - r, y + h - r, r, 15)
		love.graphics.setColor(color)
	love.graphics.setScissor()
end

function drawQuote(x, y, quoteTable, b, ...)
	if type(quoteTable) == 'table' and type(quoteTable[1]) == 'string' and #quoteTable[1] > 0 then
		local longestQuoteLength = 0

		for i, v in ipairs(quoteTable) do
			longestQuoteLength = #v > longestQuoteLength and #v or longestQuoteLength
		end

		local w = longestQuoteLength * 8
		roundedRectangle(x - w / 2, y + 24, w, #quoteTable * 20, 10, b, ...)
		love.graphics.setColor(b)
		love.graphics.setFont(quoteFont)

		for i, v in ipairs(quoteTable) do
			love.graphics.printf(v, x - w / 2, y + (i - 1) * 20 + 24, w, 'center')
		end
		
		love.graphics.setFont(defaultFont)
	end
end
