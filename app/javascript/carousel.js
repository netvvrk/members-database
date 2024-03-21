const BUTTON_ACTIVE_CLASS = "bg-slate-300";
const INACTIVE_CLASSES = ["hidden"];
const ACTIVE_CLASSES = [];

const containers = document.querySelectorAll("[data-carousel]");

containers.forEach((container) => {
  const nextBtn = container.querySelector("button[data-carousel-next]");
  const prevBtn = container.querySelector("button[data-carousel-prev]");
  const items = container.querySelectorAll("[data-carousel-item]");
  const buttons = container.querySelectorAll("[data-carousel-slide-to]");

  const itemsCount = items.length;

  let index = 0;
  let prevIndex = -1;

  const init = () => {
    if (itemsCount > -1) {
      activateIndex(0);
    }
  };
  const activateIndex = (index) => {
    if (prevIndex !== -1) {
      items[prevIndex].classList.add(INACTIVE_CLASSES);
      buttons[prevIndex].classList.remove(BUTTON_ACTIVE_CLASS);
    }
    if (index < itemsCount) {
      items[index].classList.remove(INACTIVE_CLASSES);
      buttons[index].classList.add(BUTTON_ACTIVE_CLASS);
    }
  };

  init();

  buttons.forEach((button) =>
    button.addEventListener("click", (event) => {
      prevIndex = index;
      index = event.target.dataset.carouselSlideTo;
      activateIndex(index);
    })
  );

  nextBtn.addEventListener("click", () => {
    prevIndex = index;
    index = (index + 1) % itemsCount;
    activateIndex(index);
  });

  prevBtn.addEventListener("click", () => {
    prevIndex = index;
    index = index === 0 ? itemsCount - 1 : index - 1;
    activateIndex(index);
  });
});
