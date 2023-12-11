defmodule Tremorx.Color do
  @moduledoc """
  Defines a color object.

  ## Colors
  "slate", "gray", "zinc", "neutral", "stone", "red", "orange", "amber", "yellow", "lime", "green", "emerald", "teal", "cyan", "sky", "blue", "indigo", "violet", "purple", "fuchsia", "pink", "rose",
  """

  @enforce_keys [:color]
  @fields quote(
            do: [
              color: String.t()
            ]
          )

  defstruct Keyword.keys(@fields)

  @type t() :: %__MODULE__{unquote_splicing(@fields)}
end
