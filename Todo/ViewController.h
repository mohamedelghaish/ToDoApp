//
//  ViewController.h
//  Todo
//
//   Created by Mohamed Kotb Saied Kotb on 22/04/2024.
//

#import <UIKit/UIKit.h>
#import "MyTodoClass.h"
#import "MyProtocol.h"
#import "TodoItemViewController.h"
#import "TodoViewController.h"
#import "InprogressViewController.h"
#import "DoneViewController.h"

@interface ViewController : UIViewController

@property NSMutableArray<NSMutableArray<MyTodoClass*>*>* myArrays;
@property NSMutableArray<NSMutableArray<MyTodoClass*>*>* searchMyArrays;
@property NSMutableArray<MyTodoClass*>* lowPriorityArray;
@property NSMutableArray<MyTodoClass*>* mediumPriorityArray;
@property NSMutableArray<MyTodoClass*>* highPriorityArray;
@property NSMutableArray<MyTodoClass*>* searchLowPriorityArray;
@property NSMutableArray<MyTodoClass*>* searchMediumPriorityArray;
@property NSMutableArray<MyTodoClass*>* searchHighPriorityArray;

@property NSMutableArray<MyTodoClass*>* todoArray;
@property NSMutableArray<MyTodoClass*>* inprogressArray;
@property NSMutableArray<MyTodoClass*>* doneArray;
@property NSMutableArray<MyTodoClass*>* searchTodoArray;
@property NSMutableArray<MyTodoClass*>* searchInprogressArray;
@property NSMutableArray<MyTodoClass*>* searchDoneArray;

@property NSUserDefaults *defaults;

@end


