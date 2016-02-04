describe("Jquery tests", function(){
  it("should add active class on click", function(){
    var element = $("#tester").find(".accordion-body")
    $('#tester').click()
    expect(element).toHaveClass("active");
  });
  it("should reveal element", function(){
    var element = $("#tester").find(".accordion-body")
    $('#tester').click()
    expect(element).toHaveCss({display: "block"});
  });
  it("should remove active class on additional click", function(){
    var element = $("#tester").find(".accordion-body")
    $('#tester').click()
    $('#tester').click()
    expect(element).not.toHaveClass("active");
  });
})