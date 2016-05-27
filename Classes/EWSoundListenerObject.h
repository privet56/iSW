#import <Foundation/Foundation.h>
#import <OpenAL/al.h>
#import "EWSoundState.h"
#import "OpenALSoundController.h"

@interface EWSoundListenerObject : EWSoundState
{
	BBPoint atOrientation;
	BBPoint upOrientation;
}

@property(nonatomic, assign) BBPoint atOrientation;
@property(nonatomic, assign) BBPoint upOrientation;

@end
