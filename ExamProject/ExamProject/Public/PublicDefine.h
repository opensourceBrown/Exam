//
//  PublicDefine.h
//  ExamProject
//
//  Created by magic on 13-7-20.
//  Copyright (c) 2013年 Magic Song. All rights reserved.
//

#define SCREEN_WIDTH    320
#define SCREEN_HEIGHT	([UIScreen mainScreen].bounds.size.height)      //屏幕高度

#define KEYCHAIN_IDENTIFIER     @"exam_proj_keychain_identifier"
#define KEYCHAIN_USRNAME        @"kcUserName"
#define KEYCHAIN_PWD            @"kcPassword"

#define NOT_FIRST_RUN           @"notfirstRun"      //首次启动(首次肯定为NO，以后设置为YES)
#define AUTO_LOGIN              @"isAutoLogin"      //自动登录开关

//brown...............................
#define LOCAL_PAPERFILE_URL     @"paperList.json"
#define LOCAL_EXAMFILE_URL      @"examList.json"
#define NET_PAPERDATA_URL       @"http://www.kanbook.cn/Papr/getpaprlist"
//#define NET_PAPERDATA_URL         @"http://down.xiaotu.net/paperList0.json"
#define NET_EXAMDATA_URL        @"http://www.kanbook.cn/exam/getexamlist"
#define NET_SUBMIT_EXAM_DATA    @"http://www.kanbook.cn/score/addscore"



//通知
#define NOTIFICATION_EXAM_DOWNLOAD_FINISH       @"downloadExamListFinish"
#define NOTIFICATION_PAPERS_DOWNLOAD_FINISH     @"papersDownloadedFinish"
#define NOTIFICATION_SOME_PAPER_DOWNLOAD_FINISH @"specialPaperDownloadedFinish"
#define NOTIFICATION_DOWNLOAD_FAILURE           @"downloadFailure"
#define NOTIFICATION_SUBMIT_EXAM_DATA_SUCCESS   @"submitExamDataSuccess"
#define NOTIFICATION_SUBMIT_EXAM_DATA_FAILURE   @"submitExamDataFailure"


typedef enum{
    kDisplayTopicType_Default=0,            //考试试题
    kDisplayTopicType_Wrong,                //错题记录
    kDisplayTopicType_Collected,            //收藏试题
    kDisplayTopicType_Record,               //答题记录
}DisplayTopicType;
