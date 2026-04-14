# Deploy to Azure Static Web Apps

Fully static — no backend, no container, no runtime costs. Free tier = $0/month.

## Prerequisites

- Azure CLI installed (`brew install azure-cli`)
- Logged in (`az login`)
- GitHub repo (Azure Static Web Apps deploys from a repo)

## Option 1: Deploy via Azure CLI (one command)

```bash
# Install the SWA CLI
npm install -g @azure/static-web-apps-cli

# Deploy directly (no GitHub needed)
swa deploy . --deployment-token <YOUR_TOKEN>
```

To get a deployment token, first create the Static Web App in the Azure portal or via CLI:

```bash
az staticwebapp create \
  --name auth-trainer \
  --resource-group auth-trainer-rg \
  --location eastus2 \
  --sku Free

# Get the deployment token
az staticwebapp secrets list \
  --name auth-trainer \
  --resource-group auth-trainer-rg \
  --query "properties.apiKey" -o tsv
```

## Option 2: Deploy via GitHub (auto-deploys on push)

1. Push this repo to GitHub
2. Create via CLI:

```bash
az group create --name auth-trainer-rg --location eastus

az staticwebapp create \
  --name auth-trainer \
  --resource-group auth-trainer-rg \
  --source https://github.com/<you>/authenticator-trainer \
  --branch main \
  --app-location "/" \
  --login-with-github \
  --sku Free
```

This sets up a GitHub Action that auto-deploys on every push to `main`.

## Cost

| Component | Cost |
|-----------|------|
| Azure Static Web Apps (Free tier) | $0/month |
| Custom domain + SSL | Included free |
| **Total** | **$0/month** |

Free tier includes 100 GB bandwidth/month and 2 custom domains.

## Tear down

```bash
az group delete --name auth-trainer-rg --yes
```

## How it works without a backend

The app uses **WebRTC** (via PeerJS) for peer-to-peer communication between
your desktop browser and phone browser. The PeerJS public signaling server
handles the initial handshake, then all game data flows directly between the
two browsers. No server processes code validation or timing — the desktop
browser runs all game logic.

This means it works across any network (not just same WiFi), and there's
nothing to scale, patch, or keep running.
