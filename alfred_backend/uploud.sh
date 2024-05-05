# from the dropdown at the top of Cloud Console:
export GCLOUD_PROJECT="talk-app" 
# from Step 2.2 above:
export REPO="try3--repository"
# the region you chose in Step 2.4:
export REGION="us-central1"
# whatever you want to call this image:
export IMAGE="talk-server"
us-central1-docker.pkg.dev/talk-app-419322/talk-app/talk-server
# use the region you chose above here in the URL:
export IMAGE_TAG=${REGION}-docker.pkg.dev/$GCLOUD_PROJECT/$REPO/$IMAGE

# Build the image:
docker build -t $IMAGE_TAG -f path/to/Dockerfile --platform linux/x86_64 .
# Push it to Artifact Registry:
docker push $IMAGE_TAG