# HACK: delete header field to enable attachments to e-mails (don't ask why!)
TMail::HeaderField::FNAME_TO_CLASS.delete('content-id')
