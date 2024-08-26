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

// From: https://bocoup.com/weblog/2d-picking-in-canvas

export const genColor = (nextCol = 1) => {
  const ret = [];
  // via http://stackoverflow.com/a/15804183
  if (nextCol < 16777215) {
    ret.push(nextCol & 0xff); // R
    ret.push((nextCol & 0xff00) >> 8); // G
    ret.push((nextCol & 0xff0000) >> 16); // B
    nextCol += 1;
  }
  return "rgb(" + ret.join(",") + ")";
};

// From: https://stackoverflow.com/a/52414278
export function doesPointCollide(p, box) {
  return !(
    p.x < box.left ||
    p.x > box.right ||
    p.y > box.bottom ||
    p.y < box.top
  );
}
