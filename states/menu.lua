menu = {}

function menu:enter()
    
end

function menu:update(dt)

end

function menu:keypressed(key, code)
    if console.keypressed(key) then
        return
    end

    if key == 'return' then
        state.switch(game)
    end
end

function menu:mousepressed(x, y, mbutton)
    if console.mousepressed(x, y, mbutton) then
        return
    end
    
    state.switch(game)
end

function menu:draw()
    local text = "ENTER"
    local x = love.window.getWidth()/2 - font[48]:getWidth(text)/2
    local y = love.window.getHeight()/2
    love.graphics.setFont(font[48])
    love.graphics.print(text, x, y)
end