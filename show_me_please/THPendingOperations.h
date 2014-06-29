//
//  THPendingOperations.h
//  InboxChallenge_0.0.1
//
//  Created by travis holt on 6/28/14.
//  Copyright (c) 2014 Travis Holt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THPendingOperations : NSObject

@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end
