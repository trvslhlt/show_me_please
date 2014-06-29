//
//  THPhoto.h
//  InboxChallenge_0.0.1
//
//  Created by Aditya Narayan on 6/26/14.
//  Copyright (c) 2014 Travis Holt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THPhoto : NSObject <NSCoding>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *numberID;
@property (nonatomic, strong) NSString *server;
@property (nonatomic, strong) NSString *farm;
@property (nonatomic, strong) NSString *secret;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, assign) BOOL hasImage;
@property (nonatomic, strong) NSString *timeOfFavorite;

@end












