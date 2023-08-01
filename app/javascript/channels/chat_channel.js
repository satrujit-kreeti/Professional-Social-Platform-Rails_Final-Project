import consumer from "../channels/consumer";

document.addEventListener("turbolinks:load", () => {
  if (document.getElementById("conversation") != null) {
    const conversationId = document.getElementById("conversation").dataset
      .conversationId;
    const messageInput = document.getElementById("chat_message");
    const messagesContainer = document.getElementById("messages");
    const messageForm = document.getElementById("form");

    const currentUserUsername = document.getElementById("current-user-username")
      .dataset.username;

    function scrollToBottom() {
      messagesContainer.scrollTop = messagesContainer.scrollHeight;
    }

    if (messageForm) {
      console.log("form");

      messageForm.addEventListener("submit", (event) => {
        event.preventDefault();

        const formData = new FormData(messageForm);

        fetch(messageForm.action, {
          method: messageForm.method,
          body: formData,
        })
          .then((response) => {
            if (response.ok) {
            } else {
            }
          })
          .catch((error) => {});
      });
    }

    consumer.subscriptions.create(
      { channel: "ChatChannel", conversation_id: conversationId },
      {
        connected() {
          scrollToBottom();
        },
        received: function (data) {
          const messageClass =
            data.sender === currentUserUsername
              ? "message current-user"
              : "message";
          const messageDivClass =
            data.sender === currentUserUsername ? "your-message" : "";

          messagesContainer.insertAdjacentHTML(
            "beforeend",
            `<div class="${messageDivClass}"><p class="${messageClass}"> ${data.message}</p></div>`
          );
          messageInput.value = "";

          const submitButton = document.querySelector("#message_submit");
          submitButton.disabled = false;

          scrollToBottom();
        },
        speak: function (message) {
          return this.perform("receive", {
            conversation_id: conversationId,
            message: message,
          });
        },
      }
    );
  }
});
