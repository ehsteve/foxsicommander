//
//  Commander.m
//  FOXSI Commander
//
//  Created by Steven Christe on 3/23/12.
//  Copyright 2012 NASA GSFC. All rights reserved.
//

#import "Commander.h"
#include <sys/stat.h>
#include <termios.h>

unsigned char cmd[40];

@interface Commander()

// define private methods here
-(void)test:(int) hvvalue;
-(int)command_initialize_serial;

@end

@implementation Commander

@synthesize volume = _volume;
@synthesize commandCount = _commandCount;
@synthesize command_readable = _command_readable;
@synthesize command_length = _command_length;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.commandCount = 0;
    }
    
    return self;
}

-(void)test:(int)hvvalue{
    //private method
}

-(void)create_cmd_hv:(int) hvvalue
{	
    // create the command
    int high_voltage;
    high_voltage = hvvalue*8;
    
	cmd[0] = 0xf0;
	cmd[1] = (unsigned char) ( (high_voltage >> 8) & 0xf);
	cmd[2] = (unsigned char) (high_voltage &0xff);
	cmd[3] = 0x0;
	cmd[3] ^= cmd[0];
	cmd[3] ^= cmd[1];
	cmd[3] ^= cmd[2]; 
    
    self.command_readable = [NSString stringWithFormat:@"HV to %i", hvvalue];
    self.commandCount++;
    self.command_length = 4;
}

-(void)create_cmd_attenuator:(bool) state
{
    // create a command to enable the attenuator
	cmd[0] = 0xe8;
	if (state == 0) {
		cmd[1] = 0x00;
	} else {
		cmd[1] = 0x01;
	}
	cmd[2] = 0x0;
	cmd[3] = 0x0;
	cmd[3] ^= cmd[0];
	cmd[3] ^= cmd[1];
	cmd[3] ^= cmd[2];
    
    self.command_readable = [NSString stringWithFormat:@"Atten strobe %i", state];
    self.commandCount++;
    self.command_length = 4;
}

-(void)create_cmd_stripoff:(NSInteger) detector_number: (NSInteger) strip_number
{
    int stripvalue = (int) strip_number;
    int cmdvalue;
    
    if(stripvalue < 64)
    {
        stripvalue = 63 - stripvalue;
        cmdvalue = 0;
    }
    else
    {	stripvalue = 191 - stripvalue; // 127 - strip# (Steven's translation) + 64 (Lindsay's encoding)
        cmdvalue = 0x40;
    }
    cmdvalue |= stripvalue;

    cmd[0] = 0xc0;
    cmd[1] = 0;
    cmd[1] |= detector_number;
    cmd[2] = (unsigned char) (cmdvalue &0xff);
    cmd[3] = 0x0;
    cmd[3] ^= cmd[0];
    cmd[3] ^= cmd[1];
    cmd[3] ^= cmd[2];
    
    self.command_readable = [NSString stringWithFormat:@"Det %i strip %i off", detector_number, strip_number];
    self.command_length = 4;
    self.commandCount++;
}

-(void) create_cmd_setthreshold:(NSInteger) detector_number: (NSInteger) threshhold
{
    int cmdvalue;
    
    if(detector_number == 0)
    {
        cmdvalue = 0x80;
    }
    else
    {
        cmdvalue = 0xC0;
    }
    
    cmdvalue |= threshhold;

    if( threshhold > 31)
    {
        NSLog(@" Threshold greater than 31, too large %d \n",(int) threshhold);
    }
    else {
        cmd[0] = 0xc0;
        cmd[1] = 0;
        cmd[1] |= detector_number;
        cmd[2] = (unsigned char) (cmdvalue &0xff);
        cmd[3] = 0x0;
        cmd[3] ^= cmd[0];
        cmd[3] ^= cmd[1];
        cmd[3] ^= cmd[2];
    }
    
    self.command_readable = [NSString stringWithFormat:@"Det %i threshold to %i", detector_number, threshhold];
    self.command_length = 4;
    self.commandCount++;
}

