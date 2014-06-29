//
//  THImageDownloader.m
//  InboxChallenge_0.0.1
//
//  Created by travis holt on 6/27/14.
//  Copyright (c) 2014 Travis Holt. All rights reserved.
//

#import "THImageDownloader.h"

@implementation THImageDownloader

-(instancetype)initWithTHPhoto:(THPhoto *)thPhoto atIndexPath:(NSIndexPath *)indexPath delegate:(id<THImageDownloaderDelegate>)delegate{
    
    self = [super init];
    
    if (self) {
        _indexPath = indexPath;
        _thPhoto = thPhoto;
        _delegate = delegate;
    }
    return self;
}

-(void)main{
    
    @autoreleasepool {
        
        if (self.isCancelled) {
            return;
        }
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:self.thPhoto.url];
        
        if (self.isCancelled) {
            data = nil;
            return;
        }
        
        if (data) {
            UIImage *imageFromData = [UIImage imageWithData:data];
            self.thPhoto.image = imageFromData;
        } else {
            data = nil;
        }
        
        if (self.isCancelled) {
            return;
        }
        
        
        [(NSObject*)self.delegate performSelectorOnMainThread:@selector(imageDownloaderDidFinish:) withObject:self waitUntilDone:NO];
        
    }
    
}

@end
