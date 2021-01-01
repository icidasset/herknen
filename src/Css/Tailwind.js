import colors from "tailwindcss/colors.js"


export default {
  darkMode: "media",
  theme: {

    fontFamily: {
      body: [ "Heebo" ],
      display: [ "Old Standard TT", "Libre Baskerville" ]
    },


    extend: {
      colors: {
        amber: colors.amber,
        cyan: colors.cyan,
        emerald: colors.emerald,
        fuchsia: colors.fuchsia,
        gray: colors.warmGray,
        lightBlue: colors.lightBlue,
        lime: colors.lime,
        rose: colors.rose,
        teal: colors.teal,
        violet: colors.violet
      }
    }

  },
  variants: {

    extend: {
      backgroundOpacity: [ "dark", "responsive" ],
      borderWidth: [  "first", "focus", "last" ],
      borderRadius: [ "first", "last", "responsive" ],
      pointerEvents: [ "group-hover" ],
      textOpacity: [ "dark" ]
    }

  }
}
