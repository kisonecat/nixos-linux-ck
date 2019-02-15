{ config, pkgs, fetchpatch, ... }:

let
  version = "4.19.13";
  linux_ck = pkgs.linuxManualConfig {
    inherit version;
    
    src = pkgs.fetchurl {
      url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
      sha256 = "1hn0mimh0x13gin28l6dfic21533ja8zlihkg43c8gz183y7f2pm";
    };

    inherit (pkgs) stdenv;
    
    #stdenv = (overrideCC gccStdenv gcc8);
    
    modDirVersion = "4.19.13-ck1";
    allowImportFromDerivation = true;
    configfile = ./kernel.config;
    kernelPatches = [
      { name="fix-kconfig";
        patch=./fix-kconfig.patch;
      }
      { name="ck";
        patch=pkgs.fetchpatch {
          name="patch-4.19-ck1.xz";
          url = http://ck.kolivas.org/patches/4.0/4.19/4.19-ck1/patch-4.19-ck1.xz;
          sha256 = "77863d16a08e1b3c726b6c965f1bb7c672bd7317776810121062b73f9ea26780";
        };
      }
      { name="fix-smt-error";
        patch=./fix-smt-error.patch;
      }
      pkgs.kernelPatches.bridge_stp_helper
      pkgs.kernelPatches.modinst_arg_list_too_long    
    ];  
  };

  linuxPackages_ck = pkgs.recurseIntoAttrs ( pkgs.linuxPackagesFor linux_ck );
in
{
  boot.kernelPackages = linuxPackages_ck;  
}
