//
//  TodoItemViewController.m
//  Todo
//
//   Created by Mohamed Kotb Saied Kotb on 22/04/2024.
//

#import "TodoItemViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface TodoItemViewController () <UIDocumentPickerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *myTitle;
@property (weak, nonatomic) IBOutlet UITextView *myDescription;
@property (weak, nonatomic) IBOutlet UISegmentedControl *myPriority;
@property (weak, nonatomic) IBOutlet UIDatePicker *myDate;
- (IBAction)addTodo:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *myState;
- (IBAction)attachFile:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *attachFileOutlet;
@property (weak, nonatomic) IBOutlet UIDatePicker *myReminderDate;

@end

@implementation TodoItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
    }];
    
    _myDescription.layer.borderWidth = 1;
    
    if (_isEditing){
        _myTitle.text = _editedTodoItem.title;
        _myDescription.text = _editedTodoItem.description;
        _myDate.date = _editedTodoItem.date;
        _myPriority.selectedSegmentIndex = _editedTodoItem.priority;
        _myState.selectedSegmentIndex = _editedTodoItem.state;
        [_attachFileOutlet setTitle:_editedTodoItem.fileName forState:UIControlStateNormal] ;
        _myReminderDate.date = _editedTodoItem.reminderDate;
    }
    
}


- (IBAction)addTodo:(id)sender {
    
    if ([_myTitle.text isEqualToString:@""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Task must have a name"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else{
        MyTodoClass *todoItem = [[MyTodoClass alloc] initWithName:self.myTitle.text andDescription:self.myDescription.text
                                                      andPriority:self.myPriority.selectedSegmentIndex
                                                         andState: self.myState.selectedSegmentIndex
                                                          andDate:self.myDate.date andFileName:self.attachFileOutlet.currentTitle
                                                  andReminderDate:_myReminderDate.date];
        
        if (_isEditing){
            
            _myReminderDate.enabled = NO;
            
            if (_stateBefore == 1 && todoItem.state == 0){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"You can't change state of an item from Inprogress to Todo"
                                                                               message:nil
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok"
                                                                       style:UIAlertActionStyleCancel
                                                                     handler:^(UIAlertAction * _Nonnull action) {
                }];
                
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            } else if ((_stateBefore == 2 && todoItem.state == 1) || (_stateBefore == 2 && todoItem.state == 0)){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"You can't change state of an item from Done to any other state"
                                                                               message:nil
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok"
                                                                       style:UIAlertActionStyleCancel
                                                                     handler:^(UIAlertAction * _Nonnull action) {
                }];
                
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            } else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure?"
                                                                               message:nil
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Continue"
                                                                         style:UIAlertActionStyleDefault
                                                                       handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self.refToFirstScreen didEditItem:todoItem andSection:self->_indexPathSection andIndex:self->_indexPathRow andPriorityBefore:self->_priortyBefore andPriorityAfter:todoItem.priority];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                       style:UIAlertActionStyleCancel
                                                                     handler:^(UIAlertAction * _Nonnull action) {
                }];
                
                [alert addAction:continueAction];
                [alert addAction:cancelAction];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
            
        } else{
            [self.refToFirstScreen didCreateNewItem:todoItem];
            
            [self setReminder:todoItem.title atDate:todoItem.reminderDate];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
    
}


- (IBAction)attachFile:(id)sender {
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.data"] inMode:UIDocumentPickerModeImport];
    documentPicker.delegate = self;
    [self presentViewController:documentPicker animated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    NSURL *selectedFileURL = urls.firstObject;
    NSString *fileName = [selectedFileURL lastPathComponent];
    [self.attachFileOutlet setTitle:fileName forState:UIControlStateNormal];
}

- (void)setReminder:(NSString *)reminderText atDate:(NSDate *)date {
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
    }];
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Reminder";
    content.body = reminderText;
    content.sound = [UNNotificationSound defaultSound];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond)
                                               fromDate:date];
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components
                                                                                                      repeats:NO];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"reminder"
                                                                          content:content
                                                                          trigger:trigger];
    
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
}

@end
