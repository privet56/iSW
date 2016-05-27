#import "BBSceneController.h"
#import "BBInputViewController.h"
#import "EAGLView.h"
#import "BBSpaceShip.h"
#import "BBSpaceShip2Shot.h"
#import "BBRock.h"
#import "BBCollisionController.h"
#import "BBConfiguration.h"
#import "BBMobileObject.h"
#import "BBDeathStar.h"
#import "BBParticleSystem.h"

#import <objc/runtime.h>


@implementation BBSceneController

@synthesize inputController, openGLView;
@synthesize animationInterval, animationTimer, deltaTime, levelStartDate;

// Singleton accessor.  this is how you should ALWAYS get a reference
// to the scene controller.  Never init your own. 
+(BBSceneController*)sharedSceneController
{
  static BBSceneController *sharedSceneController;
  @synchronized(self)
  {
    if (!sharedSceneController)
      sharedSceneController = [[BBSceneController alloc] init];
		
    return sharedSceneController;
  }
  return sharedSceneController;
}

- (id) init
{
	self = [super init];
	if(nil != self)
	{
		[[OpenALSoundController sharedSoundController] setSoundCallbackDelegate:self];
		[self invokeLoadResources];
		// As of iPhone OS 3.0, setting the alDistanceModel to AL_NONE doesn't seem to work.
		// So I require a work around which is implemented elsewhere.
		[[OpenALSoundController sharedSoundController] setDistanceModel:AL_INVERSE_DISTANCE_CLAMPED];
//		[[OpenALSoundController sharedSoundController] setDistanceModel:AL_LINEAR_DISTANCE_CLAMPED];
//		[[OpenALSoundController sharedSoundController] setDistanceModel:AL_EXPONENT_DISTANCE_CLAMPED];
		[[OpenALSoundController sharedSoundController] setDopplerFactor:1.0];
		[[OpenALSoundController sharedSoundController] setSpeedOfSound:343.3];
	}
	return self;
}
#pragma mark scene preload

- (void) invokeLoadResources
{
	int number_of_classes;
	Class* list_of_classes = NULL;
	// Get the number of classes so we can create a buffer of the correct size
	number_of_classes = objc_getClassList(NULL, 0);
	if(number_of_classes <= 0)
	{
		return;
	}
	
	list_of_classes = malloc(sizeof(Class) * number_of_classes);
	number_of_classes = objc_getClassList(list_of_classes, number_of_classes);
	for(int i=0; i<number_of_classes; i++)
	{
		Class current_class = list_of_classes[i];
		if(class_getClassMethod(current_class, @selector(isSubclassOfClass:)))
		{
			if([current_class isSubclassOfClass:[BBSceneObject class]])
			{
				// We found a BBSceneObject
				if([current_class respondsToSelector:@selector(loadResources)])
				{
					// Could invoke the usual way, but the compiler gives an annoying warning
					// [current_class loadResources];
					// Instead, using obj_msgSend avoids the warning
					objc_msgSend(current_class, @selector(loadResources));
				}
			}
		}
	}

	free(list_of_classes);	
}

// this is where we initialize all our scene objects
-(void)loadScene
{
	RANDOM_SEED();
	// this is where we store all our objects
	sceneObjects = [[NSMutableArray alloc] init];

	[self generateRocks];
//
	collisionController = [[BBCollisionController alloc] init];
	collisionController.sceneObjects = sceneObjects;
	if (DEBUG_DRAW_COLLIDERS)	[self addObjectToScene:collisionController];
	
	self.animationInterval = 1.0/60.0;
	self.levelStartDate = [NSDate date];
	lastFrameStartTime = 0;
	
	[inputController loadInterface];
}

// we dont actualy add the object directly to the scene.
// this can get called anytime during the game loop, so we want to
// queue up any objects that need adding and add them at the start of
// the next game loop
-(void)addObjectToScene:(BBSceneObject*)sceneObject
{
	if (objectsToAdd == nil) objectsToAdd = [[NSMutableArray alloc] init];

	sceneObject.active = YES;
	[sceneObject awake];
	[objectsToAdd addObject:sceneObject];
}

// similar to adding objects, we cannot just remove objects from
// the scene at any time.  we want to queue them for removal 
// and purge them at the end of the game loop
-(void)removeObjectFromScene:(BBSceneObject*)sceneObject
{
	if (objectsToRemove == nil) objectsToRemove = [[NSMutableArray alloc] init];
	[objectsToRemove addObject:sceneObject];
}

