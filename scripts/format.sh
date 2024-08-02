#!/bin/sh -e
set -x

ruff check pr_assistant tests docs scripts docker github_action --fix
ruff format pr_assistant tests docs scripts docker github_action
