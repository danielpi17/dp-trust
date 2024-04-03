// all of these functions will go to client and server on lua

function addByDiscordID() {
    spawncode = document.getElementById("accesslist-spawncode").textContent
    discordElement = document.getElementById("accesslist-discordid")
    discord = discordElement.value
    discordElement.value = ""
    axios.post(`https://${GetParentResourceName()}/addbydiscordid`, {spawncode:spawncode, discordid:discord}).then(result => {
        accessListPage(spawncode)
    })
}
function addByID() {
    spawncode = document.getElementById("accesslist-spawncode").textContent
    ingameidElement = document.getElementById("accesslist-ingameid")
    ingameid = ingameidElement.value
    ingameidElement.value = ""
    axios.post(`https://${GetParentResourceName()}/addbyid`, {spawncode:spawncode, id:ingameid}).then(result => {
        accessListPage(spawncode)
    })
}
function deletePersonal(personal) {
    axios.post(`https://${GetParentResourceName()}/deletepersonal`, {spawncode:personal}).then(result => {
        registerData()
    })
}
function setRank(discordid, rank) {
    spawncode = document.getElementById("accesslist-spawncode").textContent
    axios.post(`https://${GetParentResourceName()}/setrank`, {spawncode:spawncode, discordid:discordid, rank:rank}).then(result => {
        accessListPage(spawncode)
    })
}
function removeAccess(discordid) {
    spawncode = document.getElementById("accesslist-spawncode").textContent
    axios.post(`https://${GetParentResourceName()}/removeaccess`, {spawncode:spawncode, discordid:discordid}).then(result => {
        accessListPage(spawncode)
    })
}
function adminCreatePersonalVehicle() {
    discordElement = document.getElementById("adminpanel-createvehiclediscord")
    spawncodeElement = document.getElementById("adminpanel-createvehiclespawncode")
    discord = discordElement.value
    spawncode = spawncodeElement.value
    discordElement.value = ""
    spawncodeElement.value = ""
    axios.post(`https://${GetParentResourceName()}/createpersonalvehicle`, {spawncode:spawncode, discordid:discord}).then(result => {})
}
function adminSetPersonalOwner() {
    discordElement = document.getElementById("adminpanel-setpersonalownerdiscord")
    spawncodeElement = document.getElementById("adminpanel-setpersonalownerspawncode")
    discord = discordElement.value
    spawncode = spawncodeElement.value
    discordElement.value = ""
    spawncodeElement.value = ""
    axios.post(`https://${GetParentResourceName()}/setpersonalowner`, {spawncode:spawncode, discordid:discord}).then(result => {})
}
function adminDeletePersonal() {
    spawncodeElement = document.getElementById("adminpanel-deletepersonalspawncode")
    spawncode = spawncodeElement.value
    spawncodeElement.value = ""
    axios.post(`https://${GetParentResourceName()}/deletepersonaladmin`, {spawncode:spawncode}).then(result => {})
}
function adminViewAccessList() {
    spawncodeElement = document.getElementById("adminpanel-viewaccesslistspawncode")
    spawncode = spawncodeElement.value
    spawncodeElement.value = ""
    accessListPage(spawncode)
}
function adminGainAdminAccess() {
    spawncodeElement = document.getElementById("adminpanel-gainadminaccessspawncode")
    spawncode = spawncodeElement.value
    spawncodeElement.value = ""
    axios.post(`https://${GetParentResourceName()}/gainadminaccess`, {spawncode:spawncode}).then(result => {})
}
function adminLoseAdminAccess() {
    spawncodeElement = document.getElementById("adminpanel-loseadminaccessspawncode")
    spawncode = spawncodeElement.value
    spawncodeElement.value = ""
    axios.post(`https://${GetParentResourceName()}/loseadminaccess`, {spawncode:spawncode}).then(result => {})
}