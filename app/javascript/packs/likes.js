document.addEventListener("DOMContentLoaded", () => {
  const postContainers = document.getElementsByClassName("posts");
  const likeButtons = document.querySelector(".like-button");

  if (postContainers && likeButtons) {
    for (let i = 0; i < postContainers.length; i++) {
      const likeButton = postContainers[i].querySelector(".like-button");
      const icon = postContainers[i].querySelector(".icon");
      const likeCountElement = postContainers[i].querySelector(".like-count");
      const postId = likeCountElement.dataset.postId;

      handleAjax(likeButton, icon, likeCountElement, postId);
      updateLikeCount(postId, likeCountElement);

      setInterval(function () {
        updateLikeCount(postId, likeCountElement);
      }, 5000);
    }
  }
});

function handleAjax(likeButton, icon, likeCountElement, postId) {
  if (likeButton && icon) {
    likeButton.addEventListener("ajax:success", (event) => {
      const [data, _status, xhr] = event.detail;
      const response = JSON.parse(xhr.responseText);

      likeButton.innerText = response.liked ? "Liked" : "Like";
      likeButton.classList.toggle("post-button-title-on", response.liked);
      likeButton.classList.toggle("post-button-title", !response.liked);

      icon.classList.toggle("material-symbols-outlined", !response.liked);
      icon.classList.toggle("material-symbols-rounded", response.liked);

      updateLikeCount(postId, likeCountElement);
    });
  }
}

function updateLikeCount(postId, likeCountElement) {
  $.ajax({
    url: "/posts/" + postId + "/likes",
    method: "GET",
    dataType: "json",
    success: function (response) {
      if (response.like_count == 0) {
        $(likeCountElement).text(" ");
      } else if (response.like_count == 1) {
        $(likeCountElement).text("1 Like");
      } else {
        $(likeCountElement).text(response.like_count + " Likes");
      }
    },
    error: function () {
      console.log("Error occurred while updating like count.");
    },
  });
}
