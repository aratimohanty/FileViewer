//
//  FileInfo.m
//  hcl_test
//
//  Created by ARATI on 08/02/22.
//

#import "FileInfo.h"

@implementation FileInformation 
- (instancetype) initWithURL:(NSString *)url Name: (NSString *)name type: (NSString *)type size: (NSString *)size {
    if (self = [super init]) {
        self.url = url;
        self.name = name;
        self.type = type;
        self.size = size;
        self.modified_date = [NSDate date];
        self.icon = [[NSImage alloc]init];
        self.isreadable = YES;
        self.isWritable = NO;
    }
    return self;
}
@end

//testing1
//test2
