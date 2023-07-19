import consumer from '../channels/consumer';

console.log('hi');

document.addEventListener('turbolinks:load', () => {
  console.log('hi');

  const conversationId = document.getElementById('conversation').dataset.conversationId;
  const messageInput = document.getElementById('chat_message');
  const messagesContainer = document.getElementById('messages');
  const messageForm = document.getElementById('form');
  const currentUserUsername = document.getElementById('current-user-username').dataset.username;

  if (messageForm) {
    console.log('form');

    messageForm.addEventListener('submit', (event) => {
      event.preventDefault(); // Prevent the default form submission

      const formData = new FormData(messageForm);

      fetch(messageForm.action, {
        method: messageForm.method,
        body: formData
      })
        .then(response => {
          if (response.ok) {
          } else {
          }
        })
        .catch(error => {
        });
    });
  }

  consumer.subscriptions.create(
    { channel: 'ChatChannel', conversation_id: conversationId },
    {
      connected() {
        console.log("Connected to server");
      },
      received: function (data) {
        const messageClass = data.sender === currentUserUsername ? 'message current-user' : 'message';
        const messageDivClass = data.sender === currentUserUsername ? 'your-message' : '';

        messagesContainer.insertAdjacentHTML('beforeend', `<div class="${messageDivClass}"><p class="${messageClass}"> ${data.message}</p></div>`);
        messageInput.value = "";

        const submitButton = document.querySelector("#message_submit");
        submitButton.disabled = false;
      },
      speak: function (message) {
        return this.perform('receive', { conversation_id: conversationId, message: message });
      }
    }
  );
});
