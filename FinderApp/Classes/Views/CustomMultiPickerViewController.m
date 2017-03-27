//
//  CustomMultiPickerViewController.m
//  CustomMultipickerProject
//
//  Created by Ranosys on 22/02/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

#import "CustomMultiPickerViewController.h"

@interface CustomMultiPickerViewController ()

@property (strong, nonatomic) IBOutlet UITableView *pickerTableView;
@property (strong, nonatomic) IBOutlet UIToolbar *pickerToolBar;
@end

@implementation CustomMultiPickerViewController

@synthesize pickerDicData, pickerArrayData;
@synthesize viewHeight,pickertag;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self layoutViewObjects];
    
    [pickerArrayData insertObject:@"All" atIndex:0];
    bool flag=NO;
    for (int i=1; i<[pickerArrayData count]-1; i++) {
        if (![[pickerDicData objectForKey:[pickerArrayData objectAtIndex:i]] boolValue]) {
            
            flag=YES;
            break;
        }
    }
    
    if (flag) {
        [pickerDicData setObject:[NSNumber numberWithBool:NO] forKey:[pickerArrayData objectAtIndex:0]];
    }
    else {
        [pickerDicData setObject:[NSNumber numberWithBool:YES] forKey:[pickerArrayData objectAtIndex:0]];
    }
    
    [self.pickerTableView reloadData];
}

- (void)layoutViewObjects {
    
    _mainview.translatesAutoresizingMaskIntoConstraints=YES;
    _mainview.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, viewHeight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return pickerArrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    NSString *simpleTableIdentifier = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
  
    UIImageView *checkImageView=(UIImageView *)[cell viewWithTag:1];
    UILabel *label=(UILabel *)[cell viewWithTag:2];
    label.text=[pickerArrayData objectAtIndex:indexPath.row];
    if ([[pickerDicData objectForKey:[pickerArrayData objectAtIndex:indexPath.row]] boolValue]) {
        checkImageView.image=[UIImage imageNamed:@"check_mark"];
    }
    else {
    
        checkImageView.image=[UIImage imageNamed:@""];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        if (![[pickerDicData objectForKey:[pickerArrayData objectAtIndex:0]] boolValue]) {
        for (int i=0; i<[pickerArrayData count]-1; i++) {
            [pickerDicData setObject:[NSNumber numberWithBool:YES] forKey:[pickerArrayData objectAtIndex:i]];
        }
        [pickerDicData setObject:[NSNumber numberWithBool:NO] forKey:[pickerArrayData objectAtIndex:[pickerArrayData count]-1]];
        }
    }
    else if (indexPath.row==[pickerArrayData count]-1) {
        
        if ([[pickerDicData objectForKey:[pickerArrayData objectAtIndex:[pickerArrayData count]-1]] boolValue]) {
            
            [pickerDicData setObject:[NSNumber numberWithBool:NO] forKey:[pickerArrayData objectAtIndex:[pickerArrayData count]-1]];
        }
        else {
            if ([[pickerDicData objectForKey:[pickerArrayData objectAtIndex:0]] boolValue]) {
                
                for (int i=0; i<[pickerArrayData count]-1; i++) {
                    [pickerDicData setObject:[NSNumber numberWithBool:NO] forKey:[pickerArrayData objectAtIndex:i]];
                }
            }
            [pickerDicData setObject:[NSNumber numberWithBool:YES] forKey:[pickerArrayData objectAtIndex:[pickerArrayData count]-1]];
        }
    }
    else {
    
        if ([[pickerDicData objectForKey:[pickerArrayData objectAtIndex:indexPath.row]] boolValue]) {
            [pickerDicData setObject:[NSNumber numberWithBool:NO] forKey:[pickerArrayData objectAtIndex:indexPath.row]];
            [pickerDicData setObject:[NSNumber numberWithBool:NO] forKey:[pickerArrayData objectAtIndex:0]];
        }
        else {
            [pickerDicData setObject:[NSNumber numberWithBool:YES] forKey:[pickerArrayData objectAtIndex:indexPath.row]];
            bool flag=NO;
            for (int i=1; i<[pickerArrayData count]-1; i++) {
                if (![[pickerDicData objectForKey:[pickerArrayData objectAtIndex:i]] boolValue]) {
                    
                    flag=YES;
                }
            }
            if (!flag) {
                if ([[pickerDicData objectForKey:[pickerArrayData objectAtIndex:[pickerArrayData count]-1]] boolValue]) {
                    
                    [pickerDicData setObject:[NSNumber numberWithBool:NO] forKey:[pickerArrayData objectAtIndex:[pickerArrayData count]-1]];
                }
                [pickerDicData setObject:[NSNumber numberWithBool:YES] forKey:[pickerArrayData objectAtIndex:0]];
            }
        }
    }
    [self.pickerTableView reloadData];
}
#pragma mark - end


- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    [_delegate cancelDelegateMethod];
}

- (IBAction)doneAction:(UIBarButtonItem *)sender {
    
    NSMutableArray *selectedData=[NSMutableArray new];
    if ([[pickerDicData objectForKey:[pickerArrayData objectAtIndex:0]] boolValue]) {
        
        for (int i=1; i<[pickerArrayData count]-1; i++) {
            [selectedData addObject:[pickerArrayData objectAtIndex:i]];
        }
        [_delegate selectionDelegateAction:pickerDicData isOtherTrue:false selectedData:selectedData tag:pickertag];
    }
    else {
    
        for (int i=1; i<[pickerArrayData count]-1; i++) {
            
            if ([[pickerDicData objectForKey:[pickerArrayData objectAtIndex:i]] boolValue]) {
                
                [selectedData addObject:[pickerArrayData objectAtIndex:i]];
            }
        }
        
         if ([[pickerDicData objectForKey:[pickerArrayData objectAtIndex:[pickerArrayData count]-1]] boolValue]) {
              [_delegate selectionDelegateAction:pickerDicData isOtherTrue:true selectedData:selectedData tag:pickertag];
         }
         else {
             [_delegate selectionDelegateAction:pickerDicData isOtherTrue:false selectedData:selectedData tag:pickertag];
         }
    }
}
@end
