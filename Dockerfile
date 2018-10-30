FROM alpine:3.7

ENV GOOGLE_CLOUD_SDK_VERSION=223.0.0
ENV GOOGLE_APP_ENGINE_SDK_VERSION=1.9.68
ENV CLOUDSDK_APP_RUNTIME_ROOT=/google-cloud-sdk/platform/ext-runtime/
RUN apk add --no-cache curl python

# Install the gcloud SDK
RUN curl -fsSLo google-cloud-sdk.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-$GOOGLE_CLOUD_SDK_VERSION-linux-x86_64.tar.gz
RUN tar -xzf google-cloud-sdk.tar.gz
RUN rm google-cloud-sdk.tar.gz
RUN ./google-cloud-sdk/install.sh --quiet

# Install the app engine SDK
RUN ./google-cloud-sdk/bin/gcloud components install app-engine-go

# Install the legacy app engine SDK
RUN curl -fsSLo go_appengine_sdk_linux_amd64-$GOOGLE_APP_ENGINE_SDK_VERSION.zip https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_linux_amd64-$GOOGLE_APP_ENGINE_SDK_VERSION.zip
RUN unzip -q go_appengine_sdk_linux_amd64-$GOOGLE_APP_ENGINE_SDK_VERSION.zip
RUN rm go_appengine_sdk_linux_amd64-$GOOGLE_APP_ENGINE_SDK_VERSION.zip

# Clean up
RUN rm -rf ./google-cloud-sdk/.install

ADD drone-gae /bin/
ENTRYPOINT ["/bin/drone-gae"]
