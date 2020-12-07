# Unity CI - Docker

Source of CI specialised docker images for Unity.

## Base

See the [base readme](./base/README.md) for base image usage.

## Hub

See the [hub readme](./hub/README.md) for hub image usage. 

## Editor

See the [editor readme](./editor/README.md) for editor image usage.

## Community

Feel free to join us on
<a href="http://unity-ci.com/discord"><img height="30" src="media/Discord-Logo.svg" alt="Discord" /></a>
and engage with the community.

## Contributing

To contribute, please see the [development readme](./DEVELOPMENT.md) 
after you agree with our [code of conduct](./CODE_OF_CONDUCT.md) 
and have read the [contribution guide](./CONTRIBUTING.md).

## License

[MIT license](./LICENSE)

<br><br><br><br>

# :eight_spoked_asterisk: Changes from [unityci/docker](https://github.com/Unity-CI/docker)

* :warning: Removed features
  * backend-versioning server (Use `workflow_dispatch` and [unity-changeset](https://www.npmjs.com/package/unity-changeset) instead)
  * Unity project for test (Move to another branch)
* Release automatically with [semantic-release](https://github.com/semantic-release/semantic-release)
  * The release is [based on a committed message](https://www.conventionalcommits.org/)
  * Tagging based on [Semantic Versioning 2.0.0](https://semver.org/)
    * Use `v0.7.0` insted of `v0.7`
* Run workflow manually or automatically
  * Build all images on tag pushed
  * Build all editor images every 3 days
  * Run workflow manually from [Actions page](../../actions).
    * [:arrow_forward: Build All](../../actions?query=workflow%3A%22Build+All%22)
    * [:arrow_forward: Build Editor All](../../actions?query=workflow%3A%22Build+Editor+All%22)
    * [:arrow_forward: Build Editor](../../actions?query=workflow%3A%22Build+Editor%22)
* Fast skip earlier builds of images that already exist
  * The image building will be skipped within 1 min per minor/patch version
* Support environment variables file (`.gitgub/workflow/.env`) for build settings
  * `BASE_IMAGE`
  * `HUB_IMAGE`
  * `EDITOR_IMAGE`
  * `MINIMUM_UNITY_VERSION`
  * `IGNORED_UNITY_VERSIONS`
    * The build specifies an unstable version and prevents flooding of the error notifications
  * `UNITY_MODULES`
  * `IGNORED_IMAGE_TAGS`
* Support for alpha/beta versions of Unity (e.g. 2020.2.0b, 2021.1.0a)
  * :warning: **NOTE: The versions removed from [Unity beta](https://unity3d.com/beta) will not be updated**
* Grouping workflows in a minor version (2018.3, 2018.4, ...)
  * Improve the visibility of actions page
  * Easy to retry
  * A minor version will be expanded to patch versions and [fill dynamic matrix](https://github.blog/changelog/2020-04-15-github-actions-new-workflow-features/) to build image

<br><br>

## :hammer: How to build images

### 1. :pencil2: Setup build configuration file (`.github/workflows/.env`)

Overwrite `BASE_IMAGE`, `HUB_IMAGE` and `EDITOR_IMAGE` in `.github/workflows/.env`.

```sh
# Images
BASE_IMAGE=<docker_user_name>/<base_name>
HUB_IMAGE=<docker_user_name>/<hub_name>
EDITOR_IMAGE=<docker_user_name>/<editor_name>

# For example:
# BASE_IMAGE=mobsakai/unity_base
# HUB_IMAGE=mobsakai/unity_hub
# EDITOR_IMAGE=mobsakai/unity_editor
```

Overwite `MINIMUM_UNITY_VERSION`, `IGNORED_UNITY_VERSIONS`, `UNITY_MODULES` and `IGNORED_IMAGE_TAGS` if you want.

```sh
# Minimum Unity version
MINIMUM_UNITY_VERSION=2018.3

# Ignored Unity versions (Regular expressions)
IGNORED_UNITY_VERSIONS<<EOD
^2020.2.0a
EOD

# Unity modules (Regular expressions)
UNITY_MODULES<<EOD
^base$
^linux-il2cpp$
^windows-mono$
^mac-mono$
^ios$
^android$
^webgl$
EOD

# Ignored image tags (Regular expressions)
IGNORED_IMAGE_TAGS<<EOD
^2018.*linux-il2cpp
^2019.1.*linux-il2cpp
^2019.2.*linux-il2cpp
EOD
```

<br><br>

### 2. :key: Setup repository secrets

| Name                 | Description                                            |
| -------------------- | ------------------------------------------------------ |
| `DOCKERHUB_USERNAME` | [Docker Hub][] user name.                              |
| `DOCKERHUB_TOKEN`    | [Docker Hub][] access token.                           |
| `GH_TOKEN`     | [Github parsonal access token][] to dispatch workflow. |

[Docker Hub]: https://hub.docker.com/
[Github parsonal access token]: https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token

<br><br>

### 3. :arrow_forward: Run workflows (automatically)

All workflows will be run automatically.

| Workflow | Description | Trigger | Inputs |
| -- | -- | -- | -- |
| `Build All`        | Build all images.<br>(base/hub/editor) | Tag pushed | - |
| `Build Editor All` | Build all editor images.<br> | Every 3 days | **version:** Unity major/minor/patch version to build. <sup>[1](#fn1)</sup><br>*e.g. 2018.3, 2018*<br>**modules:** Modules to build. <sup>[2](#fn2)</sup><br>*e.g. base,ios,android,...* |
| `Build Editor`     | Build editor images with a specific unity minor/patch version | Dispatched from `Build Editor All` | **version:** *(Required)* Unity minor/patch version to build. <br>*e.g. 2018.3, 2018.4.0f1*<br>**modules:** Modules to build. <sup>[1](#fn1)</sup><br>*e.g. base,ios,android,...* |

[Actions page]: https://

<a name="fn1">1</a>: If empty, build all available versions.   
<a name="fn2">2</a>: Multiple values must be separated by a comma (`,`).  

<br><br>

### 4. :arrow_forward: Run workflows (manually)

You can run them manually from the [Actions page](../../actions).

**NOTE: You need permissions to run the workflow.**

* [:arrow_forward: Build All](../../actions?query=workflow%3A%22Build+All%22)
* [:arrow_forward: Build Editor All](../../actions?query=workflow%3A%22Build+Editor+All%22)
* [:arrow_forward: Build Editor](../../actions?query=workflow%3A%22Build+Editor%22)

![](https://user-images.githubusercontent.com/12690315/100829081-e454ac00-34a3-11eb-9aab-730e6a861c66.png)

<br><br><br>

## :wrench: Use custom image on Github Actions

```yml
```

https://unity-ci.com/docs/github/getting-started

https://github.com/webbertakken/unity-actions

Use with `CustomImage` parameter.

* [Request Activation File (Marketplace)][RAF_Marketplace] ![][RAF_R] ![][RAF_PR]
  * [actions.yml][RAF_actions.yml]
  * [Repository][RAF_Repository]
* [Test runner (Marketplace)][TR_Marketplace] ![][TR_R] ![][TR_PR]
  * [actions.yml][TR_actions.yml]
  * [Repository][TR_Repository]
* [Builder (Marketplace)][B_Marketplace] ![][B_R] ![][B_PR]
  * [actions.yml][B_actions.yml]
  * [Repository][B_Repository]

[RAF_R]: https://img.shields.io/github/v/release/webbertakken/unity-request-activation-file
[RAF_PR]: https://img.shields.io/github/v/release/webbertakken/unity-request-activation-file?include_prereleases
[RAF_actions.yml]: https://github.com/webbertakken/unity-request-activation-file/blob/main/action.yml
[RAF_Repository]: https://github.com/webbertakken/unity-request-activation-file
[RAF_Marketplace]: https://github.com/marketplace/actions/unity-request-activation-file

[TR_R]: https://img.shields.io/github/v/release/webbertakken/unity-test-runner
[TR_PR]: https://img.shields.io/github/v/release/webbertakken/unity-test-runner?include_prereleases
[TR_actions.yml]: https://github.com/webbertakken/unity-test-runner/blob/master/action.yml
[TR_Repository]: https://github.com/webbertakken/unity-test-runner
[TR_Marketplace]: https://github.com/marketplace/actions/unity-test-runner

[B_R]: https://img.shields.io/github/v/release/webbertakken/unity-builder
[B_PR]: https://img.shields.io/github/v/release/webbertakken/unity-builder?include_prereleases
[B_actions.yml]: https://github.com/webbertakken/unity-builder/blob/main/action.yml
[B_Repository]: https://github.com/webbertakken/unity-builder
[B_Marketplace]: https://github.com/marketplace/actions/unity-builder

<br><br><br>

## :mag: FAQ

### :exclamation: Error on time limit or API limit

Because the combination of the editor build is so large, the builds may fail due to the time limit of github actions (<6 hours) or API limitations.

Run `Build Editor All` workflow manually after all jobs are done.

### :exclamation: Missing library for editor

If a missing library is found, fix the `editor/Dockerfile` in the `fix` branch and run `Build Editor` workflow manually to test.

If the problem is solved, fix the `base/Dockerfile` in the `main` branch.

<br><br><br>

## :bulb: Next plans

* Test the build for each patch versions (2018.3.0, 2018.3.1, ...)
  * May be unnecessary for stable versions (2018.x, 2019.x)
  * Build a simple project for all platforms
  * Inspect the missing library
* Notify the error summary to mail, Slack or Discord
* Release of Unity activation lisence file (*.alf)
  * Upload as the release assets for all versions
* Update docker image description
  * From workflow