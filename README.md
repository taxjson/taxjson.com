# taxjson.com

The website — static HTML on GitHub Pages. Edit `index.html` / `style.css`, push to `main`; live in about a minute.

- `install.sh` is a shim that runs the installer from the [taxjson/taxjson](https://github.com/taxjson/taxjson) repository, so the site never carries a stale copy.
- No fonts, scripts, or images are loaded from third parties; visitors make no requests beyond this site.
- `CNAME` pins the custom domain (taxjson.com); DNS for the apex points at GitHub Pages (four A records + AAAA), `www` is a CNAME to `taxjson.github.io`.
