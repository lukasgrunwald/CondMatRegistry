#=
Checks that all .toml files can be properly read
Adapted from https://github.com/HolyLab/HolyLabRegistry
=#
using Pkg.TOML
using Test

file_type(x) = split(x, ".")[end]

d = @__DIR__
cd(d*"/..")

contents = filter(x -> !in(x, [".git", "src", "test"]), readdir())
top_level_files = filter(x -> isfile(x), contents)
top_level_folders = filter(x -> isdir(x), contents)

# Check top level files
print("Checking top level files")
for f in top_level_files
    if file_type(f) == "toml"
        # If something is wrong this throws a .toml parse error
        @test_nowarn TOML.parsefile(f)
    end
end
print("✓\n")

# Check packages in folders
for c in top_level_folders
    # Move to different letters and read packages
    println("Checking folder /$c")

    cd(c) do # Enter the folder
        packages = readdir(".")

        for p in packages
            print("  -> $p")

            cd(p) do
                files = readdir(".")
                for ff in files
                    file_type(ff) == "toml" && @test_nowarn TOML.parsefile(ff)
                end

            end
        end
        print(" ✓ \n")
    end
end
