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


wn.setup.debug({ enabled: true })


wn.setup.endpoints({
  api: "https://runfission.net",
  lobby: "https://auth.runfission.net",
  user: "fissionuser.net"
})



// 🚀


let app, fs


wn.initialise({ permissions: PERMISSIONS })
  .then(async state => {
    const { authenticated } = state

    fs = state.fs

    // Initialize app
    app = Elm.Main.init({
      flags: { authenticated }
    })

    // Ports
    app.ports.focusOnTextInput.subscribe(() => {
      setTimeout(focusOnTextInput, 0)
      setTimeout(focusOnTextInput, 50)
      setTimeout(focusOnTextInput, 250)
    })

    // app.ports.wnfsRequest.subscribe(async request => {
    //   const result = await fs[request.method](...request.arguments)
    //   app.ports.wnfsResponse.send(result)
    // })
  })



// 🛠


function focusOnTextInput() {
  const element = document.querySelector("input[type=\"text\"]")
  if (element) element.focus()
}
