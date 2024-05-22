//
//  ViewController.m
//  Todo
//
//   Created by Mohamed Kotb Saied Kotb on 22/04/2024.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, MyProtocol, UITabBarDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)btnAddMain:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]} forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]} forState:UIControlStateSelected];
    
    
    _searchBar.delegate = self;
    
    _defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *lowPriorityData = [_defaults objectForKey:@"_lowPriorityArray"];
    NSData *mediumPriorityData = [_defaults objectForKey:@"_mediumPriorityArray"];
    NSData *highPriorityData = [_defaults objectForKey:@"_highPriorityArray"];
    
    if (lowPriorityData != nil){
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:lowPriorityData];
        if(array != nil){
            _lowPriorityArray = [[NSMutableArray alloc] initWithArray:array];
        } else{
            _lowPriorityArray = [NSMutableArray new];
        }
    } else{
        _lowPriorityArray = [NSMutableArray new];
    }
    
    if (mediumPriorityData != nil){
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:mediumPriorityData];
        if(array != nil){
            _mediumPriorityArray = [[NSMutableArray alloc] initWithArray:array];
        } else{
            _mediumPriorityArray = [NSMutableArray new];
        }
    } else{
        _mediumPriorityArray = [NSMutableArray new];
    }
    
    if (highPriorityData != nil){
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:highPriorityData];
        if(array != nil){
            _highPriorityArray = [[NSMutableArray alloc] initWithArray:array];
        } else{
            _highPriorityArray = [NSMutableArray new];
        }
    } else{
        _highPriorityArray = [NSMutableArray new];
    }
    
    
    
    _searchLowPriorityArray = [_lowPriorityArray mutableCopy];
    _searchMediumPriorityArray = [_mediumPriorityArray mutableCopy];
    _searchHighPriorityArray = [_highPriorityArray mutableCopy];
    
    _myArrays = [NSMutableArray arrayWithObjects:_lowPriorityArray, _mediumPriorityArray, _highPriorityArray, nil];
    _searchMyArrays = [NSMutableArray arrayWithObjects:_searchLowPriorityArray, _searchMediumPriorityArray, _searchHighPriorityArray, nil];
    
    [self reloadTodoInprogressDoneArrays];
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section){
        case 0:
            return [_searchLowPriorityArray count];
            break;
        case 1:
            return [_searchMediumPriorityArray count];
            break;
        default:
            return [_searchHighPriorityArray count];
            
            
            
            
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    cell.textLabel.numberOfLines = 0;
    
    
    NSArray *sectionArray = _searchMyArrays[indexPath.section];
    MyTodoClass *currentItem = sectionArray[indexPath.row];
    cell.textLabel.text = currentItem.title;
    
    
    switch(currentItem.state){
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"%@\n*Todo", currentItem.title];
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"%@\n*In Progress", currentItem.title];
            break;
        default:
            cell.textLabel.text = [NSString stringWithFormat:@"%@\n*Done", currentItem.title];
    }
    
    switch(currentItem.priority){
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"low"];
            break;
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"medium"];
            break;
        default:
            cell.imageView.image = [UIImage imageNamed:@"high"];
    }
    
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TodoItemViewController *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"detailsID"];
    tvc.refToFirstScreen = self;
    
    NSArray *section = _searchMyArrays[indexPath.section];
    MyTodoClass *currentItem = section[indexPath.row];
    tvc.editedTodoItem = currentItem;
    tvc.priortyBefore = currentItem.priority;
    tvc.stateBefore = currentItem.state;
    
    
    
    
    
    tvc.isEditing = YES;
    tvc.indexPathSection = indexPath.section;
    tvc.indexPathRow = indexPath.row;
    
    
    [self presentViewController:tvc animated:YES completion:nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section){
        case 0:
            return @"Low Priority";
            break;
        case 1:
            return @"Medium Priority";
            break;
        default:
            return @"High Priority";
    }
    
}

- (void)didCreateNewItem:(MyTodoClass *)newItem{
    
    
    switch (newItem.priority){
        case 0:
            [_lowPriorityArray addObject:newItem];
            _searchLowPriorityArray = [_lowPriorityArray mutableCopy];
            break;
        case 1:
            [_mediumPriorityArray addObject:newItem];
            _searchMediumPriorityArray = [_mediumPriorityArray mutableCopy];
            break;
        default:
            [_highPriorityArray addObject:newItem];
            _searchHighPriorityArray = [_highPriorityArray mutableCopy];
    }
    
    NSData *dataLow = [NSKeyedArchiver archivedDataWithRootObject:_lowPriorityArray requiringSecureCoding:YES error:nil];
    [_defaults setObject:dataLow forKey:@"_lowPriorityArray"];
    NSData *dataMedium = [NSKeyedArchiver archivedDataWithRootObject:_mediumPriorityArray requiringSecureCoding:YES error:nil];
    [_defaults setObject:dataMedium forKey:@"_mediumPriorityArray"];
    NSData *dataHigh = [NSKeyedArchiver archivedDataWithRootObject:_highPriorityArray requiringSecureCoding:YES error:nil];
    [_defaults setObject:dataHigh forKey:@"_highPriorityArray"];
    
    [self reloadTodoInprogressDoneArrays];
    
    _searchMyArrays = [NSMutableArray arrayWithObjects:_searchLowPriorityArray,_searchMediumPriorityArray,_searchHighPriorityArray, nil];
    [_tableview reloadData];
    
}

