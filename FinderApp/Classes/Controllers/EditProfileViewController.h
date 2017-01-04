//
//  EditProfileViewController.h
//  Finder_iPhoneApp
//
//  Created by Hema on 10/06/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCropView.h"

@interface EditProfileViewController : GlobalBackViewController<ImageCropViewControllerDelegate>{
    ImageCropView* imageCropView;
    UIImage* image1;
}
@property(nonatomic,strong) NSMutableArray* profileArray;
@end
