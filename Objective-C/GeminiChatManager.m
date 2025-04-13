#import "GeminiChatManager.h"

@implementation GeminiChatManager {
    NSString *_apiKey;
    NSString *_model;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadEnv];
    }
    return self;
}

- (void)loadEnv {
    NSString *path = [[NSBundle mainBundle] pathForResource:@".env" ofType:nil];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines = [content componentsSeparatedByString:@"\n"];
    
    for (NSString *line in lines) {
        NSArray *parts = [line componentsSeparatedByString:@"="];
        if (parts.count == 2) {
            NSString *key = parts[0];
            NSString *value = parts[1];
            if ([key isEqualToString:@"GEMINI_API_KEY"]) {
                _apiKey = value;
            } else if ([key isEqualToString:@"MODEL"]) {
                _model = value;
            }
        }
    }
}

- (void)sendMessage:(NSString *)message withCompletion:(void (^)(NSString *response))completion {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://generativelanguage.googleapis.com/v1beta/models/%@:generateContent?key=%@", _model, _apiKey]];
    
    NSDictionary *bodyDict = @{
        @"contents": @[
            @{@"parts": @[@{@"text": message}]}
        ]
    };
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyDict options:0 error:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:bodyData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion([NSString stringWithFormat:@"Error: %@", error.localizedDescription]);
            return;
        }
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSString *reply = json[@"candidates"][0][@"content"][@"parts"][0][@"text"];
        completion(reply ?: @"No response from Gemini.");
    }] resume];
}

@end
