#import "BBSceneObject.h"

@interface BBAnimation : BBSceneObject
{

}

- (id) initWithAtlasKeys:(NSArray*)keys loops:(BOOL)loops speed:(NSInteger)speed;
- (void)awake;
- (void)update;

@end
