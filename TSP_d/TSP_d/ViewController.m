//
//  ViewController.m
//  TSP_d
//
//  Created by evol on 2018/12/7.
//  Copyright © 2018 evol. All rights reserved.
//

#import "ViewController.h"
#import "TspRouter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = UIColor.redColor;
    // Do any additional setup after loading the view, typically from a nib.
    
    TspRouter * router = [TspRouter new];
    
    
    NSArray * cities = router.cities;
    double max_x = 0;
    double max_y = 0;
    
    for (NSDictionary * dict in cities) {
        double _x = [dict[@"X"] doubleValue];
        double _y = [dict[@"Y"] doubleValue];
        if (max_x < _x) {
            max_x = _x;
        }
        if (max_y < _y) {
            max_y = _y;
        }
    }
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 400, 400)];
    view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:view];
    /** 路线绘制的layer */
    CAShapeLayer * _routeLayer = [[CAShapeLayer alloc] init];
    _routeLayer.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
    _routeLayer.fillColor = [UIColor clearColor].CGColor;
    _routeLayer.strokeColor = [UIColor redColor].CGColor;
    _routeLayer.lineWidth = 1;
    _routeLayer.lineJoin = kCALineJoinRound;
    [view.layer addSublayer:_routeLayer];
    
    
    double scale = 350.0/MAX(max_y, max_x);
    
    
    for (NSDictionary * dict in cities) {
        double _x = [dict[@"X"] doubleValue];
        double _y = [dict[@"Y"] doubleValue];
        UILabel * label = [[UILabel alloc] init];
        label.textColor = UIColor.redColor;
        label.text = [NSString stringWithFormat:@"%@",dict[@"name"]];
        [view addSubview:label];
        [label sizeToFit];
        label.center = CGPointMake(_x*scale, 400 - (_y * scale));
    }
    
    CGMutablePathRef  path = CGPathCreateMutable();
    NSArray * routes =  [router caculate];
    
    NSDictionary * firstDict = [cities objectAtIndex:[routes[0] integerValue]];
    double _x = [firstDict[@"X"] doubleValue];
    double _y = [firstDict[@"Y"] doubleValue];
    CGPoint firstPoint = CGPointMake(_x*scale, 400 - (_y * scale));
    CGPathMoveToPoint(path, NULL, firstPoint.x, firstPoint.y);
    
    for (int i = 1, count = (int)cities.count; i < count; i++) {
        NSDictionary * tempD = [cities objectAtIndex:[routes[i] integerValue]];
        double _xx = [tempD[@"X"] doubleValue];
        double _yy = [tempD[@"Y"] doubleValue];
        CGPoint currentPoint = CGPointMake(_xx*scale, 400 - (_yy * scale));
        CGPathAddLineToPoint(path, NULL, currentPoint.x, currentPoint.y);
    }
    _routeLayer.path = path;
    CGPathRelease(path);

}


@end
