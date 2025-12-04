use std::env;
use std::fs;

struct PaperRolls {
    columns: i32,
    rows: i32,
    rolls: String,
    backbuf: String,
    removed: u16,
}

fn main() {
    let args: Vec<String> = env::args().collect();

    if args.len() < 2 {
        eprintln!("Usage: {} <input_file>", args[0]);
        return;
    }

    let mut grid = parse_grid(&args);
    while process_all(&mut grid) > 0 {};

    println!("Total rolls removed: {}", grid.removed);
}

fn parse_grid(args: &[String]) -> PaperRolls {
    let rolls_with_newlines = fs::read_to_string(&args[1])
        .expect("Should have been able to read the file");
    let columns = rolls_with_newlines
        .find('\n')
        .expect("No newlines") as i32;
    
    // get a flat grid string
    let clean_rolls: String = rolls_with_newlines
        .chars()
        .filter(|c| !c.is_whitespace())
        .collect();

    // recalculate rows
    let total_elements = clean_rolls.len() as i32;
    if total_elements % columns != 0 {
        eprintln!("Grid is not rectangular");
    }
    let rows = total_elements / columns;
    let backbuf = clean_rolls.clone();
    let removed = 0;

    PaperRolls {
        columns,
        rows,
        rolls: clean_rolls,
        backbuf,
        removed,
    }
}

fn process_all(p: &mut PaperRolls) -> u16 {
    let count = (0..p.rolls.len())
        .filter(|&i| is_accessible(i, p))
        .count();

    p.removed += count as u16;

    p.rolls.clone_from(&p.backbuf);

    count as u16
}

fn is_accessible(idx: usize, p: &mut PaperRolls) -> bool {
    let w = p.columns as usize;
    let x = (idx % w) as i32;
    let y = (idx / w) as i32;
    let mut count = 0;
    
    if !is_paper(x, y, p) {
        return false;
    }
    for i in -1..=1 {
        for k in -1..=1 {
            if i == 0 && k == 0 { continue };
            if is_paper(x+i, y+k, p) {
                count += 1
            };
        }
    }
    
    if count < 4 {
        set_value(x, y, p, '.'); 
    }
    count < 4
}

fn set_value(x: i32, y: i32, p: &mut PaperRolls, c: char) {
    let idx: usize = (x + y * p.columns) as usize;
    
    if idx < p.backbuf.len() {
        let bytes = p.backbuf.as_bytes_mut(); 
        bytes[idx] = c as u8;
    }
}

fn is_paper(x: i32, y: i32, p: &PaperRolls) -> bool {
    if x < 0 || y < 0 || x >= p.columns || y >= p.rows {
        return false; 
    }

    let idx: usize = (x + y * p.columns) as usize;

    if idx >= p.rolls.len() {
        return false;
    }

    let b = p.rolls.as_bytes()[idx];

    if b == b'@' {
        return true;
    } else {
        return false;
    }
}

trait StringExt {
    fn as_bytes_mut(&mut self) -> &mut [u8];
}

impl StringExt for String {
    fn as_bytes_mut(&mut self) -> &mut [u8] {
        unsafe {
            let s = self.as_mut_vec();
            std::slice::from_raw_parts_mut(s.as_mut_ptr(), s.len())
        }
    }
}
