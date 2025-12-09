import day06
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn test_parse_input_simple_test() {
  let input = "123 328\n45 64\n*  +"
  let rows = day06.parse_input(input)

  should.equal(rows, [
    ["123", "328"],
    ["45", "64"],
    ["*", "+"],
  ])
}

pub fn test_identify_problems_sample_test() {
  let rows = [
    ["123", "328"],
    ["45", "64"],
    ["*", "+"],
  ]

  let problems = day06.identify_problems(rows)

  should.equal(problems, [
    ["123", "45", "*"],
    ["328", "64", "+"],
  ])
}

pub fn test_extract_operation_multiply_test() {
  let problem = ["123", "45", "*"]
  let op = day06.extract_operation(problem)

  should.equal(op, Ok("*"))
}

pub fn test_extract_operation_add_test() {
  let problem = ["328", "64", "+"]
  let op = day06.extract_operation(problem)

  should.equal(op, Ok("+"))
}

pub fn test_calculate_problem_multiply_test() {
  let problem = ["123", "45", "6", "*"]
  let result = day06.calculate_problem(problem, "*")

  should.equal(result, Ok(33210))
}

pub fn test_calculate_problem_add_test() {
  let problem = ["328", "64", "98", "+"]
  let result = day06.calculate_problem(problem, "+")

  should.equal(result, Ok(490))
}

pub fn test_solve_sample_input_test() {
  let input = "123 328  51 64
 45 64  387 23
  6 98  215 314
*   +   *   +  "

  let result = day06.solve(input)

  should.equal(result, Ok(4277556))
}

pub fn test_solve_small_example_test() {
  let input = "10 20\n5 10\n* +"
  let result = day06.solve(input)

  should.equal(result, Ok(80))
}
