//
//  Salary+CoreDataProperties.h
//  CoreDataByCode
//
//  Created by csip on 16/2/13.
//  Copyright © 2016年 ariel. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Salary.h"

NS_ASSUME_NONNULL_BEGIN

@interface Salary (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *num;
@property (nullable, nonatomic, retain) NSString *wage;

@end

NS_ASSUME_NONNULL_END
