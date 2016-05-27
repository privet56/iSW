#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>
#import "BBPoint.h";
#import "BBConfiguration.h";

@class BBTexturedQuad;
@class BBAnimatedQuad;

@interface BBMaterialController : NSObject
{
	NSMutableDictionary * materialLibrary;
	NSMutableDictionary * quadLibrary;
}

+ (BBMaterialController*)sharedMaterialController;
- (BBAnimatedQuad*)animationFromAtlasKeys:(NSArray*)atlasKeys;
- (BBTexturedQuad*)quadFromAtlasKey:(NSString*)atlasKey;
- (BBTexturedQuad*)texturedQuadFromAtlasRecord:(NSDictionary*)record
																	 atlasSize:(CGSize)atlasSize
																	 materialKey:(NSString*)key;;
- (CGSize)loadTextureImage:(NSString*)imageName materialKey:(NSString*)materialKey;
- (id) init;
- (void) dealloc;
- (void)bindMaterial:(NSString*)materialKey;
- (void)loadAtlasData:(NSString*)atlasName;

@end
