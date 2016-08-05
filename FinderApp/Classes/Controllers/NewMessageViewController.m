//
//  NewMessageViewController.m
//  Finder_iPhoneApp
//
//  Created by Hema on 27/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "NewMessageViewController.h"
#import "MessagesViewCell.h"
#import "ConferenceService.h"
#import "ContactDataModel.h"
#import "PersonalMessageViewController.h"

@interface NewMessageViewController ()
{
    NSMutableArray *contactDataArray;
    NSArray *searchResultArray;
    BOOL isSearch;
}
@property (weak, nonatomic) IBOutlet UITableView *contactListTableView;
@property (weak, nonatomic) IBOutlet UILabel *noResultFound;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation NewMessageViewController
@synthesize contactListTableView;
@synthesize noResultFound;
@synthesize searchBar;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"Contacts";
    noResultFound.hidden=YES;
    contactDataArray=[[NSMutableArray alloc]init];
    searchResultArray=[[NSArray alloc]init];
    searchBar.enablesReturnKeyAutomatically = NO;
    searchBar.returnKeyType=UIReturnKeyDone;
    [myDelegate showIndicator];
    [self performSelector:@selector(getContactDetails) withObject:nil afterDelay:.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end
#pragma mark - Webservice
- (void)getContactDetails {
    [[ConferenceService sharedManager] getContactDetails:^(id dataArray) {
        [myDelegate stopIndicator];
        contactDataArray=[dataArray mutableCopy];
        if (contactDataArray.count==0) {
            noResultFound.hidden=NO;
            contactListTableView.hidden=YES;
        }
        else {
            noResultFound.hidden=YES;
            contactListTableView.hidden=NO;
            [contactListTableView reloadData];
        }
    }
                                                 failure:^(NSError *error)
     {
         
     }] ;
}
#pragma mark - end
#pragma mark - Table view delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearch) {
         return searchResultArray.count;
    }
    else {
         return contactDataArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = @"newMessageCell";
    MessagesViewCell *contactUser=[contactListTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (contactUser == nil)
    {
        contactUser=[[MessagesViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    ContactDataModel *data;
    [contactUser.messageContainerView addShadow:contactUser.messageContainerView color:[UIColor lightGrayColor]];
    [contactUser.userImageView setCornerRadius:contactUser.userImageView.frame.size.width/2];
    if (isSearch) {
         data=[searchResultArray objectAtIndex:indexPath.row];
    }
    else {
         data=[contactDataArray objectAtIndex:indexPath.row];
    }
    [contactUser displayData:data indexPath:(int)indexPath.row];
    return contactUser;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard * storyboard=storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalMessageViewController *chatView =[storyboard instantiateViewControllerWithIdentifier:@"PersonalMessageViewController"];
    if (isSearch) {
        chatView.otherUserId=[[searchResultArray objectAtIndex:indexPath.row] contactUserId];
        chatView.otherUserName=[[searchResultArray objectAtIndex:indexPath.row] contactName];
    }
    else {
        chatView.otherUserId=[[contactDataArray objectAtIndex:indexPath.row] contactUserId];
        chatView.otherUserName=[[contactDataArray objectAtIndex:indexPath.row] contactName];
    }
    [self.navigationController pushViewController:chatView animated:YES];

}
#pragma mark - end
#pragma mark - Search bar delegates
-(BOOL)searchBar:(UISearchBar *)srchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (text.length<1) {
        noResultFound.hidden=YES;
        searchResultArray = [NSArray arrayWithArray:contactDataArray];
        isSearch = NO;
    }
    NSString *searchKey;
    if([text isEqualToString:@"\n"]){
        searchKey = searchBar.text;
    }
    else if(text.length){
        searchKey = [searchBar.text stringByAppendingString:text];
    }
    else if((searchBar.text.length-1)!=0){
        searchKey = [searchBar.text substringWithRange:NSMakeRange(0, searchBar.text.length-1)];
    }
    else{
        searchKey = @"";
    }
    searchResultArray = nil;
    if (searchKey.length)
    {
       
        isSearch = YES;
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"contactName contains[cd] %@",searchKey];
        NSArray *subPredicates = [NSArray arrayWithObjects:pred1, nil];
        NSPredicate * orPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:subPredicates];
        searchResultArray=[contactDataArray filteredArrayUsingPredicate:orPredicate];
        if (searchResultArray.count==0) {
             noResultFound.hidden=NO;
            noResultFound.text=@"No result found.";
        }
        else {
            noResultFound.hidden=YES;
        }
    }
    else
    {
        searchResultArray = [NSArray arrayWithArray:contactDataArray];
        searchBar.text=@"";
      //  [searchBar resignFirstResponder];
        isSearch = NO;
    }
    [contactListTableView reloadData];
    return YES;
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)srchBar
{
    if ([srchBar.text isEqualToString:@""]) {
        searchResultArray = [contactDataArray mutableCopy];
        //[searchBar resignFirstResponder];
        isSearch = NO;
        [contactListTableView reloadData];
    }
    return  YES;
}

- (void)searchBar:(UISearchBar *)srchBar textDidChange:(NSString *)searchText
{
    if (searchText.length<1)
    {
        noResultFound.hidden=YES;
       // [searchBar resignFirstResponder];
        searchResultArray = [contactDataArray mutableCopy];
        isSearch = NO;
        [contactListTableView reloadData];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)srchBar
{
    [searchBar resignFirstResponder];
}
#pragma mark - end


@end
