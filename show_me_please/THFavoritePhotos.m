//
//  THFavoritePhotos.m
//  InboxChallenge_02
//
//  Created by travis holt on 6/28/14.
//  Copyright (c) 2014 travis holt. All rights reserved.
//

#import "THFavoritePhotos.h"

@implementation THFavoritePhotos

-(id)init{
    self = [super init];
    
    if (self != nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"favoritedTHPhotos"];
        if (data) {
            _favoritedTHPhotos = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        } else {
            _favoritedTHPhotos = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

-(void)addFavorite:(THPhoto *)thPhoto{
    
    time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
    
    thPhoto.timeOfFavorite = [NSString stringWithFormat:@"%ld",unixTime];
    
    NSLog(@"thPhoto.timeOfFavorite: %@",thPhoto.timeOfFavorite);
    
    [self.favoritedTHPhotos setObject:thPhoto forKey:thPhoto.timeOfFavorite];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.favoritedTHPhotos];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"favoritedTHPhotos"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void)removeFavorite:(THPhoto *)thPhoto{
    
    [self.favoritedTHPhotos removeObjectForKey:thPhoto.timeOfFavorite];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.favoritedTHPhotos];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"favoritedTHPhotos"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.favoritedTHPhotos forKey:@"favoritedTHPhotos"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        
        self.favoritedTHPhotos = [decoder decodeObjectForKey:@"favoritedTHPhotos"];
        
    }
    return self;
}

@end












