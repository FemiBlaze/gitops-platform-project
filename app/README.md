# Application Overview

This is a lightweight Node.js web application used to demonstrate:

* Containerization with Docker
* CI automation using GitHub Actions
* Deployment to Kubernetes via GitOps (Argo CD)

This application is intentionally simple. Its purpose is to act as a deployable workload inside the larger GitOps platform.

---

## Design Principles

* Stateless (no local storage)
* Container-first architecture
* Environment-agnostic configuration
* Kubernetes-ready deployment

---

## Run Locally

Install dependencies and start the server:

```bash
npm install
npm start
```

The app will run on:

```
http://localhost:3000
```

---

## Run with Docker

Build the Docker image:

```bash
docker build -t app:test .
```

Run the container:

```bash
docker run -p 3000:3000 app:test
```

Access in browser:

```
http://localhost:3000
```

---

## CI Integration

When changes are pushed to the `app/` directory:

* GitHub Actions builds the Docker image
* The image is pushed to Docker Hub
* Argo CD deploys the updated image to Kubernetes

---

## Role in the Platform

This application exists purely to demonstrate:

* Automated build pipelines
* Immutable container deployment
* GitOps reconciliation
* Kubernetes workload management

It is not intended as a production business application, but as a platform validation workload.
