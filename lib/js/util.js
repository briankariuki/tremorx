export async function enter(element, { enter, enterFrom, enterTo }) {
  element.classList.remove("hidden");

  element.classList.add(...enter);
  element.classList.add(...enterFrom);

  //Wait until next frame after browser paint
  await nextFrame();
  element.classList.remove(...enterFrom);
  element.classList.add(...enterTo);

  //Wait until the transition is over

  await afterTransition(element);

  element.classList.remove(...enterTo);
  element.classList.remove(...enter);
}

export async function leave(element, { leave, leaveFrom, leaveTo }) {
  element.classList.add(...leave);
  element.classList.add(...leaveFrom);

  //Wait until next frame after browser paint
  await nextFrame();
  element.classList.remove(...leaveFrom);
  element.classList.add(...leaveTo);

  //Wait until the transition is over

  await afterTransition(element);

  element.classList.remove(...leaveTo);
  element.classList.remove(...leave);
  element.classList.add("hidden");
}

export async function nextFrame() {
  return new Promise((resolve) => {
    requestAnimationFrame(() => {
      requestAnimationFrame(resolve);
    });
  });
}

export async function afterTransition(element) {
  return new Promise((resolve) => {
    const duration = Number(
      getComputedStyle(element).transitionDuration.replace("s", "") * 1000
    );

    setTimeout(() => {
      resolve();
    }, duration);
  });
}
