# ZX-spectrum-512K-cartridge
**ZX-Flash Cart (512 Kb in a single cart)**
The following tries to explain how I managed to get the program to create cartridge roms working. The cartridge is a multibanking one for the ZX Spectrum and can hold 10 games. The full details of the cartridge are on https://trastero.speccy.org/cosas/droy/zxflash/zxflashcart_e.htm created by Droy
![image](https://github.com/user-attachments/assets/19d3272b-0a78-4e7d-a3b5-bf80ef1801f6)
John Crokett has uploaded the PCB to PCBWay https://www.pcbway.com/project/shareproject/Retro_computing___ZX_Flash_rom_cartridge_for_ZX_Spectrum.html
The problem is that the software that can be downloaded to create a cartridge rom to burn to the AM29F040 EEPROM was written for Windows 95/98 and as on now Microsoft only supports Windows 10 and 11. The program will not run on Windows 10 and nor on Windows 7 32 bit.

This document helps explain how to get Windows 98 running as a virtual machine, how to configure the program to work and how to transfer files back and forth to the virtual Windows 98.
1) 
