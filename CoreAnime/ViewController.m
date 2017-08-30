#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UIView *blueView;
@property (weak, nonatomic) IBOutlet UIButton *recordPathButton;
@property (weak, nonatomic) IBOutlet UIView *yellowView;
@property (weak, nonatomic) IBOutlet UIView *purpleView;

@end


@implementation ViewController

bool recordIsOn = false;
NSMutableArray* locs;




- (IBAction)fadeTheRed:(id)sender
{
    // Core Animation to fade out a view
    CALayer* redLayer = _redView.layer;
    
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:1.0];
    fadeAnim.toValue = [NSNumber numberWithFloat:0.0];
    fadeAnim.duration = 1.0;
    [redLayer addAnimation:fadeAnim forKey:@"opacity"];
    redLayer.opacity = 0.0;
}

- (IBAction)changeTheRedAction:(id)sender {
    
    CAKeyframeAnimation * colorKeyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"backgroundColor"];
    
    colorKeyframeAnimation.values = [[NSArray alloc] initWithObjects:
                                     (id)[[UIColor redColor] CGColor],
                                     (id)[[UIColor greenColor] CGColor],
                                     (id)[[UIColor blueColor] CGColor],nil];
    
    
    colorKeyframeAnimation.keyTimes = [[NSArray alloc] initWithObjects:
                                       [NSNumber numberWithInteger:0],
                                       [NSNumber numberWithInteger:.3],
                                       [NSNumber numberWithInteger:1], nil];
    
    colorKeyframeAnimation.duration = 5;
    
    CALayer* redLayer = _redView.layer;
    [redLayer addAnimation:colorKeyframeAnimation forKey:@"backgroundColor"];
}

- (IBAction)recordPathAction:(id)sender {
    if ( recordIsOn )
    {
        recordIsOn = false;
        _recordPathButton.backgroundColor = [UIColor purpleColor];
    }
    else
    {
        recordIsOn = true;
        locs = [NSMutableArray new];
        _recordPathButton.backgroundColor = [UIColor redColor];
    }
}
- (IBAction)animationGroupAction:(id)sender {
    
    CALayer* redLayer = _redView.layer;
    
    // Animation 1
    CAKeyframeAnimation* widthAnim = [CAKeyframeAnimation animationWithKeyPath:@"borderWidth"];
    NSArray* widthValues = [NSArray arrayWithObjects:
                            @1.0,
                            @10.0,
                            @5.0,
                            @30.0,
                            @0.5,
                            @15.0,
                            @2.0,
                            @50.0,
                            @0.0, nil];
    
    widthAnim.values = widthValues;
    widthAnim.calculationMode = kCAAnimationLinear;
    
    // Animation 2
    CAKeyframeAnimation* colorAnim = [CAKeyframeAnimation animationWithKeyPath:@"borderColor"];
    NSArray* colorValues = [NSArray arrayWithObjects:
                            (id)[UIColor greenColor].CGColor,
                            (id)[UIColor redColor].CGColor,
                            (id)[UIColor blueColor].CGColor,
                            nil];
    
    colorAnim.values = colorValues;
    colorAnim.calculationMode = kCAAnimationPaced;
    
    // Animation group
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:colorAnim, widthAnim, nil];
    group.duration = 5.0;
    [redLayer addAnimation:group forKey:@"BorderChanges"];
}

- (IBAction)doRecordedAnimateAction:(id)sender {
    
    
    /*
     if (recordIsOn || locs.count == 0)
     return;
     else
     {
     CALayer* blueLayer = _blueView.layer;
     _blueView.center = [[locs objectAtIndex:0] CGPointValue];
     
     CGMutablePathRef thePath = CGPathCreateMutable();
     CGPathMoveToPoint(thePath,
     NULL,
     [[locs objectAtIndex:0]CGPointValue].x,
     [[locs objectAtIndex:0]CGPointValue].y);
     
     for (NSValue * any in locs)
     {
     CGPoint thisPoint = [any CGPointValue];
     CGPathAddLineToPoint(thePath, NULL, thisPoint.x, thisPoint.y);
     }
     
     CAKeyframeAnimation * theAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
     theAnimation.path = thePath;
     theAnimation.duration = 5.0;
     
     //        // apply animation to the layer
     [blueLayer addAnimation:theAnimation forKey:@"position"];
     }
     */
    
    
    
    
    
    
    
    
    
    
    // CG Path BASIC
    CALayer* blueLayer = _blueView.layer;
    _blueView.center = CGPointMake(200, 200);
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathMoveToPoint(thePath,NULL, 200, 200);
    CGPathAddLineToPoint(thePath, NULL, 350, 350);
    CGPathAddLineToPoint(thePath, NULL, 300, 300);
    CAKeyframeAnimation * theAnimation = [CAKeyframeAnimation
                                          animationWithKeyPath:@"position"];
    theAnimation.path = thePath;
    theAnimation.duration = 3.0;
    [blueLayer addAnimation:theAnimation
                     forKey:@"position"];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // or below for Bezier points
    //    CGPathAddCurveToPoint(thePath,NULL,320.0,500.0, 566.0,500.0, 566.0,74.0);
    
    
}




-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch* myTouch = [[touches allObjects] objectAtIndex:0];
    CGPoint thisLoc = [myTouch locationInView: self.view];
    [locs addObject:[NSValue valueWithCGPoint: thisLoc]];
}


- (IBAction)transitionAction:(id)sender
{
    _yellowView.clipsToBounds = true;
    _purpleView.clipsToBounds = true;
    
    CATransition* transition = [CATransition animation];
    transition.startProgress = 0;
    transition.endProgress = 1.0;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    transition.duration = 5.0;
    
    // transitions
    [_yellowView.layer addAnimation:transition forKey:@"transition"];
    [_purpleView.layer addAnimation:transition forKey:@"transition"];
    
    
    // Visibilities
    
    _yellowView.hidden = YES;
    _purpleView.hidden = NO;
}


// Pausing and resuming

-(void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}





- (void)viewDidLoad
{
    [super viewDidLoad];
}


@end
