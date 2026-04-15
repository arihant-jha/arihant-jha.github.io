#!/usr/bin/env bash
set -euo pipefail

railway up \
  --project 666f32e4-8d86-498a-94e1-bd9ff4cf7023 \
  --service ec6c26fc-a62f-48c8-b57a-fe49da8b836e \
  --environment production
