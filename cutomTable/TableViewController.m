//
//  TableViewController.m
//  cutomTable
//
//  Created by user148840 on 2/5/19.
//  Copyright © 2019 user148840. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"


@interface TableViewController ()

@end

@implementation TableViewController{
    //last add
    
}
@synthesize title1,year1,poster;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // creating search controller
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    [self.searchController.searchBar sizeToFit];
    [self.searchController.searchBar setScopeButtonTitles:@[@"Movie",@"Year"]];
    
    //adding objects to array
    
    movies = [ NSMutableArray arrayWithObjects:@"Dhoom",@"DedhIshquiya",@"Happy New Year",@"Luck By Chance",@"Vicky Donor", nil];
    year = [ NSMutableArray arrayWithObjects:@"2000",@"2013",@"2014",@"2010",@"2012", nil];
    imgs = [ NSMutableArray arrayWithObjects:@"Dhoom_poster.jpg",@"DedhIshquiya.jpg",@"HappyNewYear_Poster.jpg",@"LuckByChance_Poster.jpg", @"VickyDonor_Poster.jpg", nil];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.isActive)
    {
        return [searchResults count];
    }
    else
    {
        return [movies count];
    }
}
///added by chetan sir this function set table height constant while searchbar is active

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 124.5f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"M";
    TableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    // this nspredicate used to search in array
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",[searchResults objectAtIndex:indexPath.row]];
    
    if (self.searchController.isActive)
    {
        if(counter==0)  // counter check which search bar scope button is active
        {
            // index is a varianble which store filted search result index
            index = [movies indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
                return [resultPredicate evaluateWithObject:obj];
            }];
          
        cell.lblTitle.text  = searchResults[indexPath.row];
        cell.imgPoster.image = [UIImage imageNamed:[imgs objectAtIndex:index]];
        cell.lblYear.text = [year objectAtIndex:index];
        }
        else {
            
            index = [year indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
                return [resultPredicate evaluateWithObject:obj];
            }];
            cell.lblYear.text = searchResults[indexPath.row];
            cell.lblTitle.text  =[movies objectAtIndex:index];
            cell.imgPoster.image = [UIImage imageNamed:[imgs objectAtIndex:index]];
        }
    }
    else{
        
        cell.lblTitle.text  = [movies objectAtIndex:indexPath.row];
        cell.lblYear.text = [year objectAtIndex:indexPath.row];
        cell.imgPoster.image = [UIImage imageNamed:[imgs objectAtIndex:indexPath.row]];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell1 = (TableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    UILabel *lblValue =cell1.lblTitle;
    
    //creating alert
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Row Selected"
                                 message:lblValue.text
                                 preferredStyle:UIAlertControllerStyleAlert  ];
    
    //creating cancel button
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Cancel"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];
    
    
    //Add your buttons to alert controller
    [alert addAction:noButton];
    
    // Display Alert Message
    
    [self presentViewController:alert animated:YES completion:nil];
    
    cell1.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
  //this function used to delete table row

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [movies removeObjectAtIndex:indexPath.row];
    [year removeObjectAtIndex:indexPath.row];
    [imgs removeObjectAtIndex:indexPath.row];
    
    [tableView reloadData];
}

 // this function update values after search value

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    
    if (!searchString.length)
    {
        if(counter==0)
            //storing values in search result according to scope button
        searchResults = [[NSMutableArray alloc] initWithArray:movies];
        else
        searchResults = [[NSMutableArray alloc] initWithArray:year];
        
        [self.tableView reloadData]; //reload tableview
        
        return;
    }

   // chek this fuction
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchString];
    
    // checking which scope button is active
    if (searchController.searchBar.selectedScopeButtonIndex==0){
        searchResults = [movies filteredArrayUsingPredicate:resultPredicate];
        counter=0;
    }
    else{
        searchResults = [year filteredArrayUsingPredicate:resultPredicate];
        counter=1;
    }
    [self.tableView reloadData];
}

@end
