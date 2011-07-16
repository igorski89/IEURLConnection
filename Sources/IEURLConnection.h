//
//  IEURLConnection.h
//  
//
//  Created by Igor Evsukov on 02.07.11.
//  Copyright 2011 Igor Evsukov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL (^IECanAuthenticateAgainstProtectionSpaceHandler) (NSURLProtectionSpace *protectionSpace);
typedef void (^IEDidCancelAuthenticationChallengeHandler) (NSURLAuthenticationChallenge *challenge);
typedef void (^IEDidReceiveAuthenticationChallengeHandler) (NSURLAuthenticationChallenge *challenge);
typedef BOOL (^IEShouldUseCredentialStorageHandler) ();

typedef   id (^IEWillCacheResponseHandler) (NSCachedURLResponse *cachedResponse);
typedef void (^IEDidReceiveResponseHandler) (NSURLResponse *response);
typedef void (^IEDidReceiveDataHandler) (NSData *data);
typedef void (^IESendBodyDataHandler) (NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite);
typedef   id (^IEWillSendRequestRedirectResponseHandler) (NSURLRequest *request, NSURLResponse *redirectResponse);

typedef void (^IEDidFailWithErrorHandler) (NSError *error);
typedef void (^IEDidFinishLoadingHandler) (NSURLResponse *response, NSData *responceData);

typedef void (^IEConnectionProgressBlock) (float progress);

@interface IEURLConnection : NSURLConnection {
}

@property (nonatomic, assign) id delegate;

@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSURLResponse *response;

@property (nonatomic, copy) IECanAuthenticateAgainstProtectionSpaceHandler canAuthenticateAgainstProtectionSpaceHandler;
@property (nonatomic, copy) IEDidCancelAuthenticationChallengeHandler didCancelAuthenticationChallengeHandler;
@property (nonatomic, copy) IEDidReceiveAuthenticationChallengeHandler didReceiveAuthenticationChallengeHandler;
@property (nonatomic, copy) IEShouldUseCredentialStorageHandler shouldUseCredentialStorageHandler;

@property (nonatomic, copy) IEWillCacheResponseHandler willCacheResponseHandler;
@property (nonatomic, copy) IEDidReceiveResponseHandler didReceiveResponseHandler;
@property (nonatomic, copy) IEDidReceiveDataHandler didReceiveDataHandler;
@property (nonatomic, copy) IESendBodyDataHandler sendBodyDataHandler;
@property (nonatomic, copy) IEWillSendRequestRedirectResponseHandler willSendRequestRedirectResponseHandler;

@property (nonatomic, copy) IEDidFailWithErrorHandler didFailWithErrorHandler;
@property (nonatomic, copy) IEDidFinishLoadingHandler didFinishLoadingHandler;

@property (nonatomic, copy) IEConnectionProgressBlock uploadProgressHandler;
@property (nonatomic, copy) IEConnectionProgressBlock downloadProgressHandler;


- (id)initWithRequest:(NSURLRequest *)request;
- (id)initWithRequest:(NSURLRequest *)request startImmediately:(BOOL)startImmediately;
+ (id)connectionWithRequest:(NSURLRequest *)request;
+ (id)connectionWithRequest:(NSURLRequest *)request delegate:(id)delegate;

@end
