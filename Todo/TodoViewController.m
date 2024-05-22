//
//  TodoViewController.m
//  Todo
//
//   Created by Mohamed Kotb Saied Kotb on 22/04/2024.
//

#import "TodoViewController.h"
#import "ViewController.h"

@interface TodoViewController () <UITableViewDelegate, UITableViewDataSource, MyProtocol, UITabBarDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *groupPriorityOutlet;
- (IBAction)groupPriority:(id)sender;
@property bool isGroup;

@end

@implementation TodoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isGroup = NO;
    
    _defaults = [NSUserDefaults standardUserDefaults];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
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
    
    [self reloadTodoInprogressDoneArrays];
    
    [self reloadTodoArrays];
    
    if (_isGroup){
        [_groupPriorityOutlet setTitle:@"Click to group by date" forState:UIControlStateNormal];
    } else{
        [_groupPriorityOutlet setTitle:@"Click to group by priority" forState:UIControlStateNormal];
    }
    
    [_tableview reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_isGroup){
        return 3;
    } else{
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_isGroup){
        
        switch (section){
            case 0:
                return [_todoArrayLowPriority count];
                break;
            case 1:
                return [_todoArrayMediumPriority count];
                break;
            default:
                return [_todoArrayHighPriority count];
        }
        
    } else{
        return [_todoArray count];
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    MyTodoClass *currentItem;
    
    if(_isGroup){
        switch(indexPath.section){
            case 0:
                currentItem = _todoArrayLowPriority[indexPath.row];
                break;
            case 1:
                currentItem = _todoArrayMediumPriority[indexPath.row];
                break;
            default:
                currentItem = _todoArrayHighPriority[indexPath.row];
        }
    } else{
        currentItem = _todoArray[indexPath.row];
    }
    
    
    cell.textLabel.numberOfLines = 0;
    
    cell.textLabel.text = currentItem.title;
    cell.textLabel.text = [NSString stringWithFormat:@"%@\n*Todo", currentItem.title];
    
    
    
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (_isGroup){
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
    } else{
        return @"";
    }
        
    
}

-(void) reloadTodoInprogressDoneArrays{
    
    _todoArray = [NSMutableArray new];
    _inprogressArray = [NSMutableArray new];
    _doneArray = [NSMutableArray new];
    
    for(MyTodoClass *item in _lowPriorityArray){
        switch(item.state){
            case 0:
                [_todoArray addObject:item];
                break;
                
            case 1:
                [_inprogressArray addObject:item];
                break;
                
            default:
                [_doneArray addObject:item];
        }
    }
    for(MyTodoClass *item in _mediumPriorityArray){
        switch(item.state){
            case 0:
                [_todoArray addObject:item];
                break;
                
            case 1:
                [_inprogressArray addObject:item];
                break;
                
            default:
                [_doneArray addObject:item];
        }
    }
    for(MyTodoClass *item in _highPriorityArray){
        switch(item.state){
            case 0:
                [_todoArray addObject:item];
                break;
                
            case 1:
                [_inprogressArray addObject:item];
                break;
                
            default:
                [_doneArray addObject:item];
        }
    }
    
    [_todoArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate *date1 = [obj1 date];
        NSDate *date2 = [obj2 date];
        return [date1 compare:date2];
    }];
    
    
}

-(void) reloadTodoArrays{
    _todoArrayLowPriority = [NSMutableArray new];
    _todoArrayMediumPriority = [NSMutableArray new];
    _todoArrayHighPriority = [NSMutableArray new];
    
    for(MyTodoClass *item in _todoArray){
        switch(item.priority){
            case 0:
                [_todoArrayLowPriority addObject:item];
                break;
                
            case 1:
                [_todoArrayMediumPriority addObject:item];
                break;
                
            default:
                [_todoArrayHighPriority addObject:item];
        }
    }
}



- (IBAction)groupPriority:(id)sender {
    if (_isGroup == YES){
        _isGroup = NO;
        [_groupPriorityOutlet setTitle:@"Click to group by priority" forState:UIControlStateNormal];
    }
    else {
        _isGroup = YES;
        [_groupPriorityOutlet setTitle:@"Click to group by date added" forState:UIControlStateNormal];
    }
    [_tableview reloadData];
}
@end
