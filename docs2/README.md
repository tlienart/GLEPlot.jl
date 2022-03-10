## PurgeCSS / Local

```
sudo npm i -g purgecss
```

should be such that

```
purgecss --version
```

works.

## NodeJS.jl way

```
using NodeJS
td = mktempdir()
success(pipeline(`$(NodeJS.npm_cmd()) i --prefix $td purgecss`))

# check the executable
purge = `$(NodeJS.nodejs_cmd()) $(td)/node_modules/purgecss/bin/purgecss.js`
run(pipeline(`$purge --version`))
```

calling it

```
run(pipeline(`$purge --css __site/css/tailwind.min.css --content __site/index.html --output __site/css/tailwind.min.css`))
```

```
module.exports = {
  content: ["docs2/__site/index.html", "docs2/__site/**/*.html"],
  css: ["docs2/_css/tailwind.min.css"],
  output: "docs2/__site/css/tailwind.min.css",
  extractors: [
    {
      extractor: content => content.match(/[A-Za-z0-9-_:\/]+/g) || [],
      extensions: ["html"]
    }
  ]
}
```
