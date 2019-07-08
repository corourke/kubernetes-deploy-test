docker build -t corourke/dst-frontend:latest -t corourke/dst-frontend:${GIT_SHA}  -f ./frontend/Dockerfile ./frontend
docker build -t corourke/dst-api:latest      -t corourke/dst-api:${GIT_SHA}  -f ./api-server/Dockerfile ./api-server
docker build -t corourke/dst-worker:latest   -t corourke/dst-worker:${GIT_SHA}  -f ./worker/Dockerfile ./worker

# Push images to docker hub
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

docker push corourke/dst-frontend:latest
docker push corourke/dst-api:latest
docker push corourke/dst-worker:latest

docker push corourke/dst-frontend:${GIT_SHA}
docker push corourke/dst-api:${GIT_SHA}
docker push corourke/dst-worker:${GIT_SHA}

kubectl apply -f k8config

kubectl set image deployment/fe-deployment frontend=corourke/dst-frontend:${GIT_SHA}
kubectl set image deployment/api-deployment api=corourke/dst-api:${GIT_SHA}
kubectl set image deployment/worker-deployment worker=corourke/dst-worker:${GIT_SHA}
