FROM golang:latest AS build



WORKDIR /project

# Copy the entire project and build it

COPY . /project
RUN go mod tidy
RUN go build -o /bin/project


# FROM gcr.io/distroless/static
# Below for debugging
FROM golang:latest
ENV TZ=America/New_York
COPY --from=build /bin/project /bin/project
ENV TZ=America/New_York
ENTRYPOINT ["/bin/project"]
# Args to project
#CMD []

# docker build --no-cache -t us-central1-docker.pkg.dev/mchirico/public/activeincidentfront:v0.0.1 -f Dockerfile .
# docker push us-central1-docker.pkg.dev/mchirico/public/activeincidentfront:v0.0.1
# us-central1-docker.pkg.dev/mchirico/public/activeincident:v0.0.1
# kind load docker-image webdev:v0.0.1 webdev:v0.0.1
#  kubectl create deployment --image=webdev:v0.0.1
#  kubectl create deployment --image=webdev:v0.0.1 webdev
#  kubectl port-forward --address 0.0.0.0 webdev 2345:2345 
#  kubectl port-forward --address 0.0.0.0 webdev 8080:8080
# kubectl expose deployment webdev --port=8080 --target-port=8080
# kubectl port-forward webdev 2345:2345
# kubectl exec -it webdev -- /bin/bash
# dlv debug ./main.go --listen=0.0.0.0:2345 --api-version=2  --headless







