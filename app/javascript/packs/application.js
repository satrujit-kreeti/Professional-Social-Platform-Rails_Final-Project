// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import "channels";
require("jquery");

Rails.start();
Turbolinks.start();
ActiveStorage.start();

document.addEventListener("turbolinks:load", () => {
  const notificationContainer = document.querySelector(
    ".notification-container-flash"
  );

  if (notificationContainer) {
    setTimeout(() => {
      notificationContainer.style.display = "none";
    }, 2000);
  }
});

document.addEventListener("turbolinks:load", () => {
  const radioButtons = document.querySelectorAll(
    "input[data-target='#yearsRangeField']"
  );
  const organization = document.getElementById("organization");

  if (radioButtons && organization) {
    const fresherRadioButton = document.querySelector("input[value='fresher']");
    const experiencedRadioButton = document.querySelector(
      "input[value='experienced']"
    );
    const targetFieldId = fresherRadioButton.dataset.target;
    const targetField = document.querySelector(targetFieldId);

    if (fresherRadioButton.checked) {
      $(targetField).hide();
      $(organization).hide();
    } else {
      $(targetField).slideDown();
      $(organization).slideDown();
    }

    radioButtons.forEach(function (radioButton) {
      radioButton.addEventListener("change", function () {
        if (radioButton.value === "experienced" && radioButton.checked) {
          $(targetField).slideDown();
          $(organization).slideDown();
        } else {
          $(targetField).slideUp();
          $(organization).slideUp();
        }

        if (radioButton.value === "fresher" && radioButton.checked) {
          const yearsRangeDropdown = document.getElementById("user_experience");
          yearsRangeDropdown.value = "";
        }
      });
    });
  }
});

document.addEventListener("turbolinks:load", () => {
  const addJobProfileButton = document.getElementById("add-job-profile");
  const jobProfilesFields = document.getElementById("job_profiles-fields");
  const enableJobProfilesCheckbox = document.getElementById(
    "enable-job-profiles"
  );

  if (addJobProfileButton && jobProfilesFields && enableJobProfilesCheckbox) {
    const toggleAddJobProfileButton = () => {
      if (enableJobProfilesCheckbox.checked) {
        addJobProfileButton.removeAttribute("disabled");
      } else {
        addJobProfileButton.setAttribute("disabled", "disabled");
        while (jobProfilesFields.children.length > 1) {
          jobProfilesFields.lastElementChild.remove();
        }
      }
    };

    enableJobProfilesCheckbox.addEventListener("change", () => {
      toggleAddJobProfileButton();
    });

    addJobProfileButton.addEventListener("click", () => {
      if (enableJobProfilesCheckbox.checked) {
        const timestamp = new Date().getTime();
        const regexp = new RegExp(timestamp, "g");
        jobProfilesFields.insertAdjacentHTML(
          "beforeend",
          jobProfileFields(timestamp)
        );
      }
    });

    toggleAddJobProfileButton();
  }

  function jobProfileFields(timestamp) {
    return `
      <div class="nested-fields">
        <div class="mb-3">
          <label class="form-label" for="user_job_profiles_attributes_${timestamp}_title">Job Title</label>
          <input class="form-control" type="text" name="user[job_profiles_attributes][${timestamp}][title]" id="user_job_profiles_attributes_${timestamp}_title">
        </div>
      </div>
    `;
  }
});

document.addEventListener("turbolinks:load", () => {
  const jobProfilesList = document.getElementById("job-profiles-list");

  if (jobProfilesList) {
    jobProfilesList.addEventListener("click", (event) => {
      if (event.target.matches(".edit-job-profile")) {
        const jobProfileItem = event.target.closest(".job-profile-item");
        const jobProfileId = jobProfileItem.dataset.jobProfileId;
        const jobProfileTitle = jobProfileItem.dataset.jobProfileTitle;
        toggleEditForm(jobProfileId, jobProfileTitle);
      }
    });
  }

  function toggleEditForm(jobProfileId, jobProfileTitle) {
    const jobProfileItem = document.querySelector(
      `.job-profile-item[data-job-profile-id="${jobProfileId}"]`
    );

    if (jobProfileItem) {
      const editFormHtml = `
        <form class="edit-job-profile-form" data-job-profile-id="${jobProfileId}">
          <div class="mb-3">
            <label class="form-label" for="job_profile_title_${jobProfileId}">Job Titles</label>
            <input class="form-control" type="text" name="job_profile[title]" id="job_profile_title_${jobProfileId}" value="${jobProfileTitle}">
          </div>
          <button type="button" class="btn btn-success btn-sm save-job-profile">Done</button>
        </form>
      `;

      jobProfileItem.innerHTML = editFormHtml;

      const saveButton = jobProfileItem.querySelector(".save-job-profile");
      if (saveButton) {
        saveButton.addEventListener("click", () => {
          const titleInput = jobProfileItem.querySelector(
            `#job_profile_title_${jobProfileId}`
          );
          updateJobProfile(jobProfileId, titleInput.value);
        });
      }
    }
  }

  function updateJobProfile(jobProfileId, newTitle) {
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content;

    fetch(`/job_profiles/${jobProfileId}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken,
      },
      body: JSON.stringify({ job_profile: { title: newTitle } }),
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.success) {
          const jobProfileItem = document.querySelector(
            `.job-profile-item[data-job-profile-id="${jobProfileId}"]`
          );
          jobProfileItem.innerHTML = `${data.job_profile.title} <button type="button" class="btn btn-primary btn-sm edit-job-profile">Edit</button> <a href="/job_profiles/${jobProfileId}" data-confirm="Are you sure you want to delete this job profile?" data-method="delete" class="btn btn-danger btn-sm">Delete</a>`;
        } else {
          alert("Failed to update job profile. Please try again.");
        }
      })
      .catch((error) => {
        console.error("Error:", error);
        alert(
          "An error occurred while updating the job profile. Please try again."
        );
      });
  }
});
