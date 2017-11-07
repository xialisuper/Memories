//
//  MXImagePickerViewController.m
//  MemoryForYou
//
//  Created by 夏立群 on 2017/11/2.
//  Copyright © 2017年 xialisuper. All rights reserved.
//

#import "MXImagePickerViewController.h"
#import "MXPhotoPickerCollectionViewFlowLayout.h"
#import "MXImagePickerCollectionViewCell.h"
#import "MXPhotoUtil.h"

static NSString * const kImagePickerCollectionViewCell = @"kImagePickerCollectionViewCell";
@interface MXImagePickerViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) UICollectionView *photoCollectionView;
@property (nonatomic, strong) NSArray<MXImageModel *> *dataArray;
@end

@implementation MXImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDataSource];
    [self initNavBar];
    [self initPhotoCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI
- (void)initNavBar {
    self.title = NSLocalizedString(@"图片选择", nil);
}

- (void)initPhotoCollectionView {
    
    MXPhotoPickerCollectionViewFlowLayout *layout = [[MXPhotoPickerCollectionViewFlowLayout alloc] init];
    
    UICollectionView *photoCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:photoCollectionView];
    
    photoCollectionView.backgroundColor = [UIColor whiteColor];
    photoCollectionView.dataSource = self;
    photoCollectionView.delegate = self;
    photoCollectionView.alwaysBounceHorizontal = NO;
    [self.view addSubview:photoCollectionView];
    self.photoCollectionView = photoCollectionView;
    
    [photoCollectionView registerClass:[MXImagePickerCollectionViewCell class] forCellWithReuseIdentifier:kImagePickerCollectionViewCell];
}

#pragma mark - DataSource
- (void)initDataSource {
    [[MXPhotoUtil sharedInstance] fetchAllPhotosWithResultsWithBlock:^(NSArray<MXImageModel *> *assetsArray) {
        if (assetsArray.count) {
            self.dataArray = assetsArray;
        }
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MXImagePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kImagePickerCollectionViewCell forIndexPath:indexPath];
    cell.imageModel = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"您点击了item:%ld", (long)indexPath.row);
    [collectionView cellForItemAtIndexPath:indexPath].backgroundColor = [UIColor redColor];
    
}



@end
