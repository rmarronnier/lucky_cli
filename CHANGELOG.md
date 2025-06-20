# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Support for Bun package manager as an alternative to Yarn/npm
- Comprehensive README documentation with troubleshooting guide
- Database configuration security improvements and documentation
- Sample .env file template with configuration examples
- Better error handling in BuildAndRunTask with helpful error messages
- CHANGELOG.md for tracking project changes

### Changed
- Replaced Yarn with Bun in all project templates and configurations
- Updated CI workflows to use Bun instead of Yarn
- Updated Docker configurations to install Bun
- Improved error messages with context and helpful tips
- Enhanced type safety by replacing `.as()` casts with proper nil handling

### Fixed
- Fixed critical shell injection vulnerabilities in Process.run calls
- Fixed security issues in generator_helpers.cr run_command method
- Fixed shell injection in lucky.cr task execution
- Fixed shell injection in BuildAndRunTask compilation and execution

### Security
- All shell commands now use safe Process.run with command/args separation
- Added proper argument parsing to prevent command injection
- Improved secret key generation documentation

## Previous Releases

For releases before this changelog was created, please see the [GitHub releases page](https://github.com/luckyframework/lucky_cli/releases).