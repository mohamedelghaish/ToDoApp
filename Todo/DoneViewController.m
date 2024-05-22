//
//  DoneViewController.m
//  Todo
//
//   Created by Mohamed Kotb Saied Kotb on 22/04/2024.
//

#import "DoneViewController.h"

@interface DoneViewController () <UITableViewDelegate, UITableViewDataSource, MyProtocol, UITabBarDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *groupPriorityOutlet;
- (IBAction)groupPriority:(id)sender;
@property bool isGroup;
@end

@implementation DoneViewController

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
    
    [self reloadDoneArrays];
    
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
                return [_doneArrayLowPriority count];
                break;
            case 1:
                return [_doneArrayMediumPriority count];
                break;
            default:
                return [_doneArrayHighPriority count];
        }
        
    } else{
        return [_doneArray count];
    }
    
}
    
    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        
        MyTodoClass *currentItem;
        
        if(_isGroup){
            switch(indexPath.section){
                case 0:
                    currentItem = _doneArrayLowPriority[indexPath.row];
                    break;
                case 1:
                    currentItem = _doneArrayMediumPriority[indexPath.row];
                    break;
                default:
                    currentItem = _doneArrayHighPriority[indexPath.row];
            }
        } else{
            currentItem = _doneArray[indexPath.row];
        }
        
        cell.textLabel.numberOfLines = 0;
        
        cell.textLabel.text = currentItem.title;
        cell.textLabel.text = [NSString stringWithFormat:@"%@\n*Done", currentItem.title];
        
       
        
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
    
    [_doneArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate *date1 = [obj1 date];
        NSDate *date2 = [obj2 date];
        return [date1 compare:date2];
    }];
    
}

-(void) reloadDoneArrays{
    _doneArrayLowPriority = [NSMutableArray new];
    _doneArrayMediumPriority = [NSMutableArray new];
    _doneArrayHighPriority = [NSMutableArray new];
    
    for(MyTodoClass *item in _doneArray){
        switch(item.priority){
            case 0:
                [_doneArrayLowPriority addObject:item];
                break;
                
            case 1:
                [_doneArrayMediumPriority addObject:item];
                break;
                
            default:
                [_doneArrayHighPriority addObject:item];
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
