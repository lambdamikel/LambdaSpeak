# LambdaSpeak 
## A Next-Generation Speech Synthesizer & PCM Sample Player for the Amstrad / Schneider CPC 
#### Author: Michael Wessel
#### License: GPL 3
#### Hompage: [Author's Homepage](https://www.michael-wessel.info/)
#### Version: 1.95  

### Introduction

LambdaSpeak is a next-generation speech synthesizer and PCM sample player
for the Amstrad CPC line of 8bit home computers from the 1980s (i.e, the CPC 464, CPC 664, and CPC 6128). 

LambdaSpeak is a MX4-compatible IO extension that plugs into the expansion port of the CPC.
It contains the following chips:  

LambdaSpeak is based on the Epson S1V30120 TTS (text to speech) chip. An ATMega 644-20PU 
microcontroller clocked at 20 MHz is running the LambdaSpeak firmware, which implements a high-level intelligent interface to the CPC. The LambdaSpeak firmware / ATMega 644 is also hosting and loading the Epson firmware into the S1V30120, and for controlling the Epson speech chip via SPI interface.  The Epson firmware is rather large; hence a microcontroller with a large (64 KB of) flash memory such as the ATMega 644 is required. 

The Epson S1V30120 firmware implements two modes of operation: a DECtalk mode, and a simplified, native Epson mode. The latter is simpler and sometimes produces more accurate speech, whereas the former offers more fine grained control over the speech synthesis process.  

### Features 

LambdaSpeak offers the following: 

