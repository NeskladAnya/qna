import consumer from "./consumer"

$(document).on('turbolinks:load', function(){
  consumer.subscriptions.create({ channel: "CommentsChannel", question_id: gon.question_id }, {
    connected() {
      console.log('CommentsChannel connected');
    },

    disconnected() {
      console.log('CommentsChannel disconnected');
    },

    received(data) {
      $('.question-comments').append('<p>' + data.data.body + '</p>')
    }
    
  })
})
