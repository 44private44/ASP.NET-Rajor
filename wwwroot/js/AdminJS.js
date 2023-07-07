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
                pSize: 8
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

// Searching Set 
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


//  Add Data partial view 
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

// Passsword validate

function validatePassword() {
    var password = $("#userAdminprofilepassword").val();
    if (password != "") {
        $("#userAdminprofilepasswordLabel").removeClass("validatefield");
        // 8 character validate
        if (password.length < 8) {
            $("#usernewpasswordAdminmatchAdmin").removeClass("matchpassworddiv");
            return false;
        }
        $("#usernewpasswordAdminmatchAdmin").addClass("matchpassworddiv");
        return false;
    }
    else {
        $("#userAdminprofilepasswordLabel").addClass("validatefield");
    }
}

// Password eye visible and disable

function PasswordVisible() {
    const passwordInput2 = document.getElementById("userAdminprofilepassword");
    const eyeIcon2 = document.getElementById("eyeIcon2");

    if (passwordInput2.type === "password") {
        passwordInput2.type = "text";
        eyeIcon2.classList.remove("fa-eye-slash");
        eyeIcon2.classList.add("fa-eye");
    } else {
        passwordInput2.type = "password";
        eyeIcon2.classList.remove("fa-eye");
        eyeIcon2.classList.add("fa-eye-slash");
    }
}


// get cities by country

function countrychange() {
    var countryId = $("#country-select5 option:selected").val();

    $.ajax({
        url: "/Admin/GetCitiesByCountry",
        type: "GET",
        data: { countryId: countryId },
        success: function (response) {
            var citySelect = $("#city-select5");
            citySelect.empty();
            var newOption = $('<option>', {
                value: '0',
                text: 'Select your city'
            });
            citySelect.append(newOption);
            $.each(response, function (i, city) {
                citySelect.append($('<option>', {
                    value: city.cityId,
                    text: city.cityName
                }));
            });
        },
        error: function (response) {
            console.log(response);
        }
    });
}

//ADD user Submit 

function UserAddSubmit() {
    // Serialize the form data
    var formData = $('.NewUserAddAdmindiv form').serialize();

    $.ajax({
        url: '/Admin/UserFormDataSubmitMethod',
        type: 'POST',
        data: formData,
        success: function (response) {
            console.log("sucess");
            $('.NewUserAddAdmindiv').empty();
            var searchText = '';
            var pageNo = 1;
            var pSize = 8;

            // Load the partial view
            $('.NewUserAddAdmindiv').load('/Admin/UserAdmin', function () {
                // Partial view loaded, now load the table data
                var tableUrl = '/Admin/UserAdminTableData?searchText=' + encodeURIComponent(searchText) + '&pageNo=' + pageNo + '&pSize=' + pSize;
                $("#userTableBody").load(tableUrl);
            });
        },
        error: function (xhr, textStatus, errorThrown) {
            console.log("Error");
            alert("Something going wrong");
        }
    });
}

// cancle 

function AdduserCanclebtn() {
    $('.NewUserAddAdmindiv').empty();
    var searchText = '';
    var pageNo = 1;
    var pSize = 8;

    // Load the partial view
    $('.NewUserAddAdmindiv').load('/Admin/UserAdmin', function () {
        // Partial view loaded, now load the table data
        var tableUrl = '/Admin/UserAdminTableData?searchText=' + encodeURIComponent(searchText) + '&pageNo=' + pageNo + '&pSize=' + pSize;
        $("#userTableBody").load(tableUrl);
    });
}

// edit icon
var gettinguserId;
function UserEditDataBtn(datavalue) {
    gettinguserId = datavalue.dataset.userid;

    $.ajax({
        url: '/Admin/UserEditData',
        type: 'GET',
        data: { userId: gettinguserId },
        success: function (data) {
            $('#userAdminMain').empty();
            $('#userAdminMain').html(data);
        },
        error: function () {
            // Handle the error case
            console.log('Error retrieving user data.');
        }
    });
}

// Edit user Submit data
function UserEditSubmit() {
    // Serialize the form data
    var formData = $('.edituseradmindata form').serialize();
    formData += '&userId=' + gettinguserId;
    $.ajax({
        url: '/Admin/UserFormEditData',
        type: 'POST',
        data: formData,
        success: function (response) {
            console.log("sucess");
            $('.edituseradmindata').empty();
            var searchText = '';
            var pageNo = 1;
            var pSize = 8;

            // Load the partial view
            $('.edituseradmindata').load('/Admin/UserAdmin', function () {
                // load the table data
                var tableUrl = '/Admin/UserAdminTableData?searchText=' + encodeURIComponent(searchText) + '&pageNo=' + pageNo + '&pSize=' + pSize;
                $("#userTableBody").load(tableUrl);
            });
        },
        error: function (xhr, textStatus, errorThrown) {
            console.log("Error");
            alert("Something going wrong");
        }
    });
}

// delete icon

var gettinguserIdforDelete;
function UserDeleteDataBtn(datavalue) {
    gettinguserIdforDelete = datavalue.dataset.userid;

    $.ajax({
        url: '/Admin/UserDeleteData',
        type: 'GET',
        data: { userId: gettinguserIdforDelete },
        success: function (data) {
            console.log('success');
            //$('#userAdminMain').empty();
            //$('#userAdminMain').html(data);
            $('#deletePartialContainer').css('display', 'block');
            $('#deletePartialContainer').html(data);
        },
        error: function () {
            // Handle the error case
            console.log('Error retrieving user data.');
        }
    });
}


// cancle delete

function deleteuserCanclebtn() {
    $('#deletePartialContainer').css('display', 'none');
}
// Confirm Delete

function UserDeleteConfirm() {
    $.ajax({
        url: '/Admin/UserDeleteConfirmData',
        type: 'GET',
        data: { userId: gettinguserIdforDelete },
        success: function (data) {
            $('#deletePartialContainer').css('display', 'none');
           $('#userAdminMain').empty();

            var searchText = '';
            var pageNo = 1;
            var pSize = 8;

            // Load the partial view
            $('#userAdminMain').load('/Admin/UserAdmin', function () {
                // load the table data
                var tableUrl = '/Admin/UserAdminTableData?searchText=' + encodeURIComponent(searchText) + '&pageNo=' + pageNo + '&pSize=' + pSize;
                $("#userTableBody").load(tableUrl);
            });
        },
        error: function () {
            // Handle the error case
            console.log('Error retrieving user data.');
        }
    });
}
