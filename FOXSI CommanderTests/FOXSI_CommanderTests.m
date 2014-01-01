//
//  FOXSI_CommanderTests.m
//  FOXSI CommanderTests
//
//  Created by Steven Christe on 12/30/13.
//  Copyright (c) 2013 ehSwiss Studios. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FOXSI_Commander.h"

@interface FOXSI_CommanderTests : XCTestCase
@property (strong, nonatomic) FOXSI_Commander *commander;
@end

@implementation FOXSI_CommanderTests

- (void)setUp
{
    [super setUp];
    self.commander = [[FOXSI_Commander alloc] init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testHVto200VCommand
{
    unsigned char cmd[4];
    cmd[0] = 0xf0;
    cmd[1] = 0x06;
    cmd[2] = 0x40;
    cmd[3] = 0xb6;
    
    [self.commander create_cmd_hv:200];
    
    for (int i = 0; i < 4; i++) {
        XCTAssertEqual((unsigned char)[self.commander get_command:i], cmd[i]);
    }
}

- (void)testHVto0VCommand
{
    unsigned char cmd[4];
    cmd[0] = 0xf0;
    cmd[1] = 0x00;
    cmd[2] = 0x00;
    cmd[3] = 0xf0;
    
    [self.commander create_cmd_hv:0];
    
    for (int i = 0; i < 4; i++) {
        XCTAssertEqual((unsigned char)[self.commander get_command:i], cmd[i]);
    }
}

- (void)testHVto20VCommand
{
    unsigned char cmd[4];
    cmd[0] = 0xf0;
    cmd[1] = 0x00;
    cmd[2] = 0xa0;
    cmd[3] = 0x50;
    
    [self.commander create_cmd_hv:20];
    
    for (int i = 0; i < 4; i++) {
        XCTAssertEqual((unsigned char)[self.commander get_command:i], cmd[i]);
    }
}

- (void)testStrobeAtten0
{
    unsigned char cmd[4];
    cmd[0] = 0xe8;
    cmd[1] = 0x00;
    cmd[2] = 0x00;
    cmd[3] = 0xe8;
    
    [self.commander create_cmd_attenuator:0];
    
    for (int i = 0; i < 4; i++) {
        XCTAssertEqual((unsigned char)[self.commander get_command:i], cmd[i]);
    }
}

- (void)testStrobeAtten1
{
    unsigned char cmd[4];
    cmd[0] = 0xe8;
    cmd[1] = 0x01;
    cmd[2] = 0x00;
    cmd[3] = 0xe9;
    
    [self.commander create_cmd_attenuator:1];
    
    for (int i = 0; i < 4; i++) {
        XCTAssertEqual((unsigned char)[self.commander get_command:i], cmd[i]);
    }
}

- (void)testSripOff0
{
    unsigned char cmd[4];
    cmd[0] = 0xc0;
    cmd[1] = 0x06;
    cmd[2] = 0x25;
    cmd[3] = 0xe3;
    
    [self.commander create_cmd_stripoff:6 :26];
    
    for (int i = 0; i < 4; i++) {
        XCTAssertEqual((unsigned char)[self.commander get_command:i], cmd[i]);
    }
}

- (void)testSripOff1
{
    unsigned char cmd[4];

    cmd[0] = 0xc0;
    cmd[1] = 0x04;
    cmd[2] = 0x4d;
    cmd[3] = 0x89;
    
    [self.commander create_cmd_stripoff:4 :114];
    
    for (int i = 0; i < 4; i++) {
        XCTAssertEqual((unsigned char)[self.commander get_command:i], cmd[i]);
    }
}

- (void)testSripOff2
{
    unsigned char cmd[4];

    cmd[0] = 0xc0;
    cmd[1] = 0x01;
    cmd[2] = 0x12;
    cmd[3] = 0xd3;
    
    [self.commander create_cmd_stripoff:1 :45];
    
    for (int i = 0; i < 4; i++) {
        XCTAssertEqual((unsigned char)[self.commander get_command:i], cmd[i]);
    }
}

- (void)testSripOff3
{
    unsigned char cmd[4];

    cmd[0] = 0xc0;
    cmd[1] = 0x01;
    cmd[2] = 0x3f;
    cmd[3] = 0xfe;
    
    [self.commander create_cmd_stripoff:1 :0];
    
    for (int i = 0; i < 4; i++) {
        XCTAssertEqual((unsigned char)[self.commander get_command:i], cmd[i]);
    }
}

- (void)testSripOff4
{
    unsigned char cmd[4];

    cmd[0] = 0xc0;
    cmd[1] = 0x00;
    cmd[2] = 0x3f;
    cmd[3] = 0xff;
    
    [self.commander create_cmd_stripoff:0 :0];
    
    for (int i = 0; i < 4; i++) {
        XCTAssertEqual((unsigned char)[self.commander get_command:i], cmd[i]);
    }
}

- (void)testSetThreshold0
{
    unsigned char cmd[4];
    
    cmd[0] = 0xc0;
    cmd[1] = 0x04;
    cmd[2] = 0x9e;
    cmd[3] = 0x5a;
    
    [self.commander create_cmd_setthreshold:4 :0 :30];
    
    for (int i = 0; i < 4; i++) {
        XCTAssertEqual((unsigned char)[self.commander get_command:i], cmd[i]);
    }
}

- (void)testSetThreshold1
{
    unsigned char cmd[4];
    
    cmd[0] = 0xc0;
    cmd[1] = 0x02;
    cmd[2] = 0x9e;
    cmd[3] = 0x5c;
    
    [self.commander create_cmd_setthreshold:2 :0 :30];
    
    for (int i = 0; i < 4; i++) {
        XCTAssertEqual((unsigned char)[self.commander get_command:i], cmd[i]);
    }
}

- (void)testSetThreshold2
{
    unsigned char cmd[4];
    
    cmd[0] = 0xc0;
    cmd[1] = 0x00;
    cmd[2] = 0xde;
    cmd[3] = 0x1e;
    
    [self.commander create_cmd_setthreshold:0 :1 :30];
    
    for (int i = 0; i < 4; i++) {
        XCTAssertEqual((unsigned char)[self.commander get_command:i], cmd[i]);
    }
}

- (void)testSetThreshold3
{
    unsigned char cmd[4];
    
    cmd[0] = 0xc0;
    cmd[1] = 0x01;
    cmd[2] = 0x8a;
    cmd[3] = 0x4b;
    
    [self.commander create_cmd_setthreshold:1 :0 :10];
    
    for (int i = 0; i < 4; i++) {
        XCTAssertEqual((unsigned char)[self.commander get_command:i], cmd[i]);
    }
}

- (void)testSetThreshold4
{
    unsigned char cmd[4];
    
    cmd[0] = 0xc0;
    cmd[1] = 0x00;
    cmd[2] = 0x80;
    cmd[3] = 0x40;
    
    [self.commander create_cmd_setthreshold:0 :0 :0];
    
    for (int i = 0; i < 4; i++) {
        XCTAssertEqual((unsigned char)[self.commander get_command:i], cmd[i]);
    }
}

- (void)testSetThreshold5
{
    unsigned char cmd[4];
    
    cmd[0] = 0xc0;
    cmd[1] = 0x00;
    cmd[2] = 0xc1;
    cmd[3] = 0x01;
    
    [self.commander create_cmd_setthreshold:0 :1 :1];
    
    for (int i = 0; i < 4; i++) {
        XCTAssertEqual((unsigned char)[self.commander get_command:i], cmd[i]);
    }
}

- (void)testResetClock
{
    unsigned char cmd[28];
    
    cmd[0] = 0xf8;
    cmd[1] = 0x00;
    cmd[2] = 0x00;
    cmd[3] = 0xf8;
    
    cmd[4] = 0xf8;
    cmd[5] = 0x01;
    cmd[6] = 0x00;
    cmd[7] = 0xf9;

    cmd[8] = 0xf8;
    cmd[9] = 0x02;
    cmd[10] = 0x00;
    cmd[11] = 0xfa;
    
    cmd[12] = 0xf8;
    cmd[13] = 0x03;
    cmd[14] = 0x00;
    cmd[15] = 0xfb;
    
    cmd[16] = 0xf8;
    cmd[17] = 0x07;
    cmd[18] = 0x00;
    cmd[19] = 0xff;
    
    cmd[20] = 0xf8;
    cmd[21] = 0x04;
    cmd[22] = 0x00;
    cmd[23] = 0xfc;
    
    cmd[24] = 0xf8;
    cmd[25] = 0x05;
    cmd[26] = 0x00;
    cmd[27] = 0xfd;
    
    [self.commander create_cmd_clock:0 :0];

    for (int i = 0; i < 28; i++) {
        XCTAssertEqual((unsigned char)[self.commander get_command:i], cmd[i]);
    }
}



@end
