![](http://i.imgur.com/49vYhos.png)

![Github Releases](https://img.shields.io/github/downloads/aliceinpalth/3dfetch/latest/total.svg?style=flat-square)

Similar to Linux's screenfetch script, but unsigned and executed on a Nintendo 3DS. RSF file based off of [this dummy RSF](https://gist.github.com/mid-kid/d9c4ce50407c71ec9ef3). Mainly developed as a method for learning 3DS homebrew toolkits, libraries, and build environments.

# Features
- Pretty colors!
- Cycle through text colors using the d-pad, and background colors using the L and R buttons
- Press the A button to take a screenshot, saved to the SD card root as ` 3dfetch_day_month_year_x.jpg `
- All information dynamically grabbed from 3DS' hardware
- New 3DS and old 3DS compatible
- Press select for a configuration menu
- Use in tandem with [imgurup-3ds](https://github.com/Pirater12/imgurup-3ds) for an easy sharing experience

# Screenshots
![3dfetch running a New 3DS](http://i.imgur.com/qhMDawH.png)

3dfetch running on a New 3DS with Luma CFW.

# Where to get it
Check the [releases page](https://github.com/yyualice/3dfetch/releases) for a CIA file / QR code. Or get it on TitleDB within FBI.

# Optional configuration
3dfetch can optionally be configured by creating a file at the root of your SD card called `3dfetch.conf`. At present, the following options are available:

`showAnimation:true | false` to enable/disable the little shell animation on startup.

`showSplash:true | false` to enable/disable the CFW splash on the bottom

`showCFW:true | false` to enable/disable CFW detection

# Reporting issues
Is your CFW not being recognized properly? Is the amount of free space reported incorrectly? Or maybe you came across an error.

Create an issue on GitHub. Don't forget to add your CFW, what version you are on and which 3dfetch version/commit you were using.

# Building from source
## Requirements
- [`makerom`](https://github.com/profi200/Project_CTR/releases) to create the CIA.
- [`3ds-tool`](https://github.com/dnasdw/3dstool/releases) to recompile the ROM filesystem.
- [`bannertool`](https://github.com/Steveice10/bannertool) to create the banner and icon files.
- A fork of lpp-3ds found [here](https://github.com/daedreth/lpp-3ds) which includes expanded functionality. The compiled binary (`lpp-3ds.elf`) is included in the repository, we strongly suggest against attempts to compile it yourself, if such necessity arises, visit the forks repository for instructions.

## Compiling
### CIA
Run `make` to build an installable CIA-file.

### 3dsx
If you wish to use 3dfetch inside the Homebrew Launcher and thus require a 3dsx file, run `make 3dfetch.3dsx` instead and merge the `/3ds` folder with the one found on your SD card.

### Network-sent 3dsx
If you would like to have 3dfetch be sent via network to your console, open up the Homebrew Launcher, press `Y` and run `make 3dsx` instead.
