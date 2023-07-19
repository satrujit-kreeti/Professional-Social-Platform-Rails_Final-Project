import consumer from './consumer';
console.log("hi")

document.addEventListener('turbolinks:load', function() {
  console.log("hi again")

  const notificationContainer = document.getElementById('notification-container');
  const notificationIconBackground = document.getElementById('not-icon-back');
  const notificationIcon = document.getElementById('not-icon');
  const markAllReadButton = document.getElementById("mark-all-read-button");



  const currentUserId = notificationContainer.dataset.currentuserid;

  consumer.subscriptions.create({ channel: 'NotificationChannel', sender_id: currentUserId }, {
    connected() {
      console.log("Connected")
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      console.log("Notification received:", data);
      const notificationElement = document.createElement('div');
      notificationElement.innerText = data.message;
      notificationElement.classList.add('notification', 'text-dark');



      notificationIconBackground.classList.add('blue');
      notificationIcon.classList.replace('text-dark', 'text-light');
      

      notificationIconBackground.addEventListener('click', function() {
        notificationIconBackground.classList.remove('blue');
        notificationIcon.classList.replace('text-light', 'text-dark');
      });

      markAllReadButton.disabled = false;

      // Add the notificationElement to your notification container in the DOM
      notificationContainer.insertBefore(notificationElement, notificationContainer.firstChild);
    }
  });

});