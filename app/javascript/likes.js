$(document).on('turbolinks:load', function(){
  $('.question-body, .answers').on('ajax:success', function(e){
    var vote = e.detail[0]

    if(vote['resource'] === 'question') {
      var resource = $('.question-likes-' + vote.id)
    }
    else {
      var resource = $('.answer-likes-' + vote.id)
    }

    resource.find('.final_rating').html(vote['final_rating'])

    switch (vote['liked']) {
      case true:
        resource.find('.like').addClass('btn-secondary')
        break
      case false:
        resource.find('.like').removeClass('btn-secondary')
      default:
        resource.find('.like').addClass('disabled')
    }

    switch (vote['disliked']) {
      case true:
        resource.find('.dislike').addClass('btn-secondary')
        break
      case false:
        resource.find('.dislike').removeClass('btn-secondary')
      default:
        resource.find('.dislike').addClass('disabled')
    }
  })
    .on('ajax:error', function(e){
      var errors = e.detail[0]
      var resource = errors.resource

      $.each(errors, function(index, value) {
        $('.' + resource + '-errors').append('<p>' + value + '</p>');
    })
    })
})
