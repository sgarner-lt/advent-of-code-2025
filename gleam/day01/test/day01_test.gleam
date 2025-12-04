import day01
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

// Test left rotation with wraparound
pub fn rotate_left_wraparound_test() {
  // Position 5, rotate left 10 should wrap to 95
  day01.rotate(5, day01.Left, 10)
  |> should.equal(95)
}

// Test right rotation with wraparound
pub fn rotate_right_wraparound_test() {
  // Position 95, rotate right 10 should wrap to 5
  day01.rotate(95, day01.Right, 10)
  |> should.equal(5)
}

// Test instruction parsing for left direction
pub fn parse_left_instruction_test() {
  day01.parse_instruction("L68")
  |> should.equal(Ok(#(day01.Left, 68)))
}

// Test instruction parsing for right direction
pub fn parse_right_instruction_test() {
  day01.parse_instruction("R48")
  |> should.equal(Ok(#(day01.Right, 48)))
}

// Test rotation sequence that lands on zero
pub fn rotation_lands_on_zero_test() {
  // Start at 50, rotate left 50 should land on 0
  day01.rotate(50, day01.Left, 50)
  |> should.equal(0)
}

// Test zero counting logic
pub fn count_zeros_in_sequence_test() {
  // Simulate the sample sequence
  let instructions = [
    #(day01.Left, 68),
    #(day01.Left, 30),
    #(day01.Right, 48),
    #(day01.Left, 5),
    #(day01.Right, 60),
    #(day01.Left, 55),
    #(day01.Left, 1),
    #(day01.Left, 99),
    #(day01.Right, 14),
    #(day01.Left, 82),
  ]

  day01.count_zeros(50, instructions)
  |> should.equal(3)
}
