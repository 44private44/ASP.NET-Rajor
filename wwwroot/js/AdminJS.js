// update the time in every second

function updateTime() {
    const now = new Date();
    const formattedTime = now.toLocaleString("en-US", { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric', hour: 'numeric', minute: 'numeric', hour12: false });
    $("#current-time").text(formattedTime);
}

updateTime(); // Call the function once to display the current time
setInterval(updateTime, 1000); // Call the function every second using setInterval

//--------------------------------------------------------------------------------------------------------------
// Partial view data for in Partial view
$(document).ready(function () {

    // default active menu at first time

        var UserActiveLink = $('.default-link');
        var url = UserActiveLink.attr('href');

        // Load the data for the default active link
        $.ajax({
            url: url,
            type: 'GET',
            success: function (data) {
                $('#partialViewContainer').html(data);
            },
            error: function () {
                alert("Something going wrong !");
            }
        });

    // when click on the tag or menu
    $('.admin-menu-link').click(function (e) {
        e.preventDefault();
        var url = $(this).attr('href');
        $('.main_admin_menus_divs a button').removeClass('active');

        $(this).find('button').addClass('active');

        $.ajax({
            url: url,
            type: 'GET',
            success: function (data) {
                $('#partialViewContainer').html(data);
            },
            error: function () {
                alert("Something going wrong !");
            }
        });
    });
});

