//
//  THSearchViewController.m
//  InboxChallenge_0.0.1
//
//  Created by Aditya Narayan on 6/26/14.
//  Copyright (c) 2014 Travis Holt. All rights reserved.
//

#import "THSearchViewController.h"

@interface THSearchViewController ()

@end

@implementation THSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _ado = [THAppDataObject sharedInstance];
        _searchTextField = [[UITextField alloc] init];
        _commitSearch = [[UIButton alloc] init];
        _favoriteIcon = [[UIImageView alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    THAppDataObject *ado = [THAppDataObject sharedInstance];
    
    self.searchTextField.frame = CGRectMake(ado.searchSpacing,
                                            200,
                                            ado.screenWidth,
                                            100);
    self.searchTextField.backgroundColor = [UIColor whiteColor];
    self.searchTextField.borderStyle = UITextBorderStyleLine;
    self.searchTextField.textAlignment = NSTextAlignmentCenter;
    self.searchTextField.placeholder = @"Show me...";
    self.searchTextField.font = ado.appMainFont;
    [self.view addSubview:self.searchTextField];
    
    self.commitSearch.frame = CGRectMake(ado.searchSpacing,
                                         300,
                                         ado.screenWidth - ado.searchSpacing*2,
                                         100);
    [self.commitSearch setTintColor:[UIColor whiteColor]];
    [self.commitSearch setTitle:@"please" forState:UIControlStateNormal];
    [self.commitSearch addTarget:self
               action:@selector(fireSearch:)
     forControlEvents:UIControlEventTouchUpInside];
    [self.commitSearch.titleLabel setFont:ado.appMainFont];
    [self.view addSubview:self.commitSearch];
    
    [self addFavoriteIcon];
}

-(void)viewDidAppear:(BOOL)animated{
    self.commitSearch.userInteractionEnabled = YES;
}

-(UIActivityIndicatorView*)activityIndicatorView{
    if (!_activityIndicatorView) {
        THAppDataObject *ado = [THAppDataObject sharedInstance];
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicatorView.frame = CGRectMake(ado.screenWidth/2.0 - 100, ado.screenHeight/2.0 - 100, 200, 200);
        [self.view addSubview:_activityIndicatorView];
    }
    return _activityIndicatorView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fireSearch:(UIButton*)sender{
    
    NSLog(@"fire search");

    THAppDataObject *ado = [THAppDataObject sharedInstance];
    
    [self.activityIndicatorView startAnimating];
    self.commitSearch.userInteractionEnabled = NO;
    
    
    [ado.thPhotoArray removeAllObjects];
    
    NSString *searchTag = self.searchTextField.text;
    NSString *searchTagWithoutWhiteSpace = [searchTag stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    
    
    NSString *searchURL = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?&method=flickr.photos.search&api_key=99324fd536ac227833f8357da9da9957&tags=%@&format=json&per_page=50",searchTagWithoutWhiteSpace];
    
    
    
    NSURLSessionConfiguration * sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 5.0;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];

    
    [[session dataTaskWithURL:[NSURL URLWithString:searchURL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                
                if (error) {
                    NSLog(@"error dowloading photo data");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showSearchFailureAlert];
                    });
                    return;
                } else {
                    
                    if (data != nil) {
                        
                        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        NSString *sansPrefix = [responseString stringByReplacingOccurrencesOfString:@"jsonFlickrApi(" withString:@""];
                        NSString *formatted = [sansPrefix substringToIndex:[sansPrefix length]-1];
                        
                        NSDictionary *convertedJSON = [NSJSONSerialization JSONObjectWithData: [formatted dataUsingEncoding:NSUTF8StringEncoding]
                                                                                      options: NSJSONReadingMutableContainers
                                                                                        error: &error];
                        
                        NSDictionary *photos = [convertedJSON objectForKey:@"photos"];
                        
                        NSArray *photoArray = [photos objectForKey:@"photo"];
                        
                        
                        
                        NSLog(@"%@",photoArray);
                        
                        for (NSMutableDictionary *photoData in photoArray){
                            THPhoto *newTHPhoto = [[THPhoto alloc] init];
                            newTHPhoto.title = [photoData objectForKey:@"title"];
                            newTHPhoto.numberID = [photoData objectForKey:@"id"];
                            newTHPhoto.server = [photoData objectForKey:@"server"];
                            newTHPhoto.farm = [photoData objectForKey:@"farm"];
                            newTHPhoto.secret = [photoData objectForKey:@"secret"];
                            
                            NSString *urlAsString = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@.jpg",
                                                     newTHPhoto.farm,
                                                     newTHPhoto.server,
                                                     newTHPhoto.numberID,
                                                     newTHPhoto.secret];
                            newTHPhoto.url = [NSURL URLWithString:urlAsString];
                            NSLog(@"%@",newTHPhoto.url);
                            
                            THAppDataObject *ado = [THAppDataObject sharedInstance];
                            [ado.thPhotoArray addObject:newTHPhoto];
                            
                        }
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.activityIndicatorView stopAnimating];
                            [self presentPhotosTVC];
                        });
                    }

                    
                }
                
                
            }] resume];
}

-(void)presentPhotosTVC{
    
    THPhotosTableViewController *photosTVC = [[THPhotosTableViewController alloc] init];
    [self.navigationController pushViewController:photosTVC animated:YES];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark UIAlterView
-(void)showSearchFailureAlert{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Oops!"
                                                    message: @"Your search request timedout."
                                                   delegate: self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
   
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self.activityIndicatorView stopAnimating];
    self.commitSearch.userInteractionEnabled = YES;
    
}


#pragma mark favorite icon
-(void)addFavoriteIcon{
    
    [self.view addSubview:self.favoriteIcon];
    self.favoriteIcon.frame = CGRectMake(self.ado.screenWidth-self.ado.favoriteIconSize,
                                         self.ado.screenHeight-self.ado.favoriteIconSize-self.ado.favloriteIconPadding,
                                         self.ado.favoriteIconSize,
                                         self.ado.favoriteIconSize);
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favoriteIconTapped:)];
    [self.favoriteIcon addGestureRecognizer:tgr];
    [self.favoriteIcon setUserInteractionEnabled:YES];
    self.favoriteIcon.contentMode = UIViewContentModeScaleAspectFit;
    self.favoriteIcon.image = [UIImage imageNamed:@"star-icon"];
    
}

-(void)favoriteIconTapped:(UITapGestureRecognizer*)recognizer{
    
    [self.ado.thPhotoArray removeAllObjects];
    THFavoritePhotos *thFavoritePhotos = [[THFavoritePhotos alloc] init];
    
    for (NSString *key in thFavoritePhotos.favoritedTHPhotos){
        THPhoto *thPhoto = [thFavoritePhotos.favoritedTHPhotos objectForKey:key];
        [self.ado.thPhotoArray addObject:thPhoto];
    }
    
    [self.ado.thPhotoArray sortUsingDescriptors:
    [NSArray arrayWithObjects:
      [NSSortDescriptor sortDescriptorWithKey:@"timeOfFavorite" ascending:NO], nil]];
    
    THFavoritesViewController *thfVC = [[THFavoritesViewController alloc] init];
    [self.navigationController pushViewController:thfVC animated:YES];
}

@end












