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
| If a package was `dev`'ed at an earlier time, i.e. already has an entry under `~/.julia/dev`, `dev Package` does not pull from the repository automatically. We can either pull manually to update to the latest changes upstream, or update the registry to the new version of the package (this should happen automatically upon pushing the changes to the package in the future).     |

To add or update packages in the registry, `dev` the package to be added and call (for updates the registry entry can be omitted)
```julia
register("MyPackage"; registry = "CondMatRegistry")
```
The most convenient workflow for this is to have a local environment in the `dev` folder that has the packages `dev`ed via the local path.

## Using local repository in CI

Example for a CI setup in the `/template` folder. The relevant code snippet is

```yaml
...
      - uses: lukasgrunwald/julia-buildpkg@localregistry
        with:
          localregistry: >- # Collect URL's into space seperated string
            https://github.com/lukasgrunwald/CondMatRegistry.git
          token: ${{ secrets.GITHUB_TOKEN }}
...
```
which adds the local registry to the project, using the automatic GitHub Token authentication. This allows the loading of public packages in the local repository. To load private packages, replace `${{ secrets.GITHUB_TOKEN }}` by a (fine-grained) [personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) that has access to the desired repositories. 

## RoadMap

Github (actions) and continuous integration:
- [ ] Template for Github action to automatically register new package version in local repo
- [x] Template for CI to load packages from local repository (See [#38](https://github.com/julia-actions/julia-buildpkg/pull/38))

Julia VsCode extension (ideas):
- [ ] Prompt to bump version of package upon git pushing changes.
- [ ] Pull from upstream for all `dev`'ed packages