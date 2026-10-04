# taxjson.com

The website — static HTML on GitHub Pages. Edit `index.html` / `style.css`, push to `main`; live in about a minute.

- `install.sh` is a shim that runs the installer (`install.sh` at the root of [taxjson/taxjson](https://github.com/taxjson/taxjson), `main` branch) so the site never carries a stale copy. It passes its arguments through (`bash -c "$(curl -fsSL https://taxjson.com/install.sh)" _ --with-fetch`), as do the `TAXJSON_*` environment variables.
- No fonts, scripts, or images are loaded from third parties; visitors make no requests beyond this site.
- `CNAME` pins the custom domain (taxjson.com); DNS for the apex points at GitHub Pages (four A records + AAAA), `www` is a CNAME to `taxjson.github.io`.
- `dns/taxjson.com.zone` is the DNS for the domain as a BIND zone file — importable at most DNS hosts — kept here so the records are on record next to the `CNAME` they serve.
