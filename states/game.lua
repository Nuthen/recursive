game = {}

function game:enter()
	love.graphics.setLineWidth(2)

	local x, y = love.graphics.getWidth()/2, love.graphics.getHeight()/2
    --self.shapes = {{x - 200, y - 200, x - 200, y + 200, x + 200, y + 200, x + 200, y - 200}}
	
	self.angle = math.rad(60)
	--local dy = math.tan(self.angle)*200
	--self.lines = {{x - 200, y + dy/2, x + 200, y + dy/2}, {x + 200, y + dy/2, x, y - dy/2}, {x, y - dy/2, x - 200, y + dy/2}}
	--self.lines = {{x - 200, y - 200, x - 200, y + 200}, {x - 200, y + 200, x + 200, y + 200}, {x + 200, y + 200, x + 200, y - 200}, {x + 200, y - 200, x - 200, y - 200}}
	
	self.lines = {}
	
	self.sides = 3
	self.points = {}
	
	self.r = 200
	
	self.p3xModifier = 1
	self.p3yModifier = 1
	self.p4xModifier = 1
	self.p4yModifier = 1
	
	self.connectPoints = false
	
	
	self:start()
	
	
	self.step = 0
	
	self.x, self.y = x, y
	
	--self.canvas = love.graphics.newCanvas()
	
	--self.canvas:renderTo(function()
	--	love.graphics.polygon('line', self.shapes[1])
	--end)
end

function game:start()
	local x, y = love.graphics.getWidth()/2, love.graphics.getHeight()/2

	self.lines = {}
	self.step = 0
	--self.sides = 3
	self.points = {}
	
	self.r = 200

	for i = 1, self.sides do
		local angle = math.rad((360/self.sides)*i)
		local x1, y1 = x + math.cos(angle)*self.r, y + math.sin(angle)*self.r
		table.insert(self.points, {x1, y1})
	end
	
	for i = 1, #self.points-1 do
		table.insert(self.lines, {self.points[i][1], self.points[i][2], self.points[i+1][1], self.points[i+1][2]})
	end
	table.insert(self.lines, {self.points[#self.points][1], self.points[#self.points][2], self.points[1][1], self.points[1][2]})
end

function game:update(dt)

end

function game:keypressed(key, isrepeat)
    if console.keypressed(key) then
        return
    end
	
	if key == ' ' then
		if self.step < 5 then
	
			--self.canvas:clear()
		
			local lineCount = #self.lines
			
			for i = lineCount, 1, -1 do
				local line = self.lines[i]
				local x1, y1, x2, y2 = line[1], line[2], line[3], line[4]
				
				
				local p1x, p1y = x1 + (x2-x1)/3, y1 + (y2-y1)/3
				local p2x, p2y = x1 + 2*(x2-x1)/3, y1 + 2*(y2-y1)/3
				
				local angle = math.angle(x1, y1, x2, y2)
				local dist = math.dist(p1x, p1y, p2x, p2y)
				
				local p3x, p3y = p1x + math.cos(angle-self.p3xModifier*self.angle)*dist, p1y + math.sin(angle-self.p3yModifier*self.angle)*dist
				local p4x, p4y = p2x + math.cos(angle+self.p4xModifier*self.angle)*dist, p2y + math.sin(angle+self.p4yModifier*self.angle)*dist
				
				table.remove(self.lines, i)
				
				table.insert(self.lines, {x1, y1, p1x, p1y})
				--table.insert(self.lines, {p1x, p1y, p2x, p2y})
				table.insert(self.lines, {p2x, p2y, x2, y2})
				
				table.insert(self.lines, {p1x, p1y, p3x, p3y})
				if self.connectPoints then
					table.insert(self.lines, {p3x, p3y, p4x, p4y})
					table.insert(self.lines, {p4x, p4y, p2x, p2y})
				else
					table.insert(self.lines, {p3x, p3y, p2x, p2y})
				end
			end
			
			self.step = self.step+1
		end
	end
	
	if tonumber(key) and tonumber(key) > 2 and tonumber(key) < 10 then
		self.sides = tonumber(key)
		
		self:start()
	end
	
	if key == 'q' then self.p3xModifier = self.p3xModifier+1 end
	if key == 'a' then self.p3xModifier = self.p3xModifier-1 end
	if key == 'w' then self.p3yModifier = self.p3yModifier+1 end
	if key == 's' then self.p3yModifier = self.p3yModifier-1 end
	if key == 'e' then self.p4xModifier = self.p4xModifier+1 end
	if key == 'd' then self.p4xModifier = self.p4xModifier-1 end
	if key == 'r' then self.p4yModifier = self.p4yModifier+1 end
	if key == 'f' then self.p4yModifier = self.p4yModifier-1 end
	
	if key == 't' then
		if self.connectPoints then
			self.connectPoints = false
		else
			self.connectPoints = true
		end
	end
end

function game:mousepressed(x, y, mbutton)
    if console.mousepressed(x, y, mbutton) then
        return
    end
	
	if mbutton == 'wu' then self.angle = self.angle + math.rad(3) end
	if mbutton == 'wd' then self.angle = self.angle - math.rad(3) end
end

function game:draw()
	for i = 1, #self.lines do
		love.graphics.line(self.lines[i])
	end
	
	--love.graphics.draw(self.canvas)
	love.graphics.print('FPS: '..love.timer.getFPS(), 5, 5)
	love.graphics.print('angle: '..math.deg(self.angle)..' degrees', 5, 50)
	love.graphics.print('Iterations: '..self.step..'/5', 5, 95)
	
	love.graphics.print('Press "space" to iterate', 5, love.graphics.getHeight()-70)
	love.graphics.print('3-9 to set sides', 5, love.graphics.getHeight()-120)
	love.graphics.print('mousewheel to change angle', 5, love.graphics.getHeight()-170)
	love.graphics.print('"t" to toggle extra line', 5, love.graphics.getHeight()-220)
	
	love.graphics.print('(q/a) p3xModifier: '..self.p3xModifier, love.graphics.getWidth()-450, 5)
	love.graphics.print('(w/s) p3yModifier: '..self.p3yModifier, love.graphics.getWidth()-450, 50)
	love.graphics.print('(e/d) p4xModifier: '..self.p4xModifier, love.graphics.getWidth()-450, 95)
	love.graphics.print('(r/f) p4yModifier: '..self.p4yModifier, love.graphics.getWidth()-450, 140)
end