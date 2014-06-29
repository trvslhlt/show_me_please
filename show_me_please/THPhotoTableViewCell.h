//
//  THPhotoTableViewCell.h
//  InboxChallenge_0.0.1
//
//  Created by travis holt on 6/27/14.
//  Copyright (c) 2014 Travis Holt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THPhotoTableViewCell : UITableViewCell

@property (nonatomic, strong) UITextView *photoTitleView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndictorView;
@property (nonatomic, strong) UIImageView *photoImageView;

-(void)updateImageViewFrameWithHeight:(CGFloat)height;

@end
