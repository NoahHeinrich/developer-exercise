$(function(){

  var event_bus = _({}).extend(Backbone.Events);

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
    },


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
      this.listenTo(event_bus, 'renderFirstPage', this.render);
      this.listenTo(event_bus, 'renderNextPage', this.render);
      this.listenTo(event_bus, 'renderLastPage', this.render);
      this.listenTo(event_bus, 'renderFinalPage', this.render);
      this.listenTo(event_bus, 'renderPage', this.render);
    },

    render: function (collection) {
      var page = collection;
      this.$el.html(this.template({ quotes: page.models }));
      return this;
    },
    handleSuccess: function () {
      this.render(this.collection);
    },

    handleError: function () {
      alert("Something went wrong")
    }


  })

  var PaginatorView = Backbone.View.extend({
    // el: ".pages",
    template: _.template("<a id='first' href=#> << </a> "
                        + " <a id='back' href=#> < </a>"
                        + " <% for (i=1; i <= this.totalPages; i++) { %>"
                        + " <a class='numPage' href='#'> <%= i %> </a> "
                        + "<% } %>"
                        + " <a id='forward' href=#> > </a>"
                        + " <a id= 'last' href=#> >> </a>"),

    events: {
      "click #first"  :  "goToFirst",
      "click #back"  :  "goBack",
      "click #forward"  :  "goForward",
      "click #last"  :  "goToLast",
      "click .numPage" : "goToPage"
    },


    initialize: function () {
      this.listenTo(this.collection, 'successOnFetch', this.handleSuccess);
      this.listenTo(this.collection, 'errorOnFetch', this.handleError);
    },

    render: function () {

      this.$el.html(this.template());
      return this;
    },

    handleSuccess: function () {
      this.totalPages = Math.ceil(this.collection.fullCollection.length / 15)
      this.render();
    },

    handleError: function () {
      alert("Something went wrong")
    },

    goToFirst: function (e) {
      e.preventDefault();
      event_bus.trigger("renderFirstPage", this.collection.getFirstPage())
    },

    goBack: function (e) {
      e.preventDefault();
      if(this.collection.hasPreviousPage()){
        event_bus.trigger("renderLastPage", this.collection.getPreviousPage())
      }
    },

    goForward: function (e) {
      e.preventDefault();
      if(this.collection.hasNextPage()){
        event_bus.trigger("renderNextPage", this.collection.getNextPage());
      }
    },

    goToLast: function (e) {
      e.preventDefault();
      event_bus.trigger("renderFinalPage", this.collection.getLastPage())
    },

    goToPage: function (e) {
      e.preventDefault();
      var pageNum = parseInt($(e.currentTarget).text())

      event_bus.trigger("renderPage", this.collection.getPage(pageNum))
    }
  })

  var quotes = new QuoteList([], { mode: "client" });
  var quoteView = new QuoteView({ collection: quotes, el:$("ul") });
  var pagesView = new PaginatorView({ collection: quotes, el:$(".pages") });
  quotes.getResults();
});

