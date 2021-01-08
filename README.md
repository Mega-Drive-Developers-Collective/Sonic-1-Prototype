# Sonic 1 Prototype
Research disassembly of the Sonic 1 prototype that was released by Hidden Palace on December 31st, 2020.
## Contribution notes
* To edit the assembly code, use IDA pro 7.2 and do your changes there, that way they can be backed up easier. There are a few misceelaneous commands for the processor. Output your file via the LST file format to tools/s1proto.lst. Run text.bat to ensure bit perfectness (press enter to go to next error, if you find the end of file, it is perfect).
* To edit the file names for split files, open tools/s1proto.txt and edit the appropriate lines, or add new files in sequentially, making sure you also have specified the end of the file range. See the file for examples. Run test.bat so that all the files will update and you can check for bit perfectness.
* To edit the Z80 driver, go to sound --> Z80 --> DAC Driver.asm/i64. (Z80.log in the main folder will tell you where the Timpani pitch byte is, though it won't alert you if the sound driver gets too large)
* Please ensure that before you submit a pull request, that **you have pulled the latest version from the main repository** and resolved any merge conflicts!
