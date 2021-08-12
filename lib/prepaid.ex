defmodule Prepaid do
  @price_minute 1.45
  defstruct credits: 10, recharges: []

  def make_call(phone_number, date, duration) do
    subscriber = Subscriber.find_subscriber(phone_number, :prepaid)
    cost = @price_minute * duration

    cond do
      cost <= subscriber.plan_type.credits ->
        plan_type = subscriber.plan_type
        plan_type = %__MODULE__{plan_type | credits: plan_type.credits - cost}
        subscriber = %Subscriber{subscriber | plan_type: plan_type}
        IO.inspect(subscriber)
        {:ok, "The cost of the call was #{cost} , and you have #{plan_type.credits}"}

      true ->
        {:error, "You don't have enougth credits to do this call , please make a credit recharge"}
    end
  end
end
