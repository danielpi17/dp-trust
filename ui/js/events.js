// add messenger between lua and js

window.addEventListener("DOMContentLoaded", () => {
    $("#tablet").hide()
    $("#trustedpersonals").hide()
    $("#adminpanel").hide()
    $("#accesslist").hide()
    registerData()

    window.addEventListener("message", (event) => {
        if(event.data.type === "visibility") {
            registerData()
            if(event.data.value) {
                $("#tablet").show()
            } else {
                $("#tablet").hide()
            }
        }
    })
    document.onkeyup = (event) => {
        if(event.which === 27) {
            $("#tablet").hide()
            axios.post(`https://${GetParentResourceName()}/exit`, {}).then(result => {})
        }
    }
})