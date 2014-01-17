//
//  CHViewController.m
//  RGFlipbook
//
//  Created by Ryan Gomba on 1/16/14.
//  Copyright (c) 2014 Ryan Gomba. All rights reserved.
//

#import "CHViewController.h"

static NSString * const kCellReuseIdentifier = @"cell";

#define CATransform3DPerspective(t, x, y) (CATransform3DConcat(t, CATransform3DMake(1, 0, 0, x, 0, 1, 0, y, 0, 0, 1, 0, 0, 0, 0, 1)))
#define CATransform3DMakePerspective(x, y) (CATransform3DPerspective(CATransform3DIdentity, x, y))

CG_INLINE CATransform3D
CATransform3DMake(CGFloat m11, CGFloat m12, CGFloat m13, CGFloat m14,
				  CGFloat m21, CGFloat m22, CGFloat m23, CGFloat m24,
				  CGFloat m31, CGFloat m32, CGFloat m33, CGFloat m34,
				  CGFloat m41, CGFloat m42, CGFloat m43, CGFloat m44)
{
	CATransform3D t;
	t.m11 = m11; t.m12 = m12; t.m13 = m13; t.m14 = m14;
	t.m21 = m21; t.m22 = m22; t.m23 = m23; t.m24 = m24;
	t.m31 = m31; t.m32 = m32; t.m33 = m33; t.m34 = m34;
	t.m41 = m41; t.m42 = m42; t.m43 = m43; t.m44 = m44;
	return t;
}

@interface CHViewController ()

@end

@implementation CHViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellReuseIdentifier];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self updateTransforms];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    //
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 420.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.row % 2 == 0) {
        [cell.contentView setBackgroundColor:[UIColor blueColor]];
//        [cell.contentView.layer setAnchorPoint:CGPointMake(0.5, 0.0)];
    } else {
        [cell.contentView setBackgroundColor:[UIColor redColor]];
//        [cell.contentView.layer setAnchorPoint:CGPointMake(0.5, 1.0)];
    }
    
    [cell.contentView.layer setTransform:CATransform3DIdentity];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.contentView setClipsToBounds:NO];
    [cell setClipsToBounds:NO];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateTransforms];
}

- (void)updateTransforms {
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        CGFloat centerY = cell.center.y - self.tableView.contentOffset.y;
        CGFloat distanceFromScreenCenter = self.view.bounds.size.height / 2.0 - centerY;
        CGFloat normalizedDistance = distanceFromScreenCenter / 210.0;
        
        if (normalizedDistance > 1.0) {
            normalizedDistance = 2.0 - normalizedDistance;
        } else if (normalizedDistance < -1.0) {
            normalizedDistance = -(2.0 + normalizedDistance);
        }
        
        if ([self.tableView indexPathForCell:cell].row % 2 == 1) {
//            normalizedDistance *= -1.0;
        }
//        normalizedDistance *= -1.0;
//        normalizedDistance = ABS(normalizedDistance);
        
//        CGFloat scale = 1.0 - ABS(normalizedDistance);
        
        CATransform3D transform = CATransform3DMakePerspective(0.0, 0.0005 * normalizedDistance);
//        transform = CATransform3DRotate(transform, M_PI / 4.0, 0.0, 1.0, 0.0);
//        transform.m34 = 10.0;
//        transform.m12 = 0.5;
        
        transform = CATransform3DScale(transform, 1.0, 1.0 + 0.25 * ABS(normalizedDistance), 1.0);
        
        [cell.contentView.layer setTransform:transform];
//        [cell setTransform:CGAffineTransformMakeScale(scale, scale)];
    }
}

@end
