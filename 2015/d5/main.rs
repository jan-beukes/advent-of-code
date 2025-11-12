#![allow(dead_code)]

const INPUT: &'static str = include_str!("input.txt");

fn is_nice(string: &str) -> bool {
    let black_list = &["ab", "cd", "pq", "xy"];
    let vowels = &['a', 'e', 'i', 'o', 'u'];

    (string.split(vowels).count() > 3) &&
    (!black_list.iter().any(|word| string.contains(word))) &&
    string.as_bytes().windows(2).any(|s| s[0] == s[1])
}

fn is_nice2(string: &str) -> bool {
    let bytes = string.as_bytes();
    bytes.windows(3).any(|s| s[0] == s[2]) &&
    bytes.windows(2).enumerate().any(|(i, s)| 
        match string.rfind(str::from_utf8(s).unwrap()) {
            None     => false,
            Some (idx) => idx > i + 1,
        }
    )
}

fn main() {
    let p1_count = INPUT.lines().filter(|line| is_nice(line)).count();
    let p2_count = INPUT.lines().filter(|line| is_nice2(line)).count();

    println!("P1: {p1_count}");
    println!("P2: {p2_count}");
}
