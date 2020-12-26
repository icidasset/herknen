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


wn.setup.endpoints({
  api: "https://runfission.net",
  lobby: "https://auth.runfission.net",
  user: "fissionuser.net"
})



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
    })

    app.ports.wnfsRequest.subscribe(async request => {
      if (request.method === "write") {
        request.arguments = [Uint8Array.from(request.arguments[0])]
      }

      const data = await fs[request.method.replace(/_utf8$/, "")](
        request.path,
        ...request.arguments
      )

      app.ports.wnfsResponse.send({
        tag: request.tag,
        method: request.method,
        path: request.path,
        data: data.root ? null : (data.buffer ? Array.from(data) : data)
      })
    })

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
