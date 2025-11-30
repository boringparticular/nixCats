{
  sources ? (import ./npins),
  nixpkgs ? <nixpkgs>,
  system ? (builtins.currentSystem or null),
  pkgs ? (import nixpkgs { inherit system; }),
  nixCats ? sources.nixCats,
  ...
}:
let
  lib = import "${nixpkgs}/lib";
  utils = import nixCats;
  forEachSystem = utils.eachSystem lib.platforms.all;
  luaPath = ./.;
  dependencyOverlays = [
    (utils.standardPluginOverlay sources)
    (import sources.neovim-nightly-overlay)
  ];

  extra_pkg_config = { };

  # see :help nixCats.flake.outputs.categories
  categoryDefinitions =
    {
      pkgs,
      settings,
      categories,
      extra,
      name,
      mkPlugin,
      ...
    }@packageDef:
    {
      # see :help nixCats.flake.outputs.packageDefinitions for info on that section.
      lspsAndRuntimeDeps = {
        general = with pkgs; [
          ripgrep
          fd
          fzf
        ];

        extra = with pkgs; [
          prettierd
          rustfmt

          vale
          markdownlint-cli

          lua-language-server
          stylua

          nix-doc
          nil
          nixd
          nixfmt-rfc-style
        ];

        rust = with pkgs; [
          # NOTE: should i put this in debug?
          vscode-extensions.vadimcn.vscode-lldb
        ];

        zig = with pkgs; [
          zls
        ];

        python = with pkgs; [
          basedpyright
          python3Packages.ruff
        ];

        emmet = with pkgs; [
          emmet-language-server
        ];
      };

      # This is for plugins that will load at startup without using packadd:
      startupPlugins = {
        general = with pkgs.vimPlugins; [
          pkgs.neovimPlugins.lze
          pkgs.neovimPlugins.lzextras
          plenary-nvim
          vim-sleuth
          mini-nvim
          nvim-nio
          snacks-nvim
        ];
      };

      # not loaded automatically at startup.
      # use with packadd and an autocommand in config to achieve lazy loading
      optionalPlugins = {
        general = with pkgs.vimPlugins; [
          oil-nvim
          grug-far-nvim
          nvim-treesitter.withAllGrammars
        ];

        extra = with pkgs.vimPlugins; [
          friendly-snippets
          conform-nvim
          lazydev-nvim
          nvim-lint
          undotree
          trouble-nvim
          fyler-nvim
          flatten-nvim
          noice-nvim
          overseer-nvim
          arrow-nvim
        ];

        lsp = with pkgs.vimPlugins; {
          core = [ nvim-lspconfig ];
          extra = [
          ];
        };

        treesitter.extra = with pkgs.vimPlugins; [
          nvim-treesitter-context
          nvim-treesitter-refactor
        ];

        debug = with pkgs.vimPlugins; [
          nvim-dap
          nvim-dap-ui
          nvim-dap-virtual-text

          nvim-dap-go
          nvim-dap-python
        ];

        emmet = with pkgs.vimPlugins; [
          emmet-vim
          pkgs.neovimPlugins.nvim-emmet
        ];

        notes = with pkgs.vimPlugins; [
          obsidian-nvim
          zk-nvim
        ];

        testing = with pkgs.vimPlugins; [
          neotest
          neotest-elixir
          neotest-golang
          neotest-python
        ];

        lisp = with pkgs.vimPlugins; [
          conjure
          parinfer-rust
        ];

        go = with pkgs.vimPlugins; [
          go-nvim
        ];

        flutter = with pkgs.vimPlugins; [
          flutter-tools-nvim
        ];

        elixir = with pkgs.vimPlugins; [
          elixir-tools-nvim
        ];

        zig = with pkgs.vimPlugins; [
        ];

        rust = with pkgs.vimPlugins; [
          rustaceanvim
        ];

        jujutsu = with pkgs.vimPlugins; [
          vim-jjdescription
          hunk-nvim
          vim-dirdiff
        ];

        markdown = with pkgs.vimPlugins; [
          markdown-preview-nvim
          render-markdown-nvim
        ];
      };

      sharedLibraries = {
        general = with pkgs; [ ];
      };

      environmentVariables = {
        debug = {
          CODELLDB_PATH = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
          LIBLLDB_PATH = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/lldb/lib/liblldb.so";
        };
      };

      extraWrapperArgs = {
        test = [
          ''--set CATTESTVAR2 "It worked again!"''
        ];
      };

      python3.libraries = {
        test = _: [ ];
      };

      extraLuaPackages = {
        test = [ (_: [ ]) ];
      };
    };

  # see :help nixCats.flake.outputs.packageDefinitions
  packageDefinitions =
    let
      baseSettings = {
        suffix-path = true;
        suffix-LD = true;
        host.node.enable = true;
        host.python.enable = true;
        wrapRc = true;
        aliases = [ ];
      };
      baseCategories = {
        general = true;
        extra = true;
        lsp = true;
        treesitter.extra = true;
        debug = true;
        testing = true;
        emmet = true;
        python = true;
        go = true;
        lisp = true;
        elixir = true;
        flutter = true;
        zig = true;
        rust = true;
        markdown = true;
        notes = true;
        jujutsu = true;
        trying = true;
      };
    in
    {
      boringvim =
        {
          pkgs,
          name,
          mkPlugin,
          ...
        }:
        {
          # see :help nixCats.flake.outputs.settings
          settings = baseSettings // {
            wrapRc = false;
            unwrappedCfgPath = "/home/kmies/.config/nvim";
            # IMPORTANT:
            # your aliases may not conflict with your other packages.
            aliases = [
              "bvim"
              "nvim"
              "vim"
              "vi"
            ];
            # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.neovim;
          };
          categories = baseCategories // {
          };
          # anything else to pass and grab in lua with `nixCats.extra`
          extra = { };
        };

      testvim =
        { ... }:
        {
          settings = baseSettings // {
            wrapRc = false;
            unwrappedCfgPath = "/home/kmies/.local/share/chezmoi/dot_config/nvim";
            aliases = [ "tvim" ];
          };
          categories = baseCategories;
        };

      boringwrapped =
        { ... }:
        {
          settings = baseSettings // {
            wrapRc = true;
            aliases = [ "bwim" ];
          };
          categories = baseCategories;
        };

      litevim =
        { ... }:
        {
          settings = baseSettings // {
            wrapRc = true;
            aliases = [ "lvim" ];
          };
          categories = {
            general = true;
          };
        };

      vimscode =
        { ... }:
        {
          settings = baseSettings // {
            wrapRc = true;
            aliases = [ ];
          };
          categories = {
            general = true;
          };
        };
    };

  # We will build the one named nvim here and export that one.
  # you can change which package from packageDefinitions is built later
  # using package.override { name = "aDifferentPackage"; }
  defaultPackageName = "boringvim";
