# Alien-GGML

`Alien::GGML` finds or builds the [`ggml`](https://github.com/ggml-org/ggml) tensor computation library so that it can be consumed by Perl and `PDL` distributions (including `PDL::ML` backends).

If `ggml` is already installed on your system and discoverable via `pkg-config`, `Alien::GGML` uses the system library; otherwise it downloads `ggml` v1.1.0 and builds it from source using CMake (`Alien::cmake3`).

## Installation

### Default (auto-detect system, fall back to share build)

```sh
cpanm Alien::GGML
```

### System vs. Share Install

Control whether `Alien::GGML` uses a system library or builds from source via `ALIEN_INSTALL_TYPE`:

- **Linux / macOS**:
  ```sh
  ALIEN_INSTALL_TYPE=system cpanm Alien::GGML
  ALIEN_INSTALL_TYPE=share  cpanm Alien::GGML
  ```
- **Windows (PowerShell)**:
  ```powershell
  $env:ALIEN_INSTALL_TYPE = 'system'; cpanm Alien::GGML
  $env:ALIEN_INSTALL_TYPE = 'share';  cpanm Alien::GGML
  ```

#### Installing `ggml` as a System Package

- **Debian / Ubuntu (`apt`)**:
  ```sh
  sudo apt-get update && sudo apt-get install -y libggml-dev pkg-config
  ```
  *(If `libggml-dev` is not yet packaged for your release, use `ALIEN_INSTALL_TYPE=share`.)*
- **macOS (`brew`)**:
  ```sh
  brew install pkg-config cmake
  # If a ggml formula is available in your tap, install it and ensure PKG_CONFIG_PATH includes it;
  # otherwise Alien::GGML will build from source in share mode.
  ```
- **Windows (`vcpkg`)**:
  ```powershell
  vcpkg install ggml
  # Add the vcpkg pkgconfig directory to PKG_CONFIG_PATH, or use ALIEN_INSTALL_TYPE=share.
  ```

## Usage

### XS (`Makefile.PL` with `Alien::Base::Wrapper`)

```perl
use ExtUtils::MakeMaker;
use Alien::Base::Wrapper ();

WriteMakefile(
    Alien::Base::Wrapper->new('Alien::GGML')->mm_args2(
        NAME => 'PDL::ML::Engine::GGML',
    ),
);
```

### FFI (`FFI::Platypus`)

```perl
use FFI::Platypus 2.00;
use Alien::GGML;

my $ffi = FFI::Platypus->new(
    api => 2,
    lib => [ Alien::GGML->dynamic_libs ],
);
```

*(Note: `share` installs build static archives for XS linking; `dynamic_libs` is populated when a system shared library is used.)*

## Inspecting Your Installation

Run the bundled inspection script:

```sh
perl examples/check_alien.pl
```

## Documentation

For complete documentation and tutorials, see the POD:

```sh
perldoc Alien::GGML
```
