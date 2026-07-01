"""
Project 2 — Flask web app on Azure App Service (CI/CD with GitHub Actions)
Author: Harish Sarupuru

This is a DYNAMIC web app (server-side code runs on each request) — unlike
Project 1, which served pre-built static files. App Service runs this Python
process for us and GitHub Actions redeploys it automatically on every push.
"""

import os
import platform
import socket
from datetime import datetime, timezone

from flask import Flask, render_template, jsonify

app = Flask(__name__)


@app.route("/")
def home():
    """Home page — renders server-side data to prove the app is running live."""
    context = {
        "app_name": "Harish — Azure Cloud Journey",
        "utc_time": datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S UTC"),
        "hostname": socket.gethostname(),
        "python_version": platform.python_version(),
        "region": os.environ.get("REGION", "Australia Southeast"),
        "build": os.environ.get("BUILD_TAG", "local-dev"),
    }
    return render_template("index.html", **context)


@app.route("/health")
def health():
    """Health-check endpoint. Cloud engineers wire these into monitoring/probes."""
    return jsonify(status="healthy", time=datetime.now(timezone.utc).isoformat())


@app.route("/api/info")
def api_info():
    """Tiny JSON API — shows the app can serve data, not just HTML."""
    return jsonify(
        project="Project 2 of 5 — Azure App Service + CI/CD",
        stack="Python / Flask / Gunicorn",
        hosted_on="Azure App Service (Linux)",
        deployed_by="GitHub Actions",
    )


if __name__ == "__main__":
    # Local development only. On App Service, Gunicorn runs the app (see startup.txt).
    port = int(os.environ.get("PORT", 8000))
    app.run(host="0.0.0.0", port=port, debug=True)
