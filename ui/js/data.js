adminAccess = false

function registerData() {
    axios.post(`https://${GetParentResourceName()}/loaddata`, {}).then(result => {
        setMyVehicles(result["data"]["myvehicles"]);
        setTrustedPersonals(result["data"]["trustedpersonals"])
        isAdmin(result["data"]["admin"])
    })
}

function setMyVehicles(data) {
    $("#mypersonals-vehicleList").html("")
    for(let sc in data) {
        $("#mypersonals-vehicleList").append(`<div class="vehicle">
            <a><b>Spawncode: </b>${data[sc]}</a>
            <div class="buttonBox">
                <a class="button" onclick="accessListPage('${data[sc]}')"><b>Access List</b></a>
                <a class="button" onclick="deletePersonal('${data[sc]}')"><b>Delete Personal</b></a>
            </div>
        </div>`);
    }
}
function setTrustedPersonals(data) {
    $("#trustedpersonals-vehicleList").html("")
    for(let sc in data) {
        if(data[sc][2] === "MGR" || data[sc][2] == "ADM") {
            $("#trustedpersonals-vehicleList").append(`<div class="vehicle">
                <a><b>Spawncode: </b>${data[sc][0]}</a>
                <div class="buttonBox">
                    <a style="margin-bottom: 1vh;"><b>Owner: </b>${data[sc][1]} <b>${data[sc][2]}</b></a>
                    <a class="button" onclick="accessListPage('${data[sc][0]}')"><b>Access List</b></a>
                </div>
            </div>`)
        } else {
            $("#trustedpersonals-vehicleList").append(`<div class="vehicle">
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
    $("#accesslist-vehicleList").html(`<div class="vehicle">
        <b>Spawncode: </b><a id="accesslist-spawncode"></a>
        <div class="buttonBox" style="grid-template-columns: auto 3vh;">
            <input style="background-color: #333;" type="text" id="accesslist-discordid" placeholder="Discord ID">
            <a class="button" onclick="addByDiscordID()"><b>+</b></a>
            <input style="background-color: #333;" type="text" id="accesslist-ingameid" placeholder="In Game ID">
            <a class="button" onclick="addByID()"><b>+</b></a>
        </div>
    </div>`)
    for(let sc in data) {
        if(data[sc][1] === "ONR") {
            $("#accesslist-vehicleList").append(`<div class="vehicle">
                <b>Discord: </b><a>${data[sc][0]}</a>
                <b>ONR</b>
                <div class="buttonBox">
                    <a class="button" style="cursor: default"><b>Cannot Demote ONR</b></a>
                    <a class="button" style="cursor: default"><b>Cannot Remove ONR</b></a>
                </div>
            </div>`)
        } else if(data[sc][1] === "MGR") {
            $("#accesslist-vehicleList").append(`<div class="vehicle">
                <b>Discord: </b><a>${data[sc][0]}</a>
                <b>MGR</b>
                <div class="buttonBox">
                    <a class="button" onclick="setRank('${data[sc][0]}', 'USR')"><b>Demote to USR</b></a>
                    <a class="button" onclick="removeAccess('${data[sc][0]}')"><b>Remove Access</b></a>
                </div>
            </div>`)
        } else if(data[sc][1] === "USR") {
            $("#accesslist-vehicleList").append(`<div class="vehicle">
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
    adminAccess = value
    if(value) {
        $("#sidebar-1").html(`<a onclick="adminPanelPage()"><b>Admin Panel</b></a>`)
        $("#sidebar-2").html(`<a onclick="adminPanelPage()"><b>Admin Panel</b></a>`)
        $("#sidebar-3").html(`<a onclick="adminPanelPage()" class="active"><b>Admin Panel</b></a>`)
        $("#sidebar-4").html(`<a onclick="adminPanelPage()"><b>Admin Panel</b></a>`)
        $("#adminpanel-vehicleList").html(`<div class="vehicle">
            <b>Create Personal Vehicle</b>
            <input style="background-color: #333; margin-top: 1vh; width: 75%;" type="text" id="adminpanel-createvehiclediscord" placeholder="Discord ID">
            <div class="buttonBox" style="grid-template-columns: auto 3vh;">
                <input style="background-color: #333;" type="text" id="adminpanel-createvehiclespawncode" placeholder="Spawncode">
                <a class="button" onclick="adminCreatePersonalVehicle()"><b>+</b></a>
            </div>
        </div>
        <div class="vehicle">
            <b>Set Personal Owner</b>
            <input style="background-color: #333; margin-top: 1vh; width: 75%;" type="text" id="adminpanel-setpersonalownerdiscord" placeholder="Discord ID">
            <div class="buttonBox" style="grid-template-columns: auto 3vh;">
                <input style="background-color: #333;" type="text" id="adminpanel-setpersonalownerspawncode" placeholder="Spawncode">
                <a class="button" onclick="adminSetPersonalOwner()"><b>SET</b></a>
            </div>
        </div>
        <div class="vehicle">
            <b>Delete Personal</b>
            <div class="buttonBox">
                <input style="background-color: #333;" type="text" id="adminpanel-deletepersonalspawncode" placeholder="Spawncode">
                <a class="button" onclick="adminDeletePersonal()"><b>Delete Personal</b></a>
            </div>
        </div>
        <div class="vehicle">
            <b>View Access List</b>
            <div class="buttonBox">
                <input style="background-color: #333;" type="text" id="adminpanel-viewaccesslistspawncode" placeholder="Spawncode">
                <a class="button" onclick="adminViewAccessList()"><b>View Access List</b></a>
            </div>
        </div>
        <div class="vehicle">
            <b>Gain Admin Access</b>
            <div class="buttonBox">
                <input style="background-color: #333;" type="text" id="adminpanel-gainadminaccessspawncode" placeholder="Spawncode">
                <a class="button" onclick="adminGainAdminAccess()"><b>Gain Admin Access</b></a>
            </div>
        </div>
        <div class="vehicle">
            <b>Lose Admin Access</b>
            <div class="buttonBox">
                <input style="background-color: #333;" type="text" id="adminpanel-loseadminaccessspawncode" placeholder="Spawncode">
                <a class="button" onclick="adminLoseAdminAccess()"><b>Lose Admin Access</b></a>
            </div>
        </div>`)
    }
}