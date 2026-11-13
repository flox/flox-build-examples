from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

# Example app only: a real deployment reads this from the environment.
SECRET_KEY = "django-insecure-quotes-app-example-key"
DEBUG = False
ALLOWED_HOSTS = ["*"]

INSTALLED_APPS = [
    "django.contrib.contenttypes",
]

MIDDLEWARE = [
    "django.middleware.common.CommonMiddleware",
]

ROOT_URLCONF = "quotes_site.urls"
WSGI_APPLICATION = "quotes_site.wsgi.application"

DATABASES = {}

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"
