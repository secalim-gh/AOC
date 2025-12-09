if #arg < 1 then
	print "Provide filepath"
	return
end

local input = io.open(arg[1]):read("*a")
local parse = coroutine.wrap(function (s)
	for line in string.gmatch(s, "[^\n]+") do
		local next = string.gmatch(line, "%d+")
		local t = {
			x = tonumber(next()) + 1,
			y = tonumber(next()) + 1,
		}
		coroutine.yield(t)
	end
end)

local t = parse(input)
local points = {}

local map = {width = 0, height = 0}
while t do
	table.insert(points, t)
	if t.x > map.width then
		map.width = t.x
	end
	if t.y > map.height then
		map.height = t.y
	end
	t = parse()
end

local abs = math.abs
local function area(p1, p2)
	local dx = abs(p1.x - p2.x) + 1
	local dy = abs(p1.y - p2.y) + 1
	return dx * dy
end

local maxArea = 0
for i = 1, #points - 1, 1 do
	local p = points[i]
	for k = i + 1, #points, 1 do
		local p2 = points[k]
		local a = area(p, p2)
		if a > maxArea then
			maxArea = a
		end
	end
end

print(maxArea)