- (void)didEditItem:(MyTodoClass *)newItem andSection:(NSInteger)section andIndex:(NSInteger)index andPriorityBefore:(NSInteger)priorityBefore andPriorityAfter:(NSInteger)priorityAfter{
    
    switch(priorityBefore){
        case 0:
            [_lowPriorityArray removeObjectAtIndex:index];
            [_searchLowPriorityArray removeObjectAtIndex:index];
            break;
        case 1:
            [_mediumPriorityArray removeObjectAtIndex:index];
            [_searchMediumPriorityArray removeObjectAtIndex:index];
            break;
        default:
            [_highPriorityArray removeObjectAtIndex:index];
            [_searchHighPriorityArray removeObjectAtIndex:index];
    }
    
    
    
    switch(priorityAfter){
        case 0:
            [_lowPriorityArray addObject:newItem];
            _searchLowPriorityArray = [_lowPriorityArray mutableCopy];
            break;
        case 1:
            [_mediumPriorityArray addObject:newItem];
            _searchMediumPriorityArray = [_mediumPriorityArray mutableCopy];
            break;
        default:
            [_highPriorityArray addObject:newItem];
            _searchHighPriorityArray = [_highPriorityArray mutableCopy];
    }
    
    NSData *dataLow = [NSKeyedArchiver archivedDataWithRootObject:_lowPriorityArray requiringSecureCoding:YES error:nil];
    [_defaults setObject:dataLow forKey:@"_lowPriorityArray"];
    NSData *dataMedium = [NSKeyedArchiver archivedDataWithRootObject:_mediumPriorityArray requiringSecureCoding:YES error:nil];
    [_defaults setObject:dataMedium forKey:@"_mediumPriorityArray"];
    NSData *dataHigh = [NSKeyedArchiver archivedDataWithRootObject:_highPriorityArray requiringSecureCoding:YES error:nil];
    [_defaults setObject:dataHigh forKey:@"_highPriorityArray"];
    
    [self reloadTodoInprogressDoneArrays];
    
    _searchMyArrays = [NSMutableArray arrayWithObjects:_searchLowPriorityArray,_searchMediumPriorityArray,_searchHighPriorityArray, nil];
    [_tableview reloadData];
}


- (IBAction)btnAddMain:(id)sender {
    TodoItemViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"detailsID"];
    svc.refToFirstScreen = self;
    [self presentViewController:svc animated:YES completion:nil];
}

-(void) reloadTodoInprogressDoneArrays{
    
    _searchTodoArray = [NSMutableArray new];
    _searchInprogressArray = [NSMutableArray new];
    _searchDoneArray = [NSMutableArray new];
    
    for(MyTodoClass *item in _searchLowPriorityArray){
        switch(item.state){
            case 0:
                [_searchTodoArray addObject:item];
                break;
                
            case 1:
                [_searchInprogressArray addObject:item];
                break;
                
            default:
                [_searchDoneArray addObject:item];
        }
    }
    for(MyTodoClass *item in _searchMediumPriorityArray){
        switch(item.state){
            case 0:
                [_searchTodoArray addObject:item];
                break;
                
            case 1:
                [_searchInprogressArray addObject:item];
                break;
                
            default:
                [_searchDoneArray addObject:item];
        }
    }
    for(MyTodoClass *item in _searchHighPriorityArray){
        switch(item.state){
            case 0:
                [_searchTodoArray addObject:item];
                break;
                
            case 1:
                [_searchInprogressArray addObject:item];
                break;
                
            default:
                [_searchDoneArray addObject:item];
        }
    }
    _todoArray = [_searchTodoArray mutableCopy];
    _inprogressArray = [_searchInprogressArray mutableCopy];
    _doneArray = [_searchDoneArray mutableCopy];
    
    
}

