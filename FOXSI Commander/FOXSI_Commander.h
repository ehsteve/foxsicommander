//
//  FOXSI_Commander.h
//  FOXSI Commander
//
//  Created by Steven Christe on 12/30/13.
//  Copyright (c) 2013 ehSwiss Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FOXSI_Commander : NSObject

//@property (assign) unsigned char *cmd;
@property (assign) float volume;
@property (assign) int commandCount;
@property (assign) int command_length;
@property (assign) int fsercmd;

@property (assign) NSString *command_readable;
@property (assign) NSString *serial_device_name;

-(void)create_cmd_hv:(int) hvvalue;
-(void)create_cmd_attenuator:(bool) state;
-(void)create_cmd_setthreshold:(NSInteger)detector_number :(NSInteger)asic :(int)threshhold;
-(void)create_cmd_stripoff:(NSInteger)detector_number :(int)strip_number;
-(void)create_cmd_clock:(long long) clock_lo :(long long)clock_hi;
-(void)send_command:(bool)testmode;
-(int)get_command:(int)index;

@end
