$(function () {
    window.addEventListener('message', function (e) {
        if (e.data.display == true) {
            $('#ui').fadeIn();
            $('input#firstname').val(e.data.firstname);
            $('input#lastname').val(e.data.lastname);
        } else if (e.data.display == false) {
            CloseDisplay();
        };
    });

    $('.button').on('click', function() {
        let firstname = $('input#firstname').val();
        let lastname = $('input#lastname').val();
        $.post('https://doughNamechanger/ChangeName', JSON.stringify({
            firstname: firstname,
            lastname: lastname
        }));
        CloseDisplay();
    });

    $(document).keydown(function(e) {
        if (e.keyCode == 27) {
          CloseDisplay();
        }
    });
});

function CloseDisplay() {
    $('#ui').fadeOut();
    $.post('https://doughNamechanger/CloseDisplay', JSON.stringify({}));
}