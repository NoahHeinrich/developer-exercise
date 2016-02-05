$(function(){

  var Quote = Backbone.Model.extend({
    defaults: function () {
      return {
        quote: "Everything's under control, situation normal.",
        source: "Han Solo",
        context: "Star Wars",
        theme: "movies"
      };
    },
  })

  var QuoteList = Backbone.PageableCollection.extend({
    model: Quote,
    url: "https://gist.githubusercontent.com/anonymous/8f61a8733ed7fa41c4ea/raw/1e90fd2741bb6310582e3822f59927eb535f6c73/quotes.json",

    state: {
      firstPage: 1,
      currentPage: 1,
      pageSize: 15
    },

    getResults: function () {
      var self = this;
      this.fetch({
        reset: true,
        success: function (collection, response, options) {
            self.trigger('successOnFetch');
          },
          error: function (collection, response, options) {
            self.trigger('errorOnFetch');
          }
      });
    }

  });

  var QuoteView = Backbone.View.extend({
    el:"ul",
    template: _.template("<%_.forEach(quotes, function (quote) {%>"
                        + "<li>'<%= quote.attributes.quote %>'</li>"
                        + "<p>-<%= quote.attributes.source %>, <%= quote.attributes.context %><p>"
                        + "<% }) %>"),
    initialize: function () {
      this.listenTo(this.collection, 'successOnFetch', this.handleSuccess);
      this.listenTo(this.collection, 'errorOnFetch', this.handleError);
    },

    render: function () {
      var page = this.collection.getFirstPage();
      console.log(page)
      this.$el.html(this.template({ quotes: page.models }));
      return this;
    },
    handleSuccess: function () {
      this.render();
    },

    handleError: function () {
      alert("Something went wrong")
    },


  })

  var quotes = new QuoteList([], { mode: "client" });
  var quoteView = new QuoteView({ collection: quotes });
  quotes.getResults();
});