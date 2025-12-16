use good_lp::solvers::coin_cbc;
use good_lp::{IntoAffineExpression, Solution, SolverModel, constraint, variable, variables};
use std::cmp::min;
use std::fmt;
use std::fs;
use std::io::Write;
use std::time::{Duration, Instant};

#[derive(Clone, Debug, PartialEq, Eq, Hash)]
struct ButtonWiringSchematic {
    pub data: Vec<usize>,
}
impl ButtonWiringSchematic {
    fn new(data: Vec<usize>) -> Self {
        Self { data }
    }
}
impl fmt::Display for ButtonWiringSchematic {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "({})",
            self.data
                .iter()
                .map(|x| x.to_string())
                .collect::<Vec<_>>()
                .join(",")
        )
    }
}

#[derive(Clone, Debug)]
struct JoltageRequirement {
    pub data: Vec<u16>,
}
impl JoltageRequirement {
    fn new(data: Vec<u16>) -> Self {
        Self { data }
    }
}
impl fmt::Display for JoltageRequirement {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "{{{}}}",
            self.data
                .iter()
                .map(|x| x.to_string())
                .collect::<Vec<_>>()
                .join(",")
        )
    }
}

#[derive(Clone, Debug)]
struct IndicatorLightDiagram {
    pub data: Vec<bool>,
}
impl IndicatorLightDiagram {
    // fn new(size: usize) -> Self {
    //     Self {
    //         data: vec![false; size],
    //     }
    // }
}
impl fmt::Display for IndicatorLightDiagram {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "[{}]",
            self.data
                .iter()
                .map(|b| if *b { "#" } else { "." })
                .collect::<Vec<_>>()
                .join("")
        )
    }
}

#[derive(Clone, Debug)]
struct Machine {
    indicator_light_diag: IndicatorLightDiagram,
    pub button_wiring_schemas: Vec<ButtonWiringSchematic>,
    pub joltage_reqs: JoltageRequirement,
    pub jotage_max_limit: u16,
}
impl Machine {
    fn new(
        ind: IndicatorLightDiagram,
        schemas: Vec<ButtonWiringSchematic>,
        jol: JoltageRequirement,
    ) -> Self {
        let max_limit = jol.data.iter().copied().max().unwrap_or(0);
        Self {
            indicator_light_diag: ind,
            button_wiring_schemas: schemas,
            joltage_reqs: jol,
            jotage_max_limit: max_limit,
        }
    }
}
impl fmt::Display for Machine {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "{} {} {}",
            self.indicator_light_diag,
            self.button_wiring_schemas
                .iter()
                .map(|s| s.to_string())
                .collect::<Vec<_>>()
                .join(" "),
            self.joltage_reqs
        )
    }
}

struct Problem {
    pub machines: Vec<Machine>,
}
impl Problem {
    fn new(m: Vec<Machine>) -> Self {
        Self { machines: m }
    }
}

fn parse_problem(input: &str) -> Problem {
    let mut max_voltage = 0u16;
    let machines = input
        .lines()
        .map(|l| l.trim())
        .filter(|l| !l.is_empty())
        .map(|line| {
            let elems: Vec<&str> = line.split_whitespace().collect();
            let ind_chars = elems[0].replace("[", "").replace("]", "");
            let ind: Vec<bool> = ind_chars
                .chars()
                .map(|c| match c {
                    '#' => true,
                    '.' => false,
                    _ => panic!("bad"),
                })
                .collect();
            let indicator = IndicatorLightDiagram { data: ind };
            let schemas: Vec<ButtonWiringSchematic> = elems
                .iter()
                .skip(1)
                .filter(|s| s.starts_with("("))
                .map(|s| {
                    let data = s
                        .replace("(", "")
                        .replace(")", "")
                        .split(',')
                        .map(|x| x.parse::<usize>().expect("idx"))
                        .collect();
                    ButtonWiringSchematic::new(data)
                })
                .collect();
            let jol_raw = elems.last().unwrap().replace("{", "").replace("}", "");
            let jol: Vec<u16> = jol_raw
                .split(',')
                .map(|c| {
                    let v: u16 = c.parse().expect("num");
                    max_voltage = max_voltage.max(v);
                    v
                })
                .collect();
            Machine::new(indicator, schemas, JoltageRequirement::new(jol))
        })
        .collect();
    Problem::new(machines)
}

