//
//  DailyLogReviewProgressViewController.m
//  GoBoardPro
//
//  Created by ind558 on 10/12/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "DailyLogReviewProgressViewController.h"

@interface DailyLogReviewProgressViewController ()

@end

@implementation DailyLogReviewProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblUserName.text = [NSString stringWithFormat:@"%@ %@", [[User currentUser] firstName], [[User currentUser] lastName]];
    _lblFacility.text = [[[User currentUser] selectedFacility] name];
    _lblLocation.text = [[[User currentUser] selectedLocation] name];
    _lblPosition.text = [[[User currentUser] selectedPosition] name];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBAction

- (IBAction)btnBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    return aCell;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *aCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    return aCell;
}
@end