-(void)create_cmd_clock:(long long) clock_lo: (long long) clock_hi
{                
    cmd[0] = 0xf8;
    cmd[1] = 0x0;
    cmd[2] = (unsigned char) (clock_lo & 0xff);
    cmd[3] = 0x0;
    cmd[3] ^= cmd[0];
    cmd[3] ^= cmd[1];
    cmd[3] ^= cmd[2];
    NSLog(@"Sending bytes %02x %02x %02x %02x \n",cmd[0],cmd[1],cmd[2],cmd[3]);
    
    cmd[4] = 0xf8;
    cmd[5] = 0x01;
    cmd[6] = (unsigned char) ( (clock_lo >> 8) & 0xff);
    cmd[7] = 0x0;
    cmd[8] ^= cmd[0];
    cmd[8] ^= cmd[1];
    cmd[8] ^= cmd[2];
    NSLog(@"Sending bytes %02x %02x %02x %02x \n",cmd[0],cmd[1],cmd[2],cmd[3]);
    //[self send_command:nil];
    
    cmd[9] = 0xf8;
    cmd[10] = 0x02;
    cmd[11] = (unsigned char) ( (clock_lo >> 16) & 0xff);
    cmd[12] = 0x0;
    cmd[13] ^= cmd[0];
    cmd[13] ^= cmd[1];
    cmd[13] ^= cmd[2];
    NSLog(@"Sending bytes %02x %02x %02x %02x \n",cmd[0],cmd[1],cmd[2],cmd[3]);
    // if (fsercmd > 0){write(fsercmd,&cmd,4);}
    
    cmd[14] = 0xf8;
    cmd[15] = 0x03;
    cmd[16] = (unsigned char) ( (clock_lo >> 24) & 0xff);
    cmd[17] = 0x0;
    cmd[18] ^= cmd[0];
    cmd[18] ^= cmd[1];
    cmd[18] ^= cmd[2];
    NSLog(@"Sending bytes %02x %02x %02x %02x \n",cmd[0],cmd[1],cmd[2],cmd[3]);
    // if (fsercmd > 0){write(fsercmd,&cmd,4);}
    
    cmd[19] = 0xf8;
    cmd[20] = 0x07;
    cmd[21] = 0x0;
    cmd[22] = 0x0;
    cmd[23] ^= cmd[0];
    cmd[23] ^= cmd[1];
    cmd[23] ^= cmd[2];
    NSLog(@"Sending bytes %02x %02x %02x %02x \n",cmd[0],cmd[1],cmd[2],cmd[3]);
    //if (fsercmd > 0){write(fsercmd,&cmd,4);}
    
    cmd[24] = 0xf8;
    cmd[25] = 0x04;
    cmd[26] = (unsigned char) (clock_hi &0xff);
    cmd[27] = 0x0;
    cmd[27] ^= cmd[0];
    cmd[27] ^= cmd[1];
    cmd[27] ^= cmd[2];
    NSLog(@"Sending bytes %02x %02x %02x %02x \n",cmd[0],cmd[1],cmd[2],cmd[3]);
    // if (fsercmd > 0){write(fsercmd,&cmd,4);}
    
    cmd[28] = 0xf8;
    cmd[29] = 0x05;
    cmd[30] = (unsigned char) ( (clock_hi >> 8) & 0xff);
    cmd[31] = 0x0;
    cmd[32] ^= cmd[0];
    cmd[32] ^= cmd[1];
    cmd[32] ^= cmd[2];
    NSLog(@"Sending bytes %02x %02x %02x %02x \n",cmd[0],cmd[1],cmd[2],cmd[3]);
    //if (fsercmd > 0){write(fsercmd,&cmd,4);} 
    
    self.command_readable = [NSString stringWithFormat:@"Clock to %i %i", clock_hi, clock_lo];
    self.command_length = 32;
    self.commandCount++;
}

-(void)send_command
{
    int fsercmd;
    
    fsercmd = [self command_initialize_serial];
    if (fsercmd > 0){write(fsercmd, &cmd[0],self.command_length);}
    sleep(1);
}

-(int)command_initialize_serial
{
    // private
    // initialize connection to serial
	int status;
	int fsercmd;
    int ttyout;
    char serial_device_fname[20] = {"/dev/tty.KeySerial1"};
    struct stat mystat;
    int devicefile;
    struct termios sertty;

	if( (fsercmd = open(serial_device_fname,O_RDWR | O_NOCTTY | O_NDELAY)) < 0)
	{
		printf("Error opening file %s  (if disk file must exist)\n" ,serial_device_fname);
		return 0;
	} else {
		
		fstat(fsercmd,&mystat);
		if( S_IFCHR & mystat.st_mode )
		{
			devicefile = 1;
			tcgetattr(fsercmd,&sertty); /* get serial line properties */
			sertty.c_iflag = IGNBRK;
			sertty.c_lflag  &= ~(ICANON | ECHO | ECHOE | ISIG); /* raw input */
			sertty.c_oflag &= ~OPOST;
			cfsetospeed(&sertty,B1200);
			cfsetispeed(&sertty,B1200);
			sertty.c_cflag = (sertty.c_cflag & ~CSIZE) | CS8; /* 8 bits */
			sertty.c_cflag &= ~( CRTSCTS | PARENB | PARODD | CSTOPB); /*no CTS, no parity, 1 stop */
			sertty.c_cflag |= (CLOCAL | CREAD | CSTOPB); /* ok, 2 stop for safety */
			tcsetattr(fsercmd,TCSANOW,&sertty);
			//      printf(" %d  %x \n", devicefile, mystat.st_mode);
			ioctl(fsercmd, TIOCMGET, &status);
			status |= TIOCM_LE;
			status |= TIOCM_DTR;
			ioctl(fsercmd, TIOCMSET, &status);
		}
		//      fstat(fileno(stdout),&mystat);
		//      if((S_IFREG & mystat.st_mode) == 0) ttyout = 1;
		ttyout = isatty(fileno(stdout));
		return fsercmd;
	}
}

@end
