//
//  THAppDataObject.h
//  InboxChallenge_0.0.1
//
//  Created by Aditya Narayan on 6/26/14.
//  Copyright (c) 2014 Travis Holt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THPhoto.h"
#import "THImageDownloader.h"
#import "THPendingOperations.h"
#import "THFavoritePhotos.h"

@interface THAppDataObject : NSObject

@property (nonatomic, assign) float screenWidth;
@property (nonatomic, assign) float screenHeight;

//layout
@property (nonatomic, assign) float searchSpacing;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat appMainFontSize;
@property (nonatomic, assign) UIFont *appMainFont;
@property (nonatomic, assign) CGFloat imageTextOverflow;
@property (nonatomic, assign) CGFloat bottomOfNavigation;
@property (nonatomic, assign) CGFloat favoriteIconSize;
@property (nonatomic, assign) CGFloat favloriteIconPadding;

//photos
@property (nonatomic, strong) NSMutableArray *thPhotoArray;

+(instancetype)sharedInstance;

@end
