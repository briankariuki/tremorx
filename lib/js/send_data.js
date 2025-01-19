export const SendData = {
  mounted() {
    document.addEventListener("send-data-event", (e) => {
      this.pushEvent(e.detail.event, e.detail.payload);
    });
  },
};

export const sendData = (event, payload) => {
  let relay_event = new CustomEvent("send-data-event", {
    detail: { event: event, payload: payload },
  });

  document.dispatchEvent(relay_event);
};
