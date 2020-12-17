ARG hubImage
ARG baseImage

###########################
#         Builder         #
###########################

FROM $hubImage AS builder

# Install editor
ARG version
ARG changeSet
RUN unity-hub install --version "$version" --changeset "$changeSet" 2>&1 | tee hub.log \
      && cat hub.log | grep 'Error' | exit $(wc -l)

###########################
#          Editor         #
###########################

FROM $baseImage

# Always put "Editor" and "modules.json" directly in $UNITY_PATH
ARG version
COPY --from=builder /opt/unity/editors/$version/ "$UNITY_PATH/"

# Add a file containing the version for this build
RUN echo $version > "$UNITY_PATH/version"

# Alias to "unity-editor" with default params
RUN echo '#!/bin/bash\nxvfb-run -ae /dev/stdout --server-args='-screen 0 640x480x24' "$UNITY_PATH/Editor/Unity" -batchmode "$@"' > /usr/bin/unity-editor \
      && chmod +x /usr/bin/unity-editor
