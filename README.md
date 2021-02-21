# Workarounds for Halo Custom Edition using Lua

Different files for fixing/tweaking/restoring Halo Custom Edtion functionality mainly based in Lua scripts
for Chimera.

# Building
Some scripts on this repository are modular projects that need to be bundled with other lua
modules to work, you can bundle them with [Mercury](https://github.com/Sledmine/Mercury) using the
following commands:

```
cd fp_animation_permutation
mercury luabundle
```
This will create a bundled script on the root of the repository that is distributable and functional.

**NOTE:** If the script folder has a `bundle.json` file on it, it is indeed a bundeable script.


# Changelog
You can check out the [changelog](CHANGELOG.md) for scripts from this repository.

## Warning
- Most of these files are using tag paths to do their work so they are not supposed to work on protected maps.
- Scripts in every source folder are for developing and they need to be bundled with other modules to work.
- All the bundled scripts are in the root of the repository, you can drag and drop them in your global scripts folder and they should work.
