defmodule Subscriber do
  @moduledoc """
  Subscriber Module to handle subscription of two types of plans `prepaid` and `postpaid`

  The main function of this module is `register/4`
  """
  defstruct name: nil, phone_number: nil, document: nil, plan_type: nil

  @subscriber_file %{
    :prepaid => "prepaid_subscribers.txt",
    :postpaid => "postpaid_subscribers.txt"
  }
  @doc """
  Function responsible find a subscriber by phone_number and key =  `:prepaid` , `:postpaid` or  `:all`

  ## Function parameters
  - phone_number: Phone number that needs to be checked
  - key: Subscriber plan if omitted the the search will be done to  as `:all`

  ## Example
      iex> Subscriber.register("Fredd" , "+12334" , "GR011" , :postpaid)
      iex> Subscriber.find_subscriber("+12334", :postpaid)
      %Subscriber{document: "GR011", name: "Fredd", phone_number: "+12334", plan_type: :postpaid}
  """

  def find_subscriber(phone_number, key \\ :all), do: find_subscriber_by_plan(phone_number, key)

  def find_subscriber_by_plan(phone_number, :prepaid),
    do: filter(prepaid_subscribers(), phone_number)

  def find_subscriber_by_plan(phone_number, :postpaid),
    do: filter(postpaid_subscribers(), phone_number)

  def find_subscriber_by_plan(phone_number, :all),
    do: filter(all_subscribers(), phone_number)

  def prepaid_subscribers, do: read(:prepaid)
  def postpaid_subscribers, do: read(:postpaid)
  def all_subscribers, do: read(:postpaid) ++ read(:prepaid)
  defp filter(list, phone_number), do: Enum.find(list, &(&1.phone_number == phone_number))

  @doc """
  Function responsible to register a subscriber `prepaid` or `postpaid`

  ## Function parameters
  - name: Subscriber name
  - phone_number: Subscriber phone number , if exist error will be returned
  - document: Subscriber document used to create a subscription
  - plan_type: Subscriber plan if omitted the subscription will be registered as `prepaid`

  ## Example
      iex> Subscriber.register("Jony" , "+12334", "GR123" , :postpaid)
      {:ok, "Subscriber registered succesfully."}
  """
  def register(name, phone_number, document, plan_type \\ :prepaid) do
    case find_subscriber(phone_number) do
      nil ->
        (read(plan_type) ++
           [
             %__MODULE__{
               name: name,
               phone_number: phone_number,
               document: document,
               plan_type: plan_type
             }
           ])
        |> :erlang.term_to_binary()
        |> write(plan_type)

        {:ok, "Subscriber registered succesfully."}

      _assinante ->
        {:error, "Subscriber already registered."}
    end
  end

  def write(subscriber_list, plan_type) do
    File.write!(@subscriber_file[plan_type], subscriber_list)
  end

  def read(plan_type) do
    case File.read(@subscriber_file[plan_type]) do
      {:ok, subscribers} ->
        subscribers |> :erlang.binary_to_term()

      {:error, :ennoent} ->
        {:error, "Impossible to read this file"}
    end
  end
end
