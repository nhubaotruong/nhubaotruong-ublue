#!/usr/bin/env bash
set -oue pipefail

sed -i 's|#default.clock.allowed-rates = \[ 48000 \]|default.clock.allowed-rates = [ 44100 48000 ]|' /usr/share/pipewire/pipewire.conf
# sed -i 's/balanced=balanced$/balanced=balanced-bazzite/' /etc/tuned/ppd.conf
# sed -i 's/performance=throughput-performance$/performance=throughput-performance-bazzite/' /etc/tuned/ppd.conf
# sed -i 's/balanced=balanced-battery$/balanced=balanced-battery-bazzite/' /etc/tuned/ppd.conf

# cp /usr/share/auto-cpufreq/scripts/cpufreqctl.sh /usr/bin/cpufreqctl.auto-cpufreq
# chmod +x /usr/bin/cpufreqctl.auto-cpufreq