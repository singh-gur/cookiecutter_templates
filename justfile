

push message:
    @echo "Pushing changes to the repository..."
    @git add .
    @git commit -m "{{message}}"
    @git push
