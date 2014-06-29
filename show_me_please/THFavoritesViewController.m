//
//  THFavoritesViewController.m
//  InboxChallenge_02
//
//  Created by travis holt on 6/29/14.
//  Copyright (c) 2014 travis holt. All rights reserved.


#import "THFavoritesViewController.h"

@interface THFavoritesViewController ()

@end

@implementation THFavoritesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setImageIcon{
    
    self.iconName = @"remove-icon";
    
}

-(void)actionIconTapped:(UITapGestureRecognizer*)recognizer{
    
    THPhoto *thPhoto = [self.ado.thPhotoArray objectAtIndex:self.selectedIndex];
    [self.thFavoritePhotos removeFavorite:thPhoto];
    
    [self.ado.thPhotoArray removeObjectAtIndex:self.selectedIndex];
    self.selectedIndex = -1;
    self.favoriteIcon.hidden = YES;
    [self.tableView reloadData];
    
}

@end





