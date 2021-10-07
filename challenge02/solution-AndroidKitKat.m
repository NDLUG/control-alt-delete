//
//  solution-AndroidKitKat.m
//  control-alt-delete challenge02
//
//  Created by skg on 10/1/21.
//

#import <Foundation/Foundation.h>

// Globals
char * PROGRAM_NAME = NULL;

// Usage
void usage(int status) {
    fprintf(stderr, "Usage: %s FILE\n", PROGRAM_NAME);
    exit(status);
}

// OPCode enum
typedef enum : NSUInteger {
    ACC,
    JMP,
    NOP,
} OPCode;

// Sign enum
typedef enum : NSUInteger {
    Positive,
    Negative,
} Sign;


@interface Firmware : NSObject
@property (getter=accumulatorGet,
           setter=accumulatorSet:)NSInteger accumulator;
@property (getter=programCounterGet,
           setter=programCounterSet:)NSInteger programCounter;
@property (nonatomic, retain) NSMutableArray* encounteredInstructions;
@property (nonatomic, retain) NSMutableArray* operations;
// Class methods
+ (OPCode) getOpCodeFromBinaryData:(NSString*)bindat;
+ (Sign) getSignFromBinaryData:(NSString*)bindat;
+ (NSInteger) getValueFromBinaryData:(NSString*)bindat;
+ (NSInteger) compute:(Firmware*)firmware;
+ (NSInteger) bruteforce:(Firmware*)firmware;
-(id)copyWithZone:(NSZone *)zone;
@end

@interface Operation : NSObject

@property OPCode opcode;
@property Sign sign;
@property NSInteger value;

- (id) initWithBinaryData:(NSString*) binaryData;

@end

@implementation Firmware

@synthesize accumulator;
@synthesize programCounter;
@synthesize operations;
@synthesize encounteredInstructions;

- (id) init
{
    operations = [NSMutableArray new];
    encounteredInstructions = [NSMutableArray new];
    return self;
}

+ (OPCode) getOpCodeFromBinaryData:(NSString*)bindat
{

    NSString *opCodeString = [bindat substringWithRange:NSMakeRange(0, 2)];
    NSInteger opCode = strtol([opCodeString cStringUsingEncoding:NSUTF8StringEncoding], NULL, 2);
    switch (opCode)
    {
        case 0:
            return NOP;
            break;
        case 1:
            return ACC;
            break;
        case 2:
            return JMP;
            break;
        default:
            return (OPCode)NULL;
            break;
    }
}

+ (Sign) getSignFromBinaryData:(NSString*)bindat
{
    NSString *signString = [bindat substringWithRange:NSMakeRange(2, 1)];
    NSInteger sign = strtol([signString cStringUsingEncoding:NSUTF8StringEncoding], NULL, 10);
    switch (sign)
    {
        case 0:
            return Positive;
            break;
        case 1:
            return Negative;
            break;
        default:
            return (Sign)NULL;
            break;
    }
}

+ (NSInteger) getValueFromBinaryData:(NSString*)bindat
{
    NSString *valueString = [bindat substringWithRange:NSMakeRange(3, 13)];
    NSInteger value = strtol([valueString cStringUsingEncoding:NSUTF8StringEncoding], NULL, 2);
    return value;
}

