See the related [blog post](https://www.hypn.za.net/blog/?p=1272) for more information about these scripts for the NES Classic Mini.

*   [dump-heap.sh](dump-heap.sh) - allows you to dump the memory of the emulator (and all game state)
*   [find-offset.sh](find-offset.sh) - will scan a bunch of dumped heap files for memory addresses that changes the most between the files... you should create a new dump every time a value you're looking for (eg: number of lives) changes and name the file accordingly (eg: 03 lives = 03.bin filename) - note that the actual value in memory might be 1 more or less than the displayed value (such is the case for lives in Super Mario Bros 1)
*   [read-offset.sh](read-offset.sh) - reads a byte from memory at the given offset (in hex), used by many of the other scripts
*   [write-offset.sh](write-offset.sh) - writes a byte to memory at the given offset (in hex), used by many of the other scripts
*   [is-crt-mode.sh](is-crt-mode.sh) - returns true or false, the "crt" video mode affects emulator offsets so this is used to determine which set of offsets to use
*   [get-rom-offset.sh](get-rom-offset.sh) - attempts to find the "NES" (string) header of the rom format in memory to calculate offsets from as working backwards (from the rom in memory) seems to provide more stable offsets that working from the beginning of the emulator's memory
*   [get-mario-info.sh](get-mario-info.sh) - extracts info from the active Super Mario Bros 1 game and outputs to terminal
*   [game-genie-offset.sh](gamegenie-offset.sh) - calculates the correct system memory offset for a game genie's offset address, for memory patching
*   [gamegenie.sh](gamegenie.sh) - uses [HaseeB Mir's Game Genie Decoder](https://github.com/haseeb-heaven/GameGenie_in_C) to convert a game genie code to offset + byte to write and patches the memory accordingly
*   [video-on-mushroom.sh](video-on-mushroom.sh) - shows how normal execution can be interrupted, and a video played (if/when you have the [static ARMHF ffmpeg binary](https://johnvansickle.com/ffmpeg/)) during Super Mario Bros 1 when a mushroom or flower is collected
