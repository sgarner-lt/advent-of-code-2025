import argv
import day01

pub fn main() {
  // Get command-line arguments
  let args = argv.load().arguments

  // If an input file path is provided, use it; otherwise use default
  case args {
    [input_path, ..] -> day01.run_with_input(input_path)
    [] -> day01.main()
  }
}
