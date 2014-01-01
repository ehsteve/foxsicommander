//
//  FOXSI_WindowController.m
//  FOXSI Commander
//
//  Created by Steven Christe on 12/30/13.
//  Copyright (c) 2013 ehSwiss Studios. All rights reserved.
//

#import "FOXSI_WindowController.h"
#import "FOXSI_Commander.h"

@interface FOXSI_WindowController ()
@property (strong, nonatomic) FOXSI_Commander *commander;
@end

@implementation FOXSI_WindowController

@synthesize device_name;
@synthesize voltage_input;
@synthesize stripDisable_detector_chooser;
@synthesize thresholdSet_detector_chooser;
@synthesize strip_chooser;
@synthesize strip_stepper;
@synthesize threshold_stepper;
@synthesize threshold_chooser;
@synthesize send_button;
@synthesize system_arm_button;
@synthesize testmode_chooser;
@synthesize asic_chooser;
@synthesize command_history_display;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        self.commander = [[FOXSI_Commander alloc] init];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    //now search for the correct device file
    //tty.USA19Hfa13,1,2,3
    //[device_name setStringValue:@"/dev/tty.KeySerial"];
    //[device_name setTextColor:[NSColor redColor]];
    
    [self.command_history_display setString:@"test"];
    
    NSDirectoryEnumerator *itr =
    [[NSFileManager defaultManager] enumeratorAtURL:[NSURL fileURLWithPath:@"/dev/"]
                         includingPropertiesForKeys:nil
                                            options:(NSDirectoryEnumerationSkipsHiddenFiles | NSDirectoryEnumerationSkipsPackageDescendants)
                                       errorHandler:nil];
    for (NSURL *url in itr)
    {
        if( ([[url path] hasPrefix:@"/dev/tty.KeySerial"]) || ([[url path] hasPrefix:@"/dev/tty.USA19H"]))
        {
            int fsercmd;
            // now test if can send commands to it
            if( (fsercmd = open([[url path] UTF8String],O_RDWR | O_NOCTTY | O_NDELAY)) < 0)
            {
                printf("Error opening file %s  (if disk file must exist)\n" ,[[url path] UTF8String]);
            } else
            {
                NSLog(@"found it! %@", [url path]);
                self.commander.serial_device_name = [url path];
                NSLog(@"%@",self.commander.serial_device_name);
                [self.device_name setStringValue:self.commander.serial_device_name];
                [self.device_name setTextColor:[NSColor blackColor]];
                close(fsercmd);
            }
        }
    }
}

- (IBAction)set_device_name:(id)sender {
    NSURL *theURL = [NSURL fileURLWithPath:[self.device_name stringValue] isDirectory:NO];
    NSError *err;
    
    if ([theURL checkResourceIsReachableAndReturnError:&err] == NO){
        [self update_text_display:@"File device not found!\n"];
        [self.device_name setTextColor:[NSColor redColor]];
        NSLog(@"error");
    } else {
        [self update_text_display:@"File device set.\n"];
        [self.device_name setTextColor:[NSColor blackColor]];
        self.commander.serial_device_name = [self.device_name stringValue];
    }
}

- (IBAction)voltage_toX_push:(id)sender {
    int newVoltage = [self.voltage_input intValue];
    
    [self.commander create_cmd_hv:newVoltage];
    [self update_command_display:nil];
}

- (IBAction)voltage_to0_push:(id)sender {
    [self.commander create_cmd_hv:0];
    [self update_command_display:nil];
}

- (IBAction)voltage_to200_push:(id)sender {
    [self.commander create_cmd_hv:200];
    [self update_command_display:nil];
}

- (IBAction)system_arm:(id)sender{
    if (self.system_arm_button.selectedSegment == 0){
        self.send_button.enabled = NO;
    }
    if (self.system_arm_button.selectedSegment == 1) {
        self.send_button.enabled = YES;
    }
}

- (IBAction)send_button:(id)sender {
    NSString *command_history_buffer;
    NSRange myrange;
    NSString *command_string_line = [NSString stringWithFormat:@" Sent\n"];
    
    command_history_buffer = [self.command_history_display string];
    command_history_buffer = [[command_history_buffer substringToIndex:[command_history_buffer length]-1] stringByAppendingString:command_string_line];
    
    // replace the text with new info
    [self.command_history_display setString:command_history_buffer];

    // scroll the text down
    myrange.location = [command_history_buffer length];
    myrange.length = 10;
    [self.command_history_display scrollRangeToVisible:myrange];
    
    if (self.testmode_chooser.selectedSegment == 1) {
        [self.commander send_command:1];
    } else {
        [self.commander send_command:0];
    }
    
    self.system_arm_button.selectedSegment = 0;
    self.send_button.enabled = NO;
}

- (IBAction)strip_disable_push:(id)sender{
    if ([self.strip_chooser intValue] <= 127) {
        [self.commander create_cmd_stripoff:[self.stripDisable_detector_chooser selectedSegment]:[self.strip_chooser intValue]];
        [self update_command_display:nil];
    }
}

- (IBAction)threshold_set_push:(id)sender {
    if ([self.threshold_chooser intValue] <= 31) {
        [self.commander create_cmd_setthreshold:[self.thresholdSet_detector_chooser selectedSegment]:[self.asic_chooser selectedSegment]: [self.threshold_chooser intValue]];
        [self update_command_display:nil];
    }
}

- (IBAction)sync_strip_stepper:(id)sender {
    [self.strip_stepper setIntValue:[self.strip_chooser intValue]];
}

- (IBAction)sync_threshold_stepper:(id)sender {
    [self.threshold_stepper setIntValue:[self.threshold_chooser intValue]];
}

- (IBAction)clock_reset_push:(id)sender {
    [self.commander create_cmd_clock:0LL:0LL];
    [self update_command_display:nil];
}

- (IBAction)strip_stepper_action:(id)sender {
    [self.strip_chooser setIntValue: [strip_stepper intValue]];
}

- (IBAction)threshold_stepper_action:(id)sender {
    [self.threshold_chooser setIntValue: [threshold_stepper intValue]];
}

- (IBAction)attenuator_strobe1_push:(id)sender {
    [self.commander create_cmd_attenuator:0];
    [self update_command_display:nil];
}

- (IBAction)attenuator_strobe2_push:(id)sender {
    [self.commander create_cmd_attenuator:1];
    [self update_command_display:nil];
}

- (void) update_command_display:(id)sender{
    for (int i = 0; i < self.commander.command_length; i++) {
        NSString *command_string_line = [NSString stringWithFormat:@"[%02i] %@ (%02x %02x %02x %02x)\n", i + self.commander.commandCount - self.commander.command_length + 1, self.commander.command_readable, [self.commander get_command:0+4*i], [self.commander get_command:1+4*i], [self.commander get_command:2+4*i], [self.commander get_command:3+4*i]];
        
        [self update_text_display: command_string_line];
    }
}

- (void)update_text_display:(NSString *) text_to_display {
    
    NSRange myrange;
    NSString *text_buffer;
    NSLog(@"%@",text_to_display);
    
    text_buffer = [self.command_history_display string];
    text_buffer = [text_buffer stringByAppendingString: text_to_display];
    
    // replace the text with new info
    [self.command_history_display setString:text_buffer];
    
    // scroll the text down
    myrange.length = 10;
    myrange.location = [text_buffer length];
    [self.command_history_display scrollRangeToVisible:myrange];
}

@end
