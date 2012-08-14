//
//  FOXSI_CommanderAppDelegate.m
//  FOXSI Commander
//
//  Created by Steven Christe on 3/23/12.
//  Copyright 2012 NASA GSFC. All rights reserved.
//

#import "FOXSI_CommanderAppDelegate.h"
#import "Commander.h"

@implementation FOXSI_CommanderAppDelegate

@synthesize window;
@synthesize voltage_input;
@synthesize command_history_display;
@synthesize detector_chooser;
@synthesize strip_chooser;
@synthesize threshold_chooser;
@synthesize strip_stepper;
@synthesize threshold_stepper;
@synthesize send_button;
@synthesize system_arm_button;
@synthesize testmode_chooser;

@synthesize commander = _commander;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    Commander *aCommander = [[Commander alloc] init];
    [self setCommander:aCommander];
}

- (IBAction)voltage_toX_push:(id)sender {
    int newVoltage = [voltage_input intValue];
    
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

- (IBAction)send_command:(id)sender {
    NSString *command_history_buffer;
    NSRange myrange;
    NSString *command_string_line = [NSString stringWithFormat:@" Sent\n"];
    
    command_history_buffer = [command_history_display string];
    command_history_buffer = [[command_history_buffer substringToIndex:[command_history_buffer length]-1] stringByAppendingString:command_string_line];
    
    // replace the text with new info
    [command_history_display setString:command_history_buffer];
    
    // scroll the text down
    myrange.length = [command_history_buffer length];
    [command_history_display scrollRangeToVisible:myrange];
    
    if (self.testmode_chooser.selectedSegment == 1) {
        [self.commander send_command:1];
    } else {
        [self.commander send_command:0];
    }
    
    self.system_arm_button.selectedSegment = 0;
    self.send_button.enabled = NO;
}

- (IBAction)strip_disable_push:(id)sender{
    [self.commander create_cmd_stripoff:[self.detector_chooser selectedSegment]:[self.strip_chooser intValue]];
    [self update_command_display:nil];    
}

- (IBAction)threshold_set_push:(id)sender {
    [self.commander create_cmd_setthreshold:[self.detector_chooser selectedSegment]:[self.threshold_chooser intValue]];
    [self update_command_display:nil];
}

- (IBAction)sync_strip_stepper:(id)sender {
    [self.strip_stepper setIntValue:[self.strip_chooser intValue]];
}

- (IBAction)sync_threshold_stepper:(id)sender {
    [self.threshold_stepper setIntValue:[self.threshold_chooser intValue]];
}

- (IBAction)clock_reset_push:(id)sender {
    [self.commander create_cmd_clock:0:0];
    [self update_command_display:nil];
}

- (IBAction)strip_stepper_action:(id)sender {
    [self.strip_chooser setIntValue: [strip_stepper intValue]];
}

- (IBAction)threshold_stepper_action:(id)sender {
    [self.threshold_chooser setIntValue: [threshold_stepper intValue]];
}

- (IBAction)attenuator_strobe1_push:(id)sender {
    [self.commander create_cmd_attenuator:1];    
    [self update_command_display:nil];
}

- (IBAction)attenuator_strobe2_push:(id)sender {
    [self.commander create_cmd_attenuator:0];
    [self update_command_display:nil];
}

- (void) update_command_display:(id)sender{
    
    NSRange myrange;
    NSString *command_history_buffer;
    
    for (int i = 0; i < self.commander.command_length; i++) {
    
        NSString *command_string_line = [NSString stringWithFormat:@"[%02i] %@ (%02x %02x %02x %02x)\n", i + self.commander.commandCount - self.commander.command_length + 1, self.commander.command_readable, [self.commander get_command:0+4*i], [self.commander get_command:1+4*i], [self.commander get_command:2+4*i], [self.commander get_command:3+4*i]];
        
        command_history_buffer = [command_history_display string];
        command_history_buffer = [command_history_buffer stringByAppendingString:command_string_line];
        
        // replace the text with new info
        [command_history_display setString:command_history_buffer];
        
        // scroll the text down
        myrange.length = [command_history_buffer length];
        [command_history_display scrollRangeToVisible:myrange];  
    }
}

//- (NSString *)create_command_string:(id)sender {
//    
//    NSString *command_string_line = [NSString stringWithFormat:@"[%02i] %@ (%02x %02x %02x %02x)\n",self.commander.commandCount, self.commander.command_readable, cmd[0],cmd[1],cmd[2],cmd[3]];
//
//    return command_string_line;
//}

- (void)update_text_display:(id)sender: (NSString *) text_to_display{

   }


@end
