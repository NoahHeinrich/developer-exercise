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
      currentPage: 1
    },

  });

  var quotes = new QuoteList();
  quotes.fetch().done(function() {
    console.log(quotes.models);
  });

});