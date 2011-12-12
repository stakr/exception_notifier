# Exception Notifier

Written by stakr GbR (Jan Sebastian Siwy, Martin Spickermann, Henning Staib GbR; http://www.stakr.de/)

Source: https://github.com/stakr/exception_notifier

A small plugin which sends email notifications about exceptions.

Requires Rails >= 2.3


## Integration

Just add the following code fragment into your `application_controller.rb`

    # Catches uncaught exceptions in public and send a notification email...
    def rescue_action_in_public(exception)
      case exception
      when ActionController::RoutingError, ActiveRecord::RecordNotFound
        render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
      else
        ExceptionNotifier.deliver_notification( from_email,
                                                recipients_email,
                                                controller,
                                                exception,
                                                user )
        render :file => "#{RAILS_ROOT}/public/500.html", :status => 500
      end
    end


## Example

    ExceptionNotifier.deliver_notification( 'exceptions@domain.tld',
                                            'development team <dev@domain.tld>, <bug-tracker@domain.tld>',
                                            self,
                                            exception,
                                            @current_user )

Remember that you need a well configurated `ActionMailer`, e.g.

    ActionMailer::Base.smtp_settings = {
      :address        => "domain.tld",
      :port           => 25,
      :domain         => "domain.tld",
      :authentication => :login,
      :user_name      => "login",
      :password       => "secret"
    }


Copyright (c) 2009 stakr GbR (Jan Sebastian Siwy, Martin Spickermann, Henning Staib GbR), released under the MIT license
