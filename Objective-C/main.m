#import <Foundation/Foundation.h>
#import "GeminiChatManager.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        GeminiChatManager *chatbot = [[GeminiChatManager alloc] init];
        NSString *prompt = @"Hello Gemini, what can you do?";
        [chatbot sendMessage:prompt withCompletion:^(NSString *response) {
            NSLog(@"Gemini: %@", response);
            CFRunLoopStop(CFRunLoopGetMain());
        }];
        
        CFRunLoopRun(); // Keep the run loop going until async finishes
    }
    return 0;
}
