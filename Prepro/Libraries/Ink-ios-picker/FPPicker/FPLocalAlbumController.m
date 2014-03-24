//
//  FPLocalAlbumController.m
//  FPPicker
//
//  Created by Liyan David Chang on 4/17/13.
//  Copyright (c) 2013 Filepicker.io (Couldtop Inc.). All rights reserved.
//

#import "FPLocalAlbumController.h"
#import "FPLocalController.h"


@interface FPLocalAlbumController ()

@property UILabel *emptyLabel;

@end

@implementation FPLocalAlbumController

@synthesize albums = _albums;
@synthesize fpdelegate;
@synthesize sourceType = _sourceType;
@synthesize emptyLabel = _emptyLabel;
@synthesize selectMultiple, maxFiles;
@synthesize tableView;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [self.view addSubview:tableView];
    self.title = _sourceType.name;
    self.contentSizeForViewInPopover = fpWindowSize;
}

- (void) viewWillAppear:(BOOL)animated  {
    self.tableView.frame = self.view.bounds;
    [self loadAlbumData];
    [super viewWillAppear:animated];
}

- (void) loadAlbumData {
    
    NSArray *requestedTypes = _sourceType.mimetypes;
    
    NSLog(@"Requested %@", requestedTypes);
    bool showImages = NO;
    bool showVideo = NO;
    
    for (NSString *mimetype in requestedTypes){
        if ([mimetype isEqualToString:@"video/quicktime"] || [mimetype isEqualToString:@"video/*"]){
            showVideo = YES;
        }
        if ([mimetype isEqualToString:@"image/png"] || [mimetype isEqualToString:@"image/jpeg"] || [mimetype isEqualToString:@"image/*"]){
            showImages = YES;
        }
        if ([mimetype isEqualToString:@"*/*"]){
            showImages = YES;
            showVideo = YES;
        }
    }
    NSLog(showImages ? @"Images: Yes" : @"Images: No");
    NSLog(showVideo ? @"Videos: Yes" : @"Videos: No");
    
    self.contentSizeForViewInPopover = fpWindowSize;
    
    CGRect bounds = self.view.bounds;
    
    //Just make one instance empty label
    _emptyLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, (bounds.size.height)/2-60, bounds.size.width, 30)];
    [_emptyLabel setTextColor:[UIColor grayColor]];
    [_emptyLabel setTextAlignment:NSTextAlignmentCenter];
    [_emptyLabel setText:@"No Albums Available"];
    
    // collect the things
    NSMutableArray *collector = [[NSMutableArray alloc] initWithCapacity:0];
    ALAssetsLibrary *al = [FPLocalAlbumController defaultAssetsLibrary];
    
    [al enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:
        ^(ALAssetsGroup *group, BOOL *stop) {
            if (group == nil) {
                //We're done, so reload data
                [self setAlbums:collector];
                [self.tableView reloadData];
                
                return;
            }
            NSString *sGroupPropertyName = (NSString *)[group valueForProperty:ALAssetsGroupPropertyName];
            NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
            NSLog(@"GROUP: %@ %lu", sGroupPropertyName, (unsigned long)nType);
            
            if (showImages && !showVideo){
                [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            } else if (showVideo && !showImages){
                [group setAssetsFilter:[ALAssetsFilter allVideos]];
            }
            
            if ([[sGroupPropertyName lowercaseString] isEqualToString:@"camera roll"] && nType == ALAssetsGroupSavedPhotos) {
                [collector insertObject:group atIndex:0];
            }
            else {
                [collector addObject:group];
            }
        } failureBlock:^(NSError *error) {
            NSLog(@"There was an error with the ALAssetLibrary: %@", error);
        }
     ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setAlbums:(NSArray *)albums {
    
    if (_albums != albums) {
        _albums = albums;
    }
    
    // In theory, you should be able to do this only if you update.
    // However, this seems safer to make sure that the empty label gets removed.
    if ([_albums count] == 0) {
        [self.view addSubview:_emptyLabel];
    } else {
        [_emptyLabel removeFromSuperview];
    }
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.albums count];
}

- (UITableViewCell *)tableView:(UITableView *)passedTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [passedTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Get count
    NSLog(@"group #%ld", (long)indexPath.row);
    ALAssetsGroup *g = (ALAssetsGroup*)[self.albums objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)",[g valueForProperty:ALAssetsGroupPropertyName], (long)[g numberOfAssets]];
    [cell.imageView setImage:[UIImage imageWithCGImage:[(ALAssetsGroup*)[self.albums objectAtIndex:indexPath.row] posterImage]]];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FPLocalController *sView = [[FPLocalController alloc] init];
    sView.assetGroup = (ALAssetsGroup*)[self.albums objectAtIndex:indexPath.row];
    sView.fpdelegate = fpdelegate;
    sView.selectMultiple = selectMultiple;
    sView.maxFiles = maxFiles;
    [self.navigationController pushViewController:sView animated:YES];
}

+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}


@end
