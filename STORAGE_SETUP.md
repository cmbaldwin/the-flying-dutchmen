# ActiveStorage Google Cloud Storage Setup

## Overview
This document describes the configuration for ActiveStorage using Google Cloud Storage (GCS) in The Flying Dutchmen Rails application.

## Setup Date
December 21, 2025

## Problem
The application was configured to use Google Cloud Storage for ActiveStorage but was missing the required credentials, resulting in:
```
RuntimeError (Your credentials were not found. To set up Application Default
Credentials for your environment, see
https://cloud.google.com/docs/authentication/external/set-up-adc)
```

## Solution

### 1. Service Account Credentials
- **File**: `the-flying-dutchmen-d21298c228c4.json` (in project root)
- **Service Account**: `tfd-rails-activestorage@the-flying-dutchmen.iam.gserviceaccount.com`
- **Project ID**: `the-flying-dutchmen`

### 2. Environment Variables
Created `.env` file with the following configuration:

```bash
GCLOUD_PROJECT=the-flying-dutchmen
GOOGLE_APPLICATION_CREDENTIALS=the-flying-dutchmen-d21298c228c4.json
GCLOUD_BUCKET=tld-forum
```

### 3. GCS Bucket Details
- **Bucket Name**: `tld-forum`
- **Location**: Multi-region US
- **Storage Class**: Standard
- **Access Control**: Uniform
- **Public Access**: Access granted to public principals
- **Soft Delete**: 7 days
- **Console URL**: https://console.cloud.google.com/storage/browser/tld-forum
- **gsutil URI**: `gs://tld-forum`

## Storage Configuration Files

### config/storage.yml
The `google` service is configured to use environment variables:
```yaml
google:
  service: GCS
  project: <%= ENV["GCLOUD_PROJECT"] %>
  credentials: <%= ENV["GOOGLE_APPLICATION_CREDENTIALS"] %>
  bucket: <%= ENV["GCLOUD_BUCKET"] %>
  public: true
```

### config/environments/development.rb
Development environment uses GCS (line 51):
```ruby
config.active_storage.service = :google
```

## Security Notes

### .gitignore
Ensure the following are in `.gitignore`:
- `.env` - Contains environment variable configuration
- `*.json` - Service account key files (credentials)

### Production (Heroku)
For production deployment on Heroku, set these config vars:
```bash
heroku config:set GCLOUD_PROJECT=the-flying-dutchmen
heroku config:set GCLOUD_BUCKET=tld-forum
heroku config:set GOOGLE_APPLICATION_CREDENTIALS="$(cat the-flying-dutchmen-d21298c228c4.json)"
```

## Alternative: Local Development with Disk Storage

If you prefer to use local disk storage for development instead of GCS, change line 51 in `config/environments/development.rb`:

```ruby
# Change from:
config.active_storage.service = :google

# To:
config.active_storage.service = :local
```

This will store files in the `storage/` directory locally instead of uploading to GCS.

## Testing the Setup

After configuration, restart your Rails server and verify that image uploads work correctly without authentication errors.

## Dependencies
- `google-cloud-storage` gem (installed via Gemfile)
- `dotenv-rails` gem for loading environment variables from `.env`
