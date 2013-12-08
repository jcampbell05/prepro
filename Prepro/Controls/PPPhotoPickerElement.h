//
//  PPPhotoPickerElement.h
//  Prepro
//
//  Created by James Campbell on 30/07/2013.
//  Copyright (c) 2013 Dean Uzzell. All rights reserved.
//

@interface PPPhotoPickerElement : QImageElement{
    QuickDialogController *_controller;
}

@property (nonatomic, strong) NSData *dataValue;

- (void)handleImageSelected:(id)sender;

@end
