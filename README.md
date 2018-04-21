# LambdaSpeak 
## A Next-Generation Speech Synthesizer & PCM Sample Player for the Amstrad / Schneider CPC 
#### Author: Michael Wessel
#### License: GPL 3
#### Hompage: [Author's Homepage](https://www.michael-wessel.info/)
#### Version: 1.95  

### Introduction

LambdaSpeak is a next-generation speech synthesizer and PCM sample player for the Amstrad CPC line of 8bit home computers from the 1980s (i.e, the CPC 464, CPC 664, and CPC 6128). 

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
  
  3. **SSA-1 mode:** In this mode, LambdaSpeak emulates the **Amstrad SSA-1 Speech Synthesizer**. The SSA-1 synthesizer uses a very different speech chip, the SPO-256 from General Instruments. This chip offers phoneme-based speech synthesis. The emulation of the SSA-1 is achieved by translating SPO-256 phonemes into DECtalk phonemes. Whereas the SSA-1 works synchronously, i.e., a phoneme is immediately uttered as soon as it arrives, this is not possible with the Epson chip. Hence, LambdaSpeak employs a phoneme buffer which is first filled with phonemes, and the buffer is flushed and spoken if no phoneme has arrived for a couple of milliseconds (a configurable flush buffer delay). The buffer is also flushed automatically when it overflows, and there is also a corresponding "control byte" command (see below). Hence, the SSA-1 emulation works asynchronously, and a slight delay between phoneme sending and speaking should be expected. The SSA-1 uses ports &FBEE and &FAEE.  Please note that it is impossible to emulate the low quality robotic sound of the SPO-256 with a modern speech IC such as the Epson S1V30120, so the SSA-1 emulation will actually produce understandable speech that sounds much better than the original, but is not 100% authentic. The emulation, due to its asychronous character, is only 90%, but good enough for most of the SSA-1 driver |RSX commands and games to work flawlessly. 
       
  4. **DK'tronics mode:** In this mode, the **DK'tronics Speech Synthesizer** is emulated.  The DK'tronics uses port &FBFE. The DK'tronics speech synthesizer is very similar to the SSA-1; it uses the same SPO-256 speech chip. However, the driver software and |RSX extensions are different. Moreover, a ROM version of the DK'tronics driver software was / is available, unlike for the SSA-1. The DK'tronics software implements a less advanced text-to-phoneme speech translation software than the SSA-1 driver software; the former sounds better, IMHO. The LambdaSpeak implementation of the DK'tronics speech synthesizer works similar to the SSA-1 emulation, i.e., a phoneme buffer and auto-flushing (and speaking) of the phoneme buffer after a configurable time delay of inactivity is performed. CPC port &DK'tronic &FBFE is used. Similar comments regarding the authenticity and compatibility as for the SSA-1 mode apply to the DK'tronics emulation as well.

* An 8bit PCM Sample Player, compatible with the **Amdrum** drum computer module. In **Amdrum mode**, 8bit PCM samples can be sent to port &FFxx which are being played immediately (in realtime) by LambdaSpeak. This mode can only be left by power cycling LambdaSpeak; even the reset button is ineffective in this mode (all ATmega 644 interrupts are disabled for maximal sample playing quality). The PCM audio is produced by the ATmega 644 microcontroller.      