* A high-quality speech synthesizer, based on the Epson S1V30120 speech synthesizer chip. LambdaSpeak uses the [39$ "TextToSpeech click" board from MikroElektronika](https://www.mikroe.com/text-to-speech-click) as a daugher board. This board has an audio jack output for speech. Four modes of operation are implemented in the LambdaSpeak firmware:

  1. **Native Epson Mode:** Native because the TTS is directly performed by the Epson IC / firmware. In this mode, a stream of ASCII characters can be sent to the CPC port &FBFFE,  terminated by CR (13), and the assembled ASCII string will be spoken by LambdaSpeak. Voice, volume, and speed of the speech can be specified as well.  

  2. **Native DECtalk Mode:** The DECtalk emulation offers much more fine-grained control over different aspects of the generated speech. These aspects are specified using the standard DECtalk syntax, down to the level of phonemes if desired. In this mode, LambdaSpeak can even sing a song. Again, CPC port &FBEE is used. 
  
  3. **SSA-1 mode:** In this mode, LambdaSpeak emulates the **Amstrad SSA-1 Speech Synthesizer**. The SSA-1 synthesizer uses a very different speech chip, the SPO-256 from General Instruments. This chip offers phoneme-based speech synthesis. The emulation of the SSA-1 is achieved by translating SPO-256 phonemes into DECtalk phonemes. Whereas the SSA-1 works synchronously, i.e., a phoneme is immediately uttered as soon as it arrives, this is not possible with the Epson chip. Hence, LambdaSpeak employs a phoneme buffer which is first filled with phonemes, and the buffer is flushed and spoken if no phoneme has arrived for a couple of milliseconds (a configurable flush buffer delay). Hence, the SSA-1 emulation works asynchronously, and a slight delay between phoneme sending and speaking should be expected.
  The SSA-1 uses ports &FBEE and &FAEE.  Please note that it is impossible to emulate the low quality robotic sound of the SPO-256 with a modern speech IC such as the Epson S1V30120, so the SSA-1 emulation will actually produce understandable speech that sounds much better than the original. 
       
  4. **DK'tronics mode:** In this mode, the **DK'tronics Speech Synthesizer** is emulated. The DK'tronics speech synthesizer is very similar to the SSA-1; it uses the same SPO-256 speech chip. However, the driver software and |RSX extensions are different. Moreover, a ROM version of the DK'tronics driver software was / is available, unlike for the SSA-1. The DK'tronics software implements a less advanced text-to-phoneme speech translation software than the SSA-1 driver software; the former sounds better, IMHO. The LambdaSpeak implementation of the DK'tronics speech synthesizer works similar to the SSA-1 emulation, i.e., a phoneme buffer and auto-flushing (and speaking) of the phoneme buffer after a configurable time delay of inactivity is performed. CPC port &DK'tronic &FBFE is used. Again, the DK'tronics emulation sounds much better than the original, given the much more advanced and capable speech chip used for LambdaSpeak. 

* An 8bit PCM Sample Player, compatible with the **Amdrum** drum computer module. In **Amdrum mode**, 8bit PCM samples can be sent to port &FFxx which are being played immediately (in realtime) by LambdaSpeak. This mode can only be left by power cycling LambdaSpeak; even the reset button is ineffective in this mode (all ATmega 644 interrupts are disabled for maximal sample playing quality). The PCM audio is produced by the ATmega 644 microcontroller.      

* Optionaly, LambdaSpeak 1.95 can be equipped with an OP amp-based audio mixer, used for mixing the PCM output with the speech signal. Since the speech output produced by the "TextToSpeech click" board from MikroElektronika is only available through the audio jack, a short (2") audio jumper cable can be used to route the speech into the OP amp via an input audio jack, where it gets mixed with the PCM signal, and then the combined / mixed signal is available at the output audio jack on the LambdaSpeak board. 

### Media 

Current version of **LambdaSpeak 1.95** - please notice that **the voltage SMD jumper of the TextToSpeech click daughter board must be set to 5 V position (requires soldering):** 

![LambdaSpeak Gallery](images/ls195-a.jpg)

![LambdaSpeak Gallery](images/ls195-b.jpg)

LambdaSpeak is **MX4 compatible** and can either be plugged into the Mother X4 board, or my [MX4 compatible CPC 464 expansion port adapter for the CPC 464](https://oshpark.com/shared_projects/3yA33GYO) can be used (or a cable, of course):  


![LambdaSpeak & XMem in Mother X4 Board](images/ls195-connect-a.jpg)

![LambdaSpeak & 464 Expansion Port Adapter](images/ls195-connect-b.jpg)

![LambdaSpeak & 464 Expansion Port Adapter in CPC](images/ls195-connect-c.jpg)


Below are a couple of YouTube videos that demonstrate the various features and modes of LambdaSpeak. Notice that these videos are showing older versions of the hardware. However, speech quality etc. will be identical to the current version of LambdaSpeak:  

- [LambdaSpeak Native Mode - talking ELIZA Program](https://youtu.be/ckCTHi5_2f8)
- [LambdaSpeak DK'tronics & SSA-1 Emulation - German-speaking ELIZA program, originally written for the DK'tronics speech synthesizer](https://youtu.be/aTxufTKfrYk) 
- [LambdaSpeak and DK'tronic Speech ROM Software](https://youtu.be/wxNSlEyfPMc)
- [TFM's LambdaSpeak |RSX Driver](https://youtu.be/CsaE9JfhJ20)
- [Sample Playing in "Amdrum mode" with TFM's |RSX Driver](https://youtu.be/RSu7fPpDmCQ)
- [PCM Audio Quality of Amdrum Mode using Amdrum Software](https://youtu.be/pBuBxT3YEuI)
- [Amdrum Demo](https://youtu.be/upVayBKlnow)
- [Another Amdrum Demo](https://youtu.be/E63uH6SpzMs)


The historical **LambdaSpeak Ancestry Gallery** - early versions of LambdaSpeak were using the **Emic 2**  TTS daughterboad instead of the "TextToSpeech click" from Elektronika: 

![LambdaSpeak Gallery](images/lambdaspeak-gallery.jpg)

### Hardware Overview 

These are the main components of LambdaSpeak 1.95: 

1. Epson S1V30120 Text-to-Speech Speech Synthesizer IC. The [39$ "TextToSpeech click" board from MikroElektronika](https://www.mikroe.com/text-to-speech-click) is used as a daughter board. It is plug and play, but requires re-soldering of an SMD jumper (from 3.3 V to 5 V position).   
2. ATMega 644-20PU Microcontroller clocked at 20 MHz (U4). 
3. GAL22V10 Programmable Logic Device (U1), for Z80 address decoding and some glue logic. This is a discontinued component, but still easy to get on EBay. 
4. Some glue logic: a 74LS244 bus driver (U3) and a 74LS374 flip flop (U2).
5. Optional: a LM741CN OP amp (U5) for mixing PCM output (produced by the ATmega 644) and speech output from the Epson S1V30120 such that only one audio cable is required.

Here are the [schematics of LambdaSpeak 1.95.](schematics/lambdaspeak-195-schematics.pdf). 

![LambdaSpeak Gallery](images/ls195-pcb.jpg)

The [pin assignments for the GAL22V10](firmware/ls195/gal22v10/ls195.PLD) and the [pin assignments for the ATmega](firmware/atmega644/ls195-pins.h) can be found in this repository. 

In a future version of LambdaSpeak, **LambdaSpeak 2.0**, the GAL22V10, 74LS244 and 74LS374 are going to be substituted with a **Xilinx XC9572XL CPLD** (QFP-64 encapsulation), and an SMD version of the ATmega 644-20PU will be used. A working breadboard prototype exists, but no (SMD) PCB has yet been designed:   

![LambdaSpeak Gallery](images/ls20-breadboard-a.jpg)

![LambdaSpeak Gallery](images/ls20-breadboard-b.jpg)

The pin [allocations for the Xilinx CPLD](firmware/ls2/xilinxXC9572XL/Main.ucf) and the [pin assignments for the ATmega](firmware/atmega644/ls195-pins.h) can be found in this repository. LambdaSpeak 2.0 uses the same ATmega 644 pin assignment and firmware as LambdaSpeak 1.95; hence, the only difference is in firmware for the GAL / CPLD.   

### The LambdaSpeak 1.95 Printed Circuit Board (PCB)  

The [Gerbers can be found here](gerbers/). They are also [shared at OshPark for immediate ordering](https://oshpark.com/shared_projects/C2toYu43) - this will give you 3 LambdaSpeak 1.95 PCBs for about 60 $, you still need to assemble / solder it then, buy a  ["TextToSpeech click" board from MikroElektronika for 39 $](https://www.mikroe.com/text-to-speech-click), change its SMD jumper to 5 V position, and you will also need to program ("flash") the GAL22V10 and ATmega644 with the supplied "firmware" hex files from this repository. 

For 80 $, I can assemble a complete version for you, please contact me via email if you are interrested.    
 
![LambdaSpeak Gallery](images/ls195-pcb.jpg)


#### Bill of Material & Footprints (KiCAD) 

![Bill of Material and Footprints from KiCAD](images/bom-and-footprints.jpg)

The form factors are for illustration only. Instead of ceramic disc capacitors, I have used ceramic multilayer capacitors mostly. I recommend using DIP sockets at least for the GAL22V10 and ATmega, such that they can be reprogrammed easily when a new firmware arrives.  

### LambdaSpeak 1.95 Firmware Software 

The GAL22V10 was programmed using WinCUPL. You only need the supplied [GAL22V10 HEX file](firmware/ls195/gal22v10/ls195.jed) and program it using an Epromer. I have successfully used the [Genius G540 USB Universal Programmer](https://www.amazon.com/gp/product/B075TGDDJM) for programming the GAL22V10 (B, D), and with some more problems I have also used the 
 [Signstek TL866CS Universal USB MiniPro EEPROM FLASH BIOS Programmer](https://www.amazon.com/gp/product/B00K73TSLM) (this one fails on most of my GAL22V10B's, though). 

For AVR / ATmega programming, I am using USBTinyISP, and a standard [ATmega programming board](https://www.ebay.com/itm/AVR-ATMEGA16-Minimum-System-Board-ATmega32-USB-ISP-USBasp-Programmer-F-ATMEL-S/352106489534).  

### LambdaSpeak 2.0 Firmware Software 

The Xilinx CPLD was programmed using Xilinx' ISE WebPACK design software, in Verilog. 
The CPLD was programmed using a QFP-64 test socket, connected via JTAG pins to the standard  Xilinx platform USB cable.  

ATmega programming is identical to LambdaSpeak 1.95.  

### Firmware Description 

Control Bytes 
 
### CPC Software 

To be written soon. 

#### LambdaSpeak |RSX Driver and ROM by Dr. Stefan Stumpferl (aka TFM, Gunhed)

To be written soon. 


### Acknowledgements

Bryce, TFM,  zhulien. More details later. 

#### Disclaimer 

Use at your own risk. I am not responsible for any potential damage you might cause to your CPC, other machinery, or yourself, in the process of assembling and using this piece of hardware.

Enjoy! 



