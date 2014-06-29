//
//  THPhoto.m
//  InboxChallenge_0.0.1
//
//  Created by Aditya Narayan on 6/26/14.
//  Copyright (c) 2014 Travis Holt. All rights reserved.
//

#import "THPhoto.h"

@implementation THPhoto

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.numberID forKey:@"numberID"];
    NSData *imageData = UIImagePNGRepresentation(self.image);
    [encoder encodeObject:imageData forKey:@"imageData"];
    [encoder encodeObject:self.timeOfFavorite forKey:@"timeOfFavorite"];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        
        self.title = [decoder decodeObjectForKey:@"title"];
        self.numberID = [decoder decodeObjectForKey:@"numberID"];
        NSData *imageData = [decoder decodeObjectForKey:@"imageData"];
        self.image = [UIImage imageWithData:imageData];
        self.timeOfFavorite = [decoder decodeObjectForKey:@"timeOfFavorite"];
        
    }
    return self;
}

@end













