//
//  Commander.h
//  FOXSI Commander
//
//  Created by Steven Christe on 3/23/12.
//  Copyright 2012 NASA GSFC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Commander : NSObject

//@property (assign) unsigned char *cmd;
@property (assign) float volume;
@property (assign) int commandCount;
@property (assign) int command_length;
@property (assign) NSString *command_readable;

-(void)create_cmd_hv:(int) hvvalue;
-(void)create_cmd_attenuator:(bool) state;
-(void) create_cmd_setthreshold:(NSInteger) detector_number: (NSInteger) threshhold;
-(void)create_cmd_stripoff:(NSInteger) detector_number: (NSInteger) strip_number;
-(void)create_cmd_clock:(long long) clock_lo: (long long) clock_hi;
-(void)send_command;

@end
