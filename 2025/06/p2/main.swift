import Foundation

func calc(current: Int, op: Character, value: String) -> Int {
  guard let number = Int(value) else { return current }
  switch op {
    case "+":
      return current + number
    case "-":
      return current - number
    case "*":
      return current * number
    default:
      return current
  }
}

let arguments = CommandLine.arguments

if arguments.count < 2 {
  print("Error: Missing filename argument.")
} else {
  let path = arguments[1]
  let content = try String(contentsOfFile: path, encoding: .utf8)
	
  var lines = content.split(separator: "\n")
  let operators = lines.popLast()!.replacingOccurrences(of: " ", with: "")
	
	let len = lines[0].count - 1
	
	var cols: [[Int]] = [[]]
	var colidx = 0
	for i in 0...len {
		var t = ""
		for line in lines {
			let index = line.index(line.startIndex, offsetBy: i)
			if line[index] != " " {
				t.append(line[index])
			}
		}
		let n = Int(t)
		if n != nil {
			cols[colidx].append(n!)
		} else {
			cols.append([])
			colidx += 1
		}
	}
	var results: [Int] = []
	for (i, op) in operators.enumerated() {
		var n: Int = 0
		switch op {
			case "+":
				n = cols[i].reduce(0, +)
			case "*":
				n = cols[i].reduce(1, *)
			default:
				print("Fuck")	
		}
		results.append(n)
	}
	let result = results.reduce(0, +)
	print(result)
}