// greedy solver to get an initial upper bound (simple)
fn greedy_upper_bound(machine: &Machine, max_steps: usize) -> Option<usize> {
    let rows = machine.joltage_reqs.data.len();
    let goal: Vec<usize> = machine
        .joltage_reqs
        .data
        .iter()
        .map(|&v| v as usize)
        .collect();
    let mut cur = vec![0usize; rows];
    if cur == goal {
        return Some(0);
    }
    for step in 0..max_steps {
        let mut best_score: isize = -1;
        let mut best_idx: Option<usize> = None;
        for (si, schema) in machine.button_wiring_schemas.iter().enumerate() {
            let mut feasible = true;
            let mut score: isize = 0;
            for &r in &schema.data {
                if cur[r] >= goal[r] {
                    feasible = false;
                    break;
                }
                score += (goal[r] - cur[r]) as isize;
            }
            if !feasible {
                continue;
            }
            if score > best_score {
                best_score = score;
                best_idx = Some(si);
            }
        }
        let si = match best_idx {
            Some(i) => i,
            None => return None,
        };
        for &r in &machine.button_wiring_schemas[si].data {
            cur[r] += 1;
        }
        if cur == goal {
            return Some(step + 1);
        }
    }
    None
}

// exact integer multiset solver (branch & bound). returns minimal total presses if found within node_limit/time_limit.
fn solve_counts_exact(
    machine: &Machine,
    node_limit: usize,
    time_limit: Option<Duration>,
) -> Option<usize> {
    let start = Instant::now();
    let _rows = machine.joltage_reqs.data.len();
    let cols = machine.button_wiring_schemas.len();
    let goal: Vec<usize> = machine
        .joltage_reqs
        .data
        .iter()
        .map(|&v| v as usize)
        .collect();

    // quick infeasible check
    for (r, &need) in goal.iter().enumerate() {
        if need > 0 {
            let mut covered = false;
            for s in &machine.button_wiring_schemas {
                if s.data.iter().any(|&i| i == r) {
                    covered = true;
                    break;
                }
            }
            if !covered {
                return None;
            }
        }
    }

    // Build column coverings and per-column upper bounds
    let mut col_rows: Vec<Vec<usize>> = vec![Vec::new(); cols];
    for (c, s) in machine.button_wiring_schemas.iter().enumerate() {
        for &r in &s.data {
            col_rows[c].push(r);
        }
    }
    let mut ub: Vec<usize> = vec![0; cols];
    for c in 0..cols {
        if col_rows[c].is_empty() {
            ub[c] = 0;
            continue;
        }
        let mut m = usize::MAX;
        for &r in &col_rows[c] {
            m = min(m, goal[r]);
        }
        ub[c] = if m == usize::MAX { 0 } else { m };
    }

    // column order: prefer schema with larger coverage (heuristic)
    let mut order: Vec<usize> = (0..cols).collect();
    order.sort_by_key(|&c| usize::MAX - col_rows[c].len());

    // initial best from greedy
    let mut best_total = None;
    if let Some(gub) = greedy_upper_bound(&machine, 2000) {
        best_total = Some(gub);
    }

    let mut nodes: usize = 0;
    let mut rem = goal.clone();

    // helper lower bound: ceil(sum(rem)/max_cover_remaining)
    fn lower_bound(
        rem: &Vec<usize>,
        cols_remaining: &[usize],
        col_rows: &Vec<Vec<usize>>,
    ) -> usize {
        let sum_rem: usize = rem.iter().sum();
        if sum_rem == 0 {
            return 0;
        }
        let mut maxcov = 1usize;
        for &c in cols_remaining {
            maxcov = maxcov.max(col_rows[c].len());
        }
        if maxcov == 0 {
            sum_rem
        } else {
            (sum_rem + maxcov - 1) / maxcov
        }
    }

    // recursion
    fn dfs(
        idx: usize,
        order: &Vec<usize>,
        ub: &Vec<usize>,
        col_rows: &Vec<Vec<usize>>,
        rem: &mut Vec<usize>,
        nodes: &mut usize,
        node_limit: usize,
        best_total: &mut Option<usize>,
        cur_total: usize,
        start: Instant,
        time_limit: Option<Duration>,
    ) {
        *nodes += 1;
        if *nodes > node_limit {
            return;
        }
        if let Some(tl) = time_limit {
            if start.elapsed() > tl {
                return;
            }
        }
        // goal?
        if rem.iter().all(|&x| x == 0) {
            match best_total {
                Some(bt) => {
                    if cur_total < *bt {
                        *best_total = Some(cur_total);
                    }
                }
                None => *best_total = Some(cur_total),
            }
            return;
        }
        if idx >= order.len() {
            return;
        }
        // pruning with current best
        if let Some(bt) = *best_total {
            if cur_total >= bt {
                return;
            }
        }
        // lower bound estimate using remaining columns
        let cols_remaining = &order[idx..];
        let lb = lower_bound(rem, cols_remaining, col_rows);
        if let Some(bt) = *best_total {
            if cur_total + lb >= bt {
                return;
            }
        }
        // pick column
        let c = order[idx];
        // compute max feasible for this column given rem (min of rem[r] for r in column)
        let mut max_feasible = 0usize;
        if !col_rows[c].is_empty() {
            max_feasible = col_rows[c].iter().map(|&r| rem[r]).min().unwrap_or(0);
            max_feasible = min(max_feasible, ub[c]);
        }
        // Try larger k first (heuristic)
        for k in (0..=max_feasible).rev() {
            // quick cost pruning
            let new_total = cur_total + k;
            if let Some(bt) = *best_total {
                if new_total >= bt {
                    continue;
                }
            }
            // apply k
            let mut applied = false;
            if k > 0 {
                for &r in &col_rows[c] {
                    rem[r] = rem[r].saturating_sub(k);
                }
                applied = true;
            }
            dfs(
                idx + 1,
                order,
                ub,
                col_rows,
                rem,
                nodes,
                node_limit,
                best_total,
                new_total,
                start,
                time_limit,
            );
            // undo
            if applied {
                for &r in &col_rows[c] {
                    rem[r] += k;
                }
            }
            // if we've found a perfect (lowest possible) solution of 0 we can stop early, but lower bound already handled
        }
    }

    dfs(
        0,
        &order,
        &ub,
        &col_rows,
        &mut rem,
        &mut nodes,
        node_limit,
        &mut best_total,
        0,
        start,
        time_limit,
    );

    best_total
}

