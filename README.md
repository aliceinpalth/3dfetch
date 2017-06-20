# 3dfetch
Similar to Linux's screenfetch script, but unsigned and executed on a Nintendo 3DS. RSF file based off of [this dummy RSF](https://gist.github.com/mid-kid/d9c4ce50407c71ec9ef3). Mainly developed as a method for learning 3DS homebrew toolkits, libraries, and build environments.

# Features
- Cycle through various text colors using the d-pad, and various background colors using the L and R buttons
- All information dynamically grabbed from 3DS' hardware
- A nice way to show off your 3DS' specs/model to your friends
- Use in tandem with [imgurup-3ds](https://github.com/Pirater12/imgurup-3ds) for an easy sharing experience

# Screenshots
![3dfetch running an old 3DS XL](http://i.imgur.com/8wUNZoS.png)

3dfetch running an old 3DS XL with default colors.

# Where to get it
Check the [releases page](https://github.com/yyualice/3dfetch/releases). Or get it on titledb within FBI.

# Requirements
- [lpp-3ds](https://github.com/Rinnegatamante/lpp-3ds) (The .3dsx file to be placed alongside ` index.lua `)
- If building a CIA, [makerom](https://github.com/profi200/Project_CTR/releases) and the .elf from [lpp-3ds](https://github.com/Rinnegatamante/lpp-3ds)
