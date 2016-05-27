#import "BBInputViewController.h"
#import "BBButton.h"
#import "BBArrowButton.h"
#import "BBTexturedButton.h"
#import <AudioToolbox/AudioToolbox.h>


@implementation BBInputViewController

@synthesize touchEvents, forwardMagnitude, rightMagnitude, leftMagnitude,fireMissile, m_acceleration_y;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
		// init our touch storage set
		touchEvents = [[NSMutableSet alloc] init];
		forwardMagnitude=0.0;
		m_acceleration_y=0.0;
		leftMagnitude  = 0.0;
		rightMagnitude = 0.0;
	}
	return self;
}

-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
//NSLog(@"accel x:%f, y:%f z:%f",acceleration.x, acceleration.y, acceleration.z);
//NSLog(@"accel x:%.2f     y:%.2f    z:%.2f",acceleration.x,acceleration.y,acceleration.z);
//NSLog(@"accel x:%.2f",acceleration.y);

	if(abs(acceleration.y*12.0) > 0.25)
	{
		m_acceleration_y = acceleration.y*12.0;
	}
	else
		m_acceleration_y = 0.0;
}

-(void)loadView
{
	
}

-(CGRect)screenRectFromMeshRect:(CGRect)rect atPoint:(CGPoint)meshCenter
{
	// find the point on the screen that is the center of the rectangle
	// and use that to build a screen-space rectangle
	CGPoint screenCenter = CGPointZero;
	CGPoint rectOrigin = CGPointZero;
	// since our view is rotated, then our x and y are flipped
	screenCenter.x = meshCenter.y + (DEVICE_WIDTH/2.0); // need to shift it over
	screenCenter.y = meshCenter.x + (DEVICE_HEIGHT/2.0); // need to shift it up
	
	rectOrigin.x = screenCenter.x - (CGRectGetHeight(rect)/2.0); // height and width 
	rectOrigin.y = screenCenter.y - (CGRectGetWidth(rect)/2.0); // are flipped
	
	return CGRectMake(rectOrigin.x, rectOrigin.y, CGRectGetHeight(rect), CGRectGetWidth(rect));
}


#pragma mark Touch Event Handlers

