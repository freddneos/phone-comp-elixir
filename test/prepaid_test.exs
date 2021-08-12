defmodule PrepaidTest do
  use ExUnit.Case
  doctest Prepaid

  setup do
    File.write("prepaid_subscribers.txt", :erlang.term_to_binary([]))
    File.write("postpaid_subscribers.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("prepaid_subscribers.txt")
      File.rm("postpaid_subscribers.txt")
    end)
  end

  describe "Prepaid Plan type tests" do
    test "start" do
      assert 10 + 10 == 20
    end
  end

  describe "Call tests" do
    test "Can make a call" do
      Subscriber.register("Fredd", "+3419191", "GR001", :prepaid)

      assert Prepaid.make_call("+3419191", DateTime.utc_now(), 3) ==
               {:ok, "The cost of the call was 4.35 , and you have 5.65"}
    end

    test "Can't make a long duration call without enougth credits call" do
      Subscriber.register("Fredd", "+3419191", "GR001", :prepaid)

      assert Prepaid.make_call("+3419191", DateTime.utc_now(), 10) ==
               {:error,
                "You don't have enougth credits to do this call , please make a credit recharge"}
    end
  end
end
