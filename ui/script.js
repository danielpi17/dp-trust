currentPageName = "mypersonals"

window.addEventListener("DOMContentLoaded", () => {
    $("#home").hide()
    $("#trustedpersonals").hide()
    $("#adminpanel").hide()
    $("#accesslist").hide()
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