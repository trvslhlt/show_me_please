//
//  THSearchViewController.h
//  InboxChallenge_0.0.1
//
//  Created by Aditya Narayan on 6/26/14.
//  Copyright (c) 2014 Travis Holt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THAppDataObject.h"
#import "THPhotosTableViewController.h"
#import "THFavoritesViewController.h"

@interface THSearchViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) THAppDataObject *ado;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIButton *commitSearch;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIImageView *favoriteIcon;

@end
