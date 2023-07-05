// update the time in every second

function updateTime() {
    const now = new Date();
    const formattedTime = now.toLocaleString("en-US", { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric', hour: 'numeric', minute: 'numeric', hour12: false });
    $("#current-time").text(formattedTime);
}

updateTime(); // Call the function once to display the current time
setInterval(updateTime, 1000); // Call the function every second using setInterval


//------------------------------search-------------------------------------------


//--------------------------------------------------------------------------------------------------------------
// Partial view data for in Partial view
$(document).ready(function () {

    // default active menu at first time

    var UserActiveLink = $('.default-link');
    var url = UserActiveLink.attr('href');
    var suburl = $('.active').attr('data');
    // Load the data for the default active link
    $.ajax({
        url: url,
        type: 'GET',
        success: function (data) {
            $('#partialViewContainer').html(data);
            loadPartialView(suburl);
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
        var suburl = $('.active').attr('data');

        $.ajax({
            url: url,
            type: 'GET',
            success: function (data) {
                $('#partialViewContainer').html(data);
                loadPartialView(suburl);
            },
            error: function () {
                alert("Something going wrong !");
            }
        });
    });

    // Function to load the partial view and its sub-partial view using AJAX
    function loadPartialView(suburl) {
        $.ajax({
            url: suburl,
            data: {
                searchText: '',
                pageNo: 1,
                pSize : 8
            },
            type: 'GET',
            success: function (data) {
                $('#userTableBody').html(data);
            },
            error: function () {
                alert("Something went wrong!");
            }
        });
    }
});

//----------------------------------------------------------------------------------------
//  Add Data partial view 

function handleSearch(event, suburlAboutData) {
    var searchingText = event.target.value;
    var suburl = suburlAboutData;
    $.ajax({
        url: suburl,
        data: {
            searchText: searchingText,
            pageNo: 1,
            pSize: 8
        },
        type: 'GET',
        success: function (data) {
            $('#userTableBody').empty();
            $('#userTableBody').html(data);
        },
        error: function () {
            alert("Something went wrong!");
        }
    });
}
function addnewuseradminadd(url) {

    $.ajax({
        url: url,
        type: 'GET',
        success: function (data) {
            $('#userAdminMain').empty();
            $('#userAdminMain').html(data);
        },
        error: function () {
            alert("Something going wrong !");
        }
    });
}

