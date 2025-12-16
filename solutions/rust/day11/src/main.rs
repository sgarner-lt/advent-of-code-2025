use std::collections::HashMap;
use std::env;
use std::fs;

fn main() {
    let args: Vec<String> = env::args().collect();
    let input_type = match args.get(1).map(|s| s.as_str()) {
        Some("r") => "",
        Some("s") => "-sample",
        _ => "",
    };
    let input_path = &format!("../../../challenges/day11/input{}.txt", input_type);
    let input = read_input(input_path);
    let graph = parse_input(&input);
    println!("Loaded {} nodes", graph.labels.len());
    // Part 1: count all paths from `you` to `out`.
    // println!("Part 1: {}", part1(&graph));
    // Part 2: count paths from `svr` to `out` that visit both `dac` and `fft`.
    println!("Part 2: {}", part2(&graph));
}

fn read_input(path: &str) -> String {
    fs::read_to_string(path).expect("Failed to read input file")
}

#[derive(Debug)]
struct Graph {
    labels: Vec<String>,
    adj: Vec<Vec<usize>>,
    index_of: HashMap<String, usize>,
}

fn parse_input(input: &str) -> Graph {
    // First pass: collect labels and outputs as strings
    let mut raw: Vec<(String, Vec<String>)> = Vec::new();
    for line in input.lines() {
        let trimmed = line.trim();
        if trimmed.is_empty() {
            continue;
        }
        let parts: Vec<&str> = trimmed.split_ascii_whitespace().collect();
        let label = parts[0].to_string().replace(":", "");
        let outputs = parts.iter().skip(1).map(|s| s.to_string()).collect();
        raw.push((label, outputs));
    }

    // Build a unique list of labels that includes outputs-only nodes (e.g. `out`).
    let mut index_of: HashMap<String, usize> = HashMap::new();
    let mut labels: Vec<String> = Vec::new();
    let mut add_label =
        |name: String, index_of: &mut HashMap<String, usize>, labels: &mut Vec<String>| {
            if !index_of.contains_key(&name) {
                let idx = labels.len();
                index_of.insert(name.clone(), idx);
                labels.push(name);
            }
        };

    for (label, outputs) in &raw {
        add_label(label.clone(), &mut index_of, &mut labels);
        for out in outputs {
            add_label(out.clone(), &mut index_of, &mut labels);
        }
    }

    // Build adjacency list using indices (avoid storing repeated strings)
    let mut adj = vec![Vec::new(); labels.len()];
    for (i, (label, outputs)) in raw.into_iter().enumerate() {
        // `i` is not necessarily the index in labels anymore; look up from map
        let src = *index_of.get(&label).expect("source label should exist");
        for out in outputs {
            if let Some(&j) = index_of.get(&out) {
                adj[src].push(j);
            }
        }
    }

    Graph {
        labels,
        adj,
        index_of,
    }
}

// Generalized DFS with memoization over (node, flags).
// flags: bit0 = saw `dac`, bit1 = saw `fft`. There are 4 possible flag states.
fn dfs_count_simple(
    graph: &Graph,
    node: usize,
    visited: &mut [bool],
    flags: u8,
    target: usize,
    require_mask: Option<u8>,
) -> usize {
    if node == target {
        return match require_mask {
            Some(mask) => {
                if (flags & mask) == mask {
                    1
                } else {
                    0
                }
            }
            None => 1,
        };
    }

    let mut sum = 0usize;
    for &nei in &graph.adj[node] {
        if visited[nei] {
            continue;
        }
        let mut new_flags = flags;
        let lbl = &graph.labels[nei];
        if lbl == "dac" {
            new_flags |= 1;
        }
        if lbl == "fft" {
            new_flags |= 2;
        }
        visited[nei] = true;
        sum = sum.saturating_add(dfs_count_simple(
            graph,
            nei,
            visited,
            new_flags,
            target,
            require_mask,
        ));
        visited[nei] = false;
    }
    sum
}

fn part1(graph: &Graph) -> usize {
    let start = *graph.index_of.get("you").expect("missing `you` node");
    let target = *graph.index_of.get("out").expect("missing `out` node");
    let mut visited = vec![false; graph.labels.len()];
    visited[start] = true;
    let mut flags = 0u8;
    if graph.labels[start] == "dac" {
        flags |= 1;
    }
    if graph.labels[start] == "fft" {
        flags |= 2;
    }
    // Use memoized DP for DAGs: counts only depend on (node, flags)
    let mut memo: Vec<[Option<usize>; 4]> = vec![[None; 4]; graph.labels.len()];
    dfs_count_memo(graph, start, flags, target, None, &mut memo)
}

