#import <Foundation/Foundation.h>

@interface GeminiChatManager : NSObject

- (void)sendMessage:(NSString *)message withCompletion:(void (^)(NSString *response))completion;

@end
