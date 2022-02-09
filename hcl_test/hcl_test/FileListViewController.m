//
//  FileListViewController.m
//  hcl_test
//
//  Created by ARATI on 08/02/22.
//

#import "FileListViewController.h"
#import "DataModel.h"
#import "FileInfo.h"

@interface FileListViewController () <NSTableViewDataSource, NSTableViewDelegate> {
    
}
@property (weak) IBOutlet NSProgressIndicator *progressBar;
@property (weak) IBOutlet NSButton *recursiveBtn;
@property (weak) IBOutlet NSSearchField *searchField;
@property (weak) IBOutlet NSTableView *filesTable;
@property (weak) IBOutlet NSButtonCell *openBtn;
@property (nonatomic,strong) NSMutableArray *indexArray;
@property (nonatomic, strong) NSArray *filesArray;
@property (nonatomic, strong) NSArray *filteredArray;
@property (nonatomic,strong) NSString *finderUrl;

@end

@implementation FileListViewController
@synthesize filesTable,searchField,filteredArray,filesArray,indexArray,finderUrl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)viewWillAppear {
    [super viewWillAppear];
    [self.progressBar setHidden:YES];
    [self.recursiveBtn setState:NSControlStateValueOff];
    
    [self.openBtn setEnabled:NO];
    [self.openBtn setHighlighted:NO];

    [self fetchDataWithRecursive:NO];
}

- (void)fetchDataWithRecursive:(BOOL)isrecursive {
    [self.progressBar setHidden:NO];
    [self.progressBar startAnimation:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[DataModel sharedManager]listAllFiles:isrecursive];
        self.filesArray = [[DataModel sharedManager]getFilesArray];
        self.filteredArray = self.filesArray;
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.progressBar stopAnimation:nil];
            [self.progressBar setHidden:YES];
            if (self.filteredArray) {
                [self.filesTable reloadData];
            }
        });
    });
}

- (IBAction)isRecursiveBtnClicked:(NSButton *)sender {
    [self fetchDataWithRecursive:(long)sender.state];
}

- (IBAction)onSerachButtonClicked:(id)sender {
    NSString *searchString = [self.searchField stringValue];
    NSPredicate *predicate;

    if ((searchString != nil) && (![searchString isEqualToString:@""])) {
        predicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchString];
        self.filteredArray = [self.filesArray filteredArrayUsingPredicate:predicate];
    }
    else {
        self.filteredArray = self.filesArray;
    }
    [self.filesTable reloadData];
}

- (IBAction)onOpenButtonClicked:(id)sender {
    if (self.indexArray.count > 0) {
        for (NSUInteger i = 0; i < self.indexArray.count; i++  ) {
            FileInformation *obj = [self.filteredArray objectAtIndex:[[self.indexArray objectAtIndex:i] intValue]];
            NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
            [workspace openURL:[NSURL fileURLWithPath:obj.url]];
        }
    }
}

- (IBAction)onCancelButtonClicked:(id)sender {
    NSStoryboard *sb = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    NSViewController *mainVC = [sb instantiateControllerWithIdentifier:@"MainVC"];
    self.view.window.contentViewController = mainVC;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.filteredArray.count;
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *identifier = tableColumn.identifier;
    NSTableCellView *cell = [self.filesTable makeViewWithIdentifier:identifier owner:self];
    FileInformation *obj = [self.filteredArray objectAtIndex:row];
    if ([identifier isEqualToString:@"name"]) {
        cell.textField.stringValue = obj.name;
    } else if ([identifier isEqualToString:@"type"]){
        cell.textField.stringValue = obj.type;
    } else {
        cell.textField.stringValue = obj.size;
    }
    return cell;
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSIndexSet *selectedRows = [self.filesTable selectedRowIndexes];
    NSUInteger numberOfSelectedRows = [selectedRows count];
    if (self.indexArray.count) {
        [self.indexArray removeAllObjects];
    } else {
        self.indexArray = [[NSMutableArray alloc]init];
    }
    NSUInteger index = [selectedRows firstIndex];
    while(index != NSNotFound) {
        [self.indexArray addObject:[NSNumber numberWithUnsignedInteger:index]];
        index=[selectedRows indexGreaterThanIndex: index];
    }
    [self.filesTable selectRowIndexes:selectedRows byExtendingSelection:YES];
    if (numberOfSelectedRows > 0) {
        [self.openBtn setEnabled:YES];
        [self.openBtn setHighlighted:YES];
    } else {
        [self.openBtn setEnabled:NO];
        [self.openBtn setHighlighted:NO];
    }
    
}

-(void)rightMouseDown:(NSEvent *)event {
    NSPoint mousePoint = [self.filesTable convertPoint:[event locationInWindow] fromView:nil];
    NSInteger row = [self.filesTable rowAtPoint:mousePoint];
    NSIndexSet* selectedRows = [self.filesTable selectedRowIndexes];
      if ([selectedRows containsIndex:row] == NO) {
          [self.filesTable selectRowIndexes:selectedRows byExtendingSelection:NO];
    }
    NSLog(@"Show in finder %ld *****",row);
    
    FileInformation *obj = [self.filteredArray objectAtIndex:row];
    self.finderUrl = obj.url;
    NSMenu *theMenu = [self createMenu];
    [NSMenu popUpContextMenu:theMenu withEvent:event forView:self.filesTable];
}

-(NSMenu *)createMenu {
    NSMenu *theMenu = [[NSMenu alloc] initWithTitle:@"Contextual Menu"];
    [theMenu insertItemWithTitle:@"Show in Finder" action:@selector(showInFinderClicked:) keyEquivalent:@"" atIndex:0];
    [theMenu insertItemWithTitle:@"Copy Path" action:@selector(copyPathClicked:) keyEquivalent:@"" atIndex:1];
    [theMenu insertItemWithTitle:@"Details" action:@selector(detailsClicked:) keyEquivalent:@"" atIndex:2];
    return  theMenu;
}

 - (IBAction)showInFinderClicked:(id)sender {
    NSArray *fileURLs = [NSArray arrayWithObjects:[NSURL fileURLWithPath:self.finderUrl], nil];
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:fileURLs];
}
- (IBAction)copyPathClicked:(id)sender {
    NSLog(@"copy path *****");
}
- (IBAction)detailsClicked:(id)sender {
}

@end
