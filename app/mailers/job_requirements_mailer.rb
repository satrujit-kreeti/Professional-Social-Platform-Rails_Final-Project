class JobRequirementsMailer < ApplicationMailer
    def apply_job(user_email, user_name, applicant_name,applicant_email ,cv_file)
        attachments['cv.pdf'] = { mime_type: 'application/pdf', content: cv_file.read }

        @user_creating_name = user_name
        @applicant_name = applicant_name
        @applicant_email = applicant_email
  
        mail(to: user_email, subject: 'Job Application')
    end
  end
  