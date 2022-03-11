module.exports = {
  content: ["__site/index.html", "__site/**/*.html"],
  // not recommended to put highlight or katex stuff here
  css: ["_css/bootstrap.min.css"],
  output: "__site/css/",
  extractors: [
    {
      // extractor compatible with tailwind as well
      extractor: content => content.match(/[A-Za-z0-9-_:\/]+/g) || [],
      extensions: ["html"]
    }
  ]
}
