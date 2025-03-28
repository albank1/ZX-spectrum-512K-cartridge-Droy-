# ZX-spectrum-512K-cartridge
**ZX-Flash Cart (512 Kb in a single cart)**
The following tries to explain how I managed to get the program to create cartridge roms working. The cartridge is a multibanking one for the ZX Spectrum and can hold 10 games. The full details of the cartridge are on https://trastero.speccy.org/cosas/droy/zxflash/zxflashcart_e.htm created by Droy
![Capture](https://github.com/user-attachments/assets/1f48faef-3704-47c2-9cb7-fcf7fe9d6b6a)

John Crokett has uploaded the PCB to PCBWay https://www.pcbway.com/project/shareproject/Retro_computing___ZX_Flash_rom_cartridge_for_ZX_Spectrum.html
The problem is that the software that can be downloaded to create a cartridge rom to burn to the AM29F040 EEPROM was written for Windows 95/98 and as on now Microsoft only supports Windows 10 and 11. The program will not run on Windows 10 and nor on Windows 7 32 bit.

This document helps explain how to get Windows 98 running as a virtual machine, how to configure the program to work and how to transfer files back and forth to the virtual Windows 98.

1) Download and run Oracle VirtualBox
2) Download a copy of Windows 98SE or use a premade disk image - see https://www.sysprobs.com/pre-installed-windows-98-se-virtualbox-image
3) Install Windows 98SE - the above website explains this.
4) Next comes the harder part of how to transfer files to and from the virtual Win98 - follow https://www.youtube.com/watch?v=WDo4079o8qs to set up network file sharing
5) Next download the cartridge creator program from https://trastero.speccy.org/cosas/droy/zxflash/zxflashcart_e.htm#descargas
6) Unzip the creator program and transfer to the Win98 PC. You need to run the VB runtime libray first and then the program
7) Now close the program and set up the config files with the folder for saving the rom file and for opening rom files.
8) If correctly working the program should look like the following. Double clicking on an .SNA will add it to the cartridge rom after you enter a title and when you press Create Cart it should report that it has saved the file. The following is an example of the program interface.
![Creator1](https://github.com/user-attachments/assets/d24e6db6-ecf9-4ac9-8ad8-238032c13db8)
![Creator2](https://github.com/user-attachments/assets/b7ee3ec2-d81d-447c-971d-caf20a7aee85)
![Creator3](https://github.com/user-attachments/assets/0cf799a7-db9b-4301-ac12-4fa643a2c193)

I have uploaded an example of a created rom which contains a variety of games. See below for the list of games:
![Menu](https://github.com/user-attachments/assets/44922b32-67f7-4749-ab0e-f9749e9b3abf)

I have done some more digging into the ROM and found that the Menu is stored as ascii characters from about $03a65
