//
//  RONFATest.m
//  RORegEx
//
//  Created by Riku Oja on 18.12.2014.
//  Copyright (c) 2014 Riku Oja. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "RONFA.h"

@interface RONFATest : XCTestCase

@end

@implementation RONFATest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testNFAConstruction {
    RONFA* NFA = [[RONFA alloc] initWithRegEx:@""];
    XCTAssertFalse(NFA==nil, @"NFA exists");
}

- (void)testLetterMatch {
    RONFA* NFA = [[RONFA alloc] initWithRegEx:@"a"];
    XCTAssert(NSEqualRanges([NFA findMatch:@"a"],NSMakeRange(0, 1)), @"Matches single letters");
}

- (void)testLetterMisMatch {
    RONFA* NFA = [[RONFA alloc] initWithRegEx:@"a"];
    XCTAssert(NSEqualRanges([NFA findMatch:@"b"],NSMakeRange(0, 0)), @"Recognizes letter mismatch");
}

- (void)testStringPartialFirstMatch {
    RONFA* NFA = [[RONFA alloc] initWithRegEx:@"aa"];
    XCTAssert(NSEqualRanges([NFA findMatch:@"blaa"],NSMakeRange(2, 2)), @"Returns correct partial match");
}

- (void)testStringMatch {
    RONFA* NFA = [[RONFA alloc] initWithRegEx:@"blaa"];
    XCTAssert(NSEqualRanges([NFA findMatch:@"blaa"],NSMakeRange(0, 4)), @"Returns correct complete string match");
}

- (void)testStringMisMatch {
    RONFA* NFA = [[RONFA alloc] initWithRegEx:@"blaa"];
    XCTAssert(NSEqualRanges([NFA findMatch:@"blab"],NSMakeRange(0, 0)), @"Recognizes string mismatch");
}

- (void)testExtraLetters {
    RONFA* NFA = [[RONFA alloc] initWithRegEx:@"baa"];
    XCTAssert(NSEqualRanges([NFA findMatch:@"blaa"],NSMakeRange(0, 0)), @"Notices extra letters");
}

- (void)testNondeterminism {
    RONFA* NFA = [[RONFA alloc] initWithRegEx:@"baa"];
    XCTAssert(NSEqualRanges([NFA findMatch:@"bbaa"],NSMakeRange(1, 3)), @"Allows nondeterminism");
}

- (void)testAnyCharacterMatch {
    RONFA* NFA = [[RONFA alloc] initWithRegEx:@"aa.a"];
    XCTAssert(NSEqualRanges([NFA findMatch:@"aaaa"],NSMakeRange(0, 4)), @"Correct . match");
}

- (void)testZeroCharactersMatch {
    RONFA* NFA = [[RONFA alloc] initWithRegEx:@"aa*a"];
    XCTAssert(NSEqualRanges([NFA findMatch:@"aaa"],NSMakeRange(0, 3)), @"Correct * match");
}

- (void)testAnyStringMatch {
    RONFA* NFA = [[RONFA alloc] initWithRegEx:@"a*a"];
    XCTAssert(NSEqualRanges([NFA findMatch:@"abffa"],NSMakeRange(0, 5)), @"Correct * match");
}

- (void)testOperatorCombination {
    RONFA* NFA = [[RONFA alloc] initWithRegEx:@"a*a."];
    XCTAssert(NSEqualRanges([NFA findMatch:@"graaaaagh"],NSMakeRange(2, 3)), @"Correct *a. match");
}

- (void)testParentheses {
    RONFA* NFA = [[RONFA alloc] initWithRegEx:@"(a)a"];
    XCTAssert(NSEqualRanges([NFA findMatch:@"aa"],NSMakeRange(0, 2)), @"Correct subNFA recursion");
}

- (void)testSeveralParenthesesAndOperators {
    RONFA* NFA = [[RONFA alloc] initWithRegEx:@"((*)*)a"];
    XCTAssert(NSEqualRanges([NFA findMatch:@"aa"],NSMakeRange(0, 1)), @"Correct minimal nested operator match");
}


- (void)testOR {
    RONFA* NFA = [[RONFA alloc] initWithRegEx:@"a|b"];
    XCTAssert(NSEqualRanges([NFA findMatch:@"b"],NSMakeRange(0, 1)), @"Correct OR match");
}


- (void)testORWithParentheses {
    RONFA* NFA = [[RONFA alloc] initWithRegEx:@"(aaaargh)|b"];
    XCTAssert(NSEqualRanges([NFA findMatch:@"b"],NSMakeRange(0, 1)), @"Correct OR match");
}

- (void)testORWithOperators {
    RONFA* NFA = [[RONFA alloc] initWithRegEx:@"(aa|ca*)|d"];
    XCTAssert(NSEqualRanges([NFA findMatch:@"bllcaaaaa"],NSMakeRange(3, 2)), @"Correct OR match");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
