#!/usr/bin/sh

echo "[default]
access_key = $(pass AWS|grep 'access-key-id'   |awk '{print $2'})
secret_key = $(pass AWS|grep 'secret-access-id'|awk '{print $2'})" > ~/.s3cfg
