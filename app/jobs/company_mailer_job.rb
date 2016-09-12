class CompanyMailerJob < ActiveJob::Base
  queue_as :default

  def perform(evt_type, company, company_person, options = { reason:nil, application: nil,
    resume_id: nil})
    case evt_type
      when Event::EVT_TYPE[:COMP_REGISTER]
        CompanyMailer.pending_approval(company, company_person).deliver_later
      when Event::EVT_TYPE[:COMP_APPROVED]
        CompanyMailer.registration_approved(company, company_person).deliver_later
      when Event::EVT_TYPE[:COMP_DENIED]
        CompanyMailer.registration_denied(company, company_person, options[:reason]).deliver_later
      when Event::EVT_TYPE[:JS_APPLY]
        temp_file = ResumeCruncher.download_resume(options[:resume_id])

        CompanyMailer.application_received(company, options[:application], temp_file.path).deliver_later
    end
  end
  
  def after(job)
    puts "in after hook"
    temp_file.unlink if File.exist? temp_file
    puts "Just deleted the tempfile"
  end

end
