#import "BBButton.h"

@interface BBTexturedButton : BBButton
{
	BBTexturedQuad * upQuad;
	BBTexturedQuad * downQuad;
}

- (id) initWithUpKey:(NSString*)upKey downKey:(NSString*)downKey;
- (void)dealloc;
- (void)awake;
- (void)setNotPressedVertexes;
- (void)setPressedVertexes;
- (void)update;

@end
