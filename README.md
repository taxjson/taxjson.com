# taxjson.github.io

The website — static HTML on GitHub Pages. Edit `index.html` / `style.css`, push to `main`; live in about a minute.

- `install.sh` is a shim that runs the installer from the [taxjson/taxjson](https://github.com/taxjson/taxjson) repository, so the site never carries a stale copy.
- No fonts, scripts, or images are loaded from third parties; visitors make no requests beyond this site.
- To move to a custom domain: add a `CNAME` file with the bare domain, point the domain's DNS at GitHub Pages, and update the URLs in `index.html` and the repository README.
