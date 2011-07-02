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

@synthesize canAuthenticateAgainstProtectionSpaceBlock, didCancelAuthenticationChallengeBlock, didReceiveAuthenticationChallengeBlock, shouldUseCredentialStorageBlock;
@synthesize willCacheResponseBlock, didReceiveResponseBlock, didReceiveDataBlock, sendBodyDataBlock, willSendRequestRedirectResponseBlock;
@synthesize didFailWithErrorBlock, didFinishLoadingBlock;
@synthesize uploadProgressBlock, downloadProgressBlock;

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
+ (IEURLConnection*)connectionWithRequest:(NSURLRequest *)request {
    return [[[self alloc] initWithRequest:request] autorelease];
}

- (void)dealloc {
    self.responceData = nil;
    self.urlConnection = nil;
    self.urlResponce = nil;
    
    self.canAuthenticateAgainstProtectionSpaceBlock = nil;
    self.didCancelAuthenticationChallengeBlock = nil;
    self.didReceiveAuthenticationChallengeBlock = nil;
    self.shouldUseCredentialStorageBlock = nil;
    
    self.willCacheResponseBlock = nil;
    self.didReceiveResponseBlock = nil;
    self.didReceiveDataBlock = nil;
    self.sendBodyDataBlock = nil;
    self.willSendRequestRedirectResponseBlock = nil;
    
    self.didFailWithErrorBlock = nil;
    self.didFinishLoadingBlock = nil;
    
    self.uploadProgressBlock = nil;
    self.downloadProgressBlock = nil;
    
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
        if (self.canAuthenticateAgainstProtectionSpaceBlock != nil) {
            return self.canAuthenticateAgainstProtectionSpaceBlock(protectionSpace);
        }
    }
    return NO;
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if (connection == self.urlConnection) {
        if (self.didCancelAuthenticationChallengeBlock != nil) {
            self.didCancelAuthenticationChallengeBlock(challenge);
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if (connection == self.urlConnection) {
        if (self.didReceiveAuthenticationChallengeBlock != nil) {
            self.didReceiveAuthenticationChallengeBlock(challenge);
        }
    }
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection {
    if (connection == self.urlConnection) {
        if (self.shouldUseCredentialStorageBlock != nil) {
            return self.shouldUseCredentialStorageBlock();
        }
    }
    return NO;   
}

#pragma mark 
#pragma mark Connection Data and Responses
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    if (connection == self.urlConnection) {
        if (self.willCacheResponseBlock != nil) {
            return self.willCacheResponseBlock(cachedResponse);
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
        if (self.didReceiveResponseBlock != nil) {
            self.didReceiveResponseBlock(response);
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (connection == self.urlConnection) {
        
        if (self.responceData == nil)
            self.responceData = [NSMutableData data];
        
        [self.responceData appendData:data];
        
        if (self.didReceiveDataBlock != nil) {
            self.didReceiveDataBlock(data);
        }
        
        if (self.downloadProgressBlock != nil && self.urlResponce != nil && [self.urlResponce expectedContentLength] != NSURLResponseUnknownLength) {
            self.downloadProgressBlock((double)[self.responceData length]/(double)[self.urlResponce expectedContentLength]);
        }
    }    
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    if (connection == self.urlConnection) {
        if (self.sendBodyDataBlock != nil) {
            self.sendBodyDataBlock(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
        }
        
        if (self.uploadProgressBlock != nil) {
            self.uploadProgressBlock((float)totalBytesWritten/(float)totalBytesExpectedToWrite);
        }
    }
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
    if (connection == self.urlConnection) {
        if (self.willSendRequestRedirectResponseBlock != nil) {
            self.willSendRequestRedirectResponseBlock(request, redirectResponse);
        }
    }
    return request;
}

#pragma mark 
#pragma mark Connection Completion
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (connection == self.urlConnection) {
        if (self.didFailWithErrorBlock != nil) {
            self.didFailWithErrorBlock(error);
        }
        
        [self release];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (connection == self.urlConnection) {
        if (self.didFinishLoadingBlock != nil) {
            self.didFinishLoadingBlock(self.urlResponce, self.responceData);
        }
        
        [self release];
    }
}

@end
