// add messenger between lua and js

window.addEventListener("DOMContentLoaded", () => {
    $("#home").hide()
    $("#trustedpersonals").hide()
    $("#adminpanel").hide()
    $("#accesslist").hide()
    registerData({
        "myvehicles": ["spanw", "cod", "scott", "dan", "garrett"],
        "trustedpersonals": [["test", "2142595123129839", "MGR"],["test", "2142595123129839", "ADM"],["test", "2142595123129839", "USR"]],
        "admin": true
    })
    setAccessList([["djisadojd", "USR"], ["sjaidhasiduw", "MGR"], ["sodohrwghhoq", "ONR"]])

    // document.getElementById("testbutton").addEventListener("click", () => {
    //     // $("#test").hide()
    //     fetch(`https://${GetParentResourceName()}/test`, {
    //         method: "POST",
    //         body: JSON.stringify({message: (document.getElementById("test").value)})
    //     }).then(resp => resp.json()).then(resp => console.log(JSON.stringify(resp)))
    // })
})