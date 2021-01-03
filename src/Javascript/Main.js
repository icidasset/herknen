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

    app.ports.webnativeRequest.subscribe(async request => {
      webnative[request.method](
        ...request.arguments
      )
    })

    app.ports.wnfsRequest.subscribe(async request => {
      console.log(request)

      if (request.method === "write") {
        request.arguments = [
          request.arguments[0],
          Uint8Array.from(request.arguments[1])
        ]
      }

      const data = await fs[request.method.replace(/_utf8$/, "")](
        ...request.arguments
      )

      app.ports.wnfsResponse.send({
        tag: request.tag,
        method: request.method,
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
