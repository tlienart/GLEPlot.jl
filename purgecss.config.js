module.exports = {
  content: ["__site/index.html", "__site/**/*.html"],
  css: ["_css/bootstrap.min.css", "_libs/highlight/github.min.css", "_libs/katex/katex.min.css"],
  output: "__site/css/",
  extractors: [
    {
      // extractor compatible with tailwind as well
      extractor: content => content.match(/[A-Za-z0-9-_:\/]+/g) || [],
      extensions: ["html"]
    }
  ]
}
