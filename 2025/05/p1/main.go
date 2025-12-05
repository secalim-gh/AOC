package main

import (
	"fmt"
	"os"
	"strconv"
	s "strings"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

struct Node {
  
}

func main() {
	argc := len(os.Args)
	if argc < 2 {
		fmt.Println("Provide filepath");
		return	
	}
	fpath := os.Args[1]
	fmt.Println("Filepath is", fpath);
	wholefile, err := os.ReadFile(fpath)
  check(err)
  strdata := string(wholefile)
	clean := s.Split(strdata, "\n")
  for _, v := range clean {
    u := s.Split(v[:], "-")
    if len(u[0]) == 0 { break }
    n, _ := strconv.ParseUint(u[0], 10, 32)
    n2, _ := strconv.ParseUint(u[1], 10, 32)
    fmt.Println(n, n2)
  }
		
}
