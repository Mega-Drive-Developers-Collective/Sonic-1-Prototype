# Sonic 1 Prototype
Research disassembly of the Sonic 1 prototype that was released by Hidden Palace on December 31st, 2020.
## Contribution notes
* To edit the assembly code, use IDA pro 7.2 and do your changes there, that way they can be backed up easier. There are a few misceelaneous commands for the processor. Output your file via the LST file format to tools/s1proto.lst. Run text.bat to ensure bit perfectness (press enter to go to next error, if you find the end of file, it is perfect).
* To edit the file names for split files, open tools/s1proto.txt and edit the appropriate lines, or add new files in sequentially, making sure you also have specified the end of the file range. See the file for examples. Run test.bat so that all the files will update and you can check for bit perfectness.
* Please ensure that before you submit a pull request, that you have pulled the latest version from the main repository and resolved any merge conflicts!
* You can also come discuss this project in our Discord at http://dc.megadrive.dev/

## Hacking notes
* To start your hack, run the diff.bat script, to split tools/s1proto.md into the individual data files
* Edit your data or code, and run build.bat to build out.md, or any error and log files in case there is a mistake
* All sound related data is in the sound folder, levels has both level data and level related objects, screens has most data to do with the SEGA screen, title screen and Special Stage
* SONLVL folder has all the sonlvl related data, which allows you to edit levels with the SONLVL program
* unknown and unsorted has various misc files that have yet not been relocated or identified.
* tools folder has a few different things. Usually for hacking you don't need to touch this. Just be aware to not delete this folder.
* diff.bat, test.bat, process.bat and split.bat are not needed after initially running split.bat!
