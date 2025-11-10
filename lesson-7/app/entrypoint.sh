#!/bin/sh
set -euo pipefail

python manage.py migrate --noinput || true

exec gunicorn project.wsgi:application --bind 0.0.0.0:${PORT:-8000}
