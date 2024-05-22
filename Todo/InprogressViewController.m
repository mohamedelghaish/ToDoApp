//
//  InprogressViewController.m
//  Todo
//
//   Created by Mohamed Kotb Saied Kotb on 22/04/2024.
//

#import "InprogressViewController.h"

@interface InprogressViewController () <UITableViewDelegate, UITableViewDataSource, MyProtocol, UITabBarDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *groupPriorityOutlet;
- (IBAction)groupPriority:(id)sender;
@property bool isGroup;
@end

@implementation InprogressViewController

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
    
    [self reloadInprogressArrays];
    
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
                return [_inprogressArrayLowPriority count];
                break;
            case 1:
                return [_inprogressArrayMediumPriority count];
                break;
            default:
                return [_inprogressArrayHighPriority count];
        }
        
    } else{
        return [_inprogressArray count];
    }
}
    
    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        
        MyTodoClass *currentItem;
        
        if(_isGroup){
            switch(indexPath.section){
                case 0:
                    currentItem = _inprogressArrayLowPriority[indexPath.row];
                    break;
                case 1:
                    currentItem = _inprogressArrayMediumPriority[indexPath.row];
                    break;
                default:
                    currentItem = _inprogressArrayHighPriority[indexPath.row];
            }
        } else{
            currentItem = _inprogressArray[indexPath.row];
        }
        
        
        cell.textLabel.numberOfLines = 0;
        
        cell.textLabel.text = currentItem.title;
        cell.textLabel.text = [NSString stringWithFormat:@"%@\n*Inprogress", currentItem.title];
        
       
        
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
    
    [_inprogressArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate *date1 = [obj1 date];
        NSDate *date2 = [obj2 date];
        return [date1 compare:date2];
    }];
    
    
}

-(void) reloadInprogressArrays{
    _inprogressArrayLowPriority = [NSMutableArray new];
    _inprogressArrayMediumPriority = [NSMutableArray new];
    _inprogressArrayHighPriority = [NSMutableArray new];
    
    for(MyTodoClass *item in _inprogressArray){
        switch(item.priority){
            case 0:
                [_inprogressArrayLowPriority addObject:item];
                break;
                
            case 1:
                [_inprogressArrayMediumPriority addObject:item];
                break;
                
            default:
                [_inprogressArrayHighPriority addObject:item];
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
