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
  })



// WEBNATIVE
// =========
