# Google Play Store CI/CD Setup Guide

This guide explains how to set up automated deployment to Google Play Store for Internal Testing and Closed Testing tracks.

## Prerequisites

1. Google Play Console account with admin access
2. Service Account with Play Console API access
3. GitHub repository with Actions enabled

## Step 1: Create Service Account in Google Cloud

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Navigate to **IAM & Admin** > **Service Accounts**
4. Click **Create Service Account**
5. Fill in the details:
   - Name: `play-store-deploy`
   - Description: `Service account for Play Store deployments`
6. Click **Create and Continue**
7. Skip role assignment (not needed for Play Store)
8. Click **Done**

## Step 2: Generate Service Account Key

1. Click on the created service account
2. Go to **Keys** tab
3. Click **Add Key** > **Create new key**
4. Select **JSON** format
5. Download the JSON file

## Step 3: Link Service Account to Play Console

1. Go to [Google Play Console](https://play.google.com/console/)
2. Select your app
3. Navigate to **Setup** > **API access**
4. Click **Link service account**
5. Select the service account you created
6. Grant the following permissions:
   - **View app information and download bulk reports**
   - **Manage production releases**
   - **Manage testing track releases**
   - **Manage testing track releases (internal, closed, open)**
7. Click **Invite user**

## Step 4: Add GitHub Secret

1. Go to your GitHub repository
2. Navigate to **Settings** > **Secrets and variables** > **Actions**
3. Click **New repository secret**
4. Name: `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`
5. Value: Paste the entire contents of the JSON key file you downloaded
6. Click **Add secret**

## Step 5: Configure Workflow

The workflow is already configured in `.github/workflows/flutter-deploy-playstore.yml`

### Automatic Deployments

- **Internal Testing**: Automatically deploys when you push to `main`, `master`, or `develop` branches
- **Closed Testing**: Deploy manually via workflow dispatch
- **Open Testing**: Deploy manually via workflow dispatch
- **Production**: Deploy when you create a tag starting with `v` (e.g., `v2.0.79`)

### Manual Deployment

1. Go to **Actions** tab in GitHub
2. Select **Deploy to Google Play Store** workflow
3. Click **Run workflow**
4. Select the track (internal, closed, open, production)
5. Click **Run workflow**

## Workflow Files

### `flutter-deploy-playstore.yml`
- Handles building and deploying to Google Play Store
- Supports all testing tracks (internal, closed, open, production)
- Automatic deployment to internal testing on push to main branches
- Manual deployment to other tracks via workflow dispatch

### `flutter-ci-testing.yml`
- Runs tests and code analysis
- Builds APK and AAB for testing
- Uploads artifacts for download

## Testing Tracks

### Internal Testing
- Fastest track for testing
- Limited to 100 testers
- No review required
- Automatic deployment on push to main branches

### Closed Testing
- Up to 20,000 testers
- Requires review (usually quick)
- Manual deployment via workflow dispatch

### Open Testing
- Unlimited testers
- Requires review
- Publicly visible
- Manual deployment via workflow dispatch

### Production
- Public release
- Requires full review
- Deploy via tags (e.g., `v2.0.79`)

## Troubleshooting

### Error: "Service account not found"
- Ensure the service account is linked in Play Console
- Check that the JSON key is correctly added to GitHub secrets

### Error: "Permission denied"
- Verify service account has the required permissions in Play Console
- Check API access settings in Play Console

### Error: "App bundle not found"
- Ensure the build step completed successfully
- Check that the AAB file path is correct

## Notes

- The workflow uses `r0adkll/upload-google-play@v1` action
- Application ID is set to `com.kaaikani.kaaikani` (update if different)
- Build artifacts are retained for 30 days
- Internal testing deployments are automatic on push to main branches



















