// Copyright (c) 2013 Mutual Mobile (http://mutualmobile.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "MMExampleLeftSideDrawerViewController.h"
#import "MMTableViewCell.h"
#import "ListViewController.h"
#import "SectionModel.h"

@interface MMExampleLeftSideDrawerViewController ()

@end



@implementation MMExampleLeftSideDrawerViewController

@synthesize sectionsArray;

- (id)init{
    self = [super init];
    if (self) {
        
        SectionModel *section1 = [SectionModel new];
        [section1 setTitle:@"Lista"];
        [section1 setClassString:@"ListViewController"];

        SectionModel *section2 = [SectionModel new];
        [section2 setTitle:@"Favoritos"];
        [section2 setClassString:@"ListViewController"];
        
        self.sectionsArray = [NSArray arrayWithObjects:section1, section2, nil];
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"Left will appear");
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"Left did appear");
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"Left will disappear");
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"Left did disappear");
}

/*
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if(section == MMDrawerSectionDrawerWidth)
        return @"Left Drawer Width";
    else
        return [super tableView:tableView titleForHeaderInSection:section];
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [sectionsArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if(indexPath.section == MMDrawerSectionDrawerWidth){
        
        CGFloat width = [self.drawerWidths[indexPath.row] intValue];
        CGFloat drawerWidth = self.mm_drawerController.maximumLeftDrawerWidth;
        if(drawerWidth == width){
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        else{
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
    
    [cell.textLabel setText:[[self.sectionsArray objectAtIndex:indexPath.row] title]];
    
    return cell;
    
    /*
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
        
        CGFloat width = [self.drawerWidths[indexPath.row] intValue];
        CGFloat drawerWidth = self.mm_drawerController.maximumLeftDrawerWidth;
        if(drawerWidth == width){
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        else{
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    
        [cell.textLabel setText:[self.sectionsArray objectAtIndex:indexPath.row]];
    
    return cell;
    */
    /*
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.section == MMDrawerSectionDrawerWidth){

        CGFloat width = [self.drawerWidths[indexPath.row] intValue];
        CGFloat drawerWidth = self.mm_drawerController.maximumLeftDrawerWidth;
        if(drawerWidth == width){
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        else{
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        [cell.textLabel setText:[NSString stringWithFormat:@"Width %d",[self.drawerWidths[indexPath.row] intValue]]];
    }
    return cell;
     */
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *sectionString = [[self.sectionsArray objectAtIndex:[indexPath row]] classString];
    
    Class sectionClass =  NSClassFromString(sectionString);
    
    ListViewController *lViewController = [[sectionClass alloc] initWithNibName:sectionString bundle:nil];
    
    UINavigationController *newViewController = [[UINavigationController alloc] initWithRootViewController:lViewController];
    
    [self.mm_drawerController setCenterViewController:newViewController withCloseAnimation:TRUE completion:nil];

    /*
    if(indexPath.section == MMDrawerSectionDrawerWidth){
        
        [self.mm_drawerController setCenterViewController:newViewController withCloseAnimation:TRUE completion:nil];

    }
    else {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
     */
}

@end
