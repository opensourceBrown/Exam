//
//  NSManagedObject+ActiveRecord.h
//  KPStore
//
//  Created by He baochen on 11-12-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (ActiveRecord)

+ (NSFetchRequest*)defaultFetchRequest;
+ (NSArray *)executeFetchRequest:(NSFetchRequest *)request error:(NSError **)error;

//查找该类型对象的全部数据
+ (NSArray*)findAllWithError:(NSError **)error;
+ (NSArray*)findAllSortByKey:(NSString*)sortKey
				   ascending:(BOOL)ascending
					   error:(NSError **)error;
+ (NSArray *)findAllOnLimit:(NSUInteger)theLimit
					  error:(NSError **)anError;

//创新一个新对象
+ (id)createNewObject;

+ (void)deleteAllObjects;
+ (void) deleteObjectByID:(NSManagedObjectID*)objectID;
+ (BOOL) deleteAllMatchingPredicate:(NSPredicate *)predicate;
- (void) deleteSelf;
- (void) save;

+ (NSString*)entityName;
+ (void)save;

@end
