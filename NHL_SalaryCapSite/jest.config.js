module.exports = {
    transform: {
      "^.+\\.js$": "babel-jest",
    },
    testenvironment: "jest-environment-jsdom",
    moduleNameMapper: {
      "^@hotwired/stimulus$": "../node_modules/@hotwired/stimulus",
    },
  };
  