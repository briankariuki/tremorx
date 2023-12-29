export default Input = {
  mounted() {
    let inputId = this.el.id;
    const inputField = document.getElementById(`${inputId}_field`);
    const inputWrapper = document.getElementById(`${inputId}_wrapper`);
    const input = document.getElementById(inputId);
    const canAutofocus = input?.getAttribute("data-autofocus");
    const inputType = inputField?.getAttribute("type");

    if (canAutofocus == "true") {
      inputField.focus();
      input.setAttribute("data-focus", true);
      inputWrapper.classList.add(
        "ring-2",
        "border-tremor-brand-subtle",
        "ring-tremor-brand-muted",
        "dark:border-dark-tremor-brand-subtle",
        "dark:ring-dark-tremor-brand-muted"
      );
    }

    inputField.addEventListener("focus", (_) => {
      inputField.focus();
      input.setAttribute("data-focus", true);
      inputWrapper.classList.add(
        "ring-2",
        "border-tremor-brand-subtle",
        "ring-tremor-brand-muted",
        "dark:border-dark-tremor-brand-subtle",
        "dark:ring-dark-tremor-brand-muted"
      );
    });

    inputField.addEventListener("blur", (_) => {
      inputField.blur();
      input.setAttribute("data-focus", false);
      inputWrapper.classList.remove(
        "ring-2",
        "border-tremor-brand-subtle",
        "ring-tremor-brand-muted",
        "dark:border-dark-tremor-brand-subtle",
        "dark:ring-dark-tremor-brand-muted"
      );
    });

    if (inputType == "password") {
      const eyeBtn = document.getElementById(`${inputId}_eye_btn`);
      const eyeIcon = document.getElementById(`${inputId}_eye_icon`);
      const eyeOffIcon = document.getElementById(`${inputId}_eye_off_icon`);

      eyeBtn.setAttribute("data-is-password-visible", "false");

      eyeBtn.addEventListener("click", (_) => {
        setTimeout(() => {
          const isPasswordVisible = eyeBtn.getAttribute(
            "data-is-password-visible"
          );

          if (isPasswordVisible == "true") {
            eyeIcon.classList.remove("hidden");
            eyeOffIcon.classList.add("hidden");
            eyeBtn.setAttribute("data-is-password-visible", "false");
            inputField.setAttribute("type", "password");
          } else {
            eyeOffIcon.classList.remove("hidden");
            eyeIcon.classList.add("hidden");
            eyeBtn.setAttribute("data-is-password-visible", "true");
            inputField.setAttribute("type", "text");
          }
        }, 100);
      });
    }
  },

  updated() {},
};
