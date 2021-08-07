defmodule SubscriberTest do
  use ExUnit.Case
  doctest Subscriber

  setup do
    File.write("prepaid_subscribers.txt", :erlang.term_to_binary([]))
    File.write("postpaid_subscribers.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("prepaid_subscribers.txt")
      File.rm("postpaid_subscribers.txt")
    end)
  end

  describe "Subscriber Register test" do
    test "Subscriber Structure" do
      assert %Subscriber{
               name: "Fredd",
               phone_number: "+341111",
               document: "GR123",
               plan_type: :postpaid
             }.name == "Fredd"
    end

    test "Create a prepaid subscription" do
      assert Subscriber.register("Fredd", "+123123", "XY0111") ==
               {:ok, "Subscriber registered succesfully."}
    end

    test "Create a postpaid subscription" do
      assert Subscriber.register("Fredd", "+123123", "XY0111", :postpaid) ==
               {:ok, "Subscriber registered succesfully."}
    end

    test "Try to Create a subscription with a phone_number already added" do
      Subscriber.register("Fredd", "+123123", "ZZZ", :postpaid)

      assert Subscriber.register("Fredd", "+123123", "XY0111", :postpaid) ==
               {:error, "Subscriber already registered."}
    end
  end

  describe "find subscriber tests" do
    test "find by plan Prepaid" do
      Subscriber.register("Luiz", "+3421212", "XZ001", :prepaid)
      assert Subscriber.find_subscriber("+3421212", :prepaid).name == "Luiz"
    end

    test "find by plan Postpaid" do
      Subscriber.register("Andrew", "+3421212", "XZ001", :postpaid)
      assert Subscriber.find_subscriber("+3421212", :postpaid).name == "Andrew"
    end

    test "find by plan All" do
      Subscriber.register("Jony", "+3421212", "XZ001", :postpaid)
      assert Subscriber.find_subscriber("+3421212").name == "Jony"
    end
  end
end
