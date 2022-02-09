//
//  DataModel.h
//  hcl_test
//
//  Created by ARATI on 08/02/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataModel : NSObject {
    
}
@property(nonatomic) NSString *url;
@property (nonatomic, strong) NSMutableArray *filesArray;
+ (id)sharedManager;
- (id)initWithFolder:(NSString *)url;
- (NSMutableArray *)getFilesArray;
- (void)listAllFiles:(BOOL)isRecursive;

@end

NS_ASSUME_NONNULL_END
