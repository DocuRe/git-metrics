# git-metrics

The idea behind this application is to provide reporting on github projects.  
This project using the Graphql to pull data and Pancake/D3js to render reports.  

Pull Requests are welcomed.

# svelte app

This project was created from the template for [Svelte](https://svelte.dev) apps. It lives at https://github.com/sveltejs/template.

*Note that you will need to have [Node.js](https://nodejs.org) v12.6.0 installed.*

## Getting started

Clone this repsitory 

```bash
git clone git@github.com:DocuRe/git-metrics.git
```

Install the dependencies...

```bash
cd git-metrics
npm install
```

Copy and edit config.example.json

```bash
cp config.example.json config.json
```

Edit `config.json` and replace INSERT_TOKEN_HERE with your Github token [reference](https://github.com/settings/tokens/new)

Now start [Rollup](https://rollupjs.org):

```bash
npm run dev
```

You should see an output similar to this;

```
  Your application is ready~! 🚀

  - Local:      http://0.0.0.0:5000
  - Network:    http://192.168.1.73:5000
```

## Building and running in production mode

To create an optimised version of the app:

```bash
npm run build
```

## Single-page app mode

By default, sirv will only respond to requests that match files in `public`. This is to maximise compatibility with static fileservers, allowing you to deploy your app anywhere.

If you're building a single-page app (SPA) with multiple routes, sirv needs to be able to respond to requests for *any* path. You can make it so by editing the `"start"` command in package.json:

```js
"start": "sirv public --single"
```


## Deploying to the web

### With [now](https://zeit.co/now)

Install `now` if you haven't already:

```bash
npm install -g now
```

Then, from within your project folder:

```bash
cd public
now deploy --name my-project
```

As an alternative, use the [Now desktop client](https://zeit.co/download) and simply drag the unzipped project folder to the taskbar icon.

### With [surge](https://surge.sh/)

Install `surge` if you haven't already:

```bash
npm install -g surge
```

Then, from within your project folder:

```bash
npm run build
surge public my-project.surge.sh
```
