module.exports = {
  content: ["__site/index.html", "__site/**/*.html"],
  css: ["_css/*.css"],
  output: "__site/css/final.css",
  extractors: [
    {
      // extractor compatible with tailwind as well
      extractor: content => content.match(/[A-Za-z0-9-_:\/]+/g) || [],
      extensions: ["html"]
    }
  ]
}
