#!/bin/sh
set -e

# Set default values for environment variables
export DB_HOST=${DB_HOST:-db}
export DB_PORT=${DB_PORT:-3306}

echo "Waiting for database..."
python wait_for_db.py
echo "Database is available."

# Process commands
while test $# -gt 0
do
    case "$1" in
        --migrate)
            echo "Applying database migrations..."
            python manage.py migrate
            ;;
        --create-superuser)
            echo "Creating superuser..."
            python manage.py createsuperuser --noinput --username "$DJANGO_SUPERUSER_USERNAME" --email "$DJANGO_SUPERUSER_EMAIL" || echo "Superuser already exists, skipping."
            ;;
        --runserver)
            echo "Starting server..."
            exec python manage.py runserver 0.0.0.0:8000
            ;;
        --*)
            echo "Unknown option: $1"
            ;;
        *)
            # Execute other commands
            exec "$@"
            ;;
    esac
    shift
done
