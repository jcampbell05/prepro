//
//  NavigationController.m
//  FPPicker
//
//  Created by Liyan David Chang on 6/20/12.
//  Copyright (c) 2012 Filepicker.io (Cloudtop Inc), All rights reserved.
//

#import "FPInternalHeaders.h"
#import "FPPickerController.h"
#import "FPSourceListController.h"


@interface FPPickerController ()
@property BOOL hasStatusBar;
@end

@implementation FPPickerController

@synthesize fpdelegate, sourceNames, dataTypes;

@synthesize allowsEditing, videoQuality, videoMaximumDuration, showsCameraControls, cameraOverlayView, cameraViewTransform;
@synthesize cameraDevice, cameraFlashMode;
@synthesize selectMultiple, maxFiles;

@synthesize shouldUpload, shouldDownload;

- (void) setupVariables {
    
    allowsEditing = NO;
    videoQuality = UIImagePickerControllerQualityTypeMedium;
    videoMaximumDuration = 600;
    showsCameraControls = YES;
    cameraOverlayView = nil;
    cameraViewTransform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
    cameraDevice = UIImagePickerControllerCameraDeviceRear;
    cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;

    shouldUpload = YES;
    shouldDownload = YES;
    
    selectMultiple = NO;
    maxFiles = 0;
}

