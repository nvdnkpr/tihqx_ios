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

#import "NetIamyellowTihqxModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiBlob.h"
#include "hqx.h"

@implementation NetIamyellowTihqxModule

static int factor2 = 2;
static int bytesPerPixel = 4;
static int bitsPerComponent = 8;

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"5cb08011-5443-495c-8bb6-84781d2bfacc";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"net.iamyellow.tihqx";
}

-(id)get2xBlob:(id)blob
{
    ENSURE_SINGLE_ARG(blob, TiBlob);
    
    // get image from blob
    NSData* data = [blob data];
    UIImage* img = [[UIImage alloc] initWithData:data];
    CGImageRef imageRef = [img CGImage];
    // calculations
    int w = CGImageGetWidth(imageRef);
    int h = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerRow = bytesPerPixel * w;
    
    // reserve memory (uint32_t = 4 bytes)
    uint32_t* src = (uint32_t*) calloc(w * h * bytesPerPixel, sizeof(uint32_t));
    uint32_t* dst = (uint32_t*) calloc(w * h * bytesPerPixel * factor2, sizeof(uint32_t));
    
    // copy image data to buffer
    CGContextRef srcContext = CGBitmapContextCreate(src,
                                                    w, h,
                                                    bitsPerComponent, bytesPerRow, colorSpace,
                                                    kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(srcContext, CGRectMake(0, 0, w, h), imageRef);
    
    // upscale!
    hq2x_32(src, dst, w, h);

    // make destination blob
    CGContextRef dstContext = CGBitmapContextCreate(dst,
                                                    w * factor2, h * factor2,
                                                    bitsPerComponent, bytesPerRow * factor2, colorSpace,
                                                    kCGImageAlphaPremultipliedLast | kCGBitmapByteOrderDefault);
    CGImageRef dstCgImage = CGBitmapContextCreateImage(dstContext);
    TiBlob* destBlob = [[TiBlob alloc] initWithImage:[UIImage imageWithCGImage:dstCgImage scale:[[UIScreen mainScreen] scale] orientation:0]];

    // free up memory
    free(src); free(dst);
    CGContextRelease(dstContext); CGContextRelease(srcContext);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(dstCgImage);
    [img release];
    
    // return
    return [destBlob autorelease];
}

@end