+ (NSInteger) compute:(Firmware*)firmware
{
    bool loopDetected = false;
    [firmware programCounterSet:0];
    while (!loopDetected)
    {
        if ([[firmware encounteredInstructions] containsObject:[NSNumber numberWithLong:[firmware programCounterGet]]])
        {
            loopDetected = true;
            break;
        }
        [[firmware encounteredInstructions] addObject:[NSNumber numberWithLong:[firmware programCounterGet] ]];

        if ([firmware programCounterGet] >= [[firmware operations] count])
        {
            NSLog(@"Part 2: %ld", (long)[firmware accumulatorGet]);
            return [firmware accumulatorGet];
        }
        Operation* currentOp = [[firmware operations] objectAtIndex:[firmware programCounterGet]];
        
        switch ([currentOp opcode])
        {
            case ACC:
                switch ([currentOp sign]) {
                    case Positive:
                        [firmware accumulatorSet:[firmware accumulatorGet] + [currentOp value]];
                        break;
                    case Negative:
                        [firmware accumulatorSet:[firmware accumulatorGet] - [currentOp value]];
                        break;
                    default:
                        break;
                }
                [firmware programCounterSet:[firmware programCounterGet] + 1];
                break;
            case JMP:
                switch ([currentOp sign])
                {
                    case Positive:
                        [firmware programCounterSet:[firmware programCounterGet] + [currentOp value]];
                        break;
                    case Negative:
                        [firmware programCounterSet:[firmware programCounterGet] - [currentOp value]];
                        break;
                    default:
                        break;
                }
                break;
            case NOP:
                [firmware programCounterSet:[firmware programCounterGet] + 1];
                break;
            default:
                break;
        }
    }
    return [firmware accumulatorGet];
}

+ (NSInteger) bruteforce:(Firmware*)firmware
{
    // I guess since we can't use the original.
    [[firmware operations] enumerateObjectsUsingBlock:^(id operation, NSUInteger idx, BOOL *stop) {
        switch ([operation opcode])
        {
            case NOP:
                [operation setOpcode:JMP];
                [Firmware compute:[firmware copy]];
                break;
            case JMP:
                [operation setOpcode:NOP];
                [Firmware compute:[firmware copy]];
            default:
                break;
        }
    }];
    return 0;
}

- (id)copyWithZone:(NSZone *)zone
{
    Firmware *fw = [[Firmware allocWithZone:zone]init];
    fw->operations = [operations mutableCopy];
    fw->encounteredInstructions = [encounteredInstructions mutableCopy];
    return fw;
}

@end

// Operation must be a class if I want to use NSMutableArray
// since it can only contain objectice-c objects

@implementation Operation

- (id) initWithBinaryData:(NSString*) binaryData
{
    _opcode = [Firmware getOpCodeFromBinaryData:binaryData];
    _sign = [Firmware getSignFromBinaryData:binaryData];
    _value = [Firmware getValueFromBinaryData:binaryData];
    return self;
}

@end


// Input function
NSMutableArray* parse_input(NSString* input)
{
    NSMutableArray *parsed =[NSMutableArray arrayWithArray:[input componentsSeparatedByString:@"\n"]];
    [parsed removeLastObject];
    return parsed;
}

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        int argind = 1;
        PROGRAM_NAME = (char*)argv[0];
        while (argind < argc && strlen(argv[argind]) > 1 && argv[argind][0] == '-') {
            const char *arg = argv[argind++];
            switch (arg[1]) {
                case 'h':
                    usage(0);
                    break;
                default:
                    usage(1);
                    break;
            }
        }
        NSMutableArray *parsed = [NSMutableArray new];
        // read from stdin
        if (argind == argc)
        {
            parsed = parse_input([[NSString alloc] initWithData:[[NSFileHandle fileHandleWithStandardInput] availableData] encoding:NSUTF8StringEncoding]);
        }
        else
        { // read from file on command line
            NSString *filePath = [NSString stringWithCString:argv[argind] encoding:NSUTF8StringEncoding];
            parsed = parse_input([NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL]);
        }
//        NSLog(@"%@", parsed);
        Firmware *firmware = [Firmware new];
        for (id operation in parsed)
        {
            [[firmware operations] addObject:[[Operation alloc] initWithBinaryData:operation] ];
        }
        NSLog(@"Part 1: %lu", [Firmware compute:firmware]);
        Firmware *pt2 = [Firmware new];
        for (id operation in parsed)
        {
            [[pt2 operations] addObject:[[Operation alloc] initWithBinaryData:operation] ];
        }
        [Firmware bruteforce:pt2];
    }
    return 0;
}

