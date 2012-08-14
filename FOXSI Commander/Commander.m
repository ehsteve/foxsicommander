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
-(int)command_initialize_serial:(bool) testmode;
-(void)init_command_variables;

@end

@implementation Commander

// store an increasing count of the number of commands sent
@synthesize commandCount = _commandCount;
// stores a string for a readable version of the command in the buffer
@synthesize command_readable = _command_readable;
// stores the command lenght in words, most commands are just one word long
@synthesize command_length = _command_length;   

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.commandCount = 0;
        self.command_length = 0;
    }
    
    return self;
}

-(void)send_command:(bool)testmode{
    int fsercmd;
    
    fsercmd = [self command_initialize_serial:testmode];
    for (int i = 0; i < self.command_length; i++) {
        write(fsercmd,&cmd[4*i*self.command_length],4);
    }

    [self init_command_variables];

}

-(void)init_command_variables{
    
    // now zero out everything
    for (int i = 0; i < self.command_length*4; i++) {
        cmd[i] = 0;
    }
    self.command_length = 0;
}

-(void)test:(int)hvvalue{
    //private method
}

-(int)get_command:(int) index{
    return cmd[index];
}

-(void)create_cmd_hv:(int) voltage
{	
    // schriste - output checked with sethv
    
    // create the command
    int cmd_voltage;
    // convert to command voltage
    cmd_voltage = voltage*8;
    
    if (cmd_voltage < 4095) {
        cmd[0] = 0xf0;
        cmd[1] = (unsigned char) ( (cmd_voltage >> 8) & 0xf);
        cmd[2] = (unsigned char) (cmd_voltage & 0xff);
        cmd[3] = 0x0;
        cmd[3] ^= cmd[0];
        cmd[3] ^= cmd[1];
        cmd[3] ^= cmd[2]; 
        
        self.command_readable = [NSString stringWithFormat:@"HV to %i", voltage];
        self.commandCount++;
        self.command_length = 1;
    } else {
        NSLog(@" Voltage value, %d, greater than maximum 511 (cmd 4095).\n",(int) voltage);
    }
}

-(void)create_cmd_attenuator:(bool) state
{
    // create a command to enable the attenuator
    //
    // schriste - checked with attenuator0 and attenuator1

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
    
    self.command_readable = [NSString stringWithFormat:@"Attenuator strobe %i", state];
    self.commandCount++;
    self.command_length = 1;
}

-(void)create_cmd_stripoff:(NSInteger) detector_number: (NSInteger) strip_number
{
    // create command to turn a strip off
    
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
    self.command_length = 1;
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
        
        self.command_readable = [NSString stringWithFormat:@"Det %i threshold to %i", detector_number, threshhold];
        self.command_length = 1;
        self.commandCount++;
    }
    
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
    
    cmd[9] = 0xf8;
    cmd[10] = 0x02;
    cmd[11] = (unsigned char) ( (clock_lo >> 16) & 0xff);
    cmd[12] = 0x0;
    cmd[13] ^= cmd[0];
    cmd[13] ^= cmd[1];
    cmd[13] ^= cmd[2];
    
    cmd[14] = 0xf8;
    cmd[15] = 0x03;
    cmd[16] = (unsigned char) ( (clock_lo >> 24) & 0xff);
    cmd[17] = 0x0;
    cmd[18] ^= cmd[0];
    cmd[18] ^= cmd[1];
    cmd[18] ^= cmd[2];
  
    cmd[19] = 0xf8;
    cmd[20] = 0x07;
    cmd[21] = 0x0;
    cmd[22] = 0x0;
    cmd[23] ^= cmd[0];
    cmd[23] ^= cmd[1];
    cmd[23] ^= cmd[2];
  
    cmd[24] = 0xf8;
    cmd[25] = 0x04;
    cmd[26] = (unsigned char) (clock_hi &0xff);
    cmd[27] = 0x0;
    cmd[27] ^= cmd[0];
    cmd[27] ^= cmd[1];
    cmd[27] ^= cmd[2];
 
    cmd[28] = 0xf8;
    cmd[29] = 0x05;
    cmd[30] = (unsigned char) ( (clock_hi >> 8) & 0xff);
    cmd[31] = 0x0;
    cmd[32] ^= cmd[0];
    cmd[32] ^= cmd[1];
    cmd[32] ^= cmd[2];

    self.command_readable = [NSString stringWithFormat:@"Clock to %i %i", clock_hi, clock_lo];
    self.command_length = 8;
    self.commandCount+= 7;
}

//-(void)send_one_command
//{
//    int fsercmd;
//    
//    fsercmd = [self command_initialize_serial];
//    if (fsercmd > 0){write(fsercmd, &cmd[0],self.command_length);}
//    sleep(1);
//}


-(int)command_initialize_serial:(bool)testmode
{
    // private
    // initialize connection to serial
	int status;
	int fsercmd;
    int ttyout;
    char serial_device_fname[40];
    struct stat mystat;
    int devicefile;
    struct termios sertty;

    if (testmode == TRUE) {
        strcpy(serial_device_fname, "/Users/schriste/Desktop/test.dat");
    } else
    {
        strcpy(serial_device_fname, "/dev/tty.KeySerial1");
    }
    
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
