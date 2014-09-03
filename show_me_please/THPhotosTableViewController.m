//
//  THPhotosTableViewController.m
//  InboxChallenge_0.0.1
//
//  Created by Aditya Narayan on 6/26/14.
//  Copyright (c) 2014 Travis Holt. All rights reserved.
//

#import "THPhotosTableViewController.h"
#import "THPhotoTableViewCell.h"

@interface THPhotosTableViewController ()

@end

@implementation THPhotosTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _pendingOperations = [[THPendingOperations alloc] init];
        _ado = [THAppDataObject sharedInstance];
        _favoriteIcon = [[UIImageView alloc] init];
        _thFavoritePhotos = [[THFavoritePhotos alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectedIndex = -1;
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor blackColor];
        
    self.reuseID = @"reuseID";
    [self.tableView registerClass:[THPhotoTableViewCell class] forCellReuseIdentifier:self.reuseID];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView reloadData];
    
    [self setImageIcon];
    [self addFavoriteIcon];
    
}

- (void)viewDidUnload {
    self.ado.thPhotoArray = nil;
    self.selectedIndex = -1;
    [self.pendingOperations.operationQueue cancelAllOperations];
    [self setPendingOperations:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.ado.thPhotoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    THPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.reuseID];
    
    THPhoto *thPhoto = [self.ado.thPhotoArray objectAtIndex:indexPath.row];
    
    if (thPhoto.image) {
        [cell.activityIndictorView stopAnimating];
        cell.photoImageView.image = thPhoto.image;
    } else {
        [cell.activityIndictorView startAnimating];
        cell.photoImageView.image = nil;
        if (!tableView.dragging && !tableView.decelerating) {
            [self startOperationsForPhotoRecord:thPhoto atIndexPath:indexPath];
        }
    }
        
    [cell updateImageViewFrameWithHeight:thPhoto.image.size.height];
    
    cell.photoTitleView.text = thPhoto.title;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == self.selectedIndex) {
        self.selectedIndex = -1;
        [self updateFavoriteIconWithPoint:CGPointMake(0, 0)];
    } else {
        self.selectedIndex = indexPath.row;
        CGPoint scrollTargetPoint = CGPointMake(0, (self.selectedIndex-1) * self.ado.cellHeight + self.ado.bottomOfNavigation);
        [self updateFavoriteIconWithPoint:scrollTargetPoint];


        [self.tableView setContentOffset:scrollTargetPoint animated:YES];
    }
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == self.selectedIndex) {
        THPhoto *thPhoto = [self.ado.thPhotoArray objectAtIndex:self.selectedIndex];
        UIImage *photoImage = thPhoto.image;
        return photoImage.size.height;
    }
    
    return self.ado.cellHeight;
    
}


#pragma mark - NSOperations

- (void)startOperationsForPhotoRecord:(THPhoto *)thPhoto atIndexPath:(NSIndexPath *)indexPath {
    
    if (!thPhoto.image) {
        
        [self startImageDownloadingForRecord:thPhoto atIndexPath:indexPath];
        
    }
}

- (void)startImageDownloadingForRecord:(THPhoto *)thPhoto atIndexPath:(NSIndexPath *)indexPath {
    
    if (![self.pendingOperations.imageDownloadsInProgress.allKeys containsObject:indexPath]) {
        THImageDownloader *thImageDownloader = [[THImageDownloader alloc] initWithTHPhoto:thPhoto atIndexPath:indexPath delegate:self];
        [self.pendingOperations.imageDownloadsInProgress setObject:thImageDownloader forKey:indexPath];
        [self.pendingOperations.operationQueue addOperation:thImageDownloader];
    }
}

- (void)imageDownloaderDidFinish:(THImageDownloader *)thImageDownloader {
    
    NSIndexPath *indexPath = thImageDownloader.indexPath;
    
    THPhoto *thPhoto = thImageDownloader.thPhoto;
    
    [self.ado.thPhotoArray replaceObjectAtIndex:indexPath.row withObject:thPhoto];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.pendingOperations.imageDownloadsInProgress removeObjectForKey:indexPath];
}