* Optionaly, LambdaSpeak 1.95 can be equipped with an OP amp-based audio mixer, used for mixing the PCM output with the speech signal. Since the speech output produced by the "TextToSpeech click" board from MikroElektronika is only available through the audio jack, a short (2") audio jumper cable can be used to route the speech into the OP amp via an input audio jack, where it gets mixed with the PCM signal, and then the combined / mixed signal is available at the output audio jack on the LambdaSpeak board. 

### Media 

Current version of **LambdaSpeak 1.95** - please notice that **the voltage SMD jumper of the TextToSpeech click daughter board must be set to the 5V position (requires soldering):** 

![LambdaSpeak Gallery](images/ls195-a.jpg)

![LambdaSpeak Gallery](images/ls195-b.jpg)

LambdaSpeak is **MX4 compatible** and can either be plugged into the Mother X4 board, or my [MX4 compatible CPC 464 expansion port adapter for the CPC 464](https://oshpark.com/shared_projects/3yA33GYO) can be used (or a cable, of course):  


![LambdaSpeak & XMem in Mother X4 Board](images/ls195-connect-a.JPG)

![LambdaSpeak & 464 Expansion Port Adapter](images/ls195-connect-b.JPG)

![LambdaSpeak & 464 Expansion Port Adapter in CPC](images/ls195-connect-c.JPG)


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

In a future version of LambdaSpeak, **LambdaSpeak 2.0**, the GAL22V10, 74LS244 and 74LS374 are going to be substituted by a **Xilinx XC9572XL CPLD** (QFP-64 encapsulation), and an SMD version of the ATmega 644-20PU will be used. A working breadboard prototype exists, but no (SMD) PCB has yet been designed. **Bryce** is working on a PCB for LambdaSpeak 2.0. 

![LambdaSpeak Gallery](images/ls20-breadboard-a.jpg)

![LambdaSpeak Gallery](images/ls20-breadboard-b.JPG)

The pin [allocations for the Xilinx CPLD](firmware/ls2/xilinxXC9572XL/Main.ucf) and the [pin assignments for the ATmega](firmware/atmega644/ls195-pins.h) can be found in this repository. LambdaSpeak 2.0 uses the same ATmega 644 pin assignment and firmware as LambdaSpeak 1.95; hence, the only difference is in firmware for the GAL / CPLD.   

### The LambdaSpeak 1.95 Printed Circuit Board (PCB)  

The [Gerbers can be found here](gerbers/). They are also [shared at OshPark for immediate ordering](https://oshpark.com/shared_projects/C2toYu43) - this will give you 3 LambdaSpeak 1.95 PCBs for about 60 $, you still need to assemble / solder it then, buy a  ["TextToSpeech click" board from MikroElektronika for 39 $](https://www.mikroe.com/text-to-speech-click), change its SMD jumper to 5 V position, and you will also need to program ("flash") the GAL22V10 and ATmega644 with the supplied "firmware" hex files from this repository. 

For 100 $, I can assemble a complete version for you, please contact me via email if you are interrested.    
 
![LambdaSpeak Gallery](images/ls195-pcb.jpg)


#### Bill of Material & Footprints (KiCAD) 

![Bill of Material and Footprints from KiCAD](images/bom-and-footprints.jpg)

In addition, I suggest to use standard stackable Arduino Headers for plugging in the speech daughter board. A standard 2x25 angled IDC Box Header can then be used to plug LAmbdaSpeak into the **Mother X4 board**, to connect a 50 pin ribbon cable, or to plug it into [my CPC 464 epansion port connector](https://oshpark.com/shared_projects/3yA33GYO).

The form factors are for illustration only. Instead of ceramic disc capacitors, I have used ceramic multilayer capacitors mostly. I recommend using DIP sockets at least for the GAL22V10 and ATmega, such that they can be reprogrammed easily when a new firmware arrives.  

The audio section is completely optional. If you don't require audio mixing, just route the "Amdrum" PCM output directly to the audio output jack J4, and you wont need J3. This can be achieved by connecting a cable between C6 and C8 (check the schematics), and by omitting all of the audio circuit components. You will need the RC for Amdrum mode though, i.e., C5 and R4 are required. In the configuration, the resistors R7, R8, R9, the J4 audio jack, and capacitors C6, C7, C8, C9, and the Op amp U5 can be omitted. 
Speech output comes directly from the daughter board's audio jack, of course, but it is convenient to at least keep jack J4 for Amdrum PCM output, as described. 

### Firmware for LambdaSpeak 1.95 - GAL22V10 and ATmega 644 

The GAL22V10 was designed using WinCUPL. You only need the supplied [GAL22V10 HEX file](firmware/ls195/gal22v10/ls195.jed) and program it using an Epromer. I have successfully used the [Genius G540 USB Universal Programmer](https://www.amazon.com/gp/product/B075TGDDJM) for programming the GAL22V10 (B, D), and with some more problems I have also used the 
 [Signstek TL866CS Universal USB MiniPro EEPROM FLASH BIOS Programmer](https://www.amazon.com/gp/product/B00K73TSLM) (this one fails on most of my GAL22V10B's, though). 

For AVR / ATmega programming, I am using USBTinyISP, and a standard [ATmega programming board](https://www.ebay.com/itm/AVR-ATMEGA16-Minimum-System-Board-ATmega32-USB-ISP-USBasp-Programmer-F-ATMEL-S/352106489534).  

### Firmware for LambdaSpeak 2.0 - Xilinx XC9572XL and ATmega 644  

The Xilinx CPLD was designed using Xilinx' ISE WebPACK design software, in Verilog. The CPLD was programmed using a QFP-64 test socket, connected via JTAG pins to the standard  Xilinx platform USB cable.  

ATmega programming is identical to LambdaSpeak 1.95.  

### Detailed Description of the ATmega LambdaSpeak Firmware (Version 4) 

The **current version** of the unified LambdaSpeak ATmega firmare is **4**. The highest firmware version will be 15. The unified ATmega LambdaSpeak firmware works for LambdaSpeak 1.5, LambdaSpeak 1.8, LambdaSpeak 1.95, and LambdaSpeak 2.0.  

LambdaSpeak 1.95 listens to CPC's IO ports &FBEE and &FAEE (SSA-1),  &FBFE (DK'tronics), as well as to &FFx in Amdrum mode. Native DECtalk and Native Epson modes are also using &FBEE. 
 
The LambdaSpeak 1.95 hardware uses a single signal for address decoding to the ATmega 644, so in fact, it cannot distinguish whether a request was made for &FBEE, &FAEE, &FBFE, or &FFxx. However, &FFxx is only decoded in Amdrum mode (a signal is given to the GAL from the ATmega in order to en/disable &FFxx decoding). For the other modes, the current mode of LambdaSpeak determines how LambdaSpeak reacts to the IO request at &FBEE, &FAEE, &FBFE. Even though these addresses are decoded "in parallel", the LambdaSpeak RSX Driver by TFM, the SSA-1 driver software, and the DK'tronics driver software are not getting confused, because the protocols are different (in fact, they can all be used in parallel with XMem or similar!)

ASCII for speech is only 7 Bit. Every byte with the 8th bit being set is considered a **control byte** and used for controlling the LambdaSpeak firmware, setting modes, pitch, volume, etc. 

Many of these modes are demonstrated in the BASIC program `demo01.bas` found on the `LS195.dsk` file in cpc/lambda directory here. 
The list of control bytes is the following: 

- &FF: reset LambdaSpeak. Only works if LambdaSpeak is not in PCM test mode, or in Amdrum mode. Even the reset button of LambdaSpeak will be ineffective during PCM sample playing (interrupts are disabled in order to maximize sample quality).  Reset puts LambdaSpeak into default configuration. 

The **first group of control bytes** determines the **mode** of LambdaSpeak: 

- &EF: native LambdaSpeak / Epson mode. This is the simplest mode. In this mode, simply send a series of ASCII characters to &FBFE, terminated by CR (13), to make it speak the string. In Epson mode, LambdaSpeak uses the **value 32 on port &FBFE to signal that it is ready to accept the next byte.** Voice, pitch, volume, speed can be changed, see below. Check out the `demo01.bas` program for illustration. By default, a so-called **blocking mode** of operation is used for the native Epson mode. That mean, when LambdaSpeak speaks, the Z80 CPU of the CPC is **halted**, by pulling down the READY signal. Control returns when the speech has finished. However, in order to cancel / interrupt the speech, LambdaSpeak also offers a **non-blocking mode** of operation, in which the Z80 is not halted while it is speaking. While LambdaSpeak is speaking, the CPC can hence send a **stop** command to LambdaSpeak (as it is not halted), and LambdaSpeak will immediatly stop speaking. Notice that sending the **stop** control byte (&DF( is **the only operation that will work in non-blocking mode which LambdaSpeak is speaking**. Being able to cancel currently ongoing speech is the sole purpose of the non-blocking mode. 

- &EE: native DECTalk mode of LambdaSpeak. More involved, as the DECTalk syntax allows phoneme-based control of speech synthesis, i.e., LambdaSpeak can sing. In DECTalk mode, LambdaSpeak uses the **value 32 on port &FBEE to signal that it is ready to accept the next byte.** Check out the DECTalk manual to learn about the syntax, and again `demo01.bas` for illustration. As for the Epson mode, it supports blocking and non-blocking mode of operation, see above for explanation. 

- &ED: Amstrad SSA-1 emulation mode. 90% emulatation of the SSA-1; check out games like "Roland in Space" or the SSA-1 driver software supplied in this repository. The ports are **&FBEE and &FAEE**, and the ready signal(s) of the SSA-1 are emulated accordingly. The emulation is faithful enough for games to work, and the SSA-1 driver software works as well. It was tested with SSA-1 software, Tubaruba, Alex Higgins' World Pool, Roland in Space, and a couple more, and worked flawlessly. Since the timing is not 100% accurate / faithful to the original hardware, I do not guarantee 100% compatibility. Check out the YouTube videos above to get an idea about SSA-1 emulation. 
  - Please note that SSA-1 mode always works asynchronously and the CPC / Z80 CPU will never be halted. Rather, phonemes are being  buffered, and when the buffer is full or when no phoneme has arrived for a couple of milliseconds (the flush delay is configurable, see below), the buffer is flushed and spoken. Hence, blocking and non-blocking mode does not apply to SSA-1 mode. 

- &EC: DK'tronics speech synthesizer emulation mode. 90% emulation of the DK'tronics speech synthesizer. Same comments as for the SSA-1 emulation apply. DK'tronics uses the port **&FBFE**, and the ready signal is a bit simpler than in the SSA-1 case (only one bit is used). The speech synthesizer was tested with DK'tronics ROM software, DK'tronics cassette speech synthesizer software, old BASIC program that were written for the DK'tronics (e.g., Elisa.bas on LS195.dsk), and some games, including Jump Jet, Alex Higgins' Pool, etc. Check out the YouTube videos to get an idea about DK'tronics emulation. 
  - The same comments regarding phoneme buffer and blocking and non-blocking mode as for the SSA-1 mode apply to the DK'tronics mode. Same thing. 

- &EB: enable non-blocking mode for native Epson and native DECTalk mode of LambdaSpeak. Explained above, see there. Does not apply to SSA-1 and DK'tronics mode. 

- &EA: enable blocking mode for native Epson and native DECTalk mode. See explanation above. Does not apply to SSA-1 and DK'tronics mode. 

- &E9: by default, LambdaSpeak confirms all control bytes and changes to configuration. This enable these confirmations. 

- &E8: puts LambdaSpaak into less verbose / silent mode, where it does not confirm control bytes and changes to configuration. Of course, it will still speak in this mode, but no longer confirm control bytes audibly. 

- &E7: the DecTalk / Epson firmware supports Spanish and English text-to-speech. This enables the English mode. This is the default for LambdaSpeak. Does not apply to DK'tronics or SSA-1 mode (for these, there is no text-to-speech, but phonemes are being sent to LambdaSpeak, and the text-to-phoneme translation is performed by the SSA-1 or DK'tronics CPC driver software). 

- &E6: Spanish language mode! Not really tested, but should work. 

- &E5: enables the **fast getters mode**. The firmware offers a couple of "getter" methods / control bytes which can be used to query / acquire the current settings of LambdaSpeak, e.g., the current volume, current voice number, etc. These "getter" methods / control bytes follow a certain "data transmission" protocol. If a getter method is invoked, LambdaSpeak first puts a zero-byte on the Z80 / CPC data bus (note that all LambdaSpeak modes use a non-zero "ready" signal on the data bus), then waits 50 microseconds, next puts the requested value (e.g., the current volume) on the data bus for 50 microseconds, and then puts another zero-byte on the databus for 50 microseconds, before returning to normal LambdaSpeak operation (i.e., the **ready signal** of the corresponding mode is given on the databus). Notice that the zero-byte is reserved for this syncronization purpose, and the "getter" methods / control bytes will never return a zero value (i.e., there is no zero volume, no voice number zero, etc.) Hence, a program reading these values can check for these zero-padded values to read them. Using &E5, the describe time delays are short, suitable for machine code programs that want to read the LambdaSpeak settings. The values are only visible for a couple of microseconds on the databus. 

- &E4: using the **slow getters mode**, the requested setting value is much longer visible on the databus, i.e., for 50 milliseconds (compared to the 50 microseconds in **fast getters mode**). This mode is suitable for (slower) BASIC programs that want to read the LambdaSpeak settings.   

- &E3: LambdaSpeak offers a PCM sample-playing mode - it emulates the **Amdrum drum computer**. In this mode, every byte sent to port &FFxx (xx = arbitrary) will immediatly be played as an 8bit PCM sample. THe **Amdrum software** works out of the box in this mode, and sample quality is surprsingly good / high. This mode can only be exited by power-cycling LambdaSpeak. All interrupts are disabled, for maximimum processing speed and sample quality. Hence, even the reset button of LambdaSpeak is ineffective. Decoding of &FFxx will only be enabled when Amdrum mode is enabled (the ATmega sends a signal to the address decoder chip, i.e. the GAL22V10 or Xilinx CPLD, respectively). 

- &DF: in non-blocking native Epson (or native DECTalk) mode, **speech can be stopped immediatly by sending this control byte**. This is the only control byte which can be processed in asychronous mode while LambdaSpeak is speaking. The sole purpose of the non-blocking mode is to allow sending of this stop byte and henc being able to stop the speech at any time. 

- &DE: in SSA-1 or DK'tronics mode, a phoneme buffer is used. The buffer is flushed when no new phoneme has arrived for a certain time, or when the buffer is full. The buffer can also be flushed at any time by sending this control byte. 

The **next group of control bytes** is used for getting info, and reading settings (so-called "getter" methods or control bytes). The getter methods return 4bit values, and the upper 4bits of the databus are being used (upper nibble, bits 4, 5, 6, and 7). There is never a zero  value returned. The zero-byte is used for synchronization instead, as "padding" byte, as explained.  Notice that the returned value will be available on the databus for either 50 microseconds (fast getters) or 50 milliseconds (slow getters). Before and after, a zero-byte is sent. 

- &CF: returns the current mode. This is a 4bit vector, using the upper 4 bits. Bits 4 and 5 indicate the current mode (native Epson, native DECTalk, SSA-1, DKtronics), bit 6 is on if blocking mode is enable, and off otherwise; and bit 7 is off for English mode, and on for Spanish mode.

- &CE: returns the current volume. 

- &CD: returns the current voice. The voices 1 to 8 are pre-defined. 

- &CC: returns the current speak rate. 

- &CB: returns the current language. 

- &CA: returns the current flush buffer delay. 

- &C9: returns the current firmware version number (currently, 4). 

- &C8: speaks a copyright note.

- &C7: get a quote from HAL 9000! 

- &C6: sing "Daisy Bell", a classic DecTalk song. 

- &C5: and echo test program to check port communication. In this mode, every byte sent to port &FBEE and &FAEE is immediately "echoed" back onto the databus, such that it can be read and compared with the byte that was sent. This mode can only be exited by pushing the LambdaSpeak reset button, or by power cycling of course. 

- &C4: like &C5, but for port &FBFE. 

- &C3: speak a test message. Useful for testing different voices and speech parameters (rate, etc.)

- &C2: PCM sample test. Play a sample from HAL 9000 - "I'm completely operational", over the Amdrum PCM output. Use LambdaSpeak's reset button the exit this mode.  

- &B0: set current voice to the default voice. 

- &B1 - &BF: set current voice to voice 1 (&B1) to 15 (&BF). 

- &A0: set current volume to the default volume. 

- &A1 - &AF: set currrent volume to volume level 1 (&A1) to volume level 15 (&AF). 

- &90: set current speak rate to default speak rate. 

- &91 - &9F: set current speak rate to rate level 1 (&91) to rate level 15 (&9F). 

- &80: set flush buffer delay time to default time. 

- &81 - &8F: set current flush buffer delay time to delay time 1 (&81) to delay time 15 (&8F). 

Overview of all control bytes, as discussed:  
     
     
      case 0xFF : process_reset(); break; 
    
      case 0xEF : native_mode_epson(); break; 
      case 0xEE : native_mode_dectalk(); break; 
      case 0xED : ssa1_mode(); break; 
      case 0xEC : dktronics_mode(); break; 
      case 0xEB : non_blocking(); break; 
      case 0xEA : blocking(); break; 
      case 0xE9 : confirmations_on(); break;  
      case 0xE8 : confirmations_off(); break;   
      case 0xE7 : english(); break; 
      case 0xE6 : spanish(); break; 
      case 0xE5 : fast_getters(); break; 
      case 0xE4 : slow_getters(); break; 
      case 0xE3 : amdrum_mode(); break; 
    
      case 0xDF : stop_command(); break;  
      case 0xDE : flush_command(); break;
     
      case 0xCF : get_mode(); break; 
      case 0xCE : get_volume(); break; 
      case 0xCD : get_voice(); break; 
      case 0xCC : get_rate(); break; 
      case 0xCB : get_language(); break; 
      case 0xCA : get_delay(); break; 
      case 0xC9 : get_version(); break; 
      case 0xC8 : speak_copyright_note(); break; 
      case 0xC7 : speak_hal9000_quote(); break; 
      case 0xC6 : sing_daisy(); break; 
      case 0xC5 : echo_test_program(); break; 
      case 0xC4 : echo_test_program_dk(); break; 
      case 0xC3 : test_message(); break; 
      case 0xC2 : pcm_test(); break; 
    
      case 0xB0 : set_voice_default(); break;
      case 0xB1 : set_voice(1); break; // default
      case 0xB2 : set_voice(2); break;
      case 0xB3 : set_voice(3); break;
      case 0xB4 : set_voice(4); break;
      case 0xB5 : set_voice(5); break;
      case 0xB6 : set_voice(6); break;
      case 0xB7 : set_voice(7); break;
      case 0xB8 : set_voice(8); break;
      case 0xB9 : set_voice(9); break;
      case 0xBA : set_voice(10); break;
      case 0xBB : set_voice(11); break;
      case 0xBC : set_voice(12); break;
      case 0xBD : set_voice(13); break;
      case 0xBE : set_voice(14); break;
      case 0xBF : set_voice(15); break;
    
      case 0xA0 : set_volume_default(); break;
      case 0xA1 : set_volume(1); break;
      case 0xA2 : set_volume(2); break;
      case 0xA3 : set_volume(3); break;
      case 0xA4 : set_volume(4); break;
      case 0xA5 : set_volume(5); break;
      case 0xA6 : set_volume(6); break;
      case 0xA7 : set_volume(7); break;
      case 0xA8 : set_volume(8); break;
      case 0xA9 : set_volume(9); break;
      case 0xAA : set_volume(10); break;
      case 0xAB : set_volume(11); break;
      case 0xAC : set_volume(12); break;
      case 0xAD : set_volume(13); break;
      case 0xAE : set_volume(14); break; // default 
      case 0xAF : set_volume(15); break;
    
      case 0x90 : set_rate_default(); break;
      case 0x91 : set_rate(1); break;
      case 0x92 : set_rate(2); break;
      case 0x93 : set_rate(3); break;
      case 0x94 : set_rate(4); break;
      case 0x95 : set_rate(5); break;
      case 0x96 : set_rate(6); break;
      case 0x97 : set_rate(7); break;
      case 0x98 : set_rate(8); break;
      case 0x99 : set_rate(9); break;
      case 0x9A : set_rate(10); break;
      case 0x9B : set_rate(11); break;
      case 0x9C : set_rate(12); break; // default
      case 0x9D : set_rate(13); break;
      case 0x9E : set_rate(14); break;
      case 0x9F : set_rate(15); break;
    
      case 0x80 : set_buffer_delay_default(); break;
      case 0x81 : set_buffer_delay(1); break;
      case 0x82 : set_buffer_delay(2); break;
      case 0x83 : set_buffer_delay(3); break;
      case 0x84 : set_buffer_delay(4); break;
      case 0x85 : set_buffer_delay(5); break;
      case 0x86 : set_buffer_delay(6); break;
      case 0x87 : set_buffer_delay(7); break;
      case 0x88 : set_buffer_delay(8); break;
      case 0x89 : set_buffer_delay(9); break;
      case 0x8A : set_buffer_delay(10); break; // default !!
      case 0x8B : set_buffer_delay(11); break;
      case 0x8C : set_buffer_delay(12); break;
      case 0x8D : set_buffer_delay(13); break;
      case 0x8E : set_buffer_delay(14); break;
      case 0x8F : set_buffer_delay(15); break;    
     

### CPC Software 

To be written soon. 

#### LambdaSpeak |RSX Driver and ROM by Dr. Stefan Stumpferl (aka TFM, Gunhed)

To be written soon. 


### Acknowledgements

Bryce, TFM,  zhulien. More details later. 

#### Disclaimer 

Use at your own risk. I am not responsible for any potential damage you might cause to your CPC, other machinery, or yourself, in the process of assembling and using this piece of hardware.

Enjoy! 



