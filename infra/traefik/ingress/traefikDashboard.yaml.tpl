matchRule: Host(`traefik.example.com`)
    entryPoints: ["websecure"]
    # Add custom middlewares : authentication and redirection
    middlewares:
      - name: traefik-dashboard-auth