//
//  THPhotosTableViewController.h
//  InboxChallenge_0.0.1
//
//  Created by Aditya Narayan on 6/26/14.
//  Copyright (c) 2014 Travis Holt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THAppDataObject.h"

@interface THPhotosTableViewController : UITableViewController <THImageDownloaderDelegate>

@property (nonatomic, strong) NSString *reuseID;
@property (nonatomic, strong) THAppDataObject *ado;
@property (nonatomic, strong) THPendingOperations *pendingOperations;
@property (nonatomic, assign) long selectedIndex;
@property (nonatomic, strong) UIImageView *favoriteIcon;
@property (nonatomic, strong) NSString *iconName;

@property (nonatomic, strong) THFavoritePhotos *thFavoritePhotos;

-(void)setImageIcon;
-(void)addFavoriteIcon;
-(void)updateFavoriteIconWithPoint:(CGPoint)point;

-(void)actionIconTapped:(UITapGestureRecognizer*)recognizer;


@end
