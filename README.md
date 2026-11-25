# c-build-zig

A C17 starter with Zig 0.17.1. Use `src/main.c` as the entry point. The build links the vendored cJSON library. The tests use the vendored Unity library.

## Start a project

On GitHub, select **Use this template**, then **Create a new repository**. Clone the new repository. To change the executable name, update `b.addExecutable` in `build.zig` and the paths in `.vscode/launch.json`.

## Install Zig

This template uses Zig **0.17.1**. If `zig version` already prints `0.17.1`, go to [Build, run, and test](#build-run-and-test).

### macOS with Homebrew

```sh
brew install zig
zig version
```

Homebrew installs the current stable release. If the version is different, use the direct download below. [Homebrew Zig formula](https://formulae.brew.sh/formula/zig)

### Direct download for macOS, Linux, or Windows

1. Download the **0.17.1** archive for your operating system and CPU. Choose `aarch64` for Apple Silicon or ARM64 and `x86_64` for 64-bit Intel or AMD. [Official Zig downloads](https://ziglang.org/download/)
2. Extract the full archive to a folder you want to keep. The folder must contain `zig` or `zig.exe` and the `lib` directory.
3. Add that folder to your `PATH`. On macOS or Linux, add the line below to `~/.zshrc` or `~/.bashrc` and replace the example path. On Windows, add the folder to your user **Path** in **Environment Variables**.

   ```sh
   export PATH="/path/to/extracted/zig-folder:$PATH"
   ```

4. Open a new terminal and run `zig version`. It should print `0.17.1`. [Zig installation guide](https://ziglang.org/learn/getting-started/)

## Build, run, and test

Run these commands from the project root.

```sh
zig version
zig build
zig build run
zig build test
```

The Debug executable is `zig-out/bin/c-build-zig` on macOS and Linux. On Windows, it has an `.exe` suffix. The program prints `Hello from C! 20 + 22 = 42`. The tests check positive, negative, and zero inputs.

Use a separate prefix for Release so both builds are available.

```sh
zig build -Doptimize=ReleaseFast -p zig-out/release
zig build test -Doptimize=ReleaseFast
./zig-out/release/bin/c-build-zig
```

Add new `.c` files to the matching source list in `build.zig`. Put your headers in `include/`. If you add a header search path, update `compile_flags.txt` so clangd can find it.

## LazyVim

Start Neovim from the project root.

```sh
nvim src/main.c
```

| Command or key | Action |
| --- | --- |
| `:Zig build` | Build the Debug executable. |
| `:Zig run` or F10 | Build and run. |
| `:Zig test` | Run the Unity tests. |
| `:Zig test -Doptimize=ReleaseFast` | Run the optimized tests. |
| `K` or `gd` | Show help for a symbol or go to its definition. |

The Zig commands open a terminal with the build output. Press Esc twice to leave terminal mode, then `q` to hide the terminal.

To debug, run `:Zig build`. Put a breakpoint on the `printf` line with Space d b. Press Space d c and select **Debug c-build-zig**. Press F7 to continue to the breakpoint. Use F8 to step and F1 to inspect a variable.

The project uses `compile_flags.txt` for clangd and `.vscode/launch.json` for CodeLLDB. Your LazyVim commands are in `~/.config/nvim/lua/config/zig-commands.lua`.
