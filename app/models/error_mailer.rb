class ErrorMailer < ActionMailer::Base
  def snapshot(exception, trace, session, params, env)
    @headers["Content-Type"] = "text/plain"
    @recipients = 'penguincoder@gmail.com'
    @from = 'BarleySodas <error@barleysodas.com>'
    @subject = "[BarleySodas Exception: #{env['REQUEST_URI']}]"
    @sent_on = Time.now
    @body["exception"] = exception
    @body["trace"] = trace
    @body["session"] = session
    @body["params"] = params
    @body["env"] = env
  end
end