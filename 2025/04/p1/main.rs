use std::env;
use std::fs;

struct PaperRolls {
    columns: i32,
    rows: i32,
    rolls: String,
    accessibles: u16,
}

fn main() {
    let args: Vec<String> = env::args().collect();

    if args.len() < 2 {
        eprintln!("Usage: {} <input_file>", args[0]);
        return;
    }

    let mut grid = parse_grid(&args);
    println!("cols: {}, rows: {}", grid.columns, grid.rows);
    process_all(&mut grid);

    println!("Total accessible spots: {}", grid.accessibles);
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

    let accessibles = 0;

    PaperRolls {
        columns,
        rows,
        rolls: clean_rolls,
        accessibles,
    }
}

fn process_all(p: &mut PaperRolls) {
    let count = (0..p.rolls.len())
        .filter(|&i| is_accessible(i, p))
        .count();

    p.accessibles = count as u16;
}

fn is_accessible(idx: usize, p: &PaperRolls) -> bool {
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
    count < 4
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
