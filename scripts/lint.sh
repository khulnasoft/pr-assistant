#!/usr/bin/env bash

set -e
set -x

mypy pr_assistant
ruff check pr_assistant tests docs scripts docker github_action
ruff format pr_assistant tests docker github_action --check
