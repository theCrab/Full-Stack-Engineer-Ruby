$(document).ready(function () {
  // Hide the heart and title of the comic
  $('figure a').hide()
  $('figure figcaption').hide()

  // Show each on hover
  $('figure').hover( function (e) {
    $(this).children('a, figcaption').toggle(e.type === 'mouseenter')
  })

  // Search the comic character
  $('form#search').on('submit', function (e) {
    e.preventDefault();
    $.ajax({
      url: "/",
      type: "post",
      data: { "q": $('q').text() },
      complete: function (msg) {
        console.log(msg)
      }
    })
  });

  $('figure a').click(function (e) {
    e.preventDefault();
    $.ajax({
      url: $(this).attr('href'),
      type: 'post',
      data: { comic_id: $(this).attr('data-comicId') },
      complete: function () {
        alert('all was good')
      }
    })
  })
})
