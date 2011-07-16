//
//  IEURLConnection.m
//  
//
//  Created by Igor Evsukov on 02.07.11.
//  Copyright 2011 Igor Evsukov. All rights reserved.
//

#import "IEURLConnection.h"

#pragma mark - private class – delegate proxy
@interface IEURLConnectionDelegateProxy : NSObject {
}

+ (id)shared;

- (BOOL)connection:(IEURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace;
- (void)connection:(IEURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
- (void)connection:(IEURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
- (BOOL)connectionShouldUseCredentialStorage:(IEURLConnection *)connection;

- (NSCachedURLResponse *)connection:(IEURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse;
- (void)connection:(IEURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(IEURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(IEURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;
- (NSURLRequest *)connection:(IEURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse;

- (void)connection:(IEURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(IEURLConnection *)connection;

@end

@implementation IEURLConnectionDelegateProxy

+ (id)shared {
    static IEURLConnectionDelegateProxy *proxyDelegate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        proxyDelegate = [[IEURLConnectionDelegateProxy alloc] init];
    });
    
    return proxyDelegate;
}

#pragma mark Connection Authentication
- (BOOL)connection:(IEURLConnection*)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    if (connection.delegate != nil && [connection.delegate respondsToSelector:@selector(connection:canAuthenticateAgainstProtectionSpace:)]) {
        return [connection.delegate connection:connection canAuthenticateAgainstProtectionSpace:protectionSpace];
    }
    if (connection.canAuthenticateAgainstProtectionSpaceHandler != nil) {
        return connection.canAuthenticateAgainstProtectionSpaceHandler(protectionSpace);
    }
    return NO;
}

- (void)connection:(IEURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if (connection.delegate != nil && [connection.delegate respondsToSelector:@selector(connection:didCancelAuthenticationChallenge:)]) {
        [connection.delegate connection:connection didCancelAuthenticationChallenge:challenge];
    }
    if (connection.didCancelAuthenticationChallengeHandler != nil) {
        connection.didCancelAuthenticationChallengeHandler(challenge);
    }
}

- (void)connection:(IEURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if (connection.delegate != nil && [connection.delegate respondsToSelector:@selector(connection:didReceiveAuthenticationChallenge:)]) {
        [connection.delegate connection:connection didReceiveAuthenticationChallenge:challenge];
    }
    if (connection.didReceiveAuthenticationChallengeHandler != nil) {
        connection.didReceiveAuthenticationChallengeHandler(challenge);
    }
}

- (BOOL)connectionShouldUseCredentialStorage:(IEURLConnection *)connection {
    if (connection.delegate != nil && [connection.delegate respondsToSelector:@selector(connectionShouldUseCredentialStorage:)]) {
        return [connection.delegate connectionShouldUseCredentialStorage:connection];
    }
    if (connection.shouldUseCredentialStorageHandler != nil) {
        return connection.shouldUseCredentialStorageHandler();
    }
    return NO;   
}

#pragma mark Connection Data and Responses
- (NSCachedURLResponse *)connection:(IEURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    if (connection.delegate != nil && [connection.delegate respondsToSelector:@selector(connection:willCacheResponse:)]) {
        return [connection.delegate connection:connection willCacheResponse:cachedResponse];
    }
    if (connection.willCacheResponseHandler != nil) {
        return connection.willCacheResponseHandler(cachedResponse);
    }
    return cachedResponse;
}

- (void)connection:(IEURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if (connection.delegate != nil && [connection.delegate respondsToSelector:@selector(connection:didReceiveResponse:)]) {
        [connection.delegate connection:connection didReceiveResponse:response];
    }
    
    if (connection.responseData != nil) {
        // according to documentation 
        // we should delete all previous received data
        [connection.responseData setLength:0];
    }
    
    connection.response = response;
    if (connection.didReceiveResponseHandler != nil) {
        connection.didReceiveResponseHandler(response);
    }
}

- (void)connection:(IEURLConnection *)connection didReceiveData:(NSData *)data {
    if (connection.delegate != nil && [connection.delegate respondsToSelector:@selector(connection:didReceiveData:)]) {
        [connection.delegate connection:connection didReceiveData:data];
    }
    
    if (connection.responseData == nil)
        connection.responseData = [NSMutableData data];
    
    [connection.responseData appendData:data];
    
    if (connection.didReceiveDataHandler != nil) {
        connection.didReceiveDataHandler(data);
    }
    
    if (connection.downloadProgressHandler != nil && connection.response != nil && [connection.response expectedContentLength] != NSURLResponseUnknownLength) {
        connection.downloadProgressHandler((double)[connection.responseData length]/(double)[connection.response expectedContentLength]);
    }
    
}

- (void)connection:(IEURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    if (connection.delegate != nil && [connection.delegate respondsToSelector:@selector(connection:didSendBodyData:totalBytesWritten:totalBytesExpectedToWrite:)]) {
        [connection.delegate connection:connection didSendBodyData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
    }
    
    if (connection.sendBodyDataHandler != nil) {
        connection.sendBodyDataHandler(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    }
    
    if (connection.uploadProgressHandler != nil) {
        connection.uploadProgressHandler((float)totalBytesWritten/(float)totalBytesExpectedToWrite);
    }
}

- (NSURLRequest *)connection:(IEURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
    if (connection.delegate != nil && [connection.delegate respondsToSelector:@selector(connection:willSendRequest:redirectResponse:)]) {
        return [connection.delegate connection:connection willSendRequest:request redirectResponse:redirectResponse];
    }
    if (connection.willSendRequestRedirectResponseHandler != nil) {
        return connection.willSendRequestRedirectResponseHandler(request, redirectResponse);
    }
    return request;
}

#pragma mark Connection Completion
- (void)connection:(IEURLConnection *)connection didFailWithError:(NSError *)error {
    if (connection.delegate != nil && [connection.delegate respondsToSelector:@selector(connection:didFailWithError:)]) {
        [connection.delegate connection:connection didFailWithError:error];
    }
    
    if (connection.didFailWithErrorHandler != nil) {
        connection.didFailWithErrorHandler(error);
    }
}

- (void)connectionDidFinishLoading:(IEURLConnection *)connection {
    if (connection.delegate != nil && [connection.delegate respondsToSelector:@selector(connectionDidFinishLoading:)]) {
        [connection.delegate connectionDidFinishLoading:connection];
    }
    
    if (connection.didFinishLoadingHandler != nil) {
        connection.didFinishLoadingHandler(connection.response, connection.responseData);
    }
}

@end

#pragma mark - implementation
@implementation IEURLConnection

#pragma mark - properties
@synthesize delegate;

@synthesize responseData, response;
@synthesize canAuthenticateAgainstProtectionSpaceHandler, didCancelAuthenticationChallengeHandler, didReceiveAuthenticationChallengeHandler, shouldUseCredentialStorageHandler;
@synthesize willCacheResponseHandler, didReceiveResponseHandler, didReceiveDataHandler, sendBodyDataHandler, willSendRequestRedirectResponseHandler;
@synthesize didFailWithErrorHandler, didFinishLoadingHandler;
@synthesize uploadProgressHandler, downloadProgressHandler;

#pragma mark - init && dealloc
#pragma mark original overloaded
- (id)init {
    NSLog(@"%s: returning nil, use initWithRequest: instead",__PRETTY_FUNCTION__);
    return nil;
}
- (id)initWithRequest:(NSURLRequest *)request delegate:(id)aDelegate {
    return [self initWithRequest:request delegate:aDelegate startImmediately:NO];
}
- (id)initWithRequest:(NSURLRequest *)request delegate:(id)aDelegate startImmediately:(BOOL)startImmediately {
    if ((self = [super initWithRequest:request delegate:[IEURLConnectionDelegateProxy shared] startImmediately:startImmediately])) {
        if (aDelegate != nil && aDelegate != [self class]) {
            self.delegate = aDelegate;
        }        
    }
    return self;
}
+ (id)connectionWithRequest:(NSURLRequest *)request delegate:(id)delegate {
    return [[[self alloc] initWithRequest:request delegate:delegate] autorelease];
}

#pragma mark new
- (id)initWithRequest:(NSURLRequest *)request {
    return [self initWithRequest:request delegate:nil startImmediately:NO];
}

- (id)initWithRequest:(NSURLRequest *)request startImmediately:(BOOL)startImmediately {
    return [self initWithRequest:request delegate:nil startImmediately:startImmediately];
}
+ (id)connectionWithRequest:(NSURLRequest *)request {
    return [[[self alloc] initWithRequest:request] autorelease];
}

#pragma mark 
- (void)dealloc {
    self.delegate = nil;
    
    self.responseData = nil;
    self.response = nil;
    
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


@end
