defmodule Tremorx.Components.Input do
  @moduledoc """
  Inputs - Textinput, Textarea
  """

  alias Tails
  alias Tremorx.Theme
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  import Tremorx.Assets

  attr(:type, :string, values: ~w(text password email url number))
  attr(:value, :any, default: "")
  attr(:error, :boolean, default: false)
  attr(:error_message, :string)
  attr(:disabled, :boolean, default: false)
  slot(:icon, required: false)
  slot(:stepper, required: false)
  attr(:input_class_name, :string)
  attr(:class, :string, default: nil)
  attr(:placeholder, :string, default: "Type...")
  attr(:autofocus, :boolean, default: false)
  attr(:rest, :global)

  @doc false
  defp base_input(assigns) do
    assigns =
      assigns
      |> assign(has_selection: has_selection(assigns[:value]))
      |> assign_new(:input_id, fn ->
        "input_#{to_string(System.unique_integer([:positive]))}"
      end)

    ~H"""
    <div
      id={@input_id}
      data-autofocus={@autofocus}
      data-focus="false"
      phx-mounted={
        if(@type == "password",
          do:
            JS.dispatch("input_mounted", detail: %{id: @input_id})
            |> JS.dispatch("password_input_mounted", detail: %{id: @input_id}),
          else: JS.dispatch("input_mounted", detail: %{id: @input_id})
        )
      }
    >
      <div
        id={"#{@input_id}_wrapper"}
        class={
          Tails.classes([
            Theme.make_class_name(@input_class_name, "root"),
            "relative w-full flex items-center min-w-[10rem] outline-none rounded-tremor-default transition duration-100",
            "shadow-tremor-input",
            "dark:shadow-dark-tremor-input",
            get_select_button_colors(@has_selection, @disabled, @error),
            Theme.get_border_style("sm", "all"),
            if(is_nil(@class), do: "", else: @class)
          ])
        }
      >
        <div
          :if={@icon != []}
          class={
            Tails.classes([
              Theme.make_class_name(@input_class_name, "icon"),
              "shrink-0",
              "flex items-center justify-center",
              "text-tremor-content-subtle",
              "dark:text-dark-tremor-content-subtle",
              Theme.get_sizing_style("lg", "height"),
              Theme.get_sizing_style("lg", "width"),
              Theme.get_spacing_style("md", "margin_left")
            ])
          }
        >
          <%= render_slot(@icon) %>
        </div>

        <input
          id={"#{@input_id}_field"}
          type={@type}
          placeholder={@placeholder}
          disabled={@disabled}
          value={Phoenix.HTML.Form.normalize_value(@type, @value) || ""}
          class={
            Tails.classes([
              Theme.make_class_name(@input_class_name, "input"),
              "w-full focus:outline-none focus:ring-0 border-none bg-transparent text-tremor-default rounded-tremor-default transition duration-100",
              "text-tremor-content-emphasis",
              "dark:text-dark-tremor-content-emphasis",
              "[appearance:textfield] [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none",
              if(is_nil(@icon) == false,
                do: Theme.get_spacing_style("sm", "padding_left"),
                else: Theme.get_spacing_style("lg", "padding_left")
              ),
              if(@error == true,
                do: Theme.get_spacing_style("lg", "padding_right"),
                else: Theme.get_spacing_style("two_xl", "padding_right")
              ),
              Theme.get_spacing_style("sm", "padding_y"),
              if(@disabled == true,
                do:
                  "placeholder:text-tremor-content-subtle dark:placeholder:text-dark-tremor-content-subtle",
                else: "placeholder:text-tremor-content dark:placeholder:text-dark-tremor-content"
              )
            ])
          }
          {@rest}
        />

        <button
          :if={@type == "password" && @disabled == false}
          id={"#{@input_id}_eye_btn"}
          type="button"
          class={
            Tails.classes([
              Theme.make_class_name(@input_class_name, "toggle-button"),
              "mr-2"
            ])
          }
        >
          <.eye_off_icon
            id={"#{@input_id}_eye_off_icon"}
            class={
              Tails.classes([
                "flex-none hidden h-5 w-5 transition",
                "text-tremor-content-subtle hover:text-tremor-content",
                "dark:text-dark-tremor-content-subtle hover:dark:text-dark-tremor-content"
              ])
            }
          />

          <.eye_icon
            id={"#{@input_id}_eye_icon"}
            class={
              Tails.classes([
                "flex-none h-5 w-5 transition",
                "text-tremor-content-subtle hover:text-tremor-content",
                "dark:text-dark-tremor-content-subtle hover:dark:text-dark-tremor-content"
              ])
            }
          />
        </button>

        <.exclamation_icon
          :if={@error == true}
          class={
            Tails.classes([
              Theme.make_class_name(@input_class_name, "error-icon"),
              "text-rose-500 shrink-0",
              Theme.get_spacing_style("md", "margin_right"),
              Theme.get_sizing_style("lg", "height"),
              Theme.get_sizing_style("lg", "width")
            ])
          }
        />

        <%= render_slot(@stepper) %>
      </div>

      <p
        :if={@error == true && is_nil(@error_message) == false}
        class={
          Tails.classes([
            Theme.make_class_name(@input_class_name, "error-message"),
            "text-sm text-rose-500 mt-1"
          ])
        }
      >
        <%= @error_message %>
      </p>
    </div>

    <script>
      document.addEventListener("input_mounted", (e) => {
        const inputId = e.detail.id
        const inputField = document.getElementById(`${inputId}_field`)
        const inputWrapper = document.getElementById(`${inputId}_wrapper`)
        const input = document.getElementById(inputId)
        const canAutofocus = input.getAttribute("data-autofocus")

        if(canAutofocus == "true") {
          inputField.focus()
          input.setAttribute("data-focus", true)
          inputWrapper.classList.add(
            "ring-2",
            "border-tremor-brand-subtle",
            "ring-tremor-brand-muted",
            "dark:border-dark-tremor-brand-subtle",
            "dark:ring-dark-tremor-brand-muted"
          )
        }

        inputField.addEventListener("focus", (_) => {
          inputField.focus()
          input.setAttribute("data-focus", true)
          inputWrapper.classList.add(
            "ring-2",
            "border-tremor-brand-subtle",
            "ring-tremor-brand-muted",
            "dark:border-dark-tremor-brand-subtle",
            "dark:ring-dark-tremor-brand-muted"
          )
        })

        inputField.addEventListener("blur", (_) => {
          inputField.blur()
          input.setAttribute("data-focus", false)
          inputWrapper.classList.remove(
            "ring-2",
            "border-tremor-brand-subtle",
            "ring-tremor-brand-muted",
            "dark:border-dark-tremor-brand-subtle",
            "dark:ring-dark-tremor-brand-muted"
          )
        })
      })

      document.addEventListener("password_input_mounted", (e) => {
        const inputId = e.detail.id
        const inputField = document.getElementById(`${inputId}_field`)
        const eyeBtn = document.getElementById(`${inputId}_eye_btn`)
        const eyeIcon = document.getElementById(`${inputId}_eye_icon`)
        const eyeOffIcon = document.getElementById(`${inputId}_eye_off_icon`)

        eyeBtn.setAttribute("data-is-password-visible", false)

        eyeBtn.addEventListener("click", (_) => {
          setTimeout(() => {
            const isPasswordVisible = eyeBtn.getAttribute("data-is-password-visible")

            if(isPasswordVisible == "true") {
              eyeIcon.classList.remove("hidden")
              eyeOffIcon.classList.add("hidden")
              eyeBtn.setAttribute("data-is-password-visible", false)
              inputField.setAttribute("type", "password")
            } else {
              eyeOffIcon.classList.remove("hidden")
              eyeIcon.classList.add("hidden")
              eyeBtn.setAttribute("data-is-password-visible", true)
              inputField.setAttribute("type", "text")

            }
          }, 200)
        })

      })
    </script>
    """
  end

  attr(:value, :any, default: "")
  attr(:error, :boolean, default: false)
  attr(:error_message, :string)
  attr(:disabled, :boolean, default: false)
  attr(:textarea_class_name, :string)
  attr(:class, :string, default: nil)
  attr(:placeholder, :string, default: "Type...")
  attr(:autofocus, :boolean, default: false)
  attr(:rest, :global)

  @doc false
  defp base_textarea(assigns) do
    assigns =
      assigns
      |> assign(has_selection: has_selection(assigns[:value]))
      |> assign_new(:textarea_id, fn ->
        "textarea_#{to_string(System.unique_integer([:positive]))}"
      end)

    ~H"""
    <div id={@textarea_id}>
      <textarea
        id={"#{@textarea_id}_field"}
        placeholder={@placeholder}
        disabled={@disabled}
        value={Phoenix.HTML.Form.normalize_value("text", @value || "")}
        class={
          Tails.classes([
            Theme.make_class_name(@textarea_class_name, "textarea"),
            "w-full flex items-center outline-none rounded-tremor-default px-3 py-2 text-tremor-default focus:ring-2 transition duration-100",
            "shadow-tremor-input focus:border-tremor-brand-subtle focus:ring-tremor-brand-muted",
            "dark:shadow-dark-tremor-input focus:dark:border-dark-tremor-brand-subtle focus:dark:ring-dark-tremor-brand-muted",
            get_select_button_colors(@has_selection, @disabled, @error),
            Theme.get_border_style("sm", "all"),
            if(@disabled == true,
              do:
                "placeholder:text-tremor-content-subtle dark:placeholder:text-dark-tremor-content-subtle",
              else: "placeholder:text-tremor-content dark:placeholder:text-dark-tremor-content"
            ),
            if(is_nil(@class), do: "", else: @class)
          ])
        }
        {@rest}
      />

      <p
        :if={@error == true && is_nil(@error_message) == false}
        class={
          Tails.classes([
            Theme.make_class_name(@textarea_class_name, "error-message"),
            "text-sm text-rose-500 mt-1"
          ])
        }
      >
        <%= @error_message %>
      </p>
    </div>
    """
  end

  attr(:id, :any, default: nil)
  attr(:name, :any, default: nil)
  attr(:value, :any)
  attr(:type, :string, default: "text", values: ~w(text password url email))
  attr(:error, :boolean, default: false)
  attr(:disabled, :boolean, default: false)
  attr(:autofocus, :boolean, default: false)
  attr(:error_message, :string)
  attr(:class, :string)
  attr(:placeholder, :string, default: "Type...")
  slot(:icon)

  attr(:field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"
  )

  @doc """
  Renders a text input field
  """
  def text_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(id: assigns.id || field.id)
    |> assign(input_class_name: "text-input")
    |> assign_new(:name, fn -> field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> base_input()
  end

  def text_input(assigns) do
    assigns
    |> assign(input_class_name: "text-input")
    |> base_input()
  end

  attr(:id, :any, default: nil)
  attr(:name, :any, default: nil)
  attr(:value, :any)
  attr(:error, :boolean, default: false)
  attr(:disabled, :boolean, default: false)
  attr(:error_message, :string)
  attr(:class, :string)
  attr(:placeholder, :string, default: "Type...")

  attr(:field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"
  )

  @doc """
  Renders a text area input field
  """
  def textarea_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(id: assigns.id || field.id)
    |> assign(textarea_class_name: "textarea-input")
    |> assign_new(:name, fn -> field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> base_textarea()
  end

  def textarea_input(assigns) do
    assigns
    |> assign(textarea_class_name: "textarea-input")
    |> base_textarea()
  end

  @doc false
  defp get_select_button_colors(has_selection, disabled, has_error) do
    Tails.classes([
      if(disabled == true,
        do: "bg-tremor-background-subtle dark:bg-dark-tremor-background-subtle",
        else: "bg-tremor-background dark:bg-dark-tremor-background"
      ),
      if(disabled == false,
        do: "hover:bg-tremor-background-muted dark:hover:bg-dark-tremor-background-muted",
        else: ""
      ),
      if(has_selection == true,
        do: "text-tremor-content-emphasis dark:text-dark-tremor-content-emphasis",
        else: "text-tremor-content dark:text-dark-tremor-content"
      ),
      if(disabled == true,
        do: "text-tremor-content-subtle dark:text-dark-tremor-content-subtle",
        else: ""
      ),
      if(has_error == true,
        do: "text-rose-500",
        else: ""
      ),
      if(has_error == true,
        do: "border-rose-500",
        else: "border-tremor-border dark:border-dark-tremor-border"
      )
    ])
  end

  @doc false
  defp has_selection(value) do
    is_nil(value) == false && value != ""
  end
end