// ILP solver using good_lp + coin_cbc (good_lp 1.x style)
fn solve_with_good_lp(machine: &Machine, _time_limit_secs: Option<u64>) -> Option<usize> {
    // quick feasibility check
    let rows = machine.joltage_reqs.data.len();
    let cols = machine.button_wiring_schemas.len();
    let goal_i32: Vec<i32> = machine
        .joltage_reqs
        .data
        .iter()
        .map(|&v| v as i32)
        .collect();
    // also prepare goal as usize for upper-bound computation
    let goal_usize: Vec<usize> = machine
        .joltage_reqs
        .data
        .iter()
        .map(|&v| v as usize)
        .collect();

    for (r, &need) in goal_i32.iter().enumerate() {
        if need > 0 {
            let mut covered = false;
            for s in &machine.button_wiring_schemas {
                if s.data.iter().any(|&i| i == r) {
                    covered = true;
                    break;
                }
            }
            if !covered {
                return None;
            }
        }
    }

    // build per-column rows and conservative per-variable upper bounds (min over covered rows)
    let mut col_rows: Vec<Vec<usize>> = vec![Vec::new(); cols];
    for (c, s) in machine.button_wiring_schemas.iter().enumerate() {
        for &r in &s.data {
            col_rows[c].push(r);
        }
    }
    let mut ub: Vec<usize> = vec![0; cols];
    for c in 0..cols {
        if col_rows[c].is_empty() {
            ub[c] = 0;
            continue;
        }
        let mut m = usize::MAX;
        for &r in &col_rows[c] {
            m = min(m, goal_usize[r]);
        }
        ub[c] = if m == usize::MAX { 0 } else { m };
    }

    // variables with conservative upper bounds to aid the MILP solver
    let mut vars = variables!();
    let mut xs = Vec::with_capacity(cols);
    for j in 0..cols {
        let max_j = ub[j] as i32; // good_lp accepts i32 for bounds
        let v = vars.add(
            variable()
                .integer()
                .min(0)
                .max(max_j)
                .name(format!("x{}", j)),
        );
        xs.push(v);
    }

    // Degenerate: no variables. Return 0 if all goals are zero, otherwise infeasible.
    if xs.is_empty() {
        if goal_i32.iter().all(|&g| g == 0) {
            return Some(0);
        } else {
            return None;
        }
    }

    // objective: minimize sum(x_j)
    // start from an affine expression produced from the first variable
    let mut obj = xs[0].clone().into_expression();
    for v in xs.iter().skip(1) {
        obj = obj + v.clone();
    }

    // attach solver (use default CbcSolver)

    let mut problem = vars.minimise(obj).using(coin_cbc::coin_cbc);

    // equality constraints: for each row r, sum_{c where A[r][c]=1} x_c == goal[r]
    for r in 0..rows {
        let mut expr = None;
        for (c, schema) in machine.button_wiring_schemas.iter().enumerate() {
            if schema.data.iter().any(|&i| i == r) {
                expr = Some(match expr {
                    Some(e) => e + xs[c].clone(),
                    None => xs[c].clone().into_expression(),
                });
            }
        }
        if let Some(e) = expr {
            problem = problem.with(constraint!(e == goal_i32[r]));
        }
    }

    // Solve (the test wrapper already enforces a wall-clock timeout). Return sum(x).
    match problem.solve() {
        Ok(sol) => {
            let mut total: usize = 0;
            for j in 0..cols {
                let val = sol.value(xs[j]);
                let iv = val.round() as isize;
                if iv < 0 {
                    return None;
                }
                total += iv as usize;
            }
            Some(total)
        }
        Err(e) => {
            // Log solver error for diagnostics (helpful in unit tests)
            eprintln!("ILP solver error / status: {:?}", e);
            None
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::env;

    // fallback embedded small sample if file missing (a compact sample)
    const EMBED_SAMPLE: &str = "\
[.#...#] (2,4) (3,4) (0,2,3,5) (0,1,2,3) (1,3,4,5) {26,32,28,47,23,20}
[#.####.] (0,1,2,4,6) (1,2,4,6) (0,6) (2,3) (0,2,3,4,5,6) (0,2,3,4,5) (3,4,5,6) (2,4) (0,1,2,5,6) {58,41,286,233,79,43,63}
[.#..] (1) (1,2) (0,1,3) (2,3) (0,2,3) {32,29,35,51}
[#...#] (1) (0,2,3) (1,3) (0,2,4) (0,4) (4) {34,26,19,27,31}
";

    #[test]
    fn sample_minimum_presses() {
        let default_sample = "/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day10/input-sample.txt";
        let input =
            std::fs::read_to_string(default_sample).unwrap_or_else(|_| EMBED_SAMPLE.to_string());
        let prob = parse_problem(&input);
        let mut total: usize = 0;
        for (i, m) in prob.machines.iter().enumerate() {
            let res = solve_counts_exact(m, 2_000_000, Some(Duration::from_secs(5)));
            match res {
                Some(d) => {
                    total += d;
                    println!("sample machine {} -> {}", i, d);
                }
                None => {
                    panic!("sample solver failed or infeasible for machine {}", i);
                }
            }
        }
        // expected total for sample is 33
        assert_eq!(total, 33, "sample total mismatch");
    }

    #[test]
    fn real_input_run() {
        let default_input =
            "/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day10/input.txt";
        let input_path = env::var("DAY10_INPUT").unwrap_or_else(|_| default_input.to_string());
        let input = std::fs::read_to_string(&input_path).expect("failed to read input file");
        let prob = parse_problem(&input);

        let timeout_secs: u64 = env::var("PER_MACHINE_TIMEOUT_SECS")
            .ok()
            .and_then(|s| s.parse().ok())
            .unwrap_or(600);
        let node_limit: usize = env::var("PER_MACHINE_NODE_LIMIT")
            .ok()
            .and_then(|s| s.parse().ok())
            .unwrap_or(200_000_000usize);

        println!(
            "Running real-input solver with timeout={}s node_limit={}",
            timeout_secs, node_limit
        );

        let mut total: usize = 0;
        for (i, m) in prob.machines.iter().enumerate() {
            println!(
                "Running machine {} (rows={}, schemas={})",
                i,
                m.joltage_reqs.data.len(),
                m.button_wiring_schemas.len()
            );

            // Try ILP first (with conservative per-variable bounds), fallback to DFS exact search.
            let ilp_res = solve_with_good_lp(m, Some(timeout_secs));
            let res = if let Some(d) = ilp_res {
                println!("machine {}: ILP solution -> {}", i, d);
                Some(d)
            } else {
                // ILP returned None (infeasible / timeout / solver error) — fall back
                let fallback =
                    solve_counts_exact(m, node_limit, Some(Duration::from_secs(timeout_secs)));
                fallback
            };

            match res {
                Some(d) => {
                    println!("machine {} -> {}", i, d);
                    total += d;
                }
                None => println!("machine {}: no solution found (or infeasible/timeout)", i),
            }
        }
        println!("Total presses (real input): {}", total);
    }
}

fn main() {
    // New: allow focused runs via env var MACHINE_INDEX; otherwise print greedy estimate.
    let default_input =
        "/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/challenges/day10/input.txt";
    let input_path = std::env::var("DAY10_INPUT").unwrap_or_else(|_| default_input.to_string());
    let input = fs::read_to_string(&input_path).unwrap_or_else(|_| {
        eprintln!("No input file found at {} ; exiting.", input_path);
        std::process::exit(1);
    });
    let prob = parse_problem(&input);

    // optional focused machine; if not set, run greedy summary
    let maybe_idx: Option<usize> = std::env::var("MACHINE_INDEX")
        .ok()
        .and_then(|s| s.parse().ok());

    let timeout_secs: u64 = std::env::var("PER_MACHINE_TIMEOUT_SECS")
        .ok()
        .and_then(|s| s.parse().ok())
        .unwrap_or(600);
    let node_limit: usize = std::env::var("PER_MACHINE_NODE_LIMIT")
        .ok()
        .and_then(|s| s.parse().ok())
        .unwrap_or(200_000_000usize);
    let results_out = std::env::var("RESULTS_OUT").ok();

    if let Some(idx) = maybe_idx {
        if idx >= prob.machines.len() {
            eprintln!(
                "MACHINE_INDEX {} out of range (0..{}).",
                idx,
                prob.machines.len()
            );
            std::process::exit(2);
        }
        let machine = &prob.machines[idx];
        println!(
            "Running machine #{}: rows={} schemas={} goal_sum={} max_goal={}",
            idx,
            machine.joltage_reqs.data.len(),
            machine.button_wiring_schemas.len(),
            machine
                .joltage_reqs
                .data
                .iter()
                .map(|&v| v as usize)
                .sum::<usize>(),
            machine.jotage_max_limit
        );

        let start = Instant::now();
        // Try ILP solver (good_lp + coin_cbc) first, fall back to DFS if ILP fails.
        let res_ilp = solve_with_good_lp(machine, Some(timeout_secs));
        let res = if let Some(d) = res_ilp {
            Some(d)
        } else {
            solve_counts_exact(machine, node_limit, Some(Duration::from_secs(timeout_secs)))
        };
        let dur = start.elapsed();

        match res {
            Some(depth) => {
                println!(
                    "machine #{}: exact solution depth={} elapsed={:?}",
                    idx, depth, dur
                );
                if let Some(path) = results_out {
                    let line = format!(
                        "{{\"machine\":{},\"depth\":{},\"elapsed_ms\":{}}}\n",
                        idx,
                        depth,
                        dur.as_millis()
                    );
                    let _ = std::fs::OpenOptions::new()
                        .create(true)
                        .append(true)
                        .open(path)
                        .and_then(|mut f| f.write_all(line.as_bytes()).map(|_| ()));
                }
            }
            None => {
                // fall back to greedy candidate and report timeout/infeasible
                if let Some(g) = greedy_upper_bound(machine, 10000) {
                    println!(
                        "machine #{}: no exact result (timeout/infeasible). greedy candidate={}. elapsed={:?}",
                        idx, g, dur
                    );
                } else {
                    println!(
                        "machine #{}: no exact result (timeout/infeasible) and greedy failed. elapsed={:?}",
                        idx, dur
                    );
                }
                if let Some(path) = results_out {
                    let line = format!(
                        "{{\"machine\":{},\"depth\":null,\"elapsed_ms\":{},\"status\":\"none\"}}\n",
                        idx,
                        dur.as_millis()
                    );
                    let _ = std::fs::OpenOptions::new()
                        .create(true)
                        .append(true)
                        .open(path)
                        .and_then(|mut f| f.write_all(line.as_bytes()).map(|_| ()));
                }
            }
        }
    } else {
        // summary greedy run for all machines (quick)
        let mut greedy_total: usize = 0;
        for (i, m) in prob.machines.iter().enumerate() {
            let g = greedy_upper_bound(m, 10000).unwrap_or(0);
            println!("machine #{:03}: greedy candidate={}", i, g);
            greedy_total += g;
        }
        println!("Greedy candidate total presses: {}", greedy_total);
    }
}
