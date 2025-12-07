TEXT = ARGF.read
WIDTH = TEXT.index("\n") + 1
HEIGHT = TEXT.count("\n") - 1

def walk(x, y)
  return 0 if x > WIDTH - 2 or x < 0 or y > HEIGHT
  idx = x + y * WIDTH
  return 0 if TEXT[idx] == "o"
  return walk(x, y + 1) if TEXT[idx] != "^"
  TEXT[idx] = "o"
  return 1 + walk(x - 1, y + 1) + walk(x + 1, y + 1)
end

MEMO = Array.new(HEIGHT + 1) { Array.new(WIDTH, 0) }
def count_paths(x, y)
  return 0 if x > WIDTH - 2 or x < 0 or y > HEIGHT 
  return MEMO[y][x] unless MEMO[y][x].zero? 

  paths = 0
  if y == HEIGHT
    paths = 1 
  elsif TEXT[x + y * WIDTH] != "o"
    paths = count_paths(x, y + 1)
  else
    paths = count_paths(x - 1, y + 1) + count_paths(x + 1, y + 1)
  end

  return MEMO[y][x] = paths 
end


start = TEXT.index("S")
puts "#{walk(start, 0)} splits"
puts "#{count_paths(start, 0)} timelines"