// generate a bunch of random rocks and add them to the scene
-(void)generateRocks
{
	{	//STARs
		NSInteger Count = 90;
		NSInteger index=0;
		for (index = 0; index < Count; index ++)
		{
			[self addObjectToScene:[BBRock randomRock]];
		}
	}
	{	//DEATH STAR
		BBDeathStar* ds = [[BBDeathStar alloc] init];
		
		ds.scale		= BBPointMake(2.5,2.5,1.0);
		
		//ds.translation	= BBPointMake(-((DEVICE_HEIGHT/2.0)-5.0), ((DEVICE_WIDTH/2.0)-50.0)-(9*9), 0.0);
		ds.translation	= BBPointMake(-(DEVICE_HEIGHT/2), ((DEVICE_WIDTH/2.0)-50.0)-(9*9), 0.0);
		
		ds.rotation		= BBPointMake(0.0, 0.0, 0.0);
		
		ds.speed		= BBPointMake(0.0, 0.0, 0.0);
		
		[self addObjectToScene:ds];
		[ds release];
	}	
	{	//TIEs
		NSInteger Count = 11;
		NSInteger index	= 0;
		
		for (index = 0; index < Count; index ++)
		{
			BBSpaceShip2Shot* s2s = [[BBSpaceShip2Shot alloc] init];
			
			s2s.scale		= BBPointMake(2.5,2.5,1.0);
			
			s2s.translation = BBPointMake(-((DEVICE_HEIGHT/2.0)-5.0), ((DEVICE_WIDTH/2.0)-50.0)-(index*9), 0.0);
			
			s2s.rotation	= BBPointMake(0.0, 0.0, -90.0);
			
			{
				CGFloat speedx  = 1.9;
				int iSpeed = RANDOM_INT(0,550) + 50;
				speedx = ((float)iSpeed) / 100.0;
				s2s.speed		= BBPointMake(speedx, 0.0, 0.0);
			}
			
			[self addObjectToScene:s2s];
			[s2s release];
		}		
	}
	{
		BBSpaceShip * ship = [[BBSpaceShip alloc] init];
		ship.scale = BBPointMake(2.5, 2.5, 1.0);
		ship.translation = BBPointMake(-0, -((DEVICE_WIDTH/2.0)-100.0), 0.0);	//iPad -> position on the bottom center
		[self addObjectToScene:ship];
		[ship release];		
	}
}

// makes everything go
-(void) startScene
{
	self.animationInterval = 1.0/60.0;
	[self startAnimation];
}

#pragma mark Game Loop

- (void)gameLoop
{
	// we use our own autorelease pool so that we can control when garbage gets collected
	NSAutoreleasePool * apool = [[NSAutoreleasePool alloc] init];
	
	thisFrameStartTime = [levelStartDate timeIntervalSinceNow];
	deltaTime = lastFrameStartTime = thisFrameStartTime;
	lastFrameStartTime = thisFrameStartTime;

	// add any queued scene objects
	if ([objectsToAdd count] > 0) {
		[sceneObjects addObjectsFromArray:objectsToAdd];
		[objectsToAdd removeAllObjects];
	}
	
	// update our model
	[self updateModel];
	// deal with collisions
	[collisionController handleCollisions];

	// send our objects to the renderer
	[self renderScene];
	
	// remove any objects that need removal
	if ([objectsToRemove count] > 0) {
		[sceneObjects removeObjectsInArray:objectsToRemove];
		[objectsToRemove removeAllObjects];
	}
	
	[apool release];
}

- (void)updateModel
{
	// simply call 'update' on all our scene objects
	[inputController updateInterface];
	[sceneObjects makeObjectsPerformSelector:@selector(update)];
	[[OpenALSoundController sharedSoundController] update];
	// be sure to clear the events
	[inputController clearEvents];
}

- (void)renderScene
{
	// turn openGL 'on' for this frame
	[openGLView beginDraw];
	[self setupLighting];
	// simply call 'render' on all our scene objects
	[sceneObjects makeObjectsPerformSelector:@selector(render)];
	// draw the interface on top of everything
	[inputController renderInterface];
	// finalize this frame
	[openGLView finishDraw];
}

-(void)setupLighting
{
	return;
	// cull the unseen faces
	// we use 'front' culling because Cheetah3d exports our models to be compatible
	// with this way
	glEnable(GL_CULL_FACE);
	glCullFace(GL_FRONT);
	
  // Light features
  GLfloat light_ambient[]= { 0.2f, 0.2f, 0.2f, 1.0f };
  GLfloat light_diffuse[]= { 80.0f, 80.0f, 80.0f, 0.0f };
  GLfloat light_specular[]= { 80.0f, 80.0f, 80.0f, 0.0f };
  // Set up light 0
  glLightfv (GL_LIGHT0, GL_AMBIENT, light_ambient);
  glLightfv (GL_LIGHT0, GL_DIFFUSE, light_diffuse);
  glLightfv (GL_LIGHT0, GL_SPECULAR, light_specular);
  
// // // Material features
//  GLfloat mat_specular[] = { 0.5, 0.5, 0.5, 1.0 };
//  GLfloat mat_shininess[] = { 120.0 };
//  glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, mat_specular);
//  glMaterialfv(GL_FRONT_AND_BACK, GL_SHININESS, mat_shininess);
  
  glShadeModel (GL_SMOOTH);
  
  // Enable lighting and lights
  glEnable(GL_LIGHTING);
  glEnable(GL_LIGHT0);
  
  // Place the light up and to the right
  GLfloat light0_position[] = { 50.0, 50.0, 50.0, 1.0 };
  glLightfv(GL_LIGHT0, GL_POSITION, light0_position);
}

#pragma mark Animation Timer

// these methods are copied over from the EAGLView template

- (void)startAnimation {
	self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
}

- (void)stopAnimation {
	self.animationTimer = nil;
}

- (void)setAnimationTimer:(NSTimer *)newTimer {
	[animationTimer invalidate];
	animationTimer = newTimer;
}

- (void)setAnimationInterval:(NSTimeInterval)interval {	
	animationInterval = interval;
	if (animationTimer)
	{
		[self stopAnimation];
		[self startAnimation];
	}
}

#pragma mark dealloc

- (void) dealloc
{
	[self stopAnimation];
	
	[sceneObjects release];
	[objectsToAdd release];
	[objectsToRemove release];
	[inputController release];
	[openGLView release];
	[collisionController release];
	
	[super dealloc];
}
#pragma mark EWSoundCallbackDelegate

- (void) soundDidFinishPlaying:(NSNumber*)source_number
{
	[sceneObjects makeObjectsPerformSelector:@selector(soundDidFinishPlaying:) withObject:source_number];
}

@end
