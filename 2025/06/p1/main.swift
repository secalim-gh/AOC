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

  var c = content.split(separator: "\n")
  let operators = c.popLast()!.replacingOccurrences(of: " ", with: "")
  var lines = c.map {
    $0.split(separator: " ").map { String($0) }
  }

  let firstLine = lines.removeFirst()
  var results: [Int] = firstLine.map { Int($0)! }
  
  for (i, op) in operators.enumerated() {
    for line in lines {
      let number = line[i]
      results[i] = calc(current: results[i], op: op, value: number)
    }
  }
  let result = results.reduce(0, +)
  print(result)
}
