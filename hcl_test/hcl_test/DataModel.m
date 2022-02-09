//
//  DataModel.m
//  hcl_test
//
//  Created by ARATI on 08/02/22.
//

#import "DataModel.h"
#import "FileInfo.h"

@implementation DataModel
@synthesize url,filesArray;

+ (id)sharedManager {
static DataModel *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    sharedMyManager = [[self alloc] init];
  });
  return sharedMyManager;
}

- (id)initWithFolder:(NSString *)url {
 if (self = [super init]) {
    self.url = url;
     self.filesArray = [[NSMutableArray alloc]init];
 }
return self;
}

- (NSMutableArray *)getFilesArray {
    return self.filesArray;
}
- (void)listAllFiles:(BOOL)isRecursive {
    if (self.filesArray.count) {
        [self.filesArray removeAllObjects];
    }
    NSArray *requiredAttributes = @[NSURLNameKey, NSURLFileAllocatedSizeKey, NSURLContentTypeKey, NSURLContentModificationDateKey, NSURLIsReadableKey, NSURLIsWritableKey,NSURLCustomIconKey, NSURLPathKey];
    if (![NSURL fileURLWithPath:self.url]) {
        return;
    }
    NSDirectoryEnumerator *de = [[NSFileManager defaultManager] enumeratorAtURL:[NSURL fileURLWithPath:self.url] includingPropertiesForKeys:requiredAttributes options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:nil];

    for (NSURL *fileURL in de) {
        NSNumber *isDirectory = nil;
        [fileURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
        
        if ([isDirectory boolValue]) {
            if (!isRecursive) {
                [de skipDescendants];
            } else {
                continue;
            }
        } else {
            [self.filesArray addObject:[self generateFileObjFromURL:fileURL]];
        }
    }
}

- (FileInformation *)generateFileObjFromURL:(id)fileURL {
    NSString *url = [fileURL path];
    NSString* displayName = nil;
    NSString* displayType = nil;
    NSString* displaySize = nil;
    NSImage* displayIcon = nil;
    NSDate* displayModifiedDate = nil;
    [fileURL getResourceValue:&displayName forKey:NSURLLocalizedNameKey error:nil];
    [fileURL getResourceValue:&displayType forKey:NSURLContentTypeKey error:nil];
    [fileURL getResourceValue:&displaySize forKey:NSURLTotalFileSizeKey error:nil];
    [fileURL getResourceValue:&displayIcon forKey:NSURLCustomIconKey error:nil];
    [fileURL getResourceValue:&displayModifiedDate forKey:NSURLContentModificationDateKey error:nil];
    FileInformation *obj = [[FileInformation alloc]initWithURL:url Name:displayName type:displayType size:displaySize];
    obj.modified_date = displayModifiedDate;
    obj.icon = displayIcon;
    obj.isreadable = [fileURL isreadable];
    obj.isWritable = [fileURL isWritable];
    return obj;
}
@end
