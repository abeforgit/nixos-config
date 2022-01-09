{ config, lib, pkgs, ... }:
with lib;
let cfg = config.custom.rustup;
in {
  options.custom.rustup = {
    enable = mkOption {
      example = true;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${config.custom.user} = { pkgs, ... }: {
      home.packages = with pkgs; [
        llvmPackages_latest.llvm
        llvmPackages_latest.bintools
        zlib.out
        rustup
        xorriso
        grub2
        qemu
        llvmPackages_latest.lld
        python3
      ];
      home.sessionPath = [ "$HOME/.local/bin" ];
      home.sessionVariables = {
        RUSTBIN = "$HOME/.local/bin";
        LIBCLANG_PATH =
          makeLibraryPath [ pkgs.llvmPackages_latest.libclang.lib ];
        RUSTFLAGS =
          (builtins.map (a: "-L ${a}/lib") [ pkgs.libvmi ]);
        BINDGEN_EXTRA_CLANG_ARGS =
          # Includes with normal include path
          (builtins.map (a: ''-I"${a}/include"'') [
            pkgs.libvmi
            pkgs.glibc.dev
          ])
          # Includes with special directory paths
          ++ [
            ''
              -I"${pkgs.llvmPackages_latest.libclang.lib}/lib/clang/${pkgs.llvmPackages_latest.libclang.version}/include"''
            ''-I"${pkgs.glib.dev}/include/glib-2.0"''
            "-I${pkgs.glib.out}/lib/glib-2.0/include/"
          ];
      };
    };
  };
}
