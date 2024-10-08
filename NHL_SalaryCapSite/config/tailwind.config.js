const defaultTheme = require("tailwindcss/defaultTheme");
const shadcnConfig = require("./shadcn.tailwind.js");

module.exports = {
  content: [
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/components/**/*.{html,erb,rb}",
    "./app/views/**/*.{erb,haml,html,slim}"
  ],
  safelist: [
    "text-green-500",
    "text-red-500"
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/aspect-ratio"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/container-queries"),
  ],
  ...shadcnConfig,
};

  
  