- (id)init {
    self = [super init];
    
    [self setupVariables];

    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    if (statusBarHeight < 0.0001){
        self.hasStatusBar = NO;
    } else {
        self.hasStatusBar = YES;
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    [self setupVariables];
    
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    
    [self setupVariables];
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    [self setupVariables];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.delegate = self;
    
    if (fpAPIKEY == NULL || [fpAPIKEY isEqualToString:@""] || [fpAPIKEY isEqualToString:@"SET_FILEPICKER.IO_APIKEY_HERE"]){
        NSException* apikeyException = [NSException
                                    exceptionWithName:@"Filepicker Configuration Error"
                                    reason:@"APIKEY not set. You can get one at https://www.filepicker.io and insert it into your project's info.plist as 'Filepicker API Key'"
                                    userInfo:nil];
        [apikeyException raise];
    }
    
    FPSourceListController *fpSourceListController = [FPSourceListController alloc];
    fpSourceListController.fpdelegate = self;
    fpSourceListController.imgdelagate = self;
    fpSourceListController.sourceNames = sourceNames;
    fpSourceListController.dataTypes = dataTypes;
    fpSourceListController.selectMultiple = selectMultiple;
    fpSourceListController.maxFiles = maxFiles;
    fpSourceListController.title = self.title;

    fpSourceListController = [fpSourceListController init];

    [self pushViewController:fpSourceListController animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.sourceNames = nil;
    self.dataTypes = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

#pragma mark UIImagePickerControllerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (self.hasStatusBar){
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }

    
    /* resizing the thumbnail */
    
    UIImage *originalImage, *editedImage, *imageToSave;
    editedImage = (UIImage *) [info objectForKey:
                               UIImagePickerControllerEditedImage];
    originalImage = (UIImage *) [info objectForKey:
                                 UIImagePickerControllerOriginalImage];
    
    if (editedImage) {
        NSLog(@"USING EDITED IMAGE");
        imageToSave = editedImage;
    } else {
        NSLog(@"USING ORIGINAL IMAGE");
        imageToSave = originalImage;
    }
    
    const float ThumbnailSize = 115.0f;
    float scaleFactor = ThumbnailSize / fminf(imageToSave.size.height, imageToSave.size.width);
    float newHeight = imageToSave.size.height * scaleFactor;
    float newWidth = imageToSave.size.width * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [imageToSave drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage* thumbImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if ([fpdelegate respondsToSelector:@selector(FPPickerController:didPickMediaWithInfo:)]) {
        dispatch_async(dispatch_get_main_queue(),^{
            [fpdelegate FPPickerController:self didPickMediaWithInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                              thumbImage, @"FPPickerControllerThumbnailImage"
                                                              , nil]];
        });
    }
    
    FPMBProgressHUD *hud = [FPMBProgressHUD showHUDAddedTo:picker.view animated:YES];
    hud.labelText = @"Uploading...";
    hud.mode = FPMBProgressHUDModeDeterminate;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
    
    // Picked Something From the Local Camera
    // nb: The camera roll is handled like a normal source as it is in FPLocalController
    NSLog(@"Picked something from local camera: %@ %@", info, kUTTypeImage);
    
    if ([[info objectForKey:@"UIImagePickerControllerMediaType"] isEqual:(NSString*) kUTTypeImage]){
        NSString *dataType;
        for (NSString *type in dataTypes){
            if ([type isEqualToString:@"image/png"] || [type isEqualToString:@"image/jpeg"]){
                dataType = type;
            }
        }
        NSLog(@"should upload: %@", shouldUpload?@"YES":@"NO");
        [FPLibrary uploadImage:imageToSave ofMimetype:dataType withOptions:info shouldUpload:self.shouldUpload success:^(id JSON, NSURL *localurl) {

            NSLog(@"JSON: %@", JSON);
            NSDictionary *output = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    [info objectForKey:@"UIImagePickerControllerMediaType"], @"FPPickerControllerMediaType",
                                    imageToSave, @"FPPickerControllerOriginalImage",
                                    localurl, @"FPPickerControllerMediaURL",
                                    [[[JSON objectForKey:@"data"]  objectAtIndex:0] objectForKey:@"url"], @"FPPickerControllerRemoteURL",
                                    [[[[JSON objectForKey:@"data"] objectAtIndex:0] objectForKey:@"data"] objectForKey:@"key"], @"FPPickerControllerKey",

                                    nil];
            dispatch_async(dispatch_get_main_queue(),^{
                [FPMBProgressHUD hideHUDForView:picker.view animated:YES];
                [picker dismissViewControllerAnimated:NO completion:^{
                    [fpdelegate FPPickerController:self didFinishPickingMediaWithInfo:output];
                }];
            });
            
        } failure:^(NSError *error, id JSON, NSURL *localurl) {
            NSDictionary *output = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    [info objectForKey:@"UIImagePickerControllerMediaType"], @"FPPickerControllerMediaType",
                                    imageToSave, @"FPPickerControllerOriginalImage",
                                    localurl, @"FPPickerControllerMediaURL",
                                    @"", @"FPPickerControllerRemoteURL",
                                    nil];
            dispatch_async(dispatch_get_main_queue(),^{
                NSLog(@"dispatched main thread: %@", [NSThread isMainThread]?@"YES":@"NO");

                [FPMBProgressHUD hideHUDForView:self.view animated:YES];
                [picker dismissViewControllerAnimated:NO completion:^{
                                    [fpdelegate FPPickerController:self didFinishPickingMediaWithInfo:output];
                }];

            });
        } progress:^(float progress) {
            hud.progress = progress;
        }];
    } else if ([[info objectForKey:@"UIImagePickerControllerMediaType"] isEqual:(NSString*) kUTTypeMovie]){
        NSURL *url = [info objectForKey:@"UIImagePickerControllerMediaURL"];
        [FPLibrary uploadVideoURL: url withOptions:info shouldUpload:self.shouldUpload success:^(id JSON, NSURL *localurl) {
            NSLog(@"JSON: %@", JSON);
            NSDictionary *output = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    [info objectForKey:@"UIImagePickerControllerMediaType"], @"FPPickerControllerMediaType",
                                    localurl, @"FPPickerControllerMediaURL",
                                    [[[JSON objectForKey:@"data"]  objectAtIndex:0] objectForKey:@"url"], @"FPPickerControllerRemoteURL",
                                    [[[[JSON objectForKey:@"data"] objectAtIndex:0] objectForKey:@"data"] objectForKey:@"key"], @"FPPickerControllerKey",
                                    nil];
            dispatch_async(dispatch_get_main_queue(),^{
                [FPMBProgressHUD hideHUDForView:picker.view animated:YES];
                [picker dismissViewControllerAnimated:NO completion:^{
                                    [fpdelegate FPPickerController:self didFinishPickingMediaWithInfo:output];
                }];

            });
            
        } failure:^(NSError *error, id JSON, NSURL *localurl) {
            NSLog(@"JSON: %@", JSON);
            NSDictionary *output = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    [info objectForKey:@"UIImagePickerControllerMediaType"], @"FPPickerControllerMediaType",
                                    localurl, @"FPPickerControllerMediaURL",
                                    @"", @"FPPickerControllerRemoteURL",
                                    nil];
            dispatch_async(dispatch_get_main_queue(),^{
                [FPMBProgressHUD hideHUDForView:self.view animated:YES];
                [picker dismissViewControllerAnimated:NO completion:^{
                                    [fpdelegate FPPickerController:self didFinishPickingMediaWithInfo:output];
                }];

            });
        } progress:^(float progress) {
            hud.progress = progress;
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(),^{
            NSLog(@"Error. We couldn't handle this file %@", info);
            NSLog(@"Type: %@", [info objectForKey:@"UIImagePickerControllerMediaType"]);
            [FPMBProgressHUD hideHUDForView:self.view animated:YES];
            [picker dismissViewControllerAnimated:NO completion:^{
                [fpdelegate FPPickerControllerDidCancel:self];
            }];
        });
    }
        
    });
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker 
{
    if (self.hasStatusBar){
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    //The user chose to cancel when using the camera.
    NSLog(@"Canceled something from local camera");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark FPSourcePickerDelegate Methods

- (void)FPSourceController:(FPSourceController *)picker didPickMediaWithInfo:(NSDictionary *)info  {
    if ([fpdelegate respondsToSelector:@selector(FPPickerController:didPickMediaWithInfo:)]) {
        [fpdelegate FPPickerController:self didPickMediaWithInfo:info];
    }
}


- (void)FPSourceController:(FPSourceController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    //The user chose a file from the cloud or camera roll.
    NSLog(@"Picked something from a source: %@", info);
    
    [fpdelegate FPPickerController:self didFinishPickingMediaWithInfo:info];
    fpdelegate = nil;

}

- (void)FPSourceController:(FPSourceController *)picker didFinishPickingMultipleMediaWithResults:(NSArray *)results{
    //The user chose a file from the cloud or camera roll.
    NSLog(@"Picked multiple files from a source: %@", results);
    
    //It's optional, so check
    if ([fpdelegate respondsToSelector:@selector(FPPickerController:didFinishPickingMultipleMediaWithResults:)]) {
        [fpdelegate FPPickerController:self didFinishPickingMultipleMediaWithResults:results];
    }
    fpdelegate = nil;
    
}

- (void)FPSourceControllerDidCancel:(FPSourceController *)picker
{
    //The user chose to cancel when using the cloud or camera roll.
    NSLog(@"FP Canceled.");
    
    //It's optional, so check
    if ([fpdelegate respondsToSelector:@selector(FPPickerControllerDidCancel:)]) {
        [fpdelegate FPPickerControllerDidCancel:self];
    }
    fpdelegate = nil;
}

#pragma mark UINavigationControllerDelegate Methods

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    return;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    return;
}

@end
