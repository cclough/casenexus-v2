# ClientSideValidations Initializer

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  unless html_tag =~ /^<label/
  	errorboom = 
		#%{<div class="field_with_errors">#{html_tag}<label for="#{instance.send(:tag_id)}" class="message">#{instance.error_message.first}</label></div>}.html_safe
    #%{<div class="">#{html_tag}<label for="#{instance.send(:tag_id)}" class="message application_error_message font-small">#{instance.error_message.first}</label></div>}.html_safe
  	%{<div class="message" data-content="hello!">#{html_tag}<label for="#{instance.send(:tag_id)}" class="message application_error_message font-small">#{instance.error_message.first}</label></div>}.html_safe
  	#%{<div class="">#{html_tag}<div class="message application_error_message font-small">#{instance.error_message.first}</div></div>}.html_safe
  else
    %{<div>#{html_tag}</div>}.html_safe
  end
end

# consider adding back field_with_errors class to both div tags above if you encounter problems

