game = {}

function game:enter()
	love.graphics.setLineWidth(2)

	local x, y = love.graphics.getWidth()/2, love.graphics.getHeight()/2
    --self.shapes = {{x - 200, y - 200, x - 200, y + 200, x + 200, y + 200, x + 200, y - 200}}
	
	self.angle = math.rad(60)
	local dy = math.tan(self.angle)*200
	self.lines = {{x - 200, y + dy/2, x + 200, y + dy/2}, {x + 200, y + dy/2, x, y - dy/2}, {x, y - dy/2, x - 200, y + dy/2}}
	
	self.steps = 0
	
	self.x, self.y = x, y
	
	--self.canvas = love.graphics.newCanvas()
	
	--self.canvas:renderTo(function()
	--	love.graphics.polygon('line', self.shapes[1])
	--end)
end

function game:update(dt)

end

function game:keypressed(key, isrepeat)
    if console.keypressed(key) then
        return
    end
	
	if key == ' ' then
		--self.canvas:clear()
	
		local lineCount = #self.lines
		
		for i = lineCount, 1, -1 do
			local line = self.lines[i]
			local x1, y1, x2, y2 = line[1], line[2], line[3], line[4]
			
			
			local p1x, p1y = x1 + (x2-x1)/3, y1 + (y2-y1)/3
			local p2x, p2y = x1 + 2*(x2-x1)/3, y1 + 2*(y2-y1)/3
			
			local angle = math.angle(x1, y1, x2, y2)
			local dist = math.dist(p1x, p1y, p2x, p2y)
			
			local p3x, p3y = p1x + math.cos(angle+self.angle)*dist, p1y + math.sin(angle+self.angle)*dist
			
			table.remove(self.lines, i)
			
			table.insert(self.lines, {x1, y1, p1x, p1y})
			--table.insert(self.lines, {p1x, p1y, p2x, p2y})
			table.insert(self.lines, {p2x, p2y, x2, y2})
			
			table.insert(self.lines, {p1x, p1y, p3x, p3y})
			table.insert(self.lines, {p3x, p3y, p2x, p2y})
		end
	end
end

function game:mousepressed(x, y, mbutton)
    if console.mousepressed(x, y, mbutton) then
        return
    end
end

function game:draw()
	for i = 1, #self.lines do
		love.graphics.line(self.lines[i])
	end
	
	--love.graphics.draw(self.canvas)
	love.graphics.print(love.timer.getFPS(), 5, 5)
end