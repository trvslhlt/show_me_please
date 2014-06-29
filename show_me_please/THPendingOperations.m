//
//  THPendingOperations.m
//  InboxChallenge_0.0.1
//
//  Created by travis holt on 6/28/14.
//  Copyright (c) 2014 Travis Holt. All rights reserved.
//

#import "THPendingOperations.h"

@implementation THPendingOperations

- (NSMutableDictionary *)imageDownloadsInProgress {
    if (!_imageDownloadsInProgress) {
        _imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
    }
    return _imageDownloadsInProgress;
}

- (NSOperationQueue *)operationQueue {
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.name = @"Download Queue";
        _operationQueue.maxConcurrentOperationCount = 1;
    }
    return _operationQueue;
}

@end
