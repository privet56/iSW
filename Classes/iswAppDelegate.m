#import "iswAppDelegate.h"
#import "BBInputViewController.h"
#import "EAGLView.h"
#import "BBSceneController.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation iswAppDelegate

@synthesize window;
@synthesize viewController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	BBSceneController * sceneController = [BBSceneController sharedSceneController];
	
	// make a new input view controller, and save it as an instance variable
	BBInputViewController * anInputController = [[BBInputViewController alloc] initWithNibName:nil bundle:nil];
	sceneController.inputController = anInputController;
	[anInputController release];
	
	// init our main EAGLView with the same bounds as the window
	EAGLView * glView = [[EAGLView alloc] initWithFrame:window.bounds];
	sceneController.inputController.view = glView;
	sceneController.openGLView = glView;
	[glView release];
	
	// set our view as the first window view
	[window addSubview:sceneController.inputController.view];
	[window makeKeyAndVisible];
	
	// begin the game.
	[sceneController loadScene];
	[sceneController startScene];

	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)dealloc
{
    [window release];
    [super dealloc];
}

@end
