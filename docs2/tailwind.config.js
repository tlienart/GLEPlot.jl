module.exports = {
  content: ["docs2/__site/index.html", "docs2/__site/**/*.html"],
  css: ["docs2/_css/tailwind.min.css"],
  output: "docs2/__site/css/tailwind.min.css",
  extractors: [
    {
      // tailwind needs a specific extractor
      extractor: content => content.match(/[A-Za-z0-9-_:\/]+/g) || [],
      extensions: ["html"]
    }
  ]
}