in
forEachSystem (
  system:
  let
    nixCatsBuilder = utils.baseBuilder luaPath {
      inherit
        nixpkgs
        system
        dependencyOverlays
        extra_pkg_config
        ;
    } categoryDefinitions packageDefinitions;
    defaultPackage = nixCatsBuilder defaultPackageName;
    pkgs = import nixpkgs { inherit system; };
  in
  {
    packages = utils.mkAllWithDefault defaultPackage;
    devShells.default = import ./shell.nix { inherit nixpkgs pkgs; };
  }
)
// (
  let
    nixosModule = utils.mkNixosModules {
      moduleNamespace = [ defaultPackageName ];
      inherit
        defaultPackageName
        dependencyOverlays
        luaPath
        categoryDefinitions
        packageDefinitions
        extra_pkg_config
        nixpkgs
        ;
    };

    homeModule = utils.mkHomeModules {
      moduleNamespace = [ defaultPackageName ];
      inherit
        defaultPackageName
        dependencyOverlays
        luaPath
        categoryDefinitions
        packageDefinitions
        extra_pkg_config
        nixpkgs
        ;
    };
  in
  {
    nixosModules.default = nixosModule;

    homeModules.default = homeModule;

    overlays = utils.makeOverlays luaPath {
      inherit
        nixpkgs
        dependencyOverlays
        extra_pkg_config
        ;
    } categoryDefinitions packageDefinitions defaultPackageName;

    inherit
      sources
      utils
      nixosModule
      homeModule
      ;
  }
)
