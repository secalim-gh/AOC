require "table.new"
if #arg < 1 then
	print "Provide filepath"
	return
end

local input = io.open(arg[1]):read("*a")
local abs = math.abs
local min = math.min
local max = math.max
local floor = math.floor

local function bisect_left(t, x, key_func)
	key_func = key_func or function(v) return v end
	local low, high = 1, #t + 1
	while low < high do
		local mid = low + floor((high - low) / 2)
		if key_func(t[mid]) < x then
			low = mid + 1
		else
			high = mid
		end
	end
	return low
end

local function bisect_right(t, x, key_func)
	key_func = key_func or function(v) return v end
	local low, high = 1, #t + 1
	while low < high do
		local mid = low + floor((high - low) / 2)
		if key_func(t[mid]) <= x then
			low = mid + 1
		else
			high = mid
		end
	end
	return low
end

local function is_valid(x0, y0, x1, y1, horz, vert)
	if x0 > x1 then x0, x1 = x1, x0 end
	if y0 > y1 then y0, y1 = y1, y0 end

	local key_func = function(u) return u[1] end

	local l = bisect_left(horz, y0, key_func)
	local r = bisect_right(horz, y1, key_func)

	for i = l, r - 1 do
		local edge = horz[i]
		local y, s, e = edge[1], edge[2], edge[3]

		if y0 < y and y < y1 and min(s, e) < x1 and max(s, e) > x0 then
			return false
		end
	end

	l = bisect_left(vert, x0, key_func)
	r = bisect_right(vert, x1, key_func)

	for i = l, r - 1 do
		local edge = vert[i]
		local x, s, e = edge[1], edge[2], edge[3]

		if x0 < x and x < x1 and min(s, e) < y1 and max(s, e) > y0 then
			return false
		end
	end

	return true
end

local points = {}
for line in string.gmatch(input, "[^\n]+") do
	local next_num = string.gmatch(line, "%d+")
	local x, y = tonumber(next_num()), tonumber(next_num())
	if x and y then
		table.insert(points, { x = x, y = y})
	end
end

local N = #points
if N < 2 then return end

local bounds = table.new(N, 0)
for i = 1, N do
	local p1 = points[i]
	local p2 = points[i % N + 1]
	bounds[i] = {p1, p2}
end

local horz = table.new(N/2, 0)
local vert = table.new(N/2, 0)

local hi, vi = 0, 0
for _, edge in ipairs(bounds) do
	local p1 = edge[1]
	local p2 = edge[2]

	if p1.y == p2.y then
		horz[hi] = {p1.y, p1.x, p2.x}
		hi = hi + 1
	elseif p1.x == p2.x then
		vert[vi] = {p1.x, p1.y, p2.y}
		vi = vi + 1
	end
end

table.sort(horz, function(a, b) return a[1] < b[1] end)
table.sort(vert, function(a, b) return a[1] < b[1] end)

local maxArea = 0

for i = 1, N - 1 do
	local p1 = points[i]
	local x0, y0 = p1.x, p1.y

	for k = i + 1, N do
		local p2 = points[k]
		local x1, y1 = p2.x, p2.y

		local area = (abs(x0 - x1) + 1) * (abs(y0 - y1) + 1)

		if area > maxArea then
			if is_valid(x0, y0, x1, y1, horz, vert) then
				maxArea = area
			end
		end
	end
end

print(maxArea)
