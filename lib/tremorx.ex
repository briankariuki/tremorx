defmodule Tremorx do
  @moduledoc """
  Documentation for `Tremorx`.
  """

  defmacro __using__(_) do
    quote do
      import Tremorx.Theme

      import Tremorx.Components.{
        Callout,
        Text,
        Legend,
        Layout,
        Button
      }
    end
  end
end
