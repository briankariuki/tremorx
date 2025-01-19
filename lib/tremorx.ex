defmodule Tremorx do
  @moduledoc """
  Documentation for `Tremorx`.
  """

  defmacro __using__(_) do
    quote do
      alias Tremorx.Components.{
        Callout,
        Text,
        Legend,
        Layout,
        Button,
        Input,
        Image,
        Menu,
        Bar,
        Table,
        Tab,
        Badge,
        Select,
        List,
        Tooltip,
        AreaChart,
        LineChart,
        BarChart,
        DonutChart,
        DatePicker
      }
    end
  end
end
