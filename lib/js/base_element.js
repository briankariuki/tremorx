import { sendData } from "./send_data";

class BaseHtmlElement extends HTMLElement {
  constructor() {
    super();
  }

  /**
   * Defines a property/attribute on the HTMLElement
   * @param {string} attr - The name of the property to define.
   * @param {(attr: string) => any} getter - A function to retrieve the value of the property.
   *   The parameter `attr` represents the name of the property.
   *   By default, it uses `this.getAttribute(attr)` to get the value.
   * @param {(val: any, attr: string) => void} setter - A function to set the value of the property.
   *   The first parameter `val` is the new value, and `attr` represents the name of the property.
   *   By default, it uses `this.setAttribute(attr, val)` to set the value or `this.removeAttribute(attr)` if the value is `undefined`.
   * @param {Object} [options={}] - Additional options for the property descriptor.
   * @param {boolean} [options.configurable=true] - Whether the property descriptor can be changed and the property can be deleted.
   * @param {boolean} [options.enumerable=false] - Whether the property is enumerable (defaults to `false` unless overridden).
   * @returns {HTMLElement}
   */
  defineProperty(
    attr,
    getter = (attr) => this.getAttribute(attr),
    setter = (val, attr) =>
      val == undefined
        ? this.removeAttribute(attr)
        : this.setAttribute(attr, val),
    options = {
      configurable: true,
    }
  ) {
    return Object.defineProperty(this, attr, {
      get() {
        return getter(attr);
      },
      set(val) {
        return setter(val, attr);
      },
      ...options,
    });
  }

  /**
   * Push data payload to liveview
   * @param {string} event - The name of the event.
   * @param {any} payload - Map data to send.
   * @returns {void}
   */
  pushEvent(event, payload) {
    sendData(event, payload);
  }

  connectedCallback() {}

  disconnectedCallback() {}

  adoptedCallback() {}

  attributeChangedCallback(name, oldValue, newValue) {}

  // attachRoot() {
  //   let template = document.getElementById("custom-paragraph");
  //   let templateContent = template.content;

  //   const shadowRoot = this.attachShadow({ mode: "open" });
  //   shadowRoot.appendChild(templateContent.cloneNode(true));
  // }
}

export default BaseHtmlElement;
