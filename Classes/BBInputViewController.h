#import <UIKit/UIKit.h>


@interface BBInputViewController : UIViewController <UIAccelerometerDelegate>
{
	NSMutableSet* touchEvents;
	
	NSMutableArray * interfaceObjects;
	
	CGFloat forwardMagnitude;
	CGFloat rightMagnitude;
	CGFloat leftMagnitude;
	BOOL fireMissile;
	
	float m_acceleration_y;
}

@property (retain) NSMutableSet* touchEvents;
@property (assign) CGFloat forwardMagnitude;
@property (assign) BOOL fireMissile;
@property (assign) CGFloat rightMagnitude;
@property (assign) CGFloat leftMagnitude;
@property (assign) float m_acceleration_y;

- (void)clearEvents;
- (void)dealloc ;
- (void)didReceiveMemoryWarning ;
- (void)loadView ;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)viewDidUnload ;
- (void)loadInterface;
- (void)updateInterface;
- (void)renderInterface;

-(CGRect)screenRectFromMeshRect:(CGRect)rect atPoint:(CGPoint)meshCenter;
// 7 methods



@end
