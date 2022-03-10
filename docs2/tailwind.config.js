module.exports = {
  content: ["__site/index.html", "__site/**/*.html"],
  css: ["_css/tailwind.min.css"],
  output: "__site/css/tailwind.min.css",
  extractors: [
    {
      // tailwind needs a specific extractor
      extractor: content => content.match(/[A-Za-z0-9-_:\/]+/g) || [],
      extensions: ["html"]
    }
  ]
}
