import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";

import "jquery";
import("plugins"); // async

import "css/site";

Rails.start();
Turbolinks.start();

document.addEventListener("turbolinks:load", () => {
  jQuery("[data-toggle='tooltip']").tooltip();
});
