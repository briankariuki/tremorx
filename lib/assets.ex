defmodule Tremorx.Assets do
  use Phoenix.Component

  attr(:rest, :global)

  @doc """
  Renders a loading_spinner
  """
  def loading_spinner(assigns) do
    ~H"""
    <svg {@rest} xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
      <path fill="none" d="M0 0h24v24H0z" />
      <path d="M18.364 5.636L16.95 7.05A7 7 0 1 0 19 12h2a9 9 0 1 1-2.636-6.364z" />
    </svg>
    """
  end

  attr(:rest, :global)

  @doc """
  Renders a eye icon
  """
  def eye_icon(assigns) do
    ~H"""
    <svg
      {@rest}
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      stroke-width="1.5"
      stroke="currentColor"
    >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M2.036 12.322a1.012 1.012 0 010-.639C3.423 7.51 7.36 4.5 12 4.5c4.638 0 8.573 3.007 9.963 7.178.07.207.07.431 0 .639C20.577 16.49 16.64 19.5 12 19.5c-4.638 0-8.573-3.007-9.963-7.178z"
      />
      <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
    </svg>
    """
  end

  attr(:rest, :global)

  @doc """
  Renders a eye_off icon
  """
  def eye_off_icon(assigns) do
    ~H"""
    <svg
      {@rest}
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      stroke-width="1.5"
      stroke="currentColor"
    >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M3.98 8.223A10.477 10.477 0 001.934 12C3.226 16.338 7.244 19.5 12 19.5c.993 0 1.953-.138 2.863-.395M6.228 6.228A10.45 10.45 0 0112 4.5c4.756 0 8.773 3.162 10.065 7.498a10.523 10.523 0 01-4.293 5.774M6.228 6.228L3 3m3.228 3.228l3.65 3.65m7.894 7.894L21 21m-3.228-3.228l-3.65-3.65m0 0a3 3 0 10-4.243-4.243m4.242 4.242L9.88 9.88"
      />
    </svg>
    """
  end

  attr(:rest, :global)

  @doc """
  Renders a exclamation icon
  """
  def exclamation_icon(assigns) do
    ~H"""
    <svg {@rest} xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
      <path
        fill-rule="evenodd"
        d="M2.25 12c0-5.385 4.365-9.75 9.75-9.75s9.75 4.365 9.75 9.75-4.365 9.75-9.75 9.75S2.25 17.385 2.25 12zM12 8.25a.75.75 0 01.75.75v3.75a.75.75 0 01-1.5 0V9a.75.75 0 01.75-.75zm0 8.25a.75.75 0 100-1.5.75.75 0 000 1.5z"
        clip-rule="evenodd"
      />
    </svg>
    """
  end

  attr(:rest, :global)

  @doc """
  Renders a arrow up right icon
  """
  def arrow_up_right_icon(assigns) do
    ~H"""
    <svg {@rest} xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
      <path d="M16.0037 9.41421L7.39712 18.0208L5.98291 16.6066L14.5895 8H7.00373V6H18.0037V17H16.0037V9.41421Z">
      </path>
    </svg>
    """
  end

  attr(:rest, :global)

  @doc """
  Renders a arrow up icon
  """
  def arrow_up_icon(assigns) do
    ~H"""
    <svg {@rest} xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
      <path d="M13.0001 7.82843V20H11.0001V7.82843L5.63614 13.1924L4.22192 11.7782L12.0001 4L19.7783 11.7782L18.3641 13.1924L13.0001 7.82843Z">
      </path>
    </svg>
    """
  end

  attr(:rest, :global)

  @doc """
  Renders a arrow down icon
  """
  def arrow_down_icon(assigns) do
    ~H"""
    <svg {@rest} xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
      <path d="M13.0001 16.1716L18.3641 10.8076L19.7783 12.2218L12.0001 20L4.22192 12.2218L5.63614 10.8076L11.0001 16.1716V4H13.0001V16.1716Z">
      </path>
    </svg>
    """
  end

  attr(:rest, :global)

  @doc """
  Renders a arrow down right icon
  """
  def arrow_down_right_icon(assigns) do
    ~H"""
    <svg {@rest} xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
      <path d="M14.5895 16.0032L5.98291 7.39664L7.39712 5.98242L16.0037 14.589V7.00324H18.0037V18.0032H7.00373V16.0032H14.5895Z">
      </path>
    </svg>
    """
  end

  attr(:rest, :global)

  @doc """
  Renders a arrow right icon
  """
  def arrow_right_icon(assigns) do
    ~H"""
    <svg {@rest} xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
      <path d="M16.1716 10.9999L10.8076 5.63589L12.2218 4.22168L20 11.9999L12.2218 19.778L10.8076 18.3638L16.1716 12.9999H4V10.9999H16.1716Z">
      </path>
    </svg>
    """
  end

  attr(:rest, :global)

  @doc """
  Renders a arrow down head icon
  """
  def arrow_down_head_icon(assigns) do
    ~H"""
    <svg {@rest} xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
      <path d="M11.9999 13.1714L16.9497 8.22168L18.3639 9.63589L11.9999 15.9999L5.63599 9.63589L7.0502 8.22168L11.9999 13.1714Z">
      </path>
    </svg>
    """
  end

  attr(:rest, :global)

  @doc """
  Renders a x circle icon
  """
  def x_circle_icon(assigns) do
    ~H"""
    <svg {@rest} xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
      <path d="M12 22C6.47715 22 2 17.5228 2 12C2 6.47715 6.47715 2 12 2C17.5228 2 22 6.47715 22 12C22 17.5228 17.5228 22 12 22ZM12 10.5858L9.17157 7.75736L7.75736 9.17157L10.5858 12L7.75736 14.8284L9.17157 16.2426L12 13.4142L14.8284 16.2426L16.2426 14.8284L13.4142 12L16.2426 9.17157L14.8284 7.75736L12 10.5858Z">
      </path>
    </svg>
    """
  end
end
