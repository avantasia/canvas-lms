require [
  'INST'
  'i18n!assignment'
  'jquery'
  'compiled/models/Assignment',
  'compiled/views/PublishButtonView',
  'jquery.instructure_forms'
], (INST, I18n, $, Assignment, PublishButtonView) ->

  $ ->
    $el = $('#assignment_publish_button')
    if $el.length > 0
      model = new Assignment
        id: $el.attr('data-id')
        publishable: true
        published: $el.hasClass('published')
      model.doNotParse()

      new PublishButtonView(model: model, el: $el).render()

  # -- This is all for the _grade_assignment sidebar partial
  $ ->
    $(".upload_submissions_link").click (event) ->
      event.preventDefault()
      $("#re_upload_submissions_form").slideToggle()

    $(".download_submissions_link").click (event) ->
      event.preventDefault()
      INST.downloadSubmissions($(this).attr('href'))
      $(".upload_submissions_link").slideDown()

    $("#re_upload_submissions_form").submit (event) ->
      data = $(this).getFormData()
      if !data.submissions_zip
        event.preventDefault()
        event.stopPropagation()
      else if !data.submissions_zip.match(/\.zip$/)
        event.preventDefault()
        event.stopPropagation()
        $(this).formErrors
          submissions_zip: I18n.t('errors.upload_as_zip', "Please upload files as a .zip")

    $("#edit_assignment_form").bind 'assignment_updated', (event, data) ->
      if data.assignment && data.assignment.peer_reviews
        $(".assignment_peer_reviews_link").slideDown()
      else
        $(".assignment_peer_reviews_link").slideUp()
