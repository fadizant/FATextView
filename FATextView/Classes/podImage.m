//
//  podImage.m
//  Pods
//
//  Created by Fadi Abuzant on 9/13/16.
//
//

#import "podImage.h"

@implementation podImage

+(UIImage*)imageNamedFromPodResources:(NSString *)name
{
    NSString *bundleName = [[NSBundle bundleForClass:self.class].bundleIdentifier stringByReplacingOccurrencesOfString:@"org.cocoapods." withString:@""] ;
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle bundleForClass:self.class] URLForResource:bundleName withExtension:@"bundle"]];
    return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
}

@end
