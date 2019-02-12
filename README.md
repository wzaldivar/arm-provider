# arm-provider

## v2.1

Provides files for arm images

* [qemu-arm-static v3.0.0+resin](https://github.com/resin-io/qemu)

* [s6-overlay v1.21.8.0](https://github.com/just-containers/s6-overlay)

* resin-xbuild built from: [resin-xbuild.go commit d4a214fa36e54febcda6e5126adb2ee2249c64e3](https://github.com/resin-io-projects/armv7hf-debian-qemu)

* probe_files: to use with s6-overlay, test existence of files in evironment PROBE_FILES_LIST every PROBE_FILES_INTERVAL seconds. 
    
    * Example: check if /data is mounted from NAS looking for file 
    /data/.from_nas every 5 minutes
        > ENV PROBE_FILES_LIST="/data/.from_nas"\
        > ENV PROBE_FILES_INTERVAL=300
        
    PROBE_FILES_LIST is separated by spaces (not allowed paths with spaces); empty list "" don't search files
    
    * Example:
        > ENV PROBE_FILES_LIST="/data/.from_nas /config/special_config.cfg"

## Usage

### qemu + resin-xbuild
> COPY --from=wzaldivararmhf/arm-provider /arm-provider/bin /usr/bin\
> RUN ["cross-build-start"]\
> \
> your build instructions...\
> \
> RUN ["cross-build-end"]

### s6-overlay
> COPY --from=wzaldivararmhf/arm-provider /arm-provider/s6_overlay\
> ENTRYPOINT ["/init"]

### probe_files
> COPY --from=wzaldivararmhf/arm-provider /arm-provider/probe_files /
> ENV PROBE_FILES_LIST="/path/to/file/needed.chk"\
> ENV PROBE_FILES_INTERVAL=300
