defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  test "plus" do
    assert Calc.eval("1 + 2 + 3 + 4 + 5") == 15
  end

  test "sub plus" do
    assert Calc.eval("15 - 10 - 7 - 0 + 1") == -1
  end

  test "mul and plus" do
    assert Calc.eval("1 + 2 * 3") == 7
  end

  test "mul and div" do
    assert Calc.eval("2 * 6 / 3") == 4
  end

  test "plus sub mul div" do
    assert Calc.eval(" 1 + 2 * 3 - 10 / 5") == 5
  end

  test "paren" do
    assert Calc.eval("2 * (1 + 3)") == 8
  end

  test "2 nested paren" do
    assert Calc.eval("24 + 5 * (6 / (1 + 2)) - 10") == 24
  end

  test "3 paren" do
    assert Calc.eval("2 * ((3 - 1) * (2 + 3)) - 6 / 2") == 17
  end
end
