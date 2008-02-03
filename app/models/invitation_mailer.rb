class InvitationMailer < ActionMailer::Base
  def invitation(invitation, recipient)
    @headers["Content-Type"] = "text/plain"
    @recipients = recipient
    @from = 'BarleySodas <no-reply@barleysodas.com>'
    @subject = "You've been invited to BarleySodas!"
    @body["invitation"] = invitation
    @body["people_title"] = invitation.people.title
  end
end