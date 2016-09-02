local map = {}
local cells = {}

local cx,cy = 400,400
local inner = 0
local data = love.image.newImageData(800, 800)
local canvas =love.graphics.newCanvas()
local tmp = 1

local function newCell()
	local angle = love.math.random()*1000
	local cell = {
		math.floor(math.sin(angle)*(150+inner)+400),
		math.floor(math.cos(angle)*(150+inner)+400),
	}
	table.insert(cells, cell)
end

local function cellWalk(c)
	local dx = love.math.random(-tmp,tmp)
	local dy = love.math.random(-tmp,tmp)
	c[1] = c[1] + dx
	c[2] = c[2] + dy
	c[1] = c[1] < 0 and 799 or c[1]
	c[1] = c[1] > 799 and 0 or c[1]
	c[2] = c[2] < 0 and 799 or c[2]
	c[2] = c[2] > 799 and 0 or c[2]
end

local hsv ={0,1,255}

local function cellSet(c)
	data:setPixel(c[1],c[2],255,255,255,255)
	local t = math.max(math.abs(c[1]-400),math.abs(c[2]-400))
	inner = inner<t and t or inner
	love.graphics.setCanvas(canvas)
	hsv[1] = (t/400)*360
	love.graphics.setColor(math.HSVtoRGB(unpack(hsv)))
	love.graphics.points(c[1],c[2])
	love.graphics.setCanvas()
end

local function quadcheck(x,y)
	if x<0 or x>799 or y<0 or y>799  then return end
	return true
end


local function cellCheck(c)
	local x,y = c[1],c[2]
	if quadcheck(x-1,y) and data:getPixel(x-1,y) ~= 0 then return true end
	if quadcheck(x+1,y) and data:getPixel(x+1,y) ~= 0 then return true end
	if quadcheck(x-1,y-1) and data:getPixel(x-1,y-1) ~= 0 then return true end
	if quadcheck(x+1,y-1) and data:getPixel(x+1,y-1) ~= 0 then return true end
	if quadcheck(x,y-1) and data:getPixel(x,y-1) ~= 0 then return true end
	if quadcheck(x-1,y+1) and data:getPixel(x-1,y+1) ~= 0 then return true end
	if quadcheck(x+1,y+1) and data:getPixel(x+1,y+1) ~= 0 then return true end
	if quadcheck(x,y+1) and data:getPixel(x,y+1) ~= 0 then return true end
end





function love.load()
	cellSet({cx,cy})
	for i = 1, 50000 do
		newCell()
	end
end


function love.update()
	for i = #cells , 1 , -1 do
		local cell = cells[i]
		cellWalk(cell)
		if cellCheck(cell) then
			table.remove(cells, i)
			cellSet(cell)		
			newCell()
		end
	end
	love.window.setTitle(love.timer.getFPS())
end

function love.draw()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(canvas)
	love.graphics.setColor(0, 255, 100, 255)
	for i,v in ipairs(cells) do
		love.graphics.points(v[1], v[2])
	end
	--[[
	love.graphics.setColor(0, 100, 255, 255)
	for i,v in ipairs(map) do
		love.graphics.points(v[1], v[2])
	end]]
	
end



function math.HSVtoRGB(h,s,v)
  local r,g,b
  local x,y,z
  if s==0 then
	r=v;g=v;b=v
  else
	h=h/60
	i=math.floor(h)
	f=h-i
	x=v*(1-s)
	y=v*(1-s*f)
	z=v*(1-s*(1-f))
  end   
  if i==0 then
	r=v;g=z;b=x
  elseif i==1 then
	r=y;g=v;b=x
  elseif i==2 then
	r=x;g=v;b=z
  elseif i==3 then
	r=x;g=y;b=v
  elseif i==4 then
	r=z;g=x;b=v
  elseif i==5 then
	r=v;g=x;b=y
  else
	r=v;g=z;b=x
  end
  return math.floor(r),math.floor(g),math.floor(b)
end