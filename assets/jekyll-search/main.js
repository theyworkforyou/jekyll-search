jQuery(function($) {
  var $searchBoxes = $('[data-jekyll-search]');
  $searchBoxes.selectToAutocomplete();
  $searchBoxes.on('change', function(e) {
    var value = $(this).val();
    if (value) {
      window.location.href = value;
    }
  });
});
