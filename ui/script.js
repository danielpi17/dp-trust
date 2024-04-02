currentPageName = "mypersonals"

window.addEventListener("DOMContentLoaded", () => {
    $("#home").hide()
    $("#trustedpersonals").hide()
    $("#adminpanel").hide()
    $("#accesslist").hide()
    setMyVehicles(["spanw", "cod", "scott", "dan", "garrett"])
    setTrustedPersonals([["test", "2142595123129839", "MGR"],["test", "2142595123129839", "ADM"],["test", "2142595123129839", "USR"]])
    setAccessList([["djisadojd", "USR"], ["sjaidhasiduw", "MGR"], ["sodohrwghhoq", "ONR"]])

    document.getElementById("testbutton").addEventListener("click", () => {
        // $("#test").hide()
        fetch(`https://${GetParentResourceName()}/test`, {
            method: "POST",
            body: JSON.stringify({message: (document.getElementById("test").value)})
        }).then(resp => resp.json()).then(resp => console.log(JSON.stringify(resp)))
    })
})

function registerData(data) {

}
function homePage() {
    $(`#${currentPageName}`).hide()
    $("#home").show()
    currentPageName = "home"
}
function myPersonalsPage() {
    $(`#${currentPageName}`).hide()
    $("#mypersonals").show()
    currentPageName = "mypersonals"
}
function trustedPersonalsPage() {
    $(`#${currentPageName}`).hide()
    $("#trustedpersonals").show()
    currentPageName = "trustedpersonals"
}
function adminPanelPage() {
    $(`#${currentPageName}`).hide()
    $("#adminpanel").show()
    currentPageName = "adminpanel"
}
function accessListPage(spawncode) {
    $(`#${currentPageName}`).hide()
    $("#accesslist").show()
    currentPageName = "accesslist"
    document.getElementById("accesslist-spawncode").textContent = spawncode
}

function addByDiscordID() {
    console.log(document.getElementById("accesslist-spawncode").textContent)
    console.log(document.getElementById("accesslist-discordid").value)
}
function addByID() {
    console.log(document.getElementById("accesslist-spawncode").textContent)
    console.log(document.getElementById("accesslist-ingameid").value)
}
function deletePersonal(personal) {
    console.log(personal)
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
        } else {
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

function setRank(discordid, rank) {
    console.log("Set rank on vehicle " + document.getElementById("accesslist-spawncode").textContent + " Discord ID: " + discordid + " Rank: " + rank)
}

// setRank(discordid, rank) removeaccess(discordid)
// make it so that admins can use the panel to type in a vehicle name and edit the owner, view access list, delete personal, take owner
// admin panel can also type in the spawncode of a vehicle and a discord id to create a personal
// make a function that determines if you can use admin panel
// make functions refresh rest automatically
// rank of ADM on vehicle does not show up in the list