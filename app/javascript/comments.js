$(document).on('turbolinks:load', function(){
  $('.question-comments').on('ajax:success', function(e) {
    var comment = e.detail[0]
  })
})
