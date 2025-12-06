import Foundation

let arguments = CommandLine.arguments

if arguments.count < 2 {
	print("Error: Missing filename argument.")
} else {
	let path = arguments[1]
	let content = try String(contentsOfFile: path, encoding: .utf8)

	var c = content.split(separator: "\n")
	let operators = c.popLast()!.replacingOccurrences(of: " ", with: "")
	let lines = c.map {
		$0.split(separator: " ").map { Int($0)! }
	}

	let columnCount = lines[0].count
	let rotated = (0..<columnCount).map { i in
		lines.map { $0[i] }
	}
	
	var results: [Int] = []
	for (i, op) in operators.enumerated() {
		switch op {
			case "+":
				results.append(rotated[i].reduce(0, +))
			case "*":
				results.append(rotated[i].reduce(1, *))
			default:
				print("Unexpected operator")
		}
	}
	let result = results.reduce(0, +)
	print(result)
}
