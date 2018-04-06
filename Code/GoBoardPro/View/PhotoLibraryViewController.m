//
//  PhotoLibraryViewController.m
//  GoBoardPro
//
//  Created by Optiquall Solutions on 15/01/18.
//  Copyright © 2018 IndiaNIC. All rights reserved.
//

#import "PhotoLibraryViewController.h"
#import "PhotoLibCollectionViewCell.h"
@interface PhotoLibraryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray * arrFolderName,*arrImage;
    NSString * isFolderSelected;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewPhotoLibrary;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnUpload;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (nonatomic, copy) void (^Completion)();
@end

@implementation PhotoLibraryViewController



@synthesize lastPoint,red,green,blue,brush,opacity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isFolderSelected = @"NO";
    arrFolderName = [[NSMutableArray alloc]init];
    arrImage = [[NSMutableArray alloc]init];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    red = 0.0/480.0;
    green = 0.0/480.0;
    blue = 0.0/480.0;
    brush = 5.0;
    opacity = 1.0;

    [_collectionViewPhotoLibrary registerNib:[UINib nibWithNibName:@"PhotoLibCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];

    [arrFolderName addObjectsFromArray:@[@"Folder 1",@"Folder 2",@"Folder 3",@"Folder 4"]];

  [arrImage addObjectsFromArray:@[@"go_board_group_sel.png",@"go_board_group_sel.png",@"go_board_group_sel.png",@"go_board_group_sel.png"]];
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return arrFolderName.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoLibCollectionViewCell *cell= (PhotoLibCollectionViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    for (id object in cell.contentView.subviews)
    {
        [object removeFromSuperview];
    }
    
    UIImageView * imageView = [[UIImageView alloc]init];
    UILabel * lblFolderName = [[UILabel alloc]init];

        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, 70, 70)];
        lblFolderName = [[UILabel alloc]initWithFrame:CGRectMake(0, 73, 100, 27)];
        lblFolderName.textColor = [UIColor blackColor];
        lblFolderName.textAlignment = NSTextAlignmentCenter;
        lblFolderName.font = [UIFont systemFontOfSize:20];
        [cell.contentView addSubview:imageView];
        [cell.contentView addSubview:lblFolderName];
   
    imageView.image = [UIImage imageNamed:[arrImage objectAtIndex:indexPath.item]];
    lblFolderName.text = [arrFolderName objectAtIndex:indexPath.item];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    arrFolderName = [[NSMutableArray alloc]init];
    arrImage = [[NSMutableArray alloc]init];
    [arrFolderName addObjectsFromArray:@[@"Image 1",@"Image 2",@"Image 3"]];
    [arrImage addObjectsFromArray:@[@"imgMyCreatedOrder.png",@"imgSearchMyOrder.png",@"menu_19@2x.png"]];
    if ([isFolderSelected isEqualToString:@"YES"]) {
        _imgView.hidden = NO;
    
        _imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[arrImage objectAtIndex:indexPath.item]]];
    }
    else{
    isFolderSelected = @"YES";
          _imgView.hidden = YES;
    }

    [_collectionViewPhotoLibrary reloadData];
}

- (IBAction)btnCancelTapped:(UIButton *)sender {
    if (_imgView.hidden) {
       
        if ([isFolderSelected isEqualToString: @"YES"]) {
            arrFolderName = [[NSMutableArray alloc]init];
            arrImage = [[NSMutableArray alloc]init];
            
            [arrFolderName addObjectsFromArray:@[@"Folder 1",@"Folder 2",@"Folder 3",@"Folder 4"]];
            
            [arrImage addObjectsFromArray:@[@"go_board_group_sel.png",@"go_board_group_sel.png",@"go_board_group_sel.png",@"go_board_group_sel.png"]];
            
            isFolderSelected = @"NO";
            [_collectionViewPhotoLibrary reloadData];
        }
        else{
   
        }

    }
    else{
         _imgView.hidden = YES;
    }
   }

- (IBAction)btnUploadTapped:(UIButton *)sender {
}
-(void)showGPopOverWithSender:(UIButton*)sender{
    
    popOver = nil;
    popOver = [[UIPopoverController alloc] initWithContentViewController:self];
    popOver.delegate = self;
    [popOver setPopoverContentSize:CGSizeMake(320, 480)];
    [popOver presentPopoverFromRect:sender.frame inView:[sender superview] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
}
- (void)showGPopOverWithSender:(UIButton*)sender base62String:(nullable NSString*)base63 {

    
    popOver = nil;
    popOver = [[UIPopoverController alloc] initWithContentViewController:self];
    popOver.delegate = self;
    [popOver setPopoverContentSize:CGSizeMake(320, 480)];
    [popOver presentPopoverFromRect:sender.frame inView:[sender superview] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)popoverGControllerDidDismissPopover:(UIPopoverController *)popoverController {
    if (_Completion) {
        _Completion();
    }
    popOver = nil;
}

@end
