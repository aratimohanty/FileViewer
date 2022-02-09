//
//  ViewController.h
//  hcl_test
//
//  Created by ARATI on 08/02/22.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (weak) IBOutlet NSTextField *direcoryPathField;
@property (weak) IBOutlet NSButtonCell *nextBtn;

- (IBAction)onCancelButtonClicked:(id)sender;
- (IBAction)onNextButtonClicked:(id)sender;
- (IBAction)onBrowsingButtonClicked:(id)sender;
@end

