defmodule PostpaidTest do
  use ExUnit.Case
  doctest Postpaid

  setup do
    File.write("prepaid_subscribers.txt", :erlang.term_to_binary([]))
    File.write("postpaid_subscribers.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("prepaid_subscribers.txt")
      File.rm("postpaid_subscribers.txt")
    end)
  end

  describe "Postpaid Plan type tests" do
    test "start" do
      assert 10 + 10 == 20
    end
  end
end
