# Lucky CLI

[![Lucky CLI Main CI](https://github.com/luckyframework/lucky_cli/actions/workflows/ci.yml/badge.svg)](https://github.com/luckyframework/lucky_cli/actions/workflows/ci.yml)
[![Lucky CLI Weekly CI](https://github.com/luckyframework/lucky_cli/actions/workflows/weekly.yml/badge.svg)](https://github.com/luckyframework/lucky_cli/actions/workflows/weekly.yml)

This is the CLI utility used for generating new [Lucky Framework](https://luckyframework.org) Web applications.

If you're looking for the Lucky core shard, you'll find that at https://github.com/luckyframework/lucky

## Table of Contents

- [Installing the CLI](#installing-the-cli)
- [Usage](#usage)
- [Available Commands](#available-commands)
- [Development](#development)
- [Architecture](#architecture)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## Installing the CLI

To install the Lucky CLI, read [Installing Lucky](https://luckyframework.org/guides/getting-started/installing) guides for your Operating System.

### Quick Install

```bash
# On macOS (requires Homebrew)
brew install luckyframework/homebrew-lucky/lucky

# From source (requires Crystal)
git clone https://github.com/luckyframework/lucky_cli
cd lucky_cli
shards install
crystal build --release -o /usr/local/bin/lucky src/lucky.cr
```

## Usage

### Creating a New Project

```bash
# Start the interactive project wizard
lucky init

# Create a project with all defaults
lucky init.custom my_app

# Create an API-only project  
lucky init.custom my_api --api

# Create a project without authentication
lucky init.custom my_app --no-auth
```

### Development Commands

```bash
# Start the development server (requires Procfile.dev)
lucky dev

# Run a specific task
lucky db.migrate
lucky db.seed.required_data

# See all available tasks in your project
lucky tasks

# Compile tasks for faster execution
lucky tasks.precompile
```

## Available Commands

### Built-in Commands

- `lucky init` - Start the interactive project setup wizard
- `lucky init.custom` - Create a new Lucky project with options
  - `--api` - Generate an API-only project (no HTML/assets)
  - `--no-auth` - Skip authentication setup
- `lucky dev` - Start the development server using Procfile.dev
- `lucky tasks` - List all available tasks in your Lucky project

### Project Tasks

Once inside a Lucky project, you can run various tasks:

- `lucky db.create` - Create the database
- `lucky db.migrate` - Run pending migrations
- `lucky db.rollback` - Rollback the last migration
- `lucky db.seed.required_data` - Seed required data
- `lucky gen.action` - Generate a new action
- `lucky gen.model` - Generate a new model
- `lucky gen.migration` - Generate a new migration
- `lucky gen.page` - Generate a new HTML page
- `lucky gen.component` - Generate a new component
- `lucky gen.resource` - Generate a full resource with model, actions, and pages

## Development

### Building the CLI

*NOTE:* this should be used for working on the CLI and submitting PRs.

1.  Install [Crystal](https://crystal-lang.org/install/) first.
2.  Clone the repo `git clone https://github.com/luckyframework/lucky_cli`
3.  Go to the repo directory `cd lucky_cli`
4.  Install dependencies `shards install`
5.  Run `crystal build -o /usr/local/bin/lucky src/lucky.cr`
    (instead of `/usr/local/bin/` destination you can choose any other directory that in `$PATH`)

Run `which lucky` from the command line to make sure it is installed.

**If you're generating a Lucky web project, [install the required dependencies](https://luckyframework.org/guides/getting-started/installing#install-required-dependencies). Then run `lucky init`**

### Running Tests

```bash
# Run unit tests
crystal spec

# Run integration tests
earthly +integration-specs

# Run all tests
earthly +gh-action-essential

# Update test fixtures
earthly +update-snapshot
```

## Architecture

The Lucky CLI is built with a modular architecture:

### Core Components

- **Generators** - Create new files and projects (`src/generators/`)
- **Templates** - ECR templates for generated code (`src/*_app_skeleton/`)
- **Tasks** - Built-in CLI tasks (`src/lucky.cr`)
- **Helpers** - Shared utilities (`src/lucky_cli/`)

### Template System

Lucky uses [ECR (Embedded Crystal)](https://crystal-lang.org/api/latest/ECR.html) templates to generate project files. Templates are organized by project type:

- `web_app_skeleton/` - Full-stack web applications
- `api_app_skeleton/` - API-only applications  
- `browser_app_skeleton/` - Browser assets and JavaScript
- `base_authentication_app_skeleton/` - Shared authentication code

### Code Generation

The CLI generates code using a combination of:
- ECR templates for dynamic content
- Static file copying for assets
- String manipulation for simple insertions

## Troubleshooting

### Common Issues

#### "lucky: command not found"
- Ensure `/usr/local/bin` is in your PATH
- Try `export PATH=/usr/local/bin:$PATH`
- Verify installation with `which lucky`

#### "Error: Unable to find tasks.cr"
- Make sure you're running lucky commands from a Lucky project root
- Check that `tasks.cr` exists in your project

#### Compilation Errors
- Ensure your Crystal version matches the project requirements
- Run `shards install` to update dependencies
- Check for syntax errors in your tasks.cr file

#### Permission Denied
- Use `sudo` when installing to system directories
- Or install to a user-writable location and add to PATH

### Debug Mode

Set environment variables for debugging:

```bash
# Show detailed compilation errors
lucky db.migrate --error-trace

# Skip the spinner for CI environments
CI=true lucky dev
```

## Contributing

1.  Fork it ( https://github.com/luckyframework/lucky_cli/fork )
2.  Create your feature branch (git checkout -b my-new-feature)
3.  Commit your changes (git commit -am 'Add some feature')
4.  Install [Earthly](https://earthly.dev/)
5.  Update fixtures with `earthly +update-snapshot`
6.  Push to the branch (git push origin my-new-feature)
7.  Check that specs on GitHub Actions CI pass `earthly +gh-action-e2e`
8.  Create a new Pull Request

### Development Guidelines

- Follow Crystal's coding conventions
- Add tests for new features
- Update documentation as needed
- Keep commits focused and atomic
- Write descriptive commit messages

### Release Process

1. Update version in `src/lucky_cli/version.cr`
2. Update CHANGELOG.md with release notes
3. Create a new git tag: `git tag vX.Y.Z`
4. Push tag: `git push origin vX.Y.Z`
5. GitHub Actions will automatically create a release

## Contributors

[paulcsmith](https://github.com/paulcsmith) Paul Smith - Original Creator of Lucky

<a href="https://github.com/luckyframework/lucky_cli/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=luckyframework/lucky_cli" />
</a>

Made with [contrib.rocks](https://contrib.rocks).