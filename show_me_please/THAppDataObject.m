//
//  THAppDataObject.m
//  InboxChallenge_0.0.1
//
//  Created by Aditya Narayan on 6/26/14.
//  Copyright (c) 2014 Travis Holt. All rights reserved.
//

#import "THAppDataObject.h"

@implementation THAppDataObject

-(id)init{
    self = [super init];
    
    if (self != nil) {
        _thPhotoArray = [[NSMutableArray alloc] init];
        [self getScreenDimensions];
        [self loadSettings];

    }
    return self;
}

+(instancetype)sharedInstance{
    
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

-(void)getScreenDimensions{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.screenWidth = screenRect.size.width;
    self.screenHeight = screenRect.size.height;
    
}


-(void)loadSettings{
    
    NSArray *fontFamilies = [UIFont familyNames];
    for (int i = 0; i < [fontFamilies count]; i++)
    {
        NSString *fontFamily = [fontFamilies objectAtIndex:i];
        NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
        NSLog (@"%@: %@", fontFamily, fontNames);
    }
    
    self.searchSpacing = 0.0;
    self.cellHeight = 120.0;
    self.appMainFontSize = self.cellHeight/2.0;
    self.appMainFont = [UIFont fontWithName:@"Oswald-Regular" size:self.appMainFontSize];
    self.imageTextOverflow = 100;
    
    self.bottomOfNavigation = 65.0;
    self.favoriteIconSize = 50.0;
    self.favloriteIconPadding = 7.0;
    
}

@end















