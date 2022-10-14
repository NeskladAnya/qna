import consumer from "./consumer"

consumer.subscriptions.create({ channel: "QuestionsChannel"}, {
  connected() {
    console.log('QuestionsChannel connected')
    this.perform('follow')
  },

  received(data) {
    document.querySelector('.table')
      .insertAdjacentHTML('beforeend', data)
  }
})
