class InvitationsController < ApplicationController
  append_before_filter :ensure_xhr, :only => [ :create, :send ]
  
  # GET /invitations
  # GET /invitations.xml
  def index
    @invitations = Invitation.find(:all, :include => [ 'people' ],
      :order => 'peoples.title ASC')
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @invitations.to_xml }
    end
  end
  
  # POST /invitations
  def create
    @invitation = Invitation.new
    @invitation.people_id = params[:people_id].to_i if params[:people_id]
    @people = @invitation.people
    if @invitation.save
      render :partial => 'invitations/invitations'
    else
      render :inline => "<%= error_messages_for('invitation') -%>",
        :status => 500
    end
  end
  
  # DELETE /invitations/1
  # DELETE /invitations/1.xml
  def destroy
    @invitation = Invitation.find(params[:id])
    @invitation.destroy
    respond_to do |format|
      format.html { redirect_to invitations_url }
      format.xml  { head :ok }
    end
  end
  
  def send_invitation
    @invitation = Invitation.find(:first, :include => [ 'people' ],
      :conditions => [ "people_id = ?", session[:people_id] ])
    @invitation ||= Invitation.new :people_id => session[:people_id]
    @people = @invitation.people
    recipient = params[:email].to_s
    begin
      if @invitation.new_record?
        @invitation.errors.add(:you, "have no invitations")
      end
      if recipient.to_s.empty?
        @invitation.errors.add(:recipient, "is missing")
      end
      raise "Misconfigured invitation!" unless @invitation.errors.empty?
      InvitationMailer.deliver_invitation(@invitation, recipient)
    rescue
      logger.info("Failed to deliver invitation: #{$!}")
      render :inline => "<%= error_messages_for('invitation') -%>",
        :status => 500
      return
    end
    @invitation.toggle! :sent
    render :partial => 'invitations/invitations'
  end
end
