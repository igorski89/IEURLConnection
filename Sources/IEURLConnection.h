//
//  IEURLConnection.h
//  
//
//  Created by Igor Evsukov on 02.07.11.
//  Copyright 2011 Igor Evsukov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL (^IECanAuthenticateAgainstProtectionSpaceBlock) (NSURLProtectionSpace *protectionSpace);
typedef void (^IEDidCancelAuthenticationChallengeBlock) (NSURLAuthenticationChallenge *challenge);
typedef void (^IEDidReceiveAuthenticationChallengeBlock) (NSURLAuthenticationChallenge *challenge);
typedef BOOL (^IEShouldUseCredentialStorageBlock) ();

typedef   id (^IEWillCacheResponseBlock) (NSCachedURLResponse *cachedResponse);
typedef void (^IEDidReceiveResponseBlock) (NSURLResponse *response);
typedef void (^IEDidReceiveDataBlock) (NSData *data);
typedef void (^IESendBodyDataBlock) (NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite);
typedef   id (^IEWillSendRequestRedirectResponseBlock) (NSURLRequest *request, NSURLResponse *redirectResponse);

typedef void (^IEDidFailWithErrorBlock) (NSError *error);
typedef void (^IEDidFinishLoadingBlock) (NSURLResponse *response, NSData *responceData);

typedef void (^IEConnectionProgressBlock) (float progress);

@interface IEURLConnection : NSObject {
}

@property (nonatomic, copy) IECanAuthenticateAgainstProtectionSpaceBlock canAuthenticateAgainstProtectionSpaceBlock;
@property (nonatomic, copy) IEDidCancelAuthenticationChallengeBlock didCancelAuthenticationChallengeBlock;
@property (nonatomic, copy) IEDidReceiveAuthenticationChallengeBlock didReceiveAuthenticationChallengeBlock;
@property (nonatomic, copy) IEShouldUseCredentialStorageBlock shouldUseCredentialStorageBlock;

@property (nonatomic, copy) IEWillCacheResponseBlock willCacheResponseBlock;
@property (nonatomic, copy) IEDidReceiveResponseBlock didReceiveResponseBlock;
@property (nonatomic, copy) IEDidReceiveDataBlock didReceiveDataBlock;
@property (nonatomic, copy) IESendBodyDataBlock sendBodyDataBlock;
@property (nonatomic, copy) IEWillSendRequestRedirectResponseBlock willSendRequestRedirectResponseBlock;

@property (nonatomic, copy) IEDidFailWithErrorBlock didFailWithErrorBlock;
@property (nonatomic, copy) IEDidFinishLoadingBlock didFinishLoadingBlock;

@property (nonatomic, copy) IEConnectionProgressBlock uploadProgressBlock;
@property (nonatomic, copy) IEConnectionProgressBlock downloadProgressBlock;


- (id)initWithRequest:(NSURLRequest *)request;
- (id)initWithRequest:(NSURLRequest *)request startImmediately:(BOOL)startImmediately;
+ (IEURLConnection*)connectionWithRequest:(NSURLRequest *)request;

- (void)start;
- (void)cancel;

@end