// just a handy way for other object to clear our events
- (void)clearEvents
{
	[touchEvents removeAllObjects];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	// just store them all in the big set.
	[touchEvents addObjectsFromArray:[touches allObjects]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	// just store them all in the big set.
	[touchEvents addObjectsFromArray:[touches allObjects]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	// just store them all in the big set.
	[touchEvents addObjectsFromArray:[touches allObjects]];
}

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark Loading the Buttons

-(void)loadInterface
{
	if (interfaceObjects == nil) interfaceObjects = [[NSMutableArray alloc] init];
	[interfaceObjects removeAllObjects];
	
	// right arrow button
	//BBArrowButton * rightButton = [[BBArrowButton alloc] init];
	BBTexturedButton* rightButton = [[BBTexturedButton alloc] initWithUpKey:@"rightUp" downKey:@"rightDown"];
	rightButton.scale = BBPointMake(50.0, 50.0, 1.0);
	rightButton.translation = BBPointMake(-155.0, -130.0, 0.0);												//iPhone
	rightButton.translation = BBPointMake(((DEVICE_HEIGHT/2.0)-50.0), 0, 0.0);								//iPad
	rightButton.target = self;
	rightButton.buttonDownAction = @selector(rightButtonDown);
	rightButton.buttonUpAction = @selector(rightButtonUp);
	rightButton.active = YES;
	[rightButton awake];
	[interfaceObjects addObject:rightButton];
	[rightButton release];
	
	// left arrow
	//BBArrowButton * leftButton = [[BBArrowButton alloc] init];
	BBTexturedButton* leftButton = [[BBTexturedButton alloc] initWithUpKey:@"leftUp" downKey:@"leftDown"];
	leftButton.scale = BBPointMake(50.0, 50.0, 1.0);
	leftButton.translation = BBPointMake(-210.0, -130.0, 0.0);											//iPhone
	leftButton.translation = BBPointMake(-((DEVICE_HEIGHT/2.0)-50.0), 0, 0.0);	//iPad
	//leftButton.rotation = BBPointMake(0.0, 0.0, 180.0);
	leftButton.target = self;
	leftButton.buttonDownAction = @selector(leftButtonDown);
	leftButton.buttonUpAction = @selector(leftButtonUp);
	leftButton.active = YES;
	[leftButton awake];
	[interfaceObjects addObject:leftButton];
	[leftButton release];

	/*
	// forward button
	BBArrowButton * forwardButton = [[BBArrowButton alloc] init];
	forwardButton.scale = BBPointMake(50.0, 50.0, 1.0);
	forwardButton.translation = BBPointMake(-185.0, -75.0, 0.0);											//iPhone
	forwardButton.translation = BBPointMake(-((DEVICE_HEIGHT/2.0)-75.0), -((DEVICE_WIDTH/2.0)-105.0), 0.0);	//iPad
	forwardButton.rotation = BBPointMake(0.0, 0.0, 90.0);
	forwardButton.target = self;
	forwardButton.buttonDownAction = @selector(forwardButtonDown);
	forwardButton.buttonUpAction = @selector(forwardButtonUp);	
	forwardButton.active = YES;
	[forwardButton awake];
	[interfaceObjects addObject:forwardButton];
	[forwardButton release];
	*/
	// rfire Button
	//BBButton * rfireButton = [[BBButton alloc] init];
	BBTexturedButton* rfireButton = [[BBTexturedButton alloc] initWithUpKey:@"fireUp" downKey:@"fireDown"];
	rfireButton.scale = BBPointMake(50.0, 50.0, 1.0);
	rfireButton.translation = BBPointMake(rightButton.translation.x, rightButton.translation.y-55.0, rightButton.translation.z);
	rfireButton.target = self;
	rfireButton.buttonDownAction = @selector(fireButtonDown);
	rfireButton.buttonUpAction = @selector(fireButtonUp);
	rfireButton.active = YES;
	[rfireButton awake];
	[interfaceObjects addObject:rfireButton];
	[rfireButton release];
	
	// lfire Button
	//BBButton * lfireButton = [[BBButton alloc] init];
	BBTexturedButton* lfireButton = [[BBTexturedButton alloc] initWithUpKey:@"fireUp" downKey:@"fireDown"];
	lfireButton.scale = BBPointMake(50.0, 50.0, 1.0);
	lfireButton.translation = BBPointMake(leftButton.translation.x, leftButton.translation.y-55.0, leftButton.translation.z);
	lfireButton.target = self;
	lfireButton.buttonDownAction = @selector(fireButtonDown);
	lfireButton.buttonUpAction = @selector(fireButtonUp);
	lfireButton.active = YES;
	[lfireButton awake];
	[interfaceObjects addObject:lfireButton];
	[lfireButton release];
	
	{
		UIAccelerometer* accel = [UIAccelerometer sharedAccelerometer];
		accel.updateInterval = 1.0f / 9.0f;
		accel.delegate = self;
	}
	
}

-(void)updateInterface
{
	[interfaceObjects makeObjectsPerformSelector:@selector(update)];
}

-(void)renderInterface
{
	[interfaceObjects makeObjectsPerformSelector:@selector(render)];
	return;
	
	glMatrixMode(GL_PROJECTION);
	glPushMatrix();
	glLoadIdentity();
	glRotatef(-90.0f, 0.0f, 0.0f, 1.0f);
	
	// set up the viewport so that it is analagous to the screen pixels
	glOrthof(-240, 240, -160, 160, -1.0f, 50.0f);
	
	glMatrixMode(GL_MODELVIEW);
	glDisable(GL_LIGHTING);
	glDisable(GL_CULL_FACE);
//	glCullFace(GL_FRONT);

	// simply call 'render' on all our scene objects
	[interfaceObjects makeObjectsPerformSelector:@selector(render)];

	glMatrixMode(GL_PROJECTION);
	glPopMatrix();
	glMatrixMode(GL_MODELVIEW);
}

#pragma mark Input Registers

-(void)fireButtonDown { self.fireMissile = YES; }

-(void)fireButtonUp {	self.fireMissile = NO;	}

-(void)leftButtonDown {		self.leftMagnitude = 1.0;	}

-(void)leftButtonUp {		self.leftMagnitude = 0.0;	}

-(void)rightButtonDown {	self.rightMagnitude = 1.0;	}

-(void)rightButtonUp {		self.rightMagnitude = 0.0;	}

-(void)forwardButtonDown {	self.forwardMagnitude = 1.0;}

-(void)forwardButtonUp {	self.forwardMagnitude = 0.0;}


- (void)dealloc 
{
	[touchEvents release];
	[super dealloc];
}


@end
