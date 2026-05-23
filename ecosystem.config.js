module.exports = {
  apps: [
    {
      name: 'geyoutube-web',
      cwd: '/var/www/geyoutube',
      script: 'venv/bin/gunicorn',
      args: '--bind 127.0.0.1:5001 --workers 2 --threads 4 --timeout 600 --access-logfile logs/access.log --error-logfile logs/error.log app:app',
      interpreter: 'none', // Don't use Node.js interpreter
      instances: 1,
      exec_mode: 'fork',
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      env: {
        NODE_ENV: 'production',
        PORT: '5001'
      },
      error_file: 'logs/web-error.log',
      out_file: 'logs/web-out.log',
      log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
      merge_logs: true,
      min_uptime: '10s',
      max_restarts: 10,
      restart_delay: 4000
    },
    {
      name: 'geyoutube-worker',
      cwd: '/var/www/geyoutube',
      script: 'venv/bin/celery',
      args: '-A celery_app worker --loglevel=info --concurrency=1 --logfile=logs/celery.log',
      interpreter: 'none',
      instances: 1,
      exec_mode: 'fork',
      autorestart: true,
      watch: false,
      max_memory_restart: '2G',
      error_file: 'logs/worker-error.log',
      out_file: 'logs/worker-out.log',
      log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
      merge_logs: true,
      min_uptime: '10s',
      max_restarts: 10,
      restart_delay: 4000
    }
  ]
};
