# Workarounds for Halo Custom Edition using Lua

Different files for fixing/tweaking/restoring Halo Custom Edtion functionality mainly based in Lua scripts
for Chimera.

## Available scripts
- **Dynamic Reverb Sound**:
  Provides reverberation for sounds that does not have it by default like melee, reload, ready and grenade throw.
- **FP Animation Permutation**:
  Reimplements first person animation permutation by using the OpenSauce animation label format.

## Changelog

There is changelog markdown file here in this repository to checkout changes for every script version.

## Warning

- Most of these files are using tag paths to do their work so they are not supposed to work on protected maps.

- All the scripts in root are release files, you can drag and drop it in your global scripts folder and they must work.

- Scripts in the src folder are for developing and they need to be bundled with other libraries to work.
