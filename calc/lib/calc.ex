defmodule Calc do 
  def main() do
    case IO.gets("> ") do
    :eof ->
      IO.puts "All done"
    {:error, reason} ->
      IO.puts "Error: #{reason}"
    line ->
      IO.puts(eval(line))
      main()
    end
  end

  def eval(exp) do
    eval_sub(exp |> String.trim |> String.split)
  end

  defp reverse([]) do
    []
  end

  defp reverse([h|t]) do
    reverse(t) ++ [h]
  end

  defp check_integer(exp) do
    cond do
      length(exp) != 1 -> false
      true ->
        try do
          [head | _tail ] = exp
          _ = String.to_integer(head)
          true
        catch error: _arg ->
          false
        end
    end
  end
 
  defp count_paren(exp, lparen, rparen) do
    len = length(exp)
    rev = reverse(exp)
    [shead | _stail] = Enum.take(Enum.slice(exp, lparen, 1), 1)
    start = String.slice(shead,1..-1)                  
    [ehead | _etail] = Enum.take(Enum.slice(rev, len - rparen - 1, 1),1)
    en = String.slice(ehead,0..-2)
    mid = [start] ++ Enum.slice(exp, lparen + 1, rparen - lparen - 1) ++ [en]
    num_left = length(Enum.filter(mid, fn(x) -> x =~ "(" end))
    num_right = length(Enum.filter(mid, fn(x) -> x =~ ")" end))
    num_left == num_right
  end
 
  defp get_right(exp, rec, lparen, rparen) do 
    temp = rparen
    cond do
      !count_paren(exp, lparen, rparen) ->
        rec = Enum.slice(exp, rparen + 1, length(exp))
        rparen = temp + Enum.find_index(rec, fn(x) -> x =~ ")" end) + 1
        get_right(exp, rec, lparen, rparen)
      true -> rparen
    end
    
  end

  defp eval_sub(exp) do
    if exp == [] do
      exit("Please input valid argument")
    end
    [head | _tail] = exp
    len = length(exp)
    rev = reverse(exp)
    cond do
      length(exp) == 1 && check_integer(exp) ->
        round(String.to_integer(head))
      true -> 
        lparen = Enum.find_index(exp, fn(x) -> x =~ "(" end)
        rparen = Enum.find_index(exp, fn(x) -> x =~ ")" end)
        if lparen != nil do
          rparen = get_right(exp, exp, lparen, rparen)
        end
        cond do
          lparen != nil ->
            cond do
              rparen != nil ->
                left = Enum.take(exp, lparen)
                [shead | _stail] = Enum.take(Enum.slice(exp, lparen, 1), 1)
                start = String.slice(shead,1..-1)                  
                [ehead | _etail] = Enum.take(Enum.slice(rev, len - rparen - 1, 1),1)
                en = String.slice(ehead,0..-2)
                mid = [start] ++ Enum.slice(exp, lparen + 1, rparen - lparen - 1) ++ [en]
                right = Enum.slice(exp, rparen + 1, len)
                res = List.insert_at(left, length(left), Kernel.inspect(eval_sub(mid))) ++ right
                eval_sub(res)
              true ->
                exit("Wrong argument")
            end
          true ->          
            addsub = Enum.find(reverse(exp), fn(x) -> x == "+" || x == "-" end)
            muldiv = Enum.find(reverse(exp), fn(x) -> x == "*" || x == "/" end)
            op = cond do
              addsub != nil ->
                addsub
              muldiv != nil ->
                Enum.find(reverse(exp), fn(x) -> x == "*" || x == "/" end)
            end

            op_ind = Enum.find_index(reverse(exp), fn(x) -> x == op end)            
            left =  Enum.take(exp, length(exp) - op_ind - 1)
            right = Enum.take(exp, -op_ind)
            result = case op do
                "+" -> eval_sub(left) + eval_sub(right)
                "-" -> eval_sub(left) - eval_sub(right)
                "*" -> eval_sub(left) * eval_sub(right)
                "/" -> 
                  if eval_sub(right) == 0 do
                    exit("divide by 0 error")
                  end
                  eval_sub(left) / eval_sub(right)
                _ -> exit("Wrong argument")
            end
          round(result)
        end
    end
  end 
end
