//
//  ViewController.m
//  hcl_test
//
//  Created by ARATI on 08/02/22.
//

#import "ViewController.h"
#import "FileListViewController.h"
#import "DataModel.h"

@interface ViewController () {
    NSOpenPanel* folderBrowserDialog;
}
@property(nonatomic)NSOpenPanel* folderBrowserDialog;
@end

@implementation ViewController
@synthesize folderBrowserDialog;
- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)viewWillAppear {
    [super viewWillAppear];

    [self.nextBtn setEnabled:NO];
    [self.nextBtn setHighlighted:NO];
}

- (IBAction)onNextButtonClicked:(id)sender {
    NSStoryboard *sb = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    FileListViewController *listVC = [sb instantiateControllerWithIdentifier:@"ListVC"];
    self.view.window.contentViewController = listVC;
    self.presentingViewController.representedObject = self.folderBrowserDialog.URL;
}

- (IBAction)onCancelButtonClicked:(id)sender {
    [self.view.window close];
}

- (IBAction)onBrowsingButtonClicked:(id)sender {
    self.folderBrowserDialog = [NSOpenPanel openPanel];
    [self.folderBrowserDialog setCanChooseFiles:NO];
    [self.folderBrowserDialog setCanChooseDirectories:YES];
    [self.folderBrowserDialog setAllowsMultipleSelection:NO];
    [self.folderBrowserDialog setDirectoryURL:[NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) firstObject]]];

    NSModalResponse response = [self.folderBrowserDialog runModal];
    if (response == NSModalResponseOK) {
        [self.direcoryPathField setStringValue:[NSString stringWithFormat:@"%@", [(NSURL*)[[self.folderBrowserDialog URLs] objectAtIndex:0] path]]];
        [[DataModel sharedManager]initWithFolder: self.direcoryPathField.stringValue];

        [self.nextBtn setEnabled:YES];
        [self.nextBtn setHighlighted:YES];
    } else {
        [self.nextBtn setEnabled:NO];
        [self.nextBtn setHighlighted:NO];
    }

}
@end
