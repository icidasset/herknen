//
// | (• ◡•)| (❍ᴥ❍ʋ)


self.wn = webnative



// 🍱


const PERMISSIONS = {
  app: {
    name: "Herknen",
    creator: "icidasset"
  }
}


const app = Elm.Main.init({
  flags: {}
})


wn.setup.debug({ enabled: true })


// wn.setup.endpoints({
//   api: "https://runfission.net",
//   lobby: "https://auth.runfission.net",
//   user: "fissionuser.net"
// })


// Allows for the blur event on input elements on iOS
document.body.addEventListener("click", () => {})



// 🚀


let fs


wn.initialise({ permissions: PERMISSIONS })
  .then(async state => {
    const { authenticated } = state

    fs = state.fs

    // Ports
    app.ports.focusOnTextInput.subscribe(() => {
      setTimeout(focusOnTextInput, 0)
      setTimeout(focusOnTextInput, 50)
      setTimeout(focusOnTextInput, 250)
      setTimeout(focusOnTextInput, 500)
    })

    // Webnative ports
    webnativeElm.setup(app, fs)

    // Initialise, Pt. 2
    app.ports.initialise.send({
      authenticated
    })
  })



// 🛠


function focusOnTextInput() {
  const element = document.querySelector("input[type=\"text\"]")
  if (element) element.focus()
}



// Vertical Height
// ---------------

setVerticalHeightUnit()


window.addEventListener("resize", () => {
  setTimeout(setVerticalHeightUnit, 0)
})


function setVerticalHeightUnit() {
  const vh = document.documentElement.clientHeight * 0.01
  document.documentElement.style.setProperty("--vh", `${vh}px`)
}
