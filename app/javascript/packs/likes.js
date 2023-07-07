document.addEventListener("DOMContentLoaded", () => {
  const likeButton = document.getElementById("like-button");
  const icon = document.getElementById("icon");

  handleAjax(likeButton, icon);
  
});


document.addEventListener("DOMContentLoaded", () => {
  const postContainers = document.getElementsByClassName("posts");

  for (let i = 0; i < postContainers.length; i++) {
    const likeButton = postContainers[i].querySelector(".like-button");
    const icon = postContainers[i].querySelector(".icon");

    handleAjax(likeButton, icon);
    
  }
});


function handleAjax(likeButton, icon){
  if (likeButton && icon) {
    likeButton.addEventListener("ajax:success", (event) => {
      const [data, _status, xhr] = event.detail;
      const response = JSON.parse(xhr.responseText);
      
      likeButton.innerText = response.liked ? "Liked" : "Like";
      likeButton.classList.toggle("post-button-title-on", response.liked);
      likeButton.classList.toggle("post-button-title", !response.liked);

      icon.classList.toggle("material-symbols-outlined", !response.liked);
      icon.classList.toggle("material-symbols-rounded", response.liked);
    });
  }
}

