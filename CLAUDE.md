# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

"Docker para NGINX con PHP-FPM" — an early (2015) Docker image running nginx + PHP-FPM under supervisord, with a systemd unit (`docker-nginx.service`) to run the container as a host service.

## Layout

- `Dockerfile`, `nginx-site.conf`, `supervisord.conf` — image and process definitions.
- `docker-nginx.service` — systemd unit for the container.
- `build-all.sh` — image build helper.
