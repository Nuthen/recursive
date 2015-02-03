game = {}

function game:enter()
	local x, y = love.graphics.getWidth()/2, love.graphics.getHeight()/2
    self.shapes = {{x - 200, y - 200, x - 200, y + 200, x + 200, y + 200, x + 200, y - 200}}
	
	self.steps = 0
	
	self.canvas = love.graphics.newCanvas()
	
	self.canvas:renderTo(function()
		love.graphics.polygon('line', self.shapes[1])
	end)
end

function game:update(dt)

end

function game:keypressed(key, isrepeat)
    if console.keypressed(key) then
        return
    end
	
	if key == ' ' then
		local shapeCount = #self.shapes
		
		for i = 1, shapeCount do
			local shape = self.shapes[i]
			
			if self.steps % 2 == 0 then
				local x1, y1 = math.midpoint(shape[1], shape[2], shape[3], shape[4])
				local x2, y2 = math.midpoint(shape[5], shape[6], shape[7], shape[8])
				
				table.insert(self.shapes, {x1, y1, shape[3], shape[4], shape[5], shape[6], x2, y2})
				
				self.shapes[i][3] = x1
				self.shapes[i][4] = y1
				self.shapes[i][5] = x2
				self.shapes[i][6] = y2
				
				self.canvas:renderTo(function()
					love.graphics.polygon('line', x1, y1, shape[3], shape[4], shape[5], shape[6], x2, y2)
					love.graphics.polygon('line', self.shapes[i])
				end)
			else
				local x1, y1 = math.midpoint(shape[1], shape[2], shape[7], shape[8])
				local x2, y2 = math.midpoint(shape[3], shape[4], shape[5], shape[6])
				
				table.insert(self.shapes, {x1, y1, x2, y2, shape[5], shape[6], shape[7], shape[8]})
				
				self.shapes[i][5] = x1
				self.shapes[i][6] = y1
				self.shapes[i][7] = x2
				self.shapes[i][8] = y2
				
				self.canvas:renderTo(function()
					love.graphics.polygon('line', x1, y1, x2, y2, shape[5], shape[6], shape[7], shape[8])
					love.graphics.polygon('line', self.shapes[i])
				end)
			end
		end
		
		self.steps = self.steps + 1
	end
end

function game:mousepressed(x, y, mbutton)
    if console.mousepressed(x, y, mbutton) then
        return
    end
end

function game:draw()
	--for i = 1, #self.shapes do
	--	love.graphics.polygon('line', self.shapes[i])
	--end
	
	love.graphics.draw(self.canvas)
	love.graphics.print(love.timer.getFPS(), 5, 5)
end