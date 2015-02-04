game = {}

function game:enter()
	self:resetValues()
	
	self:start()
end

function game:start()
	self.canvas = love.graphics.newCanvas()

	self.lines = {}
	self.step = 0
	
	local x, y = love.graphics.getWidth()/2, love.graphics.getHeight()/2
	local points = {}

	-- find points for a regular polygon of n sides
	for i = 1, self.sides do
		local angle = math.rad((360/self.sides)*i)
		local x1, y1 = x + math.cos(angle)*self.r, y + math.sin(angle)*self.r
		table.insert(points, x1)
		table.insert(points, y1)
	end
	
	-- store the lines between points
	for i = 1, #points-2, 2 do
		table.insert(self.lines, {points[i], points[i+1], points[i+2], points[i+3]})
	end
	table.insert(self.lines, {points[#points-1], points[#points], points[1], points[2]})
	
	
	game:drawCanvas()
end

function game:resetValues()
	-- default values
	self.sides = 3
	self.angle = 60
	self.angle1Multiplier = 1
	self.angle2Multiplier = 1
	self.removeNumerator = 1
	self.removeDenominator = 3
	self.maxSteps = 5 -- max iterations
	self.connectPoints = false -- when false, angle 2 is irrelevant
	self.cleanLines = true -- when true, canvas is cleared each iteration
	self.helpText = true
	self.preview = true
	self.r = 300 -- the shape will nearly fill the screen vertically
	
	
	love.graphics.setLineWidth(1)
	love.graphics.setLineStyle('rough')
end

function game:drawCanvas()
	self.canvas:renderTo(function()
		for i = 1, #self.lines do
			local r, g, b, a = HSL((256/#self.lines)*i, 255, 200, 255)
			love.graphics.setColor(r, g, b, a)
			love.graphics.line(self.lines[i])
		end
		love.graphics.setColor(255, 255, 255)
	end)
end

function game:update(dt)

end

function game:keypressed(key, isrepeat)
    if console.keypressed(key) then
        return
    end
	
	if key == ' ' then
		if self.step < self.maxSteps then
			if self.cleanLines then
				self.canvas:clear()
			end
		
			local lineCount = #self.lines
			
			for i = lineCount, 1, -1 do
				local line = self.lines[i]
				local x1, y1, x2, y2 = line[1], line[2], line[3], line[4]
				
				local remov = self.removeNumerator/self.removeDenominator
				local length = (1/2)-remov/2
				
				local p1x, p1y = x1 + length*(x2-x1), y1 + length*(y2-y1)
				local p2x, p2y = x1 + (1-length)*(x2-x1), y1 + (1-length)*(y2-y1)
				
				local angle = math.angle(x1, y1, x2, y2)
				local dist = math.dist(p1x, p1y, p2x, p2y)
				
				local p3x, p3y = p1x + math.cos(angle-math.rad(self.angle)*self.angle1Multiplier)*dist, p1y + math.sin(angle-math.rad(self.angle)*self.angle1Multiplier)*dist
				local p4x, p4y = p2x + math.cos(angle-math.rad(self.angle)*self.angle2Multiplier)*dist, p2y + math.sin(angle-math.rad(self.angle)*self.angle2Multiplier)*dist
				
				table.remove(self.lines, i)
				
				table.insert(self.lines, i, {x1, y1, p1x, p1y})
				--table.insert(self.lines, {p1x, p1y, p2x, p2y})
				table.insert(self.lines, i+1, {p2x, p2y, x2, y2})
				
				table.insert(self.lines, i+2, {p1x, p1y, p3x, p3y})
				if self.connectPoints then
					table.insert(self.lines, i+3, {p3x, p3y, p4x, p4y})
					table.insert(self.lines, i+4, {p4x, p4y, p2x, p2y})
				else
					table.insert(self.lines, i+5, {p3x, p3y, p2x, p2y})
				end
			end
			
			self.step = self.step+1
			
			
			self.canvas:renderTo(function()
				game:drawCanvas()
			end)
		end
	end
	
	if tonumber(key) and tonumber(key) > 2 and tonumber(key) < 10 then
		self.sides = tonumber(key)
		
		self:start()
	end
	
	
	if key == 'q' then self.angle1Multiplier = self.angle1Multiplier + 1 end
	if key == 'a' then self.angle1Multiplier = self.angle1Multiplier - 1 end
	if key == 'w' then self.angle2Multiplier = self.angle2Multiplier + 1 end
	if key == 's' then self.angle2Multiplier = self.angle2Multiplier - 1 end
	
	if key == 'e' then self.removeNumerator = self.removeNumerator + 1 end
	if key == 'd' then self.removeNumerator = self.removeNumerator - 1 end
	if key == 'r' then self.removeDenominator = self.removeDenominator + 1 end
	if key == 'f' then self.removeDenominator = self.removeDenominator - 1 end
	
	if key == 'y' then self.r = self.r + 20 self:start() end
	if key == 'h' then self.r = self.r - 20 self:start() end
	
	if key == 't' then
		if self.connectPoints then
			self.connectPoints = false
		else
			self.connectPoints = true
		end
	end
	
	if key == 'g' then
		if self.cleanLines then
			self.cleanLines = false
		else
			self.cleanLines = true
		end
	end
	
	if key == 'f1' then
		fullscreen, fstype = love.window.getFullscreen()
		if not fullscreen then
			love.window.setFullscreen(true, 'desktop')
			--self:start()
		else
			love.window.setFullscreen(false)
			--self:start()
		end
	end
	
	if key == 'f2' then
		self:resetValues()
		self:start()
	end
	
	if key == 'f3' then
		if self.helpText then
			self.helpText = false
		else
			self.helpText = true
		end
	end
	
	if key == 'f4' then
		if self.preview then
			self.preview = false
		else
			self.preview = true
		end
	end
end

function game:mousepressed(x, y, mbutton)
    if console.mousepressed(x, y, mbutton) then
        return
    end
	
	if mbutton == 'wu' then self.angle = self.angle + 1 end
	if mbutton == 'wd' then self.angle = self.angle - 1 end
end

function game:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.setFont(font[24])
	
	
	love.graphics.draw(self.canvas)
	love.graphics.print('FPS: '..love.timer.getFPS(), 5, 5)
	love.graphics.print('Iterations: '..self.step..'/'..self.maxSteps, 5, 35)
	love.graphics.print('Angle: '..self.angle..' degrees', 5, 65)
	love.graphics.print('(q/a) angle1: '..self.angle1Multiplier..'x', 5, 95)
	love.graphics.print('(w/s) angle2: '..self.angle2Multiplier..'x', 5, 125)
	love.graphics.print('(e/d) (r/f) remove %: '..self.removeNumerator..'/'..self.removeDenominator, 5, 155)
	
	love.graphics.print('(y/h) radius: '..self.r, 5, 185)
	
	local status = 'off'
	if self.cleanLines then status = 'on' end
	love.graphics.print('(g) clean lines: '..status, 5, 215)
	
	local status = 'off'
	if self.connectPoints then status = 'on' end
	love.graphics.print('(t) extra line: '..status, 5, 245)
	
	
	
	if self.helpText then
		love.graphics.print('(f1) fullsreen', 5, love.graphics.getHeight()-220)
		love.graphics.print('(f2) default values', 5, love.graphics.getHeight()-190)
		love.graphics.print('(f3) hide help text', 5, love.graphics.getHeight()-160)
		love.graphics.print('(f4) hide preview', 5, love.graphics.getHeight()-130)
		love.graphics.print('mousewheel to change angle', 5, love.graphics.getHeight()-100)
		love.graphics.print('3-9 to set sides', 5, love.graphics.getHeight()-70)
		love.graphics.print('Press "space" to iterate', 5, love.graphics.getHeight()-40)
	end
	
	
	
	
	-- preview
	if self.preview then
		local dist = 150
		local x1, y1 = love.graphics.getWidth() - 50 - dist, love.graphics.getHeight() - 100
		local x2, y2 = x1 + dist, y1
		
		local remov = self.removeNumerator/self.removeDenominator
		local length = (1/2)-remov/2
		
		local p1x, p1y = x1 + length*(x2-x1), y1 + length*(y2-y1)
		local p2x, p2y = x1 + (1-length)*(x2-x1), y1 + (1-length)*(y2-y1)
		
		local angle = math.angle(x1, y1, x2, y2)
		local dist = math.dist(p1x, p1y, p2x, p2y)
		
		local p3x, p3y = p1x + math.cos(angle-math.rad(self.angle)*self.angle1Multiplier)*dist, p1y + math.sin(angle-math.rad(self.angle)*self.angle1Multiplier)*dist
		local p4x, p4y = p2x + math.cos(angle-math.rad(self.angle)*self.angle2Multiplier)*dist, p2y + math.sin(angle-math.rad(self.angle)*self.angle2Multiplier)*dist
		
		
		
		love.graphics.setColor(0, 255, 0)
		love.graphics.line(p1x, p1y, p3x, p3y)
		if self.connectPoints then
			love.graphics.line(p3x, p3y, p4x, p4y)
			love.graphics.line(p4x, p4y, p2x, p2y)
		else
			love.graphics.line(p3x, p3y, p2x, p2y)
		end
		
		love.graphics.setLineWidth(4)
		love.graphics.setColor(255, 255, 255)
		love.graphics.line(x1, y1, x2, y2)
		
		if self.cleanLines then
			love.graphics.setColor(255, 0, 0)
			love.graphics.line(p1x, p1y, p2x, p2y)
		end
		
		love.graphics.setColor(255, 255, 255)
		
		love.graphics.print('Preview', x1-50, y1-50)
	end
end

function game:resize(w, h)
	self:start()
end