-(void) reloadLowMediumHigh{
    
    _searchLowPriorityArray = [NSMutableArray new];
    _searchMediumPriorityArray = [NSMutableArray new];
    _searchHighPriorityArray = [NSMutableArray new];
    
    for(MyTodoClass *item in _searchTodoArray){
        switch(item.priority){
            case 0:
                [_searchLowPriorityArray addObject:item];
                break;
                
            case 1:
                [_searchMediumPriorityArray addObject:item];
                break;
                
            default:
                [_searchHighPriorityArray addObject:item];
        }
    }
    for(MyTodoClass *item in _searchInprogressArray){
        switch(item.state){
            case 0:
                [_searchLowPriorityArray addObject:item];
                break;
                
            case 1:
                [_searchMediumPriorityArray addObject:item];
                break;
                
            default:
                [_searchHighPriorityArray addObject:item];
        }
    }
    for(MyTodoClass *item in _searchDoneArray){
        switch(item.state){
            case 0:
                [_searchLowPriorityArray addObject:item];
                break;
                
            case 1:
                [_searchMediumPriorityArray addObject:item];
                break;
                
            default:
                [_searchHighPriorityArray addObject:item];
        }
    }
    _lowPriorityArray = [_searchLowPriorityArray mutableCopy];
    _mediumPriorityArray = [_searchMediumPriorityArray mutableCopy];
    _highPriorityArray = [_searchHighPriorityArray mutableCopy];
    
    NSData *dataLow = [NSKeyedArchiver archivedDataWithRootObject:_lowPriorityArray requiringSecureCoding:YES error:nil];
    [_defaults setObject:dataLow forKey:@"_lowPriorityArray"];
    NSData *dataMedium = [NSKeyedArchiver archivedDataWithRootObject:_mediumPriorityArray requiringSecureCoding:YES error:nil];
    [_defaults setObject:dataMedium forKey:@"_mediumPriorityArray"];
    NSData *dataHigh = [NSKeyedArchiver archivedDataWithRootObject:_highPriorityArray requiringSecureCoding:YES error:nil];
    [_defaults setObject:dataHigh forKey:@"_highPriorityArray"];
    
    
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        NSArray *section = self->_searchMyArrays[indexPath.section];
        MyTodoClass *currentItem = section[indexPath.row];
        switch(indexPath.section){
            case 0:
                [self->_searchLowPriorityArray removeObject:currentItem];
                [self->_lowPriorityArray removeObject:currentItem];
                break;
            case 1:
                [self->_searchMediumPriorityArray removeObject:currentItem];
                [self->_mediumPriorityArray removeObject:currentItem];
                break;
            default:
                [self->_searchHighPriorityArray removeObject:currentItem];
                [self->_highPriorityArray removeObject:currentItem];
        }
        [self reloadTodoInprogressDoneArrays];
        
        [self reloadLowMediumHigh];
        
        [tableView reloadData];
        
        completionHandler(YES);
    }];
    
    deleteAction.backgroundColor = [UIColor redColor];
    
    UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    
    return configuration;
    
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    _searchLowPriorityArray = [_lowPriorityArray mutableCopy];
    _searchMediumPriorityArray = [_mediumPriorityArray mutableCopy];
    _searchHighPriorityArray = [_highPriorityArray mutableCopy];
    
    _searchTodoArray = [_todoArray mutableCopy];
    _searchInprogressArray = [_inprogressArray mutableCopy];
    _searchDoneArray = [_doneArray mutableCopy];
    
    if (searchText.length > 0) {
        NSMutableArray *filteredLowPriorityArray = [[NSMutableArray alloc] init];
        for (MyTodoClass *todoItem in self.lowPriorityArray) {
            if ([todoItem.title containsString:searchText]) {
                [filteredLowPriorityArray addObject:todoItem];
            }
        }
        
        NSMutableArray *filteredMediumPriorityArray = [[NSMutableArray alloc] init];
        for (MyTodoClass *todoItem in self.mediumPriorityArray) {
            if ([todoItem.title containsString:searchText]) {
                [filteredMediumPriorityArray addObject:todoItem];
            }
        }
        
        NSMutableArray *filteredHighPriorityArray = [[NSMutableArray alloc] init];
        for (MyTodoClass *todoItem in self.highPriorityArray) {
            if ([todoItem.title containsString:searchText]) {
                [filteredHighPriorityArray addObject:todoItem];
            }
        }
        
        NSMutableArray *filteredtodoArray = [[NSMutableArray alloc] init];
        for (MyTodoClass *todoItem in self.todoArray) {
            if ([todoItem.title containsString:searchText]) {
                [filteredtodoArray addObject:todoItem];
            }
        }
        
        NSMutableArray *filteredInprogressArray = [[NSMutableArray alloc] init];
        for (MyTodoClass *todoItem in self.inprogressArray) {
            if ([todoItem.title containsString:searchText]) {
                [filteredInprogressArray addObject:todoItem];
            }
        }
        
        NSMutableArray *filteredDoneArray = [[NSMutableArray alloc] init];
        for (MyTodoClass *todoItem in self.doneArray) {
            if ([todoItem.title containsString:searchText]) {
                [filteredDoneArray addObject:todoItem];
            }
        }
        
        self.searchLowPriorityArray = [filteredLowPriorityArray mutableCopy];
        self.searchMediumPriorityArray = [filteredMediumPriorityArray mutableCopy];
        self.searchHighPriorityArray = [filteredHighPriorityArray mutableCopy];
        
    }
    else {
        _searchLowPriorityArray = [_lowPriorityArray mutableCopy];
        _searchMediumPriorityArray = [_mediumPriorityArray mutableCopy];
        _searchHighPriorityArray = [_highPriorityArray mutableCopy];
        
        _searchTodoArray = [_todoArray mutableCopy];
        _searchInprogressArray = [_inprogressArray mutableCopy];
        _searchDoneArray = [_doneArray mutableCopy];
    }
    
    _searchMyArrays = [NSMutableArray arrayWithObjects:_searchLowPriorityArray,_searchMediumPriorityArray,_searchHighPriorityArray, nil];
    
    [self.tableview reloadData];
}

@end





