# godot-4-ci
*This is a fork of [abarichello/godot-ci](https://github.com/abarichello/godot-ci) for Godot 4 beta*

Docker image to export Godot 4 Beta games and deploy to GitLab/GitHub Pages and Itch.io using GitLab CI and GitHub Actions.

<img src="https://i.imgur.com/3z4Sxhd.png" width=450>

## Docker Hub
https://hub.docker.com/r/benpm/godot-4-ci/

## How To Use
`.gitlab-ci.yml` and `.github/workflows/godot-4-ci.yml` are included in this project as reference.

## Environment configuration

First you need to remove unused jobs/stages from the `.yml` file you are using as a template(`.gitlab-ci.yml` or `.github/workflows/godot-4-ci.yml`).<br>
Then you have to add these environments to a configuration panel depending on the chosen CI and jobs:
- **GitHub**: `https://github.com/<username>/<project-name>/settings/secrets`
- **GitLab**: `https://gitlab.com/<username>/<repo-name>/settings/ci_cd`

### GitHub Pages

Secrets needed for a GitHub Pages deploy via GitLab CI:

|Variable|Description|Example|
|-|-|-|
| REMOTE_URL | The `git remote` where the web export will be hosted (in this case GitHub), it should contain your [deploy/personal access token](https://github.com/settings/tokens)|`https://<github username>:<deploy token>@github.com/<username>/<repository>.git`
| GIT_EMAIL | Git email of the account that will commit to the `gh-pages` branch. | `email@example.com`
| GIT_USERNAME | Username of the account that will commit to the `gh-pages` branch. | `username`

Others variables are set automatically by the `gitlab-runner`, see the documentation for [predefined variables](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html).<br>

### Itch.io

Deployment to Itch.io is done via [Butler](https://itch.io/docs/butler/).<br>
Secrets needed for a Itch.io deploy via GitLab CI:

|Variable|Description|Example|
|-|-|-|
| ITCHIO_USERNAME | Your username on Itch.io, as in your personal page will be at `https://<username>.itch.io` |`username`
| ITCHIO_GAME | the name of your game on Itchio, as in your game will be available at `https://<username>.itch.io/<game>`  |`game`
| BUTLER_API_KEY | An [Itch.io API key](https://itch.io/user/settings/api-keys) is necessary for Butler so that the CI can authenticate on Itch.io on your behalf. **Make that API key `Masked`(GitLab CI) to keep it secret** |`xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

## Troubleshoot
#### Problems while exporting

- **Check that the export presets file (`export_presets.cfg`) is committed to version control.** In other words, `export_presets.cfg` must *not* be in `.gitignore`.
  - Make sure you don't accidentally commit Android release keystore or Windows codesigning credentials. These credentials cannot be revoked if they are leaked!
- Check that the export names on `export_presets.cfg` match the ones used in your CI script **(case-sensitive)**. Export preset names that contain spaces must be written within quotes (single or double).
- Check the paths used in your CI script. Some commands may be running in the wrong place if you are keeping the project in a folder (like the `test-project` template) or not.

## Additional Resources
Greenfox has an [excellent repo](https://gitlab.com/greenfox/godot-build-automation) that is also for automating Godot exports.
