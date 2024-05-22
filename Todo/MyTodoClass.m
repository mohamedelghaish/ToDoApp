//
//  MyTodoClass.m
//  Todo
//
//   Created by Mohamed Kotb Saied Kotb on 22/04/2024.
//

#import <Foundation/Foundation.h>
#import "MyTodoClass.h"

@implementation MyTodoClass

@synthesize description = _description;

-(instancetype) initWithName: (NSString*) title andDescription: (NSString*) description andPriority: (NSInteger) priority andState: (NSInteger) state andDate: (NSDate*) date andFileName: (NSString*) fileName andReminderDate: (NSDate*) reminderDate{
    if (self = [super init]) {
        _title = title;
        _description = description;
        _priority = priority;
        _date = date;
        _state = state;
        _fileName = fileName;
        _reminderDate = reminderDate;
        }
        return self;
}

+ (BOOL)supportsSecureCoding{
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:_title forKey:@"title"];
    [coder encodeObject:_description forKey:@"description"];
    [coder encodeInteger:(_priority) forKey:@"priority"];
    [coder encodeObject:_date forKey:@"date"];
    [coder encodeInteger:_state forKey:@"state"];
    [coder encodeObject:_fileName forKey:@"fileName"];
    [coder encodeObject:_reminderDate forKey:@"reminderDate"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        _title = [coder decodeObjectOfClass:[NSString class] forKey:@"title"];
        _description = [coder decodeObjectOfClass:[NSString class] forKey:@"description"];
        _priority = [coder decodeIntegerForKey:@"priority"];
        _date = [coder decodeObjectOfClass:[NSString class] forKey:@"date"];
        _state = [coder decodeIntegerForKey:@"state"];
        _fileName = [coder decodeObjectForKey:@"fileName"];
        _reminderDate = [coder decodeObjectOfClass:[NSString class] forKey:@"reminderDate"];
        }
        return self;
}

@end
