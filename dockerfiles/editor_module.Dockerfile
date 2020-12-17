ARG hubImage
ARG baseImage
ARG editorBaseImage

###########################
#         Builder         #
###########################

FROM $editorBaseImage AS editorBase
FROM $hubImage AS builder

# Install module
ARG version
COPY --from=editorBase "$UNITY_PATH/" /opt/unity/editors/$version/

ARG changeSet
ARG module="non-existent-module"
RUN unity-hub install-modules --version "$version" --module "$module" --childModules 2>&1 | tee hub.log \
        && cat hub.log | grep 'Missing module' | exit $(wc -l)

###########################
#          Editor         #
###########################

FROM $baseImage

# Always put "Editor" and "modules.json" directly in $UNITY_PATH
ARG version
COPY --from=builder /opt/unity/editors/$version/ "$UNITY_PATH/"

