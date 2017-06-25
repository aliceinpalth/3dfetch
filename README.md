![](http://i.imgur.com/49vYhos.png)

Similar to Linux's screenfetch script, but unsigned and executed on a Nintendo 3DS. RSF file based off of [this dummy RSF](https://gist.github.com/mid-kid/d9c4ce50407c71ec9ef3). Mainly developed as a method for learning 3DS homebrew toolkits, libraries, and build environments.

# Features
- Pretty colors!
- Cycle through text colors using the d-pad, and background colors using the L and R buttons
- Press the A button to take a screenshot, saved to the SD card root as ` 3dfetch_day_month_year_x.jpg `
- All information dynamically grabbed from 3DS' hardware
- New 3DS and old 3DS compatible
- Use in tandem with [imgurup-3ds](https://github.com/Pirater12/imgurup-3ds) for an easy sharing experience

# Screenshots
![3dfetch running an old 3DS XL](http://i.imgur.com/8wUNZoS.png)

3dfetch running an old 3DS XL with default colors.

# Where to get it
Check the [releases page](https://github.com/yyualice/3dfetch/releases). Or get it on titledb within FBI.

# Building from source
- You will need [makerom](https://github.com/profi200/Project_CTR/releases) in your `$PATH` to create the CIA.
- You will need [3ds-tool](https://github.com/dnasdw/3dstool/releases) in your `$PATH` to recompile the ROM filesystem.
- And you will also need the [bannertool](https://github.com/Steveice10/bannertool) to create the banner and icon files.

- This software uses a fork of lpp-3ds found [here](https://github.com/daedreth/lpp-3ds) which expanded functionality.
The compiled binary (lpp-3ds.elf) is already part of the repository, we strongly suggest against attempts to compile it yourself,
if such necessity arises, visit the forks repository for instructions.

Once you have all the requirements, simply run the ` build_cia.sh ` script.
