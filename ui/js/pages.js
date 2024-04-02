currentPageName = "mypersonals"

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
    if(adminAccess) {
        $(`#${currentPageName}`).hide()
        $("#adminpanel").show()
        currentPageName = "adminpanel"
    }
}
function accessListPage(spawncode) {
    $(`#${currentPageName}`).hide()
    $("#accesslist").show()
    currentPageName = "accesslist"
    document.getElementById("accesslist-spawncode").textContent = spawncode
}