fn part2(graph: &Graph) -> usize {
    let start = *graph.index_of.get("svr").expect("missing `svr` node");
    let target = *graph.index_of.get("out").expect("missing `out` node");
    let mut visited = vec![false; graph.labels.len()];
    visited[start] = true;
    let mut flags = 0u8;
    if graph.labels[start] == "dac" {
        flags |= 1;
    }
    if graph.labels[start] == "fft" {
        flags |= 2;
    }
    let mask = 1 | 2; // need both dac and fft
    let mut memo: Vec<[Option<usize>; 4]> = vec![[None; 4]; graph.labels.len()];
    dfs_count_memo(graph, start, flags, target, Some(mask), &mut memo)
}

fn dfs_count_memo(
    graph: &Graph,
    node: usize,
    flags: u8,
    target: usize,
    require_mask: Option<u8>,
    memo: &mut Vec<[Option<usize>; 4]>,
) -> usize {
    let idx = flags as usize;
    if let Some(v) = memo[node][idx] {
        return v;
    }
    if node == target {
        let res = match require_mask {
            Some(mask) => {
                if (flags & mask) == mask {
                    1usize
                } else {
                    0usize
                }
            }
            None => 1usize,
        };
        memo[node][idx] = Some(res);
        return res;
    }

    let mut sum = 0usize;
    for &nei in &graph.adj[node] {
        let mut new_flags = flags;
        let lbl = &graph.labels[nei];
        if lbl == "dac" {
            new_flags |= 1;
        }
        if lbl == "fft" {
            new_flags |= 2;
        }
        sum = sum.saturating_add(dfs_count_memo(
            graph,
            nei,
            new_flags,
            target,
            require_mask,
            memo,
        ));
    }

    memo[node][idx] = Some(sum);
    sum
}

