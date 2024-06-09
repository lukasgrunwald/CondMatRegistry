# CondMatRegistry

Private repository containing research code and convenience packages that are too specific or not yet developed enough to be published to the General repository, but that are widely used throughout our private codebase.

The registry was created using [LocalRegistry.jl](LocalRegistry.jl) and can be added to any julia installation using
```julia
using Pkg
pkg"registry add git@github.com:lukasgrunwald/CondMatRegistry.git"
```
Once it is added, all packages in the registry can be added to projects using `add` (fixed package version recorded in registry) or `dev` (package in current state will be added to `~/.julia/dev`). Changes of the latter can be conveniently tracked using Revise.

| :warning: WARNING           |
|:----------------------------|
| If a package was `dev`'ed at an earlier time, i.e. already has an entry under `~/.julia/dev`, `dev Package` does not pull from the repository automatically. We can either pull manually to update to the latest changes upstream, or update the registry to the new version of the package.     |

To add or update packages in the registry, `dev` the package to be added and call (for updates the registry entry can be omitted)
```julia
register("MyPackage"; registry = "CondMatRegistry")
```
The most convenient workflow for this is to have a local environment in the `dev` folder that has the packages `dev`ed via the local path. We provide a template for registering new package versions using CI.

## Using local registry in CI

Example for a CI setup in the `/template` folder. Personal registries, e.g. created with [LocalRegistry.jl](https://github.com/GunnarFarneback/LocalRegistry.jl), can be added to the CI using the `localregistry` input option of the `julia-actions/julia-buildpkg` action. If the personal registry as well as packages needed in the current project are public, no additional setup is required if the registry url is specified in https-format.

If the registry contains private packages, or is itself private, the ssh protocol should to be used. The user has to provide the corresponding private SSH-keys to the `ssh-agent` to access packages and registry. This can be conveniently done using the [webfactory/ssh-agent](https://github.com/webfactory/ssh-agent) action. A snippet illustrating the usage of (private) personal registries is shown below

```yaml
...   
      # Adding private SSH keys (only necessary for accessing private packages and/or 
      # when providing Registry-link in ssh format)
      - uses: webfactory/ssh-agent@v0.8.0
        with:
          ssh-private-key: |
            ${{ secrets.PRIVATE_DEPLOY_KEY }}
            ${{ secrets.PRIVATE_DEPLOY_KEY2 }}
      - uses: julia-actions/julia-buildpkg@main # Update @main once new taged version available
        with:
          localregistry: |
            https://github.com/username/PersonalRegistry.git
            git@github.com:username2/PersonalRegistry2.git
          git_cli: false # = JULIA_PKG_USE_CLI_GIT. Options: true | false (default)
...
```

For Julia 1.7 and above, the `git_cli` option can be used to set the `JULIA_PKG_USE_CLI_GIT` [environment flag](https://docs.julialang.org/en/v1/manual/environment-variables/), for additional control of the SSH configuration used by `Pkg` to add/dev packages.

## CI Registrator

The package version in a local-registry hosted on GitHub can be automatically updated with CI, using our [composite action](https://github.com/lukasgrunwald/julia-register-local). To repo calling the action needs to have write access to the local-registries GitHub repository. This can be conventiently achieved using a private part of the deploy key as a repository secret.

A complete example is collected in the `/template` folder and a minimal snippet is shown below

```yaml
name: CI
on:
  push:
    branches:
      - master
jobs:
  test:
    # ... Run unit tests 
  register:
    needs: test # Only run this once test is completed
    name: Register Package
    runs-on: ubuntu-latest
    steps:
    - uses: lukasgrunwald/julia-register-local@master
      with:
        localregistry: git@github.com:lukasgrunwald/CondMatRegistry.git
        ssh_keys: | # Private Deploy key of CondMatRegistry
           ${{ secrets.REGISTRY_DEPLOY }}
```

## RoadMap

Github (actions) and continuous integration:
- [x] Template for CI to load packages from local repository (See [#38](https://github.com/julia-actions/julia-buildpkg/pull/38))
- [x] Template for Github action to automatically register new package version in local repo (see [repo](https://github.com/lukasgrunwald/julia-register-local))

Julia VsCode extension (ideas):
- [ ] Prompt to bump version of package upon git pushing changes.
- [ ] Pull from upstream for all `dev`'ed packages
