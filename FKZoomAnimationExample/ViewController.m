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
    NSArray * photoArray;
    CGRect cellframe;
}

@property (strong, nonatomic) FKZoomAnimation *zoomAnimation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - user Methods

-(void)presentPopupWithIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [photoCV dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    if (_zoomAnimation != nil) {
        _zoomAnimation = nil;
    }
    
    _zoomAnimation = [[FKZoomAnimation alloc] init];
    [_zoomAnimation animateFromView:cell toView:self.view];
    return;
    
    UICollectionViewCell *photoCell = [photoCV dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    cellframe = photoCell.frame;
    selfFrameView = [[UIView alloc] initWithFrame:photoCell.frame];
    selfFrameView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [photoCV addSubview:selfFrameView];
    selectedImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, selfFrameView.frame.size.width, selfFrameView.frame.size.width)];
    selectedImage.layer.cornerRadius = selectedImage.frame.size.width/2;
    selectedImage.clipsToBounds = YES;
    selectedImage.image = [UIImage imageNamed:@"test"];
    [selfFrameView addSubview:selectedImage];
    
    [UIView animateWithDuration:0.50 animations:^{
        [selfFrameView setFrame:CGRectInset(photoCV.bounds, 0, 0)];
        selfFrameView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        selectedImage.layer.cornerRadius = 0;
        float dy = (photoCV.frame.size.height-photoCV.frame.size.width)/2;
        [selectedImage setFrame:CGRectInset(selfFrameView.bounds, 0, dy)];
    } completion:^(BOOL finished) {
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [backButton setFrame:CGRectMake(0, 0, 0, 0)];
        [backButton setTitle:@"Back" forState:UIControlStateNormal];
        backButton.tag = indexPath.row;
        [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [selfFrameView addSubview:backButton];
        
        [UIView animateWithDuration:0.05 animations:^{
            [backButton setFrame:CGRectMake(0, 0, 60, 30)];
        }];
    }];
}

-(void)backButtonPressed:(UIButton *)sender{
    
    [UIView animateWithDuration:0.01 animations:^{
        [sender setFrame:CGRectMake(0, 0, 0, 0)];
    } completion:^(BOOL finished) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        UICollectionViewCell *photoCell = [photoCV dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
        [UIView animateWithDuration:0.5 animations:^{
            [selfFrameView setFrame:photoCell.frame];
            [selectedImage setFrame:CGRectInset(selfFrameView.bounds, 0, 0)];
            
            selectedImage.layer.cornerRadius = selectedImage.frame.size.width/2;
            selectedImage.clipsToBounds = YES;
        } completion:^(BOOL finished) {
            [selfFrameView removeFromSuperview];
            photoCV.scrollEnabled = YES;
        }];
    }];
}

#pragma mark - Collection View Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //  return photoArray.count;
    return 10;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPat
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    UIImageView *photoImageView = (UIImageView *)[photoCell viewWithTag:100];
    photoImageView.layer.cornerRadius = photoImageView.frame.size.width/2;
    photoImageView.clipsToBounds = YES;
    photoImageView.image = [UIImage imageNamed:@"test"];
    return photoCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    collectionView.scrollEnabled = NO;
    [self presentPopupWithIndexPath:indexPath];
}

@end
