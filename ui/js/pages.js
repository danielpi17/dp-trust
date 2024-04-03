currentPageName = "mypersonals"

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
    if(adminAccess) {
        document.getElementById("adminpanel-createvehiclediscord").value = ""
        document.getElementById("adminpanel-createvehiclespawncode").value = ""
        document.getElementById("adminpanel-setpersonalownerdiscord").value = ""
        document.getElementById("adminpanel-setpersonalownerspawncode").value = ""
        document.getElementById("adminpanel-deletepersonalspawncode").value = ""
        document.getElementById("adminpanel-viewaccesslistspawncode").value = ""
        document.getElementById("adminpanel-gainadminaccessspawncode").value = ""
        document.getElementById("adminpanel-loseadminaccessspawncode").value = ""
        $(`#${currentPageName}`).hide()
        $("#adminpanel").show()
        currentPageName = "adminpanel"
    }
}
function accessListPage(spawncode) {
    axios.post(`https://${GetParentResourceName()}/accesslist`, {spawncode:spawncode}).then(result => {
        setAccessList(result["data"])
        document.getElementById("accesslist-spawncode").textContent = spawncode
    })
    $(`#${currentPageName}`).hide()
    $("#accesslist").show()
    currentPageName = "accesslist"
}