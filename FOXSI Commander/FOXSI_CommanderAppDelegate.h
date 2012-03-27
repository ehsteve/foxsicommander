//
//  FOXSI_CommanderAppDelegate.h
//  FOXSI Commander
//
//  Created by Steven Christe on 3/23/12.
//  Copyright 2012 NASA GSFC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Commander;

@interface FOXSI_CommanderAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    NSTextField *voltage_input;
    NSTextField *command_display;
    NSTextView *command_history_display;
    NSSegmentedControl *detector_chooser;
    NSTextField *strip_chooser;
    NSTextField *threshold_chooser;
    NSStepperCell *strip_stepper;
    NSStepperCell *threshold_stepper;
}

@property (assign) IBOutlet NSWindow *window;

@property (assign) IBOutlet NSTextField *voltage_input;
@property (assign) IBOutlet NSTextField *command_display;
@property (assign) IBOutlet NSTextView *command_history_display;
@property (assign) IBOutlet NSSegmentedControl *detector_chooser;
@property (assign) IBOutlet NSTextField *strip_chooser;
@property (assign) IBOutlet NSTextField *threshold_chooser;
@property (assign) IBOutlet NSStepperCell *strip_stepper;
@property (assign) IBOutlet NSStepperCell *threshold_stepper;

@property (assign) Commander *commander;

- (IBAction)voltage_toX_push:(id)sender;
- (IBAction)voltage_to0_push:(id)sender;
- (IBAction)voltage_to200_push:(id)sender;
- (IBAction)send_command:(id)sender;
- (IBAction)attenuator_strobe1_push:(id)sender;
- (IBAction)attenuator_strobe2_push:(id)sender;
- (IBAction)strip_disable_push:(id)sender;
- (IBAction)threshold_set_push:(id)sender;
- (IBAction)sync_strip_stepper:(id)sender;
- (IBAction)sync_threshold_stepper:(id)sender;
- (IBAction)clock_reset_push:(id)sender;

- (IBAction)strip_stepper_action:(id)sender;
- (IBAction)threshold_stepper_action:(id)sender;
- (void)update_command_display:(id)sender;
- (void)update_command_buffer:(id)sender;

@end
