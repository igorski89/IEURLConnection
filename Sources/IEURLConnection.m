//
//  IEURLConnection.m
//  
//
//  Created by Igor Evsukov on 02.07.11.
//  Copyright 2011 Igor Evsukov. All rights reserved.
//

#import "IEURLConnection.h"

@interface IEURLConnection()

@property (nonatomic, retain) NSMutableData *responceData;
@property (nonatomic, retain) NSURLConnection *urlConnection;
@property (nonatomic, retain) NSURLResponse *urlResponce;

@end

@implementation IEURLConnection

@synthesize urlConnection, responceData, urlResponce;

@synthesize canAuthenticateAgainstProtectionSpaceHandler, didCancelAuthenticationChallengeHandler, didReceiveAuthenticationChallengeHandler, shouldUseCredentialStorageHandler;
@synthesize willCacheResponseHandler, didReceiveResponseHandler, didReceiveDataHandler, sendBodyDataHandler, willSendRequestRedirectResponseHandler;
@synthesize didFailWithErrorHandler, didFinishLoadingHandler;
@synthesize uploadProgressHandler, downloadProgressHandler;

#pragma mark -
#pragma mark init && dealloc
- (id)init {
    NSLog(@"%s: returning nil, use initWithRequest: instead",__PRETTY_FUNCTION__);
    return nil;
}

- (id)initWithRequest:(NSURLRequest *)request {
    return [self initWithRequest:request startImmediately:NO];
}

- (id)initWithRequest:(NSURLRequest *)request startImmediately:(BOOL)startImmediately {
    if (![NSURLConnection canHandleRequest:request]) return nil;
    
    if ((self = [super init])) {
        self.urlConnection = [[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:startImmediately] autorelease];
    }
    return self;
}
+ (id)connectionWithRequest:(NSURLRequest *)request {
    return [[[self alloc] initWithRequest:request] autorelease];
}

- (void)dealloc {
    self.responceData = nil;
    self.urlConnection = nil;
    self.urlResponce = nil;
    
    self.canAuthenticateAgainstProtectionSpaceHandler = nil;
    self.didCancelAuthenticationChallengeHandler = nil;
    self.didReceiveAuthenticationChallengeHandler = nil;
    self.shouldUseCredentialStorageHandler = nil;
    
    self.willCacheResponseHandler = nil;
    self.didReceiveResponseHandler = nil;
    self.didReceiveDataHandler = nil;
    self.sendBodyDataHandler = nil;
    self.willSendRequestRedirectResponseHandler = nil;
    
    self.didFailWithErrorHandler = nil;
    self.didFinishLoadingHandler = nil;
    
    self.uploadProgressHandler = nil;
    self.downloadProgressHandler = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark connection execution
- (void)start {
    [self retain];
    
    [self.urlConnection start];
}

- (void)cancel {
    [self.urlConnection cancel];
    
    [self release];
}

#pragma mark -
#pragma mark delegation

#pragma mark 
#pragma mark Connection Authentication
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    if (connection == self.urlConnection) {
        if (self.canAuthenticateAgainstProtectionSpaceHandler != nil) {
            return self.canAuthenticateAgainstProtectionSpaceHandler(protectionSpace);
        }
    }
    return NO;
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if (connection == self.urlConnection) {
        if (self.didCancelAuthenticationChallengeHandler != nil) {
            self.didCancelAuthenticationChallengeHandler(challenge);
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if (connection == self.urlConnection) {
        if (self.didReceiveAuthenticationChallengeHandler != nil) {
            self.didReceiveAuthenticationChallengeHandler(challenge);
        }
    }
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection {
    if (connection == self.urlConnection) {
        if (self.shouldUseCredentialStorageHandler != nil) {
            return self.shouldUseCredentialStorageHandler();
        }
    }
    return NO;   
}

#pragma mark 
#pragma mark Connection Data and Responses
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    if (connection == self.urlConnection) {
        if (self.willCacheResponseHandler != nil) {
            return self.willCacheResponseHandler(cachedResponse);
        }
    }
    return cachedResponse;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if (connection == self.urlConnection) {
        
        if (self.responceData != nil) {
            // accordint to documentation 
            // we should delete all previous received data
            [self.responceData setLength:0];
        }
         
        self.urlResponce = response;
        if (self.didReceiveResponseHandler != nil) {
            self.didReceiveResponseHandler(response);
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (connection == self.urlConnection) {
        
        if (self.responceData == nil)
            self.responceData = [NSMutableData data];
        
        [self.responceData appendData:data];
        
        if (self.didReceiveDataHandler != nil) {
            self.didReceiveDataHandler(data);
        }
        
        if (self.downloadProgressHandler != nil && self.urlResponce != nil && [self.urlResponce expectedContentLength] != NSURLResponseUnknownLength) {
            self.downloadProgressHandler((double)[self.responceData length]/(double)[self.urlResponce expectedContentLength]);
        }
    }    
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    if (connection == self.urlConnection) {
        if (self.sendBodyDataHandler != nil) {
            self.sendBodyDataHandler(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
        }
        
        if (self.uploadProgressHandler != nil) {
            self.uploadProgressHandler((float)totalBytesWritten/(float)totalBytesExpectedToWrite);
        }
    }
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
    if (connection == self.urlConnection) {
        if (self.willSendRequestRedirectResponseHandler != nil) {
            self.willSendRequestRedirectResponseHandler(request, redirectResponse);
        }
    }
    return request;
}

#pragma mark 
#pragma mark Connection Completion
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (connection == self.urlConnection) {
        if (self.didFailWithErrorHandler != nil) {
            self.didFailWithErrorHandler(error);
        }
        
        [self release];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (connection == self.urlConnection) {
        if (self.didFinishLoadingHandler != nil) {
            self.didFinishLoadingHandler(self.urlResponce, self.responceData);
        }
        
        [self release];
    }
}

@end
