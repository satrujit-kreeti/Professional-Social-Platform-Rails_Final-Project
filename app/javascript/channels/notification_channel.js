import consumer from "./consumer";

document.addEventListener("turbolinks:load", function () {
  const notificationContainer = document.getElementById(
    "notification-container"
  );
  const notificationIconBackground = document.getElementById("not-icon-back");
  const notificationIcon = document.getElementById("not-icon");
  const markAllReadButton = document.getElementById("mark-all-read-button");

  if (notificationContainer) {
    const currentUserId = notificationContainer.dataset.currentuserid;

    consumer.subscriptions.create(
      { channel: "NotificationChannel", sender_id: currentUserId },
      {
        connected() {},

        disconnected() {},

        received(data) {
          const notificationElement = document.createElement("div");
          notificationElement.innerText = data.message;
          notificationElement.classList.add("notification", "text-dark", "p-2");

          notificationIconBackground.classList.add("blue");
          notificationIcon.classList.replace("text-dark", "text-light");

          notificationIconBackground.addEventListener("click", function () {
            notificationIconBackground.classList.remove("blue");
            notificationIcon.classList.replace("text-light", "text-dark");
          });

          markAllReadButton.disabled = false;

          notificationContainer.insertBefore(
            notificationElement,
            notificationContainer.firstChild
          );
        },
      }
    );
  }
});
