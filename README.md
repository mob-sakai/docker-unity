:warning: NOTE: This project has been integrated into [mob-sakai/docker](https://github.com/mob-sakai/docker), so we are NOT continuing development in this repository. :warning: 
--

<br><br><br>
<br><br><br>
<br><br><br>
<br><br><br>

# Docker - Unity3d

Source of CI specialised docker images for Unity.

Inspired by [game-ci/docker](https://github.com/game-ci/docker).

<br><br><br><br>

# :eight_spoked_asterisk: Changes from [game-ci/docker](https://github.com/game-ci/docker)

* :warning: Removed features
  * backend-versioning server (Use `workflow_dispatch` and [unity-changeset](https://www.npmjs.com/package/unity-changeset) instead)
  * Unity project for test (Move to another branch)
* Release automatically with [semantic-release](https://github.com/semantic-release/semantic-release)
  * The release is [based on a committed message](https://www.conventionalcommits.org/)
  * Tagging based on [Semantic Versioning 2.0.0](https://semver.org/)
    * Use `v1.0.0` insted of `v1.0`
* Run workflow manually or automatically
  * Build all images on tag pushed
  * Build all editor images every 3 days
  * Run workflow manually from [Actions page](../../actions).
    * [:arrow_forward: Build All](../../actions?query=workflow%3A%22Build+All%22)
    * [:arrow_forward: Build Editor All](../../actions?query=workflow%3A%22Build+Editor+All%22)
    * [:arrow_forward: Build Editor](../../actions?query=workflow%3A%22Build+Editor%22)
* Fast skip earlier builds of images that already exist
* Support environment variables file (`.env`) for build settings
  * `DOCKER_REGISTRY`
  * `DOCKER_USERNAME`
  * `BASE_IMAGE`
  * `HUB_IMAGE`
  * `EDITOR_IMAGE`
  * `MINIMUM_UNITY_VERSION`
  * `IGNORED_UNITY_VERSIONS`
    * The build specifies an unstable version and prevents flooding of the error notifications
  * `IGNORED_IMAGE_TAGS`
* Support for alpha/beta versions of Unity (e.g. 2020.2.0b, 2021.1.0a)
  * :warning: **NOTE: The versions removed from [Unity beta](https://unity3d.com/beta) will not be updated**
* Grouping workflows in a module (base, ios, android, ...)
  * Improve the visibility of actions page
  * Easy to retry

<br><br>

## :hammer: How to build images

### 1. :pencil2: Setup build configuration file (`.env`)

Overwrite `DOCKER_REGISTRY`, `DOCKER_USERNAME`, `BASE_IMAGE`, `HUB_IMAGE` and `EDITOR_IMAGE` in `.env`.

```sh
# Docker Hub: docker.io
# GitHub Container Registory: ghcr.io
DOCKER_REGISTRY=ghcr.io
DOCKER_USERNAME=mob-sakai

# Full image ID
BASE_IMAGE=ghcr.io/mob-sakai/unity_base
HUB_IMAGE=ghcr.io/mob-sakai/unity_hub
EDITOR_IMAGE=ghcr.io/mob-sakai/unity3d
```

Overwite `MINIMUM_UNITY_VERSION`, `IGNORED_UNITY_VERSIONS` and `IGNORED_IMAGE_TAGS` if you want.

```sh
# Minimum Unity version
MINIMUM_UNITY_VERSION=2018.3

# Ignored Unity versions (Regular expressions)
IGNORED_UNITY_VERSIONS="
^2020.2.0a
"

# Ignored image tags (Regular expressions)
IGNORED_IMAGE_TAGS="
^2018.*linux-il2cpp
^2019.1.*linux-il2cpp
^2019.2.*linux-il2cpp
"
```

<br><br>

### 2. :key: Setup repository secrets

| Name           | Description                                              |
| -------------- | -------------------------------------------------------- |
| `DOCKER_TOKEN` | The access token or passward to longin docker registory. |
| `GH_WORKFLOW_TOKEN`     | [Github parsonal access token][] to dispatch workflow.   |

[Github parsonal access token]: https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token

<br><br>

### 3. :arrow_forward: Run workflows (automatically)

All workflows will be run automatically.

| Workflow                          | Description                                      | Trigger                                               | Inputs                                                                               |
| --------------------------------- | ------------------------------------------------ | ----------------------------------------------------- | ------------------------------------------------------------------------------------ |
| `Release`                         | Release new tag.                                 | Pushed commits (include feat or fix) on `main` branch | -                                                                                    |
| `Build All`                       | Build all images.<br>(base/hub/editor)           | A new tag pushed                                      | -                                                                                    |
| `Build Editor`                    | Build editor images with a specific Unity module | Dispatched from `Build All`                           | <br>**module:** Unity module to build. <br>**repoTag:** The repository tag to build. |
| `Request Activation License File` | Request Activation License File                  | Dispatched from `Build Editor (Base)`                 | **repoTag:** The repository tag to build.                                            |

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
jobs:
  unity-test:
    runs-on: ubuntu-latest
    strategy:
      fail-fast: false
      matrix:
        unity:
          [
            2019.3.15f1,
            2019.4.16f1,
            2020.1.16f1,
          ]

    steps:
      - uses: actions/checkout@v2

      - uses: mob-sakai/unity-test-runner@main
        with:
          customImage: ghcr.io/mob-sakai/unity3d:${{ matrix.unity }}
          customParameters: "-nographics"
          testMode: editmode
        env:
          UNITY_LICENSE_FILE: .ulfs/Unity_v${{ matrix.unity }}.ulf

      - uses: actions/upload-artifact@v2
        if: failure()
        with:
          path: "*.alf"
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

Re-run `Build All` workflow manually after all jobs are done.

### :exclamation: Missing library for editor

If a missing library is found, fix the `dockerfiles/editor.Dockerfile` in local.

If the problem is solved, fix the `dockerfiles/base.Dockerfile` in the `main` branch.

<br><br><br>

## :bulb: Next plans

* Test the build for each patch versions (2018.3.0, 2018.3.1, ...)
  * May be unnecessary for stable versions (2018.x, 2019.x)
  * Build a simple project for all platforms
  * Inspect the missing library
* Notify the error summary to mail, Slack or Discord
