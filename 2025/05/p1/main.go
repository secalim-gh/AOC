package main

import (
	"fmt"
	"os"
	// "strconv"
	s "strings"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
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
	strdata := s.Split(string(wholefile[:]), "-")
	// for s.Compare(strdata, "\n") == 0 {
		fmt.Println(strdata[0])
  //}
		
	// u, _ := strconv.ParseUint("789", 0, 64)
	// fmt.Println(u)
}
