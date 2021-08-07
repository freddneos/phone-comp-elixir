defmodule PhoneComp do
  def start() do
    File.write("prepaid_subscribers.txt", :erlang.term_to_binary([]))
    File.write("postpaid_subscribers.txt", :erlang.term_to_binary([]))
  end

  def register_subscriber(name, phone_number, document, plan_type) do
    Subscriber.register(name, phone_number, document, plan_type)
  end
end
