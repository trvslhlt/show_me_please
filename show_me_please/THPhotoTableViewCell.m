//
//  THPhotoTableViewCell.m
//  InboxChallenge_0.0.1
//
//  Created by travis holt on 6/27/14.
//  Copyright (c) 2014 Travis Holt. All rights reserved.
//

#import "THPhotoTableViewCell.h"
#import "THAppDataObject.h"

@implementation THPhotoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _photoTitleView = [[UITextView alloc] init];
        _activityIndictorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _photoImageView = [[UIImageView alloc] init];
        [self prepareCellLayout];
    }
    return self;
}

-(void)prepareCellLayout{
    THAppDataObject *ado = [THAppDataObject sharedInstance];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor blackColor];
    
    [self addSubview:self.photoImageView];
    [self addSubview:self.photoTitleView];
    [self addSubview:self.activityIndictorView];
    [self.activityIndictorView startAnimating];
        
    self.frame = CGRectMake(0, 0, ado.screenWidth, ado.cellHeight);
    self.photoImageView.frame = CGRectMake(0, 0, ado.screenWidth, ado.screenHeight);
    self.activityIndictorView.frame = CGRectMake(0, 0, ado.screenWidth, ado.cellHeight);
    self.photoTitleView.frame = CGRectMake(-ado.imageTextOverflow, 0, ado.screenWidth + 2*ado.imageTextOverflow, ado.cellHeight);
    
    self.photoTitleView.textContainer.maximumNumberOfLines = 1;
    self.photoTitleView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.photoTitleView setUserInteractionEnabled:NO];
    [self.photoTitleView setTextAlignment:NSTextAlignmentCenter];
    self.photoTitleView.font = ado.appMainFont;
    self.photoTitleView.backgroundColor = [UIColor clearColor];
    self.photoTitleView.textColor = [UIColor blackColor];
    
    [self.photoImageView setBackgroundColor:[UIColor orangeColor]];
    [self.photoImageView setContentMode:UIViewContentModeScaleAspectFill];
    
}

-(void)updateImageViewFrameWithHeight:(CGFloat)height{
    
    CGRect ivRect = self.photoImageView.frame;
    ivRect.size.height = height;
    self.photoImageView.frame = ivRect;
    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
