import "jquery";
import "popper.js";
import "bootstrap";

import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";

export function start() {
  Rails.start();
  Turbolinks.start();

  document.addEventListener("turbolinks:load", () => {
    jQuery("[data-toggle='tooltip']").tooltip();
  });
}
