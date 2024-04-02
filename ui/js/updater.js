// all of these functions will go to client and server on lua

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
function setRank(discordid, rank) {
    console.log("Set rank on vehicle " + document.getElementById("accesslist-spawncode").textContent + " Discord ID: " + discordid + " Rank: " + rank)
}
function removeAccess(discordid) {
    console.log("Remove access on vehicle " + document.getElementById("accesslist-spawncode").textContent + " Discord ID: " + discordid)
}