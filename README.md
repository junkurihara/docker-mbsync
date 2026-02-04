# docker-mbsync

Container for backing up Gmail/Google Workspace

## Setup

1. Generate secrets

```bash
   echo "your-email@example.com" > secrets/gmail_user.txt
   echo "xxxx xxxx xxxx xxxx" > secrets/gmail_app_password.txt
   chmod 600 secrets/gmail_*.txt
```

2. Create config

```bash
   cp config/mbsyncrc.example config/mbsyncrc
```

3. Start

```bash
   docker compose up -d
```
