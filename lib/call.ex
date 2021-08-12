defmodule Call do
  defstruct data: nil, duration: nil

  def register(subscriber, data, duration) do
    to_update_subscriber = %Subscriber{
      subscriber
      | calls: subscriber.calls ++ [%__MODULE__{data: data, duration: duration}]
    }

    Subscriber.update(subscriber.phone_number, to_update_subscriber)
  end
end
