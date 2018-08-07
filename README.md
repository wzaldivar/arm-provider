Provides files for arm images

- qemu-arm-static v2.9.0+resin1 from: https://github.com/resin-io/qemu
- s6-overlay v1.21.4.0 from: https://github.com/just-containers/s6-overlay
- resin-xbuild build from resin-xbuild.go commit d4a214fa36e54febcda6e5126adb2ee2249c64e3 from: https://github.com/resin-io-projects/armv7hf-debian-qemu

- probe_files: to use with s6-overlay, test existence of files in evironment PROBE_FILES_LIST every PROBE_FILES_INTERVAL seconds. 
    Example: check if /data is mounted from NAS looking for file /data/.from_nas every 5 minutes
        ENV PROBE_FILES_LIST="/data/.from_nas"
        ENV PROBE_FILES_INTERVAL=300
    PROBE_FILES_LIST is separated by spaces (not allowed paths with spaces); empty list "" don't search files
        Example:
            ENV PROBE_FILES_LIST="/data/.from_nas /config/special_config.cfg"
