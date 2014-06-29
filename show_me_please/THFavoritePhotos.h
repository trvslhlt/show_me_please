//
//  THFavoritePhotos.h
//  InboxChallenge_02
//
//  Created by travis holt on 6/28/14.
//  Copyright (c) 2014 travis holt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THAppDataObject.h"
#import "THPhoto.h"

@interface THFavoritePhotos : NSObject <NSCoding>

@property (nonatomic, strong) NSMutableDictionary *favoritedTHPhotos;

-(void)addFavorite:(THPhoto*)thPhoto;
-(void)removeFavorite:(THPhoto*)thPhoto;

@end
