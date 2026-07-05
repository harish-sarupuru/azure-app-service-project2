# Project 2 — Python Web App on Azure App Service with GitHub Actions CI/CD

A dynamic **Python (Flask)** web app hosted on **Azure App Service (Linux)**, deployed
automatically by a **GitHub Actions CI/CD pipeline** on every push to `main`. This is
the second of five hands-on Azure cloud engineering projects.

Where Project 1 served *static* files from Blob Storage, this project runs *server-side
code* on a managed platform and ships changes automatically — the core of modern cloud
delivery.

**Live site:** https://harish-webapp-project2-bnbtatd9amgdgxa4.australiasoutheast-01.azurewebsites.net/

---

## What this project demonstrates

- Provisioning an **App Service Plan** (compute) and **App Service** (the web app)
- Running a real **Python/Flask** app with **Gunicorn** as the production WSGI server
- **CI/CD** with **GitHub Actions** — build, package, and deploy on every commit
- Storing deployment credentials securely as a **GitHub Actions secret** (publish profile)
- A **health-check endpoint** (`/health`) and a small **JSON API** (`/api/info`)
- Cost control with the **F1 Free tier** and an Azure budget alert

## Architecture

```
  git push ─▶ GitHub ─▶ GitHub Actions (build + deploy)
                              │  publish profile (secret)
                              ▼
                     Azure App Service (Linux)
                       └── Gunicorn ─▶ Flask app (app:app)
                              ▲
   Browser ──HTTPS──────────┘  https://<app-name>.azurewebsites.net
```

## Routes

| Route       | Returns                                             |
|-------------|-----------------------------------------------------|
| `/`         | HTML page rendered server-side (live server time)   |
| `/health`   | JSON health check for monitoring/probes             |
| `/api/info` | JSON project/stack info                             |

## Run locally

```bash
python -m venv venv
source venv/bin/activate        # Windows: venv\Scripts\activate
pip install -r requirements.txt
python app.py                   # http://localhost:8000
```

## Files

- `app.py` — Flask application (routes + server-side rendering)
- `templates/index.html` — home page template
- `requirements.txt` — Python dependencies (Flask, Gunicorn)
- `startup.txt` — App Service startup command (Gunicorn)
- `.github/workflows/azure-app-service.yml` — CI/CD pipeline
- `.gitignore` — keeps venv, secrets, and junk out of Git

## Deploy

Full click-by-click instructions are in **Project2-Build-Guide** (in the project folder).
Short version: create the App Service, download its publish profile, add it to GitHub as
the secret `AZURE_WEBAPP_PUBLISH_PROFILE`, set `APP_NAME` in the workflow, and push.

---

*Project 2 of 5 — part of my journey to becoming an Azure Cloud Engineer.*
