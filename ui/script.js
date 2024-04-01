currentPageName = "mypersonals"

window.addEventListener("DOMContentLoaded", () => {
    $("#home").hide()
    $("#trustedpersonals").hide()
    $("#adminpanel").hide()
    document.getElementById("testbutton").addEventListener("click", () => {
        // $("#test").hide()
        fetch(`https://${GetParentResourceName()}/test`, {
            method: "POST",
            body: JSON.stringify({message: (document.getElementById("test").value)})
        }).then(resp => resp.json()).then(resp => console.log(JSON.stringify(resp)))
    })
})


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