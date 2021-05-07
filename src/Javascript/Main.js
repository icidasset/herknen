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


webnativeElm.setup({
  app: app,
  webnative: webnative
})


app.ports.focusOnTextInput.subscribe(() => {
  setTimeout(focusOnTextInput, 0)
  setTimeout(focusOnTextInput, 50)
  setTimeout(focusOnTextInput, 250)
  setTimeout(focusOnTextInput, 500)
})



// 🛠


function focusOnTextInput() {
  const element = document.querySelector("input[type=\"text\"]")
  if (element && document.activeElement != element) element.focus()
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
