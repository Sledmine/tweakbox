# Workarounds for Halo Custom Edition using Lua

Different files for fixing/tweaking/restoring Halo Custom Edtion functionality mainly based in Lua scripts
for Chimera.

# Hosted scripts
- **FP Animation Permutation**:
  Reimplements first person animation permutation by using the OpenSauce animation label format.


# Building
Some of the scripts on this repository are modular projects that need to be bundled with other lua
modules to work, you can bundle them using [Mercury](https://github.com/Sledmine/Mercury) using the
following commands:

```
cd fp_animation_permutation
mercury luabundle
```

This will create a bundled script on the root of the repository that is distributable and functional.

# Changelog
You can check out the [changelog](CHANGELOG.md) for every script on the repository.

## Warning
- Most of these files are using tag paths to do their work so they are not supposed to work on protected maps.
- Scripts in every source folder are for developing and they need to be bundled with other modules to work.
- All the bundled scripts are in the root of the repository, you can drag and drop them in your global scripts folder and they should work.
