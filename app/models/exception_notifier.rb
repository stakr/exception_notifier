require 'pathname'

class ExceptionNotifier < ActionMailer::Base
  
  # Delivers an exception notification.
  # 
  # Invoke:
  # 
  #   ExceptionNotifier.deliver_notification(from_email, recipients_email, request, klass, exception, user)
  # 
  def notification(from_email, recipients_email, request, klass, exception, user = nil)
    subject       "[ERROR] #{request.host_with_port} - #{exception.class}"
    from          from_email
    recipients    recipients_email
    content_type  "multipart/alternative"
    
    part "multipart/related" do |p|
      # HTML part
      p.part      :content_type => 'text/html', 
                  :body => render_message('notification.html.erb',
                                          :request    => request,
                                          :klass      => klass,
                                          :exception  => exception,
                                          :user       => user,
                                          :backtrace  => sanitize_backtrace(exception.backtrace))
      
      # Attach uploaded files
      append_attachment(p, request.parameters)
    end
    
  end
  
  private
  
  def append_attachment(p, params)
    @i = 0
    params.each do |key, value|
      case value
      when ActionController::UploadedFile
        p.part :content_type => value.content_type do |q|
                                    value.rewind
          q.body                  = value.read
          q.filename              = value.original_filename
          q.headers['Content-ID'] = "<attachment#{@i += 1}>"
          q.transfer_encoding     = 'base64'
          q.content_disposition   = 'attachment'
        end
      when Hash
        append_attachment(p, value)
      else
        # Do nothing for Strings etc.
      end
    end
  end
  
  def sanitize_backtrace(trace)
    re = Regexp.new(/^#{Regexp.escape(rails_root)}/)
    trace.map do |line| 
      Pathname.new(line.gsub(re, "[RAILS_ROOT]")).cleanpath.to_s 
    end
  end
  
  def rails_root
    @rails_root ||= Pathname.new(RAILS_ROOT).cleanpath.to_s
  end
  
end
