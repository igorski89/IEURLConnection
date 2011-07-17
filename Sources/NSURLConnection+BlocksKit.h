//
//  NSURLConnection+BlocksKit.h
//  BKURLConnection
//
//  Created by Igor Evsukov on 17.07.11.
//  Copyright 2011 Igor Evsukov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL (^BKCanAuthenticateAgainstProtectionSpaceHandler) (NSURLProtectionSpace *protectionSpace);
typedef void (^BKDidCancelAuthenticationChallengeHandler) (NSURLAuthenticationChallenge *challenge);
typedef void (^BKDidReceiveAuthenticationChallengeHandler) (NSURLAuthenticationChallenge *challenge);
typedef BOOL (^BKShouldUseCredentialStorageHandler) ();

typedef   id (^BKWillCacheResponseHandler) (NSCachedURLResponse *cachedResponse);
typedef void (^BKDidReceiveResponseHandler) (NSURLResponse *response);
typedef void (^BKDidReceiveDataHandler) (NSData *data);
typedef void (^BKSendBodyDataHandler) (NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite);
typedef   id (^BKWillSendRequestRedirectResponseHandler) (NSURLRequest *request, NSURLResponse *redirectResponse);

typedef void (^BKDidFailWithErrorHandler) (NSError *error);
typedef void (^BKDidFinishLoadingHandler) (NSURLResponse *response, NSData *responceData);

typedef void (^BKConnectionProgressBlock) (float progress);


@interface NSURLConnection (BlocksKit)

#if __has_feature(objc_arc)
@property (nonatomic, weak) id delegate;

@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSURLResponse *response;
#else
@property (nonatomic, assign) id delegate;

@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSURLResponse *response;
#endif

@property (nonatomic, copy) BKCanAuthenticateAgainstProtectionSpaceHandler canAuthenticateAgainstProtectionSpaceHandler;
@property (nonatomic, copy) BKDidCancelAuthenticationChallengeHandler didCancelAuthenticationChallengeHandler;
@property (nonatomic, copy) BKDidReceiveAuthenticationChallengeHandler didReceiveAuthenticationChallengeHandler;
@property (nonatomic, copy) BKShouldUseCredentialStorageHandler shouldUseCredentialStorageHandler;

@property (nonatomic, copy) BKWillCacheResponseHandler willCacheResponseHandler;
@property (nonatomic, copy) BKDidReceiveResponseHandler didReceiveResponseHandler;
@property (nonatomic, copy) BKDidReceiveDataHandler didReceiveDataHandler;
@property (nonatomic, copy) BKSendBodyDataHandler sendBodyDataHandler;
@property (nonatomic, copy) BKWillSendRequestRedirectResponseHandler willSendRequestRedirectResponseHandler;

@property (nonatomic, copy) BKDidFailWithErrorHandler didFailWithErrorHandler;
@property (nonatomic, copy) BKDidFinishLoadingHandler didFinishLoadingHandler;

@property (nonatomic, copy) BKConnectionProgressBlock uploadProgressHandler;
@property (nonatomic, copy) BKConnectionProgressBlock downloadProgressHandler;

+ (NSURLConnection*)connectionWithRequest:(NSURLRequest *)request delegate:(id)delegate;

- (id)initWithRequest:(NSURLRequest *)request;
- (id)initWithRequest:(NSURLRequest *)request startImmediately:(BOOL)startImmediately;
+ (NSURLConnection*)connectionWithRequest:(NSURLRequest *)request;


@end
