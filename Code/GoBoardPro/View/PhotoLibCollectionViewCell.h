//
//  PhotoLibCollectionViewCell.h
//  GoBoardPro
//
//  Created by Optiquall Solutions on 15/01/18.
//  Copyright © 2018 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoLibCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *lblFileName;

@end
