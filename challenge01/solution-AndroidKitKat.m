//
//  solution-AndroidKitKat.m
//  control-alt-delete
//
//  Created by skg on 10/1/21.
//
//  Compile with:
//  $ clang -x objective-c -fobjc-arc solution-AndroidKitKat.m -o solution-AndroidKitKat
//


#import <Foundation/Foundation.h>

// Globals
char * PROGRAM_NAME = NULL;

// Usage
void usage(int status) {
    fprintf(stderr, "Usage: %s FILE\n", PROGRAM_NAME);
    exit(status);
}

// CipherSolver.h
@interface  CipherSolver: NSObject

@property (getter=keyGet, setter=keySet:) NSString* key;

- (NSString*) crack:(NSString*)str;

@end

@implementation CipherSolver
- (NSString*) crack:(NSString *)str
{
    NSMutableString *cracked = [NSMutableString stringWithCapacity:[str length]];
    for (int i = 0; i < [str length]; i++)
    {
        char c = [str characterAtIndex:i] - 'A';
        char k = [_key characterAtIndex:(i % [_key length])] - 'A';
        char t = ((26 + c - k) % 26) + 'A';
        [cracked insertString:[NSString stringWithUTF8String:&t] atIndex:i];
    }
    return cracked;
}
@end

// Input function
NSMutableArray* parse_input(NSString* input)
{
    return [NSMutableArray arrayWithArray:[input componentsSeparatedByString:@"\n"]];
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
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
        
        CipherSolver *solver = [[CipherSolver alloc] init];
        [solver keySet: @"UNIX"];
        NSMutableArray *parsed = [NSMutableArray new];
        // read from stdin
        if (argind == argc) {
            parsed = parse_input([[NSString alloc] initWithData:[[NSFileHandle fileHandleWithStandardInput] availableData] encoding:NSUTF8StringEncoding]);
        } else { // read from file on command line
            NSString *filePath = [NSString stringWithCString:argv[argind] encoding:NSUTF8StringEncoding];
            parsed = parse_input([NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL]);
        }
        

        // ugly username and password extraction, but it works
        NSString *username = [[[parsed objectAtIndex:0]
                               componentsSeparatedByString:@" "] objectAtIndex:1];
        NSString *password = [[[parsed objectAtIndex:1]
                               componentsSeparatedByString:@" "] objectAtIndex:1];
        NSLog(@"%@", [solver crack:username]);
        NSLog(@"%@", [solver crack:password]);
        
        
    }
    return 0;
}
