MAIN1="p1/main.swift"
MAIN2="p2/main.swift"

p1/main.out: p1/main.swift
	xcrun swiftc $(MAIN1) -o p1/main.out

INPT=""
run: p1/main.out
	./p1/main.out $(INPT)

p2/main.out: p2/main.swift
	xcrun swiftc $(MAIN2) -o p2/main.out

run2: p2/main.out
	./p2/main.out $(INPT)