- (void)suspendAllOperations {
    [self.pendingOperations.operationQueue setSuspended:YES];
}


- (void)resumeAllOperations {
    [self.pendingOperations.operationQueue setSuspended:NO];
}


- (void)cancelAllOperations {
    [self.pendingOperations.operationQueue cancelAllOperations];
}


- (void)loadImagesForOnscreenCells {
    
    NSSet *visibleRows = [NSSet setWithArray:[self.tableView indexPathsForVisibleRows]];
    
    NSMutableSet *pendingOperations = [NSMutableSet setWithArray:[self.pendingOperations.imageDownloadsInProgress allKeys]];
    
    NSMutableSet *toBeCancelled = [pendingOperations mutableCopy];
    NSMutableSet *toBeStarted = [visibleRows mutableCopy];
    
    [toBeStarted minusSet:pendingOperations];
    
    [toBeCancelled minusSet:visibleRows];
    
    for (NSIndexPath *anIndexPath in toBeCancelled) {
        
        THImageDownloader *pendingDownload = [self.pendingOperations.imageDownloadsInProgress objectForKey:anIndexPath];
        [pendingDownload cancel];
        [self.pendingOperations.imageDownloadsInProgress removeObjectForKey:anIndexPath];
    }
    
    toBeCancelled = nil;
    
    for (NSIndexPath *anIndexPath in toBeStarted) {
        
        THPhoto *thPhoto = [self.ado.thPhotoArray objectAtIndex:anIndexPath.row];
        [self startOperationsForPhotoRecord:thPhoto atIndexPath:anIndexPath];
    }
    toBeStarted = nil;
    
}

#pragma mark UIScrollView


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 1: As soon as the user starts scrolling, you will want to suspend all operations and take a look at what the user wants to see.
    [self suspendAllOperations];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
        [self loadImagesForOnscreenCells];
        [self resumeAllOperations];
}


#pragma mark - Favorites

-(void)setImageIcon{
    
    self.iconName = @"star-icon";
    
}

-(void)addFavoriteIcon{
    
    [self.view addSubview:self.favoriteIcon];
    self.favoriteIcon.frame = CGRectMake(self.ado.screenWidth-self.ado.favoriteIconSize,
                                         self.ado.screenHeight-self.ado.favoriteIconSize - self.ado.bottomOfNavigation,
                                         self.ado.favoriteIconSize,
                                         self.ado.favoriteIconSize);
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionIconTapped:)];
    [self.favoriteIcon addGestureRecognizer:tgr];
    [self.favoriteIcon setUserInteractionEnabled:YES];
    [self.favoriteIcon setHidden:YES];
    self.favoriteIcon.contentMode = UIViewContentModeScaleAspectFit;
    self.favoriteIcon.image = [UIImage imageNamed:self.iconName];
    
}

-(void)updateFavoriteIconWithPoint:(CGPoint)point{
    if (self.selectedIndex == -1) {
        self.favoriteIcon.hidden = YES;
    } else {
        THPhoto *thPhoto = [self.ado.thPhotoArray objectAtIndex:self.selectedIndex];
        self.favoriteIcon.hidden = NO;
        
        
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             self.favoriteIcon.frame = CGRectMake(self.ado.screenWidth-self.ado.favoriteIconSize,
                                                                  point.y - self.ado.favoriteIconSize + self.ado.cellHeight/2 + thPhoto.image.size.height - self.ado.favloriteIconPadding,
                                                                  self.ado.favoriteIconSize,
                                                                  self.ado.favoriteIconSize);

                             
                         }
                         completion:nil];
        
    }
    
    
    
}

-(void)actionIconTapped:(UITapGestureRecognizer*)recognizer{
    
    THPhoto *thPhoto = [self.ado.thPhotoArray objectAtIndex:self.selectedIndex];
    
    self.favoriteIcon.hidden = YES;
    
    [self.thFavoritePhotos addFavorite:thPhoto];
    
}



@end








