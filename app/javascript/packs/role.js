document.addEventListener("turbolinks:load", () => {
    const addJobRoleLink = document.getElementById("add_job_role_link");
    const jobRolesContainer = document.getElementById("job_roles");
  
    let jobRoleIndex = 0;
  
  
    if (addJobRoleLink && jobRolesContainer){
    function addJobRoleFields() {
      const html = `<div class="job_role_fields mb-3">
                      <label for="job_sector_job_roles_attributes_${jobRoleIndex}_name" class= "form-label">
                        Job Role
                      </label>
                      <input type="text" name="job_sector[job_roles_attributes][${jobRoleIndex}][name]" id="job_sector_job_roles_attributes_${jobRoleIndex}_name" class= "form-control">
                    </div>`;
      jobRolesContainer.insertAdjacentHTML("beforeend", html);
      jobRoleIndex++;
      console.log("clicked");
    }
    addJobRoleFields();

    addJobRoleLink.addEventListener("click", addJobRoleFields);
    }
  });
  


  

document.addEventListener("turbolinks:load", () => {
const jobSectorSelect = document.getElementById("job_sector_select");
const jobRoleSelect = document.getElementById("job_role_select");

if (jobSectorSelect && jobRoleSelect) { // Check if the elements exist on the page
    function updateJobRolesDropdown() {
    const selectedJobSectorId = jobSectorSelect.value;
    console.log("Selected Job Sector ID:", selectedJobSectorId);

    $.ajax({
        url: `/admin/job_sectors/${selectedJobSectorId}/job_roles`,
        type: 'GET',
        data: { id: selectedJobSectorId },
        success: function(data) {
        console.log("Received Job Roles Data:", data);
        // Clear the current job roles dropdown
        jobRoleSelect.innerHTML = "";

        // Add the new options to the job roles dropdown based on the data received
        data.forEach(function(jobRole) {
            const option = document.createElement("option");
            option.value = jobRole.id;
            option.text = jobRole.name;
            jobRoleSelect.appendChild(option);
        });
        },
        error: function(error) {
        console.error("Error:", error);
        }
    });
    }

    // Listen for changes in the job sector dropdown and update the job roles dropdown accordingly
    jobSectorSelect.addEventListener("change", updateJobRolesDropdown);
}
});
  


document.addEventListener("turbolinks:load", () => {
  const addCertificateButton = document.getElementById('add-certificate');
  const certificatesFields = document.getElementById('certificates-fields');


  if (addCertificateButton && certificatesFields){
  

  addCertificateButton.addEventListener('click', function () {
    const time = new Date().getTime();
    const template = `<div class="certificate-fields">
                        <hr>
                        <div class="mb-3">
                          <label class="form-label">Certificate Name</label>
                          <input type="text" name="user[certificates_attributes][${time}][name]" class="form-control">
                        </div>
                        <div class="mb-3">
                          <label class="form-label">Upload Certificate</label>
                          <input type="file" name="user[certificates_attributes][${time}][document]" accept="application/pdf,image/jpeg,image/png" class="form-control">
                        </div>
                        
                      </div>`;
    certificatesFields.insertAdjacentHTML('beforeend', template);
  });
}
});



document.addEventListener("turbolinks:load", () => {
  const pdfThumbnails = document.querySelectorAll('.pdf-thumbnail');

  pdfThumbnails.forEach((thumbnail) => {
    const pdfUrl = thumbnail.dataset.url;
    fetch(pdfUrl)
      .then((response) => response.arrayBuffer())
      .then((data) => {
        const loadingTask = pdfjsLib.getDocument({ data });
        loadingTask.promise.then((pdf) => {
          pdf.getPage(1).then((page) => {
            const canvas = thumbnail;
            const context = canvas.getContext('2d');
            const viewport = page.getViewport({ scale: 0.3 }); // Adjust the scale as needed

            canvas.height = viewport.height;
            canvas.width = viewport.width;

            const renderContext = {
              canvasContext: context,
              viewport,
            };
            page.render(renderContext);
          });
        });
      });
  });
});

