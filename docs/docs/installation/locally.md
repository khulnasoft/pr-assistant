## Using pip package

Install the package:

```
pip install pr-insight
```

Then run the relevant tool with the script below.
<br>
Make sure to fill in the required parameters (`user_token`, `openai_key`, `pr_url`, `command`):

```python
from pr_insight import cli
from pr_insight.config_loader import get_settings

def main():
    # Fill in the following values
    provider = "github" # GitHub provider
    user_token = "..."  # GitHub user token
    openai_key = "..."  # OpenAI key
    pr_url = "..."      # PR URL, for example 'https://github.com/Khulnasoft/pr-insight/pull/809'
    command = "/review" # Command to run (e.g. '/review', '/describe', '/ask="What is the purpose of this PR?"', ...)

    # Setting the configurations
    get_settings().set("CONFIG.git_provider", provider)
    get_settings().set("openai.key", openai_key)
    get_settings().set("github.user_token", user_token)

    # Run the command. Feedback will appear in GitHub PR comments
    cli.run_command(pr_url, command)


if __name__ == '__main__':
    main()
```

## Using Docker image

A list of the relevant tools can be found in the [tools guide](../tools/ask.md).

To invoke a tool (for example `review`), you can run directly from the Docker image. Here's how:

- For GitHub:
```
docker run --rm -it -e OPENAI.KEY=<your key> -e GITHUB.USER_TOKEN=<your token> khulnasoft/pr-insight:latest --pr_url <pr_url> review
```

- For GitLab:
```
docker run --rm -it -e OPENAI.KEY=<your key> -e CONFIG.GIT_PROVIDER=gitlab -e GITLAB.PERSONAL_ACCESS_TOKEN=<your token> khulnasoft/pr-insight:latest --pr_url <pr_url> review
```

Note: If you have a dedicated GitLab instance, you need to specify the custom url as variable:
```
docker run --rm -it -e OPENAI.KEY=<your key> -e CONFIG.GIT_PROVIDER=gitlab -e GITLAB.PERSONAL_ACCESS_TOKEN=<your token> -e GITLAB.URL=<your gitlab instance url> khulnasoft/pr-insight:latest --pr_url <pr_url> review
```

- For BitBucket:
```
docker run --rm -it -e CONFIG.GIT_PROVIDER=bitbucket -e OPENAI.KEY=$OPENAI_API_KEY -e BITBUCKET.BEARER_TOKEN=$BITBUCKET_BEARER_TOKEN khulnasoft/pr-insight:latest --pr_url=<pr_url> review
```

For other git providers, update CONFIG.GIT_PROVIDER accordingly, and check the `pr_insight/settings/.secrets_template.toml` file for the environment variables expected names and values.

---


If you want to ensure you're running a specific version of the Docker image, consider using the image's digest:
```bash
docker run --rm -it -e OPENAI.KEY=<your key> -e GITHUB.USER_TOKEN=<your token> khulnasoft/pr-insight@sha256:71b5ee15df59c745d352d84752d01561ba64b6d51327f97d46152f0c58a5f678 --pr_url <pr_url> review
```

Or you can run a [specific released versions](https://github.com/Khulnasoft/pr-insight/blob/main/RELEASE_NOTES.md) of pr-insight, for example:
```
khulnasoft/pr-insight@v0.9
```

---

## Run from source

1. Clone this repository:

```
git clone https://github.com/Khulnasoft/pr-insight.git
```

2. Navigate to the `/pr-insight` folder and install the requirements in your favorite virtual environment:

```
pip install -e .
```

*Note: If you get an error related to Rust in the dependency installation then make sure Rust is installed and in your `PATH`, instructions: https://rustup.rs*

3. Copy the secrets template file and fill in your OpenAI key and your GitHub user token:

```
cp pr_insight/settings/.secrets_template.toml pr_insight/settings/.secrets.toml
chmod 600 pr_insight/settings/.secrets.toml
# Edit .secrets.toml file
```

4. Run the cli.py script:

```
python3 -m pr_insight.cli --pr_url <pr_url> review
python3 -m pr_insight.cli --pr_url <pr_url> ask <your question>
python3 -m pr_insight.cli --pr_url <pr_url> describe
python3 -m pr_insight.cli --pr_url <pr_url> improve
python3 -m pr_insight.cli --pr_url <pr_url> add_docs
python3 -m pr_insight.cli --pr_url <pr_url> generate_labels
python3 -m pr_insight.cli --issue_url <issue_url> similar_issue
...
```

[Optional] Add the pr_insight folder to your PYTHONPATH
```
export PYTHONPATH=$PYTHONPATH:<PATH to pr_insight folder>
```