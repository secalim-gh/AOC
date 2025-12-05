package main

import (
	"fmt"
	"os"
	"strconv"
	s "strings"
  "sort"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

type Node struct {
  lval uint64
  rval uint64
  lnode *Node
  rnode *Node
}

type BTree struct {
  root *Node
  count uint32
}

func (t *BTree) print() {
	if t.root == nil {
		fmt.Println("Empty Tree")
		return
	}
	t.walkAndPrint(t.root)
  fmt.Println(t.count, "nodes")
}

func (t *BTree) walkAndPrint(n *Node) {
	if n == nil {
		return
	}
	t.walkAndPrint(n.lnode)
	fmt.Printf("(%d, %d)\n", n.lval, n.rval)
	t.walkAndPrint(n.rnode)
}

func (t *BTree) add(node *Node) {
  t.count++
  if t.root == nil {
    t.root = node
    return
  }

  n := t.root
  var p *Node   

  for n != nil {
    p = n 
    if node.lval <= n.lval {
      n = n.lnode 
    } else {
      n = n.rnode 
    }
  }

  if node.lval <= p.lval {
    p.lnode = node
  } else {
    p.rnode = node
  }
}
	
func treeFromString(str string) BTree {
  t := BTree{nil, 0}
  clean := s.Split(str, "\n")
  var nodes []*Node

  for _, v := range clean {
    u := s.Split(v, "-")
    if len(s.TrimSpace(v)) == 0 {
      continue
    }
    n, _ := strconv.ParseUint(s.TrimSpace(u[0]), 10, 64)
    n2, _ := strconv.ParseUint(s.TrimSpace(u[1]), 10, 64)
    nodes = append(nodes, &Node{n, n2, nil, nil})
  }

  sort.Slice(nodes, func(i, j int) bool {
    return nodes[i].lval < nodes[j].lval
  })

  if len(nodes) == 0 {
    return t
  }

  merged := []*Node{nodes[0]}
  for i := 1; i < len(nodes); i++ {
    last := merged[len(merged)-1]
    curr := nodes[i]

    if curr.lval <= last.rval {
      if curr.rval > last.rval {
        last.rval = curr.rval
      }
    } else {
      merged = append(merged, curr)
    }
  }

  for _, node := range merged {
    t.add(node)
  }

  return t
}

func (t *BTree) isFresh(n uint64) bool {
  if nil == t.root { return false }
  node := t.root
  for node != nil {
    if n < node.lval {
      node = node.lnode 
    } else if n > node.rval  {
      node = node.rnode 
    } else {
      return true
    }
  }
  return false
}

func main() {
	argc := len(os.Args)
	if argc < 2 {
		fmt.Println("Provide filepath");
		return	
	}
  
	fpath := os.Args[1]
	wholefile, err := os.ReadFile(fpath)
  check(err)
  
  strdata := string(wholefile)
  i := s.LastIndex(strdata, "\n\n")
  tree := treeFromString(strdata[:i])

  ids := s.Split(strdata[i+2:], "\n")
  fresh_products := 0
  ids = ids[:len(ids)-1]
  for _, id := range ids {
    n, _ := strconv.ParseUint(id, 10, 64)
    if tree.isFresh(uint64(n)) {
      fresh_products++
    }
  }
  
  fmt.Println("There are", fresh_products, "fresh products")
}
