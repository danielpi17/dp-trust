adminAccess = false

function registerData(data) {
    setMyVehicles(data["myvehicles"]);
    setTrustedPersonals(data["trustedpersonals"])
    isAdmin(data["admin"])
}


function setMyVehicles(data) {
    for(let sc in data) {
        $('#mypersonals-vehicleList').append(`<div class="vehicle">
            <a><b>Spawncode: </b>${data[sc]}</a>
            <div class="buttonBox">
                <a class="button" onclick="accessListPage('${data[sc]}')"><b>Access List</b></a>
                <a class="button" onclick="deletePersonal('${data[sc]}')"><b>Delete Personal</b></a>
            </div>
        </div>`);
    }
}
function setTrustedPersonals(data) {
    for(let sc in data) {
        if(data[sc][2] === "MGR" || data[sc][2] == "ADM") {
            $('#trustedpersonals-vehicleList').append(`<div class="vehicle">
                <a><b>Spawncode: </b>${data[sc][0]}</a>
                <div class="buttonBox">
                    <a style="margin-bottom: 1vh;"><b>Owner: </b>${data[sc][1]} <b>${data[sc][2]}</b></a>
                    <a class="button" onclick="accessListPage('${data[sc][0]}')"><b>Access List</b></a>
                </div>
            </div>`)
        } else {
            $('#trustedpersonals-vehicleList').append(`<div class="vehicle">
                <a><b>Spawncode: </b>${data[sc][0]}</a>
                <div class="buttonBox">
                    <a style="margin-bottom: 1vh;"><b>Owner: </b>${data[sc][1]} <b>${data[sc][2]}</b></a>
                    <a class="button" style="cursor: default"><b>Access List (You must be MGR)</b></a>
                </div>
            </div>`)
        }
    }
}
function setAccessList(data) {
    for(let sc in data) {
        if(data[sc][1] === "ONR") {
            $('#accesslist-vehicleList').append(`<div class="vehicle">
                <b>Discord: </b><a>${data[sc][0]}</a>
                <b>ONR</b>
                <div class="buttonBox">
                    <a class="button" style="cursor: default"><b>Cannot Demote ONR</b></a>
                    <a class="button" style="cursor: default"><b>Cannot Remove ONR</b></a>
                </div>
            </div>`)
        } else if(data[sc][1] === "MGR") {
            $('#accesslist-vehicleList').append(`<div class="vehicle">
                <b>Discord: </b><a>${data[sc][0]}</a>
                <b>MGR</b>
                <div class="buttonBox">
                    <a class="button" onclick="setRank('${data[sc][0]}', 'USR')"><b>Demote to USR</b></a>
                    <a class="button" onclick="removeAccess('${data[sc][0]}')"><b>Remove Access</b></a>
                </div>
            </div>`)
        } else if(data[sc][1] === "USR") {
            $('#accesslist-vehicleList').append(`<div class="vehicle">
                <b>Discord: </b><a>${data[sc][0]}</a>
                <b>${data[sc][1]}</b>
                <div class="buttonBox">
                    <a class="button" onclick="setRank('${data[sc][0]}', 'MGR')"><b>Promote to MGR</b></a>
                    <a class="button" onclick="removeAccess('${data[sc][0]}')"><b>Remove Access</b></a>
                </div>
            </div>`)
        }
    }
}


function isAdmin(value) {
    // all html for admin panel should be under value in an append
    adminAccess = value
    if(value) {
        $("#sidebar").append(`<a onclick="adminPanelPage()"><b>Admin Panel</b></a>`)
        $("#sidebar-1").append(`<a onclick="adminPanelPage()"><b>Admin Panel</b></a>`)
        $("#sidebar-2").append(`<a onclick="adminPanelPage()"><b>Admin Panel</b></a>`)
        $("#sidebar-3").append(`<a onclick="adminPanelPage()" class="active"><b>Admin Panel</b></a>`)
        $("#sidebar-4").append(`<a onclick="adminPanelPage()"><b>Admin Panel</b></a>`)
    }
}

// make it so that admins can use the panel to type in a vehicle name and edit the owner, view access list, delete personal, take owner
// admin panel can also type in the spawncode of a vehicle and a discord id to create a personal
// make functions refresh rest automatically