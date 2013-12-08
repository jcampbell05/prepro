//
//  PPPhotoPickerElement.m
//  Prepro
//
//  Created by James Campbell on 30/07/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

#import "PPPhotoPickerElement.h"
#import "GGFullScreenImageViewController.h"
#import "QImageTableViewCell.h"

@implementation PPPhotoPickerElement

- (void)fetchValueIntoObject:(id)obj
{
	if (_key == nil) {
		return;
	}
    
    if (self.dataValue) {
      [obj setValue:self.dataValue forKey:_key];
    }
	
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [super imagePickerController:picker didFinishPickingMediaWithInfo:info];
    _dataValue = UIImageJPEGRepresentation(self.imageValue, 1);
    NSLog(@"Picked");
}

- (void)setDataValue:(NSData *)dataValue {
    self.imageValue = [UIImage imageWithData:dataValue];
}

- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller {
    QImageTableViewCell *cell = [super getCellForTableView:tableView controller:controller];
    [cell.imageViewButton addTarget:self action:@selector(handleImageSelected:) forControlEvents:UIControlEventTouchUpInside];
    cell.imageViewButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _controller = controller;
    return cell;
}

- (void)handleImageSelected:(UIButton *)sender {
    if (self.imageValue || self.dataValue) {
        GGFullscreenImageViewController *vc = [[GGFullscreenImageViewController alloc] init];
        vc.liftedImageView = sender.imageView;
        [_controller presentViewController:vc animated:YES completion:nil];
    }
}



@end
