import consumer from "./consumer"

$(document).on('turbolinks:load', function(){
  consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
    connected() {
      console.log('AnswersChannel connected');
    },

    disconnected() {
      console.log('AnswersChannel disconnected');
    },

    received(data) {
      this.appendLine(data)
    },

    appendLine(data) {
      const html = this.createLine(data)
      $('.other-answers').append(html)
    },

    createLine(data) {
      return `
      <li class="list-group-item" id="answer-${data.answer.id}">
        <div class="row mb-3">
          <div class="col-6 d-flex justify-content-start align-items-center">
            ${data.answer.body}
          </div>
        </div>
      </li>
        `
    }
  })
})
