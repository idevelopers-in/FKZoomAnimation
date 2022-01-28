//
//  ViewController.m
//  FKZoomAnimationExample
//
//  Created by Firoz Khan on 08/04/16.
//

#import "FKZoomAnimation.h"
#import "ViewController.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate> {
    
    IBOutlet UICollectionView *photoCV;
    UIView *selfFrameView ;
    UIImageView *selectedImage;
    CGRect cellframe;
}

@property (strong, nonatomic) FKZoomAnimation *zoomAnimation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection View Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    UIImageView *photoImageView = (UIImageView *)[photoCell viewWithTag:100];
    photoImageView.layer.cornerRadius = photoImageView.frame.size.width/2;
    photoImageView.clipsToBounds = YES;
    photoImageView.image = [UIImage imageNamed:@"test"];
    return photoCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    collectionView.scrollEnabled = NO;
    [self presentPopupWithIndexPath:indexPath];
}

#pragma mark - User Methods

- (void)presentPopupWithIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [photoCV dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    if (_zoomAnimation != nil) {
        _zoomAnimation = nil;
    }
    
    _zoomAnimation = [[FKZoomAnimation alloc] init];
    [_zoomAnimation animateFromView:cell toView:self.view completion:^{
        self->photoCV.scrollEnabled = YES;
    }];
}

@end
