# Copyright 2016 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Build the guestbook-go example

# Usage:
#   [VERSION=v3] [REGISTRY="staging-k8s.gcr.io"] make build
SHORT_SHA?=dev-v3
REGISTRY?=gcr.io
PROJECT_ID?=kewei-demo-sandbox

release: clean build push clean

vendor:
	@echo "🌀  Vendor go dependencies for build ..."
	go mod download
	go mod vendor
	go mod verify
	@echo "✅   Go dependencies vendored\n"

test:
	go test .

# builds a docker image that builds the app and packages it into a minimal docker image
build:
	docker build -t ${REGISTRY}/${PROJECT_ID}/guestbook:${SHORT_SHA} .
# push the image to an registry
push:
	gcloud docker -- push ${REGISTRY}/${PROJECT_ID}/guestbook:${SHORT_SHA}

# remove previous images and containers
clean:
	docker rm -f ${REGISTRY}/${PROJECT_ID}/guestbook:${SHORT_SHA} 2> /dev/null || true

.PHONY: release clean build push
