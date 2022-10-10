$(document).on('turbolinks:load', function(){
  $('.like', '.dislike').on('ajax:success', function(e){
    var vote = e.detail[0]

    if(vote.resource == 'question') {
      var resource = $('.question-likes')
    }

    resource.find('.final_rating').html(vote.final_rating)
  })
})