// Return counts for each final flag state (0..3) using u128 to reduce overflow risk.
fn dfs_count_vec_memo(
    graph: &Graph,
    node: usize,
    flags: u8,
    target: usize,
    memo: &mut Vec<[Option<[u128; 4]>; 4]>,
) -> [u128; 4] {
    let idx = flags as usize;
    if let Some(v) = &memo[node][idx] {
        return *v;
    }
    if node == target {
        let mut out = [0u128; 4];
        out[flags as usize] = 1u128;
        memo[node][idx] = Some(out);
        return out;
    }

    let mut acc = [0u128; 4];
    for &nei in &graph.adj[node] {
        let mut new_flags = flags;
        let lbl = &graph.labels[nei];
        if lbl == "dac" {
            new_flags |= 1;
        }
        if lbl == "fft" {
            new_flags |= 2;
        }
        let res = dfs_count_vec_memo(graph, nei, new_flags, target, memo);
        for i in 0..4 {
            acc[i] = acc[i].saturating_add(res[i]);
        }
    }

    memo[node][idx] = Some(acc);
    acc
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn sample_part2_matches_expected() {
        let sample = "svr: aaa bbb\naaa: fft\nfft: ccc\nbbb: tty\ntty: ccc\nccc: ddd eee\nddd: hub\nhub: fff\neee: dac\ndac: fff\nfff: ggg hhh\nggg: out\nhhh: out\n";
        let g = parse_input(sample);
        let res = part2(&g);
        assert_eq!(
            res, 2,
            "expected 2 paths that visit both dac and fft in sample"
        );
    }

    #[test]
    fn simple_cycle_counts_only_simple_paths() {
        // a->b, b->a and b->out ; only 1 simple path a->b->out
        let s = "a: b\nb: a out\nout:\n";
        let g = parse_input(s);
        let start = *g.index_of.get("a").unwrap();
        let target = *g.index_of.get("out").unwrap();
        let mut visited = vec![false; g.labels.len()];
        visited[start] = true;
        let cnt = dfs_count_simple(&g, start, &mut visited, 0, target, None);
        assert_eq!(cnt, 1);
    }

    #[test]
    fn flags_propagate_and_count() {
        // Chain that visits dac then fft to out
        let s = "svr: a\na: dac\ndac: b\nb: fft\nfft: out\nout:\n";
        let g = parse_input(s);
        let res = part2(&g);
        assert_eq!(res, 1);
    }

    #[test]
    fn analyze_real_input_sccs() {
        use std::path::PathBuf;
        let base = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
        let input_path = base.join("../../../challenges/day11/input.txt");
        let input = std::fs::read_to_string(&input_path).expect("failed to read real input");
        let g = parse_input(&input);
        let n = g.labels.len();
        let m: usize = g.adj.iter().map(|v| v.len()).sum();

        // Tarjan
        let mut index = 0usize;
        let mut indices: Vec<Option<usize>> = vec![None; n];
        let mut low: Vec<usize> = vec![0; n];
        let mut onstack: Vec<bool> = vec![false; n];
        let mut stack: Vec<usize> = Vec::new();
        let mut sccs: Vec<Vec<usize>> = Vec::new();

        fn strong(
            v: usize,
            g: &Graph,
            index: &mut usize,
            indices: &mut Vec<Option<usize>>,
            low: &mut Vec<usize>,
            stack: &mut Vec<usize>,
            onstack: &mut Vec<bool>,
            sccs: &mut Vec<Vec<usize>>,
        ) {
            indices[v] = Some(*index);
            low[v] = *index;
            *index += 1;
            stack.push(v);
            onstack[v] = true;

            for &w in &g.adj[v] {
                if indices[w].is_none() {
                    strong(w, g, index, indices, low, stack, onstack, sccs);
                    low[v] = std::cmp::min(low[v], low[w]);
                } else if onstack[w] {
                    low[v] = std::cmp::min(low[v], indices[w].unwrap());
                }
            }

            if indices[v].unwrap() == low[v] {
                let mut comp = Vec::new();
                loop {
                    let w = stack.pop().unwrap();
                    onstack[w] = false;
                    comp.push(w);
                    if w == v {
                        break;
                    }
                }
                sccs.push(comp);
            }
        }

        for v in 0..n {
            if indices[v].is_none() {
                strong(
                    v,
                    &g,
                    &mut index,
                    &mut indices,
                    &mut low,
                    &mut stack,
                    &mut onstack,
                    &mut sccs,
                );
            }
        }

        let mut sizes: Vec<usize> = sccs.iter().map(|c| c.len()).collect();
        sizes.sort_unstable_by(|a, b| b.cmp(a));

        println!(
            "real nodes={}, edges={}, scc_count={}, top_scc_sizes={:?}, scc_gt1={}",
            n,
            m,
            sccs.len(),
            &sizes[..sizes.len().min(10)],
            sizes.iter().filter(|&&s| s > 1).count()
        );

        // report sizes for special labels
        for name in ["out", "dac", "fft", "svr", "you"] {
            match g.index_of.get(name) {
                Some(&idx) => {
                    let scc_idx = sccs.iter().position(|c| c.contains(&idx)).unwrap();
                    println!("{} in scc size {}", name, sccs[scc_idx].len());
                }
                None => println!("{} missing", name),
            }
        }
    }

    #[test]
    fn run_memo_on_real_input() {
        use std::path::PathBuf;
        use std::time::Instant;
        let base = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
        let input_path = base.join("../../../challenges/day11/input.txt");
        let input = std::fs::read_to_string(&input_path).expect("failed to read real input");
        let g = parse_input(&input);
        let start = *g.index_of.get("svr").expect("missing svr");
        let target = *g.index_of.get("out").expect("missing out");
        let mask = 1 | 2;
        let mut memo: Vec<[Option<usize>; 4]> = vec![[None; 4]; g.labels.len()];
        let t0 = Instant::now();
        let res = dfs_count_memo(&g, start, 0, target, Some(mask), &mut memo);
        let dt = t0.elapsed();
        println!("memo result={} elapsed={:?}", res, dt);
    }

    #[test]
    fn breakdown_real_input_counts() {
        use std::path::PathBuf;
        use std::time::Instant;
        let base = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
        let input_path = base.join("../../../challenges/day11/input.txt");
        let input = std::fs::read_to_string(&input_path).expect("failed to read real input");
        let g = parse_input(&input);
        let start = *g.index_of.get("svr").expect("missing svr");
        let target = *g.index_of.get("out").expect("missing out");
        let mut memo: Vec<[Option<[u128; 4]>; 4]> = vec![[None; 4]; g.labels.len()];
        let t0 = Instant::now();
        let res = dfs_count_vec_memo(&g, start, 0, target, &mut memo);
        let dt = t0.elapsed();
        println!(
            "breakdown none={}, dac_only={}, fft_only={}, both={}, elapsed={:?}",
            res[0], res[1], res[2], res[3], dt
        );
    }
}
