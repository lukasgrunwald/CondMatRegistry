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

This makes it possible to have CI and rapid development for interdependent packages hosted in private GitHub repositories

## RoadMap

Github (actions) and continuous integration:
- [ ] Template for Github action to automatically register new package version in local repo
- [ ] Template for CI to load packages from local repository

Julia VsCode extension (ideas):
- [ ] Prompt to bump version of package upon git pushing changes.
- [ ] Pull from upstream for all `dev`'ed packages