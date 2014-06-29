//
//  THImageDownloader.h
//  InboxChallenge_0.0.1
//
//  Created by travis holt on 6/27/14.
//  Copyright (c) 2014 Travis Holt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THAppDataObject.h"
#import "THPhoto.h"

@protocol THImageDownloaderDelegate;

@interface THImageDownloader : NSOperation

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) THPhoto *thPhoto;
@property (nonatomic, assign) id <THImageDownloaderDelegate> delegate;

- (instancetype)initWithTHPhoto:(THPhoto *)thPhoto atIndexPath:(NSIndexPath *)indexPath delegate:(id<THImageDownloaderDelegate>)delegate;

@end




@protocol THImageDownloaderDelegate <NSObject>

@required
-(void)imageDownloaderDidFinish:(THImageDownloader*)downloader;

@end


