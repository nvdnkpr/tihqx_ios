//
//   Copyright 2012 jordi domenech <jordi@iamyellow.net>
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//

#import "NetIamyellowTihqxView.h"

#include "common.h"
#include "hqx.h"
#include "TiViewProxy.h"

@implementation NetIamyellowTihqxView

static int bytesPerPixel = 4;
static int bitsPerComponent = 8;
static int factor = 2;

#pragma Public APIs

-(void)dealloc
{
    RELEASE_TO_NIL(image);

    [super dealloc];
}

-(void)setImage_:(id)arg
{
    if (image == nil) {
        NSString* source = [TiUtils stringValue:[[self proxy] valueForKey:@"image"]];
        
        // 1st get data from source image
        UIImage* sourceImage = [UIImage imageNamed:source];
        CGImageRef imageRef = [sourceImage CGImage];
        int w = CGImageGetWidth(imageRef);
        int h = CGImageGetHeight(imageRef);
        
        if ([[UIScreen mainScreen] scale] == factor) {
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            int bytesPerRow = bytesPerPixel * w;
            
            // reserve memory (uint32_t = 4 bytes)
            uint32_t* src = (uint32_t*) calloc(w * h * bytesPerPixel, sizeof(uint32_t));
            uint32_t* dst = (uint32_t*) calloc(w * h * bytesPerPixel * factor, sizeof(uint32_t));
            
            CGContextRef srcContext = CGBitmapContextCreate(src,
                                                            w, h,
                                                            bitsPerComponent, bytesPerRow, colorSpace,
                                                            kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
            CGContextDrawImage(srcContext, CGRectMake(0, 0, w, h), imageRef);
            
            // upscale
            hq2x_32(src, dst, w, h);
            
            // make new image with raw data
            CGContextRef dstContext = CGBitmapContextCreate(dst,
                                                            w * factor, h * factor,
                                                            bitsPerComponent, bytesPerRow * factor, colorSpace,
                                                            kCGImageAlphaPremultipliedLast | kCGBitmapByteOrderDefault);
            CGImageRef dstCgImage = CGBitmapContextCreateImage(dstContext);
            
            // create normal view stuff
            image = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:dstCgImage scale:2.0f orientation:0]];
            
            // free up memory
            free(src); free(dst);
            CGContextRelease(dstContext); CGContextRelease(srcContext);
            CGColorSpaceRelease(colorSpace);
            CGImageRelease(dstCgImage);
        }
        else {
            image = [[UIImageView alloc] initWithImage:sourceImage];
        }
        [self addSubview:image];
        [(TiViewProxy*)[self proxy] contentsWillChange]; // not sure if this is necessary
    }
}

@end
