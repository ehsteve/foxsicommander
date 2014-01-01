//
//  FOXSI_WindowController.h
//  FOXSI Commander
//
//  Created by Steven Christe on 12/30/13.
//  Copyright (c) 2013 ehSwiss Studios. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FOXSI_WindowController : NSWindowController

@property (weak) IBOutlet NSButton *send_button;

@property (weak) IBOutlet NSTextField *voltage_input;
@property (weak) IBOutlet NSSegmentedControl *thresholdSet_detector_chooser;
@property (weak) IBOutlet NSSegmentedControl *stripDisable_detector_chooser;

@property (weak) IBOutlet NSTextField *strip_chooser;
@property (weak) IBOutlet NSStepperCell *strip_stepper;
@property (weak) IBOutlet NSStepperCell *threshold_stepper;
@property (weak) IBOutlet NSSegmentedControl *system_arm_button;
@property (weak) IBOutlet NSSegmentedControl *testmode_chooser;
@property (weak) IBOutlet NSSegmentedControl *asic_chooser;
@property (weak) IBOutlet NSTextField *device_name;
@property (weak) IBOutlet NSTextField *threshold_chooser;
@property (unsafe_unretained) IBOutlet NSTextView *command_history_display;

- (IBAction)send_button:(NSButton *)sender;
- (IBAction)voltage_toX_push:(id)sender;
- (IBAction)voltage_to0_push:(id)sender;
- (IBAction)voltage_to200_push:(id)sender;
- (IBAction)attenuator_strobe1_push:(id)sender;
- (IBAction)attenuator_strobe2_push:(id)sender;
- (IBAction)strip_disable_push:(id)sender;
- (IBAction)threshold_set_push:(id)sender;
- (IBAction)sync_strip_stepper:(id)sender;
- (IBAction)sync_threshold_stepper:(id)sender;
- (IBAction)clock_reset_push:(id)sender;
- (IBAction)system_arm:(id)sender;
- (IBAction)set_device_name:(id)sender;

- (IBAction)strip_stepper_action:(id)sender;
- (IBAction)threshold_stepper_action:(id)sender;

- (void)update_command_display:(id)sender;
- (void)update_text_display:(NSString *) text_to_display;

@end
