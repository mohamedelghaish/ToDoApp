//
//  MyProtocol.h
//  Todo
//
//   Created by Mohamed Kotb Saied Kotb on 22/04/2024.
//

#ifndef MyProtocol_h
#define MyProtocol_h

#import "MyTodoClass.h"

@protocol MyProtocol <NSObject>

-(void) didCreateNewItem : (MyTodoClass*) newItem ;
-(void) didEditItem : (MyTodoClass*) newItem andSection: (NSInteger) section andIndex: (NSInteger) index andPriorityBefore: (NSInteger) priorityBefore andPriorityAfter: (NSInteger) priorityAfter ;

@end

#endif /* MyProtocol_h */
