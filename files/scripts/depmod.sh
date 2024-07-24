#!/usr/bin/env bash

depmod -a -v "$(ls /usr/lib/modules)"
