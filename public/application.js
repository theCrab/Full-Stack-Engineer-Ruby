$(document).ready(function () {

  // Hide the heart and title of the comic
  $('figure a').hide()
  $('figure figcaption').hide()

  // Show on hover
  $('figure').hover( function (e) {
    $(this).children('a, figcaption').toggle(e.type === 'mouseenter')

    if ($(this).hasClass('favourites')) {
      var faved = $(this).children('a')
      faved.attr('href', faved.attr('href').replace('upvote', 'downvote'))

      faved.show()
    }
  })

  // Search the comic character
  $('form#search').on('submit', function (e) {
    e.preventDefault();
    $.ajax({
      url: "/search",
      type: "post",
      dataType: 'json',
      data: { "q": $('#q').val() }
    })
    .done(function (msg) {
      console.log(msg)
    })
  })

  // Favourite/Upvote a comic
  $('figure a').click(function (e) {
    e.preventDefault()

    $.post({
      url: $(this).attr('href'),
      type: 'post',
      dataType: 'json',
      data: { id: $(this).attr('data-comic-id') }
    })
    .done(function (dd) {
      getFavourites()
      removeFavourites($(this).attr('data-comic-id'))
    })
  })

  // Delete/Downvote a comic
  $($(this).attr('id')+' a').click(function (e) {
    e.preventDefault()

    // if ($(this).attr('href').endsWith('downvote')) {

      $.ajax({
        url: $(this).attr('href'),
        type: 'DELETE',
        dataType: 'json',
        data: { id: $(this).attr('data-comic-id') }, // Uncomment for 'POST'
        error: function (_res, _status, _jxhr) {
          if (_status === 410) { // is this how to match?
            removeFavourites($(this).attr('data-comic-id'))
            alert('from success')
          }
        },
        statusCode: {
          410: function () {
            removeFavourites($(this).attr('data-comic-id'))
            alert('statusCode')
          }
        }
      }).always(function (jqXHR, textStatus, errorThrown) {
        removeFavourites($(this).attr('data-comic-id'))
        alert(textStatus + ' error::::> ' + errorThrown)
        // getFavourites()
      })
      // .done(function (jqXHR, textStatus, errorThrown) {
      //   removeFavourites($(this).attr('data-comic-id'))
      //   alert('done')
      //   // getFavourites()
      // })
      // .fail(function (jqXHR, textStatus, errorThrown) {
      //   alert('failed')
      //   removeFavourites($(this).attr('data-comic-id'))
      //   // getFavourites()
      // })
    // }
  })

  // PAGINATION, continous page load instead of page skips
  $('#next-page').click(function (e) {
    e.preventDefault()

    $.get({
      url: $(this).attr('href'),
      dataType: 'json',
      data: { page: $(this).attr('data-pagenumber') }
    })
    .done(function (result) {
      // Append to current page
      // $.each(result)
    })
  })

  // Show favourite comics
  getFavourites()
})

// Return an array of comic_id's
// and apply the .favourites style
function getFavourites() {
  $.get({
    url: '/favourites',
    dataType: 'json'
  })
  .done(function (data) {
    for (var i = 0; i < data.length; i++) {
      $('#'+data[i]+', #'+data[i]+' a').addClass('favourites')
      $('#'+data[i]+' a img').attr('src', '/heart_on.png')
      $('#'+data[i]+' a').show()
    }
  })
}

function removeFavourites(el) {
  $(el).removeClass('favourites')
  $(el).children('img').attr('src', '/heart_off.png')
}
