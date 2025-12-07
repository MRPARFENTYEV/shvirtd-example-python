PROJECT_DIR="$(pwd)"
(crontab -l 2>/dev/null; echo "* * * * * cd \"$PROJECT_DIR\" && ./backup.sh") | crontab -