#import <UIKit/UIKit.h>

@class iswViewController;

@interface iswAppDelegate : NSObject <UIApplicationDelegate>
{
    UIWindow *window;
	iswViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet iswViewController *viewController;

@end

