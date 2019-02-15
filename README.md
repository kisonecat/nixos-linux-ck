# Linux-CK packaged for NixOS

The `kernel.nix` and the associated patches make it possible to use Con Kolivas' ck patchset in NixOS.

## How to use

You'll need to generate a `kernel.config` file.

Then your `configuration.nix` might begin like this:

```
{ config, pkgs, fetchurl, ... }:

{
  imports = [
    ./kernel.nix  # the file from this repository
 ];

```
