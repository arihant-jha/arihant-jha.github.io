# Emberwood FastHTML Blog

An ultra-light FastHTML application that renders a micro-blog and serves each post through native FastHTML routes. It is already wired for Railway deployment using the documented `fh_railway_deploy` helper for the smoothest setup.

## Local development

1. Create and activate a Python virtual environment and install the dependencies:

   ```bash
   python -m venv .venv
   source .venv/bin/activate     # or `.venv\\Scripts\\activate` on Windows
   pip install -r requirements.txt
   ```

2. Run the app locally via FastHTML’s `serve()` helper (it already listens on `$PORT` when available):

   ```bash
   python main.py
   ```

   Alternatively, start the Starlette server anywhere with `uvicorn`:

   ```bash
   uvicorn main:app --reload
   ```

3. Visit `http://localhost:8000` (or the port logged by the FastHTML server) to see the blog and navigate into posts.

## Railway deployment

Railway is the recommended host because FastHTML ships a helper that bootstraps the project automatically.

1. Install the Railway CLI if you haven’t already:

   ```bash
   curl -sSL https://railway.app/install.sh | sh
   railway login
   ```

2. From the repo root, run FastHTML’s Railway helper:

   ```bash
   fh_railway_deploy emberwood-blog
   ```

   That command either links to your existing Railway project or creates a new one, builds the app, and deploys it. Copy the produced URL for your custom domain or GitHub Pages iframe.

3. Any new commits in this repo (after you connect it inside Railway) will trigger a redeploy automatically; use `railway up` or `railway run` if you want to test changes before pushing.

4. (Optional) Create a custom domain like `blog.yourdomain.com` in the Railway dashboard and point your DNS there. Use an iframe or reverse proxy from GitHub Pages if you need to combine static and dynamic experiences.

## Project structure

- `main.py` – FastHTML routes with styles, home page, and per-post detail pages.
- `requirements.txt` – Direct dependencies tracked for Railway builds.
- `.gitignore` – Standard Python ignores plus the `dist/` folder for future static exports.

Let me know if you want to set up a GitHub Action that runs `pip install -r requirements.txt` and `railway up` on push, or if you’d prefer to generate static snapshots for GH Pages and embed the Railway-hosted blog.
