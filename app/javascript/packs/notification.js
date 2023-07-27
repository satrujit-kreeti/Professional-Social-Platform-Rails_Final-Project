document.addEventListener("DOMContentLoaded", function () {
  const markAllReadButton = document.getElementById("mark-all-read-button");

  if (markAllReadButton) {
    markAllReadButton.addEventListener("click", function () {
      const csrfToken = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content");

      fetch("/mark_all_as_read", {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken,
        },
        body: JSON.stringify({}),
      })
        .then((response) => {
          if (response.ok) {
            location.reload();
          } else {
          }
        })
        .catch((error) => {});
    });
  }
});
